/mob/living/simple_animal
	name = "animal"
	health = 20
	maxHealth = 20
	universal_speak = FALSE
	mob_sort_value = 12

	mob_bump_flag = SIMPLE_ANIMAL
	mob_swap_flags = MONKEY|SLIME|SIMPLE_ANIMAL
	mob_push_flags = MONKEY|SLIME|SIMPLE_ANIMAL

	meat_type = /obj/item/chems/food/meat
	meat_amount = 3
	bone_material = /decl/material/solid/bone
	bone_amount = 5
	skin_material = /decl/material/solid/skin
	skin_amount = 5

	icon_state = ICON_STATE_WORLD

	var/gene_damage = 0 // Set to -1 to disable gene damage for the mob.
	var/show_stat_health = 1	//does the percentage health show in the stat panel for the mob

	var/list/speak = list("...")
	var/speak_chance = 0
	var/list/emote_hear = list()	//Hearable emotes
	var/list/emote_see = list()		//Unlike speak_emote, the list of things in this variable only show by themselves with no spoken text. IE: Ian barks, Ian yaps

	var/turns_per_move = 1
	var/turns_since_move = 0
	var/stop_automated_movement = 0 //Use this to temporarely stop random movement or to if you write special movement code for animals.
	var/wander = 1	// Does the mob wander around when idle?
	var/stop_automated_movement_when_pulled = 1 //When set to 1 this stops the animal from moving when someone is grabbing it.

	//Interaction
	var/response_help_1p = "You pet $TARGET$."
	var/response_help_3p = "$USER$ pets $TARGET$."
	var/response_disarm =  "pushes aside"
	var/response_harm =    "kicks"
	var/harm_intent_damage = 3
	var/can_escape = FALSE // 'smart' simple animals such as human enemies, or things small, big, sharp or strong enough to power out of a net

	//Temperature effect
	var/minbodytemp = 250
	var/maxbodytemp = 350
	var/heat_damage_per_tick = 3	//amount of damage applied if animal's body temperature is higher than maxbodytemp
	var/cold_damage_per_tick = 2	//same as heat_damage_per_tick, only if the bodytemperature it's lower than minbodytemp
	var/fire_alert = 0

	var/list/hat_offsets

	//Atmos effect - Yes, you can make creatures that require arbitrary gasses to survive. N2O is a trace gas and handled separately, hence why it isn't here. It'd be hard to add it. Hard and me don't mix (Yes, yes make all the dick jokes you want with that.) - Errorage
	var/list/min_gas = list(/decl/material/gas/oxygen = 5)
	var/list/max_gas = list(
		/decl/material/gas/chlorine = 1,
		/decl/material/gas/carbon_dioxide = 5
	)

	var/unsuitable_atmos_damage = 2	//This damage is taken when atmos doesn't fit all the requirements above
	var/speed = 0 //LETS SEE IF I CAN SET SPEEDS FOR SIMPLE MOBS WITHOUT DESTROYING EVERYTHING. Higher speed is slower, negative speed is faster

	//LETTING SIMPLE ANIMALS ATTACK? WHAT COULD GO WRONG. Defaults to zero so Ian can still be cuddly
	var/obj/item/natural_weapon/natural_weapon
	var/friendly = "nuzzles"
	var/environment_smash = 0
	var/resistance		  = 0	// Damage reduction
	var/armor_type = /datum/extension/armor
	var/list/natural_armor //what armor animal has
	var/flash_vulnerability = 1 // whether or not the mob can be flashed; 0 = no, 1 = yes, 2 = very yes
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

/mob/living/simple_animal/Initialize()
	. = ..()

	// Aquatic creatures only care about water, not atmos.
	if(is_aquatic)
		max_gas = list()
		min_gas = list()
		minbodytemp = 0

	check_mob_icon_states(TRUE)
	if(isnull(base_animal_type))
		base_animal_type = type
	if(LAZYLEN(natural_armor))
		set_extension(src, armor_type, natural_armor)
	if(islist(hat_offsets))
		set_extension(src, /datum/extension/hattable/directional, hat_offsets)
	if(scannable_result)
		set_extension(src, /datum/extension/scannable, scannable_result)
	setup_languages()

