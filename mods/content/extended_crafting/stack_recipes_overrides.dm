/decl/material/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)	//recipes below don't support composite materials
		return
	if(hardness >= MAT_VALUE_FLEXIBLE)
		. += new/datum/stack_recipe/furniture/hygiene_material/sink(src)
		. += new/datum/stack_recipe/furniture/hygiene_material/urinal(src)
		. += new/datum/stack_recipe/furniture/hygiene_material/toilet(src)

/decl/material/solid/plastic/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)	//recipes below don't support composite materials
		return
	. += new/datum/stack_recipe/furniture/equipment/punchingbag(src)
	. += new/datum/stack_recipe/furniture/mop_bucket(src)

/decl/material/solid/cloth/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)	//recipes below don't support composite materials
		return
	. += new/datum/stack_recipe/furniture/mattress(src)
	. += new/datum/stack_recipe/clothing/bandana(src)
	. += new/datum/stack_recipe/clothing/bandana/green(src)
	. += new/datum/stack_recipe_list("bandana masks", create_recipe_list(/datum/stack_recipe/clothing/bandana_mask))
	. += new/datum/stack_recipe/clothing/turban(src)
	. += new/datum/stack_recipe/clothing/hijab(src)
	. += new/datum/stack_recipe/clothing/balaclava(src)
	. += new/datum/stack_recipe_list("ponchos", create_recipe_list(/datum/stack_recipe/clothing/poncho))
	. += new/datum/stack_recipe/clothing/roughspun_robe(src)

/decl/material/solid/metal/steel/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)	//recipes below don't support composite materials
		return
	. += new/datum/stack_recipe/furniture/equipment/weightlifter(src)
	. += new/datum/stack_recipe/furniture/filling_cabinet(src)
	. += new/datum/stack_recipe/furniture/filling_cabinet/wall(src)
	. += new/datum/stack_recipe/furniture/filling_cabinet/chest_drawer(src)
	. += new/datum/stack_recipe/furniture/equipment/critter_crate(src)
	. += new/datum/stack_recipe_list("carts", create_recipe_list(/datum/stack_recipe/cart))
	. += new/datum/stack_recipe/furniture/roller_bed(src)
	. += new/datum/stack_recipe/furniture/ironing_board(src)
	. += new/datum/stack_recipe/furniture/equipment/morgue(src)
	. += new/datum/stack_recipe/furniture/equipment/crematorium(src)
	. += new/datum/stack_recipe/furniture/equipment/tank_dispenser(src)
	. += new/datum/stack_recipe/furniture/wheelchair(src)
	. += new/datum/stack_recipe_list("plumbing", create_recipe_list(/datum/stack_recipe/furniture/hygiene))

/decl/material/solid/metal/plasteel/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)	//recipes below don't support composite materials
		return
	. += new/datum/stack_recipe/furniture/equipment/stasis_cage(src)

/decl/material/solid/wood/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)	//recipes below don't support composite materials
		return
	. += new/datum/stack_recipe/furniture/dogbed(src)
	. += new/datum/stack_recipe/furniture/large_wood_crate(src)
	. += new/datum/stack_recipe/furniture/large_wood_crate/ore_box(src)

/decl/material/solid/stone/generate_recipes(var/reinforce_material)
	. = ..()
	if(reinforce_material)	//recipes below don't support composite materials
		return
	. += new/datum/stack_recipe/furniture/fountain(src)
