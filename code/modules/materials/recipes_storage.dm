
/datum/stack_crafting/recipe/box/box
	name = "box"
	result_type = /obj/item/storage/box

/datum/stack_crafting/recipe/box/large
	name = "large box"
	result_type = /obj/item/storage/box/large

/datum/stack_crafting/recipe/box/donut
	name = "donut box"
	result_type = /obj/item/storage/box/donut/empty

/datum/stack_crafting/recipe/box/egg
	name = "egg box"
	result_type = /obj/item/storage/fancy/egg_box/empty

/datum/stack_crafting/recipe/box/light_tubes
	name = "light tubes box"
	result_type = /obj/item/storage/box/lights/tubes/empty

/datum/stack_crafting/recipe/box/light_bulbs
	name = "light bulbs box"
	result_type = /obj/item/storage/box/lights/bulbs/empty

/datum/stack_crafting/recipe/box/mouse_traps
	name = "mouse traps box"
	result_type = /obj/item/storage/box/mousetraps/empty

/datum/stack_crafting/recipe/box/pizza
	name = "pizza box"
	result_type = /obj/item/pizzabox

/datum/stack_crafting/recipe/bag
	name = "bag"
	result_type = /obj/item/storage/bag/plasticbag
	on_floor = 1

/datum/stack_crafting/recipe/folder
	name = "folder"
	result_type = /obj/item/folder
	var/modifier = "grey"

/datum/stack_crafting/recipe/folder/display_name()
	return "[modifier] [name]"

/datum/stack_crafting/recipe/folder/normal

#define COLORED_FOLDER(color) /datum/stack_crafting/recipe/folder/##color{\
	result_type = /obj/item/folder/##color;\
	modifier = #color;\
	}
COLORED_FOLDER(blue)
COLORED_FOLDER(red)
COLORED_FOLDER(cyan)
COLORED_FOLDER(yellow)
#undef COLORED_FOLDER