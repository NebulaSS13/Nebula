
/datum/stack_crafting/recipe/furniture
	one_per_turf = 1
	on_floor = 1
	difficulty = 2
	time = 5

/datum/stack_crafting/recipe/furniture/chair
	name = "chair"
	result_type = /obj/structure/bed/chair
	time = 10
	var/list/modifiers

/datum/stack_crafting/recipe/furniture/chair/display_name()
	return modifiers ? jointext(modifiers + ..(), " ") : ..()

/datum/stack_crafting/recipe/furniture/chair/padded
	result_type = /obj/structure/bed/chair/padded

/datum/stack_crafting/recipe/furniture/chair/office
	name = "office chair"

/datum/stack_crafting/recipe/furniture/chair/office/display_name()
	return modifiers ? jointext(modifiers + name, " ") : name // Bypass material
/datum/stack_crafting/recipe/furniture/chair/office/comfy
	result_type = /obj/structure/bed/chair/office/comfy
	name = "office comfy chair"
/datum/stack_crafting/recipe/furniture/chair/comfy
	result_type = /obj/structure/bed/chair/comfy
	name = "comfy chair"
/datum/stack_crafting/recipe/furniture/chair/arm
	result_type = /obj/structure/bed/chair/armchair
	name = "armchair"
/datum/stack_crafting/recipe/furniture/chair/roundedchair
	result_type = /obj/structure/bed/chair/rounded
	name = "rounded chair"

/datum/stack_crafting/recipe/furniture/chair/wood
/datum/stack_crafting/recipe/furniture/chair/wood/normal
	result_type = /obj/structure/bed/chair/wood
/datum/stack_crafting/recipe/furniture/chair/wood/fancy
	result_type = /obj/structure/bed/chair/wood/wings
	modifiers = list("fancy")

/datum/stack_crafting/recipe/furniture/sofa/m
	result_type = /obj/structure/bed/sofa/middle
	title = "sofa, middle"

/datum/stack_crafting/recipe/furniture/sofa/l
	result_type = /obj/structure/bed/sofa/left
	title = "sofa, left"

/datum/stack_crafting/recipe/furniture/sofa/r
	result_type = /obj/structure/bed/sofa/right
	title = "sofa, right"

/datum/stack_crafting/recipe/furniture/door
	name = "door"
	result_type = /obj/structure/door
	time = 50

/datum/stack_crafting/recipe/furniture/coatrack
	name = "coat rack"
	result_type = /obj/structure/coatrack

/datum/stack_crafting/recipe/furniture/barricade
	name = "barricade"
	result_type = /obj/structure/barricade
	time = 50
	required_tool = TOOL_WELDER

/datum/stack_crafting/recipe/furniture/stool
	name = "stool"
	result_type = /obj/item/stool

/datum/stack_crafting/recipe/furniture/bar_stool
	name = "bar stool"
	result_type = /obj/item/stool/bar

/datum/stack_crafting/recipe/furniture/bed
	name = "bed"
	result_type = /obj/structure/bed
	craftable_stack_types = list(/obj/item/stack/material)
	required_tool = TOOL_WELDER

/datum/stack_crafting/recipe/furniture/pew
	name = "pew, right"
	result_type = /obj/structure/bed/chair/pew

/datum/stack_crafting/recipe/furniture/pew_left
	name = "pew, left"
	result_type = /obj/structure/bed/chair/pew/left

/datum/stack_crafting/recipe/furniture/table_frame
	name = "table frame"
	result_type = /obj/structure/table/frame
	time = 10

/datum/stack_crafting/recipe/furniture/rack
	name = "rack"
	result_type = /obj/structure/rack

/datum/stack_crafting/recipe/furniture/closet
	name = "closet"
	result_type = /obj/structure/closet
	time = 15

/datum/stack_crafting/recipe/furniture/tank_dispenser
	name = "tank dispenser"
	result_type = /obj/structure/tank_rack
	time = 15

/datum/stack_crafting/recipe/furniture/canister
	name = "canister"
	result_type = /obj/machinery/portable_atmospherics/canister
	req_amount = 20
	time = 10

/datum/stack_crafting/recipe/furniture/tank
	name = "pressure tank"
	result_type = /obj/item/pipe/tank
	time = 20

/datum/stack_crafting/recipe/furniture/computerframe
	name = "computer frame"
	result_type = /obj/machinery/constructable_frame/computerframe
	req_amount = 5
	time = 25

/datum/stack_crafting/recipe/furniture/computerframe/spawn_result(mob/user, location, amount)
	return new result_type(location)

/datum/stack_crafting/recipe/furniture/ladder
	name = "ladder"
	result_type = /obj/structure/ladder
	time = 50
	one_per_turf = TRUE
	on_floor = FALSE

/datum/stack_crafting/recipe/furniture/girder
	name = "wall support"
	result_type = /obj/structure/girder
	time = 50

/datum/stack_crafting/recipe/furniture/wall_frame
	name = "low wall frame"
	result_type = /obj/structure/wall_frame
	time = 50

/datum/stack_crafting/recipe/furniture/machine
	name = "machine frame"
	result_type = /obj/machinery/constructable_frame/machine_frame
	req_amount = 5
	time = 25

/datum/stack_crafting/recipe/furniture/machine/spawn_result(mob/user, location, amount)
	return new result_type(location)

