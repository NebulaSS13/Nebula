
/mob/living/simple_animal
	name = "animal"
	max_health = 20
	universal_speak = FALSE
	mob_sort_value = 12

	mob_bump_flag = SIMPLE_ANIMAL
	mob_swap_flags = MONKEY|SLIME|SIMPLE_ANIMAL
	mob_push_flags = MONKEY|SLIME|SIMPLE_ANIMAL

	icon_state = ICON_STATE_WORLD
	buckle_pixel_shift = @"{'x':0,'y':0,'z':8}"

	move_intents = list(
		/decl/move_intent/walk/animal,
		/decl/move_intent/run/animal
	)

	var/base_movement_delay = 4
	ai = /datum/mob_controller

	var/can_have_rider = TRUE
	var/max_rider_size = MOB_SIZE_SMALL

	/// Does the percentage health show in the stat panel for the mob?
	var/show_stat_health = TRUE

	//Interaction
	var/response_help_1p = "You pet $TARGET$."
	var/response_help_3p = "$USER$ pets $TARGET$."
	var/response_disarm =  "pushes aside"
	var/response_harm =    "kicks"
	var/harm_intent_damage = 3

	//Temperature effect
	var/minbodytemp = 250
	var/maxbodytemp = 350
	var/heat_damage_per_tick = 3	//amount of damage applied if animal's body temperature is higher than maxbodytemp
	var/cold_damage_per_tick = 2	//same as heat_damage_per_tick, only if the bodytemperature it's lower than minbodytemp

	//Atmos effect - Yes, you can make creatures that require arbitrary gasses to survive. N2O is a trace gas and handled separately, hence why it isn't here. It'd be hard to add it. Hard and me don't mix (Yes, yes make all the dick jokes you want with that.) - Errorage
	var/list/min_gas = list(/decl/material/gas/oxygen = 5)
	var/list/max_gas = list(
		/decl/material/gas/chlorine = 1,
		/decl/material/gas/carbon_dioxide = 5
	)

	var/unsuitable_atmos_damage = 2	//This damage is taken when atmos doesn't fit all the requirements above

	//LETTING SIMPLE ANIMALS ATTACK? WHAT COULD GO WRONG. Defaults to zero so Ian can still be cuddly
	var/obj/item/natural_weapon/natural_weapon
	var/environment_smash = 0
	var/resistance		  = 0	// Damage reduction
	var/armor_type = /datum/extension/armor
	var/list/natural_armor //what armor animal has
	var/is_aquatic = FALSE

	//Null rod stuff
	var/supernatural = 0
	var/purge = 0

	var/bleed_ticks = 0
	var/bleed_colour = COLOR_BLOOD_HUMAN
	var/can_bleed = TRUE

	// contained in a cage
	var/in_stasis = 0

	//for simple animals with abilities, mostly megafauna
	var/ability_cooldown

	//for simple animals that reflect damage when attacked in melee
	var/return_damage_min
	var/return_damage_max

	var/performing_delayed_life_action = FALSE
	var/glowing_eyes = FALSE
	var/mob_icon_state_flags = 0

	var/scannable_result // Codex page generated when this mob is scanned.
	var/base_animal_type // set automatically in Initialize(), used for language checking.

	var/attack_delay = DEFAULT_ATTACK_COOLDOWN // How long in ds that a creature winds up before attacking.
	var/sa_accuracy = 85 //base chance to hit out of 100

	// Visible message shown when the mob dies.
	var/death_message = "dies!"

	// Ranged attack handling vars.
	var/burst_projectile = FALSE
	var/projectiletype
	var/projectilesound
	var/casingtype
	var/fire_desc = "fires" //"X fire_desc at Y!"
	var/ranged_range = 6 //tiles of range for ranged attackers to attack

/mob/living/simple_animal/Initialize()
	. = ..()

	// Aquatic creatures only care about water, not atmos.
	add_inventory_slot(new /datum/inventory_slot/head/simple)

	if(is_aquatic)
		max_gas = list()
		min_gas = list()
		minbodytemp = 0

	check_mob_icon_states(TRUE)
	if(isnull(base_animal_type))
		base_animal_type = type
	if(LAZYLEN(natural_armor))
		set_extension(src, armor_type, natural_armor)
	if(scannable_result)
		set_extension(src, /datum/extension/scannable, scannable_result)
	setup_languages()

