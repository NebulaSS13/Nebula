
/datum/mob_controller/aggressive/goat/king
	break_stuff_probability = 35
	emote_hear = list("brays in a booming voice")
	emote_see = list("stamps a mighty foot, shaking the surroundings")
	only_attack_enemies = TRUE
	can_escape_buckles = TRUE

/datum/mob_controller/aggressive/goat/king/retaliate(atom/source)
	..()
	if(body?.stat == CONSCIOUS && prob(5))
		var/decl/pronouns/pronouns = body.get_pronouns()
		body.visible_message(SPAN_WARNING("\The [body] bellows indignantly, with a judgemental gleam in [pronouns.his] eye."))

/datum/mob_controller/aggressive/goat/king/phase2
	break_stuff_probability = 40

/datum/mob_controller/aggressive/goat/king/phase2/retaliate(atom/source)
	. = ..()
	var/mob/living/simple_animal/hostile/goat/king/phase2/goat = body
	if(istype(goat))
		goat.do_retaliation()

//Visager's tracks 'Battle!' and 'Miniboss Fight' from the album 'Songs from an Unmade World 2' are available here
//http://freemusicarchive.org/music/Visager/Songs_From_An_Unmade_World_2/ and are made available under the CC BY 4.0 Attribution license,
//which is available for viewing here: https://creativecommons.org/licenses/by/4.0/legalcode

//the king and his court
/mob/living/simple_animal/hostile/goat/king
	name = "king of goats"
	desc = "The oldest and wisest of goats; king of his race, peerless in dignity and power. His golden fleece radiates nobility."
	icon = 'icons/mob/simple_animal/goat_king.dmi'
	speak_emote = list("brays in a booming voice")
	ai = /datum/mob_controller/aggressive/goat/king
	response_harm = "assaults"
	max_health = 500
	mob_size = MOB_SIZE_LARGE
	mob_bump_flag = HEAVY
	move_intents = list(
		/decl/move_intent/walk/animal,
		/decl/move_intent/run/animal
	)
	min_gas = null
	max_gas = null
	minbodytemp = 0
	flash_protection = FLASH_PROTECTION_MAJOR
	natural_weapon = /obj/item/natural_weapon/goatking
	var/current_damtype = BRUTE
	var/list/elemental_weapons = list(
		BURN = /obj/item/natural_weapon/goatking/fire,
		ELECTROCUTE = /obj/item/natural_weapon/goatking/lightning
	)
	var/stun_chance = 5 //chance per attack to Weaken target

/mob/living/simple_animal/hostile/goat/king/proc/OnDeath()
	visible_message("<span class='cultannounce'>\The [src] lets loose a terrific wail as its wounds close shut with a flash of light, and its eyes glow even brighter than before!</span>")
	new /mob/living/simple_animal/hostile/goat/king/phase2(src.loc)
	qdel(src)

/mob/living/simple_animal/hostile/goat/king/death(gibbed)
	. = ..()
	if(.)
		OnDeath()

/mob/living/simple_animal/hostile/goat/king/apply_attack_effects(mob/living/target)
	. = ..()
	if(prob(stun_chance))
		SET_STATUS_MAX(target, STAT_WEAK, 0.5)
		ADJ_STATUS(target, STAT_CONFUSE, 1)
		visible_message(SPAN_WARNING("\The [target] is bowled over by the impact of [src]'s attack!"))

/mob/living/simple_animal/hostile/goat/king/Process_Spacemove()
	return 1

/mob/living/simple_animal/hostile/goat/king/get_natural_weapon()
	if(!(current_damtype in elemental_weapons))
		return ..()
	if(ispath(elemental_weapons[current_damtype]))
		var/T = elemental_weapons[current_damtype]
		elemental_weapons[current_damtype] = new T(src)
	return elemental_weapons[current_damtype]

/obj/item/natural_weapon/goatking
	name = "giant horns"
	attack_verb = list("brutalized")
	_base_attack_force = 40
	sharp = TRUE