/mob/living/simple_animal/proc/setup_languages()
	add_language(/decl/language/animal)

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
	else if(resting && (mob_icon_state_flags & MOB_ICON_HAS_REST_STATE))
		icon_state += "-resting"

	z_flags &= ~ZMM_MANGLE_PLANES
	if(stat == CONSCIOUS)
		var/image/I = get_eye_overlay()
		if(I)
			if(glowing_eyes)
				z_flags |= ZMM_MANGLE_PLANES
			add_overlay(I)

	var/datum/extension/hattable/hattable = get_extension(src, /datum/extension/hattable)
	var/image/I = hattable?.get_hat_overlay(src)
	if(I)
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

/mob/living/simple_animal/Life()
	if(is_aquatic && !submerged() && stat != DEAD)
		walk(src, 0)
		if(!HAS_STATUS(src, STAT_PARA)) // gated to avoid redundant update_icon() calls.
			SET_STATUS_MAX(src, STAT_PARA, 3)
			update_icon()
	. = ..()
	if(!.)
		return FALSE
	if(z && !living_observers_present(SSmapping.get_connected_levels(z)))
		return
	//Health
	if(stat == DEAD)
		if(health > 0)
			switch_from_dead_to_living_mob_list()
			set_stat(CONSCIOUS)
			set_density(1)
			update_icon()
		return 0

	handle_atmos()

	if(health <= 0)
		death()
		return

	if(health > maxHealth)
		health = maxHealth

	handle_supernatural()
	handle_impaired_vision()

	if(can_bleed && bleed_ticks > 0)
		handle_bleeding()

	delayed_life_action()
	return 1

// Handles timed stuff in Life()
/mob/living/simple_animal/proc/delayed_life_action()
	set waitfor = FALSE
	if(performing_delayed_life_action)
		return
	if(client)
		return
	performing_delayed_life_action = TRUE
	do_delayed_life_action()
	performing_delayed_life_action = FALSE

// For saner overriding; only override this.
/mob/living/simple_animal/proc/do_delayed_life_action()
	if(buckled && can_escape)
		if(istype(buckled, /obj/effect/energy_net))
			var/obj/effect/energy_net/Net = buckled
			Net.escape_net(src)
		else if(prob(50))
			escape(src, buckled)
		else if(prob(50))
			visible_message("<span class='warning'>\The [src] struggles against \the [buckled]!</span>")

	//Movement
	if(lying)
		if(!incapacitated())
			lying = FALSE
			update_icon()
	else if(!stop_automated_movement && !buckled_mob && wander && !anchored)
		if(isturf(src.loc) && !resting)		//This is so it only moves if it's not inside a closet, gentics machine, etc.
			turns_since_move++
			if(turns_since_move >= turns_per_move && (!(stop_automated_movement_when_pulled) || !LAZYLEN(grabbed_by))) //Some animals don't move when pulled
				SelfMove(pick(global.cardinal))
				turns_since_move = 0

	//Speaking
	if(speak_chance)
		if(rand(0,200) < speak_chance)
			var/action = pick(
				speak.len;      "speak",
				emote_hear.len; "emote_hear",
				emote_see.len;  "emote_see"
				)

			switch(action)
				if("speak")
					say(pick(speak))
				if("emote_hear")
					audible_emote("[pick(emote_hear)].")
				if("emote_see")
					visible_emote("[pick(emote_see)].")

/mob/living/simple_animal/proc/handle_atmos(var/atmos_suitable = 1)
	//Atmos
	if(!loc)
		return

	var/datum/gas_mixture/environment = loc.return_air()
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
		if(!(MUTATION_SPACERES in mutations) && abs(environment.temperature - bodytemperature) > 40)
			bodytemperature += ((environment.temperature - bodytemperature) / 5)

	if(bodytemperature < minbodytemp)
		fire_alert = 2
		adjustBruteLoss(cold_damage_per_tick)
	else if(bodytemperature > maxbodytemp)
		fire_alert = 1
		adjustBruteLoss(heat_damage_per_tick)
	else
		fire_alert = 0

	if(!atmos_suitable)
		adjustBruteLoss(unsuitable_atmos_damage)

