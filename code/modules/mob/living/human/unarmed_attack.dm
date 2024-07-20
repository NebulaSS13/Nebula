//Species unarmed attacks
/decl/natural_attack
	abstract_type = /decl/natural_attack
	var/name
	var/selector_icon_state
	var/attack_verb = list("attacks")	// Empty hand hurt intent verb.
	var/attack_noun = list("fist")
	var/damage = 0						// Extra empty hand attack damage.
	var/attack_sound = "punch"
	var/miss_sound = 'sound/weapons/punchmiss.ogg'
	var/shredding = 0 // Calls the old attack_alien() behavior on objects/mobs when on harm intent.
	var/sharp = 0
	var/edge = 0
	var/delay = 0
	var/deal_halloss
	var/sparring_variant_type = /decl/natural_attack/light_strike
	var/eye_attack_text
	var/eye_attack_text_victim
	var/list/usable_with_limbs = list(BP_L_HAND, BP_R_HAND)
	var/is_starting_default = FALSE

/decl/natural_attack/proc/summarize()
	var/list/usable_limbs = list()
	for(var/limb in usable_with_limbs)
		var/start = copytext(limb, 1, 3)
		if(start == "l_")
			usable_limbs |= "left [copytext(limb, 3)]"
		else if(start == "r_")
			usable_limbs |= "right [copytext(limb, 3)]"
		else
			usable_limbs |= limb
	. = "You can use this attack with your: [english_list(usable_limbs)]."
	if(sharp || edge)
		. += "<br>This attack is sharp and will cause <font color='#ff0000'><b>bleeding</b></font>."
	if(shredding)
		. += "<br>This powerful attack will shred electronics and destroy some structures."

/decl/natural_attack/proc/get_damage_type()
	if(deal_halloss)
		return PAIN
	return BRUTE

/decl/natural_attack/proc/get_damage_flags()
	. |= (sharp && DAM_SHARP)
	. |= (edge && DAM_EDGE)

/decl/natural_attack/proc/padded_by_user_gear(var/mob/living/human/user)
	if(istype(user) && length(usable_with_limbs))
		for(var/limb_slot in usable_with_limbs)
			var/obj/item/gear = user.get_covering_equipped_item_by_zone(limb_slot)
			if(istype(gear) && (gear.item_flags & ITEM_FLAG_PADDED))
				return TRUE
	return FALSE

/decl/natural_attack/proc/resolve_to_soft_variant(var/mob/living/human/user)
	. = src
	if(istype(user) && (user.pulling_punches || padded_by_user_gear(user)))
		var/decl/natural_attack/soft_variant = get_sparring_variant()
		if(soft_variant)
			. = soft_variant

/decl/natural_attack/proc/get_sparring_variant()
	return GET_DECL(sparring_variant_type)

/decl/natural_attack/proc/is_usable(var/mob/living/human/user, var/mob/target, var/zone)
	if(!user.restrained() && !user.incapacitated())
		for(var/etype in usable_with_limbs)
			var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(user, etype)
			if(E)
				return TRUE
	return FALSE

/decl/natural_attack/proc/get_unarmed_damage(mob/living/user, mob/living/victim)
	return damage