/obj/item/natural_weapon/goatking/fire
	name = "burning horns"
	atom_damage_type =  BURN

/obj/item/natural_weapon/goatking/lightning
	name = "lightning horns"
	atom_damage_type =  ELECTROCUTE

/mob/living/simple_animal/hostile/goat/guard
	name = "honour guard"
	desc = "A very handsome and noble beast."
	icon = 'icons/mob/simple_animal/goat_guard.dmi'
	max_health = 125
	natural_weapon = /obj/item/natural_weapon/goathorns

/obj/item/natural_weapon/goathorns
	name = "horns"
	attack_verb = list("impaled", "stabbed")
	_base_attack_force = 15
	sharp = TRUE

/mob/living/simple_animal/hostile/goat/guard/master
	name = "master of the guard"
	desc = "A very handsome and noble beast - the most trusted of all the king's men."
	icon = 'icons/mob/simple_animal/goat_master.dmi'
	max_health = 200
	natural_weapon = /obj/item/natural_weapon/goathorns

/mob/living/simple_animal/hostile/goat/king/phase2
	name = "emperor of goats"
	desc = "The King of Kings, God amongst men, and your superior in every way."
	icon = 'icons/mob/simple_animal/goat_king_phase_2.dmi'
	max_health = 750
	natural_weapon = /obj/item/natural_weapon/goatking/unleashed
	elemental_weapons = list(
		BURN = /obj/item/natural_weapon/goatking/fire/unleashed,
		ELECTROCUTE = /obj/item/natural_weapon/goatking/lightning/unleashed
	)
	default_pixel_y = 5
	stun_chance = 7
	ai = /datum/mob_controller/aggressive/goat/king/phase2

	var/spellscast = 0
	var/phase3 = FALSE
	var/datum/sound_token/boss_theme
	var/sound_id = "goat"
	var/special_attacks = 0

/obj/item/natural_weapon/goatking/unleashed
	_base_attack_force = 55

/obj/item/natural_weapon/goatking/lightning/unleashed
	_base_attack_force = 55

/obj/item/natural_weapon/goatking/fire/unleashed
	_base_attack_force = 55

/mob/living/simple_animal/hostile/goat/king/phase2/Initialize()
	. = ..()
	boss_theme = play_looping_sound(src, sound_id, 'sound/music/Visager-Battle.ogg', volume = 10, range = 7, falloff = 4, prefer_mute = TRUE)
	update_icon()

/mob/living/simple_animal/hostile/retaliate/goat/guard
	name = "honour guard"
	desc = "A very handsome and noble beast."
	icon = 'icons/mob/simple_animal/goat_guard.dmi'
	max_health = 125
	natural_weapon = /obj/item/natural_weapon/goathorns

/obj/item/natural_weapon/goathorns
	name = "horns"
	attack_verb = list("impaled", "stabbed")
	_base_attack_force = 15
	sharp = TRUE

/mob/living/simple_animal/hostile/retaliate/goat/guard/master
	name = "master of the guard"
	desc = "A very handsome and noble beast - the most trusted of all the king's men."
	icon = 'icons/mob/simple_animal/goat_master.dmi'
	max_health = 200
	natural_weapon = /obj/item/natural_weapon/goathorns
	move_intents = list(
		/decl/move_intent/walk/animal,
		/decl/move_intent/run/animal
	)

