/decl/hierarchy/skill/crafting
	name = "Crafting"
	difficulty = SKILL_EASY
	default_max = SKILL_MAX
	abstract_type = /decl/hierarchy/skill/crafting

/decl/hierarchy/skill/crafting/carpentry
	name = "Carpentry"
	uid =  "skill_crafting_carpentry"
	desc = "This skill describes your skill with woodworking."
	levels = list(
		"Unskilled"   = "Placeholder.",
		"Basic"       = "Placeholder.",
		"Trained"     = "Placeholder.",
		"Experienced" = "Placeholder.",
		"Master"      = "Placeholder."
	)

/decl/hierarchy/skill/crafting/stonemasonry
	name = "Stonemasonry"
	uid =  "skill_crafting_mason"
	desc = "This skill describes your skill with stonecarving."
	levels = list(
		"Unskilled"   = "Placeholder.",
		"Basic"       = "Placeholder.",
		"Trained"     = "Placeholder.",
		"Experienced" = "Placeholder.",
		"Master"      = "Placeholder."
	)

/decl/hierarchy/skill/crafting/metalwork
	name = "Metalwork"
	uid =  "skill_crafting_metalwork"
	desc = "This skill describes your skill with shaping, forging and casting metal."
	levels = list(
		"Unskilled"   = "Placeholder.",
		"Basic"       = "Placeholder.",
		"Trained"     = "Placeholder.",
		"Experienced" = "Placeholder.",
		"Master"      = "Placeholder."
	)

/decl/hierarchy/skill/crafting/artifice
	name = "Artifice"
	uid =  "skill_crafting_artifice"
	desc = "This skill describes your skill with complex devices and mechanisms."
	levels = list(
		"Unskilled"   = "Placeholder.",
		"Basic"       = "Placeholder.",
		"Trained"     = "Placeholder.",
		"Experienced" = "Placeholder.",
		"Master"      = "Placeholder."
	)

/decl/hierarchy/skill/crafting/textiles
	name = "Textiles"
	uid =  "skill_crafting_textiles"
	desc = "This skill describes your skill with cloth, thread and leather."
	levels = list(
		"Unskilled"   = "Placeholder.",
		"Basic"       = "Placeholder.",
		"Trained"     = "Placeholder.",
		"Experienced" = "Placeholder.",
		"Master"      = "Placeholder."
	)

/decl/hierarchy/skill/crafting/sculpting
	name = "Sculpting"
	uid =  "skill_crafting_sculpting"
	desc = "This skill describes your skill shaping wax, clay, and other soft materials."
	levels = list(
		"Unskilled"   = "Placeholder.",
		"Basic"       = "Placeholder.",
		"Trained"     = "Placeholder.",
		"Experienced" = "Placeholder.",
		"Master"      = "Placeholder."
	)

// SCULPTING OVERRIDES
/decl/material/solid/clay
	crafting_skill = /decl/hierarchy/skill/crafting/sculpting

/decl/material/solid/soil
	crafting_skill = /decl/hierarchy/skill/crafting/sculpting

/decl/material/solid/organic/wax
	crafting_skill = /decl/hierarchy/skill/crafting/sculpting

// TEXTILES OVERRIDES
/obj/structure/textiles
	work_skill = /decl/hierarchy/skill/crafting/textiles

/decl/material/solid/organic/cloth
	crafting_skill = /decl/hierarchy/skill/crafting/textiles

/decl/material/solid/organic/skin
	crafting_skill = /decl/hierarchy/skill/crafting/textiles

/decl/material/solid/organic/leather
	crafting_skill = /decl/hierarchy/skill/crafting/textiles

/decl/material/solid/organic/plantmatter
	crafting_skill = /decl/hierarchy/skill/crafting/textiles

// STONEMASONRY OVERRIDES
/decl/material/solid/stone
	crafting_skill = /decl/hierarchy/skill/crafting/stonemasonry

// METALWORK OVERRIDES
/decl/material/solid/metal
	crafting_skill = /decl/hierarchy/skill/crafting/metalwork

// CARPENTRY OVERRIDES
/decl/material/solid/organic/wood
	crafting_skill = /decl/hierarchy/skill/crafting/carpentry

/decl/material/solid/organic/plantmatter/pith // not quite wood but it's basically still wood carving
	crafting_skill = /decl/hierarchy/skill/crafting/carpentry

// MISC OVERRIDES
/decl/stack_recipe
	recipe_skill = null // set based on material

// Removal of space skills
/datum/map/shaded_hills/get_available_skill_types()
	. = ..()
	. -= list(
		SKILL_EVA,
		SKILL_MECH,
		SKILL_PILOT,
		SKILL_COMPUTER,
		SKILL_FORENSICS,
		SKILL_ELECTRICAL,
		SKILL_ATMOS,
		SKILL_ENGINES,
		SKILL_DEVICES
	)