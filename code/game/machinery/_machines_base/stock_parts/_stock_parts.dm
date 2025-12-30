/obj/item/stock_parts
	name = "stock part"
	icon = 'icons/obj/items/stock_parts/stock_parts.dmi'
	randpixel = 5
	w_class = ITEM_SIZE_SMALL
	material = /decl/material/solid/metal/steel
	var/part_flags = PART_FLAG_LAZY_INIT | PART_FLAG_HAND_REMOVE
	var/rating = 1
	var/status = 0               // Flags using PART_STAT defines.
	var/base_type                // Type representing parent of category for replacer usage.
	var/list/ignore_damage_types // Lazy list of damage types to ignore.

/obj/item/stock_parts/attack_hand(mob/user)
	if(istype(loc, /obj/machinery))
		return FALSE // Can potentially add uninstall code here, but not currently supported.
	return ..()

/obj/item/stock_parts/proc/set_component_status(var/obj/machinery/machine, var/flag)
	var/old_stat = status
	status |= flag
	if(old_stat != status)
		if(!machine)
			machine = loc
		if(istype(machine))
			machine.component_stat_change(src, old_stat, flag)

/obj/item/stock_parts/proc/unset_status(var/obj/machinery/machine, var/flag)
	var/old_stat = status
	status &= ~flag
	if(old_stat != status)
		if(!machine)
			machine = loc
		if(istype(machine))
			machine.component_stat_change(src, old_stat, flag)

/obj/item/stock_parts/proc/on_install(var/obj/machinery/machine)
	set_component_status(machine, PART_STAT_INSTALLED)

/obj/item/stock_parts/proc/on_uninstall(var/obj/machinery/machine, var/temporary = FALSE)
	unset_status(machine, PART_STAT_INSTALLED)
	stop_processing(machine)
	if(!temporary && (part_flags & PART_FLAG_QDEL))
		qdel(src)

// Use to process on the machine it's installed on.

/obj/item/stock_parts/proc/start_processing(var/obj/machinery/machine)
	if(istype(machine))
		LAZYDISTINCTADD(machine.processing_parts, src)
		START_PROCESSING_MACHINE(machine, MACHINERY_PROCESS_COMPONENTS)
		set_component_status(machine, PART_STAT_PROCESSING)

/obj/item/stock_parts/proc/stop_processing(var/obj/machinery/machine)
	if(istype(machine))
		LAZYREMOVE(machine.processing_parts, src)
		if(!LAZYLEN(machine.processing_parts))
			STOP_PROCESSING_MACHINE(machine, MACHINERY_PROCESS_COMPONENTS)
		unset_status(machine, PART_STAT_PROCESSING)

/obj/item/stock_parts/proc/machine_process(var/obj/machinery/machine)
	return PROCESS_KILL

// RefreshParts has been called, likely meaning other componenets were added/removed.
/obj/item/stock_parts/proc/on_refresh(var/obj/machinery/machine)

/obj/item/stock_parts/take_damage(damage, damage_type = BRUTE, damage_flags, inflicter, armor_pen = 0, silent, do_update_health)
	if(damage_type in ignore_damage_types)
		return
	. = ..()

/obj/item/stock_parts/check_health(lastdamage, lastdamtype, lastdamflags, consumed)
	if(!can_take_damage())
		return
	if(!is_functional())
		if(istype(loc, /obj/machinery))
			on_fail(loc, lastdamtype)
		else
			physically_destroyed()

/obj/item/stock_parts/proc/on_fail(var/obj/machinery/machine, var/damtype)
	machine.on_component_failure(src)
	var/cause = "shatters"
	switch(damtype)
		if(BURN)
			cause = "sizzles"
		if(ELECTROCUTE)
			cause = "sparks"
	visible_message(SPAN_WARNING("Something [cause] inside \the [machine]."), range = 2)
	update_name()

/obj/item/stock_parts/update_name()
	. = ..()
	if(!is_functional())
		SetName("broken [name]") // prepend 'broken' to the results

/obj/item/stock_parts/proc/is_functional()
	return (!can_take_damage()) || (current_health > 0)

/obj/item/stock_parts/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(can_take_damage())
		if(!is_functional())
			. += SPAN_WARNING("It is completely broken.")
		else if(get_percent_health() < 50)
			. += SPAN_WARNING("It is heavily damaged.")
		else if(get_percent_health() < 75)
			. += SPAN_NOTICE("It is showing signs of damage.")
		else if(is_damaged())
			. += SPAN_NOTICE("It is showing some wear and tear.")

//Machines handle damaging for us, so don't do it twice
/obj/item/stock_parts/explosion_act(severity)
	var/obj/machinery/M = loc
	if(istype(M) && (src in M.component_parts))
		return
	..()

/// Alt-click interactions provided to our parent machine.
/obj/item/stock_parts/proc/get_machine_alt_interactions(mob/user)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_BE_PURE(TRUE)
	RETURN_TYPE(/list)
	. = list()

/// A stub for showing messages based on part status when a machine is examined.
/obj/item/stock_parts/proc/on_machine_examined(mob/user)
	SHOULD_CALL_PARENT(TRUE)
