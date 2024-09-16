/mob/living/simple_animal/hostile/carp
	name = "space carp"
	desc = "A ferocious, fang-bearing creature that resembles a fish."
	icon = 'icons/mob/simple_animal/space_carp.dmi'

	max_health = 50
	harm_intent_damage = 8
	natural_weapon = /obj/item/natural_weapon/bite
	base_movement_delay = 2

	//Space carp aren't affected by atmos.
	min_gas = null
	max_gas = null
	minbodytemp = 0
	faction = "carp"
	bleed_colour = "#5d0d71"
	pass_flags = PASS_FLAG_TABLE
	butchery_data = /decl/butchery_data/animal/fish/space_carp
	ai = /datum/mob_controller/aggressive/carp
	ability_handlers = list(/datum/ability_handler/predator)

	var/carp_color = COLOR_PURPLE

/datum/mob_controller/aggressive/carp
	speak_chance = 0
	turns_per_wander = 6
	break_stuff_probability = 25

/datum/mob_controller/aggressive/carp/find_target()
	. = ..()
	if(.)
		body.custom_emote(VISIBLE_MESSAGE,"gnashes at [.]")

/mob/living/simple_animal/hostile/carp/get_pry_desc()
	return "gnashing"

/mob/living/simple_animal/hostile/carp/get_door_pry_time()
	return 10 SECONDS

/mob/living/simple_animal/hostile/carp/Initialize()
	. = ..()
	carp_randomify()
	update_icon()

/mob/living/simple_animal/hostile/carp/proc/carp_randomify()
	max_health = rand(initial(max_health), (1.5 * initial(max_health)))
	current_health = max_health
	if(prob(1))
		carp_color = pick(COLOR_WHITE, COLOR_BLACK)
	else
		carp_color = pick(COLOR_PURPLE, COLOR_BLUE, COLOR_YELLOW, COLOR_GREEN, COLOR_RED, COLOR_TEAL)

/mob/living/simple_animal/hostile/carp/on_update_icon()
	. = ..()
	color = carp_color
	if(check_state_in_icon("[icon_state]-eyes", icon))
		var/image/I = image(icon, "[icon_state]-eyes")
		I.appearance_flags |= RESET_COLOR
		add_overlay(I)

/mob/living/simple_animal/hostile/carp/Process_Spacemove()
	return 1	//No drifting in space for space carp!	//original comments do not steal
