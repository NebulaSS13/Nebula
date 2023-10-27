/decl/bodytype/vox
	name =              "soldier voxform"
	bodytype_category = BODYTYPE_VOX
	icon_base =         'mods/species/vox/icons/body/soldier/body.dmi'
	icon_deformed =     'mods/species/vox/icons/body/deformed_body.dmi'
	husk_icon =         'mods/species/vox/icons/body/husk.dmi'
	blood_overlays =    'mods/species/vox/icons/body/blood_overlays.dmi'
	eye_icon =          'mods/species/vox/icons/body/soldier/eyes.dmi'
	bodytype_flag =     BODY_FLAG_VOX
	limb_blend =        ICON_MULTIPLY
	eye_blend =         ICON_MULTIPLY
	appearance_flags =  HAS_EYE_COLOR | HAS_HAIR_COLOR | HAS_SKIN_COLOR
	base_hair_color =   "#160900"
	base_eye_color =    "#d60093"
	base_color =        "#526d29"
	body_flags =        BODY_FLAG_NO_DNA
	cold_level_1 = 80
	cold_level_2 = 50
	cold_level_3 = -1
	default_h_style = /decl/sprite_accessory/hair/vox/short
	flesh_color = "#808d11"
	blood_types = list(/decl/blood_type/vox)

	vital_organs = list(
		BP_STACK,
		BP_BRAIN
	)

	override_limb_types = list(
		BP_GROIN = /obj/item/organ/external/groin/vox,
		BP_TAIL = /obj/item/organ/external/tail/vox
	)

	has_organ = list(
		BP_STOMACH =    /obj/item/organ/internal/stomach/vox,
		BP_HEART =      /obj/item/organ/internal/heart/vox,
		BP_LUNGS =      /obj/item/organ/internal/lungs/vox,
		BP_LIVER =      /obj/item/organ/internal/liver/vox,
		BP_KIDNEYS =    /obj/item/organ/internal/kidneys/vox,
		BP_BRAIN =      /obj/item/organ/internal/brain,
		BP_EYES =       /obj/item/organ/internal/eyes/vox,
		BP_STACK =      /obj/item/organ/internal/voxstack,
		BP_HINDTONGUE = /obj/item/organ/internal/hindtongue
	)

	base_markings = list(
		/decl/sprite_accessory/marking/vox/beak =   "#bc7d3e",
		/decl/sprite_accessory/marking/vox/scutes = "#bc7d3e",
		/decl/sprite_accessory/marking/vox/crest =  "#bc7d3e",
		/decl/sprite_accessory/marking/vox/claws =  "#a0a654"
	)

/decl/bodytype/vox/Initialize()
	if(!equip_adjust)
		equip_adjust = list(
			BP_L_HAND =           list("[NORTH]" = list("x" =  0, "y" = -2), "[EAST]" = list("x" = 0, "y" = -2), "[SOUTH]" = list("x" =  0, "y" = -2),  "[WEST]" = list("x" =  0, "y" = -2)),
			BP_R_HAND =           list("[NORTH]" = list("x" =  0, "y" = -2), "[EAST]" = list("x" = 0, "y" = -2), "[SOUTH]" = list("x" =  0, "y" = -2),  "[WEST]" = list("x" =  0, "y" = -2)),
			slot_head_str =       list("[NORTH]" = list("x" =  0, "y" = -2), "[EAST]" = list("x" = 3, "y" = -2), "[SOUTH]" = list("x" =  0, "y" = -2),  "[WEST]" = list("x" = -3, "y" = -2)),
			slot_wear_mask_str =  list("[NORTH]" = list("x" =  0, "y" =  0), "[EAST]" = list("x" = 4, "y" =  0), "[SOUTH]" = list("x" =  0, "y" =  0),  "[WEST]" = list("x" = -4, "y" =  0)),
			slot_wear_suit_str =  list("[NORTH]" = list("x" =  0, "y" = -1), "[EAST]" = list("x" = 0, "y" = -1), "[SOUTH]" = list("x" =  0, "y" = -1),  "[WEST]" = list("x" =  0, "y" = -1)),
			slot_w_uniform_str =  list("[NORTH]" = list("x" =  0, "y" = -1), "[EAST]" = list("x" = 0, "y" = -1), "[SOUTH]" = list("x" =  0, "y" = -1),  "[WEST]" = list("x" =  0, "y" = -1)),
			slot_underpants_str = list("[NORTH]" = list("x" =  0, "y" = -1), "[EAST]" = list("x" = 0, "y" = -1), "[SOUTH]" = list("x" =  0, "y" = -1),  "[WEST]" = list("x" =  0, "y" = -1)),
			slot_undershirt_str = list("[NORTH]" = list("x" =  0, "y" = -1), "[EAST]" = list("x" = 0, "y" = -1), "[SOUTH]" = list("x" =  0, "y" = -1),  "[WEST]" = list("x" =  0, "y" = -1)),
			slot_back_str =       list("[NORTH]" = list("x" =  0, "y" =  0), "[EAST]" = list("x" = 3, "y" =  0), "[SOUTH]" = list("x" =  0, "y" =  0),  "[WEST]" = list("x" = -3, "y" =  0))
		)
	return ..()

