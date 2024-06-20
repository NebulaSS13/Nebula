var/global/list/slime_pain_messages = list(
	"You can feel your body becoming weak!",
	"You feel like you're about to die!",
	"You feel every part of your body screaming in agony!",
	"A low, rolling pain passes through your body!",
	"Your body feels as if it's falling apart!",
	"You feel extremely weak!",
	"A sharp, deep pain bathes every inch of your body!"
)

// This proc is called when a slime is feeding on the mob, and the mob is
// over a certain cloneloss threshold. It will generally destroy the mob,
// but in the case of humans will dissolve a random limb, etc.
// The return value is the amount of nutrition provided to the slime.
/mob/living/proc/eaten_by_slime()
	if(QDELETED(src))
		return
	new /obj/effect/decal/cleanable/mucus(get_turf(src))
	var/remains_type = get_remains_type()
	if(remains_type)
		new remains_type(get_turf(src))
	dump_contents()
	qdel(src)
	. = rand(2,3)

/mob/living/human/eaten_by_slime()
	var/list/limbs = get_external_organs()
	if(LAZYLEN(limbs) > 1)
		var/obj/item/organ/external/E = pick(limbs)
		if(E.limb_flags & ORGAN_FLAG_CAN_AMPUTATE)
			E.dismember(FALSE, DISMEMBER_METHOD_ACID)
			. = 1
	if((QDELETED(src) || LAZYLEN(limbs) <= 1))
		. = ..()

// Simple check to ensure a target is currently being fed on.
/mob/proc/currently_being_eaten_by_a_slime(var/mob/living/slime/feeder_check)
	for(var/mob/living/slime/M in range(1, src))
		if(feeder_check != M && M.feeding_on?.resolve() == src)
			return M

/mob/can_enter_cryopod(var/mob/user)
	. = ..()
	if(. && currently_being_eaten_by_a_slime())
		if(src == user)
			to_chat(src, SPAN_WARNING("You cannot use that, as you're too busy getting your life sucked out of you."))
		else
			to_chat(user, SPAN_WARNING("\The [user] cannot use that, as they are too busy getting the life sucked out of them."))
		return FALSE

// Handle cosmetic effects (currently) from being eaten by a slime, mostly pain-related.
/mob/living/proc/handle_additional_slime_effects()
	if(can_feel_pain())
		to_chat(src, SPAN_DANGER(pick(global.slime_pain_messages)))

/mob/living/human/handle_additional_slime_effects()
	custom_pain(pick(global.slime_pain_messages),100)

// Called by a feeding slime on the victim.
// The return value is the nutrition provided to the slime.
/mob/living/proc/slime_feed_act(var/mob/living/slime/attacker)
	var/protection = (1 - get_blocked_ratio(null, TOX, damage_flags = DAM_DISPERSED | DAM_BIO))
	take_damage((attacker.is_adult ? 10 : 5) * protection, CLONE)
	take_damage(1 * protection, TOX)
	if(current_health <= 0)
		take_damage(1 * protection, TOX)
	if(prob(15) && client)
		handle_additional_slime_effects()
	. = 15 * protection
	if(stat == DEAD || get_damage(CLONE) >= get_max_health())
		eaten_by_slime()
