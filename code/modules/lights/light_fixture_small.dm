// the smaller bulb light fixture
/obj/machinery/light/small
	icon_state = "bulb_map"
	base_state = "bulb"
	desc = "A small lighting fixture."
	light_type = /obj/item/light/bulb
	accepts_light_type = /obj/item/light/bulb
	base_type = /obj/machinery/light/small
	frame_type = /obj/item/frame/light/small

/obj/machinery/light/small/emergency
	light_type = /obj/item/light/bulb/red

/obj/machinery/light/small/red
	light_type = /obj/item/light/bulb/red

/obj/machinery/light/small/readylight
	light_type = /obj/item/light/bulb/red/readylight
	var/state = 0

/obj/machinery/light/small/readylight/proc/set_state(var/new_state)
	state = new_state
	if(state)
		set_mode(lightbulb::MODE_READY)
	else
		set_mode(null)