/datum/stack_crafting/recipe/furniture/turret
	name = "turret frame"
	result_type = /obj/machinery/porta_turret_construct
	req_amount = 5
	time = 25

/datum/stack_crafting/recipe/furniture/turret/spawn_result(mob/user, location, amount)
	return new result_type(location)

/datum/stack_crafting/recipe/furniture/door_assembly
	time = 50

/datum/stack_crafting/recipe/furniture/door_assembly/standard
	name = "standard airlock assembly"
	result_type = /obj/structure/door_assembly

/datum/stack_crafting/recipe/furniture/door_assembly/airtight
	name = "airtight hatch assembly"
	result_type = /obj/structure/door_assembly/door_assembly_hatch

/datum/stack_crafting/recipe/furniture/door_assembly/highsec
	name = "high security airlock assembly"
	result_type = /obj/structure/door_assembly/door_assembly_highsecurity

/datum/stack_crafting/recipe/furniture/door_assembly/ext
	name = "exterior airlock assembly"
	result_type = /obj/structure/door_assembly/door_assembly_ext

/datum/stack_crafting/recipe/furniture/door_assembly/firedoor
	name = "emergency shutter assembly"
	result_type = /obj/structure/firedoor_assembly

/datum/stack_crafting/recipe/furniture/door_assembly/firedoor/border
	name = "unidirectional emergency shutter assembly"
	result_type = /obj/structure/firedoor_assembly/border
	one_per_turf = FALSE
	time = 10

/datum/stack_crafting/recipe/furniture/door_assembly/double
	name = "double airlock assembly"
	result_type = /obj/structure/door_assembly/double

/datum/stack_crafting/recipe/furniture/door_assembly/blast
	name = "blast door assembly"
	result_type = /obj/structure/door_assembly/blast

/datum/stack_crafting/recipe/furniture/door_assembly/shutter
	name = "shutter assembly"
	result_type = /obj/structure/door_assembly/blast/shutter

/datum/stack_crafting/recipe/furniture/door_assembly/morgue
	name = "morgue door assembly"
	result_type = /obj/structure/door_assembly/blast/morgue

/datum/stack_crafting/recipe/furniture/crate
	name = "crate"
	result_type = /obj/structure/closet/crate
	time = 50

/datum/stack_crafting/recipe/furniture/crate/plastic
	result_type = /obj/structure/closet/crate/plastic

/datum/stack_crafting/recipe/furniture/flaps
	name = "flaps"
	result_type = /obj/structure/plasticflaps
	time = 50

/datum/stack_crafting/recipe/furniture/coffin
	name = "coffin"
	result_type = /obj/structure/closet/coffin
	time = 15

/datum/stack_crafting/recipe/furniture/coffin/wooden
	name = "coffin"
	result_type = /obj/structure/closet/coffin/wooden
	time = 15

/datum/stack_crafting/recipe/furniture/bookcase
	name = "book shelf"
	result_type = /obj/structure/bookcase
	time = 15

/datum/stack_crafting/recipe/furniture/planting_bed
	name = "planting bed"
	result_type = /obj/machinery/portable_atmospherics/hydroponics/soil
	req_amount = 3
	time = 10

/datum/stack_crafting/recipe/furniture/planting_bed/spawn_result(mob/user, location, amount)
	return new result_type(location)

/datum/stack_crafting/recipe/furniture/fullwindow
	name = "full-tile window"
	result_type = /obj/structure/window
	time = 15
	one_per_turf = 0

/datum/stack_crafting/recipe/furniture/fullwindow/can_make(mob/user)
	. = ..()
	if(.)
		for(var/obj/structure/window/check_window in user.loc)
			if(check_window.is_fulltile())
				to_chat(user, SPAN_WARNING("There is already a full-tile window here!"))
				return FALSE

/datum/stack_crafting/recipe/furniture/fullwindow/spawn_result(mob/user, location, amount)
	return new result_type(user?.loc, use_material, use_reinf_material, SOUTHWEST, TRUE)

/datum/stack_crafting/recipe/furniture/borderwindow
	name = "border window"
	result_type = /obj/structure/window
	time = 5
	one_per_turf = 0

/datum/stack_crafting/recipe/furniture/borderwindow/can_make(mob/user)
	. = ..()
	if(.)
		for(var/obj/structure/window/check_window in user.loc)
			if(check_window.dir == user.dir)
				to_chat(user, "<span class='warning'>There is already a window facing that direction here!</span>")
				return FALSE

/datum/stack_crafting/recipe/furniture/borderwindow/spawn_result(mob/user, location, amount)
	return new result_type(user?.loc, use_material, use_reinf_material, user?.dir, TRUE)

/datum/stack_crafting/recipe/furniture/windoor
	name = "windoor assembly"
	result_type = /obj/structure/windoor_assembly
	time = 20
	one_per_turf = 1

/datum/stack_crafting/recipe/furniture/windoor/can_make(mob/user)
	. = ..()
	if(.)
		if(locate(/obj/machinery/door/window) in user.loc)
			to_chat(user, "<span class='warning'>There is already a windoor here!</span>")
			return FALSE

/datum/stack_crafting/recipe/furniture/windoor/spawn_result(mob/user, location, amount)
	return new result_type(user?.loc, use_material, use_reinf_material)
