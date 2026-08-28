/decl/stack_recipe/hardness/integrity
	abstract_type      = /decl/stack_recipe/hardness/integrity
	required_integrity = 50

/decl/stack_recipe/hardness/integrity/sign
	result_type        = /obj/item/banner/sign
	uid                = "stack_recipe_sign"

/decl/stack_recipe/hardness/integrity/buckler
	result_type        = /obj/item/shield_base/buckler
	difficulty         = MAT_VALUE_HARD_DIY
	uid                = "stack_recipe_buckler_base"

// TODO: forging
/decl/stack_recipe/hardness/integrity/shield_fasteners
	result_type        = /obj/item/shield_fasteners
	difficulty         = MAT_VALUE_VERY_HARD_DIY
	uid                = "stack_recipe_shield_fastener"

/decl/stack_recipe/hardness/integrity/furniture
	abstract_type      = /decl/stack_recipe/hardness/integrity/furniture
	one_per_turf       = TRUE
	on_floor           = TRUE
	difficulty         = MAT_VALUE_HARD_DIY
	category           = "furniture"

/decl/stack_recipe/hardness/integrity/furniture/door
	result_type        = /obj/structure/door
	req_amount         = 5 * SHEET_MATERIAL_AMOUNT // Arbitrary value since doors return weird matter values.
	uid                = "stack_recipe_door"

/decl/stack_recipe/hardness/integrity/furniture/barricade
	result_type        = /obj/structure/barricade
	uid                = "stack_recipe_barricade"

/decl/stack_recipe/hardness/integrity/furniture/banner_frame
	result_type        = /obj/structure/banner_frame
	uid                = "stack_recipe_banner_frame"

/decl/stack_recipe/hardness/integrity/furniture/sign_hook
	result_type        = /obj/structure/banner_frame/sign
	uid                = "stack_recipe_sign_hook"

/decl/stack_recipe/hardness/integrity/furniture/sign_hook/wall
	result_type        = /obj/structure/banner_frame/sign/wall
	uid                = "stack_recipe_sign_hook_wall"

/decl/stack_recipe/hardness/integrity/furniture/coatrack
	result_type        = /obj/structure/coatrack
	uid                = "stack_recipe_coatrack"

/decl/stack_recipe/hardness/integrity/furniture/stool
	result_type        = /obj/item/stool
	category           = "seating"
	uid                = "stack_recipe_stool"

/decl/stack_recipe/hardness/integrity/furniture/bar_stool
	result_type        = /obj/item/stool/bar
	category           = "seating"
	uid                = "stack_recipe_stool_bar"

/decl/stack_recipe/hardness/integrity/furniture/bench
	result_type        = /obj/structure/chair/bench
	category           = "seating"
	uid                = "stack_recipe_bench"

/decl/stack_recipe/hardness/integrity/furniture/bench/pew
	result_type        = /obj/structure/chair/bench/pew
	uid                = "stack_recipe_bench_pew"

/decl/stack_recipe/hardness/integrity/furniture/bench/lounge
	result_type        = /obj/structure/chair/bench/lounge
	difficulty         = MAT_VALUE_VERY_HARD_DIY
	uid                = "stack_recipe_bench_lounge"

/decl/stack_recipe/hardness/integrity/furniture/closet
	result_type        = /obj/structure/closet
	uid                = "stack_recipe_closet"

/decl/stack_recipe/hardness/integrity/furniture/tank_dispenser
	result_type        = /obj/structure/tank_rack/empty
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE
	uid                = "stack_recipe_tank_dispenser"

/decl/stack_recipe/hardness/integrity/furniture/coffin
	result_type        = /obj/structure/closet/coffin
	uid                = "stack_recipe_coffin"

/decl/stack_recipe/hardness/integrity/furniture/chair
	result_type        = /obj/structure/chair
	category           = "seating"
	uid                = "stack_recipe_chair"

/decl/stack_recipe/hardness/integrity/furniture/chair/office
	result_type        = /obj/structure/chair/office/comfy/unpadded
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE
	uid                = "stack_recipe_chair_office"

/decl/stack_recipe/hardness/integrity/furniture/chair/comfy
	result_type        = /obj/structure/chair/comfy/unpadded
	uid                = "stack_recipe_chair_comfy"

/decl/stack_recipe/hardness/integrity/furniture/chair/arm
	result_type        = /obj/structure/chair/armchair/unpadded
	uid                = "stack_recipe_chair_comfy_arm"

/decl/stack_recipe/hardness/integrity/furniture/chair/roundedchair
	result_type        = /obj/structure/chair/rounded
	uid                = "stack_recipe_chair_rounded"

/decl/stack_recipe/hardness/integrity/furniture/chair/backed
	result_type        = /obj/structure/chair/backed
	uid                = "stack_recipe_chair_backed"

/decl/stack_recipe/hardness/integrity/furniture/chair/slatted
	result_type        = /obj/structure/chair/slatted
	uid                = "stack_recipe_chair_slatted"

/decl/stack_recipe/hardness/integrity/furniture/drying_rack
	result_type        = /obj/structure/drying_rack
	uid                = "stack_recipe_drying_rack"

/decl/stack_recipe/hardness/integrity/lock
	result_type        = /obj/item/lock_construct
	uid                = "stack_recipe_lock_construct"

/decl/stack_recipe/hardness/integrity/lockpick
	result_type        = /obj/item/lockpick
	uid                = "stack_recipe_lockpick"

/decl/stack_recipe/hardness/integrity/key
	result_type        = /obj/item/key
	uid                = "stack_recipe_key"

/decl/stack_recipe/hardness/integrity/keyring
	result_type        = /obj/item/keyring
	uid                = "stack_recipe_keyring"

/decl/stack_recipe/hardness/integrity/rod
	result_type        = /obj/item/stack/material/rods
	difficulty         = MAT_VALUE_NORMAL_DIY
	uid                = "stack_recipe_rod"

/decl/stack_recipe/hardness/integrity/nonflammable
	abstract_type      = /decl/stack_recipe/hardness/integrity/nonflammable

/decl/stack_recipe/hardness/integrity/nonflammable/can_be_made_from(stack_type, tool_type, decl/material/mat, decl/material/reinf_mat)
	. = ..()
	if(. && (!mat || !mat.ignition_point))
		return FALSE

/decl/stack_recipe/hardness/integrity/nonflammable/sconce
	result_type        = /obj/item/wall_sconce
	difficulty         = MAT_VALUE_NORMAL_DIY
	available_to_map_tech_level = MAP_TECH_LEVEL_MEDIEVAL
	uid                = "stack_recipe_wall_sconce"

/decl/stack_recipe/hardness/integrity/nonflammable/lantern
	result_type        = /obj/item/flame/fuelled/lantern
	difficulty         = MAT_VALUE_HARD_DIY
	available_to_map_tech_level = MAP_TECH_LEVEL_MEDIEVAL
	uid                = "stack_recipe_lantern"