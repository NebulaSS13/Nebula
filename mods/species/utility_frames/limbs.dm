/decl/bodytype/prosthetic/utility_frame
	name = "Utility Frame"
	prosthetic_limb_desc = "This limb is extremely cheap and simplistic, with a raw steel frame and plastic casing."
	icon_base = 'mods/species/utility_frames/icons/body.dmi'
	body_appearance_flags = HAS_SKIN_COLOR | HAS_EYE_COLOR
	species_restricted = list(SPECIES_FRAME)
	limb_blend = ICON_MULTIPLY
	modular_prosthetic_tier = MODULAR_BODYPART_CYBERNETIC

DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/utility_frame, utility_frame)
