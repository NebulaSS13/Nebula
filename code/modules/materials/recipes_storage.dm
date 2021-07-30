//Small Box Variants
/datum/stack_recipe/box/box
	title = "box"
	result_type = /obj/item/storage/box

/datum/stack_recipe/box/beakers
	title = "beakers box"
	result_type = /obj/item/storage/box/beakers/empty

/datum/stack_recipe/box/checkers
	title = "checkers box"
	result_type = /obj/item/storage/box/checkers/empty

/datum/stack_recipe/box/chess
	title = "black chess box"
	result_type = /obj/item/storage/box/checkers/chess/empty

/datum/stack_recipe/box/chess_red
	title = "red chess box"
	result_type = /obj/item/storage/box/checkers/chess/red/empty

/datum/stack_recipe/box/donk
	title = "donk pockets box"
	result_type = /obj/item/storage/box/donkpockets/empty

/datum/stack_recipe/box/grenades
	title = "grenades box"
	result_type = /obj/item/storage/box/grenade/empty

/datum/stack_recipe/box/gloves
	title = "sterile gloves box"
	result_type = /obj/item/storage/box/gloves/empty

/datum/stack_recipe/box/handcuffs
	title = "handcuffs box"
	result_type = /obj/item/storage/box/handcuffs/empty

/datum/stack_recipe/box/ids
	title = "ids box"
	result_type = /obj/item/storage/box/ids/empty

/datum/stack_recipe/box/implant
	title = "implant box"
	result_type = /obj/item/storage/box/implant/empty

/datum/stack_recipe/box/light_tubes
	title = "light tubes box"
	result_type = /obj/item/storage/box/lights/tubes/empty

/datum/stack_recipe/box/light_bulbs
	title = "light bulbs box"
	result_type = /obj/item/storage/box/lights/bulbs/empty

/datum/stack_recipe/box/light_replacement
	title = "replacement lights box"
	result_type = /obj/item/storage/box/lights/mixed/empty

/datum/stack_recipe/box/masks
	title = "sterile masks box"
	result_type = /obj/item/storage/box/masks/empty

/datum/stack_recipe/box/monkey_cubes
	title = "monkey cubes box"
	result_type = /obj/item/storage/box/monkeycubes/empty

/datum/stack_recipe/box/mouse_traps
	title = "mouse traps box"
	result_type = /obj/item/storage/box/mousetraps/empty

/datum/stack_recipe/box/parts_big
	title = "big parts box"
	result_type = /obj/item/storage/box/parts/empty

/datum/stack_recipe/box/parts
	title = "parts pack box"
	result_type = /obj/item/storage/box/parts_pack/empty

/datum/stack_recipe/box/parts_manipulator
	title = "manipulators box"
	result_type = /obj/item/storage/box/parts_pack/manipulator/empty

/datum/stack_recipe/box/parts_lasers
	title = "lasers box"
	result_type = /obj/item/storage/box/parts_pack/laser/empty

/datum/stack_recipe/box/parts_capacitors
	title = "capacitors box"
	result_type = /obj/item/storage/box/parts_pack/capacitor/empty

/datum/stack_recipe/box/parts_keyboards
	title = "keyboards box"
	result_type = /obj/item/storage/box/parts_pack/keyboard/empty

/datum/stack_recipe/box/rad_hazard
	title = "radiation hazard box"
	result_type = /obj/item/storage/box/rad_hazard/empty

/datum/stack_recipe/box/syringes
	title = "syringes box"
	result_type = /obj/item/storage/box/syringes/empty

/datum/stack_recipe/box/survival
	title = "crew survival box"
	result_type = /obj/item/storage/box/survival/empty

/datum/stack_recipe/box/survival/engineer
	title = "engineer survival box"
	result_type = /obj/item/storage/box/engineer/empty

//Large Box Variants
/datum/stack_recipe/box/large
	title = "large box"
	result_type = /obj/item/storage/box/large

/datum/stack_recipe/box/large/ids
	title = "large ids box"
	result_type = /obj/item/storage/box/large/ids/empty


//Specialized Box Variants
/datum/stack_recipe/box/donut
	title = "donut box"
	result_type = /obj/item/storage/box/donut/empty

/datum/stack_recipe/box/egg
	title = "egg box"
	result_type = /obj/item/storage/fancy/egg_box/empty

/datum/stack_recipe/box/pizza
	title = "pizza box"
	result_type = /obj/item/pizzabox

/datum/stack_recipe/bag
	title = "bag"
	result_type = /obj/item/storage/bag/plasticbag
	on_floor = 1

/datum/stack_recipe/ammo_box
	title = "ammo box"
	result_type = /obj/item/storage/box/ammo/empty

/datum/stack_recipe/snap_pop
	title = "snap pop box"
	result_type = /obj/item/storage/box/snappops/empty

/datum/stack_recipe/matches
	title = "matchbox"
	result_type = /obj/item/storage/box/matches/empty

/datum/stack_recipe/detergent
	title = "detergent pods bag"
	result_type = /obj/item/storage/box/detergent/empty

//Folders
/datum/stack_recipe/folder
	title = "folder"
	result_type = /obj/item/folder
	var/modifier = "grey"

/datum/stack_recipe/folder/display_name()
	return "[modifier] [title]"

/datum/stack_recipe/folder/normal

#define COLORED_FOLDER(color) /datum/stack_recipe/folder/##color{\
	result_type = /obj/item/folder/##color;\
	modifier = #color\
	}
COLORED_FOLDER(blue)
COLORED_FOLDER(red)
COLORED_FOLDER(cyan)
COLORED_FOLDER(yellow)
#undef COLORED_FOLDER