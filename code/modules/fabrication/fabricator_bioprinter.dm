#define BIOPRINTER_BLOOD_SAMPLE_SIZE 5

/obj/machinery/fabricator/bioprinter
	name = "bioprinter"
	desc = "Fabricator used for cloning organs from DNA."
	icon = 'icons/obj/machines/fabricators/bioprinter.dmi'
	icon_state = "bioprinter"
	base_icon_state = "bioprinter"
	base_type = /obj/machinery/fabricator/bioprinter
	fabricator_class = FABRICATOR_CLASS_MEAT
	ignore_input_contents_length = TRUE // mostly eats organs, let people quickly dump a torso in there without doing surgery.
	var/datum/mob_snapshot/loaded_dna //DNA for biological organs

/obj/machinery/fabricator/bioprinter/can_ingest(var/obj/item/thing)
	. = istype(thing, /obj/item/organ) || istype(thing, /obj/item/food/butchery) || ..()

/obj/machinery/fabricator/bioprinter/get_nano_template()
	return "fabricator_bioprinter.tmpl"

/obj/machinery/fabricator/bioprinter/make_order(datum/fabricator_recipe/recipe, multiplier)
	var/datum/fabricator_build_order/order = ..()
	//Keep these in the order so changing settings while queueing things up won't screw up older orders in the queue
	order.set_data("dna", loaded_dna)
	return order

/obj/machinery/fabricator/bioprinter/can_ingest(var/obj/item/thing)
	return istype(thing?.material, /decl/material/solid/organic/meat) || ..()

/obj/machinery/fabricator/bioprinter/do_build(datum/fabricator_build_order/order)
	. = ..()
	//Fetch params as they were when the order was passed
	var/datum/mob_snapshot/D = order.get_data("dna")
	for(var/obj/item/organ/O in .)
		if(D)
			O.copy_from_mob_snapshot(D)
		O.status |= ORGAN_CUT_AWAY

/obj/machinery/fabricator/bioprinter/attackby(obj/item/W, mob/user)
	if(istype(W,/obj/item/chems/syringe))
		var/obj/item/chems/syringe/S = W
		if(REAGENT_VOLUME(S.reagents, /decl/material/liquid/blood))
			var/sample = REAGENT_DATA(S.reagents, /decl/material/liquid/blood)
			if(islist(sample))
				var/weakref/R = sample["donor"]
				var/mob/living/human/H = R.resolve()
				if(H && istype(H) && H.species)
					loaded_dna = H.get_mob_snapshot()
					if(loaded_dna)
						to_chat(user, SPAN_INFO("You inject the blood sample into \the [src]."))
						S.remove_any_reagents(BIOPRINTER_BLOOD_SAMPLE_SIZE)
						//Tell nano to do its job
						SSnano.update_uis(src)
						return TRUE
		to_chat(user, SPAN_WARNING("\The [src] displays an error: no viable blood sample could be obtained from \the [W]."))
		return TRUE
	. = ..()

/obj/machinery/fabricator/bioprinter/OnTopic(user, href_list, state)
	. = ..()
	if(href_list["flush_dna"])
		if(fab_status_flags & FAB_BUSY)
			state("Can't flush DNA while printing in progress!")
		else
			loaded_dna = null
		. = TOPIC_REFRESH

/obj/machinery/fabricator/bioprinter/proc/ui_data_dna(mob/user, ui_key)
	if(!loaded_dna)
		return null
	return list(
		"real_name" = loaded_dna.real_name,
		"UE"        = loaded_dna.unique_enzymes,
		"species"   = loaded_dna.root_species.name,
		"btype"     = loaded_dna.blood_type,
	)

/obj/machinery/fabricator/bioprinter/ui_draw_config(mob/user, ui_key)
	return TRUE //Always draw it for us

/obj/machinery/fabricator/bioprinter/ui_data_config(mob/user, ui_key)
	if(!(. = ..()))
		return
	var/list/dnaentry = ui_data_dna(user, ui_key)
	LAZYSET(., "dna", dnaentry)

//Only let us print things if we got a DNA set
/obj/machinery/fabricator/bioprinter/can_build(datum/fabricator_recipe/recipe, multiplier)
	return ..() && loaded_dna
/obj/machinery/fabricator/bioprinter/ui_fabricator_build_option_is_available(datum/fabricator_recipe/R, max_sheets)
	return ..() && loaded_dna
