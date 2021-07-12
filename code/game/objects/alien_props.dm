// Alien props for away missions and such.

// Power cells
/obj/item/cell/alien
	name = "alien device"
	desc = "It hums with power."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "unknown1"
	maxcharge = 5000
	origin_tech = "{'powerstorage':7}"
	var/static/base_icon

/obj/item/cell/alien/on_update_icon()
	if(!base_icon)
		base_icon = pick("instrument", "unknown1", "unknown3", "unknown4")
	icon_state = base_icon

// APC
#define APC_UPDATE_ALLGOOD 128

/obj/machinery/power/apc/alien
	name = "alien device"
	desc = "It's affixed to the floor, with a thick wire going into it."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "ano10"
	update_state = 0 //Don't pixelshift us on wall
	autoname = 0
	uncreated_component_parts = list(
		/obj/item/cell/alien
	)

/obj/machinery/power/apc/alien/on_update_icon()
	check_updates()
	if(update_state & APC_UPDATE_ALLGOOD)
		icon_state = "ano11"
	else
		icon_state = "ano10"

#undef APC_UPDATE_ALLGOOD

// Lights
/obj/machinery/light/alien
	name = "glowbulb"
	desc = "An alien device, perhaps some sort of light source."
	icon_state = "bulb_map"
	base_state = "bulb"
	color = COLOR_PURPLE
	light_type = /obj/item/light/alien
	accepts_light_type = /obj/item/light/alien

/obj/machinery/light/alien/Initialize()
	color = null  //It's just for mapping
	. = ..()

/obj/item/light/alien
	name = "glowbulb"
	icon_state = "lbulb"
	base_state = "lbulb"
	desc = "A simple alien device, perhaps some sort of light source."
	color = COLOR_PURPLE
	var/static/random_light_color

/obj/item/light/alien/Initialize()
	. = ..()
	if(!random_light_color)
		random_light_color = get_random_colour(FALSE, 100, 255)
	b_color = random_light_color
	color = random_light_color

//Airlock
/obj/machinery/door/airlock/alien
	name = "airlock"
	desc = "It's made of some odd metal."

/obj/machinery/door/airlock/alien/Initialize()
	. = ..()
	var/decl/material/A = GET_DECL(/decl/material/solid/metal/aliumium)
	if(A)
		door_color = A.color
	stripe_color = get_random_colour(FALSE, 0, 255)
	update_icon()
