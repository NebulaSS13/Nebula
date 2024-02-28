/decl/stack_recipe/steel
	abstract_type = /decl/stack_recipe/steel
	required_material = /decl/material/solid/metal/steel

/decl/stack_recipe/steel/apc
	name = "APC frame"
	result_type = /obj/item/frame/apc
	difficulty = 2

/decl/stack_recipe/steel/air_alarm
	name = "air alarm frame"
	result_type = /obj/item/frame/air_alarm
	difficulty = 2

/decl/stack_recipe/steel/fire_alarm
	name = "fire alarm frame"
	result_type = /obj/item/frame/fire_alarm
	difficulty = 2

/decl/stack_recipe/steel/light
	name = "light fixture frame"
	result_type = /obj/item/frame/light
	difficulty = 2

/decl/stack_recipe/steel/light_small
	name = "small light fixture frame"
	result_type = /obj/item/frame/light/small
	difficulty = 2

/decl/stack_recipe/steel/light_switch
	name = "light switch frame"
	result_type = /obj/item/frame/button/light_switch
	difficulty = 2

/decl/stack_recipe/steel/light_switch/windowtint
	name = "window tint switch frame"
	result_type = /obj/item/frame/button/light_switch/windowtint
	difficulty = 2

/decl/stack_recipe/grenade/steel
	required_material = /decl/material/solid/metal/steel

/decl/stack_recipe/steel/cannon
	name = "cannon frame"
	result_type = /obj/item/cannonframe
	time = 15
	difficulty = 3

/decl/stack_recipe/steel/tile
	abstract_type = /decl/stack_recipe/steel/tile
	category = "tiling"

/decl/stack_recipe/steel/tile/metal/floor
	name = "regular floor tile"
	result_type = /obj/item/stack/tile/floor

/decl/stack_recipe/steel/tile/roof
	name = "roofing tile"
	result_type = /obj/item/stack/tile/roof

/decl/stack_recipe/steel/tile/mono
	name = "mono floor tile"
	result_type = /obj/item/stack/tile/mono

/decl/stack_recipe/steel/tile/mono_dark
	name = "dark mono floor tile"
	result_type = /obj/item/stack/tile/mono/dark

/decl/stack_recipe/steel/tile/grid
	name = "grid floor tile"
	result_type = /obj/item/stack/tile/grid

/decl/stack_recipe/steel/tile/ridged
	name = "ridged floor tile"
	result_type = /obj/item/stack/tile/ridge

/decl/stack_recipe/steel/tile/tech_grey
	name = "grey techfloor tile"
	result_type = /obj/item/stack/tile/techgrey

/decl/stack_recipe/steel/tile/tech_grid
	name = "grid techfloor tile"
	result_type = /obj/item/stack/tile/techgrid

/decl/stack_recipe/steel/tile/tech_maint
	name = "dark techfloor tile"
	result_type = /obj/item/stack/tile/techmaint

/decl/stack_recipe/steel/tile/dark
	name = "dark floor tile"
	result_type = /obj/item/stack/tile/floor_dark


/decl/stack_recipe/steel/furniture
	abstract_type = /decl/stack_recipe/steel/furniture
	one_per_turf = 1
	on_floor = 1
	difficulty = 2
	time = 5

/decl/stack_recipe/steel/furniture/computerframe
	name = "computer frame"
	result_type = /obj/machinery/constructable_frame/computerframe
	req_amount = 5
	time = 25

/decl/stack_recipe/steel/furniture/computerframe/spawn_result(mob/user, location, amount)
	return new result_type(location)

/decl/stack_recipe/steel/furniture/door_assembly
	name = "standard airlock assembly"
	category = "airlock assemblies"

/decl/stack_recipe/steel/furniture/door_assembly/standard
	result_type = /obj/structure/door_assembly

/decl/stack_recipe/steel/furniture/door_assembly/airtight
	name = "airtight hatch assembly"
	result_type = /obj/structure/door_assembly/door_assembly_hatch

/decl/stack_recipe/steel/furniture/door_assembly/highsec
	name = "high security airlock assembly"
	result_type = /obj/structure/door_assembly/door_assembly_highsecurity

/decl/stack_recipe/steel/furniture/door_assembly/ext
	name = "exterior airlock assembly"
	result_type = /obj/structure/door_assembly/door_assembly_ext

/decl/stack_recipe/steel/furniture/door_assembly/firedoor
	name = "emergency shutter assembly"
	result_type = /obj/structure/firedoor_assembly

/decl/stack_recipe/steel/furniture/door_assembly/firedoor/border
	name = "unidirectional emergency shutter assembly"
	result_type = /obj/structure/firedoor_assembly/border
	one_per_turf = FALSE
	time = 10

/decl/stack_recipe/steel/furniture/door_assembly/double
	name = "double airlock assembly"
	result_type = /obj/structure/door_assembly/double

/decl/stack_recipe/steel/furniture/door_assembly/blast
	name = "blast door assembly"
	result_type = /obj/structure/door_assembly/blast

/decl/stack_recipe/steel/furniture/door_assembly/shutter
	name = "shutter assembly"
	result_type = /obj/structure/door_assembly/blast/shutter

/decl/stack_recipe/steel/furniture/door_assembly/morgue
	name = "morgue door assembly"
	result_type = /obj/structure/door_assembly/blast/morgue

/decl/stack_recipe/steel/furniture/canister
	name = "canister"
	result_type = /obj/machinery/portable_atmospherics/canister
	req_amount = 20
	time = 10

/decl/stack_recipe/steel/furniture/tank
	name = "pressure tank"
	result_type = /obj/item/pipe/tank
	time = 20

/decl/stack_recipe/tile/pool
	name = "pool floor tile"
	result_type = /obj/item/stack/tile/pool
	required_material = /decl/material/solid/metal/steel
