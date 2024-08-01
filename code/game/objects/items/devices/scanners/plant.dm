
/obj/item/scanner/plant
	name = "plant analyzer"
	desc = "A hand-held botanical scanner used to analyze plants."
	icon = 'icons/obj/items/device/scanner/plant_scanner.dmi'
	scan_sound = 'sound/effects/fastbeep.ogg'
	printout_color = "#eeffe8"
	var/static/list/valid_targets = list(
		/obj/item/food/grown,
		/obj/machinery/portable_atmospherics/hydroponics,
		/obj/item/seeds,
		/obj/structure/flora/plant
	)

/obj/item/scanner/plant/is_valid_scan_target(atom/O)
	if(is_type_in_list(O, valid_targets))
		return TRUE
	return FALSE

/obj/item/scanner/plant/scan(atom/A, mob/user)
	scan_title = "[A] at [get_area_name(A)]"
	scan_data = plant_scan_results(A)
	show_menu(user)

/proc/plant_scan_results(obj/target)

	var/datum/seed/grown_seed
	var/datum/reagents/grown_reagents
	if(istype(target,/obj/item/food/grown))
		var/obj/item/food/grown/G = target
		grown_seed = G.seed
		grown_reagents = G.reagents
	else if(istype(target,/obj/item/seeds))
		var/obj/item/seeds/S = target
		grown_seed = S.seed
	else if(istype(target,/obj/machinery/portable_atmospherics/hydroponics))
		var/obj/machinery/portable_atmospherics/hydroponics/H = target
		grown_seed = H.seed
		grown_reagents = H.reagents
	else if(istype(target,/obj/structure/flora/plant))
		var/obj/structure/flora/plant/P = target
		grown_seed = P.plant

	if(!grown_seed)
		return

	if(grown_seed.mysterious && !grown_seed.scanned)
		grown_seed.scanned = TRUE
		for(var/planetoid_id in SSmapping.planetoid_data_by_id)
			var/datum/planetoid_data/P = SSmapping.planetoid_data_by_id[planetoid_id]
			if(P.is_native_plant(grown_seed))
				SSstatistics.add_field(STAT_XENOPLANTS_SCANNED, 1)
				break

	var/list/dat = list()

	var/form_title = "[grown_seed.product_name] (#[grown_seed.uid])"
	dat += "<h3>Plant data for [form_title]</h3>"

	var/list/general_data        = list()
	var/list/extended_trait_data = list()

	if(length(grown_seed.mutants))
		extended_trait_data += "It exhibits a high degree of potential subspecies shift."

	for(var/decl/plant_trait/plant_trait in decls_repository.get_decls_of_subtype_unassociated(/decl/plant_trait))
		if(plant_trait.shows_general_data)
			general_data[plant_trait.name] = grown_seed.get_trait(plant_trait.type)
		if(plant_trait.shows_extended_data)
			var/extended_data = plant_trait.get_extended_data(grown_seed.get_trait(plant_trait.type), grown_seed)
			if(extended_data)
				extended_trait_data += extended_data

	dat += "<h2>General Data</h2>"
	dat += "<table>"
	if(length(general_data))
		for(var/trait_name in general_data)
			dat += "<tr><td><b>[uppertext(trait_name)]</b></td><td>[general_data[trait_name]]</td></tr>"
	dat += "</table>"

	if(LAZYLEN(grown_reagents?.reagent_volumes))
		dat += "<h2>Reagent Data</h2>"
		dat += "<br>This sample contains: "
		for(var/rtype in grown_reagents.reagent_volumes)
			var/decl/material/R = GET_DECL(rtype)
			dat += "<br>- [R.get_reagent_name(grown_reagents)], [REAGENT_VOLUME(grown_reagents, rtype)] unit(s)"

	dat += "<h2>Other Data</h2>"
	if(length(extended_trait_data))
		dat += jointext(extended_trait_data, "<br>")

	return JOINTEXT(dat)