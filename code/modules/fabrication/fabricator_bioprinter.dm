/obj/machinery/fabricator/bioprinter
	name = "bioprinter"
	desc = "Fabricator used for printing new biological or artificial limbs and organs."
	icon = 'icons/obj/machines/fabricators/bioprinter.dmi'
	icon_state = "bioprinter"
	base_icon_state = "bioprinter"
	base_type = /obj/machinery/fabricator/bioprinter
	fabricator_class = FABRICATOR_CLASS_MEAT
	base_storage_capacity = list(
		/decl/material/solid/meat        = SHEET_MATERIAL_AMOUNT * 100,
		/decl/material/solid/metal/steel = SHEET_MATERIAL_AMOUNT * 100,
	)
	var/datum/dna/loaded_dna_datum                           //DNA for biological organs
	var/decl/species/selected_species                        //What species has been selected for prothetics organs
	var/decl/prosthetics_manufacturer/selected_manufacturer  //What manufacturer to use for prosthetics
	var/make_biological = TRUE //Whether we should print biological organs or prosthetics 

/obj/machinery/fabricator/bioprinter/Initialize()
	. = ..()
	selected_species = global.using_map?.default_species

/obj/machinery/fabricator/bioprinter/get_nano_template()
	return "fabricator_bioprinter.tmpl"

/obj/machinery/fabricator/bioprinter/make_order(datum/fabricator_recipe/recipe, multiplier)
	var/datum/fabricator_build_order/order = ..()
	//Keep these in the order so changing settings while queueing things up won't screw up older orders in the queue
	LAZYSET(order.data, "biological", make_biological)

	if(make_biological)
		LAZYSET(order.data, "dna",          loaded_dna_datum)
	else
		LAZYSET(order.data, "species",      selected_species)
		LAZYSET(order.data, "manufacturer", selected_manufacturer)
	return order

/obj/machinery/fabricator/bioprinter/do_build(datum/fabricator_build_order/order)
	. = ..()
	//Fetch params as they were when the order was passed
	var/datum/dna/D = LAZYACCESS(order.data, "dna")
	var/decl/species/S = LAZYACCESS(order.data, "species")
	var/decl/prosthetics_manufacturer/M = LAZYACCESS(order.data, "manufacturer")
	var/is_prosthetic = !(LAZYACCESS(order.data, "biological"))
	for(var/obj/item/organ/O in .)
		if(is_prosthetic)
			if(D)
				O.set_dna(D)
			O.status |= ORGAN_CUT_AWAY
		else
			if(S)
				O.set_species(S)
			if(M)
				O.setup_as_prosthetic(M) //Force organ manufacturer

/obj/machinery/fabricator/bioprinter/attackby(obj/item/W, mob/user)
	if(istype(W,/obj/item/chems/syringe))
		var/obj/item/chems/syringe/S = W
		if(REAGENT_VOLUME(S.reagents, /decl/material/liquid/blood))
			var/loaded_dna = REAGENT_DATA(S.reagents, /decl/material/liquid/blood)
			if(islist(loaded_dna))
				var/weakref/R = loaded_dna["donor"]
				var/mob/living/carbon/human/H = R.resolve()
				if(H && istype(H) && H.species && H.dna)
					loaded_dna_datum = H.dna && H.dna.Clone()
					to_chat(user, SPAN_INFO("You inject the blood sample into \the [src]."))
					S.reagents.clear_reagents()
					return TRUE
		to_chat(user, SPAN_WARNING("\The [src] displays an error: no viable blood sample could be obtained from \the [W]."))
		return TRUE
	. = ..()

/obj/machinery/fabricator/bioprinter/OnTopic(user, href_list, state)
	if(href_list["pick_species"])
		var/chosen_specie = input(user, "Choose a specie to produce prosthetics for", "Target Species", selected_species) in get_all_species()
		if(chosen_specie)
			selected_species = chosen_specie
		. = TOPIC_REFRESH

	if(href_list["pick_manufacturer"])
		var/list/manufacturers = subtypesof(/decl/prosthetics_manufacturer)
		var/chosen_manufacturer = input(user, "Choose a prosthetic design", "Manufacturer Designs", selected_manufacturer) in manufacturers
		if(chosen_manufacturer)
			selected_manufacturer = chosen_manufacturer
		. = TOPIC_REFRESH

	if(href_list["flush_dna"])
		if(fab_status_flags & FAB_BUSY)
			state("Can't flush DNA while printing in progress!")
		else
			loaded_dna_datum = null
		. = TOPIC_REFRESH
	
	if(href_list["set_organic"])
		make_biological = TRUE
		. = TOPIC_REFRESH

	if(href_list["set_mechanical"])
		make_biological = FALSE
		. = TOPIC_REFRESH

	. = ..()

/obj/machinery/fabricator/bioprinter/proc/ui_data_dna(mob/user, ui_key)
	if(!loaded_dna_datum)
		return null
	return list(
		"real_name" = loaded_dna_datum.real_name,
		"UE"        = loaded_dna_datum.unique_enzymes,
		"species"   = loaded_dna_datum.species,
		"btype"     = loaded_dna_datum.b_type,
	)

/obj/machinery/fabricator/bioprinter/ui_draw_config(mob/user, ui_key)
	return TRUE //Always draw it for us

/obj/machinery/fabricator/bioprinter/ui_data_config(mob/user, ui_key)
	if(!(. = ..()))
		return
	var/list/dnaentry = ui_data_dna(user, ui_key)
	LAZYSET(., "selected_species", selected_species)
	LAZYSET(., "make_biological",  make_biological)
	LAZYSET(., "species",          selected_species)
	LAZYSET(., "manufacturer",     selected_manufacturer)
	LAZYSET(., "dna",              dnaentry)

/obj/machinery/fabricator/bioprinter/ui_fabricator_build_options_data()
	var/list/build_options
	for(var/datum/fabricator_recipe/R in design_cache)
		if(R.hidden && !(fab_status_flags & FAB_HACKED))
			continue
		if(show_category != "All" && show_category != R.category)
			continue
		if(filter_string && !findtextEx_char(lowertext(R.name), lowertext(filter_string)))
			continue
		//Added some extra criteras to get the build options
		if(make_biological && !istype(R, /datum/fabricator_recipe/meat)) 
			continue //Only biological organs allowed
		if(!make_biological && istype(R, /datum/fabricator_recipe/meat))
			continue //Only mechanical organs allowed
		LAZYADD(build_options, list(ui_fabricator_build_option_entry_data(R)))
	return build_options
