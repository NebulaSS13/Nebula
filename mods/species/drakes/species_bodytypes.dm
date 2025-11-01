/datum/appearance_descriptor/age/grafadreka
	chargen_min_index = 2
	chargen_max_index = 6
	standalone_value_descriptors = list(
		"a hatchling"   = 1,
		"a juvenile"    = 2,
		"an adolescent" = 4,
		"an adult"      = 6,
		"aging"         = 20,
		"elderly"       = 30
	)

/datum/appearance_descriptor/age/grafadreka/hatchling
	chargen_min_index = 1
	chargen_max_index = 2

/decl/posture/lying/drake
	overlay_modifier = "_lying"
/decl/posture/lying/deliberate/drake
	overlay_modifier = "_lying"
/decl/posture/sitting/drake
	overlay_modifier = "_sitting"

/decl/bodytype/quadruped/grafadreka
	name                 = "adult drake"
	icon_base            = 'mods/species/drakes/icons/body.dmi'
	blood_overlays       = 'mods/species/drakes/icons/blood.dmi'
	eye_icon             = 'mods/species/drakes/icons/eyes.dmi'
	icon_template        = 'mods/species/drakes/icons/template.dmi'
	skeletal_icon        = 'mods/species/drakes/icons/skeleton.dmi'
	damage_overlays      = 'mods/species/drakes/icons/damage.dmi'
	surgery_overlay_icon = null // todo: 'mods/species/drakes/icons/surgery.dmi'
	bodytype_category    = BODYTYPE_GRAFADREKA
	eye_blend            = ICON_MULTIPLY
	limb_blend           = ICON_MULTIPLY
	appearance_flags     = HAS_SKIN_COLOR | HAS_EYE_COLOR
	mob_size             = MOB_SIZE_LARGE
	override_limb_types  = list(
		BP_TAIL   = /obj/item/organ/external/tail/grafadreka,
		BP_L_HAND = /obj/item/organ/external/hand/quadruped/grafadreka,
		BP_R_HAND = /obj/item/organ/external/hand/right/quadruped/grafadreka,
		BP_HEAD   = /obj/item/organ/external/head/gripper/grafadreka
	)
	base_color           = "#608894"
	base_eye_color       = COLOR_SILVER
	pixel_offset_x       = -16
	antaghud_offset_x    = 16
	override_organ_types = list(BP_DRAKE_GIZZARD = /obj/item/organ/internal/drake_gizzard)
	uid                  = "bodytype_drake"
	footprints_icon      = 'icons/mob/footprints/footprints_paw.dmi'

	additional_emotes    = list(
		/decl/emote/audible/drake_warble,
		/decl/emote/audible/drake_purr,
		/decl/emote/audible/drake_grumble,
		/decl/emote/audible/drake_huff,
		/decl/emote/audible/drake_rattle,
		/decl/emote/audible/drake_warn,
		/decl/emote/audible/drake_rumble,
		/decl/emote/audible/drake_roar,
		/decl/emote/audible/drake_sneeze,
		/decl/emote/visible/drake_headbutt
	)

	removed_emotes = list(
		/decl/emote/audible/clap,
		/decl/emote/audible/chuckle,
		/decl/emote/audible/laugh,
		/decl/emote/audible/mumble,
		/decl/emote/audible/slap,
		/decl/emote/audible/giggle,
		/decl/emote/visible/airguitar,
		/decl/emote/visible/salute,
		/decl/emote/visible/flap,
		/decl/emote/visible/aflap,
		/decl/emote/visible/eyebrow,
		/decl/emote/visible/frown,
		/decl/emote/visible/blush,
		/decl/emote/visible/wave,
		/decl/emote/visible/raise,
		/decl/emote/visible/grin,
		/decl/emote/visible/smile,
		/decl/emote/visible/hug,
		/decl/emote/visible/dap,
		/decl/emote/visible/signal,
		/decl/emote/visible/handshake,
		/decl/emote/visible/afold,
		/decl/emote/visible/hip,
		/decl/emote/visible/holdup,
		/decl/emote/visible/crub,
		/decl/emote/visible/erub,
		/decl/emote/visible/fslap,
		/decl/emote/visible/hrub,
		/decl/emote/visible/hspread,
		/decl/emote/visible/pocket,
		/decl/emote/visible/rsalute,
		/decl/emote/visible/tfist
	)

	character_preview_screen_locs = list(
		"1" = "character_preview_map:1,4:36",
		"2" = "character_preview_map:1,3:31",
		"4" = "character_preview_map:1,2:26",
		"8" = "character_preview_map:1,1:21"
	)

	available_mob_postures = list(
		/decl/posture/standing,
		/decl/posture/lying/drake,
		/decl/posture/lying/deliberate/drake,
		/decl/posture/sitting/drake
	)

	basic_posture_map = list(
		/decl/posture/standing         = /decl/posture/standing,
		/decl/posture/lying            = /decl/posture/lying/drake,
		/decl/posture/lying/deliberate = /decl/posture/lying/deliberate/drake
	)

	ability_handlers = list(
		/datum/ability_handler/predator/grafadreka
	)
	age_descriptor = /datum/appearance_descriptor/age/grafadreka
	default_sprite_accessories = list(
		SAC_MARKINGS = list(
			/decl/sprite_accessory/marking/grafadreka                 = list(SAM_COLOR = COLOR_BLUE_GRAY),
			/decl/sprite_accessory/marking/grafadreka/bioluminescence = list(SAM_COLOR = COLOR_CYAN),
			/decl/sprite_accessory/marking/grafadreka/claws           = list(SAM_COLOR = COLOR_SILVER)
		)
	)
	z_flags = ZMM_WIDE_LOAD

	eye_low_light_vision_effectiveness    = 0.15
	eye_low_light_vision_adjustment_speed = 0.3
	eye_darksight_range                   = 7

	// Copied from riot armor, as drakes cannot wear equipment
	// or hold shields. May need to be toned down at some point.
	natural_armour_values = list(
		ARMOR_MELEE  = ARMOR_MELEE_VERY_HIGH,
		ARMOR_BULLET = ARMOR_BALLISTIC_SMALL,
		ARMOR_LASER  = ARMOR_LASER_SMALL,
		ARMOR_ENERGY = ARMOR_ENERGY_MINOR,
		ARMOR_BOMB   = ARMOR_BOMB_PADDED
	)

	VAR_PRIVATE/list/_sitting_equip_adjust
	VAR_PRIVATE/list/_lying_equip_adjust

