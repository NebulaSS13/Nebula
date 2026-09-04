/decl/stack_recipe/hardness/integrity
	abstract_type      = /decl/stack_recipe/hardness/integrity
	required_integrity = 50

/decl/stack_recipe/hardness/integrity/sign
	result_type        = /obj/item/banner/sign

/decl/stack_recipe/hardness/integrity/buckler
	result_type        = /obj/item/shield_base/buckler
	difficulty         = MAT_VALUE_HARD_DIY

// TODO: forging
/decl/stack_recipe/hardness/integrity/shield_fasteners
	result_type        = /obj/item/shield_fasteners
	difficulty         = MAT_VALUE_VERY_HARD_DIY

/decl/stack_recipe/hardness/integrity/furniture
	abstract_type      = /decl/stack_recipe/hardness/integrity/furniture
	one_per_turf       = TRUE
	on_floor           = TRUE
	difficulty         = MAT_VALUE_HARD_DIY
	category           = "furniture"

/decl/stack_recipe/hardness/integrity/furniture/door
	result_type        = /obj/structure/door
	req_amount         = 5 * SHEET_MATERIAL_AMOUNT // Arbitrary value since doors return weird matter values.

/decl/stack_recipe/hardness/integrity/furniture/barricade
	result_type        = /obj/structure/barricade

/decl/stack_recipe/hardness/integrity/furniture/banner_frame
	result_type        = /obj/structure/banner_frame

/decl/stack_recipe/hardness/integrity/furniture/sign_hook
	result_type        = /obj/structure/banner_frame/sign

/decl/stack_recipe/hardness/integrity/furniture/sign_hook/wall
	result_type        = /obj/structure/banner_frame/sign/wall

/decl/stack_recipe/hardness/integrity/furniture/coatrack
	result_type        = /obj/structure/coatrack

/decl/stack_recipe/hardness/integrity/furniture/stool
	result_type        = /obj/item/stool
	category           = "seating"

/decl/stack_recipe/hardness/integrity/furniture/bar_stool
	result_type        = /obj/item/stool/bar
	category           = "seating"

/decl/stack_recipe/hardness/integrity/furniture/bench
	result_type        = /obj/structure/chair/bench
	category           = "seating"

/decl/stack_recipe/hardness/integrity/furniture/bench/pew
	result_type        = /obj/structure/chair/bench/pew

/decl/stack_recipe/hardness/integrity/furniture/bench/lounge
	result_type        = /obj/structure/chair/bench/lounge
	difficulty         = MAT_VALUE_VERY_HARD_DIY

/decl/stack_recipe/hardness/integrity/furniture/closet
	result_type        = /obj/structure/closet

/decl/stack_recipe/hardness/integrity/furniture/tank_dispenser
	result_type        = /obj/structure/tank_rack/empty
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

/decl/stack_recipe/hardness/integrity/furniture/coffin
	result_type        = /obj/structure/closet/coffin

/decl/stack_recipe/hardness/integrity/furniture/chair
	result_type        = /obj/structure/chair
	category           = "seating"

/decl/stack_recipe/hardness/integrity/furniture/chair/office
	result_type        = /obj/structure/chair/office/comfy/unpadded
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

/decl/stack_recipe/hardness/integrity/furniture/chair/comfy
	result_type        = /obj/structure/chair/comfy/unpadded

/decl/stack_recipe/hardness/integrity/furniture/chair/arm
	result_type        = /obj/structure/chair/armchair/unpadded

/decl/stack_recipe/hardness/integrity/furniture/chair/roundedchair
	result_type        = /obj/structure/chair/rounded

/decl/stack_recipe/hardness/integrity/furniture/chair/backed
	result_type        = /obj/structure/chair/backed

/decl/stack_recipe/hardness/integrity/furniture/chair/slatted
	result_type        = /obj/structure/chair/slatted

/decl/stack_recipe/hardness/integrity/furniture/drying_rack
	result_type        = /obj/structure/drying_rack

/decl/stack_recipe/hardness/integrity/lock
	result_type        = /obj/item/lock_construct

/decl/stack_recipe/hardness/integrity/lockpick
	result_type        = /obj/item/lockpick

/decl/stack_recipe/hardness/integrity/key
	result_type        = /obj/item/key

/decl/stack_recipe/hardness/integrity/keyring
	result_type        = /obj/item/keyring

/decl/stack_recipe/hardness/integrity/rod
	result_type        = /obj/item/stack/material/rods
	difficulty         = MAT_VALUE_NORMAL_DIY

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

/decl/stack_recipe/hardness/integrity/nonflammable/lantern
	result_type        = /obj/item/flame/fuelled/lantern
	difficulty         = MAT_VALUE_HARD_DIY
	available_to_map_tech_level = MAP_TECH_LEVEL_MEDIEVAL