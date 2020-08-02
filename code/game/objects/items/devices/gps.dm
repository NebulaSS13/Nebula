/obj/item/gps
	name = "relay positioning device"
	desc = "Triangulates the approximate co-ordinates using a nearby satellite network."
	icon = 'icons/obj/items/device/locator.dmi'
	icon_state = "locator"
	item_state = "locator"
	origin_tech = "{'materials':2,'programming':2,'wormholes':2}"
	material = /decl/material/solid/metal/aluminium
	matter = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/glass = MATTER_AMOUNT_TRACE
	)
	w_class = ITEM_SIZE_SMALL
	material = /decl/material/solid/metal/aluminium
	matter = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/glass = MATTER_AMOUNT_TRACE
	)

/obj/item/gps/attack_self(var/mob/user)
	to_chat(user, "<span class='notice'>[html_icon(src)] \The [src] flashes <i>[get_coordinates()]</i>.</span>")

/obj/item/gps/examine(mob/user)
	. = ..()
	to_chat(user, "<span class='notice'>\The [src]'s screen shows: <i>[get_coordinates()]</i>.</span>")

/obj/item/gps/proc/get_coordinates()
	var/turf/T = get_turf(src)
	return T ? "[T.x]:[T.y]:[T.z]" : "N/A"

/mob/living/carbon/human/Stat()
	. = ..()
	if(statpanel("Status"))
		var/obj/item/gps/L = locate() in src
		if(L)
			stat("Coordinates:", "[L.get_coordinates()]")
