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
	var/decl/hierarchy/supply_pack/root = GET_DECL(/decl/hierarchy/supply_pack)
	for(var/decl/hierarchy/supply_pack/sp in root.children)
		if(sp.is_category())
			for(var/decl/hierarchy/supply_pack/spc in sp.get_descendents())
				spc.setup()
				master_supply_list += spc

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

	//To stop things being sent to centcomm which should not be sent to centcomm. Recursively checks for these types.
/datum/controller/subsystem/supply/proc/forbidden_atoms_check(atom/A)
	if(istype(A,/mob/living))
		return 1
	if(istype(A,/obj/item/disk/nuclear))
		return 1
	if(istype(A,/obj/machinery/nuclearbomb))
		return 1
	if(istype(A,/obj/item/radio/beacon))
		return 1

	for(var/i=1, i<=A.contents.len, i++)
		var/atom/B = A.contents[i]
		if(.(B))
			return 1

/datum/controller/subsystem/supply/proc/sell()

	for(var/area/subarea in shuttle.shuttle_area)
		for(var/atom/movable/AM in subarea)
			if(AM.anchored)
				continue
			if(istype(AM, /obj/structure/closet/crate/))
				var/obj/structure/closet/crate/CR = AM
				callHook("sell_crate", list(CR, subarea))
				add_points_from_source(CR.get_single_monetary_worth() * crate_return_rebate * 0.1, "crate")
				var/find_slip = 1

				for(var/atom in CR)
					// Sell manifests
					var/atom/A = atom
					if(find_slip && istype(A,/obj/item/paper/manifest))
						var/obj/item/paper/manifest/slip = A
						if(!LAZYACCESS(slip.metadata, "is_copy") && LAZYLEN(slip.applied_stamps))
							add_points_from_source(LAZYACCESS(slip.metadata, "order_total") * slip_return_rebate, "manifest")
							find_slip = 0
						continue

					// Sell materials
					if(is_type_in_list(A.type, saleable_materials))
						add_points_from_source(A.get_combined_monetary_worth() * goods_sale_modifier * 0.1, "goods")

					// Must sell ore detector disks in crates
					if(istype(A, /obj/item/disk/survey))
						var/obj/item/disk/survey/D = A
						add_points_from_source(D.get_combined_monetary_worth() * 0.005, "data")

			qdel(AM)

/datum/controller/subsystem/supply/proc/get_clear_turfs()
	var/list/clear_turfs = list()

	for(var/area/subarea in shuttle.shuttle_area)
		for(var/turf/T in subarea)
			if(T.density)
				continue
			var/occupied = 0
			for(var/atom/A in T.contents)
				if(!A.simulated)
					continue
				occupied = 1
				break
			if(!occupied)
				clear_turfs += T

	return clear_turfs

//Buyin
/datum/controller/subsystem/supply/proc/buy()
	if(!shoppinglist.len)
		return

	var/list/clear_turfs = get_clear_turfs()

	for(var/S in shoppinglist)
		if(!clear_turfs.len)
			break
		var/turf/pickedloc = pick_n_take(clear_turfs)
		shoppinglist -= S
		donelist += S

		var/datum/supply_order/SO = S
		var/decl/hierarchy/supply_pack/SP = SO.object

		var/obj/A = new SP.containertype(pickedloc)
		A.SetName("[SP.containername][SO.comment ? " ([SO.comment])":"" ]")
		//supply manifest generation begin

		var/obj/item/paper/manifest/slip
		if(!SP.contraband)
			var/info = list()
			info +="<h3>[command_name()] Shipping Manifest</h3><hr><br>"
			info +="Order #[SO.ordernum]<br>"
			info +="Destination: [global.using_map.station_name]<br>"
			info +="[shoppinglist.len] PACKAGES IN THIS SHIPMENT<br>"
			info +="CONTENTS:<br><ul>"

			slip = new /obj/item/paper/manifest(A, null, JOINTEXT(info))
			LAZYSET(slip.metadata, "order_total", SP.cost)
			LAZYSET(slip.metadata, "is_copy",     FALSE)

		//spawn the stuff, finish generating the manifest while you're at it
		if(SP.access)
			if(!islist(SP.access))
				A.req_access = list(SP.access)
			else if(islist(SP.access))
				var/list/L = SP.access // access var is a plain var, we need a list
				A.req_access = L.Copy()

		var/list/spawned = SP.spawn_contents(A)
		if(slip)
			for(var/atom/content in spawned)
				slip.info += "<li>[content.name]</li>" //add the item to the manifest
			slip.info += "</ul><br>CHECK CONTENTS AND STAMP BELOW THE LINE TO CONFIRM RECEIPT OF GOODS<hr>"

// Adds any given item to the supply shuttle
/datum/controller/subsystem/supply/proc/addAtom(var/atom/movable/A)
	var/list/clear_turfs = get_clear_turfs()
	if(!clear_turfs.len)
		return FALSE

	var/turf/pickedloc = pick(clear_turfs)

	A.forceMove(pickedloc)

	return TRUE

/datum/supply_order
	var/ordernum
	var/decl/hierarchy/supply_pack/object = null
	var/orderedby = null
	var/comment = null
	var/reason = null
	var/orderedrank = null //used for supply console printing
