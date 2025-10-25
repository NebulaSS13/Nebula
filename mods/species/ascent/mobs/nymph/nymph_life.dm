/mob/living/simple_animal/alien/kharmaan/handle_nutrition_and_hydration()
	. = ..()
	// Generate some crystals over time.
	if(nutrition >= 300 && crystal_reserve < ANYMPH_MAX_CRYSTALS)
		crystal_reserve = min(ANYMPH_MAX_CRYSTALS, crystal_reserve + 15)
		adjust_nutrition(DEFAULT_HUNGER_FACTOR * -4)
	else if(nutrition >= 200 && crystal_reserve < ANYMPH_MAX_CRYSTALS)
		crystal_reserve = min(ANYMPH_MAX_CRYSTALS, crystal_reserve + 10)
		adjust_nutrition(DEFAULT_HUNGER_FACTOR * -3)
	else if(nutrition >= 100 && crystal_reserve < ANYMPH_MAX_CRYSTALS)
		crystal_reserve = min(ANYMPH_MAX_CRYSTALS, crystal_reserve + 5)
		adjust_nutrition(DEFAULT_HUNGER_FACTOR * -2)
	else
		adjust_nutrition(DEFAULT_HUNGER_FACTOR * -1)
	if(hydration > 0)
		adjust_hydration(DEFAULT_THIRST_FACTOR * -1)

/mob/living/simple_animal/alien/kharmaan/Stat()
	. = ..()
	if(client && statpanel("Status"))
		stat("Nutrition", "[get_nutrition()]/[ANYMPH_NUTRITION_MOLT]")
		stat("Crystal reserve", "[crystal_reserve]/[ANYMPH_CRYSTAL_MOLT]")

/mob/living/simple_animal/alien/kharmaan/proc/can_molt()
	if(crystal_reserve < ANYMPH_CRYSTAL_MOLT)
		to_chat(src, SPAN_WARNING("You don't have enough crystalline matter stored up to molt right now."))
		return FALSE
	if(nutrition < ANYMPH_NUTRITION_MOLT)
		to_chat(src, SPAN_WARNING("You're too hungry to molt right now!"))
		return FALSE
	if(world.time - last_molt < ANYMPH_TIME_MOLT)
		to_chat(src, SPAN_WARNING("You haven't waited long enough between molts."))
		return FALSE
	return TRUE

/mob/living/simple_animal/alien/kharmaan/proc/molt()
	if(!can_molt())
		return

	molt = min(molt + 1, 5)
	visible_message("\icon[src] [src] begins to shimmy and shake out of its old skin.")
	if(molt == 5)
		if(do_after(src, 10 SECONDS, src, FALSE))
			var/mob/living/human/H = new(get_turf(src), /decl/species/mantid::uid)
			set_gyne_lineage(H, get_gyne_lineage(H))
			H.real_name = "[random_id(/decl/species/mantid, 10000, 99999)] [get_gyne_name(H)]"
			H.nutrition = nutrition * 0.25 // Homgry after molt.
			mind.transfer_to(H)
			qdel(src)
			H.visible_message("\icon[H] [H] emerges from its molt as a new alate.")
			new/obj/item/ascent_molt(get_turf(src))
		else
			visible_message("\icon[src] [src] abruptly stops molting.")
		return

	if(do_after(src, 5 SECONDS, src, FALSE))
		var/matrix/M = matrix()
		M.Scale(1 + (molt / 10))
		animate(src, transform = M, time = 2, easing = QUAD_EASING)
		transform = M
		last_molt = world.time
		nutrition = max(0, nutrition - ANYMPH_NUTRITION_MOLT)
		crystal_reserve = max(0, crystal_reserve - ANYMPH_CRYSTAL_MOLT)
		new /obj/item/ascent_molt(get_turf(src))

	else
		visible_message("\icon[src] [src] abruptly stops molting.")