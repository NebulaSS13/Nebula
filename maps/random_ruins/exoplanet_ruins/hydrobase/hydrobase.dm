/datum/map_template/ruin/exoplanet/hydrobase
	name = "hydroponics base"
	description = "A hydroponics base with random plants and a lot of enemies."
	suffixes = list("hydrobase/hydrobase.dmm")
	cost = 2
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS | TEMPLATE_FLAG_NO_RUINS
	template_tags = TEMPLATE_TAG_ALIEN
	apc_test_exempt_areas = list(
		/area/map_template/hydrobase = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/map_template/hydrobase/station = NO_SCRUBBER,
		/area/map_template/hydrobase/station/solarlock = NO_SCRUBBER|NO_VENT,
		/area/map_template/hydrobase/station/dockport = NO_SCRUBBER|NO_VENT
	)

// Areas //
/area/map_template/hydrobase
	name = "\improper Hydroponics Base X207"
	icon_state = "hydro"
	icon = 'maps/random_ruins/exoplanet_ruins/hydrobase/hydro.dmi'

/area/map_template/hydrobase/solars
	name = "\improper X207 Solar Array"
	icon_state = "solar"

/area/map_template/hydrobase/station/processing
	name = "\improper X207 Processing Area"
	icon_state = "processing"

/area/map_template/hydrobase/station/shipaccess
	name = "\improper X207 Shipping Access"
	icon_state = "shipping"

/area/map_template/hydrobase/station/shower
	name = "\improper X207 Clean Room"
	icon_state = "shower"

/area/map_template/hydrobase/station/growA
	name = "\improper X207 Growing Zone A"
	icon_state = "A"

/area/map_template/hydrobase/station/growB
	name = "\improper X207 Growing Zone B"
	icon_state = "B"

/area/map_template/hydrobase/station/growC
	name = "\improper X207 Growing Zone C"
	icon_state = "C"

/area/map_template/hydrobase/station/growD
	name = "\improper X207 Growing Zone D"
	icon_state = "D"

/area/map_template/hydrobase/station/growF //nobody knows what happened to growing zone e
	name = "\improper X207 Growing Zone F"
	icon_state = "F"

/area/map_template/hydrobase/station/growX
	name = "\improper X207 Growing Zone X"
	icon_state = "X"

/area/map_template/hydrobase/station/goatzone
	name = "\improper X207 Containment Zone"
	icon_state = "goatzone"

/area/map_template/hydrobase/station/dockport
	name = "\improper X207 Access Port"
	icon_state = "airlock"

/area/map_template/hydrobase/station/solarlock
	name = "\improper X207 External Airlock"
	icon_state = "airlock"


// Objs //
/obj/structure/closet/secure_closet/hydroponics/hydro
	name = "hydroponics supplies locker"
	req_access = list()

/obj/item/projectile/beam/drone/weak
	damage = 7


// Mobs //
/mob/living/simple_animal/hostile/goat/hydro
	name = "goat"
	desc = "An impressive goat, in size and coat. His horns look pretty serious!"
	max_health = 100
	natural_weapon = /obj/item/natural_weapon/hooves/strong
	faction = "farmbots"

/obj/item/natural_weapon/hooves/strong
	_base_attack_force = 15

/mob/living/simple_animal/hostile/malf_drone/hydro
	name = "Farmbot"
	desc = "The botanist's best friend. There's something slightly odd about the way it moves."
	icon = 'maps/random_ruins/exoplanet_ruins/hydrobase/farmbot.dmi'
	faction = "farmbots"
	max_health = 225
	ai = /datum/mob_controller/aggressive/malf_drone/hydro

/datum/mob_controller/aggressive/malf_drone/hydro
	malfunctioning = 0
	emote_speech = list("Initiating harvesting subrout-ine-ine.", "Connection timed out.", "Connection with master AI syst-tem-tem lost.", "Core systems override enab-...")
	emote_see    = list("beeps repeatedly", "whirrs violently", "flashes its indicator lights", "emits a ping sound")

/mob/living/simple_animal/hostile/malf_drone/hydro/Initialize()
	. = ..()
	if(prob(15))
		projectiletype = /obj/item/projectile/beam/drone/weak

/mob/living/simple_animal/hostile/malf_drone/hydro/emp_act(severity)
	take_damage(rand(5, 10) * (severity + 1))
	disabled = rand(15, 30)
	var/datum/mob_controller/aggressive/malf_drone/drone_brain = ai
	if(istype(drone_brain))
		drone_brain.malfunctioning = 1
		drone_brain.hostile_drone = 1
		drone_brain.try_destroy_surroundings = TRUE
	projectiletype = initial(projectiletype)
	stop_automove()
