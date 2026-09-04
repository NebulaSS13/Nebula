/obj/machinery/light/navigation
	name = "navigation light"
	desc = "A periodically flashing light."
	icon = 'icons/obj/lighting_nav.dmi'
	icon_state = "nav10"
	base_state = "nav1"
	light_type = /obj/item/light/tube/large
	accepts_light_type = /obj/item/light/tube/large
	on = TRUE
	var/delay = 1
	base_type = /obj/machinery/light/navigation
	frame_type = /obj/item/frame/light/nav
	stat_immune = NOPOWER | NOINPUT | NOSCREEN

/obj/machinery/light/navigation/on_update_icon()
	. = ..() // this will handle pixel offsets
	icon_state = "nav[delay][!!(lightbulb && on)]"

/obj/machinery/light/navigation/attackby(obj/item/used_item, mob/user)
	. = ..()
	if(!. && IS_MULTITOOL(used_item))
		delay = 5 + ((delay + 1) % 5)
		to_chat(user, SPAN_NOTICE("You adjust the delay on \the [src]."))
		return TRUE

/obj/machinery/light/navigation/delay2
	delay = 2

/obj/machinery/light/navigation/delay3
	delay = 3

/obj/machinery/light/navigation/delay4
	delay = 4

/obj/machinery/light/navigation/delay5
	delay = 5