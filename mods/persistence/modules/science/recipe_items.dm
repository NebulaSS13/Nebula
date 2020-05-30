/datum/stack_recipe/experimental_device
	title = "experimental device"
	result_type = /obj/item/experiment
	time = 50
	difficulty = 1

/decl/material/steel/generate_recipes(var/reinforce_material)
	. = ..()
	. += new/datum/stack_recipe/experimental_device(src)