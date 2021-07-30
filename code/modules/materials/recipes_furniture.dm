
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

#define PADDED_CHAIR(color) /datum/stack_recipe/furniture/chair/padded/##color{\
	result_type = /obj/structure/bed/chair/padded/##color;\
	modifiers = list("padded", #color)\
	}
PADDED_CHAIR(beige)
PADDED_CHAIR(black)
PADDED_CHAIR(brown)
PADDED_CHAIR(lime)
PADDED_CHAIR(teal)
PADDED_CHAIR(red)
PADDED_CHAIR(purple)
PADDED_CHAIR(green)
PADDED_CHAIR(yellow)
#undef PADDED_CHAIR

/datum/stack_recipe/furniture/chair/office
	title = "office chair"

/datum/stack_recipe/furniture/chair/office/display_name()
	return modifiers ? jointext(modifiers + title, " ") : title // Bypass material

/datum/stack_recipe/furniture/chair/office/light
	result_type = /obj/structure/bed/chair/office/light
	modifiers = list("light")

/datum/stack_recipe/furniture/chair/office/dark
	result_type = /obj/structure/bed/chair/office/dark
	modifiers = list("dark")

#define COMFY_OFFICE_CHAIR(color) /datum/stack_recipe/furniture/chair/office/comfy/##color{\
	result_type = /obj/structure/bed/chair/office/comfy/##color;\
	modifiers = list(#color, "comfy")\
	}
COMFY_OFFICE_CHAIR(beige)
COMFY_OFFICE_CHAIR(black)
COMFY_OFFICE_CHAIR(brown)
COMFY_OFFICE_CHAIR(lime)
COMFY_OFFICE_CHAIR(teal)
COMFY_OFFICE_CHAIR(red)
COMFY_OFFICE_CHAIR(purple)
COMFY_OFFICE_CHAIR(green)
COMFY_OFFICE_CHAIR(yellow)
#undef COMFY_OFFICE_CHAIR

/datum/stack_recipe/furniture/chair/comfy
	title = "comfy chair"

#define COMFY_CHAIR(color) /datum/stack_recipe/furniture/chair/comfy/##color{\
	result_type = /obj/structure/bed/chair/comfy/##color;\
	modifiers = list(#color)\
	}
COMFY_CHAIR(beige)
COMFY_CHAIR(black)
COMFY_CHAIR(brown)
COMFY_CHAIR(lime)
COMFY_CHAIR(teal)
COMFY_CHAIR(red)
COMFY_CHAIR(purple)
COMFY_CHAIR(green)
COMFY_CHAIR(yellow)
#undef COMFY_CHAIR

/datum/stack_recipe/furniture/chair/captain
	title = "captain chair"
	result_type = /obj/structure/bed/chair/comfy/captain

/datum/stack_recipe/furniture/chair/arm
	title = "armchair"

#define ARMCHAIR(color) /datum/stack_recipe/furniture/chair/arm/##color{\
	result_type = /obj/structure/bed/chair/armchair/##color;\
	modifiers = list(#color)\
	}
ARMCHAIR(beige)
ARMCHAIR(black)
ARMCHAIR(brown)
ARMCHAIR(lime)
ARMCHAIR(teal)
ARMCHAIR(red)
ARMCHAIR(purple)
ARMCHAIR(green)
ARMCHAIR(yellow)
#undef ARMCHAIR

/datum/stack_recipe/furniture/chair/wood

/datum/stack_recipe/furniture/chair/wood/normal
	result_type = /obj/structure/bed/chair/wood

/datum/stack_recipe/furniture/chair/wood/fancy
	result_type = /obj/structure/bed/chair/wood/wings
	modifiers = list("fancy")

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

/datum/stack_recipe/furniture/stool
	title = "stool"
	result_type = /obj/item/stool

/datum/stack_recipe/furniture/bar_stool
	title = "bar stool"
	result_type = /obj/item/stool/bar

/datum/stack_recipe/furniture/bed
	title = "bed"
	result_type = /obj/structure/bed

/datum/stack_recipe/furniture/bed/psych
	title = "psychiatrist's couch"
	result_type = /obj/structure/bed/psych