/mob/living/simple_animal/proc/setup_languages()
	add_language(/decl/language/animal)

/mob/living/simple_animal/proc/apply_attack_effects(mob/living/target)
	set waitfor = FALSE
	return

var/global/list/simplemob_icon_bitflag_cache = list()
/mob/living/simple_animal/proc/check_mob_icon_states(var/sa_initializing = FALSE)
	if(sa_initializing) // Let people force-rebuild the mob cache with proccall if needed.
		mob_icon_state_flags = global.simplemob_icon_bitflag_cache[type]
	else
		mob_icon_state_flags = null
	if(isnull(mob_icon_state_flags))
		mob_icon_state_flags = 0
		if(check_state_in_icon("world", icon))
			mob_icon_state_flags |= MOB_ICON_HAS_LIVING_STATE
		if(check_state_in_icon("world-dead", icon))
			mob_icon_state_flags |= MOB_ICON_HAS_DEAD_STATE
		if(check_state_in_icon("world-sleeping", icon))
			mob_icon_state_flags |= MOB_ICON_HAS_SLEEP_STATE
		if(check_state_in_icon("world-resting", icon))
			mob_icon_state_flags |= MOB_ICON_HAS_REST_STATE
		if(check_state_in_icon("world-gib", icon))
			mob_icon_state_flags |= MOB_ICON_HAS_GIB_STATE
		if(check_state_in_icon("world-dust", icon))
			mob_icon_state_flags |= MOB_ICON_HAS_DUST_STATE
		if(check_state_in_icon("world-paralyzed", icon))
			mob_icon_state_flags |= MOB_ICON_HAS_PARALYZED_STATE
		global.simplemob_icon_bitflag_cache[type] = mob_icon_state_flags

/mob/living/simple_animal/on_update_icon()

	..()

	icon_state = ICON_STATE_WORLD
	if(stat != DEAD && HAS_STATUS(src, STAT_PARA) && (mob_icon_state_flags & MOB_ICON_HAS_PARALYZED_STATE))
		icon_state += "-paralyzed"
	else if(stat == DEAD && (mob_icon_state_flags & MOB_ICON_HAS_DEAD_STATE))
		icon_state += "-dead"
	else if(stat == UNCONSCIOUS && (mob_icon_state_flags & MOB_ICON_HAS_SLEEP_STATE))
		icon_state += "-sleeping"
	else if(current_posture?.deliberate && (mob_icon_state_flags & MOB_ICON_HAS_REST_STATE))
		icon_state += "-resting"

	z_flags &= ~ZMM_MANGLE_PLANES
	if(stat == CONSCIOUS)
		var/image/I = get_eye_overlay()
		if(I)
			if(glowing_eyes)
				z_flags |= ZMM_MANGLE_PLANES
			add_overlay(I)

/mob/living/simple_animal/get_eye_overlay()
	var/eye_icon_state = "[icon_state]-eyes"
	if(check_state_in_icon(eye_icon_state, icon))
		var/image/I = (glowing_eyes ? emissive_overlay(icon, eye_icon_state) : image(icon, eye_icon_state))
		I.appearance_flags = RESET_COLOR
		return I

/mob/living/simple_animal/Destroy()
	if(istype(natural_weapon))
		QDEL_NULL(natural_weapon)
	. = ..()

/mob/living/simple_animal/handle_regular_status_updates()

	if(purge)
		purge -= 1

	. = ..()
	if(.)
		if(can_bleed && bleed_ticks > 0)
			handle_bleeding()
		if(is_aquatic && !submerged())
			stop_automove()
			if(HAS_STATUS(src, STAT_PARA) <= 2) // gated to avoid redundant update_icon() calls.
				SET_STATUS_MAX(src, STAT_PARA, 3)
				update_icon()
	else
		// Cancel any trailing walking if we're dead.
		stop_automove()

/mob/living/simple_animal/handle_some_updates()
	. = ..() && (!z || living_observers_present(SSmapping.get_connected_levels(z)))

/mob/living/simple_animal/turf_is_safe(turf/target)
	if((. = ..()) && is_aquatic != target.submerged())
		return FALSE

