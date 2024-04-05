/decl/stack_recipe/hardness
	abstract_type     = /decl/stack_recipe/hardness
	required_min_hardness = MAT_VALUE_FLEXIBLE + 10

/decl/stack_recipe/hardness/improvised_armour
	result_type       = /obj/item/clothing/suit/armor/crafted
	category          = "improvised armor"

/decl/stack_recipe/hardness/improvised_armour/armguards
	result_type       = /obj/item/clothing/accessory/armguards/craftable

/decl/stack_recipe/hardness/improvised_armour/legguards
	result_type       = /obj/item/clothing/accessory/legguards/craftable

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

/decl/stack_recipe/hardness/drill_head
	result_type       = /obj/item/drill_head
	difficulty        = MAT_VALUE_EASY_DIY
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

/decl/stack_recipe/hardness/baseball_bat
	result_type       = /obj/item/twohanded/baseballbat
	difficulty        = MAT_VALUE_HARD_DIY
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE // similar to boxes, not thematically appropriate to low tech
	category          = "weapons"

/decl/stack_recipe/hardness/ashtray
	result_type       = /obj/item/ashtray

/decl/stack_recipe/hardness/mortar
	result_type = /obj/item/chems/glass/mortar

/decl/stack_recipe/ring
	result_type       = /obj/item/clothing/ring/material

/decl/stack_recipe/hardness/clipboard
	result_type       = /obj/item/clipboard
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

/decl/stack_recipe/hardness/cross
	result_type       = /obj/item/cross
	on_floor          = TRUE
