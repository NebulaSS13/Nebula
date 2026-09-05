/datum/mob_controller/passive/glitterfly
	emote_speech = list("Pi..","Po...", "Pa...")
	emote_see    = list("vibrates","flutters", "twirls")
	emote_hear   = list("pips", "clicks", "chirps")

/mob/living/simple_animal/passive/glitterfly
	name = "glitterfly"
	desc = "A large, shiny butterfly!"
	icon = 'mods/content/polaris/icons/wildlife/glitterfly.dmi'
	max_health = 10
	base_movement_delay = -1
	ai = /datum/mob_controller/passive/glitterfly

/mob/living/simple_animal/passive/glitterfly/Initialize()
	. = ..()
	var/colorlist = list(rgb(rand(100,255), rand(100,255), rand(100,255)) =  10, rgb(rand(5,100), rand(5,100), rand(5,100)) = 2, "#222222" = 1)
	set_color(pickweight(colorlist))
	default_pixel_y = rand(5,12)
	reset_offsets(0)
	set_scale(round(rand(90, 105) / 100))

/*
	hovering = TRUE

	attacktext = list("bit", "buffeted", "slashed")
	melee_damage_lower = 1
	melee_damage_upper = 2
	attack_armor_pen = 80
	attack_sharp = TRUE
*/

/mob/living/simple_animal/passive/glitterfly/rare
	name = "sparkling glitterfly"
	desc = "A large, incredibly shiny butterfly!"
	layer = ABOVE_LIGHTING_LAYER
	plane = ABOVE_LIGHTING_PLANE
	max_health = 30

/*
	melee_damage_upper = 5
*/
