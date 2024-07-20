/*
Contains most of the procs that are called when a mob is attacked by something

bullet_act
ex_act
meteor_act

*/

/mob/living/human/bullet_act(var/obj/item/projectile/P, var/def_zone)

	def_zone = check_zone(def_zone, src)
	if(!has_organ(def_zone))
		return PROJECTILE_FORCE_MISS //if they don't have the organ in question then the projectile just passes by.

	//Shields
	var/shield_check = check_shields(P.damage, P, null, def_zone, P)
	if(shield_check)
		if(shield_check < 0)
			return shield_check
		else
			P.on_hit(src, 100, def_zone)
			return 100

	var/blocked = ..(P, def_zone)

	radio_interrupt_cooldown = world.time + (RADIO_INTERRUPT_DEFAULT * 0.8)

	return blocked

/mob/living/human/stun_effect_act(var/stun_amount, var/agony_amount, var/def_zone)
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(src, def_zone)
	if(!affected)
		return

	var/siemens_coeff = get_siemens_coefficient_organ(affected)
	stun_amount *= siemens_coeff
	agony_amount *= siemens_coeff
	agony_amount *= affected.get_agony_multiplier()

	affected.stun_act(stun_amount, agony_amount)

	radio_interrupt_cooldown = world.time + RADIO_INTERRUPT_DEFAULT

	if(!affected.can_feel_pain() || (GET_CHEMICAL_EFFECT(src, CE_PAINKILLER)/3 > agony_amount)) //stops blurry eyes and stutter if you can't feel pain
		agony_amount = 0

	..(stun_amount, agony_amount, def_zone)

/mob/living/human/get_blocked_ratio(def_zone, damage_type, damage_flags, armor_pen, damage)
	if(!def_zone && (damage_flags & DAM_DISPERSED))
		var/tally
		for(var/zone in organ_rel_size)
			tally += organ_rel_size[zone]
		for(var/zone in organ_rel_size)
			def_zone = zone
			. += .() * organ_rel_size/tally
		return
	return ..()

/mob/living/human/get_armors_by_zone(obj/item/organ/external/def_zone, damage_type, damage_flags)
	if(!def_zone)
		def_zone = ran_zone()
	if(!istype(def_zone))
		def_zone = GET_EXTERNAL_ORGAN(src, def_zone)
	if(!def_zone)
		return ..()

	. = list()
	for(var/slot in global.standard_clothing_slots)
		var/obj/item/clothing/gear = get_equipped_item(slot)
		if(!istype(gear))
			continue
		if(LAZYLEN(gear.accessories))
			for(var/obj/item/clothing/accessory in gear.accessories)
				if(accessory.body_parts_covered & def_zone.body_part)
					var/armor = get_extension(accessory, /datum/extension/armor)
					if(armor)
						. += armor
		if(gear.body_parts_covered & def_zone.body_part)
			var/armor = get_extension(gear, /datum/extension/armor)
			if(armor)
				. += armor

	// Add inherent armor to the end of list so that protective equipment is checked first
	. += ..()

/mob/living/human/proc/check_head_coverage()
	for(var/slot in global.standard_headgear_slots)
		var/obj/item/clothing/clothes = get_equipped_item(slot)
		if(istype(clothes) && (clothes.body_parts_covered & SLOT_HEAD))
			return TRUE
	return FALSE

//Used to check if they can be fed food/drinks/pills
/mob/living/human/check_mouth_coverage()
	for(var/slot in global.standard_headgear_slots)
		var/obj/item/gear = get_equipped_item(slot)
		if(istype(gear) && (gear.body_parts_covered & SLOT_FACE) && !(gear.item_flags & ITEM_FLAG_FLEXIBLEMATERIAL))
			return gear

/mob/living/human/resolve_item_attack(obj/item/I, mob/living/user, var/target_zone)

	for (var/obj/item/grab/G in grabbed_by)
		if(G.resolve_item_attack(user, I, target_zone))
			return null

	if(user == src) // Attacking yourself can't miss
		return target_zone

	var/accuracy_penalty = user.melee_accuracy_mods()
	accuracy_penalty += 10*get_skill_difference(SKILL_COMBAT, user)
	accuracy_penalty += 10*(I.w_class - ITEM_SIZE_NORMAL)
	accuracy_penalty -= I.melee_accuracy_bonus

	var/hit_zone = get_zone_with_miss_chance(target_zone, src, accuracy_penalty)

	if(!hit_zone)
		visible_message("<span class='danger'>\The [user] misses [src] with \the [I]!</span>")
		return null

	if(check_shields(I.get_attack_force(user), I, user, target_zone, I))
		return null

	var/obj/item/organ/external/affecting = GET_EXTERNAL_ORGAN(src, hit_zone)
	if (!affecting)
		to_chat(user, "<span class='danger'>They are missing that limb!</span>")
		return null

	return hit_zone

