
/datum/stack_recipe/furniture
	one_per_turf = 1
	on_floor = 1
	difficulty = 2
	time = 5

/datum/stack_recipe/furniture/chair
	title = "chair"
	result_type = /obj/structure/bed/chair
	time = 10
	var/list/modifiers

/datum/stack_recipe/furniture/chair/display_name()
	return modifiers ? jointext(modifiers + ..(), " ") : ..()

/datum/stack_recipe/furniture/chair/padded
	result_type = /obj/structure/bed/chair/padded

/datum/stack_recipe/furniture/chair/office
	title = "office chair"

/datum/stack_recipe/furniture/chair/office/display_name()
	return modifiers ? jointext(modifiers + title, " ") : title // Bypass material
/datum/stack_recipe/furniture/chair/office/comfy
	result_type = /obj/structure/bed/chair/office/comfy
	title = "office comfy chair"
/datum/stack_recipe/furniture/chair/comfy
	result_type = /obj/structure/bed/chair/comfy
	title = "comfy chair"
/datum/stack_recipe/furniture/chair/arm
	result_type = /obj/structure/bed/chair/armchair
	title = "armchair"
/datum/stack_recipe/furniture/chair/roundedchair
	result_type = /obj/structure/bed/chair/rounded
	title = "rounded chair"

/datum/stack_recipe/furniture/chair/wood
/datum/stack_recipe/furniture/chair/wood/normal
	result_type = /obj/structure/bed/chair/wood
/datum/stack_recipe/furniture/chair/wood/fancy
	result_type = /obj/structure/bed/chair/wood/wings
	modifiers = list("fancy")

/datum/stack_recipe/furniture/sofa/m
	result_type = /obj/structure/bed/sofa/middle
	title = "sofa, middle"

/datum/stack_recipe/furniture/sofa/l
	result_type = /obj/structure/bed/sofa/left
	title = "sofa, left"

/datum/stack_recipe/furniture/sofa/r
	result_type = /obj/structure/bed/sofa/right
	title = "sofa, right"

/datum/stack_recipe/furniture/door
	title = "door"
	result_type = /obj/structure/door
	time = 50

/datum/stack_recipe/furniture/coatrack
	title = "coat rack"
	result_type = /obj/structure/coatrack

/datum/stack_recipe/furniture/barricade
	title = "barricade"
	result_type = /obj/structure/barricade
	time = 50

/datum/stack_recipe/furniture/banner_frame
	title = "banner frame"
	result_type = /obj/structure/banner_frame
	time = 25

/datum/stack_recipe/furniture/stool
	title = "stool"
	result_type = /obj/item/stool

/datum/stack_recipe/furniture/bar_stool
	title = "bar stool"
	result_type = /obj/item/stool/bar

/datum/stack_recipe/furniture/bed
	title = "bed"
	result_type = /obj/structure/bed

/datum/stack_recipe/furniture/pew
	title = "pew, right"
	result_type = /obj/structure/bed/chair/pew

/datum/stack_recipe/furniture/pew_left
	title = "pew, left"
	result_type = /obj/structure/bed/chair/pew/left

/datum/stack_recipe/furniture/table_frame
	title = "table frame"
	result_type = /obj/structure/table/frame
	time = 10

/datum/stack_recipe/furniture/rack
	title = "rack"
	result_type = /obj/structure/rack

/datum/stack_recipe/furniture/closet
	title = "closet"
	result_type = /obj/structure/closet
	time = 15

/datum/stack_recipe/furniture/tank_dispenser
	title = "tank dispenser"
	result_type = /obj/structure/tank_rack
	time = 15

/datum/stack_recipe/furniture/canister
	title = "canister"
	result_type = /obj/machinery/portable_atmospherics/canister
	req_amount = 20
	time = 10

/datum/stack_recipe/furniture/tank
	title = "pressure tank"
	result_type = /obj/item/pipe/tank
	time = 20

/datum/stack_recipe/furniture/computerframe
	title = "computer frame"
	result_type = /obj/machinery/constructable_frame/computerframe
	req_amount = 5
	time = 25

/datum/stack_recipe/furniture/computerframe/spawn_result(mob/user, location, amount)
	return new result_type(location)

/datum/stack_recipe/furniture/ladder
	title = "ladder"
	result_type = /obj/structure/ladder
	time = 50
	one_per_turf = TRUE
	on_floor = FALSE

/datum/stack_recipe/furniture/girder
	title = "wall support"
	result_type = /obj/structure/girder
	time = 50

/datum/stack_recipe/furniture/wall_frame
	title = "low wall frame"
	result_type = /obj/structure/wall_frame
	time = 50

/datum/stack_recipe/furniture/machine
	title = "machine frame"
	result_type = /obj/machinery/constructable_frame/machine_frame
	req_amount = 5
	time = 25

/datum/stack_recipe/furniture/machine/spawn_result(mob/user, location, amount)
	return new result_type(location)