/datum/stack_recipe/furniture/pew
	title = "pew, right"
	result_type = /obj/structure/bed/chair/pew

/datum/stack_recipe/furniture/pew_left
	title = "pew, left"
	result_type = /obj/structure/bed/chair/pew/left

/datum/stack_recipe/furniture/table_frame
	title = "table frame"
	result_type = /obj/structure/table
	time = 10

/datum/stack_recipe/furniture/rack
	title = "rack"
	result_type = /obj/structure/table/rack

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

/datum/stack_recipe/furniture/turret
	title = "turret frame"
	result_type = /obj/machinery/porta_turret_construct
	req_amount = 5
	time = 25

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

/datum/stack_recipe/furniture/planting_bed
	title = "planting bed"
	result_type = /obj/machinery/portable_atmospherics/hydroponics/soil
	req_amount = 3
	time = 10

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
				to_chat(user, "<span class='warning'>There is already a fll-tile window here!</span>")
				return FALSE

/datum/stack_recipe/furniture/fullwindow/spawn_result(mob/user, location, amount)
	return new result_type(user?.loc, SOUTHWEST, 1, use_material, use_reinf_material)

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
	return new result_type(user?.loc, user?.dir, 1, use_material, use_reinf_material)

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

//Misc furniture
/datum/stack_recipe/furniture/morgue
	title = "morgue"
	result_type = /obj/structure/morgue
	difficulty = MAT_VALUE_HARD_DIY
	time = 5 SECONDS
	req_amount = 10

/datum/stack_recipe/furniture/crematorium
	title = "crematorium"
	result_type = /obj/structure/crematorium
	difficulty = MAT_VALUE_HARD_DIY
	time = 5 SECONDS
	req_amount = 10

/datum/stack_recipe/furniture/tank_dispenser
	title = "tank storage unit"
	result_type = /obj/structure/dispenser/empty

/datum/stack_recipe/furniture/displaycase
	title = "displaycase"
	result_type = /obj/structure/displaycase
	time = 15

/datum/stack_recipe/furniture/dogbed
	title = "dog bed"
	result_type = /obj/structure/dogbed
	req_amount = 4

/datum/stack_recipe/furniture/mattress
	title = "mattress"
	result_type = /obj/structure/mattress
	req_amount = 5

/datum/stack_recipe/furniture/roller_bed
	title = "roller bed"
	result_type = /obj/item/roller
	req_amount = 4

/datum/stack_recipe/furniture/wheelchair
	title = "wheelchair"
	result_type = /obj/structure/bed/chair/wheelchair
	req_amount = 10
	difficulty = MAT_VALUE_HARD_DIY
	time = 15 SECONDS

/datum/stack_recipe/furniture/ironing_board
	title = "ironing board"
	result_type = /obj/structure/bed/roller/ironingboard
	req_amount = 4

/datum/stack_recipe/furniture/filling_cabinet
	title = "filling cabinet"
	result_type = /obj/structure/filingcabinet
	difficulty = MAT_VALUE_NORMAL_DIY
	req_amount = 7

/datum/stack_recipe/furniture/filling_cabinet/wall
	title = "wall filling cabinet"
	result_type = /obj/structure/filingcabinet/wallcabinet

/datum/stack_recipe/furniture/filling_cabinet/chest_drawer
	title = "chest drawer"
	result_type = /obj/structure/filingcabinet/chestdrawer

//Plumbing / hygiene
/datum/stack_recipe/furniture/hygiene
	time = 10 SECONDS
	apply_material_name = FALSE
	on_floor = TRUE
	req_amount = 5
	difficulty = MAT_VALUE_HARD_DIY

/datum/stack_recipe/furniture/hygiene/drain/bath
	title = "bath drain"
	result_type = /obj/structure/hygiene/drain/bath

/datum/stack_recipe/furniture/hygiene/drain
	title = "drain"
	result_type = /obj/structure/hygiene/drain

/datum/stack_recipe/furniture/hygiene/faucet
	title = "faucet"
	result_type = /obj/structure/hygiene/faucet

/datum/stack_recipe/furniture/hygiene/shower
	title = "shower"
	result_type = /obj/structure/hygiene/shower