/mob/living/human/hit_with_weapon(obj/item/I, mob/living/user, var/effective_force, var/hit_zone)
	var/obj/item/organ/external/affecting = GET_EXTERNAL_ORGAN(src, hit_zone)
	if(!affecting)
		return //should be prevented by attacked_with_item() but for sanity.

	var/weapon_mention
	if(I.attack_message_name())
		weapon_mention = " with [I.attack_message_name()]"
	if(effective_force)
		visible_message("<span class='danger'>[src] has been [I.attack_verb.len? pick(I.attack_verb) : "attacked"] in the [affecting.name][weapon_mention] by [user]!</span>")
	else
		visible_message("<span class='warning'>[src] has been [I.attack_verb.len? pick(I.attack_verb) : "attacked"] in the [affecting.name][weapon_mention] by [user]!</span>")
		return // If it has no force then no need to do anything else.

	. = standard_weapon_hit_effects(I, user, effective_force, hit_zone)
	if(istype(ai))
		ai.retaliate(user)

/mob/living/human/standard_weapon_hit_effects(obj/item/I, mob/living/user, var/effective_force, var/hit_zone)
	var/obj/item/organ/external/affecting = GET_EXTERNAL_ORGAN(src, hit_zone)
	if(!affecting)
		return 0

	var/blocked = get_blocked_ratio(hit_zone, I.atom_damage_type, I.damage_flags(), I.armor_penetration, I.get_attack_force(user))
	// Handle striking to cripple.
	if(user.a_intent == I_DISARM)
		effective_force *= 0.66 //reduced effective force...
		if(!..(I, user, effective_force, hit_zone))
			return 0

		//set the dislocate mult less than the effective force mult so that
		//dislocating limbs on disarm is a bit easier than breaking limbs on harm
		attack_joint(affecting, I, effective_force, 0.5, blocked) //...but can dislocate joints
	else if(!..())
		return 0

	if(effective_force > 10 || effective_force >= 5 && prob(33))
		forcesay(global.hit_appends)	//forcesay checks stat already
		radio_interrupt_cooldown = world.time + (RADIO_INTERRUPT_DEFAULT * 0.8) //getting beat on can briefly prevent radio use

	if((I.atom_damage_type == BRUTE || I.atom_damage_type == PAIN) && prob(25 + (effective_force * 2)))
		if(!stat)
			if(headcheck(hit_zone))
				//Harder to score a stun but if you do it lasts a bit longer
				if(prob(effective_force))
					apply_effect(20, PARALYZE, blocked)
					if(current_posture.prone)
						visible_message("<span class='danger'>[src] [species.knockout_message]</span>")
			else
				//Easier to score a stun but lasts less time
				if(prob(effective_force + 5))
					apply_effect(3, WEAKEN, blocked)
					if(current_posture.prone)
						visible_message("<span class='danger'>[src] has been knocked down!</span>")

		//Apply blood
		attack_bloody(I, user, effective_force, hit_zone)

		animate_receive_damage(src)

	return 1

/mob/living/human/proc/attack_bloody(obj/item/W, mob/attacker, var/effective_force, var/hit_zone)
	if(W.atom_damage_type != BRUTE)
		return

	if(!should_have_organ(BP_HEART))
		return

	//make non-sharp low-force weapons less likely to be bloodied
	if(W.sharp || prob(effective_force*4))
		if(!(W.atom_flags & ATOM_FLAG_NO_BLOOD))
			W.add_blood(src)
	else
		return //if the weapon itself didn't get bloodied than it makes little sense for the target to be bloodied either

	//getting the weapon bloodied is easier than getting the target covered in blood, so run prob() again
	if(prob(33 + W.sharp*10))
		var/turf/location = loc
		if(istype(location) && location.simulated)
			location.add_blood(src)
		if(ishuman(attacker))
			var/mob/living/human/H = attacker
			if(get_dist(H, src) <= 1) //people with TK won't get smeared with blood
				H.bloody_body(src)
				H.bloody_hands(src)

		switch(hit_zone)
			if(BP_HEAD)
				var/obj/item/mask = get_equipped_item(slot_wear_mask_str)
				if(mask)
					mask.add_blood(src)
					update_equipment_overlay(slot_wear_mask_str, FALSE)
				var/obj/item/head = get_equipped_item(slot_head_str)
				if(head)
					head.add_blood(src)
					update_equipment_overlay(slot_head_str, FALSE)
				var/obj/item/glasses = get_equipped_item(slot_glasses_str)
				if(glasses && prob(33))
					glasses.add_blood(src)
					update_equipment_overlay(slot_glasses_str, FALSE)
			if(BP_CHEST)
				bloody_body(src)

