/mob/living/simple_animal/hostile/carp
	name = "space carp"
	desc = "A ferocious, fang-bearing creature that resembles a fish."
	icon = 'icons/mob/simple_animal/space_carp.dmi'
	speak_chance = 0
	turns_per_move = 3
	speed = 2
	maxHealth = 50
	health = 50

	harm_intent_damage = 8
	natural_weapon = /obj/item/natural_weapon/bite
	pry_time = 10 SECONDS
	melee_damage_flags = DAM_SHARP
	pry_desc = "biting"

	//Space carp aren't affected by atmos.
	min_gas = null
	max_gas = null
	minbodytemp = 0

	break_stuff_probability = 25
	faction = "carp"
	bleed_colour = "#5d0d71"
	pass_flags = PASS_FLAG_TABLE

	meat_type = /obj/item/chems/food/fish/poison
	skin_material = /decl/material/solid/skin/fish/purple
	bone_material = /decl/material/solid/bone/cartilage
	var/carp_color = COLOR_PURPLE

/mob/living/simple_animal/hostile/carp/Initialize()
	. = ..()
	carp_randomify()
	update_icon()

/mob/living/simple_animal/hostile/carp/proc/carp_randomify()
	maxHealth = rand(initial(maxHealth), (1.5 * initial(maxHealth)))
	health = maxHealth
	if(prob(1))
		carp_color = pick(COLOR_WHITE, COLOR_BLACK)
	else
		carp_color = pick(COLOR_PURPLE, COLOR_BLUE, COLOR_YELLOW, COLOR_GREEN, COLOR_RED, COLOR_TEAL)

/mob/living/simple_animal/hostile/carp/on_update_icon()
	. = ..()
	color = carp_color
	var/image/I = image(icon, "[icon_state]-eyes")
	I.appearance_flags |= RESET_COLOR
	add_overlay(I)

/mob/living/simple_animal/hostile/carp/Process_Spacemove()
	return 1	//No drifting in space for space carp!	//original comments do not steal

/mob/living/simple_animal/hostile/carp/FindTarget()
	. = ..()
	if(.)
		custom_emote(1,"nashes at [.]")