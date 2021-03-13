var/global/list/sparring_attack_cache = list()

//Species unarmed attacks
/decl/natural_attack
	var/name
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

/decl/natural_attack/proc/padded_by_user_gear(var/mob/living/carbon/human/user)
	if(istype(user) && length(usable_with_limbs))
		for(var/bp in usable_with_limbs)
			var/obj/item/gear = user.get_covering_equipped_item_by_zone(bp)
			if(istype(gear) && (gear.item_flags & ITEM_FLAG_PADDED))
				return TRUE
	return FALSE

/decl/natural_attack/proc/resolve_to_soft_variant(var/mob/living/carbon/human/user)
	. = src
	if(istype(user) && (user.pulling_punches || padded_by_user_gear(user)))
		var/decl/natural_attack/soft_variant = get_sparring_variant()
		if(soft_variant)
			. = soft_variant

/decl/natural_attack/proc/get_sparring_variant()
	return sparring_variant_type && GET_DECL(sparring_variant_type)

/decl/natural_attack/proc/is_usable(var/mob/living/carbon/human/user, var/mob/target, var/zone)
	if(!user.restrained() && !user.incapacitated())
		for(var/etype in usable_with_limbs)
			var/obj/item/organ/external/E = user.organs_by_name[etype]
			if(E && !E.is_stump())
				return TRUE
	return FALSE

/decl/natural_attack/proc/get_unarmed_damage()
	return damage

/decl/natural_attack/proc/apply_effects(var/mob/living/carbon/human/user,var/mob/living/carbon/human/target,var/attack_damage,var/zone)

	if(target.stat == DEAD)
		return

	var/stun_chance = rand(0, 100)
	var/armour = target.get_blocked_ratio(zone, BRUTE, damage = attack_damage)

	if(attack_damage >= 5 && armour < 1 && !(target == user) && stun_chance <= attack_damage * 5) // 25% standard chance
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
				var/datum/inventory_slot/inv_slot = LAZYACCESS(target.held_item_slots, check_zone)
				if(inv_slot?.holding)
					// Disarm left hand
					target.visible_message(SPAN_DANGER("\The [inv_slot.holding] was knocked right out of [target]'s grasp!"))
					target.drop_from_inventory(inv_slot.holding)
			if(BP_CHEST)
				if(!target.lying)
					var/turf/T = get_step(get_turf(target), get_dir(get_turf(user), get_turf(target)))
					if(!T.density)
						step(target, get_dir(get_turf(user), get_turf(target)))
						target.visible_message("<span class='danger'>[pick("[target] was sent flying backward!", "[target] staggers back from the impact!")]</span>")
					if(prob(50))
						target.set_dir(GLOB.reverse_dir[target.dir])
					target.apply_effect(attack_damage * 0.4, WEAKEN, armour)
			if(BP_GROIN)
				target.visible_message("<span class='warning'>[target] looks like \he is in pain!</span>", "<span class='warning'>[(target.gender=="female") ? "Oh god that hurt!" : "Oh no, not your[pick("testicles", "crown jewels", "clockweights", "family jewels", "marbles", "bean bags", "teabags", "sweetmeats", "goolies")]!"]</span>")
				target.apply_effects(stutter = attack_damage * 2, agony = attack_damage* 3, blocked = armour)
			if(BP_L_LEG, BP_L_FOOT, BP_R_LEG, BP_R_FOOT)
				if(!target.lying)
					target.visible_message("<span class='warning'>[target] gives way slightly.</span>")
					target.apply_effect(attack_damage*3, PAIN, armour)
	else if(attack_damage >= 5 && !(target == user) && (stun_chance + attack_damage * 5 >= 100) && armour < 1) // Chance to get the usual throwdown as well (25% standard chance)
		if(!target.lying)
			target.visible_message("<span class='danger'>[target] [pick("slumps", "falls", "drops")] down to the ground!</span>")
		else
			target.visible_message("<span class='danger'>[target] has been weakened!</span>")
		target.apply_effect(3, WEAKEN, armour * 100)

	var/obj/item/clothing/C = target.get_covering_equipped_item_by_zone(zone)
	if(istype(C) && prob(10))
		C.leave_evidence(user)

/decl/natural_attack/proc/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	var/msg = "\The [user] [pick(attack_verb)] \the [target]"
	var/obj/item/organ/external/affecting = istype(target) && zone && target.get_organ(zone)
	if(affecting)
		msg = "[msg] in the [affecting.name]"
	if(islist(attack_noun) && length(attack_noun))
		msg = "[msg] with their [pick(attack_noun)]"
	if(msg)
		user.visible_message(SPAN_DANGER("[msg]!"))
		playsound(user.loc, attack_sound, 25, 1, -1)

