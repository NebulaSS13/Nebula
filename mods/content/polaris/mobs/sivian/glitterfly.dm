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
	natural_weapon = /obj/item/natural_weapon/glitterfly_wings

/mob/living/simple_animal/passive/glitterfly/can_overcome_gravity()
	return !incapacitated()

/mob/living/simple_animal/passive/glitterfly/handle_regular_status_updates()
	. = ..()
	if(incapacitated())
		stop_floating()
	else
		start_floating()

/mob/living/simple_animal/passive/glitterfly/death(gibbed)
	. = ..()
	if(. && !gibbed)
		stop_floating()

/obj/item/natural_weapon/glitterfly_wings
	name = "wings"
	_base_attack_force = 1
	armor_penetration = 80
	attack_verb = list("bit", "buffeted", "slashed")
	sharp = TRUE

/mob/living/simple_animal/passive/glitterfly/Initialize()
	. = ..()
	var/colorlist = list(rgb(rand(100,255), rand(100,255), rand(100,255)) =  10, rgb(rand(5,100), rand(5,100), rand(5,100)) = 2, "#222222" = 1)
	set_color(pickweight(colorlist))
	default_pixel_y = rand(5,12)
	reset_offsets(0)
	set_scale(round(rand(90, 105) / 100))

/mob/living/simple_animal/passive/glitterfly/rare
	name = "sparkling glitterfly"
	desc = "A large, incredibly shiny butterfly!"
	layer = ABOVE_LIGHTING_LAYER
	plane = ABOVE_LIGHTING_PLANE
	max_health = 30
	natural_weapon = /obj/item/natural_weapon/glitterfly_wings/rare

/obj/item/natural_weapon/glitterfly_wings/rare
	_base_attack_force = 5
