/decl/bodytype/prosthetic/utility_frame
	name =              "utility frame"
	desc =              "This limb is extremely cheap and simplistic, with a raw steel frame and plastic casing."
	icon_base =         'mods/species/utility_frames/icons/body.dmi'
	bodytype_category = BODYTYPE_HUMANOID
	limb_blend =        ICON_MULTIPLY
	appearance_flags =  HAS_SKIN_COLOR | HAS_EYE_COLOR
	modular_limb_tier = MODULAR_BODYPART_CYBERNETIC
	base_color = "#333355"
	base_eye_color = "#00ccff"

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