/decl/bodytype/quadruped/grafadreka/Initialize()
	if(!length(_equip_adjust))
		_equip_adjust = list(
			(slot_head_str) = list(
				"[NORTH]" = list(16,  -8),
				"[SOUTH]" = list(16, -12),
				"[EAST]"  = list(38,  -8),
				"[WEST]"  = list(-6,  -8)
			)
		)

	if(!length(_sitting_equip_adjust))
		_sitting_equip_adjust = list(
			(slot_head_str) = list(
				"[NORTH]" = list(16, -2),
				"[SOUTH]" = list(16, -2),
				"[EAST]"  = list(22, -2),
				"[WEST]"  = list(12, -2)
			)
		)

	if(!length(_lying_equip_adjust))
		_lying_equip_adjust = list(
			(slot_head_str) = list(
				"[NORTH]" = list( 24, -24),
				"[SOUTH]" = list( 24, -24),
				"[EAST]"  = list( 24, -24),
				"[WEST]"  = list(-10, -24)
			)
		)

	return ..()

/decl/bodytype/quadruped/grafadreka/get_equip_adjustments(mob/mob)
	switch(mob.current_posture?.name)
		if("lying", "resting")
			return _lying_equip_adjust
		if("sitting")
			return _sitting_equip_adjust
	return ..()

/decl/bodytype/quadruped/grafadreka/hatchling
	name                = "hatchling drake"
	icon_base           = 'mods/species/drakes/icons/hatchling_body.dmi'
	blood_overlays      = 'mods/species/drakes/icons/hatchling_blood.dmi'
	eye_icon            = 'mods/species/drakes/icons/hatchling_eyes.dmi'
	icon_template       = 'icons/mob/human_races/species/template.dmi'
	damage_overlays     = 'icons/mob/human_races/species/default_damage_overlays.dmi'
	bodytype_category   = BODYTYPE_GRAFADREKA_HATCHLING
	mob_size            = MOB_SIZE_SMALL
	pixel_offset_x      = 0
	antaghud_offset_x   = 0
	ability_handlers    = list(
		/datum/ability_handler/predator/grafadreka/hatchling
	)
	z_flags             = 0
	// TODO: weaker attack subtypes for the baby
	override_limb_types = list(
		BP_TAIL   = /obj/item/organ/external/tail/grafadreka/hatchling,
		BP_L_HAND = /obj/item/organ/external/hand/quadruped/grafadreka,
		BP_R_HAND = /obj/item/organ/external/hand/right/quadruped/grafadreka,
		BP_HEAD   = /obj/item/organ/external/head/gripper/grafadreka
	)

	default_emotes      = list(
		/decl/emote/audible/drake_hatchling_growl,
		/decl/emote/audible/drake_hatchling_whine,
		/decl/emote/audible/drake_hatchling_yelp,
		/decl/emote/audible/drake_warn/hatchling,
		/decl/emote/audible/drake_sneeze
	)
	age_descriptor = /datum/appearance_descriptor/age/grafadreka/hatchling
	character_preview_screen_locs = null
	uid = "bodytype_drake_hatchling"

