/mob/living/human
	move_intents = list(/decl/move_intent/walk)

/mob/living/human/get_movement_delay(var/travel_dir)
	var/tally = ..()

	var/obj/item/organ/external/H = GET_EXTERNAL_ORGAN(src, BP_GROIN) // gets bodytype slowdown, which can be reset by set_bodytype
	if(H)
		tally += H.bodytype.get_movement_slowdown(src)

	tally += species.handle_movement_delay_special(src)

	if(!has_gravity())
		if(skill_check(SKILL_EVA, SKILL_PROF))
			tally -= 2
		tally -= 1

	tally -= GET_CHEMICAL_EFFECT(src, CE_SPEEDBOOST)
	tally += GET_CHEMICAL_EFFECT(src, CE_SLOWDOWN)

	var/health_deficiency = (get_max_health() - current_health)
	if(health_deficiency >= 40)
		tally += (health_deficiency / 25)

	if(can_feel_pain() && get_shock() >= 10)
		tally += (get_shock() / 10) //pain shouldn't slow you down if you can't even feel it

	var/list/limbs_to_check
	if(istype(buckled, /obj/structure/chair/wheelchair))
		for(var/obj/item/I in get_equipped_items(include_carried = TRUE))
			var/slot = get_equipped_slot_for_item(I)
			tally += LAZYACCESS(I.slowdown_per_slot, slot)
			tally += I.slowdown_general
			tally += I.slowdown_accessory
		limbs_to_check = global.all_maniple_limbs
	else
		limbs_to_check = global.all_stance_limbs

	var/missing_limbs = H ? H.bodytype.get_expected_organ_count_for_categories(limbs_to_check) : 4
	if(missing_limbs > 0)
		var/max_delay_per_limb = ceil(16/missing_limbs)
		for(var/obj/item/organ/external/limb in get_organs_by_categories(limbs_to_check))
			tally += limb.get_movement_delay(max_delay_per_limb)
			missing_limbs--
		if(missing_limbs > 0)
			tally += missing_limbs * max_delay_per_limb

	if(shock_stage >= 10 || get_stamina() <= 0)
		tally += 3

	if(is_asystole())
		tally += 10 // Heart attacks are kinda distracting.

	if(aiming && aiming.aiming_at)
		tally += 5 // Iron sights make you slower, it's a well-known fact.

	if(facing_dir && ((travel_dir & facing_dir) != facing_dir))
		tally += 3 // If we're not facing the direction we're going, we have to slow down.

	var/decl/bodytype/root_bodytype = get_bodytype()
	if (root_bodytype && bodytemperature < root_bodytype.cold_discomfort_level)
		tally += (root_bodytype.cold_discomfort_level - bodytemperature) / 10 * 1.75

	if(has_genetic_condition(GENE_COND_RUNNING))
		tally = 0

	return (tally+get_config_value(/decl/config/num/movement_human))

/mob/living/human/size_strength_mod()
	. = ..()
	. += species.strength

/mob/living/human/try_space_move(space_move_result, direction)
	if(space_move_result == SPACE_MOVE_PERMITTED)
		var/obj/item/tank/jetpack/thrust = get_jetpack()
		if(thrust && thrust.on && prob(skill_fail_chance(SKILL_EVA, 10, SKILL_ADEPT)))
			to_chat(src, SPAN_WARNING("You fumble with the controls of \the [thrust]!"))
			if(prob(50))
				thrust.toggle()
			if(prob(50))
				thrust.stabilization_on = 0
			SetMoveCooldown(15)	//2 seconds of random rando panic drifting
			step(src, pick(global.alldirs))
			return FALSE
	return ..()

/mob/living/human/Move()
	. = ..()
	if(.) //We moved

		if(stat != DEAD)

			var/nut_removed = DEFAULT_HUNGER_FACTOR/10
			var/hyd_removed = DEFAULT_THIRST_FACTOR/10
			if (move_intent.flags & MOVE_INTENT_EXERTIVE)
				nut_removed *= 2
				hyd_removed *= 2
			adjust_nutrition(-nut_removed)
			adjust_hydration(-hyd_removed)

		handle_leg_damage()
		species.handle_post_move(src)

/mob/living/human/forceMove()
	. = ..()
	if(.)
		species.handle_post_move(src, exertion = FALSE)

/mob/living/human/proc/handle_leg_damage()
	if(!can_feel_pain())
		return
	var/crutches = 0
	for(var/obj/item/support in get_held_items())
		if(support.get_stance_support_value() > 0)
			crutches++
	for(var/organ_name in list(BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT))
		var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(src, organ_name)
		if(E && (E.is_dislocated() || E.is_broken()))
			if(crutches)
				crutches--
			else
				E.add_pain(10)

/mob/living/human/can_sprint()
	return (stamina > 0)
