/decl/machine_construction/default/panel_closed/door
	needs_board = "door"
	down_state = /decl/machine_construction/default/panel_open/door
	var/hacking_state = /decl/machine_construction/default/panel_closed/door/hacking

/decl/machine_construction/default/panel_closed/door/attackby(obj/item/I, mob/user, obj/machinery/machine)
	if(isScrewdriver(I))
		TRANSFER_STATE(hacking_state)
		playsound(get_turf(machine), 'sound/items/Screwdriver.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("You release some of the logic wiring on \the [machine]. The cover panel remains closed."))
		machine.update_icon()
		return
	if(isCrowbar(I))
		TRANSFER_STATE(down_state)
		playsound(get_turf(machine), 'sound/items/Crowbar.ogg', 50, 1)
		machine.panel_open = TRUE
		to_chat(user, SPAN_NOTICE("You open the main cover panel on \the [machine], exposing the internals."))
		machine.queue_icon_update()
		return TRUE
	if(istype(I, /obj/item/storage/part_replacer))
		var/obj/item/storage/part_replacer/replacer = I
		if(replacer.remote_interaction)
			machine.part_replacement(user, replacer)
		machine.display_parts(user)
		return TRUE

/decl/machine_construction/default/panel_closed/door/mechanics_info()
	. = list()
	. += "Use a screwdriver to open a small hatch and expose some logic wires."
	. += "Use a crowbar on the secured (bolted, welded or braced) airlock to pry open the main cover."
	. += "Use a parts replacer to view installed parts."

/decl/machine_construction/default/panel_closed/door/hacking
	up_state = /decl/machine_construction/default/panel_closed/door

/decl/machine_construction/default/panel_closed/door/hacking/attackby(obj/item/I, mob/user, obj/machinery/machine)
	if(isScrewdriver(I))
		TRANSFER_STATE(up_state)
		playsound(get_turf(machine), 'sound/items/Screwdriver.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("You tuck the exposed wiring back into \the [machine] and screw the hatch back into place."))
		machine.queue_icon_update()
		return TRUE

/decl/machine_construction/default/panel_closed/door/hacking/mechanics_info()
	. = list()
	. += "Use a screwdriver close the hatch and tuck the exposed wires back in."

/decl/machine_construction/default/panel_open/door
	needs_board = "door"
	up_state = /decl/machine_construction/default/panel_closed/door