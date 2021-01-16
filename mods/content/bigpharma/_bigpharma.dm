/decl/modpack/bigpharma
	name = "Big Pharma Content"

var/list/reagent_names_to_medication_names
/proc/get_medication_name_from_reagent_name(var/reagent_name)
	. = LAZYACCESS(global.reagent_names_to_medication_names, reagent_name)
	if(!.)
		var/decl/language/bigpharma/pharma = decls_repository.get_decl(/decl/language/bigpharma)
		LAZYSET(global.reagent_names_to_medication_names, reagent_name, pharma.get_random_name())
		. = global.reagent_names_to_medication_names[reagent_name]

var/list/reagent_names_to_colours
/proc/get_medication_colour_from_reagent_name(var/reagent_name)
	. = LAZYACCESS(global.reagent_names_to_colours, reagent_name)
	if(!.)
		LAZYSET(global.reagent_names_to_colours, reagent_name, get_random_colour())
		. = global.reagent_names_to_colours[reagent_name]

var/list/reagent_names_to_icon_state
/proc/get_medication_icon_state_from_reagent_name(var/reagent_name, var/base_state, var/min, var/max)
	. = LAZYACCESS(global.reagent_names_to_icon_state, reagent_name)
	if(!.)
		LAZYSET(global.reagent_names_to_icon_state, reagent_name, "[base_state][rand(min, max)]")
		. = global.reagent_names_to_icon_state[reagent_name]

/proc/handle_med_obfuscation(var/obj/item/thing)
	// Do we need to bother with anything past this point?
	var/datum/extension/obfuscated_medication/meds = get_extension(thing, /datum/extension/obfuscated_medication)
	if(!meds)
		return
	// Emergency pouches probably shouldn't be obfuscated.
	if(istype(thing.loc, /obj/item/storage/med_pouch) || istype(thing.loc, /obj/item/storage/firstaid))
		remove_extension(thing, /datum/extension/obfuscated_medication)
		return
	// Containers that can't find an original reagent name will just opt-out of the entire system.
	meds.original_reagent = meds.get_original_reagent(thing)
	if(!meds.original_reagent)
		remove_extension(thing, /datum/extension/obfuscated_medication)
		return
	// Okay, now apply the obfuscation.
	var/new_name = meds.get_name()
	if(new_name)
		thing.SetName(new_name)
	if(meds.container_description)
		thing.desc = meds.container_description
	thing.update_icon()	
