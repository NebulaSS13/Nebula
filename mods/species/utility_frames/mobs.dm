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
	var/spawn_eye_color = COLOR_RED

/mob/living/human/frame/Initialize(mapload, species_uid, datum/mob_snapshot/supplied_appearance)
	species_uid = /decl/species/utility_frame::uid
	. = ..()
	if(spawn_outfit)
		dressup_human(src, RESOLVE_TO_DECL(spawn_outfit))
	var/list/spawn_markings = get_frame_spawn_markings()
	if(spawn_markings)
		clear_sprite_accessories(spawn_color, skip_update = TRUE)
		set_sprite_accessories(spawn_markings)
	if(spawn_eye_color)
		set_eye_colour(spawn_eye_color)

/mob/living/human/frame/proc/get_frame_spawn_markings()
	return

/mob/living/human/frame/malf
	faction = "killbots"
	var/spawn_stripe_color = COLOR_RED_GRAY

/mob/living/human/frame/malf/get_frame_spawn_markings()
	var/list/malf_frame_markings = list(
		SAC_MARKINGS = list(
			/decl/sprite_accessory/marking/frame/plating         = list(SAM_COLOR = COLOR_SILVER),
			/decl/sprite_accessory/marking/frame/plating/legs    = list(SAM_COLOR = COLOR_SILVER),
			/decl/sprite_accessory/marking/frame/plating/head    = list(SAM_COLOR = COLOR_SILVER),
			/decl/sprite_accessory/marking/frame/head_stripe     = list(SAM_COLOR = spawn_stripe_color),
			/decl/sprite_accessory/marking/frame/shoulder_stripe = list(SAM_COLOR = spawn_stripe_color)
		)
	)
	return malf_frame_markings

/mob/living/human/frame/malf/combat
	spawn_outfit = /decl/outfit/utility_frame/combat
	spawn_color = COLOR_BLUE_GRAY
	spawn_stripe_color = COLOR_ORANGE
	spawn_eye_color = COLOR_ORANGE

/mob/living/human/frame/malf/scientist
	spawn_outfit = /decl/outfit/utility_frame/scientist
	spawn_color = COLOR_BLUE_GRAY
	spawn_stripe_color = COLOR_CYAN
	spawn_eye_color = COLOR_ORANGE

/mob/living/human/frame/malf/melee
	spawn_outfit = /decl/outfit/utility_frame/melee
	spawn_stripe_color = COLOR_RED

/mob/living/human/frame/malf/melee/sword
	spawn_outfit = /decl/outfit/utility_frame/melee/sword
	spawn_stripe_color = COLOR_RED_LIGHT

/mob/living/human/frame/malf/ranged
	spawn_outfit = /decl/outfit/utility_frame/ranged
	spawn_stripe_color = COLOR_PALE_GOLD

/mob/living/human/frame/malf/ranged/ionrifle
	spawn_outfit = /decl/outfit/utility_frame/ranged/ionrifle
	spawn_stripe_color = COLOR_GOLD

/mob/living/human/frame/malf/ranged/smg
	spawn_outfit = /decl/outfit/utility_frame/ranged/smg
	spawn_stripe_color = COLOR_YELLOW_GRAY

/mob/living/human/frame/malf/ranged/grenadier
	spawn_outfit = /decl/outfit/utility_frame/ranged/grenadier
	spawn_stripe_color = COLOR_BROWN

/mob/living/simple_animal/mob_mimic/malf_frame
	ai = /datum/mob_controller/aggressive
	abstract_type = /mob/living/simple_animal/mob_mimic/malf_frame

/mob/living/simple_animal/mob_mimic/malf_frame/combat
	mimic_mob = /mob/living/human/frame/malf/combat

/mob/living/simple_animal/mob_mimic/malf_frame/scientist
	mimic_mob = /mob/living/human/frame/malf/scientist

/mob/living/simple_animal/mob_mimic/malf_frame/melee
	mimic_mob = /mob/living/human/frame/malf/melee

/mob/living/simple_animal/mob_mimic/malf_frame/melee_sword
	mimic_mob = /mob/living/human/frame/malf/melee/sword

/mob/living/simple_animal/mob_mimic/malf_frame/ranged
	mimic_mob = /mob/living/human/frame/malf/ranged

/mob/living/simple_animal/mob_mimic/malf_frame/ranged_ionrifle
	mimic_mob = /mob/living/human/frame/malf/ranged/ionrifle

/mob/living/simple_animal/mob_mimic/malf_frame/ranged_smg
	mimic_mob = /mob/living/human/frame/malf/ranged/smg

/mob/living/simple_animal/mob_mimic/malf_frame/ranged_grenadier
	mimic_mob = /mob/living/human/frame/malf/ranged/grenadier