/mob/living/simple_animal/proc/escape(mob/living/M, obj/O)
	O.unbuckle_mob(M)
	visible_message(SPAN_DANGER("\The [M] escapes from \the [O]!"))

/mob/living/simple_animal/proc/handle_supernatural()
	if(purge)
		purge -= 1

/mob/living/simple_animal/gib()
	..(((mob_icon_state_flags & MOB_ICON_HAS_GIB_STATE) ? "world-gib" : null), TRUE)

/mob/living/simple_animal/proc/visible_emote(var/act_desc)
	custom_emote(1, act_desc)

/mob/living/simple_animal/proc/audible_emote(var/act_desc)
	custom_emote(2, act_desc)

/mob/living/simple_animal/bullet_act(var/obj/item/projectile/Proj)
	if(!Proj || Proj.nodamage)
		return

	var/damage = Proj.damage
	if(Proj.damtype == STUN)
		damage = Proj.damage / 6
	if(Proj.damtype == BRUTE)
		damage = Proj.damage / 2
	if(Proj.damtype == BURN)
		damage = Proj.damage / 1.5
	if(Proj.agony)
		damage += Proj.agony / 6
		if(health < Proj.agony * 3)
			SET_STATUS_MAX(src, STAT_PARA, Proj.agony / 20)
			visible_message("<span class='warning'>[src] is stunned momentarily!</span>")

	bullet_impact_visuals(Proj)
	adjustBruteLoss(damage)
	Proj.on_hit(src)
	return 0

/mob/living/simple_animal/get_hug_zone_messages(var/zone)
	. = ..() || list(response_help_3p, response_help_1p)

/mob/living/simple_animal/default_help_interaction(mob/user)
	if(health > 0 && user.attempt_hug(src))
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
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			var/decl/natural_attack/attack = H.get_unarmed_attack(src)
			if(istype(attack))
				dealt_damage = attack.damage <= dealt_damage ? dealt_damage : attack.damage
				harm_verb = pick(attack.attack_verb)
				if(attack.sharp || attack.edge)
					adjustBleedTicks(dealt_damage)
		adjustBruteLoss(dealt_damage)
		user.visible_message(SPAN_DANGER("\The [user] [harm_verb] \the [src]!"))
		user.do_attack_animation(src)
		return TRUE

/mob/living/simple_animal/attackby(var/obj/item/O, var/mob/user)
	if(istype(O, /obj/item/stack/medical))
		if(stat != DEAD)
			var/obj/item/stack/medical/MED = O
			if(!MED.animal_heal)
				to_chat(user, SPAN_WARNING("\The [MED] won't help \the [src] at all!"))
			else if(health < maxHealth && MED.can_use(1))
				adjustBruteLoss(-MED.animal_heal)
				visible_message(SPAN_NOTICE("\The [user] applies \the [MED] to \the [src]."))
				MED.use(1)
		else
			var/decl/pronouns/G = get_pronouns()
			to_chat(user, SPAN_WARNING("\The [src] is dead, medical items won't bring [G.him] back to life."))
		return TRUE

	if(istype(O, /obj/item/flash) && stat != DEAD)
		return O.attack(src, user, user.get_target_zone())

	if(meat_type && (stat == DEAD) && meat_amount)
		if(istype(O, /obj/item/knife/kitchen/cleaver))
			var/victim_turf = get_turf(src)
			if(!locate(/obj/structure/table, victim_turf))
				to_chat(user, SPAN_WARNING("You need to place \the [src] on a table to butcher it."))
				return TRUE
			var/time_to_butcher = (mob_size)
			to_chat(user, SPAN_WARNING("You begin harvesting \the [src]."))
			if(do_after(user, time_to_butcher, src, same_direction = TRUE))
				if(prob(user.skill_fail_chance(SKILL_COOKING, 60, SKILL_ADEPT)))
					to_chat(user, SPAN_DANGER("You botch harvesting \the [src], and ruin some of the meat in the process."))
					subtract_meat(user)
				else
					harvest(user, user.get_skill_value(SKILL_COOKING))
			else
				to_chat(user, SPAN_DANGER("Your hand slips with your movement, and some of the meat is ruined."))
				subtract_meat(user)
			return TRUE

	else
		if(!O.force || (O.item_flags & ITEM_FLAG_NO_BLUDGEON))
			visible_message(SPAN_NOTICE("\The [user] gently taps [src] with \the [O]."))
			return TRUE
		return O.attack(src, user, user.get_target_zone() || ran_zone())

	return ..()