/mob/living/simple_animal/hostile/goat/king/phase2/proc/do_retaliation()
	set waitfor = FALSE
	if(spellscast < 5)
		if(prob(5)) //stun move
			spellscast++
			visible_message(SPAN_MFAUNA("\The [src]' fleece flashes with blinding light!"))
			new /obj/item/grenade/flashbang/instant(src.loc)

		else if(prob(5)) //spawn adds
			spellscast++
			visible_message(SPAN_MFAUNA("\The [src] summons the imperial guard to his aid, and they appear in a flash!"))
			new /mob/living/simple_animal/hostile/goat/guard/master(get_step(src,pick(global.cardinal)))
			new /mob/living/simple_animal/hostile/goat/guard(get_step(src,pick(global.cardinal)))
			new /mob/living/simple_animal/hostile/goat/guard(get_step(src,pick(global.cardinal)))

		else if(prob(5)) //EMP blast
			spellscast++
			visible_message(SPAN_MFAUNA("\The [src] disrupts nearby electrical equipment!"))
			empulse(get_turf(src), 5, 2, 0)

		else if(prob(5) && current_damtype == BRUTE && !special_attacks) //elemental attacks
			spellscast++
			if(prob(50))
				visible_message(SPAN_MFAUNA("\The [src]' horns flicker with holy white flame!"))
				current_damtype = BURN
			else
				visible_message(SPAN_MFAUNA("\The [src]' horns glimmer, electricity arcing between them!"))
				current_damtype = ELECTROCUTE

		else if(prob(5)) //earthquake spell
			visible_message("<span class='cultannounce'>\The [src]' eyes begin to glow ominously as dust and debris in the area is kicked up in a light breeze.</span>")
			ai?.pause()
			if(do_after(src, 6 SECONDS, src))
				var/initial_brute = get_damage(BRUTE)
				var/initial_burn = get_damage(BURN)
				visible_message(SPAN_MFAUNA("\The [src] raises its fore-hooves and stomps them into the ground with incredible force!"))
				explosion(get_step(src,pick(global.cardinal)), -1, 2, 2, 3, 6)
				explosion(get_step(src,pick(global.cardinal)), -1, 1, 4, 4, 6)
				explosion(get_step(src,pick(global.cardinal)), -1, 3, 4, 3, 6)
				spellscast += 2
				set_damage(BRUTE, initial_brute)
				set_damage(BURN, initial_burn)
			else
				visible_message(SPAN_NOTICE("The [src] loses concentration and huffs haughtily."))
			ai?.resume()

		else return

/mob/living/simple_animal/hostile/goat/king/phase2/proc/phase3_transition()
	phase3 = TRUE
	spellscast = 0
	max_health = 750
	current_health = max_health
	new /obj/item/grenade/flashbang/instant(src.loc)
	QDEL_NULL(boss_theme)
	boss_theme = play_looping_sound(src, sound_id, 'sound/music/Visager-Miniboss_Fight.ogg', volume = 10, range = 8, falloff = 4, prefer_mute = TRUE)
	stun_chance = 10
	update_icon()
	visible_message("<span class='cultannounce'>\The [src]' wounds close with a flash, and when he emerges, he's even larger than before!</span>")

/mob/living/simple_animal/hostile/goat/king/phase2/on_update_icon()
	..()
	if(phase3)
		icon_state += "-enraged"
		set_scale(1.5)
	else
		set_scale(1.25)
	default_pixel_y = 10

/mob/living/simple_animal/hostile/goat/king/phase2/handle_living_non_stasis_processes()
	. = ..()
	if(!.)
		return FALSE
	if(special_attacks >= 6 && current_damtype != BRUTE)
		visible_message(SPAN_MFAUNA("The energy surrounding \the [src]'s horns dissipates."))
		current_damtype = BRUTE
	if(current_health <= 150 && !phase3 && spellscast == 5) //begin phase 3, reset spell limit and heal
		phase3_transition()

/mob/living/simple_animal/hostile/goat/king/phase2/OnDeath()
	QDEL_NULL(boss_theme)
	if(phase3)
		visible_message(SPAN_MFAUNA("\The [src] shrieks as the seal on his power breaks and his wool sheds off!"))
		new /obj/item/towel/fleece(src.loc)

/mob/living/simple_animal/hostile/goat/king/phase2/Destroy()
	QDEL_NULL(boss_theme)
	. = ..()

/mob/living/simple_animal/hostile/goat/king/phase2/apply_attack_effects(mob/living/target)
	. = ..()
	if(current_damtype != BRUTE)
		special_attacks++
