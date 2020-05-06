/obj/item/scanner/reagent
	name = "reagent scanner"
	desc = "A hand-held reagent scanner which identifies chemical agents."
	icon = 'icons/obj/items/device/scanner/spectrometer.dmi'
	icon_state = "spectrometer"
	item_state = "analyzer"

	origin_tech = "{'magnets':2,'biotech':2}"
	scan_sound = 'sound/effects/scanbeep.ogg'
	var/details = 0

/obj/item/scanner/reagent/is_valid_scan_target(obj/O)
	return istype(O)

/obj/item/scanner/reagent/scan(obj/O, mob/user)
	scan_data = reagent_scan_results(O, details)
	scan_data = jointext(scan_data, "<br>")
	user.show_message(SPAN_NOTICE(scan_data))

/proc/reagent_scan_results(obj/O, details = 0)
	if(isnull(O.reagents))
		return list("No significant chemical agents found in [O].")
	if(!LAZYLEN(O.reagents.reagent_volumes))
		return list("No active chemical agents found in [O].")
	. = list("Chemicals found in [O]:")
	var/one_percent = O.reagents.total_volume / 100
	for (var/rtype in O.reagents.reagent_volumes)
		var/decl/material/R = decls_repository.get_decl(rtype)
		. += "[R.name][details ? ": [REAGENT_VOLUME(O.reagents, rtype) / one_percent]%" : ""]"

/obj/item/scanner/reagent/adv
	name = "advanced reagent scanner"
	icon_state = "adv_spectrometer"
	details = 1
	origin_tech = "{'magnets':4,'biotech':2}"