// Mutation device for turning alates into gynes.
/obj/machinery/ascent_magnetotron
	name = "magnetotron"
	desc = "An assemblage of alien machinery with large imposing dynamos."
	color = COLOR_PURPLE
	icon_state = "weightlifter"
	icon = 'icons/obj/structures/weightlifter.dmi'

/obj/machinery/ascent_magnetotron/proc/display_message(var/message)
	var/decl/language/speaking = GET_DECL(/decl/language/mantid/nonvocal)
	for(var/mob/M in viewers())
		if(M.can_speak(speaking))
			to_chat(M, "\icon[src] " + SPAN_WARNING("\The [src] flashes, \"[message]\""))
		else
			to_chat(M, "\icon[src] " + SPAN_WARNING("\The [src] flashes in a variety of ") + make_rainbow("rainbow hues") + SPAN_WARNING("."))

/obj/machinery/ascent_magnetotron/attack_hand(var/mob/user)

	if(!user.check_dexterity(DEXTERITY_COMPLEX_TOOLS, TRUE))
		return ..()

	var/mob/living/carbon/human/target = locate() in contents
	if(isnull(target))
		display_message("No biological signature detected in [src].")
		return TRUE

	if(!isspecies(target, SPECIES_MANTID_ALATE))
		display_message("Invalid biological signature detected. Safety mechanisms engaged, only alates may undergo metamorphosis.")
		return TRUE

	visible_message(SPAN_NOTICE("\icon[src] \The [src] begins to crackle and hum with energy as magnetic fields begin to fluctuate."))
	if(!prob(100 / (get_total_gynes() + 1)))
		// Oops it killed us.
		target.visible_message(SPAN_DANGER("\The [target] shrieks loudly as \the [src] tears them apart!"))
		target.gib()
		visible_message(SPAN_NOTICE("\icon[src] [src] shuts down with a loud bang, signaling the end of the process."))
		return TRUE

	if(do_after(target, 10 SECONDS, src, TRUE))
		// Convert to gyne successfully.
		target.dna.lineage = create_gyne_name()
		target.real_name = "[rand(1, 99)] [target.dna.lineage]"
		target.name = target.real_name
		target.dna.real_name = target.real_name

		target.visible_message(SPAN_NOTICE("[target] molts away their shell, emerging as a new gyne."))
		spark_at(src, cardinal_only = TRUE)
		ADJ_STATUS(target, STAT_STUN, 6)
		target.change_species(SPECIES_MANTID_GYNE)
		new /obj/effect/temp_visual/emp_burst(loc)
		for(var/obj/item/organ/external/E in target.get_external_organs())
			if(prob(60))
				E.add_pain(rand(15,40))
		visible_message(SPAN_NOTICE("\icon[src] [src] shuts down with a loud bang, signaling the end of the process."))
		playsound(src, 'sound/weapons/flashbang.ogg', 100)
	return TRUE



/obj/machinery/ascent_magnetotron/proc/get_total_gynes()
	for(var/mob/living/carbon/human/H in global.living_mob_list_)
		if(isspecies(H, SPECIES_MANTID_GYNE))
			.+= 1

/obj/item/stock_parts/circuitboard/ascent_magnetotron
	name = "circuitboard (Ascent magnetotron)"
	build_path = /obj/machinery/ascent_magnetotron
	board_type = "machine"
	origin_tech = "{'engineering':2,'magnets':4}"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 3,
		/obj/item/stock_parts/manipulator = 1
	)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/datum/fabricator_recipe/imprinter/circuit/ascent_magnetotron
	path = /obj/item/stock_parts/circuitboard/ascent_magnetotron
	species_locked = list(
		/decl/species/mantid
	)