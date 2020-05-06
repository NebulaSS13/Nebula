#define  ORE_SURFACE   "surface minerals"
#define  ORE_PRECIOUS  "precious metals"
#define  ORE_NUCLEAR   "nuclear fuel"
#define  ORE_EXOTIC    "exotic matter"
/turf/simulated/var/surveyed

/obj/item/scanner/mining
	name = "ore detector"
	desc = "A complex device used to locate ore deep underground."
	icon = 'icons/obj/items/device/scanner/ore_scanner.dmi'
	icon_state = "ore"
	origin_tech = "{'magnets':1,'engineering':1}"
	use_delay = 50
	printout_color = "#fff7f0"
	var/survey_data = 0

	scan_sound = 'sound/effects/ping.ogg'

/obj/item/scanner/mining/examine(mob/user)
	. = ..()
	to_chat(user,"A tiny indicator on the [src] shows it holds [survey_data] good explorer points.")

/obj/item/scanner/mining/is_valid_scan_target(turf/simulated/T)
	return istype(T)

/obj/item/scanner/mining/scan(turf/simulated/T, mob/user)
	scan_title = "Mineral scan data"
	var/list/scan_results = mineral_scan_results(T)
	if(!scan_data)
		scan_data = scan_results[1]
	else
		scan_data += "<hr>[scan_results[1]]"
	to_chat(user, "\icon[src] <span class='notice'>\The [src] displays a readout.</span>")
	to_chat(user, scan_results[1])

	if(scan_results[2])
		survey_data += scan_results[2]
		playsound(loc, 'sound/machines/ping.ogg', 40, 1)
		to_chat(user,"<span class='notice'>New survey data stored - [scan_results[2]] GEP.</span>")

/obj/item/scanner/mining/proc/put_disk_in_hand(var/mob/M)
	if(!survey_data)
		to_chat(M,"<span class='warning'>There is no survey data stored on the [src].</span>")
		return 0
	visible_message("<span class='notice'>The [src] spits out a disk containing [survey_data] GEP.</span>")
	var/obj/item/disk/survey/D = new(get_turf(src))
	D.data = survey_data
	survey_data = 0
	M.put_in_hands(D)
	return 1

/obj/item/scanner/mining/verb/get_data()
	set category = "Object"
	set name = "Get Survey Data"
	set src in usr

	var/mob/M = usr
	if(!istype(M))
		return
	if(M.incapacitated())
		return
	put_disk_in_hand(M)

/obj/item/disk/survey
	name = "survey data disk"
	icon = 'icons/obj/items/device/diskette.dmi'
	icon_state = "nucleardisk"
	var/data

/obj/item/disk/survey/examine(mob/user)
	. = ..()
	to_chat(user,"A tiny indicator on the [src] shows it holds [data] good explorer points.")

//Returns list of two elements, 1 is text output, 2 is amoutn of GEP data
/proc/mineral_scan_results(turf/simulated/target)
	var/list/metals = list(
		ORE_SURFACE = 0,
		ORE_PRECIOUS = 0,
		ORE_NUCLEAR = 0,
		ORE_EXOTIC = 0
		)
	var/new_data = 0

	for(var/turf/simulated/T in range(2, target))

		if(!T.has_resources)
			continue

		for(var/metal in T.resources)
			var/ore_type
			var/data_value = 1

			switch(metal)
				if(MAT_SILICON, MAT_GRAPHITE, MAT_IRON)
					ore_type = ORE_SURFACE
				if(MAT_GOLD, MAT_SILVER, MAT_DIAMOND, MAT_RUTILE)
					ore_type = ORE_PRECIOUS
					data_value = 2
				if(MAT_URANIUM)
					ore_type = ORE_NUCLEAR
					data_value = 3
				if(MAT_PHORON, MAT_OSMIUM, MAT_METALLIC_HYDROGEN)
					ore_type = ORE_EXOTIC
					data_value = 4

			if(ore_type) metals[ore_type] += T.resources[metal]

			if(!T.surveyed)
				new_data += data_value * T.resources[metal]

		T.surveyed = 1

	var/list/scandata = list("Mineral scan at ([target.x],[target.y])")
	for(var/ore_type in metals)
		var/result = "no sign"

		switch(metals[ore_type])
			if(1 to 25) result = "trace amounts"
			if(26 to 75) result = "significant amounts"
			if(76 to INFINITY) result = "huge quantities"

		scandata += "- [result] of [ore_type]."

	return list(jointext(scandata, "<br>"), new_data)

#undef  ORE_SURFACE
#undef  ORE_PRECIOUS
#undef  ORE_NUCLEAR
#undef  ORE_EXOTIC