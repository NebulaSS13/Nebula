/datum/ability_handler/psionics/cancel()
	sound_to(owner, sound('sound/effects/psi/power_fail.ogg'))
	return ..()

/datum/ability_handler/psionics/proc/stunned(var/amount)
	var/old_stun = stun
	stun = max(stun, amount)
	if(amount && !old_stun)
		to_chat(owner, "<span class='danger'>Your concentration has been shattered! You cannot focus your psi power!</span>")
		ui.update_icon()
	cancel()

/datum/ability_handler/psionics/proc/get_armour(var/armourtype)
	if(use_psi_armour && can_use_passive())
		return round(clamp(clamp(4 * rating, 0, 20) * get_rank(SSpsi.armour_faculty_by_type[armourtype]), 0, 100) * (stamina/max_stamina))
	else
		return 0

/datum/ability_handler/psionics/proc/get_rank(var/faculty)
	return LAZYACCESS(ranks, faculty)

/datum/ability_handler/psionics/proc/set_rank(var/faculty, var/rank, var/defer_update, var/temporary)
	if(get_rank(faculty) != rank)
		LAZYSET(ranks, faculty, rank)
		if(!temporary)
			LAZYSET(base_ranks, faculty, rank)
		if(!defer_update)
			update()

/datum/ability_handler/psionics/proc/set_cooldown(var/value)
	next_power_use = world.time + value
	ui.update_icon()

/datum/ability_handler/psionics/proc/can_use_passive()
	return (owner.stat == CONSCIOUS && !suppressed && !stun)

/datum/ability_handler/psionics/proc/can_use(var/incapacitation_flags)
	return (owner.stat == CONSCIOUS && (!incapacitation_flags || !owner.incapacitated(incapacitation_flags)) && !suppressed && !stun && world.time >= next_power_use)

/datum/ability_handler/psionics/proc/spend_power(var/value = 0, var/check_incapacitated, var/backblast_on_failure = TRUE)
	. = FALSE
	if(isnull(check_incapacitated))
		check_incapacitated = (INCAPACITATION_STUNNED|INCAPACITATION_KNOCKOUT)
	if(can_use(check_incapacitated))
		value = max(1, ceil(value * cost_modifier))
		if(value <= stamina)
			stamina -= value
			ui.update_icon()
			. = TRUE
		else
			if(backblast_on_failure)
				backblast(abs(stamina - value))
			stamina = 0
			. = FALSE
		ui.update_icon()

/datum/ability_handler/psionics/proc/spend_power_armor(var/value = 0)
	armor_cost += value

/datum/ability_handler/psionics/proc/hide_auras()
	if(owner.client)
		for(var/thing in SSpsi.all_aura_images)
			owner.client.images -= thing

/datum/ability_handler/psionics/proc/show_auras()
	if(owner.client)
		for(var/image/I in SSpsi.all_aura_images)
			owner.client.images |= I

/datum/ability_handler/psionics/proc/backblast(var/value)

	// Can't backblast if you're controlling your power.
	if(!owner || suppressed)
		return FALSE

	sound_to(owner, sound('sound/effects/psi/power_feedback.ogg'))
	to_chat(owner, "<span class='danger'><font size=3>Wild energistic feedback blasts across your psyche!</font></span>")
	stunned(value * 2)
	set_cooldown(value * 100)

	if(prob(value*10))
		owner.emote(/decl/emote/audible/scream)

	// Your head asplode.
	owner.take_damage(value, BRAIN)
	if(ishuman(owner))
		var/mob/living/human/pop = owner
		if(pop.should_have_organ(BP_BRAIN))
			var/obj/item/organ/internal/sponge = GET_INTERNAL_ORGAN(pop, BP_BRAIN)
			if(sponge && sponge.damage >= sponge.max_damage)
				var/obj/item/organ/external/affecting = GET_EXTERNAL_ORGAN(pop, sponge.parent_organ)
				if(affecting)
					affecting.dismember(0, DISMEMBER_METHOD_BLUNT)
					if(sponge)
						qdel(sponge)

/datum/ability_handler/psionics/proc/reset()
	aura_color = initial(aura_color)
	ranks = base_ranks ? base_ranks.Copy() : null
	max_stamina = initial(max_stamina)
	stamina = min(stamina, max_stamina)
	cancel()
	update()
