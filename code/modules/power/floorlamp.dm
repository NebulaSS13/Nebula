/obj/machinery/light/flamp
	name = "lamp fixture"
	desc = "A standing lamp fixture. Can be outfitted with a lampshade."
	icon = 'icons/obj/floorlamp.dmi'
	icon_state = "flampshade_map"
	base_state = "flamp"
	base_type = /obj/machinery/light/flamp
	frame_type = /obj/item/machine_chassis/flamp
	light_type = /obj/item/light/bulb/large
	accepts_light_type = /obj/item/light/bulb/large
	var/switch_state = TRUE
	var/obj/item/lampshade/lampshade = new

/obj/machinery/light/flamp/on_update_icon()
	if(lampshade)
		base_state = "flampshade"
	else
		base_state = "flamp"
	. = ..()

/obj/machinery/light/flamp/attackby(obj/item/held_item, mob/user)
	if(!lampshade)
		if(istype(held_item, /obj/item/lampshade))
			lampshade = held_item
			user.drop_from_inventory(held_item, src)
			update_icon(0)
			return TRUE
	else if(held_item.do_tool_interaction(TOOL_SCREWDRIVER, user, src, 1 SECOND, "unscrewing", "unscrewing"))
		lampshade.dropInto(loc)
		lampshade = null
		update_icon(0)
		return TRUE
	return ..()

/obj/machinery/light/flamp/expected_to_be_on()
	// Lamps with lampshades are controlled by a switch on the lamp instead of a lightswitch.
	if(lampshade)
		return switch_state && !(stat & NOPOWER)
	return ..()

// Lamps with lampshades can be toggled by hand.
/obj/machinery/light/flamp/attack_hand(mob/user)
	if(lampshade)
		switch_state = !switch_state
		playsound(src, 'sound/items/penclick.ogg', 5, FALSE)
		user.visible_message(
			"<b>[user]</b> pushes the lamp's lightswitch.",
			SPAN_NOTICE("You push the lamp's lightswitch, turning it [switch_state ? "on" : "off"]."),
			SPAN_NOTICE("You hear a click."))
		delay_and_set_on(expected_to_be_on(), 0.5 SECONDS)
		return TRUE
	return ..()

/obj/item/light/bulb/large
	name = "large light bulb"
	b_range = 6
	b_power = 1
	lighting_modes = list(
		LIGHTMODE_EMERGENCY = list(l_range = 6, l_power = 0.45, l_color = LIGHT_COLOR_EMERGENCY),
	)

/obj/item/light/bulb/large/Initialize(mapload, obj/machinery/light/fixture)
	. = ..()
	set_scale(1.2, 1.2) // i hate this

/obj/machinery/light/flamp/noshade
	icon_state = "flampshade_map"
	lampshade = null

/obj/item/lampshade
	name = "lampshade"
	desc = "A lampshade for a lamp."
	icon = 'icons/obj/floorlamp.dmi'
	icon_state = "lampshade"
	material = /decl/material/solid/organic/cloth
	obj_flags = OBJ_FLAG_HOLLOW
	w_class = ITEM_SIZE_NORMAL

// Subtype used for creation via crafting.
/obj/machinery/light/flamp/noshade/deconstruct
	light_type = null
	panel_open = TRUE
	construct_state = /decl/machine_construction/wall_frame/no_wires/simple

/obj/item/machine_chassis/flamp
	name = "lamp fixture frame"
	desc = "A bare frame for a standing lamp fixture. Must be secured to the floor with a wrench."
	icon = 'icons/obj/floorlamp.dmi'
	icon_state = "flamp-construct-item"
	w_class = ITEM_SIZE_STRUCTURE
	material = /decl/material/solid/metal/steel
	build_type = /obj/machinery/light/flamp/noshade/deconstruct

/datum/fabricator_recipe/engineering/floorlamp
	path = /obj/item/machine_chassis/flamp