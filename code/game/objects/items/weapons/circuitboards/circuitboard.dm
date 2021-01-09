/obj/item/stock_parts/circuitboard
	name = "circuit board"
	icon = 'icons/obj/modules/module_id.dmi'
	icon_state = ICON_STATE_WORLD
	origin_tech = "{'programming':2}"
	density = 0
	anchored = 0
	w_class = ITEM_SIZE_SMALL
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	force = 5.0
	throwforce = 5.0
	throw_speed = 3
	throw_range = 15
	part_flags = 0
	material = /decl/material/solid/glass
	var/build_path = null
	var/board_type = "computer"
	var/list/req_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1
	)  // Components needed to build the machine.
	var/list/spawn_components // If set, will be used as a replacement for req_components when setting components at round start.
	var/list/additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable = 1
	) // unlike the above, this is added to req_components instead of replacing them.
	var/buildtype_select = FALSE

//Called when the circuitboard is used to contruct a new machine.
/obj/item/stock_parts/circuitboard/proc/construct(var/obj/machinery/M)
	if (istype(M, build_path))
		return 1
	return 0

//Called when a computer is deconstructed to produce a circuitboard.
//Only used by computers, as other machines store their circuitboard instance.
/obj/item/stock_parts/circuitboard/proc/deconstruct(var/obj/machinery/M)
	if (istype(M, build_path))
		return 1
	return 0

// Used with the build type selection multitool extension. Return a list of possible build types to allow multitool toggle.
/obj/item/stock_parts/circuitboard/proc/get_buildable_types()

/obj/item/stock_parts/circuitboard/Initialize()
	. = ..()
	if(buildtype_select)
		if(get_extension(src, /datum/extension/interactive/multitool))
			. = INITIALIZE_HINT_QDEL
			CRASH("A circuitboard of type [type] has conflicting multitool extensions")
		set_extension(src, /datum/extension/interactive/multitool/circuitboards/buildtype_select)
	update_desc()

/obj/item/stock_parts/circuitboard/on_uninstall(obj/machinery/machine)
	. = ..()
	if(buildtype_select && machine)
		build_path = machine.base_type || machine.type
		var/obj/machinery/thing = build_path
		SetName(T_BOARD(initial(thing.name)))

/obj/item/stock_parts/circuitboard/proc/update_desc()
	if(!build_path)
		return
	var/obj/machinery/M = build_path
	if(!desc)
		desc = "A circuitboard for \the [initial(M.name)]"
	var/list/need = req_components.Copy()
	if(!(initial(M.stat_immune) & NOSCREEN))
		LAZYSET(need, /obj/item/stock_parts/console_screen, 1)
	if(!(initial(M.stat_immune) & NOINPUT))
		LAZYSET(need, /obj/item/stock_parts/keyboard, 1)
	if(!(initial(M.stat_immune) & NOPOWER))
		LAZYADD(need, "a power source")
	var/list/parts = list()
	for(var/thing in need)
		if(ispath(thing))
			var/obj/item/fake_thing = thing
			parts += "[need[thing]] [initial(fake_thing.name)]\s"
		else
			parts += thing

	desc += "\nTo build an operational [initial(M.name)] you would need [english_list(parts)]."