/mob/living/simple_animal/hit_with_weapon(obj/item/O, mob/living/user, var/effective_force, var/hit_zone)

	visible_message(SPAN_DANGER("\The [src] has been attacked with \the [O] by \the [user]!"))

	if(O.force <= resistance)
		to_chat(user, SPAN_WARNING("This weapon is ineffective; it does no damage."))
		return 0

	var/damage = O.force
	if (O.damtype == PAIN)
		damage = 0
	if (O.damtype == STUN)
		damage = (O.force / 8)
	if(supernatural && istype(O,/obj/item/nullrod))
		damage *= 2
		purge = 3
	adjustBruteLoss(damage)
	if(O.edge || O.sharp)
		adjustBleedTicks(damage)

	return 1

/mob/living/simple_animal/get_movement_delay(var/travel_dir)
	var/tally = ..() //Incase I need to add stuff other than "speed" later

	tally += speed
	if(purge)//Purged creatures will move more slowly. The more time before their purge stops, the slower they'll move.
		if(tally <= 0)
			tally = 1
		tally *= purge

	return tally+config.animal_delay

/mob/living/simple_animal/Stat()
	. = ..()

	if(statpanel("Status") && show_stat_health)
		stat(null, "Health: [round((health / maxHealth) * 100)]%")

/mob/living/simple_animal/death(gibbed, deathmessage = "dies!", show_dead_message)
	density = 0
	adjustBruteLoss(maxHealth) //Make sure dey dead.
	walk_to(src,0)
	. = ..(gibbed,deathmessage,show_dead_message)

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

/mob/living/simple_animal/adjustBruteLoss(damage)
	..()
	updatehealth()

/mob/living/simple_animal/adjustFireLoss(damage)
	..()
	updatehealth()

/mob/living/simple_animal/adjustToxLoss(damage)
	..()
	updatehealth()

/mob/living/simple_animal/adjustOxyLoss(damage)
	..()
	updatehealth()

/mob/living/simple_animal/proc/SA_attackable(target_mob)
	if (isliving(target_mob))
		var/mob/living/L = target_mob
		if(!L.stat && L.health >= 0)
			return (0)
	return 1

/mob/living/simple_animal/say(var/message)
	var/verb = "says"
	if(speak_emote.len)
		verb = pick(speak_emote)

	message = sanitize(message)

	..(message, null, verb)

/mob/living/simple_animal/get_speech_ending(verb, var/ending)
	return verb

/mob/living/simple_animal/put_in_hands(var/obj/item/W) // No hands.
	W.forceMove(get_turf(src))
	return 1

// Harvest an animal's delicious byproducts
/mob/living/simple_animal/proc/harvest(var/mob/user, var/skill_level)
	var/actual_meat_amount = round(max(1,(meat_amount / 2) + skill_level / 2))
	user.visible_message("<span class='danger'>\The [user] chops up \the [src]!</span>")
	if(meat_type && actual_meat_amount > 0 && (stat == DEAD))
		for(var/i=0;i<actual_meat_amount;i++)
			var/obj/item/meat = new meat_type(get_turf(src))
			meat.SetName("[src.name] [meat.name]")
			if(can_bleed)
				var/obj/effect/decal/cleanable/blood/splatter/splat = new(get_turf(src))
				splat.basecolor = bleed_colour
				splat.update_icon()
			qdel(src)

