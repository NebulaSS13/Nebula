/decl/hierarchy/supply_pack
	name = "Supply Packs"
	hierarchy_type = /decl/hierarchy/supply_pack
	var/list/contains = list()
	var/manifest = ""
	var/cost
	var/containertype = /obj/structure/closet/crate
	var/containername = null
	var/access = null
	var/hidden = 0
	var/contraband = 0
	var/num_contained = 0 //number of items picked to be contained in a randomised crate
	var/supply_method = /decl/supply_method
	var/decl/security_level/security_level

//Is run once on init for non-base-category supplypacks.
var/global/list/cargoprices = list()
/decl/hierarchy/supply_pack/proc/setup()
	if(!num_contained)
		for(var/entry in contains)
			num_contained += max(1, contains[entry])
	if(isnull(cost))
		cost = 0
		for(var/entry in contains)
			cost += atom_info_repository.get_combined_worth_for(entry) * max(1, contains[entry])
		var/container_value = containertype ? atom_info_repository.get_single_worth_for(containertype) : 0
		if(container_value)
			cost += atom_info_repository.get_single_worth_for(containertype)
		cost = max(1, NONUNIT_CEILING((cost * WORTH_TO_SUPPLY_POINTS_CONSTANT * SSsupply.price_markup), WORTH_TO_SUPPLY_POINTS_ROUND_CONSTANT))
	global.cargoprices[name] = cost

	var/decl/supply_method/sm = GET_DECL(supply_method)
	manifest = sm.setup_manifest(src)

/client/proc/print_cargo_prices()
	set name = "Print Cargo Prices"
	set category = "Debug"

	global.cargoprices = sortTim(global.cargoprices, /proc/cmp_numeric_asc, TRUE)
	var/pad = 0
	for(var/key in global.cargoprices)
		pad = max(pad, length_char(key)+2)
	for(var/key in global.cargoprices)
		to_chat(mob, "[pad_right("[key]:", pad, " ")][global.cargoprices[key]]")

/decl/hierarchy/supply_pack/proc/sec_available()
	if(isnull(security_level))
		return TRUE
	var/decl/security_state/security_state = GET_DECL(global.using_map.security_state)
	switch(security_level)
		if(SUPPLY_SECURITY_ELEVATED)
			if(security_state.all_security_levels.len > 1)
				security_level = security_state.all_security_levels[2] 
			else
				security_level = security_state.high_security_level 
		if(SUPPLY_SECURITY_HIGH)
			security_level = security_state.high_security_level
	if(!istype(security_level))
		return TRUE
	return security_state.current_security_level_is_same_or_higher_than(security_level)

/decl/hierarchy/supply_pack/proc/spawn_contents(var/location)
	var/decl/supply_method/sm = GET_DECL(supply_method)
	. = sm.spawn_contents(src, location)
	for(var/obj/O in .)
		O.anchored = FALSE

/*
//SUPPLY PACKS
//NOTE: only secure crate types use the access var (and are lockable)
//NOTE: hidden packs only show up when the computer has been hacked.
//ANOTER NOTE: Contraband is obtainable through modified supplycomp circuitboards.
//BIG NOTE: Don't add living things to crates, that's bad, it will break the shuttle.
//NEW NOTE: Do NOT set the price of any crates below 7 points. Doing so allows infinite points.
*/

/decl/supply_method/proc/spawn_contents(var/decl/hierarchy/supply_pack/sp, var/location)
	if(!sp || !location)
		return
	. = list()
	for(var/entry in sp.contains)
		for(var/i = 1 to max(1, sp.contains[entry]))
			dd_insertObjectList(.,new entry(location))

/decl/supply_method/proc/setup_manifest(var/decl/hierarchy/supply_pack/sp)
	. = list()
	. += "<ul>"
	for(var/path in sp.contains)
		var/atom/A = path
		if(!ispath(A))
			continue
		. += "<li>[initial(A.name)]</li>"
	. += "</ul>"
	. = jointext(.,null)

/decl/supply_method/randomized/spawn_contents(var/decl/hierarchy/supply_pack/sp, var/location)
	if(!sp || !location)
		return
	. = list()
	for(var/j = 1 to sp.num_contained)
		var/picked = pick(sp.contains)
		. += new picked(location)

/decl/supply_method/randomized/setup_manifest(var/decl/hierarchy/supply_pack/sp)
	return "Contains any [sp.num_contained] of:" + ..()
