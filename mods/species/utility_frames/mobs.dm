/decl/outfit/utility_frame
	abstract_type = /decl/outfit/utility_frame
	name          = "Utility Frame"
	uniform       = /obj/item/clothing/shirt/harness

/decl/outfit/utility_frame/combat
	name  = "Utility Frame - Combat"
	hands = list(/obj/item/knife/combat)

/decl/outfit/utility_frame/scientist
	name  = "Utility Frame - Scientist"
	hands = list(/obj/item/gun/energy/gun)

/decl/outfit/utility_frame/melee
	name  = "Utility Frame - Melee Baton"
	hands = list(/obj/item/baton)

/decl/outfit/utility_frame/melee/sword
	name  = "Utility Frame - Melee Sword"
	hands = list(/obj/item/tool/machete/unbreakable)

/decl/outfit/utility_frame/ranged
	name  = "Utility Frame - Ranged Laser"
	hands = list(/obj/item/gun/energy/laser)

/decl/outfit/utility_frame/ranged/ionrifle
	name  = "Utility Frame - Ranged Ion Rifle"
	hands = list(/obj/item/gun/energy/ionrifle)

/decl/outfit/utility_frame/ranged/smg
	name  = "Utility Frame - SMG"
	hands = list(/obj/item/gun/projectile/automatic/smg)

/decl/outfit/utility_frame/ranged/grenadier
	name  = "Utility Frame - Ranged Grenadier"
	hands = list(/obj/item/gun/launcher/grenade)

/mob/living/human/frame
	var/spawn_outfit
	var/spawn_color = COLOR_GUNMETAL

/mob/living/human/frame/Initialize(mapload, species_uid, datum/mob_snapshot/supplied_appearance)
	species_uid = /decl/species/utility_frame::uid
	. = ..()
	if(spawn_outfit)
		dressup_human(src, spawn_outfit)
//	var/list/spawn_markings = get_frame_spawn_markings()
//	if(spawn_markings)
//  	clear_sprite_accessories(spawn_color)
//  	apply_sprite_accessories(spawn_markings)

/mob/living/human/frame/proc/get_frame_spawn_markings()
	return

/mob/living/human/frame/malf
	ai = /datum/mob_controller/aggressive

/mob/living/human/frame/malf/combat
	spawn_outfit = /decl/outfit/utility_frame/combat

/mob/living/human/frame/malf/scientist
	spawn_outfit = /decl/outfit/utility_frame/scientist

/mob/living/human/frame/malf/melee
	spawn_outfit = /decl/outfit/utility_frame/melee

/mob/living/human/frame/malf/melee/sword
	spawn_outfit = /decl/outfit/utility_frame/melee/sword

/mob/living/human/frame/malf/ranged
	spawn_outfit = /decl/outfit/utility_frame/ranged

/mob/living/human/frame/malf/ranged/ionrifle
	spawn_outfit = /decl/outfit/utility_frame/ranged/ionrifle

/mob/living/human/frame/malf/ranged/smg
	spawn_outfit = /decl/outfit/utility_frame/ranged/smg

/mob/living/human/frame/malf/ranged/grenadier
	spawn_outfit = /decl/outfit/utility_frame/ranged/grenadier
