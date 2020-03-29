/obj/item/gps
	name = "relay positioning device"
	desc = "Triangulates the approximate co-ordinates using a nearby satellite network."
	icon = 'icons/obj/items/device/locator.dmi'
	icon_state = "locator"
	item_state = "locator"
	origin_tech = "{'" + TECH_MATERIAL + "':2,'" + TECH_DATA + "':2,'" + TECH_BLUESPACE + "':2}"
	matter = list(MAT_ALUMINIUM = 250, MAT_STEEL = 250, MAT_GLASS = 50)
	w_class = ITEM_SIZE_SMALL
	matter = list(MAT_ALUMINIUM = 250, MAT_STEEL = 250, MAT_GLASS = 50)

/obj/item/gps/attack_self(var/mob/user)
	to_chat(user, "<span class='notice'>\icon[src] \The [src] flashes <i>[get_coordinates()]</i>.</span>")

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