/datum/stack_recipe/furniture/hygiene/sink/puddle
	title = "puddle"
	result_type = /obj/structure/hygiene/sink/puddle
	difficulty = MAT_VALUE_EASY_DIY

/datum/stack_recipe/furniture/hygiene/sink/kitchen
	title = "kitchen sink"
	result_type = /obj/structure/hygiene/sink/kitchen

/datum/stack_recipe/furniture/hygiene/sink
	title = "sink"
	result_type = /obj/structure/hygiene/sink

/datum/stack_recipe/furniture/hygiene/sink
	title = "sink"
	result_type = /obj/structure/hygiene/sink

/datum/stack_recipe/furniture/hygiene/urinal
	title = "urinal"
	result_type = /obj/structure/hygiene/urinal

/datum/stack_recipe/furniture/hygiene/toilet
	title = "toilet"
	result_type = /obj/structure/hygiene/toilet


//Curtains
/datum/stack_recipe/furniture/curtain
	time = 1 SECOND
	apply_material_name = FALSE //curtains are either cloth or plastic
	one_per_turf = FALSE
	req_amount = 2

/datum/stack_recipe/furniture/curtain/cloth/bed
	title = "cloth bed curtain"
	result_type = /obj/item/curtain/bed

/datum/stack_recipe/furniture/curtain/cloth/black
	title = "black cloth curtain"
	result_type = /obj/item/curtain/black

/datum/stack_recipe/furniture/curtain/cloth/bar
	title = "cloth bar curtain"
	result_type = /obj/item/curtain/bar

/datum/stack_recipe/furniture/curtain/plastic/medical
	title = "plastic medical curtain"
	result_type = /obj/item/curtain/medical

/datum/stack_recipe/furniture/curtain/plastic/privacy
	title = "plastic privacy curtain"
	result_type = /obj/item/curtain/privacy

/datum/stack_recipe/furniture/curtain/plastic/shower
	title = "plastic shower curtain"
	result_type = /obj/item/curtain/shower

/datum/stack_recipe/furniture/curtain/plastic/shower/engineering
	title = "plastic engineering shower curtain"
	result_type = /obj/item/curtain/shower/engineering

/datum/stack_recipe/furniture/curtain/plastic/shower/security
	title = "plastic security shower curtain"
	result_type = /obj/item/curtain/shower/security

/datum/stack_recipe/furniture/curtain/plastic/canteen
	title = "plastic canteen curtain"
	result_type = /obj/item/curtain/canteen

//fitness
/datum/stack_recipe/furniture/weightlifter
	title = "weight lifter"
	result_type = /obj/structure/fitness/weightlifter
	difficulty = MAT_VALUE_HARD_DIY
	apply_material_name = FALSE
	req_amount = 20

/datum/stack_recipe/furniture/punchingbag
	title = "punching bag"
	result_type = /obj/structure/fitness/punchingbag
	difficulty = MAT_VALUE_NORMAL_DIY
	apply_material_name = FALSE
	req_amount = 10

//Wall Cabinets
/datum/stack_recipe/furniture/wall/fireaxe_cabinet
	title = "fireaxe cabinet"
	apply_material_name = FALSE
	result_type = /obj/structure/fireaxecabinet/empty //would be nice to have a mountable frame..
	req_amount = 2

/datum/stack_recipe/furniture/wall/extinguisher_cabinet
	title = "extinguished cabinet"
	apply_material_name = FALSE
	result_type = /obj/structure/extinguisher_cabinet/empty
	req_amount = 2

//Misc crates
/datum/stack_recipe/furniture/critter_crate
	title = "critter crate"
	time = 8 SECONDS
	difficulty = MAT_VALUE_EASY_DIY
	apply_material_name = FALSE
	req_amount = 12
	result_type = /obj/structure/closet/crate/critter

/datum/stack_recipe/furniture/large_crate
	title = "large wooden shipping crate"
	time = 8 SECONDS
	difficulty = MAT_VALUE_EASY_DIY
	apply_material_name = FALSE
	req_amount = 12
	result_type = /obj/structure/largecrate

/datum/stack_recipe/furniture/large_crate/ore_box
	title = "large wooden ore box"
	result_type = /obj/structure/ore_box
