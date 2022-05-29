/obj/structure/fitness
	anchored = 1
	var/being_used = 0

/obj/structure/fitness/punchingbag
	name = "punching bag"
	desc = "A punching bag."
	icon_state = "punchingbag"
	icon = 'icons/obj/structures/punching_bag.dmi'
	density = 1
	var/list/hit_message = list("hit", "punch", "kick", "robust")

/obj/structure/fitness/punchingbag/attack_hand(mob/user)
	if(!ishuman(user))
		..()
		return
	var/mob/living/carbon/human/H = user
	var/synth = H.isSynthetic()
	if(!synth && H.nutrition < 20)
		to_chat(H, SPAN_WARNING("You [synth ? "need more energy" : "are too tired"] to use the punching bag. Go [synth ? "recharge" : "eat something"]."))
	else
		if(H.a_intent == I_HURT)
			H.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			flick("[icon_state]_hit", src)
			playsound(src.loc, 'sound/effects/woodhit.ogg', 25, 1, -1)
			H.do_attack_animation(src)
			if(!synth)
				H.adjust_nutrition(-(5 * DEFAULT_HUNGER_FACTOR))
				H.adjust_hydration(-(5 * DEFAULT_THIRST_FACTOR))
			to_chat(H, SPAN_NOTICE("You [pick(hit_message)] \the [src]."))

/obj/structure/fitness/weightlifter
	name = "weightlifting machine"
	desc = "A machine used to lift weights."
	icon_state = "weightlifter"
	icon = 'icons/obj/structures/weightlifter.dmi'
	var/weight = 1
	var/max_weight = 5
	var/list/success_message = list("with great effort", "straining hard", "without any trouble", "with ease")
	var/list/fail_message = list(", lifting them part of the way and then letting them drop", ", unable to even budge them")

/obj/structure/fitness/weightlifter/attackby(obj/item/W, mob/user)
	if(IS_WRENCH(W))
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 75, 1)
		weight = (weight % max_weight) + 1
		to_chat(user, "You set the machine's weight level to [weight].")

/obj/structure/fitness/weightlifter/attack_hand(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/synth = H.isSynthetic()
	if(H.loc != src.loc)
		to_chat(H, SPAN_WARNING("You must be on the weight machine to use it."))
		return
	if(!synth && H.nutrition < 50)
		to_chat(H, SPAN_WARNING("You need more energy to lift weights. Go eat something."))
		return
	if(being_used)
		to_chat(H, SPAN_WARNING("The weight machine is already in use by somebody else."))
		return
	else
		being_used = 1
		playsound(src.loc, 'sound/effects/weightlifter.ogg', 50, 1)
		H.set_dir(SOUTH)
		flick("[icon_state]_[weight]", src)
		if(do_after(H, 20 + (weight * 10)))
			playsound(src.loc, 'sound/effects/weightdrop.ogg', 25, 1)
			var/skill = max_weight * H.get_skill_value(SKILL_HAULING)/SKILL_MAX
			var/message
			if(skill < weight)
				if(weight - skill > max_weight/2)
					if(prob(50))
						message = ", getting hurt in the process"
						H.apply_damage(5)
					else
						message = "; this does not look safe"
				else
					message = fail_message[min(1 + round(weight - skill), fail_message.len)]
				H.visible_message( \
					SPAN_NOTICE("\The [H] fails to lift the weights[message]."), \
					SPAN_NOTICE("You fail to lift the weights[message]."))
			else
				if(!synth)
					var/adj_weight = weight * 5
					H.adjust_nutrition(-(adj_weight * DEFAULT_HUNGER_FACTOR))
					H.adjust_hydration(-(adj_weight * DEFAULT_THIRST_FACTOR))
				message = success_message[min(1 + round(skill - weight), fail_message.len)]
				H.visible_message( \
					SPAN_NOTICE("\The [H] lift\s the weights [message]."), \
					SPAN_NOTICE("You lift the weights [message]."))
			being_used = 0
		else
			to_chat(H, SPAN_NOTICE("Against your previous judgement, perhaps working out is not for you."))
			being_used = 0
