/obj/machinery/fabricator/bioprinter
	name = "bioprinter"
	desc = "It's a machine that fabricates organs out of meat."
	icon = 'icons/obj/machines/fabricators/bioprinter.dmi'
	icon_state = "bioprinter"
	base_icon_state = "bioprinter"
	base_type = /obj/machinery/fabricator/bioprinter
	fabricator_class = FABRICATOR_CLASS_MEAT
	base_storage_capacity = list(
		/decl/material/solid/meat = SHEET_MATERIAL_AMOUNT * 100
	)
	var/datum/dna/loaded_dna_datum

/obj/machinery/fabricator/bioprinter/do_build(var/datum/fabricator_recipe/recipe, var/amount)
	. = ..()
	for(var/obj/item/organ/O in .)
		if(loaded_dna_datum)
			O.set_dna(loaded_dna_datum)
		O.status |= ORGAN_CUT_AWAY

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