/mob/living/simple_animal/handle_environment(datum/gas_mixture/environment)
	. = ..()
	var/atmos_suitable = TRUE
	if(environment)
		// don't bother checking it twice if we got a supplied FALSE val.
		if(atmos_suitable)
			if(is_aquatic)
				atmos_suitable = submerged()
			else if(LAZYLEN(min_gas))
				for(var/gas in min_gas)
					if(environment.gas[gas] < min_gas[gas])
						atmos_suitable = FALSE
						break
				if(atmos_suitable && LAZYLEN(max_gas))
					for(var/gas in max_gas)
						if(environment.gas[gas] > max_gas[gas])
							atmos_suitable = FALSE
							break
		//Atmos effect
		if(!has_genetic_condition(GENE_COND_SPACE_RESISTANCE) && abs(environment.temperature - bodytemperature) > 40)
			bodytemperature += ((environment.temperature - bodytemperature) / 5)

	if(bodytemperature < minbodytemp)
		SET_HUD_ALERT(src, /decl/hud_element/condition/fire, 2)
		take_damage(cold_damage_per_tick, BURN)
	else if(bodytemperature > maxbodytemp)
		SET_HUD_ALERT(src, /decl/hud_element/condition/fire, 1)
		take_damage(heat_damage_per_tick, BURN)
	else
		SET_HUD_ALERT(src, /decl/hud_element/condition/fire, 0)

	if(!atmos_suitable)
		take_damage(unsuitable_atmos_damage)

/mob/living/simple_animal/get_mob_temperature_threshold(threshold, bodypart)
	if(threshold >= HEAT_LEVEL_1)
		return maxbodytemp
	if(threshold <= COLD_LEVEL_1)
		return minbodytemp
	return ..()

/mob/living/simple_animal/get_gibbed_icon()
	return icon

/mob/living/simple_animal/get_gibbed_state(dusted)
	if(dusted)
		return (mob_icon_state_flags & MOB_ICON_HAS_DUST_STATE) ? "world-dust" : null
	return (mob_icon_state_flags & MOB_ICON_HAS_GIB_STATE) ? "world-gib" : null

/mob/living/simple_animal/proc/visible_emote(var/act_desc)
	custom_emote(1, act_desc)

/mob/living/simple_animal/proc/audible_emote(var/act_desc)
	custom_emote(2, act_desc)

/mob/living/simple_animal/get_hug_zone_messages(var/zone)
	. = ..() || list(response_help_3p, response_help_1p)

/mob/living/simple_animal/default_help_interaction(mob/user)
	if(current_health > 0 && user.attempt_hug(src))
		user.update_personal_goal(/datum/goal/achievement/specific_object/pet, type)
		return TRUE
	. = ..()

/mob/living/simple_animal/default_disarm_interaction(mob/user)
	. = ..()
	if(!.)
		user.visible_message(SPAN_NOTICE("\The [user] [response_disarm] \the [src]."))
		user.do_attack_animation(src)
		return TRUE

/mob/living/simple_animal/default_hurt_interaction(mob/user)
	. = ..()
	if(!.)
		var/dealt_damage = harm_intent_damage
		var/harm_verb = response_harm
		var/damage_flags
		var/damage_type
		if(ishuman(user))
			var/mob/living/human/H = user
			var/decl/natural_attack/attack = H.get_unarmed_attack(src)
			if(istype(attack))
				dealt_damage = attack.damage <= dealt_damage ? dealt_damage : attack.damage
				harm_verb = pick(attack.attack_verb)
				damage_flags = attack.get_damage_flags()
				damage_type = attack.get_damage_type()
		take_damage(dealt_damage, damage_type, damage_flags = damage_flags, inflicter = user)
		user.visible_message(SPAN_DANGER("\The [user] [harm_verb] \the [src]!"))
		user.do_attack_animation(src)
		return TRUE

