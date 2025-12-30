/obj/item/scanner/reagent
	name = "reagent scanner"
	desc = "A hand-held reagent scanner which identifies chemical agents."
	icon = 'icons/obj/items/device/scanner/spectrometer.dmi'
	origin_tech = @'{"magnets":2,"biotech":2}'
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
	var/chem_volumes = REAGENT_VOLUMES(O.reagents)
	if(!LAZYLEN(chem_volumes))
		return list("No active chemical agents found in [O].")
	. = list("Chemicals found in [O]:")
	var/one_percent = REAGENT_TOTAL_VOLUME(O.reagents) / 100
	for (var/decl/material/reagent as anything in REAGENT_VOLUMES(O.reagents))
		. += "[reagent.name][details ? ": [REAGENT_VOLUME(O.reagents, reagent) / one_percent]%" : ""]"

/obj/item/scanner/reagent/adv
	name = "advanced reagent scanner"
	icon = 'icons/obj/items/device/scanner/advanced_spectrometer.dmi'
	details = 1
	origin_tech = @'{"magnets":4,"biotech":2}'