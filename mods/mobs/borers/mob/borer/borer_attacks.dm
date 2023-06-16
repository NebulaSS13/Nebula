/mob/living/simple_animal/borer/UnarmedAttack(atom/A, proximity)

	if(!isliving(A) || a_intent != I_GRAB)
		return ..()

	if(host || !can_use_borer_ability(requires_host_value = FALSE, check_last_special = FALSE))
		return

	var/mob/living/M = A
	if(M.has_brain_worms())
		to_chat(src, SPAN_WARNING("You cannot take a host who already has a passenger!"))
		return

	//TODO generalize borers to enter any mob. Until then, return early.
	if(!ishuman(M))
		to_chat(src, SPAN_WARNING("This creature is not sufficiently intelligent to host you."))
		return
	// end TODO

	var/mob/living/carbon/human/H = M
	var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(H, BP_HEAD)
	if(!E)
		to_chat(src, SPAN_WARNING("\The [H] does not have a head!"))
		return
	if(!H.should_have_organ(BP_BRAIN))
		to_chat(src, SPAN_WARNING("\The [H] does not seem to have a brain cavity to enter."))
		return
	if(H.check_head_coverage())
		to_chat(src, SPAN_WARNING("You cannot get through that host's protective gear."))
		return

	to_chat(M, SPAN_WARNING("Something slimy begins probing at the opening of your ear canal..."))
	to_chat(src, SPAN_NOTICE("You slither up [M] and begin probing at their ear canal..."))
	set_special_ability_cooldown(5 SECONDS)

	if(!do_after(src, 3 SECONDS, M))
		return

	to_chat(src, SPAN_NOTICE("You wiggle into \the [M]'s ear."))
	if(M.stat == CONSCIOUS)
		to_chat(M, SPAN_DANGER("Something wet, cold and slimy wiggles into your ear!"))

	host = M
	host.status_flags |= PASSEMOTES
	forceMove(host)

	if(hud_used)
		hud_used.show_ability_hud()

	//Update their traitor status.
	if(host.mind && !neutered)
		var/decl/special_role/borer/borers = GET_DECL(/decl/special_role/borer)
		borers.add_antagonist_mind(host.mind, 1, borers.faction_name, borers.faction_welcome)

	if(ishuman(host))
		var/obj/item/organ/internal/I = GET_INTERNAL_ORGAN(H, BP_BRAIN)
		if(!I) // No brain organ, so the borer moves in and replaces it permanently.
			replace_brain()
		else if(E) // If they're in normally, implant removal can get them out.
			LAZYDISTINCTADD(E.implants, src)