/mob/living/simple_animal/attackby(var/obj/item/O, var/mob/user)

	if(istype(O, /obj/item/stack/medical))
		if(stat != DEAD)
			var/obj/item/stack/medical/MED = O
			if(!MED.animal_heal)
				to_chat(user, SPAN_WARNING("\The [MED] won't help \the [src] at all!"))
			else if(current_health < get_max_health() && MED.can_use(1))
				heal_damage(BRUTE, MED.animal_heal)
				visible_message(SPAN_NOTICE("\The [user] applies \the [MED] to \the [src]."))
				MED.use(1)
		else
			var/decl/pronouns/G = get_pronouns()
			to_chat(user, SPAN_WARNING("\The [src] is dead, medical items won't bring [G.him] back to life."))
		return TRUE

	return ..()

/mob/living/simple_animal/get_movement_delay(var/travel_dir)
	. = max(1, ..() + base_movement_delay + get_config_value(/decl/config/num/movement_animal))
	//Purged creatures will move more slowly. The more time before their purge stops, the slower they'll move.
	if(purge)
		. *= purge

/mob/living/simple_animal/Stat()
	. = ..()

	if(statpanel("Status") && show_stat_health)
		stat(null, "Health: [get_health_percent()]%")

/mob/living/simple_animal/get_death_message(gibbed)
	if(!gibbed && death_message)
		return death_message
	return ..()

/mob/living/simple_animal/death(gibbed)
	. = ..()
	if(.)
		density = FALSE

/mob/living/simple_animal/explosion_act(severity)
	..()
	var/damage
	switch(severity)
		if(1)
			damage = 500
		if(2)
			damage = 120
		if(3)
			damage = 30
	apply_damage(damage, BRUTE, damage_flags = DAM_EXPLODE)

/mob/living/simple_animal/say(var/message)
	var/verb = "says"
	if(speak_emote.len)
		verb = pick(speak_emote)

	message = sanitize(message)

	..(message, null, verb)

/mob/living/simple_animal/put_in_hands(var/obj/item/W) // No hands.
	W.forceMove(get_turf(src))
	return 1

/mob/living/simple_animal/is_burnable()
	return heat_damage_per_tick

/mob/living/simple_animal/proc/adjustBleedTicks(var/amount)
	if(!can_bleed)
		return

	if(amount > 0)
		bleed_ticks = max(bleed_ticks, amount)
	else
		bleed_ticks = max(bleed_ticks + amount, 0)

	bleed_ticks = round(bleed_ticks)

/mob/living/simple_animal/get_blood_color()
	return bleed_colour

/mob/living/simple_animal/proc/handle_bleeding()
	bleed_ticks--
	take_damage(1)
	blood_splatter(get_turf(src), src, FALSE)

/mob/living/simple_animal/get_digestion_product()
	return /decl/material/liquid/nutriment

/mob/living/simple_animal/proc/reflect_unarmed_damage(var/mob/living/human/attacker, var/damage_type, var/description)
	if(attacker.a_intent == I_HURT)
		attacker.apply_damage(rand(return_damage_min, return_damage_max), damage_type, attacker.get_active_held_item_slot(), used_weapon = description)
		if(rand(25))
			to_chat(attacker, SPAN_WARNING("Your attack has no obvious effect on \the [src]'s [description]!"))

/mob/living/simple_animal/proc/get_natural_weapon()
	if(ispath(natural_weapon))
		natural_weapon = new natural_weapon(src)
	return natural_weapon

/mob/living/simple_animal/get_admin_job_string()
	return "Animal"

/mob/living/simple_animal/get_speech_bubble_state_modifier()
	return ..() || "rough"

/mob/living/simple_animal/can_act()
	return ..() && !(is_aquatic && !submerged())

/mob/living/simple_animal/experiences_hunger_and_thirst()
	// return !supernatural && !isSynthetic()
	return FALSE // They need a reliable way to recover nutrition/hydration before this is made general.

/mob/living/simple_animal/get_nutrition()
	return get_max_nutrition()

/mob/living/simple_animal/get_hydration()
	return get_max_hydration()

