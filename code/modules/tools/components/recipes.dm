/datum/stack_recipe/tool
	abstract_type = /datum/stack_recipe/tool

/datum/stack_recipe/tool/handle
	abstract_type = /datum/stack_recipe/tool/handle
	difficulty    = 1

/datum/stack_recipe/tool/handle/long
	title         = "tool handle, long"
	result_type   = /obj/item/tool_component/handle/long

/datum/stack_recipe/tool/handle/short
	title         = "tool handle, short"
	result_type   = /obj/item/tool_component/handle/short

/datum/stack_recipe/tool/head
	abstract_type   = /datum/stack_recipe/tool/head
	difficulty      = 2

/datum/stack_recipe/tool/head/hammer
	title           = "hammer head"
	result_type   = /obj/item/tool_component/head/hammer

/datum/stack_recipe/tool/head/shovel
	title           = "shovel head"
	result_type   = /obj/item/tool_component/head/shovel

/datum/stack_recipe/tool/head/sledgehammer
	title           = "sledgehammer head"
	difficulty      = 3
	result_type   = /obj/item/tool_component/head/sledgehammer

/datum/stack_recipe/tool/head/pickaxe
	title           = "pickaxe head"
	difficulty      = 3
	result_type   = /obj/item/tool_component/head/pickaxe
