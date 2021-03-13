/obj/item/stock_parts/circuitboard/airlock_electronics
	name = "airlock electronics"
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_electronics"
	material = /decl/material/solid/glass

	build_path = /obj/machinery/door/airlock
	board_type = "door"

	req_components = list()
	additional_spawn_components = list(
		/obj/item/stock_parts/radio/receiver/buildable,
		/obj/item/stock_parts/radio/transmitter/on_event/buildable,
		/obj/item/stock_parts/power/apc/buildable
	) // The borg UI thing doesn't need screen/keyboard as borgs don't need those.

	var/secure = 0 //if set, then wires will be randomized and bolts will drop if the door is broken
/obj/item/stock_parts/circuitboard/airlock_electronics/secure
	name = "secure airlock electronics"
	desc = "designed to be somewhat more resistant to hacking than standard electronics."
	origin_tech = "{'programming':2}"
	secure = TRUE

/obj/item/stock_parts/circuitboard/airlock_electronics/windoor
	icon_state = "door_electronics_smoked"
	name = "window door electronics"
	build_path = /obj/machinery/door/window
	additional_spawn_components = list()

/obj/item/stock_parts/circuitboard/airlock_electronics/morgue
	name = "morgue door electronics"
	build_path = /obj/machinery/door/morgue
	additional_spawn_components = list()

/obj/item/stock_parts/circuitboard/airlock_electronics/blast
	name = "blast door and shutter electronics"
	build_path = /obj/machinery/door/blast
	additional_spawn_components = list(
		/obj/item/stock_parts/radio/receiver/buildable,
		/obj/item/stock_parts/power/apc/buildable
	)

/obj/item/stock_parts/circuitboard/airlock_electronics/brace
	name = "airlock brace access circuit"
	build_path = /obj/item/airlock_brace // idk why they use this; I think it's just to share the UI. This isn't used to build machines.
	req_access = list()

/obj/item/stock_parts/circuitboard/airlock_electronics/firedoor
	name = "fire door electronics"
	build_path = /obj/machinery/door/firedoor
	additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable
	)

/obj/item/stock_parts/circuitboard/airlock_electronics/brace/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, datum/topic_state/state = GLOB.deep_inventory_state)
	var/list/data = ui_data()

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "airlock_electronics.tmpl", src.name, 1000, 500, null, null, state)
		ui.set_initial_data(data)
		ui.open()

/obj/item/stock_parts/circuitboard/airlock_electronics/construct(obj/machinery/door/door)
	. = ..()
	if(istype(door, /obj/machinery/door/airlock))
		var/obj/machinery/door/airlock/airlock = door
		airlock.secured_wires = secure

/obj/item/stock_parts/circuitboard/airlock_electronics/deconstruct(obj/machinery/door/door)
	. = ..()
	if(istype(door, /obj/machinery/door/airlock))
		var/obj/machinery/door/airlock/airlock = door
		secure = airlock.secured_wires