/decl/natural_attack/proc/handle_eye_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target)
	var/obj/item/organ/internal/eyes/eyes = target.get_internal_organ(BP_EYES)
	if(eyes)
		eyes.take_internal_damage(rand(3,4), 1)
		user.visible_message("<span class='danger'>[user] presses \his [eye_attack_text] into [target]'s [eyes.name]!</span>")
		var/eye_pain = eyes.can_feel_pain()
		to_chat(target, "<span class='danger'>You experience[(eye_pain) ? "" : " immense pain as you feel" ] [eye_attack_text_victim] being pressed into your [eyes.name][(eye_pain)? "." : "!"]</span>")
		return
	user.visible_message("<span class='danger'>[user] attempts to press \his [eye_attack_text] into [target]'s eyes, but they don't have any!</span>")

/decl/natural_attack/proc/damage_flags()
	return (src.sharp? DAM_SHARP : 0)|(src.edge? DAM_EDGE : 0)

/decl/natural_attack/bite
	name = "bite"
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

/decl/natural_attack/bite/is_usable(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone)

	if(user.is_muzzled())
		return 0
	for(var/obj/item/clothing/C in list(user.wear_mask, user.head, user.wear_suit))
		if(C && (C.body_parts_covered & SLOT_FACE) && (C.item_flags & ITEM_FLAG_THICKMATERIAL))
			return 0 //prevent biting through a space helmet or similar
	if (user == target && (zone == BP_HEAD || zone == BP_EYES || zone == BP_MOUTH))
		return 0 //how do you bite yourself in the head?
	return 1

/decl/natural_attack/punch
	name = "punch"
	attack_verb = list("punched")
	attack_noun = list("fist")
	eye_attack_text = "fingers"
	eye_attack_text_victim = "digits"
	damage = 0
	sparring_variant_type = /decl/natural_attack/light_strike/punch
	is_starting_default = TRUE

/decl/natural_attack/punch/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)

	var/obj/item/organ/external/affecting = istype(target) && zone && target.get_organ(zone)
	if(!affecting)
		return ..()

	var/organ = affecting.name

	attack_damage = Clamp(attack_damage, 1, 5) // We expect damage input of 1 to 5 for this proc. But we leave this check juuust in case.

	if(target == user)
		user.visible_message("<span class='danger'>[user] [pick(attack_verb)] \himself in the [organ]!</span>")
		return 0

	target.update_personal_goal(/datum/goal/achievement/fistfight, TRUE)
	user.update_personal_goal(/datum/goal/achievement/fistfight, TRUE)

	if(!target.lying)
		switch(zone)
			if(BP_HEAD, BP_MOUTH, BP_EYES)
				// ----- HEAD ----- //
				switch(attack_damage)
					if(1 to 2)
						user.visible_message("<span class='danger'>[user] slapped [target] across \his cheek!</span>")
					if(3 to 4)
						user.visible_message(pick(
							80; "<span class='danger'>[user] [pick(attack_verb)] [target] in the head!</span>",
							20; "<span class='danger'>[user] struck [target] in the head[pick("", " with a closed fist")]!</span>",
							50; "<span class='danger'>[user] threw a hook against [target]'s head!</span>"
							))
					if(5)
						user.visible_message(pick(
							10; "<span class='danger'>[user] gave [target] a solid slap across \his face!</span>",
							90; "<span class='danger'>[user] smashed \his [pick(attack_noun)] into [target]'s [pick("[organ]", "face", "jaw")]!</span>"
							))
			else
				// ----- BODY ----- //
				switch(attack_damage)
					if(1 to 2)	user.visible_message("<span class='danger'>[user] threw a glancing punch at [target]'s [organ]!</span>")
					if(1 to 4)	user.visible_message("<span class='danger'>[user] [pick(attack_verb)] [target] in \his [organ]!</span>")
					if(5)		user.visible_message("<span class='danger'>[user] smashed \his [pick(attack_noun)] into [target]'s [organ]!</span>")
	else
		user.visible_message("<span class='danger'>[user] [pick("punched", "threw a punch at", "struck", "slammed their [pick(attack_noun)] into")] [target]'s [organ]!</span>") //why do we have a separate set of verbs for lying targets?