/mob/living/simple_animal/proc/subtract_meat(var/mob/user)
	meat_amount--
	if(meat_amount <= 0)
		to_chat(user, SPAN_NOTICE("\The [src] carcass is ruined beyond use."))

/mob/living/simple_animal/bullet_impact_visuals(var/obj/item/projectile/P, var/def_zone)
	..()
	switch(get_bullet_impact_effect_type(def_zone))
		if(BULLET_IMPACT_MEAT)
			if(P.damtype == BRUTE)
				var/hit_dir = get_dir(P.starting, src)
				var/obj/effect/decal/cleanable/blood/B = blood_splatter(get_step(src, hit_dir), src, 1, hit_dir)
				B.icon_state = pick("dir_splatter_1","dir_splatter_2")
				B.basecolor = bleed_colour
				var/scale = min(1, round(mob_size / MOB_SIZE_MEDIUM, 0.1))
				B.set_scale(scale)
				B.update_icon()

/mob/living/simple_animal/handle_fire()
	return

/mob/living/simple_animal/update_fire()
	return
/mob/living/simple_animal/IgniteMob()
	return
/mob/living/simple_animal/ExtinguishMob()
	return

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

/mob/living/simple_animal/proc/handle_bleeding()
	bleed_ticks--
	adjustBruteLoss(1)

	var/obj/effect/decal/cleanable/blood/drip/drip = new(get_turf(src))
	drip.basecolor = bleed_colour
	drip.update_icon()

/mob/living/simple_animal/get_digestion_product()
	return /decl/material/liquid/nutriment

/mob/living/simple_animal/eyecheck()
	switch(flash_vulnerability)
		if(2 to INFINITY)
			return FLASH_PROTECTION_REDUCED
		if(1)
			return FLASH_PROTECTION_NONE
		if(0)
			return FLASH_PROTECTION_MAJOR
		else
			return FLASH_PROTECTION_MAJOR

/mob/living/simple_animal/proc/reflect_unarmed_damage(var/mob/living/carbon/human/attacker, var/damage_type, var/description)
	if(attacker.a_intent == I_HURT)
		attacker.apply_damage(rand(return_damage_min, return_damage_max), damage_type, attacker.get_active_held_item_slot(), used_weapon = description)
		if(rand(25))
			to_chat(attacker, SPAN_WARNING("Your attack has no obvious effect on \the [src]'s [description]!"))

/mob/living/simple_animal/proc/get_natural_weapon()
	if(ispath(natural_weapon))
		natural_weapon = new natural_weapon(src)
	return natural_weapon

/mob/living/simple_animal/getCloneLoss()
	. = max(0, gene_damage)

/mob/living/simple_animal/adjustCloneLoss(var/amount)
	setCloneLoss(gene_damage + amount)

/mob/living/simple_animal/setCloneLoss(amount)
	if(gene_damage >= 0)
		gene_damage = clamp(amount, 0, maxHealth)
		if(gene_damage >= maxHealth)
			death()

/mob/living/simple_animal/get_admin_job_string()
	return "Animal"

/mob/living/simple_animal/get_telecomms_race_info()
	return list("Domestic Animal", FALSE)

/mob/living/simple_animal/handle_flashed(var/obj/item/flash/flash, var/flash_strength)
	var/safety = eyecheck()
	if(safety < FLASH_PROTECTION_MAJOR)
		SET_STATUS_MAX(src, STAT_WEAK, 2)
		if(safety < FLASH_PROTECTION_MODERATE)
			SET_STATUS_MAX(src, STAT_STUN, (flash_strength - 2))
			SET_STATUS_MAX(src, STAT_BLURRY, flash_strength)
			SET_STATUS_MAX(src, STAT_CONFUSE, flash_strength)
			flash_eyes(2)
		return TRUE
	return FALSE

/mob/living/simple_animal/get_speech_bubble_state_modifier()
	return ..() || "rough"

/mob/living/simple_animal/proc/can_act()
	return !(QDELETED(src) || incapacitated() || (is_aquatic && !submerged()))