/datum/stack_recipe/furniture/door_assembly
	time = 50

/datum/stack_recipe/furniture/door_assembly/standard
	title = "standard airlock assembly"
	result_type = /obj/structure/door_assembly

/datum/stack_recipe/furniture/door_assembly/airtight
	title = "airtight hatch assembly"
	result_type = /obj/structure/door_assembly/door_assembly_hatch

/datum/stack_recipe/furniture/door_assembly/highsec
	title = "high security airlock assembly"
	result_type = /obj/structure/door_assembly/door_assembly_highsecurity

/datum/stack_recipe/furniture/door_assembly/ext
	title = "exterior airlock assembly"
	result_type = /obj/structure/door_assembly/door_assembly_ext

/datum/stack_recipe/furniture/door_assembly/firedoor
	title = "emergency shutter assembly"
	result_type = /obj/structure/firedoor_assembly

/datum/stack_recipe/furniture/door_assembly/firedoor/border
	title = "unidirectional emergency shutter assembly"
	result_type = /obj/structure/firedoor_assembly/border
	one_per_turf = FALSE
	time = 10

/datum/stack_recipe/furniture/door_assembly/double
	title = "double airlock assembly"
	result_type = /obj/structure/door_assembly/double

/datum/stack_recipe/furniture/door_assembly/blast
	title = "blast door assembly"
	result_type = /obj/structure/door_assembly/blast

/datum/stack_recipe/furniture/door_assembly/shutter
	title = "shutter assembly"
	result_type = /obj/structure/door_assembly/blast/shutter

/datum/stack_recipe/furniture/door_assembly/morgue
	title = "morgue door assembly"
	result_type = /obj/structure/door_assembly/blast/morgue

/datum/stack_recipe/furniture/crate
	title = "crate"
	result_type = /obj/structure/closet/crate
	time = 50

/datum/stack_recipe/furniture/crate/plastic
	result_type = /obj/structure/closet/crate/plastic

/datum/stack_recipe/furniture/flaps
	title = "flaps"
	result_type = /obj/structure/plasticflaps
	time = 50

/datum/stack_recipe/furniture/coffin
	title = "coffin"
	result_type = /obj/structure/closet/coffin
	time = 15

/datum/stack_recipe/furniture/coffin/wooden
	title = "coffin"
	result_type = /obj/structure/closet/coffin/wooden
	time = 15

/datum/stack_recipe/furniture/bookcase
	title = "book shelf"
	result_type = /obj/structure/bookcase
	time = 15

/datum/stack_recipe/furniture/book_cart
	title = "book cart"
	result_type = /obj/structure/bookcase/cart
	time = 15

/datum/stack_recipe/furniture/planting_bed
	title = "planting bed"
	result_type = /obj/machinery/portable_atmospherics/hydroponics/soil
	req_amount = 3
	time = 10

/datum/stack_recipe/furniture/planting_bed/spawn_result(mob/user, location, amount)
	return new result_type(location)

/datum/stack_recipe/furniture/fullwindow
	title = "full-tile window"
	result_type = /obj/structure/window
	time = 15
	one_per_turf = 0

/datum/stack_recipe/furniture/fullwindow/can_make(mob/user)
	. = ..()
	if(.)
		for(var/obj/structure/window/check_window in user.loc)
			if(check_window.is_fulltile())
				to_chat(user, SPAN_WARNING("There is already a full-tile window here!"))
				return FALSE

/datum/stack_recipe/furniture/fullwindow/spawn_result(mob/user, location, amount)
	return new result_type(user?.loc, use_material, use_reinf_material, SOUTHWEST, TRUE)

/datum/stack_recipe/furniture/borderwindow
	title = "border window"
	result_type = /obj/structure/window
	time = 5
	one_per_turf = 0

/datum/stack_recipe/furniture/borderwindow/can_make(mob/user)
	. = ..()
	if(.)
		for(var/obj/structure/window/check_window in user.loc)
			if(check_window.dir == user.dir)
				to_chat(user, "<span class='warning'>There is already a window facing that direction here!</span>")
				return FALSE

/datum/stack_recipe/furniture/borderwindow/spawn_result(mob/user, location, amount)
	return new result_type(user?.loc, use_material, use_reinf_material, user?.dir, TRUE)

/datum/stack_recipe/furniture/windoor
	title = "windoor assembly"
	result_type = /obj/structure/windoor_assembly
	time = 20
	one_per_turf = 1

/datum/stack_recipe/furniture/windoor/can_make(mob/user)
	. = ..()
	if(.)
		if(locate(/obj/machinery/door/window) in user.loc)
			to_chat(user, "<span class='warning'>There is already a windoor here!</span>")
			return FALSE

/datum/stack_recipe/furniture/windoor/spawn_result(mob/user, location, amount)
	return new result_type(user?.loc, use_material, use_reinf_material)