/decl/natural_attack/kick
	name = "kick"
	attack_verb = list("struck")
	attack_noun = list("foot", "knee")
	attack_sound = "swing_hit"
	damage = 0
	usable_with_limbs = list(BP_L_FOOT, BP_R_FOOT)
	sparring_variant_type = /decl/natural_attack/light_strike/kick

/decl/natural_attack/kick/is_usable(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone)
	if(zone == BP_HEAD || zone == BP_EYES || zone == BP_MOUTH)
		zone = BP_CHEST
	. = ..()

/decl/natural_attack/kick/get_unarmed_damage(var/mob/living/carbon/human/user)
	var/obj/item/clothing/shoes = user.shoes
	if(!istype(shoes))
		return damage
	return damage + (shoes ? shoes.force : 0)

/decl/natural_attack/kick/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)

	var/obj/item/organ/external/affecting = istype(target) && zone && target.get_organ(zone)
	if(!affecting)
		return ..()

	var/organ = affecting.name
	attack_damage = Clamp(attack_damage, 1, 5)
	switch(attack_damage)
		if(1 to 2)	user.visible_message("<span class='danger'>[user] threw [target] a glancing [pick(attack_noun)] to the [organ]!</span>") //it's not that they're kicking lightly, it's that the kick didn't quite connect
		if(3 to 4)	user.visible_message("<span class='danger'>[user] [pick(attack_verb)] [target] in \his [organ]!</span>")
		if(5)		user.visible_message("<span class='danger'>[user] landed a strong [pick(attack_noun)] against [target]'s [organ]!</span>")

/decl/natural_attack/stomp
	name = "stomp"
	attack_verb = list("stomped on")
	attack_noun = list("foot")
	attack_sound = "swing_hit"
	damage = 0
	usable_with_limbs = list(BP_L_FOOT, BP_R_FOOT)

/decl/natural_attack/stomp/is_usable(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone)
	if(!istype(target))
		return 0

	if (!user.lying && (target.lying || (zone in list(BP_L_FOOT, BP_R_FOOT))))
		if((user in target.grabbed_by) && target.lying)
			return 0
		var/obj/item/organ/external/E = user.organs_by_name[BP_L_FOOT]
		if(E && !E.is_stump())
			return 1

		E = user.organs_by_name[BP_R_FOOT]
		if(E && !E.is_stump())
			return 1

		return 0

/decl/natural_attack/stomp/get_unarmed_damage(var/mob/living/carbon/human/user)
	var/obj/item/clothing/shoes = user.shoes
	return damage + (shoes ? shoes.force : 0)

/decl/natural_attack/stomp/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)

	var/obj/item/organ/external/affecting = istype(target) && zone && target.get_organ(zone)
	if(!affecting)
		return ..()

	var/organ = affecting.name
	var/obj/item/clothing/shoes = user.shoes
	attack_damage = Clamp(attack_damage, 1, 5)

	var/shoe_text = shoes ? copytext(shoes.name, 1, -1) : "foot"
	switch(attack_damage)
		if(1 to 4)
			user.visible_message(pick(
				"<span class='danger'>[user] stomped on [target]'s [organ][pick("", "with their [shoe_text]")]!</span>",
				"<span class='danger'>[user] stomped \his [shoe_text] down onto [target]'s [organ]!</span>"))
		if(5)
			user.visible_message(pick(
				"<span class='danger'>[user] stomped down hard onto [target]'s [organ][pick("", "with their [shoe_text]")]!</span>",
				"<span class='danger'>[user] slammed \his [shoe_text] down onto [target]'s [organ]!</span>"))

/decl/natural_attack/light_strike
	name = "light strike"
	deal_halloss = 3
	attack_noun = list("limb")
	attack_verb = list("tapped", "lightly struck")
	shredding = 0
	damage = 0
	sharp = 0
	edge = 0
	attack_sound = "light_strike"

/decl/natural_attack/light_strike/punch
	name = "light punch"
	attack_noun = list("fist")
	usable_with_limbs = list(BP_L_HAND, BP_R_HAND)

/decl/natural_attack/light_strike/kick
	name = "light kick"
	attack_noun = list("foot")
	usable_with_limbs = list(BP_L_FOOT, BP_R_FOOT)

/decl/natural_attack/light_strike/kick/is_usable(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone)
	if(zone == BP_HEAD || zone == BP_EYES || zone == BP_MOUTH)
		zone = BP_CHEST
	. = ..()
