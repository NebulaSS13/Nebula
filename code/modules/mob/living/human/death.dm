/mob/living/human/gib(do_gibs = TRUE)
	var/turf/my_turf = get_turf(src)
	. = ..()
	if(.)
		for(var/obj/item/organ/I in get_internal_organs())
			remove_organ(I)
			if(!QDELETED(I) && isturf(my_turf))
				I.dropInto(my_turf)
				I.throw_at(get_edge_target_turf(I, pick(global.alldirs)), rand(1,3), THROWFORCE_GIBS)
		for(var/obj/item/organ/external/E in get_external_organs())
			if(!E.parent_organ)
				continue //Skip root organ
			E.dismember(FALSE, DISMEMBER_METHOD_EDGE, TRUE, ignore_last_organ = TRUE)
			if(my_turf)
				E.dropInto(my_turf)
				E.throw_at(get_edge_target_turf(E, pick(global.alldirs)), rand(1,3), THROWFORCE_GIBS)

/mob/living/human/get_death_message(gibbed)
	if(get_config_value(/decl/config/toggle/health_show_human_death_message))
		return species.get_species_death_message(src) || "seizes up and falls limp..."
	return ..()

/mob/living/human/death(gibbed)
	if(!(. = ..()))
		return

	BITSET(hud_updateflag, HEALTH_HUD)
	BITSET(hud_updateflag, STATUS_HUD)
	BITSET(hud_updateflag, LIFE_HUD)

	//Handle species-specific deaths.
	handle_hud_list()
	if(!gibbed)
		set_tail_animation_state(null, TRUE)
		handle_organs()
		if(species.death_sound)
			playsound(loc, species.death_sound, 80, 1, 1)
	if(SSticker.mode)
		SSticker.mode.check_win()
	species.handle_death(src)

/mob/living/human/physically_destroyed(var/skip_qdel, var/droplimb_type = DISMEMBER_METHOD_BLUNT)
	for(var/obj/item/organ/external/limb in get_external_organs())
		if(!limb.parent_organ) // don't dismember root
			continue
		limb.dismember(TRUE, droplimb_type, TRUE, TRUE)
	dump_contents()
	if(!skip_qdel && !QDELETED(src))
		qdel(src)
