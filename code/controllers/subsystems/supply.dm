SUBSYSTEM_DEF(supply)
	name = "Supply"
	wait = 20 SECONDS
	priority = SS_PRIORITY_SUPPLY
	//Initializes at default time
	flags = SS_NO_TICK_CHECK

	//supply points
	var/points = 50
	var/points_per_process = 1
	var/point_sources = list()

	var/price_markup =        1.15
	var/crate_return_rebate = 0.9
	var/slip_return_rebate =  0.15
	var/goods_sale_modifier = 0.75
	var/list/saleable_materials = list(/obj/item/stack/material)

	//control
	var/ordernum
	var/list/shoppinglist = list()
	var/list/requestlist = list()
	var/list/donelist = list()
	var/list/master_supply_list = list()

	//shuttle movement
	var/movetime = 1200
	var/datum/shuttle/autodock/ferry/supply/shuttle
	var/list/point_source_descriptions = list(
		"goods" = "From the sale of goods",
		"time" = "Base station supply",
		"manifest" = "From exported manifests",
		"crate" = "From exported crates",
		"data" =  "From uploaded survey data",
		"total" = "Total"
	)

/datum/controller/subsystem/supply/Initialize()
	. = ..()
	ordernum = rand(1,9000)

	//Build master supply list
	var/decl/hierarchy/supply_pack/root = IMPLIED_DECL
	for(var/decl/hierarchy/supply_pack/pack in root.get_descendants())
		if(!pack.is_category())
			master_supply_list += pack

// Just add points over time.
/datum/controller/subsystem/supply/fire()
	add_points_from_source(points_per_process, "time")

/datum/controller/subsystem/supply/stat_entry()
	..("Points: [points]")

//Supply-related helper procs.

/datum/controller/subsystem/supply/proc/add_points_from_source(amount, source)
	points += amount
	point_sources[source] += amount
	point_sources["total"] += amount

/// To stop things being sent to centcomm which should not be sent to centcomm. Recursively checks for these types.
/datum/controller/subsystem/supply/proc/forbidden_atoms_check(atom/checking)
	if(isliving(checking)) // You can't send a mob to the admin level.
		return TRUE
	if(istype(checking, /obj/item/disk/nuclear)) // Keep it somewhere nuclear operatives can reach it.
		return TRUE
	if(istype(checking, /obj/machinery/nuclearbomb)) // Don't nuke the admin level.
		return TRUE
	if(istype(checking, /obj/item/radio/beacon)) // Because these can be used for teleportation, I guess?
		return TRUE

	for(var/atom/child in checking.contents)
		if(forbidden_atoms_check(child))
			return TRUE
	return FALSE

/datum/controller/subsystem/supply/proc/sell()
	for(var/area/subarea in shuttle.shuttle_area)
		for(var/obj/structure/closet/crate/sold_crate in subarea)
			if(sold_crate.anchored)
				continue
			RAISE_EVENT(/decl/observ/crate_sold, subarea, sold_crate)
			add_points_from_source(sold_crate.get_single_monetary_worth() * crate_return_rebate * 0.1, "crate")
			var/find_slip = TRUE

			for(var/atom/movable/subcontent as anything in sold_crate)
				// Sell manifests
				if(find_slip && istype(subcontent, /obj/item/paper/manifest))
					var/obj/item/paper/manifest/slip = subcontent
					if(!LAZYACCESS(slip.metadata, "is_copy") && LAZYLEN(slip.applied_stamps))
						add_points_from_source(LAZYACCESS(slip.metadata, "order_total") * slip_return_rebate, "manifest")
						find_slip = FALSE
					continue

				// Sell materials
				if(is_type_in_list(subcontent, saleable_materials))
					add_points_from_source(subcontent.get_combined_monetary_worth() * goods_sale_modifier * 0.1, "goods")
				// Must sell ore detector disks in crates
				else if(istype(subcontent, /obj/item/disk/survey))
					add_points_from_source(subcontent.get_combined_monetary_worth() * 0.005, "data")

			qdel(sold_crate)

/datum/controller/subsystem/supply/proc/get_clear_turfs()
	var/list/clear_turfs = list()
	for(var/area/subarea in shuttle.shuttle_area)
		for(var/turf/candidate_turf in subarea)
			if(candidate_turf.density)
				continue
			var/occupied = FALSE
			for(var/atom/movable/child as anything in candidate_turf.contents)
				if(!child.simulated || !child.density)
					continue
				occupied = TRUE
				break
			if(!occupied)
				clear_turfs += candidate_turf
	return clear_turfs

//Buyin
/datum/controller/subsystem/supply/proc/buy()
	if(!shoppinglist.len)
		return

	var/list/clear_turfs = get_clear_turfs()

	for(var/datum/supply_order/order in shoppinglist)
		if(!clear_turfs.len)
			break
		var/turf/pickedloc = pick_n_take(clear_turfs)
		shoppinglist -= order
		donelist += order

		var/decl/hierarchy/supply_pack/supplypack = order.object

		var/obj/result = new supplypack.containertype(pickedloc)
		result.SetName("[supplypack.containername][order.comment ? " ([order.comment])":"" ]")
		//supply manifest generation begin

		var/obj/item/paper/manifest/slip
		if(!supplypack.contraband)
			var/info = list()
			info +="<h3>[global.using_map.boss_name] Shipping Manifest</h3><hr><br>"
			info +="Order #[order.ordernum]<br>"
			info +="Destination: [global.using_map.station_name]<br>"
			info +="[shoppinglist.len] PACKAGES IN THIS SHIPMENT<br>"
			info +="CONTENTS:<br><ul>"

			slip = new /obj/item/paper/manifest(result, null, JOINTEXT(info))
			LAZYSET(slip.metadata, "order_total", supplypack.cost)
			LAZYSET(slip.metadata, "is_copy",     FALSE)

		//spawn the stuff, finish generating the manifest while you're at it
		if(supplypack.access)
			if(!islist(supplypack.access))
				result.req_access = list(supplypack.access)
			else if(islist(supplypack.access))
				var/list/supplypack_access = supplypack.access // access var is a plain var, we need a list
				result.req_access = supplypack_access.Copy()

		var/list/spawned = supplypack.spawn_contents(result)
		if(slip)
			for(var/atom/content in spawned)
				slip.info += "<li>[content.name]</li>" //add the item to the manifest
			slip.info += "</ul><br>CHECK CONTENTS AND STAMP BELOW THE LINE TO CONFIRM RECEIPT OF GOODS<hr>"

// Adds any given item to the supply shuttle
/datum/controller/subsystem/supply/proc/addAtom(var/atom/movable/added)
	var/list/clear_turfs = get_clear_turfs()
	if(!clear_turfs.len)
		return FALSE

	var/turf/pickedloc = pick(clear_turfs)

	added.forceMove(pickedloc)

	return TRUE

/datum/supply_order
	var/ordernum
	var/decl/hierarchy/supply_pack/object = null
	var/orderedby = null
	var/comment = null
	var/reason = null
	var/orderedrank = null //used for supply console printing