/mob/living/human/proc/projectile_hit_bloody(obj/item/projectile/P, var/effective_force, var/hit_zone, var/obj/item/organ/external/organ)
	if(P.atom_damage_type != BRUTE || P.nodamage)
		return
	if(!(P.sharp || prob(effective_force*4)))
		return
	if(prob(effective_force))
		var/turf/location = loc
		if(istype(location) && location.simulated)
			location.add_blood(src)
		if(hit_zone)
			organ = GET_EXTERNAL_ORGAN(src, hit_zone)
		if(organ)
			var/list/bloody = get_covering_equipped_items(organ.body_part)
			for(var/obj/item/clothing/C in bloody)
				C.add_blood(src)
				C.update_clothing_icon()

/mob/living/human/proc/attack_joint(var/obj/item/organ/external/organ, var/obj/item/W, var/effective_force, var/dislocate_mult, var/blocked)
	if(!organ || organ.is_dislocated() || !(organ.limb_flags & ORGAN_FLAG_CAN_DISLOCATE) || blocked >= 100)
		return 0
	if(W.atom_damage_type != BRUTE)
		return 0

	//want the dislocation chance to be such that the limb is expected to dislocate after dealing a fraction of the damage needed to break the limb
	var/dislocate_chance = effective_force/(dislocate_mult * organ.min_broken_damage * get_config_value(/decl/config/num/health_organ_health_multiplier))*100
	if(prob(dislocate_chance * blocked_mult(blocked)))
		visible_message("<span class='danger'>[src]'s [organ.joint] [pick("gives way","caves in","crumbles","collapses")]!</span>")
		organ.dislocate(1)
		return 1
	return 0

/mob/living/human/emag_act(var/remaining_charges, mob/user, var/emag_source)
	var/obj/item/organ/external/affecting = GET_EXTERNAL_ORGAN(src, user.get_target_zone())
	if(!affecting || !affecting.is_robotic())
		to_chat(user, "<span class='warning'>That limb isn't robotic.</span>")
		return -1
	if(affecting.status & ORGAN_SABOTAGED)
		to_chat(user, "<span class='warning'>[src]'s [affecting.name] is already sabotaged!</span>")
		return -1
	to_chat(user, "<span class='notice'>You sneakily slide [emag_source] into the dataport on [src]'s [affecting.name] and short out the safeties.</span>")
	affecting.status |= ORGAN_SABOTAGED
	return 1

/mob/living/human/hitby(atom/movable/AM, var/datum/thrownthing/TT)
	// empty active hand and we're in throw mode, so we can catch it
	if(isobj(AM) && in_throw_mode && !get_active_held_item() && TT.speed <= THROWFORCE_SPEED_DIVISOR && !incapacitated() && isturf(AM.loc))
		put_in_active_hand(AM)
		visible_message(SPAN_NOTICE("\The [src] catches \the [AM]!"))
		toggle_throw_mode(FALSE)
		process_momentum(AM, TT)
		return FALSE
	return ..()

/mob/living/human/proc/bloody_hands(var/mob/living/source, var/amount = 2)
	var/obj/item/clothing/gloves/gloves = get_equipped_item(slot_gloves_str)
	if(istype(gloves))
		gloves.add_blood(source, amount)
	else
		add_blood(source, amount)
	//updates on-mob overlays for bloody hands and/or bloody gloves
	update_equipment_overlay(slot_gloves_str)

