/obj/item/scanner/xenobio
	name = "xenolife scanner"
	desc = "Multipurpose organic life scanner. With spectral breath analyzer you can find out what snacks Ian had! Or what gasses alien life breathes."
	icon = 'icons/obj/items/device/scanner/xenobio_scanner.dmi'
	icon_state = "xenobio"
	item_state = "analyzer"
	scan_sound = 'sound/effects/scanbeep.ogg'
	printout_color = "#f3e6ff"
	origin_tech = "{'magnets':1,'biotech':1}"
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/plastic = MATTER_AMOUNT_TRACE
	)

	var/list/valid_targets = list(
		/mob/living/carbon/human,
		/mob/living/simple_animal
	)

/obj/item/scanner/xenobio/is_valid_scan_target(atom/O)
	if(is_type_in_list(O, valid_targets))
		return TRUE
	if(istype(O, /obj/structure/stasis_cage))
		var/obj/structure/stasis_cage/cagie = O
		return !!cagie.contained
	return FALSE

/obj/item/scanner/xenobio/scan(mob/O, mob/user)
	scan_title = O.name
	scan_data =  O.xenobio_scan_results()
	user.show_message(SPAN_NOTICE(scan_data))

/proc/list_gases(var/gases)
	. = list()
	for(var/g in gases)
		var/decl/material/mat = GET_DECL(g)
		. += "[capitalize(mat.gas_name)] ([gases[g]]%)"
	return english_list(.)

/mob/proc/xenobio_scan_results()
	. = "Incompatible life form, analysis failed."

/mob/living/carbon/human/xenobio_scan_results()
	. += "Data for \the [src]:"
	. += "Species:\t[species]"
	if(species.breath_type)
		var/decl/material/mat = GET_DECL(species.breath_type)
		. += "Breathes:\t[mat.gas_name]"
	if(species.exhale_type)
		var/decl/material/mat = GET_DECL(species.exhale_type)
		. += "Exhales:\t[mat.gas_name]"
	. += "Known toxins:\t[english_list(species.poison_types)]"
	. += "Temperature comfort zone:\t[species.cold_discomfort_level] K to [species.heat_discomfort_level] K"
	. += "Pressure comfort zone:\t[species.warning_low_pressure] kPa to [species.warning_high_pressure] kPa"
	. = jointext(., "<br>")

/mob/living/simple_animal/xenobio_scan_results()
	. += "Data for \the [src]:"
	. += "Species:\t[initial(name)]"
	. += "Breathes:\t[list_gases(min_gas)]"
	. += "Known toxins:\t[list_gases(max_gas)]"
	. += "Temperature comfort zone:\t[minbodytemp] K to [maxbodytemp] K"

	for(var/planet_id in SSmapping.planetoid_data_by_id)
		var/datum/planetoid_data/P = SSmapping.planetoid_data_by_id[planet_id]
		if(P.is_native_animal(src))
			var/list/discovered = SSstatistics.get_field(STAT_XENOFAUNA_SCANNED)
			LAZYDISTINCTADD(discovered, "[P.name]-[type]")
			SSstatistics.set_field(STAT_XENOFAUNA_SCANNED, discovered)
			. += "New xenofauna species discovered!"
			break
	. = jointext(., "<br>")
