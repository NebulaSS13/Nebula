#include "slavers_base_areas.dm"
#include "../mining/mining_areas.dm"

/obj/effect/overmap/visitable/sector/slavers_base
	name = "large asteroid"
	desc = "Sensor array is reading an artificial structure inside the asteroid."
	icon_state = "object"
	initial_generic_waypoints = list(
		"nav_slavers_base_1",
		"nav_slavers_base_2",
		"nav_slavers_base_3",
		"nav_slavers_base_4",
		"nav_slavers_base_5",
		"nav_slavers_base_6",
		"nav_slavers_base_antag"
	)

/datum/map_template/ruin/away_site/slavers
	name = "Slavers' Base"
	description = "Asteroid with slavers base inside."
	suffixes = list("slavers/slavers_base.dmm")
	cost = 1
	level_data_type = /datum/level_data/mining_level
	area_usage_test_exempted_root_areas = list(/area/slavers_base)
	apc_test_exempt_areas = list(
		/area/slavers_base/hangar = NO_SCRUBBER
	)

/obj/effect/shuttle_landmark/nav_slavers_base/nav1
	name = "Slavers Base Navpoint #1"
	landmark_tag = "nav_slavers_base_1"

/obj/effect/shuttle_landmark/nav_slavers_base/nav2
	name = "Slavers Base Navpoint #2"
	landmark_tag = "nav_slavers_base_2"

/obj/effect/shuttle_landmark/nav_slavers_base/nav3
	name = "Slavers Base Navpoint #3"
	landmark_tag = "nav_slavers_base_3"

/obj/effect/shuttle_landmark/nav_slavers_base/nav4
	name = "Slavers Base Navpoint #4"
	landmark_tag = "nav_slavers_base_4"

/obj/effect/shuttle_landmark/nav_slavers_base/nav5
	name = "Slavers Base Navpoint #5"
	landmark_tag = "nav_slavers_base_5"

/obj/effect/shuttle_landmark/nav_slavers_base/nav6
	name = "Slavers Base Navpoint #6"
	landmark_tag = "nav_slavers_base_6"

/obj/effect/shuttle_landmark/nav_slavers_base/nav7
	name = "Slavers Base Navpoint #7"
	landmark_tag = "nav_slavers_base_antag"

/decl/outfit/corpse
	name = "Corpse Clothing"
	abstract_type = /decl/outfit/corpse

/decl/outfit/corpse/slavers_base
	name = "Basic slaver output"

/obj/abstract/landmark/corpse/slavers_base
	abstract_type = /obj/abstract/landmark/corpse/slavers_base

/obj/abstract/landmark/corpse/slavers_base/slaver1
	name = "Slaver"
	corpse_outfits = list(/decl/outfit/corpse/slavers_base/slaver1)

/decl/outfit/corpse/slavers_base/slaver1
	name = "Dead Slaver 1"
	uniform = /obj/item/clothing/jumpsuit/johnny
	shoes = /obj/item/clothing/shoes/color/black
	glasses = /obj/item/clothing/glasses/sunglasses

/obj/abstract/landmark/corpse/slavers_base/slaver2
	name = "Slaver"
	corpse_outfits = list(/decl/outfit/corpse/slavers_base/slaver2)

/decl/outfit/corpse/slavers_base/slaver2
	name = "Dead Slaver 2"
	uniform = /obj/item/clothing/jumpsuit/johnny
	shoes = /obj/item/clothing/shoes/color/blue

/obj/abstract/landmark/corpse/slavers_base/slaver3
	name = "Slaver"
	corpse_outfits = list(/decl/outfit/corpse/slavers_base/slaver3)

/decl/outfit/corpse/slavers_base/slaver3
	name = "Dead Slaver 3"
	uniform = /obj/item/clothing/costume/pirate
	shoes = /obj/item/clothing/shoes/color/brown