/decl/bodytype/quadruped/grafadreka/hatchling/Initialize()
	if(!length(_equip_adjust))
		_equip_adjust = list(
			(slot_head_str) = list(
				"[NORTH]" = list( 0, -18),
				"[SOUTH]" = list( 0, -18),
				"[EAST]"  = list( 8, -18),
				"[WEST]"  = list(-8, -18)
			)
		)
	if(!length(_sitting_equip_adjust))
		_sitting_equip_adjust = list(
			(slot_head_str) = list(
				"[NORTH]" = list( 0, -14),
				"[SOUTH]" = list( 0, -14),
				"[EAST]"  = list( 4, -14),
				"[WEST]"  = list(-4, -14)
			)
		)
	if(!length(_lying_equip_adjust))
		_lying_equip_adjust = list(
			(slot_head_str) = list(
				"[NORTH]" = list( 0, -24),
				"[SOUTH]" = list( 0, -24),
				"[EAST]"  = list( 0, -24),
				"[WEST]"  = list( 0, -24)
			)
		)
	return ..()

/decl/sprite_accessory/marking/grafadreka/get_accessory_icon(var/obj/item/organ/external/organ)
	if(organ?.bodytype?.type == /decl/bodytype/quadruped/grafadreka/hatchling)
		return 'mods/species/drakes/icons/hatchling_markings.dmi'
	return ..()

/decl/sprite_accessory/marking/grafadreka
	name            = "Drake Spines"
	icon            = 'mods/species/drakes/icons/markings.dmi'
	icon_state      = "spines"
	uid             = "acc_marking_drake_spines"
	species_allowed = list(/decl/species/grafadreka::uid)
	color_blend     = ICON_MULTIPLY
	body_parts      = list(
		BP_CHEST,
		BP_GROIN,
		BP_TAIL,
		BP_HEAD,
		BP_L_ARM,
		BP_R_ARM,
		BP_L_HAND,
		BP_R_HAND,
		BP_L_LEG,
		BP_R_LEG,
		BP_L_FOOT,
		BP_R_FOOT
	)

/decl/sprite_accessory/marking/grafadreka/bioluminescence
	name       = "Drake Bioluminescence"
	uid        = "acc_marking_drake_bioluminescence"
	icon_state = "glow"
	body_parts = list(
		BP_CHEST,
		BP_GROIN,
		BP_TAIL,
		BP_HEAD
	)

/decl/sprite_accessory/marking/grafadreka/claws
	name       = "Drake Claws"
	uid        = "acc_marking_drake_claws"
	icon_state = "claws"
	body_parts = list(
		BP_L_HAND,
		BP_R_HAND,
		BP_L_FOOT,
		BP_R_FOOT
	)

/obj/item/organ/external/tail/grafadreka
	tail_icon  = 'mods/species/drakes/icons/body.dmi'
	tail_blend = ICON_MULTIPLY

/obj/item/organ/external/tail/grafadreka/hatchling
	tail_icon  = 'mods/species/drakes/icons/hatchling_body.dmi'

// Technically means that severed drake paws can be used as shovels, but whatever.
/obj/item/organ/external/hand/quadruped/grafadreka
	_base_attack_force = 8
	needs_attack_dexterity = DEXTERITY_NONE

/obj/item/organ/external/hand/quadruped/grafadreka/get_natural_attacks()
	var/static/unarmed_attack = GET_DECL(/decl/natural_attack/claws/strong/drake)
	return unarmed_attack

/obj/item/organ/external/hand/quadruped/grafadreka/Initialize(mapload, material_key, datum/mob_snapshot/supplied_appearance)
	. = ..()
	item_flags |= ITEM_FLAG_NO_BLUDGEON
	set_extension(src, /datum/extension/tool, list(
		TOOL_PICK   = TOOL_QUALITY_MEDIOCRE,
		TOOL_SHOVEL = TOOL_QUALITY_GOOD
	))

/obj/item/organ/external/hand/quadruped/grafadreka/set_bodytype(decl/bodytype/new_bodytype, override_material, apply_to_internal_organs)
	override_material = /decl/material/solid/organic/bone
	. = ..()

/obj/item/organ/external/hand/right/quadruped/grafadreka
	_base_attack_force = 8
	needs_attack_dexterity = DEXTERITY_NONE

/obj/item/organ/external/hand/right/quadruped/grafadreka/get_natural_attacks()
	var/static/unarmed_attack = GET_DECL(/decl/natural_attack/claws/strong/drake)
	return unarmed_attack

/obj/item/organ/external/hand/right/quadruped/grafadreka/Initialize(mapload, material_key, datum/mob_snapshot/supplied_appearance)
	. = ..()
	item_flags |= ITEM_FLAG_NO_BLUDGEON
	set_extension(src, /datum/extension/tool, list(
		TOOL_PICK   = TOOL_QUALITY_MEDIOCRE,
		TOOL_SHOVEL = TOOL_QUALITY_GOOD
	))

/obj/item/organ/external/hand/right/quadruped/grafadreka/set_bodytype(decl/bodytype/new_bodytype, override_material, apply_to_internal_organs)
	override_material = /decl/material/solid/organic/bone
	. = ..()

/obj/item/organ/external/head/gripper/grafadreka/get_natural_attacks()
	var/static/unarmed_attack = GET_DECL(/decl/natural_attack/bite/sharp/drake)
	return unarmed_attack