// Returns TRUE if further affects should be applied.
/decl/natural_attack/proc/apply_effects(mob/living/user, mob/living/target, attack_damage, zone)

	if(target.stat == DEAD)
		return FALSE

	var/armour = target.get_blocked_ratio(zone, BRUTE, damage = attack_damage)
	if(armour >= 1)
		return FALSE

	var/stun_chance = rand(0, 100)
	if(attack_damage >= 5 && !(target == user) && stun_chance <= attack_damage * 5) // 25% standard chance
		switch(zone) // strong punches can have effects depending on where they hit
			if(BP_HEAD, BP_EYES, BP_MOUTH)
				// Induce blurriness
				target.visible_message("<span class='danger'>[target] looks momentarily disoriented.</span>", "<span class='danger'>You see stars.</span>")
				target.apply_effect(attack_damage*2, EYE_BLUR, armour)
			if(BP_L_ARM, BP_L_HAND, BP_R_ARM, BP_R_HAND)
				var/check_zone = zone
				if(check_zone == BP_L_ARM)
					check_zone = BP_L_HAND
				else if(check_zone == BP_R_ARM)
					check_zone = BP_R_HAND
				var/equipped = target.get_equipped_item(check_zone)
				if(equipped)
					target.visible_message(SPAN_DANGER("\The [equipped] was knocked right out of [target]'s grasp!"))
					target.drop_from_inventory(equipped)
			if(BP_CHEST)
				if(!target.current_posture.prone)
					var/turf/T = get_step(get_turf(target), get_dir(get_turf(user), get_turf(target)))
					if(!T.density)
						step(target, get_dir(get_turf(user), get_turf(target)))
						target.visible_message("<span class='danger'>[pick("[target] was sent flying backward!", "[target] staggers back from the impact!")]</span>")
					if(prob(50))
						target.set_dir(global.reverse_dir[target.dir])
					target.apply_effect(attack_damage * 0.4, WEAKEN, armour)
			if(BP_GROIN)
				var/decl/pronouns/G = target.get_pronouns()
				target.visible_message( \
					SPAN_WARNING("\The [target] looks like [G.he] [G.is] in pain!"), \
					SPAN_WARNING(G.get_message_for_being_kicked_in_the_dick()))
				target.apply_effects(stutter = attack_damage * 2, agony = attack_damage* 3, blocked = armour)
			if(BP_L_LEG, BP_L_FOOT, BP_R_LEG, BP_R_FOOT)
				if(!target.current_posture.prone)
					target.visible_message("<span class='warning'>[target] gives way slightly.</span>")
					target.apply_effect(attack_damage*3, PAIN, armour)
	else if(attack_damage >= 5 && !(target == user) && (stun_chance + attack_damage * 5 >= 100)) // Chance to get the usual throwdown as well (25% standard chance)
		if(!target.current_posture.prone)
			target.visible_message("<span class='danger'>[target] [pick("slumps", "falls", "drops")] down to the ground!</span>")
		else
			target.visible_message("<span class='danger'>[target] has been weakened!</span>")
		target.apply_effect(3, WEAKEN, armour * 100)

	var/obj/item/clothing/C = target.get_covering_equipped_item_by_zone(zone)
	if(istype(C) && prob(10))
		C.leave_evidence(user)

	return TRUE

/decl/natural_attack/proc/show_attack(var/mob/living/human/user, var/mob/living/human/target, var/zone, var/attack_damage)
	var/msg = "\The [user] [pick(attack_verb)] \the [target]"
	var/obj/item/organ/external/affecting = istype(target) && zone && GET_EXTERNAL_ORGAN(target, zone)
	if(affecting)
		msg = "[msg] in the [affecting.name]"
	if(islist(attack_noun) && length(attack_noun))
		msg = "[msg] with their [pick(attack_noun)]"
	if(msg)
		user.visible_message(SPAN_DANGER("[msg]!"))
		playsound(user.loc, attack_sound, 25, 1, -1)

/decl/natural_attack/proc/handle_eye_attack(var/mob/living/human/user, var/mob/living/human/target)
	var/obj/item/organ/internal/eyes = GET_INTERNAL_ORGAN(target, BP_EYES)
	var/decl/pronouns/G = user.get_pronouns()
	if(eyes)
		eyes.take_internal_damage(rand(3,4), 1)
		user.visible_message(SPAN_DANGER("\The [user] jams [G.his] [eye_attack_text] into \the [target]'s [eyes.name]!"))
		if(eyes.can_feel_pain())
			to_chat(target, SPAN_DANGER("You experience immense pain as [eye_attack_text_victim] are jammed into your [eyes.name]!"))
		else
			to_chat(target, SPAN_DANGER("You experience [eye_attack_text_victim] being jammed into your [eyes.name]."))
	else
		var/decl/pronouns/target_gender = target.get_pronouns()
		user.visible_message(SPAN_DANGER("\The [user] attempts to press [G.his] [eye_attack_text] into \the [target]'s eyes, but [target_gender.he] [target_gender.does]n't have any!"))

/decl/natural_attack/proc/damage_flags()
	return (src.sharp? DAM_SHARP : 0)|(src.edge? DAM_EDGE : 0)

/decl/natural_attack/bite
	name = "bite"
	selector_icon_state = "attack_bite"
	attack_verb = list("bit")
	attack_noun = list("mouth")
	attack_sound = 'sound/weapons/bite.ogg'
	shredding = 0
	damage = 0
	sharp = 0
	edge = 0
	usable_with_limbs = list(BP_HEAD)

/decl/natural_attack/bite/sharp
	attack_verb = list("bit", "chomped")
	sharp = 1
	edge = 1

