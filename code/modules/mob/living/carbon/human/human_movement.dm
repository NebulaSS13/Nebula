/mob/living/carbon/human
	move_intents = list(/decl/move_intent/walk)

/mob/living/carbon/human/get_movement_delay(var/travel_dir)
	var/tally = ..()

	var/obj/item/organ/external/H = GET_EXTERNAL_ORGAN(src, BP_GROIN) // gets species slowdown, which can be reset by robotize()
	if(H)
		tally += H.slowdown

	tally += species.handle_movement_delay_special(src)

	if(!has_gravity())
		if(skill_check(SKILL_EVA, SKILL_PROF))
			tally -= 2
		tally -= 1

	tally -= GET_CHEMICAL_EFFECT(src, CE_SPEEDBOOST)
	tally += GET_CHEMICAL_EFFECT(src, CE_SLOWDOWN)

	var/health_deficiency = (maxHealth - health)
	if(health_deficiency >= 40) tally += (health_deficiency / 25)

	if(can_feel_pain())
		if(get_shock() >= 10) tally += (get_shock() / 10) //pain shouldn't slow you down if you can't even feel it

	if(istype(buckled, /obj/structure/bed/chair/wheelchair))
		for(var/organ_name in list(BP_L_HAND, BP_R_HAND, BP_L_ARM, BP_R_ARM))
			var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(src, organ_name)
			tally += E ? E.get_movement_delay(4) : 4
	else
		var/total_item_slowdown = -1
		for(var/obj/item/I in get_equipped_items(include_carried = TRUE))
			var/item_slowdown = 0
			var/slot = get_equipped_slot_for_item(I)
			item_slowdown += LAZYACCESS(I.slowdown_per_slot, slot)
			item_slowdown += I.slowdown_general
			item_slowdown += I.slowdown_accessory
			total_item_slowdown += max(item_slowdown, 0)
		tally += total_item_slowdown

		for(var/organ_name in list(BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT))
			var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(src, organ_name)
			tally += E ? E.get_movement_delay(4) : 4

	if(shock_stage >= 10 || get_stamina() <= 0)
		tally += 3

	if(is_asystole())
		tally += 10 // Heart attacks are kinda distracting.

	if(aiming && aiming.aiming_at)
		tally += 5 // Iron sights make you slower, it's a well-known fact.

	if(facing_dir)
		tally += 3 // Locking direction will slow you down.

	if (bodytemperature < species.cold_discomfort_level)
		tally += (species.cold_discomfort_level - bodytemperature) / 10 * 1.75

	tally += max(2 * stance_damage, 0) //damaged/missing feet or legs is slow

	if(mRun in mutations)
		tally = 0

	return (tally+config.human_delay)

/mob/living/carbon/human/size_strength_mod()
	. = ..()
	. += species.strength

/mob/living/carbon/human/Process_Spacemove(var/allow_movement)
	var/obj/item/tank/jetpack/thrust = get_jetpack()

	if(thrust && thrust.on && (allow_movement || thrust.stabilization_on) && thrust.allow_thrust(0.01, src))
		return 1

	. = ..()


/mob/living/carbon/human/space_do_move(var/allow_move, var/direction)
	if(allow_move == 1)
		var/obj/item/tank/jetpack/thrust = get_jetpack()
		if(thrust && thrust.on && prob(skill_fail_chance(SKILL_EVA, 10, SKILL_ADEPT)))
			to_chat(src, "<span class='warning'>You fumble with [thrust] controls!</span>")
			if(prob(50))
				thrust.toggle()
			if(prob(50))
				thrust.stabilization_on = 0
			SetMoveCooldown(15)	//2 seconds of random rando panic drifting
			step(src, pick(global.alldirs))
			return 0

	. = ..()

/mob/living/carbon/human/proc/get_jetpack()
	var/obj/item/back = get_equipped_item(slot_back_str)
	if(back)
		if(istype(back,/obj/item/tank/jetpack))
			return back
		if(istype(back,/obj/item/rig))
			var/obj/item/rig/rig = back
			for(var/obj/item/rig_module/maneuvering_jets/module in rig.installed_modules)
				return module.jets

/mob/living/carbon/human/slip_chance(var/prob_slip = 5)
	if(!..())
		return 0
	//Check hands and mod slip
	for(var/hand_slot in get_held_item_slots())
		var/datum/inventory_slot/inv_slot = get_inventory_slot_datum(hand_slot)
		var/obj/item/held = inv_slot?.get_equipped_item()
		if(!held)
			prob_slip -= 2
		else if(held.w_class <= ITEM_SIZE_SMALL)
			prob_slip -= 1
	return prob_slip

/mob/living/carbon/human/Check_Shoegrip()
	if(species.check_no_slip(src))
		return 1
	var/obj/item/shoes = get_equipped_item(slot_shoes_str)
	if(shoes && (shoes.item_flags & ITEM_FLAG_NOSLIP) && istype(shoes, /obj/item/clothing/shoes/magboots))  //magboots + dense_object = no floating
		return 1
	return 0

/mob/living/carbon/human/Move()
	. = ..()
	if(.) //We moved

		var/stamina_cost = 0
		for(var/obj/item/grab/G as anything in get_active_grabs())
			stamina_cost -= G.grab_slowdown()
		stamina_cost = round(stamina_cost)
		if(stamina_cost < 0)
			adjust_stamina(stamina_cost)

		handle_leg_damage()
		species.handle_post_move(src)
		if(client)
			var/turf/B = GetAbove(src)
			up_hint.icon_state = "uphint[!!(B && TURF_IS_MIMICKING(B))]"

/mob/living/carbon/human/proc/handle_leg_damage()
	if(!can_feel_pain())
		return
	var/crutches = 0
	for(var/obj/item/cane/C in get_held_items())
		crutches++
	for(var/organ_name in list(BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT))
		var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(src, organ_name)
		if(E && (E.is_dislocated() || E.is_broken()))
			if(crutches)
				crutches--
			else
				E.add_pain(10)

/mob/living/carbon/human/can_sprint()
	return (stamina > 0)

/mob/living/carbon/human/UpdateLyingBuckledAndVerbStatus()
	var/old_buckled_lying = !!buckled?.buckle_lying
	var/old_lying = lying
	. = ..()
	if(!buckled)
		if(lying && !old_lying && !resting) // fell down
			if(ismob(buckled))
				var/mob/M = buckled
				M.unbuckle_mob()
			var/decl/bodytype/B = get_bodytype()
			playsound(loc, isSynthetic() ? pick(B.synthetic_bodyfall_sounds) : pick(B.bodyfall_sounds), 50, TRUE, -1)
		else if(!lying && !old_buckled_lying)
			handle_stance() // Force an immediate stance update.