/mob/living/human/proc/bloody_body(var/mob/living/source)
	var/obj/item/gear = get_equipped_item(slot_wear_suit_str)
	if(gear)
		gear.add_blood(source)
		update_equipment_overlay(slot_wear_suit_str, redraw_mob = FALSE)
	gear = get_equipped_item(slot_w_uniform_str)
	if(gear)
		gear.add_blood(source)
		update_equipment_overlay(slot_w_uniform_str, redraw_mob = FALSE)

/mob/living/human/proc/handle_suit_punctures(var/damtype, var/damage, var/def_zone)

	// Tox and oxy don't matter to suits.
	if(damtype != BURN && damtype != BRUTE) return

	// The rig might soak this hit, if we're wearing one.
	var/obj/item/rig/rig = get_rig()
	if(rig)
		rig.take_hit(damage)

	// We may also be taking a suit breach.
	var/obj/item/clothing/suit/space/suit = get_equipped_item(slot_wear_suit_str)
	if(istype(suit))
		suit.create_breaches(damtype, damage)

/mob/living/human/reagent_permeability()
	var/perm = 0

	var/list/perm_by_part = list(
		"head" = THERMAL_PROTECTION_HEAD,
		"upper_torso" = THERMAL_PROTECTION_UPPER_TORSO,
		"lower_torso" = THERMAL_PROTECTION_LOWER_TORSO,
		"legs" = THERMAL_PROTECTION_LEG_LEFT + THERMAL_PROTECTION_LEG_RIGHT,
		"feet" = THERMAL_PROTECTION_FOOT_LEFT + THERMAL_PROTECTION_FOOT_RIGHT,
		"arms" = THERMAL_PROTECTION_ARM_LEFT + THERMAL_PROTECTION_ARM_RIGHT,
		"hands" = THERMAL_PROTECTION_HAND_LEFT + THERMAL_PROTECTION_HAND_RIGHT
		)

	for(var/obj/item/clothing/C in src.get_equipped_items())
		if(C.permeability_coefficient == 1 || !C.body_parts_covered)
			continue
		if(C.body_parts_covered & SLOT_HEAD)
			perm_by_part["head"] *= C.permeability_coefficient
		if(C.body_parts_covered & SLOT_UPPER_BODY)
			perm_by_part["upper_torso"] *= C.permeability_coefficient
		if(C.body_parts_covered & SLOT_LOWER_BODY)
			perm_by_part["lower_torso"] *= C.permeability_coefficient
		if(C.body_parts_covered & SLOT_LEGS)
			perm_by_part["legs"] *= C.permeability_coefficient
		if(C.body_parts_covered & SLOT_FEET)
			perm_by_part["feet"] *= C.permeability_coefficient
		if(C.body_parts_covered & SLOT_ARMS)
			perm_by_part["arms"] *= C.permeability_coefficient
		if(C.body_parts_covered & SLOT_HANDS)
			perm_by_part["hands"] *= C.permeability_coefficient

	for(var/part in perm_by_part)
		perm += perm_by_part[part]

	return perm

/mob/living/human/lava_act(datum/gas_mixture/air, temperature, pressure)
	var/was_burned = FireBurn(0.4 * vsc.fire_firelevel_multiplier, temperature, pressure)
	if (was_burned)
		fire_act(air, temperature)
	return FALSE

//Removed the horrible safety parameter. It was only being used by ninja code anyways.
//Now checks siemens_coefficient of the affected area by default
/mob/living/human/electrocute_act(var/shock_damage, var/obj/source, var/base_siemens_coeff = 1.0, var/def_zone = null)

	if(status_flags & GODMODE)	return 0	//godmode

	if(species.get_shock_vulnerability(src) == -1)
		if(stored_shock_by_ref["\ref[src]"])
			stored_shock_by_ref["\ref[src]"] += shock_damage
		else
			stored_shock_by_ref["\ref[src]"] = shock_damage
		return

	if (!def_zone)
		def_zone = pick(BP_L_HAND, BP_R_HAND)

	shock_damage = apply_shock(shock_damage, def_zone, base_siemens_coeff)

	if(!shock_damage)
		return 0

	stun_effect_act(agony_amount=shock_damage, def_zone=def_zone)

	playsound(loc, "sparks", 50, 1, -1)
	if (shock_damage > 15)
		src.visible_message(
			"<span class='warning'>[src] was electrocuted[source ? " by the [source]" : ""]!</span>", \
			"<span class='danger'>You feel a powerful shock course through your body!</span>", \
			"<span class='warning'>You hear a heavy electrical crack.</span>" \
		)
	else
		src.visible_message(
			"<span class='warning'>[src] was shocked[source ? " by the [source]" : ""].</span>", \
			"<span class='warning'>You feel a shock course through your body.</span>", \
			"<span class='warning'>You hear a zapping sound.</span>" \
		)

	switch(shock_damage)
		if(11 to 15)
			SET_STATUS_MAX(src, STAT_STUN, 1)
		if(16 to 20)
			SET_STATUS_MAX(src, STAT_STUN, 2)
		if(21 to 25)
			SET_STATUS_MAX(src, STAT_WEAK, 2)
		if(26 to 30)
			SET_STATUS_MAX(src, STAT_WEAK, 5)
		if(31 to INFINITY)
			SET_STATUS_MAX(src, STAT_WEAK, 10) //This should work for now, more is really silly and makes you lay there forever

	set_status(STAT_JITTER, min(shock_damage*5, 200))

	spark_at(loc, amount=5, cardinal_only = TRUE)

	return shock_damage