/decl/natural_attack/bite/is_usable(var/mob/living/human/user, var/mob/living/human/target, var/zone)

	if(user.get_item_blocking_speech())
		return 0
	for(var/slot in list(slot_wear_mask_str, slot_head_str, slot_wear_suit_str))
		var/obj/item/clothing/C = user.get_equipped_item(slot)
		if(istype(C) && (C.body_parts_covered & SLOT_FACE) && (C.item_flags & ITEM_FLAG_THICKMATERIAL))
			return 0 //prevent biting through a space helmet or similar
	if (user == target && (zone == BP_HEAD || zone == BP_EYES || zone == BP_MOUTH))
		return 0 //how do you bite yourself in the head?
	return 1

/decl/natural_attack/punch
	name = "punch"
	selector_icon_state = "attack_punch"
	attack_verb = list("punched")
	attack_noun = list("fist")
	eye_attack_text = "fingers"
	eye_attack_text_victim = "digits"
	damage = 0
	sparring_variant_type = /decl/natural_attack/light_strike/punch
	is_starting_default = TRUE

/decl/natural_attack/punch/show_attack(var/mob/living/human/user, var/mob/living/human/target, var/zone, var/attack_damage)

	var/obj/item/organ/external/affecting = istype(target) && zone && GET_EXTERNAL_ORGAN(target, zone)
	if(!affecting)
		return ..()

	attack_damage = clamp(attack_damage, 1, 5) // We expect damage input of 1 to 5 for this proc. But we leave this check juuust in case.

	if(target == user)
		user.visible_message("<span class='danger'>[user] [pick(attack_verb)] \himself in \the [affecting]!</span>")
		return 0

	target.update_personal_goal(/datum/goal/achievement/fistfight, TRUE)
	user.update_personal_goal(/datum/goal/achievement/fistfight, TRUE)

	var/decl/pronouns/user_gender =   user.get_pronouns()
	var/decl/pronouns/target_gender = target.get_pronouns()
	var/attack_string
	if(!target.current_posture.prone)
		switch(zone)
			if(BP_HEAD, BP_MOUTH, BP_EYES)
				// ----- HEAD ----- //
				switch(attack_damage)
					if(1 to 2)
						attack_string = "slapped \the [target] across [target_gender.his] cheek"
					if(3 to 4)
						user.visible_message(pick(
							80; attack_string = "[pick(attack_verb)] \the [target] in the head",
							20; attack_string = "struck \the [target] in the head[pick("", " with a closed fist")]",
							50; attack_string = "threw a hook against \the [target]'s head"
							))
					if(5)
						user.visible_message(pick(
							10; attack_string = "gave \the [target] a solid slap across [target_gender.his] face",
							90; attack_string = "smashed [user_gender.his] [pick(attack_noun)] into \the [target]'s [pick("[affecting.name]", "face", "jaw")]"
							))
			else
				// ----- BODY ----- //
				switch(attack_damage)
					if(1 to 2)
						attack_string = "threw a glancing punch at [target]'s [affecting.name]"
					if(1 to 4)
						attack_string = "[pick(attack_verb)] [target] in \the [affecting]"
					if(5)
						attack_string = "smashed [user_gender.his] [pick(attack_noun)] into [target]'s [affecting.name]"
	else
		//why do we have a separate set of verbs for lying targets?
		attack_string = "[pick("punched", "threw a punch at", "struck", "slammed their [pick(attack_noun)] into")] \the [target]'s [affecting.name]"

	if(attack_string)
		user.visible_message(SPAN_DANGER("\The [user] [attack_string]!"))

/decl/natural_attack/kick
	name = "kick"
	selector_icon_state = "attack_kick"
	attack_verb = list("struck")
	attack_noun = list("foot", "knee")
	attack_sound = "swing_hit"
	damage = 0
	usable_with_limbs = list(BP_L_FOOT, BP_R_FOOT)
	sparring_variant_type = /decl/natural_attack/light_strike/kick

/decl/natural_attack/kick/is_usable(var/mob/living/human/user, var/mob/living/human/target, var/zone)
	if(zone == BP_HEAD || zone == BP_EYES || zone == BP_MOUTH)
		zone = BP_CHEST
	. = ..()

/decl/natural_attack/kick/get_unarmed_damage(mob/living/user, mob/living/victim)
	var/obj/item/clothing/shoes = user.get_equipped_item(slot_shoes_str)
	if(!istype(shoes))
		return damage
	return damage + (shoes ? shoes.get_attack_force(user) : 0)

