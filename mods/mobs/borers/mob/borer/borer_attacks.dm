/mob/living/simple_animal/borer/ResolveUnarmedAttack(atom/A)

	if(host)
		return TRUE // We cannot click things outside of our host.

	if(!isliving(A) || !check_intent(I_FLAG_GRAB) || stat)
		return ..()

	if(!can_use_borer_ability(requires_host_value = FALSE, check_last_special = FALSE))
		return TRUE

	var/mob/living/victim = A
	if(victim.has_brain_worms())
		to_chat(src, SPAN_WARNING("You cannot take a host who already has a passenger!"))
		return TRUE
	var/obj/item/organ/external/limb = GET_EXTERNAL_ORGAN(victim, BP_HEAD)
	if(!limb)
		to_chat(src, SPAN_WARNING("\The [victim] does not have anatomy compatible with your lifecycle!"))
		return TRUE
	if(BP_IS_PROSTHETIC(limb))
		to_chat(src, SPAN_WARNING("\The [victim]'s head is prosthetic and cannot support your lifecycle!"))
		return TRUE
	if(!victim.should_have_organ(BP_BRAIN))
		to_chat(src, SPAN_WARNING("\The [victim] does not seem to have a brain cavity to enter."))
		return TRUE
	if(victim.check_head_coverage())
		to_chat(src, SPAN_WARNING("You cannot get through that host's protective gear."))
		return TRUE

	to_chat(victim, SPAN_WARNING("Something slimy begins probing at the opening of your ear canal..."))
	to_chat(src, SPAN_NOTICE("You slither up [victim] and begin probing at their ear canal..."))
	set_ability_cooldown(5 SECONDS)

	if(!do_after(src, 3 SECONDS, victim) || host || GET_EXTERNAL_ORGAN(victim, BP_HEAD) != limb || BP_IS_PROSTHETIC(limb) || victim.check_head_coverage())
		return TRUE

	to_chat(src, SPAN_NOTICE("You wiggle into \the [victim]'s ear."))
	if(victim.stat == CONSCIOUS)
		to_chat(victim, SPAN_DANGER("Something wet, cold and slimy wiggles into your ear!"))

	host = victim
	host.status_flags |= PASSEMOTES
	forceMove(host)

	var/datum/hud/animal/borer/borer_hud = hud_used
	if(istype(borer_hud))
		for(var/obj/thing in borer_hud.borer_hud_elements)
			thing.alpha =        255
			thing.set_invisibility(INVISIBILITY_NONE)

	//Update their traitor status.
	if(host.mind && !neutered)
		var/decl/special_role/borer/borers = GET_DECL(/decl/special_role/borer)
		borers.add_antagonist_mind(host.mind, 1, borers.faction_name, borers.faction_welcome)

	if(ishuman(host))
		var/obj/item/organ/internal/I = GET_INTERNAL_ORGAN(victim, BP_BRAIN)
		if(!I) // No brain organ, so the borer moves in and replaces it permanently.
			replace_brain()
		else if(limb) // If they're in normally, implant removal can get them out.
			LAZYDISTINCTADD(limb.implants, src)
	return TRUE
