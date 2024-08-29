/mob/living/simple_animal/hostile/jelly
	name = "zeq"
	desc = "It looks like a floating jellyfish. How does it do that?"
	faction = "zeq"
	icon = 'icons/mob/simple_animal/jelly.dmi'
	move_intents = list(
		/decl/move_intent/walk/animal_fast,
		/decl/move_intent/run/animal_fast
	)
	max_health = 75
	natural_weapon = /obj/item/natural_weapon/tentacles
	ai = /datum/mob_controller/aggressive/jelly
	base_movement_delay = 1
	var/gets_random_color = TRUE

/datum/mob_controller/aggressive/jelly
	speak_chance = 0.25
	emote_see = list("wobbles slightly","oozes something out of tentacles' ends")
	only_attack_enemies = TRUE

/obj/item/natural_weapon/tentacles
	name = "tentacles"
	attack_verb = list("stung","slapped")
	_base_attack_force = 10
	atom_damage_type =  BURN

/mob/living/simple_animal/hostile/jelly/Initialize()
	. = ..()
	if(gets_random_color)
		color = color_matrix_rotate_hue(round(rand(0,360),20))

/mob/living/simple_animal/hostile/jelly/alt
	icon = 'icons/mob/simple_animal/jelly_alt.dmi'

//megajellyfish
/mob/living/simple_animal/hostile/jelly/mega
	name = "zeq queen"
	desc = "A gigantic jellyfish-like creature. Its bell wobbles about almost as if it's ready to burst."
	max_health = 300
	gets_random_color = FALSE
	ai = /datum/mob_controller/aggressive/megajelly

	var/jelly_scale = 3
	var/split_type = /mob/living/simple_animal/hostile/jelly/mega/half
	var/static/megajelly_color

/datum/mob_controller/aggressive/megajelly
	can_escape_buckles = TRUE

/mob/living/simple_animal/hostile/jelly/mega/Initialize()
	. = ..()
	set_scale(jelly_scale)
	var/obj/item/attacking_with = get_natural_weapon()
	if(attacking_with)
		attacking_with.set_base_attack_force(attacking_with.get_initial_base_attack_force() * jelly_scale)
	if(!megajelly_color)
		megajelly_color = color_matrix_rotate_hue(round(rand(0,360),20))
	color = megajelly_color

/mob/living/simple_animal/hostile/jelly/mega/death(gibbed)
	if(split_type)
		jelly_split()
		return TRUE
	return ..()

/mob/living/simple_animal/hostile/jelly/mega/proc/jelly_split()
	visible_message(SPAN_MFAUNA("\The [src] rumbles briefly before splitting into two!"))
	var/kidnum = 2
	for(var/i = 0 to kidnum)
		var/mob/living/simple_animal/child = new split_type(get_turf(src))
		child.min_gas = min_gas.Copy()
		child.max_gas = max_gas.Copy()
		child.minbodytemp = minbodytemp
		child.maxbodytemp = maxbodytemp
	QDEL_NULL(src)

/mob/living/simple_animal/hostile/jelly/mega/half
	name = "zeq duchess"
	desc = "A huge jellyfish-like creature."
	max_health = 150
	jelly_scale = 1.5
	split_type = /mob/living/simple_animal/hostile/jelly/mega/quarter

/mob/living/simple_animal/hostile/jelly/mega/quarter
	name = "zeqling"
	desc = "A jellyfish-like creature."
	max_health = 75
	jelly_scale = 0.75
	split_type = /mob/living/simple_animal/hostile/jelly/mega/fourth
	ai = /datum/mob_controller/aggressive

/mob/living/simple_animal/hostile/jelly/mega/fourth
	name = "zeqetta"
	desc = "A tiny jellyfish-like creature."
	max_health = 40
	jelly_scale = 0.375
	split_type = /mob/living/simple_animal/hostile/jelly/mega/eighth

/mob/living/simple_animal/hostile/jelly/mega/eighth
	name = "zeqttina"
	desc = "An absolutely tiny jellyfish-like creature."
	max_health = 20
	jelly_scale = 0.1875
	split_type = null