/mob/living/human/explosion_act(severity)
	..()
	if(QDELETED(src))
		return

	var/b_loss = null
	var/f_loss = null
	switch (severity)
		if(1)
			b_loss = 400
			f_loss = 100
			var/atom/target = get_edge_target_turf(src, get_dir(src, get_step_away(src, src)))
			throw_at(target, 200, 4)
		if(2)
			b_loss = 60
			f_loss = 60
			if (get_sound_volume_multiplier() >= 0.2)
				SET_STATUS_MAX(src, STAT_TINNITUS, 30)
				SET_STATUS_MAX(src, STAT_DEAF, 120)
			if(prob(70))
				SET_STATUS_MAX(src, STAT_PARA, 10)
		if(3)
			b_loss = 30
			if (get_sound_volume_multiplier() >= 0.2)
				SET_STATUS_MAX(src, STAT_TINNITUS, 15)
				SET_STATUS_MAX(src, STAT_DEAF, 60)
			if (prob(50))
				SET_STATUS_MAX(src, STAT_PARA, 10)

	// focus most of the blast on one organ
	apply_damage(0.7 * b_loss, BRUTE, null, DAM_EXPLODE, used_weapon = "Explosive blast")
	apply_damage(0.7 * f_loss, BURN, null, DAM_EXPLODE, used_weapon = "Explosive blast")

	// distribute the remaining 30% on all limbs equally (including the one already dealt damage)
	apply_damage(0.3 * b_loss, BRUTE, null, DAM_EXPLODE | DAM_DISPERSED, used_weapon = "Explosive blast")
	apply_damage(0.3 * f_loss, BURN, null, DAM_EXPLODE | DAM_DISPERSED, used_weapon = "Explosive blast")

//Used by various things that knock people out by applying blunt trauma to the head.
//Checks that the species has a "head" (brain containing organ) and that hit_zone refers to it.
/mob/living/human/proc/headcheck(var/target_zone, var/brain_tag = BP_BRAIN)

	target_zone = check_zone(target_zone, src)

	var/obj/item/organ/internal/brain = GET_INTERNAL_ORGAN(src, brain_tag)
	if(!brain || brain.parent_organ != target_zone)
		return FALSE

	//if the parent organ is significantly larger than the brain organ, then hitting it is not guaranteed
	var/obj/item/organ/external/head = GET_EXTERNAL_ORGAN(src, target_zone)
	if(!head)
		return FALSE
	if(head.w_class > brain.w_class + 1)
		return prob(100 / 2**(head.w_class - brain.w_class - 1))
	return TRUE

/mob/living/human/flash_eyes(var/intensity = FLASH_PROTECTION_MODERATE, override_blindness_check = FALSE, affect_silicon = FALSE, visual = FALSE, type = /obj/screen/fullscreen/flash)
	var/vision_organ_tag = get_vision_organ_tag()
	if(vision_organ_tag)
		var/obj/item/organ/internal/eyes/I = get_organ(vision_organ_tag, /obj/item/organ/internal/eyes)
		if(I)
			I.additional_flash_effects(intensity)
	return ..()

/*
Contians the proc to handle radiation.
Specifically made to do radiation burns.
*/
/mob/living/human/apply_radiation(damage)
	..()
	if(!isSynthetic() && !ignore_rads)
		damage = 0.25 * damage * (species ? species.get_radiation_mod(src) : 1)
		take_damage(BURN, damage)
	return TRUE
