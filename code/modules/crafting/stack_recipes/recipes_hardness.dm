/decl/stack_recipe/hardness
	abstract_type     = /decl/stack_recipe/hardness
	required_min_hardness = MAT_VALUE_FLEXIBLE + 10
	validation_material = DEFAULT_FURNITURE_MATERIAL

/decl/stack_recipe/hardness/improvised_armour
	result_type       = /obj/item/clothing/suit/armor/crafted
	category          = "improvised armor"
	uid               = "stack_recipe_improvised_suit"

/decl/stack_recipe/hardness/improvised_armour/armguards
	result_type       = /obj/item/clothing/gloves/armguards/craftable
	uid               = "stack_recipe_improvised_armguards"

/decl/stack_recipe/hardness/improvised_armour/legguards
	result_type       = /obj/item/clothing/shoes/legguards/craftable
	uid               = "stack_recipe_improvised_legguards"

/decl/stack_recipe/hardness/improvised_armour/gauntlets
	result_type       = /obj/item/clothing/gloves/thick/craftable
	uid               = "stack_recipe_improvised_gauntlets"

/decl/stack_recipe/hardness/utensils
	abstract_type     = /decl/stack_recipe/hardness/utensils
	category          = "utensils"

/decl/stack_recipe/hardness/utensils/fork
	result_type       = /obj/item/utensil/fork
	uid               = "stack_recipe_fork"

/decl/stack_recipe/hardness/utensils/chopsticks
	result_type       = /obj/item/utensil/chopsticks
	uid               = "stack_recipe_chopsticks"

/decl/stack_recipe/hardness/utensils/knife
	result_type       = /obj/item/utensil/knife
	difficulty        = MAT_VALUE_HARD_DIY
	uid               = "stack_recipe_knife"

/decl/stack_recipe/hardness/utensils/spoon
	result_type       = /obj/item/utensil/spoon
	uid               = "stack_recipe_spoon"

/decl/stack_recipe/hardness/bell
	result_type       = /obj/item/bell
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE // similar to boxes and bats, not thematically appropriate to low tech
	uid               = "stack_recipe_bell"

/decl/stack_recipe/hardness/blade
	result_type       = /obj/item/butterflyblade
	difficulty        = MAT_VALUE_NORMAL_DIY
	category          = "weapons"
	uid               = "stack_recipe_butterfly_blade"

/decl/stack_recipe/hardness/urn
	result_type       = /obj/item/urn
	craft_stack_types           = list(
		/obj/item/stack/material/sheet,
		/obj/item/stack/material/ingot,
		/obj/item/stack/material/bar,
		/obj/item/stack/material/puck
	)
	forbidden_craft_stack_types = list(
		/obj/item/stack/material/ore,
		/obj/item/stack/material/log,
		/obj/item/stack/material/lump,
		/obj/item/stack/material/slab,
		/obj/item/stack/material/plank
	)
	uid               = "stack_recipe_urn"

/decl/stack_recipe/hardness/drill_head
	result_type       = /obj/item/drill_head
	difficulty        = MAT_VALUE_EASY_DIY
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE
	uid               = "stack_recipe_drill_head"

/decl/stack_recipe/hardness/baseball_bat
	result_type       = /obj/item/baseball_bat
	difficulty        = MAT_VALUE_HARD_DIY
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE // similar to boxes, not thematically appropriate to low tech
	category          = "weapons"
	uid               = "stack_recipe_baseball_bat"

/decl/stack_recipe/hardness/ashtray
	result_type       = /obj/item/ashtray
	uid               = "stack_recipe_ashtray"

/decl/stack_recipe/hardness/mortar
	result_type       = /obj/item/chems/glass/mortar
	uid               = "stack_recipe_mortar"

/decl/stack_recipe/hardness/clipboard
	result_type       = /obj/item/clipboard
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE
	uid               = "stack_recipe_clipboard"

/decl/stack_recipe/hardness/cross
	result_type       = /obj/item/cross
	on_floor          = TRUE
	uid               = "stack_recipe_cross"

/decl/stack_recipe/hardness/surgical
	abstract_type     = /decl/stack_recipe/hardness/surgical
	difficulty        = MAT_VALUE_HARD_DIY
	category          = "medical"
	available_to_map_tech_level = MAP_TECH_LEVEL_MEDIEVAL

/decl/stack_recipe/hardness/surgical/retractor
	result_type       = /obj/item/ancient_surgery/retractor
	uid               = "stack_recipe_ancient_retractor"

/decl/stack_recipe/hardness/surgical/cautery
	result_type       = /obj/item/ancient_surgery/cautery
	uid               = "stack_recipe_ancient_cautery"

/decl/stack_recipe/hardness/surgical/bonesetter
	result_type       = /obj/item/ancient_surgery/bonesetter
	uid               = "stack_recipe_ancient_bonesetter"

/decl/stack_recipe/hardness/surgical/scalpel
	result_type       = /obj/item/ancient_surgery/scalpel
	uid               = "stack_recipe_ancient_scalpel"

/decl/stack_recipe/hardness/surgical/forceps
	result_type       = /obj/item/ancient_surgery/forceps
	uid               = "stack_recipe_ancient_forceps"

/decl/stack_recipe/hardness/surgical/bonesaw
	result_type       = /obj/item/ancient_surgery/bonesaw
	uid               = "stack_recipe_ancient_bonesaw"