/obj/abstract/landmark/corpse/slavers_base/slaver4
	name = "Slaver"
	corpse_outfits = list(/decl/outfit/corpse/slavers_base/slaver4)

/decl/outfit/corpse/slavers_base/slaver4
	name = "Dead Slaver 4"
	uniform = /obj/item/clothing/costume/redcoat
	shoes = /obj/item/clothing/shoes/color/brown

/obj/abstract/landmark/corpse/slavers_base/slaver5
	name = "Slaver"
	corpse_outfits = list(/decl/outfit/corpse/slavers_base/slaver5)

/decl/outfit/corpse/slavers_base/slaver5
	name = "Dead Slaver 5"
	uniform = /obj/item/clothing/jumpsuit/sterile
	shoes = /obj/item/clothing/shoes/color/orange
	mask = /obj/item/clothing/mask/surgical

/obj/abstract/landmark/corpse/slavers_base/slaver6
	name = "Slaver"
	corpse_outfits = list(/decl/outfit/corpse/slavers_base/slaver6)

/decl/outfit/corpse/slavers_base/slaver6
	name = "Dead Slaver 6"
	uniform = /obj/item/clothing/shirt/flannel/red/outfit
	shoes = /obj/item/clothing/shoes/color/orange

/obj/abstract/landmark/corpse/slavers_base/slave
	name = "Slave"
	corpse_outfits = list(/decl/outfit/corpse/slavers_base/slave)

/decl/outfit/corpse/slavers_base/slave
	name = "Dead Slave"
	uniform = /obj/item/clothing/jumpsuit/orange
	shoes = /obj/item/clothing/shoes/jackboots/tactical

/mob/living/simple_animal/hostile/abolition_extremist
	name = "abolition extremist"
	desc = "Vigiliant fighter against slavery."
	icon = 'maps/away/slavers/icons/abolitionist.dmi'

	max_health = 100
	natural_weapon = /obj/item/natural_weapon/punch
	unsuitable_atmos_damage = 15
	projectilesound = 'sound/weapons/laser.ogg'
	projectiletype = /obj/item/projectile/beam
	faction = "extremist abolitionists"
	ai = /datum/mob_controller/abolitionist
	var/corpse = /obj/abstract/landmark/corpse/abolitionist
	var/weapon = /obj/item/gun/energy/laser

/mob/living/simple_animal/hostile/abolition_extremist/has_ranged_attack()
	return TRUE

/datum/mob_controller/abolitionist
	speak_chance = 0
	turns_per_wander = 10
	stop_wander_when_pulled = 0
	can_escape_buckles = TRUE

/mob/living/simple_animal/hostile/abolition_extremist/death(gibbed)
	. = ..()
	if(. && !gibbed)
		if(corpse)
			new corpse(loc)
		if(weapon)
			new weapon(loc)
		qdel(src)

/obj/abstract/landmark/corpse/abolitionist
	name = "abolitionist"
	corpse_outfits = list(/decl/outfit/corpse/abolitionist)

/decl/outfit/corpse/abolitionist
	name = "Dead abolitionist"
	uniform = /obj/item/clothing/jumpsuit/abolitionist
	shoes = /obj/item/clothing/shoes/jackboots
	head = /obj/item/clothing/head/helmet/merc

/obj/item/clothing/jumpsuit/abolitionist
	name = "abolitionist combat suit"
	desc = "Lightly armored suit worn by abolition extremists during raids. It has green patches on the right sleeve and the chest. There is big green \"A\" on the back."
	icon = 'maps/away/slavers/icons/uniform.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_ARMS
	armor = list(
		ARMOR_MELEE  = ARMOR_MELEE_KNIVES,
		ARMOR_BULLET = ARMOR_BALLISTIC_PISTOL,
		ARMOR_LASER  = ARMOR_LASER_MINOR,
		ARMOR_ENERGY = ARMOR_ENERGY_MINOR
		)
