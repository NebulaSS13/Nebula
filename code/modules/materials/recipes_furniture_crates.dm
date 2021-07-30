// crates
/datum/stack_recipe/furniture/crate
	time = 5 SECONDS
	difficulty = MAT_VALUE_NORMAL_DIY
	apply_material_name = FALSE
	req_amount = 6

/datum/stack_recipe/furniture/crate/general
	title = "crate"
	result_type = /obj/structure/closet/crate
	apply_material_name = TRUE

/datum/stack_recipe/furniture/crate/plastic
	result_type = /obj/structure/closet/crate/plastic

/datum/stack_recipe/furniture/crate/nedical
	title = "medical crate"
	result_type = /obj/structure/closet/crate/medical

/datum/stack_recipe/furniture/crate/nedical/trauma
	title = "medical trauma crate"
	result_type = /obj/structure/closet/crate/med_crate/trauma/empty

/datum/stack_recipe/furniture/crate/nedical/burn
	title = "medical burn crate"
	result_type = /obj/structure/closet/crate/med_crate/burn/empty

/datum/stack_recipe/furniture/crate/nedical/oxyloss
	title = "medical low oxygen crate"
	result_type = /obj/structure/closet/crate/med_crate/oxyloss/empty

/datum/stack_recipe/furniture/crate/nedical/toxin
	title = "medical toxin crate"
	result_type = /obj/structure/closet/crate/med_crate/toxin/empty

/datum/stack_recipe/furniture/crate/hydroponics
	title = "hydroponics crate"
	result_type = /obj/structure/closet/crate/hydroponics

/datum/stack_recipe/furniture/crate/bin
	title = "large bin"
	result_type = /obj/structure/closet/crate/bin

/datum/stack_recipe/furniture/crate/radioactive
	title = "radioactive crate"
	result_type = /obj/structure/closet/crate/radiation

//
//Secure Crates
//
/datum/stack_recipe/furniture/secure_crate
	time = 8 SECONDS
	difficulty = MAT_VALUE_HARD_DIY
	apply_material_name = FALSE
	req_amount = 8

/datum/stack_recipe/furniture/secure_crate/secure
	title = "secure crate"
	result_type = /obj/structure/closet/crate/secure

/datum/stack_recipe/furniture/secure_crate/weapon
	title = "secure weapons crate"
	result_type = /obj/structure/closet/crate/secure/weapon

/datum/stack_recipe/furniture/secure_crate/explosives
	title = "secure explosives crate"
	result_type = /obj/structure/closet/crate/secure/explosives

/datum/stack_recipe/furniture/secure_crate/shuttle
	title = "secure storage compartment"
	result_type = /obj/structure/closet/crate/secure/shuttle

/datum/stack_recipe/furniture/secure_crate/gear
	title = "secure gear crate"
	result_type = /obj/structure/closet/crate/secure/gear

/datum/stack_recipe/furniture/secure_crate/hydro
	title = "secure hydroponics crate"
	result_type = /obj/structure/closet/crate/secure/hydrosec

//
// Large Crates
//
/datum/stack_recipe/furniture/large_crate
	req_amount = 12
	apply_material_name = FALSE
	time = 8 SECONDS

/datum/stack_recipe/furniture/large_crate/large
	title = "large crate"
	result_type = /obj/structure/closet/crate/large

/datum/stack_recipe/furniture/large_crate/hydro
	title = "large hydroponics crate"
	result_type = /obj/structure/closet/crate/large/hydroponics
	
/datum/stack_recipe/furniture/large_crate/secure
	title = "large secure crate"
	result_type = /obj/structure/closet/crate/secure/large

/datum/stack_recipe/furniture/large_crate/secure/supermatter
	title = "large secure supermatter crate"
	result_type = /obj/structure/closet/crate/secure/large/supermatter