/decl/natural_attack/kick/show_attack(var/mob/living/human/user, var/mob/living/human/target, var/zone, var/attack_damage)

	var/obj/item/organ/external/affecting = istype(target) && zone && GET_EXTERNAL_ORGAN(target, zone)
	if(!affecting)
		return ..()

	attack_damage = clamp(attack_damage, 1, 5)
	switch(attack_damage)
		if(1 to 2)	user.visible_message("<span class='danger'>[user] threw [target] a glancing [pick(attack_noun)] to \the [affecting]!</span>") //it's not that they're kicking lightly, it's that the kick didn't quite connect
		if(3 to 4)	user.visible_message("<span class='danger'>[user] [pick(attack_verb)] [target] in \the [affecting]!</span>")
		if(5)		user.visible_message("<span class='danger'>[user] landed a strong [pick(attack_noun)] against [target]'s [affecting.name]!</span>")

/decl/natural_attack/stomp
	name = "stomp"
	selector_icon_state = "attack_stomp"
	attack_verb = list("stomped on")
	attack_noun = list("foot")
	attack_sound = "swing_hit"
	damage = 0
	usable_with_limbs = list(BP_L_FOOT, BP_R_FOOT)

/decl/natural_attack/stomp/is_usable(var/mob/living/human/user, var/mob/living/human/target, var/zone)
	if(!istype(target))
		return FALSE
	if (!user.current_posture.prone && (target.current_posture.prone || (zone in list(BP_L_FOOT, BP_R_FOOT))))
		if((user in target.grabbed_by) && target.current_posture.prone)
			return FALSE
		for(var/foot_tag in list(BP_L_FOOT, BP_R_FOOT))
			if(GET_EXTERNAL_ORGAN(user, foot_tag))
				return TRUE
	return FALSE

/decl/natural_attack/stomp/get_unarmed_damage(mob/living/user, mob/living/victim)
	var/obj/item/clothing/shoes = user.get_equipped_item(slot_shoes_str)
	return damage + (shoes ? shoes.get_attack_force(user) : 0)

/decl/natural_attack/stomp/show_attack(var/mob/living/human/user, var/mob/living/human/target, var/zone, var/attack_damage)

	var/obj/item/organ/external/affecting = istype(target) && zone && GET_EXTERNAL_ORGAN(target, zone)
	if(!affecting)
		return ..()

	var/obj/item/clothing/shoes = user.get_equipped_item(slot_shoes_str)
	attack_damage = clamp(attack_damage, 1, 5)

	var/shoe_text = shoes ? copytext(shoes.name, 1, -1) : "foot"
	var/decl/pronouns/G = user.get_pronouns()
	var/attack_string
	switch(attack_damage)
		if(1 to 4)
			attack_string = pick(
				"stomped on \the [target]'s [affecting.name][pick("", "with their [shoe_text]")]",
				"stomped [G.his] [shoe_text] down on \the [target]'s [affecting.name]")
		if(5)
			attack_string = pick(
				"stomped down hard on \the [target]'s [affecting.name][pick("", "with their [shoe_text]")]",
				"slammed [G.his] [shoe_text] down on \the [target]'s [affecting.name]")
	if(attack_string)
		user.visible_message(SPAN_DANGER("\The [user] [attack_string]!"))

/decl/natural_attack/light_strike
	name = "light strike"
	deal_halloss = 3
	selector_icon_state = "attack_light_strike"
	attack_noun = list("limb")
	attack_verb = list("tapped", "lightly struck")
	shredding = 0
	damage = 0
	sharp = 0
	edge = 0
	attack_sound = "light_strike"

/decl/natural_attack/light_strike/punch
	name = "light punch"
	selector_icon_state = "attack_light_punch"
	attack_noun = list("fist")
	usable_with_limbs = list(BP_L_HAND, BP_R_HAND)

/decl/natural_attack/light_strike/kick
	name = "light kick"
	selector_icon_state = "attack_light_kick"
	attack_noun = list("foot")
	usable_with_limbs = list(BP_L_FOOT, BP_R_FOOT)

/decl/natural_attack/light_strike/kick/is_usable(var/mob/living/human/user, var/mob/living/human/target, var/zone)
	if(zone == BP_HEAD || zone == BP_EYES || zone == BP_MOUTH)
		zone = BP_CHEST
	. = ..()

/decl/natural_attack/forelimb_slash
	name = "forelimb slash"
	selector_icon_state = "attack_slash"
	attack_verb = list("mauled", "slashed", "struck", "pierced")
	attack_noun = list("forelimb")
	damage = 8
	shredding = 1
	sharp = 1
	edge = 1
	delay = 20
	eye_attack_text = "a forelimb"
	eye_attack_text_victim = "a forelimb"
	usable_with_limbs = list(BP_L_HAND, BP_R_HAND)
