/decl/stack_recipe/steel
	abstract_type     = /decl/stack_recipe/steel
	required_material = /decl/material/solid/metal/steel
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE
	category          = "structures"

/decl/stack_recipe/steel/machine
	abstract_type     = /decl/stack_recipe/steel/machine
	category          = "machines"
	difficulty        = MAT_VALUE_HARD_DIY

/decl/stack_recipe/steel/machine/apc
	result_type       = /obj/item/frame/apc

/decl/stack_recipe/steel/machine/air_alarm
	result_type       = /obj/item/frame/air_alarm

/decl/stack_recipe/steel/machine/fire_alarm
	result_type       = /obj/item/frame/fire_alarm

/decl/stack_recipe/steel/machine/light
	result_type       = /obj/item/frame/light

/decl/stack_recipe/steel/machine/light_small
	result_type       = /obj/item/frame/light/small

/decl/stack_recipe/steel/machine/light_switch
	result_type       = /obj/item/frame/button/light_switch

/decl/stack_recipe/steel/machine/light_switch/windowtint
	result_type       = /obj/item/frame/button/light_switch/windowtint

/decl/stack_recipe/steel/machine/frame
	result_type       = /obj/machinery/constructable_frame/machine_frame
	req_amount        = 5 * SHEET_MATERIAL_AMOUNT // Arbitrary value since machines don't handle matter properly yet.

/decl/stack_recipe/steel/machine/frame/spawn_result(mob/user, location, amount, decl/material/mat, decl/material/reinf_mat, paint_color, spent_type, spent_amount = 1)
	return ..(user, location, amount, null, null, paint_color, spent_type, spent_amount)

/decl/stack_recipe/grenade/steel
	required_material = /decl/material/solid/metal/steel

/decl/stack_recipe/steel/cannon
	result_type       = /obj/item/cannonframe
	difficulty        = MAT_VALUE_VERY_HARD_DIY
	category          = "weapons"

/decl/stack_recipe/steel/furniture
	abstract_type     = /decl/stack_recipe/steel/furniture
	one_per_turf      = TRUE
	on_floor          = TRUE
	difficulty        = MAT_VALUE_HARD_DIY
	category          = "furniture"

/decl/stack_recipe/steel/furniture/computerframe
	result_type       = /obj/machinery/constructable_frame/computerframe
	req_amount        = 5 * SHEET_MATERIAL_AMOUNT // Arbitrary value since machines don't handle matter properly yet.
	category          = "machines"

/decl/stack_recipe/steel/furniture/computerframe/spawn_result(mob/user, location, amount, decl/material/mat, decl/material/reinf_mat, paint_color, spent_type, spent_amount = 1)
	return ..(user, location, amount, null, null)

/decl/stack_recipe/steel/furniture/door_assembly
	name              = "standard airlock assembly"
	category          = "airlock assemblies"
	abstract_type     = /decl/stack_recipe/steel/furniture/door_assembly

/decl/stack_recipe/steel/furniture/door_assembly/standard
	result_type       = /obj/structure/door_assembly

/decl/stack_recipe/steel/furniture/door_assembly/airtight
	name              = "airtight hatch assembly"
	result_type       = /obj/structure/door_assembly/door_assembly_hatch

/decl/stack_recipe/steel/furniture/door_assembly/highsec
	name              = "high security airlock assembly"
	result_type       = /obj/structure/door_assembly/door_assembly_highsecurity

/decl/stack_recipe/steel/furniture/door_assembly/ext
	name              = "exterior airlock assembly"
	result_type       = /obj/structure/door_assembly/door_assembly_ext

/decl/stack_recipe/steel/furniture/door_assembly/firedoor
	name              = "emergency shutter assembly"
	result_type       = /obj/structure/firedoor_assembly

/decl/stack_recipe/steel/furniture/door_assembly/firedoor/border
	name              = "unidirectional emergency shutter assembly"
	result_type       = /obj/structure/firedoor_assembly/border
	one_per_turf      = FALSE

/decl/stack_recipe/steel/furniture/door_assembly/double
	name              = "double airlock assembly"
	result_type       = /obj/structure/door_assembly/double

/decl/stack_recipe/steel/furniture/door_assembly/blast
	name              = "blast door assembly"
	result_type       = /obj/structure/door_assembly/blast

/decl/stack_recipe/steel/furniture/door_assembly/shutter
	name              = "shutter assembly"
	result_type       = /obj/structure/door_assembly/blast/shutter

/decl/stack_recipe/steel/furniture/door_assembly/morgue
	name              = "morgue door assembly"
	result_type       = /obj/structure/door_assembly/blast/morgue

/decl/stack_recipe/steel/furniture/canister
	result_type       = /obj/machinery/portable_atmospherics/canister
	req_amount        = 5 * SHEET_MATERIAL_AMOUNT // Arbitrary value since machines don't handle matter properly yet.

/decl/stack_recipe/steel/furniture/tank
	result_type       = /obj/item/pipe/tank

/decl/stack_recipe/steel/furniture/drill_brace
	result_type       = /obj/structure/drill_brace

/decl/stack_recipe/steel/furniture/armor_stand
	result_type       = /obj/structure/armor_stand
	difficulty        = MAT_VALUE_NORMAL_DIY

/decl/stack_recipe/steel/furniture/target_stake
	result_type       = /obj/structure/target_stake
	difficulty        = MAT_VALUE_NORMAL_DIY
