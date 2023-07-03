/obj/machinery/light/neon
	name = "neon light fixture"
	desc = "A neon lighting fixture."
	accepts_light_type = /obj/item/light/tube/large/neon
	light_type = /obj/item/light/tube/large/neon/yellow

/obj/machinery/light/neon/orange
	light_type = /obj/item/light/tube/large/neon/orange

/obj/machinery/light/neon/purple
	light_type = /obj/item/light/tube/large/neon/purple

/obj/machinery/light/neon/red
	light_type = /obj/item/light/tube/large/neon/red

/obj/machinery/light/neon/pink
	light_type = /obj/item/light/tube/large/neon/pink

/obj/machinery/light/neon/blue
	light_type = /obj/item/light/tube/large/neon/blue

/obj/machinery/light/neon/green
	light_type = /obj/item/light/tube/large/neon/green

/obj/machinery/light/neon/lyellow
	light_type = /obj/item/light/tube/large/neon/lyellow

//colored bulbs
/obj/item/light/tube/large/neon
	b_power = 0.95
	b_range = 4.5

/obj/item/light/tube/large/neon/red
	b_color = "#ff9999"

/obj/item/light/tube/large/neon/orange
	b_color = "#ffcc66"

/obj/item/light/tube/large/neon/purple
	b_color = "#cf90e4"

/obj/item/light/tube/large/neon/pink
	b_color = "#ff6699"

/obj/item/light/tube/large/neon/blue
	b_color = "#99ccff"

/obj/item/light/tube/large/neon/green
	b_color = "#ccff66"

/obj/item/light/tube/large/neon/yellow
	b_color = "#ffff99"

/obj/item/light/tube/large/neon/lyellow
	b_color = LIGHT_COLOR_LYELLOW

// Streetlights
/obj/item/light/bulb/street
	b_color = "#26d5db"
	b_range = 4.5
	b_power = 1.6

/obj/machinery/light/street
	name = "streetlamp"
	icon = 'mods/content/modern_nights/icons/obj/street.dmi'
	icon_state = "streetlamp_map"
	base_state = "streetlamp"
	desc = "A neon glow to light your way."
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CHECKS_BORDER
	obj_flags = null
	density = TRUE
	layer = MOB_LAYER // layer based on pixel_x/pixel_y
	light_type = /obj/item/light/bulb/street
	accepts_light_type = /obj/item/light/bulb/street
	frame_type = null // todo: create custom frame item
	construct_state = /decl/machine_construction/noninteractive // todo: create custom construction states
	directional_offset = "{'NORTH':{'y':8}, 'SOUTH':{'y':12}, 'EAST':{'x':10}, 'WEST':{'x':-10}}" // designed for use with asymmetrical pavement turfs where the south dir is smaller
	//on_wall = FALSE

// todo: move toggle into base game
/obj/machinery/light/street/Initialize(mapload, d, populate_parts)
	. = ..()
	light_offset_x = 0
	light_offset_y = 0

/obj/machinery/light/street/proc/get_blocked_dir()
	if (dir & SOUTH)
		return dir & ~SOUTH | NORTH // this is due to asymmetrical pavement
	return dir

/obj/machinery/light/street/CheckExit(atom/movable/mover, target)
	if(get_dir(mover.loc, target) & get_blocked_dir())
		return !density
	return TRUE

/obj/machinery/light/street/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	// don't check airgroup because we use CANPASS_ALWAYS
	if(get_dir(loc, target) & get_blocked_dir())
		return !density
	return TRUE