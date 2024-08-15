/decl/bodytype/prosthetic/basic_human
	name = "Unbranded"
	pref_name = "synthetic body"
	bodytype_category = BODYTYPE_HUMANOID
	uid = "bodytype_prosthetic_basic_human"

/decl/bodytype/prosthetic/wooden
	name = "crude wooden"
	desc = "A crude wooden prosthetic."
	icon_base = 'icons/mob/human_races/cyberlimbs/morgan/morgan_main.dmi'
	modifier_string = "wooden"
	hardiness = 0.75
	manual_dexterity = DEXTERITY_SIMPLE_MACHINES
	movement_slowdown = 1
	is_robotic = FALSE
	modular_limb_tier = MODULAR_BODYPART_ANYWHERE
	bodytype_category = BODYTYPE_HUMANOID
	material = /decl/material/solid/organic/wood
	required_map_tech = MAP_TECH_LEVEL_MEDIEVAL
	uid = "bodytype_prosthetic_wooden"

DEFINE_ROBOLIMB_MODEL_TRAITS(/decl/bodytype/prosthetic/wooden, pirate, 0, "wooden")