/decl/bodytype/vox/servitor
	name = "servitor voxform"
	bodytype_category = BODYTYPE_HUMANOID
	icon_base =      'mods/species/vox/icons/body/servitor/body.dmi'
	icon_deformed =  'mods/species/vox/icons/body/deformed_body.dmi'
	husk_icon =      'mods/species/vox/icons/body/husk.dmi'
	blood_overlays = 'mods/species/vox/icons/body/blood_overlays.dmi'
	eye_icon =       'mods/species/vox/icons/body/servitor/eyes.dmi'
	base_markings = list(
		/decl/sprite_accessory/marking/vox/beak/servitor =   "#bc7d3e",
		/decl/sprite_accessory/marking/vox/scutes/servitor = "#bc7d3e",
		/decl/sprite_accessory/marking/vox/crest/servitor =  "#bc7d3e",
		/decl/sprite_accessory/marking/vox/claws/servitor =  "#a0a654"
	)
	default_h_style = /decl/sprite_accessory/hair/vox/short/servitor
	override_limb_types = list(
		BP_GROIN = /obj/item/organ/external/groin/vox,
		BP_TAIL = /obj/item/organ/external/tail/vox/servitor
	)

/decl/bodytype/vox/stanchion
	name = "stanchion voxform"
	blood_overlays  = 'mods/species/vox/icons/body/stanchion/blood_overlays.dmi'
	damage_overlays = 'mods/species/vox/icons/body/stanchion/damage_overlays.dmi'
	icon_base       = 'mods/species/vox/icons/body/stanchion/body.dmi'
	eye_icon        = 'mods/species/vox/icons/body/stanchion/eyes.dmi'
	icon_template   = 'mods/species/vox/icons/body/stanchion/template.dmi'
	base_markings = list(
		/decl/sprite_accessory/marking/vox/beak/stanchion =   "#bc7d3e",
		/decl/sprite_accessory/marking/vox/scutes/stanchion = "#bc7d3e",
		/decl/sprite_accessory/marking/vox/crest/stanchion =  "#bc7d3e",
		/decl/sprite_accessory/marking/vox/claws/stanchion =  "#a0a654"
	)
	default_h_style = /decl/sprite_accessory/hair/vox/short/stanchion
	override_limb_types = list(
		BP_GROIN = /obj/item/organ/external/groin/vox,
		BP_TAIL = /obj/item/organ/external/tail/vox/stanchion
	)
	bodytype_category = BODYTYPE_VOX_LARGE


/decl/bodytype/vox/servitor/alchemist
	name = "alchemist voxform"
	icon_base = 'mods/species/vox/icons/body/servitor/body_alchemist.dmi'
	eye_icon = 'mods/species/vox/icons/body/servitor/eyes_alchemist.dmi'

/decl/bodytype/vox/servitor/Initialize()
	if(!equip_adjust)
		equip_adjust = list()
	return ..()

/obj/item/organ/external/tail/vox
	tail =       "voxtail"
	tail_icon =  'mods/species/vox/icons/body/soldier/tail.dmi'
	tail_blend = ICON_MULTIPLY

/obj/item/organ/external/tail/vox/servitor
	tail_icon =  'mods/species/vox/icons/body/servitor/tail.dmi'

/obj/item/organ/external/tail/vox/stanchion
	tail_icon =  'mods/species/vox/icons/body/stanchion/tail.dmi'
