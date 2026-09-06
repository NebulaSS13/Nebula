/decl/stack_recipe/hardness
	abstract_type     = /decl/stack_recipe/hardness
	required_min_hardness = MAT_VALUE_FLEXIBLE + 10
	validation_material = DEFAULT_FURNITURE_MATERIAL

/decl/stack_recipe/hardness/improvised_armour
	result_type       = /obj/item/clothing/suit/armor/crafted
	category          = "improvised armor"

/decl/stack_recipe/hardness/improvised_armour/armguards
	result_type       = /obj/item/clothing/gloves/armguards/craftable

/decl/stack_recipe/hardness/improvised_armour/legguards
	result_type       = /obj/item/clothing/shoes/legguards/craftable

/decl/stack_recipe/hardness/improvised_armour/gauntlets
	result_type       = /obj/item/clothing/gloves/thick/craftable

/decl/stack_recipe/hardness/utensils
	abstract_type     = /decl/stack_recipe/hardness/utensils
	category          = "utensils"

/decl/stack_recipe/hardness/utensils/fork
	result_type       = /obj/item/utensil/fork

/decl/stack_recipe/hardness/utensils/chopsticks
	result_type       = /obj/item/utensil/chopsticks

/decl/stack_recipe/hardness/utensils/knife
	result_type       = /obj/item/utensil/knife
	difficulty        = MAT_VALUE_HARD_DIY

/decl/stack_recipe/hardness/utensils/spoon
	result_type       = /obj/item/utensil/spoon

/decl/stack_recipe/hardness/bell
	result_type       = /obj/item/bell
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE // similar to boxes and bats, not thematically appropriate to low tech

/decl/stack_recipe/hardness/blade
	result_type       = /obj/item/butterflyblade
	difficulty        = MAT_VALUE_NORMAL_DIY
	category          = "weapons"

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

/decl/stack_recipe/hardness/drill_head
	result_type       = /obj/item/drill_head
	difficulty        = MAT_VALUE_EASY_DIY
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

/decl/stack_recipe/hardness/baseball_bat
	result_type       = /obj/item/baseball_bat
	difficulty        = MAT_VALUE_HARD_DIY
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE // similar to boxes, not thematically appropriate to low tech
	category          = "weapons"

/decl/stack_recipe/hardness/ashtray
	result_type       = /obj/item/ashtray

/decl/stack_recipe/hardness/mortar
	result_type = /obj/item/chems/glass/mortar

/decl/stack_recipe/hardness/clipboard
	result_type       = /obj/item/clipboard
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

/decl/stack_recipe/hardness/cross
	result_type       = /obj/item/cross
	on_floor          = TRUE

/decl/stack_recipe/hardness/surgical
	abstract_type     = /decl/stack_recipe/hardness/surgical
	difficulty        = MAT_VALUE_HARD_DIY
	category          = "medical"
	available_to_map_tech_level = MAP_TECH_LEVEL_MEDIEVAL

/decl/stack_recipe/hardness/surgical/retractor
	result_type       = /obj/item/ancient_surgery/retractor

/decl/stack_recipe/hardness/surgical/cautery
	result_type       = /obj/item/ancient_surgery/cautery

/decl/stack_recipe/hardness/surgical/bonesetter
	result_type       = /obj/item/ancient_surgery/bonesetter

/decl/stack_recipe/hardness/surgical/scalpel
	result_type       = /obj/item/ancient_surgery/scalpel

/decl/stack_recipe/hardness/surgical/forceps
	result_type       = /obj/item/ancient_surgery/forceps

/decl/stack_recipe/hardness/surgical/bonesaw
	result_type       = /obj/item/ancient_surgery/bonesaw
