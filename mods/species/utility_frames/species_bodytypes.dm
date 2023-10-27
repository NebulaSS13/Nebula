/decl/bodytype/prosthetic/utility_frame
	name =              "utility frame"
	examined_name =     null
	desc =              "This limb is extremely cheap and simplistic, with a raw steel frame and plastic casing."
	icon_base =         'mods/species/utility_frames/icons/body.dmi'
	eye_icon = 'mods/species/utility_frames/icons/eyes.dmi'
	bodytype_category = BODYTYPE_HUMANOID
	limb_blend =        ICON_MULTIPLY
	appearance_flags =  HAS_SKIN_COLOR | HAS_EYE_COLOR
	modular_limb_tier = MODULAR_BODYPART_CYBERNETIC
	body_flags =        BODY_FLAG_NO_PAIN | BODY_FLAG_NO_DNA | BODY_FLAG_NO_DEFIB | BODY_FLAG_NO_STASIS
	base_color = "#333355"
	base_eye_color = "#00ccff"
	material = /decl/material/solid/metal/steel
	vital_organs = list(
		BP_POSIBRAIN,
		BP_CELL
	)
	override_limb_types = list(BP_HEAD = /obj/item/organ/external/head/utility_frame)
	has_organ = list(
		BP_POSIBRAIN = /obj/item/organ/internal/posibrain,
		BP_EYES      = /obj/item/organ/internal/eyes,
		BP_CELL      = /obj/item/organ/internal/cell
	)
	base_markings = list(
		/decl/sprite_accessory/marking/frame/plating = "#8888cc",
		/decl/sprite_accessory/marking/frame/plating/legs = "#8888cc",
		/decl/sprite_accessory/marking/frame/plating/head = "#8888cc"
	)

/decl/bodytype/prosthetic/utility_frame/Initialize()
	equip_adjust = list(
		"[slot_l_ear_str]" =  list(
			"[NORTH]" = list("x" =  2, "y" = 0),
			"[EAST]"  = list("x" =  0, "y" = 0),
			"[SOUTH]" = list("x" = -2, "y" = 0),
			"[WEST]"  = list("x" =  0, "y" = 0)
		),
		"[slot_r_ear_str]" =  list(
			"[NORTH]" = list("x" = -2, "y" = 0),
			"[EAST]"  = list("x" =  0, "y" = 0),
			"[SOUTH]" = list("x" =  2, "y" = 0),
			"[WEST]"  = list("x" =  0, "y" = 0)
		)
	)
	. = ..()

DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/utility_frame, utility_frame)