/// Adapts our temperature and atmos thresholds to our current z-level.
/mob/living/simple_animal/proc/adapt_to_current_level()
	var/turf/T = get_turf(src)
	if(!T)
		return

	var/datum/level_data/level_data = SSmapping.levels_by_z[T.z]
	if(!level_data)
		return

	bodytemperature = level_data.exterior_atmos_temp
	minbodytemp     = bodytemperature - 20
	maxbodytemp     = bodytemperature + 20

	// Adapt atmosphere if necessary.
	if(!min_gas && !max_gas)
		return

	if(min_gas)
		min_gas.Cut()
	if(max_gas)
		max_gas.Cut()
	if(!level_data.exterior_atmosphere)
		return

	for(var/gas in level_data.exterior_atmosphere.gas)
		var/gas_amt = level_data.exterior_atmosphere.gas[gas]
		if(min_gas)
			min_gas[gas] = round(gas_amt * 0.5)
		if(max_gas)
			min_gas[gas] = round(gas_amt * 1.5)

// Simple filler bodytype so animals get offsets for their inventory slots.
/decl/bodytype/animal
	abstract_type = /decl/bodytype/animal
	name = "animal"
	bodytype_flag = 0
	bodytype_category = "animal body"

/decl/bodytype/quadruped/animal
	abstract_type = /decl/bodytype/quadruped/animal
	name = "quadruped animal"
	bodytype_flag = 0
	bodytype_category = "quadrupedal animal body"

/mob/living/simple_animal/get_base_telegraphed_melee_accuracy()
	return sa_accuracy

/mob/living/simple_animal/check_has_mouth()
	return TRUE

/mob/living/simple_animal/can_buckle_mob(var/mob/living/dropping)
	. = ..() && can_have_rider && (dropping.mob_size <= max_rider_size)

/mob/living/simple_animal/get_available_postures()
	var/static/list/available_postures = list(
		/decl/posture/standing,
		/decl/posture/lying,
		/decl/posture/lying/deliberate
	)
	return available_postures

/mob/living/simple_animal/get_default_3p_hug_message(mob/living/target)
	return "$USER$ nuzzles $TARGET$."

/mob/living/simple_animal/get_default_1p_hug_message(mob/living/target)
	return "You nuzzle $TARGET$."

/mob/living/simple_animal/handle_stance()
	stance_damage = 0
	return

/mob/living/simple_animal/proc/get_pry_desc()
	return "prying"

/mob/living/simple_animal/pry_door(var/mob/user, var/delay, var/obj/machinery/door/pesky_door)
	if(!can_pry_door())
		return
	visible_message(SPAN_DANGER("\The [user] begins [get_pry_desc()] at \the [pesky_door]!"))
	if(istype(ai))
		ai.pause()
	if(do_after(user, delay, pesky_door))
		pesky_door.open(1)
	else
		visible_message(SPAN_NOTICE("\The [user] is interrupted."))
	if(istype(ai))
		ai.resume()

/mob/living/simple_animal/has_ranged_attack()
	return !!projectiletype && get_ranged_attack_distance() > 0

/mob/living/simple_animal/proc/shoot_wrapper(target, location, user)
	if(shoot_at(target, location, user) && casingtype)
		new casingtype(loc)

/mob/living/simple_animal/proc/shoot_at(var/atom/target, var/atom/start)
	if(!start)
		start = get_turf(src)
	if(!can_act() || !istype(target) || !istype(start) || target == start || !has_ranged_attack())
		return FALSE
	var/obj/item/projectile/A = new projectiletype(get_turf(start))
	if(!A)
		return FALSE
	playsound(start, projectilesound, 100, 1)
	A.launch(target, get_exposed_defense_zone(target), src)
	return TRUE

/mob/living/simple_animal/get_ranged_attack_distance()
	return ranged_range

/mob/living/simple_animal/handle_ranged_attack(atom/target)
	if(!has_ranged_attack() || !istype(target))
		return
	visible_message(SPAN_DANGER("\The [src] [fire_desc] at \the [target]!"))
	if(burst_projectile)
		var/datum/callback/shoot_cb = CALLBACK(src, PROC_REF(shoot_wrapper), target, loc)
		addtimer(shoot_cb, 1)
		addtimer(shoot_cb, 4)
		addtimer(shoot_cb, 6)
	else
		shoot_at(target, loc, src)

/mob/living/simple_animal/can_eat_food_currently(obj/eating, mob/user, consumption_method)
	return TRUE

/mob/living/simple_animal/get_attack_telegraph_delay()
	return attack_delay

/mob/living/simple_animal/set_stat(var/new_stat)
	if((. = ..()))
		queue_icon_update()
