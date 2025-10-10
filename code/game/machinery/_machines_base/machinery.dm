/*
Overview:
   Used to create objects that need a per step proc call.  Default definition of 'New()'
   stores a reference to src machine in global 'machines list'.  Default definition
   of 'Destroy' removes reference to src machine in global 'machines list'.

Class Variables:
   use_power (num)
	  current state of auto power use.
	  Possible Values:
		 0 -- no auto power use
		 1 -- machine is using power at its idle power level
		 2 -- machine is using power at its active power level

   active_power_usage (num)
	  Value for the amount of power to use when in active power mode

   idle_power_usage (num)
	  Value for the amount of power to use when in idle power mode

   power_channel (num)
	  What channel to draw from when drawing power for power mode
	  Possible Values:
		 EQUIP:1 -- Equipment Channel
		 LIGHT:2 -- Lighting Channel
		 ENVIRON:3 -- Environment Channel

   component_parts (list)
	  A list of component parts of machine used by frame based machines.

   panel_open (num)
	  Whether the panel is open

   uid (num)
	  Unique id of machine across all machines.

   gl_uid (global num)
	  Next uid value in sequence

   stat (bitflag)
	  Machine status bit flags.
	  Possible bit flags:
		 BROKEN:1 -- Machine is broken
		 NOPOWER:2 -- No power is being supplied to machine.
		 MAINT:8 -- machine is currently under going maintenance.
		 EMPED:16 -- temporary broken by EMP

Class Procs:
   New()					 'game/machinery/machine.dm'

   Destroy()					 'game/machinery/machine.dm'

   powered(chan = EQUIP)		 'modules/power/power_usage.dm'
	  Checks to see if area that contains the object has power available for power
	  channel given in 'chan'.

   use_power_oneoff(amount, chan=power_channel)   'modules/power/power_usage.dm'
	  Deducts 'amount' from the power channel 'chan' of the area that contains the object.
	  This is not a continuous draw, but rather will be cleared after one APC update.

   power_change()			   'modules/power/power_usage.dm'
	  Called by the area that contains the object when ever that area under goes a
	  power state change (area runs out of power, or area channel is turned off).

   RefreshParts()			   'game/machinery/machine.dm'
	  Called to refresh the variables in the machine that are contributed to by parts
	  contained in the component_parts list. (example: glass and material amounts for
	  the autolathe)

	  Default definition does nothing.

   Process()				  'game/machinery/machine.dm'
	  Called by the 'master_controller' once per game tick for each machine that is listed in the 'machines' list.


	Compiled by Aygar
*/

/obj/machinery
	name = "machinery"
	w_class = ITEM_SIZE_STRUCTURE
	layer = STRUCTURE_LAYER // Layer under items
	throw_speed = 1
	throw_range = 5
	matter = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_PRIMARY
	)
	temperature_sensitive = TRUE
	abstract_type = /obj/machinery

	var/stat = 0
	var/waterproof = TRUE
	var/reason_broken = 0
	/// The machine will never set stat to these flags.
	var/stat_immune = NOSCREEN | NOINPUT
	var/emagged = FALSE
	/// wire datum, if any. If you place a type path, it will be autoinitialized.
	var/datum/wires/wires
	var/use_power = POWER_USE_IDLE
		//0 = dont run the auto
		//1 = run auto, use idle
		//2 = run auto, use active
	var/idle_power_usage = 0
	var/active_power_usage = 0
	/// Valid values: EQUIP, ENVIRON, LIGHT. If it should use a direct terminal connection instead, use LOCAL.
	var/power_channel = EQUIP
	/// Helps with bookkeeping when initializing atoms. Don't modify.
	var/power_init_complete = FALSE
	/// List of component instances. Expected type: /obj/item/stock_parts
	var/list/component_parts
	/// List of component paths which have lazy init (created when needed). Keys are part typepaths, values are the number of components.
	var/list/uncreated_component_parts = list(/obj/item/stock_parts/power/apc)
	/// null - no max. list(type part = number max).
	var/list/maximum_component_parts = list(/obj/item/stock_parts = 10)
	var/uid
	var/panel_open = FALSE
	var/static/gl_uid = 1
	/// Can the machine be interacted with while de-powered.
	var/interact_offline = FALSE
	/// sound played on successful interface use
	var/clicksound
	/// volume of sound played on successful interface use
	var/clickvol = 40
	///The skill used for skill checks for this machine (mostly so subtypes can use different skills).
	var/core_skill = SKILL_DEVICES
	/// Machines often do all operations on Process(). This caches the user's skill while the operations are running.
	var/operator_skill
	/// For mapped buildable types, set this to be the base type actually buildable.
	var/base_type
	/// This generic variable is to be used by mappers to give related machines a string key. In principle used by radio stock parts.
	var/id_tag
	/// what is created when the machine is dismantled.
	var/frame_type = /obj/machinery/constructable_frame/machine_frame/deconstruct
	var/required_interaction_dexterity = DEXTERITY_KEYBOARDS

	/// Component parts queued for processing by the machine. Expected type: /obj/item/stock_parts
	var/list/processing_parts
	/// Controls whether components, the machine itself, or both run their processing in Process().
	var/processing_flags

	/// Used to setup network locks on machinery at populate_parts.
	/// list(a, b) means access requires either A or B.
	/// list(list(a, b)) means access requires A and B.
	/// These can be combined, e.g. list(a, list(b, c)) requires either a, or both b and c.
	/// Null means no access requirement.
	var/list/initial_access

/obj/machinery/Initialize(mapload, d=0, populate_parts = TRUE)
	. = ..()
	if(d)
		set_dir(d)
	START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF) // It's safe to remove machines from here, but only if base machinery/Process returned PROCESS_KILL.
	SSmachines.machinery += src // All machines should remain in this list, always.
	if(ispath(wires))
		wires = new wires(src)
	populate_parts(populate_parts)
	RefreshParts()
	power_change()

/obj/machinery/Destroy()
	if(istype(wires))
		QDEL_NULL(wires)
	SSmachines.machinery -= src
	QDEL_NULL_LIST(component_parts) // Further handling is done via destroyed events.
	STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_ALL)
	. = ..()

/obj/machinery/proc/ProcessAll(var/wait)
	SHOULD_NOT_SLEEP(TRUE)
	if(processing_flags & MACHINERY_PROCESS_COMPONENTS)
		for(var/thing in processing_parts)
			var/obj/item/stock_parts/part = thing
			if(part.machine_process(src) == PROCESS_KILL)
				part.stop_processing()

	if((processing_flags & MACHINERY_PROCESS_SELF) && Process(wait) == PROCESS_KILL)
		STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

/obj/machinery/Process()
	return PROCESS_KILL // Only process if you need to.

/obj/machinery/modify_mapped_vars(map_hash)
	..()
	ADJUST_TAG_VAR(id_tag, map_hash)

/obj/machinery/proc/set_broken(new_state, cause = MACHINE_BROKEN_GENERIC)
	if(stat_immune & BROKEN)
		return FALSE
	if(!new_state == !(reason_broken & cause))
		return FALSE
	reason_broken ^= cause

	if(!reason_broken != !(stat & BROKEN))
		stat ^= BROKEN
		queue_icon_update()
		return TRUE

/obj/machinery/proc/set_noscreen(new_state)
	if(stat_immune & NOSCREEN)
		return FALSE
	if(!new_state != !(stat & NOSCREEN))// new state is different from old
		stat ^= NOSCREEN                // so flip it
		return TRUE

/obj/machinery/proc/set_noinput(new_state)
	if(stat_immune & NOINPUT)
		return FALSE
	if(!new_state != !(stat & NOINPUT))
		stat ^= NOINPUT
		return TRUE

/obj/machinery/proc/is_broken(var/additional_flags = 0)
	return (stat & (BROKEN|additional_flags))

/obj/machinery/proc/is_unpowered(var/additional_flags = 0)
	return (stat & (NOPOWER|additional_flags))

/obj/machinery/proc/operable(var/additional_flags = 0)
	return !inoperable(additional_flags)

/obj/machinery/proc/inoperable(var/additional_flags = 0)
	return (stat & (NOPOWER|BROKEN|additional_flags))

/obj/machinery/CanUseTopic(var/mob/user)
	if(stat & BROKEN)
		return STATUS_CLOSE

	if(!interact_offline && (stat & NOPOWER))
		return STATUS_CLOSE

	if(user.direct_machine_interface(src))
		return ..()

	if(stat & NOSCREEN)
		return STATUS_CLOSE

	if(stat & NOINPUT)
		return min(..(), STATUS_UPDATE)
	return ..()

/mob/proc/direct_machine_interface(obj/machinery/machine)
	return FALSE

/mob/living/silicon/direct_machine_interface(obj/machinery/machine)
	return TRUE

/mob/observer/ghost/direct_machine_interface(obj/machinery/machine)
	return TRUE

/obj/machinery/CanUseTopicPhysical(var/mob/user)
	if((stat & BROKEN) && (reason_broken & MACHINE_BROKEN_GENERIC))
		return STATUS_CLOSE

	return global.physical_topic_state.can_use_topic(nano_host(), user)

/obj/machinery/CouldUseTopic(var/mob/user)
	..()
	user.set_machine(src)
	if(clicksound && isliving(user))
		playsound(src, clicksound, clickvol)

/obj/machinery/CouldNotUseTopic(var/mob/user)
	user.unset_machine()

// This must not be converted to use OnTopic.
// mechanics_text and power_text can be done at a distance (via examination)
// while the TOPIC_REFRESH handling must come after OnTopic has resolved in the parent call of Topic.
/obj/machinery/Topic(href, href_list, datum/topic_state/state)
	if(href_list["mechanics_text"] && construct_state) // This is an OOC examine thing handled via Topic; specifically bypass all checks, but do nothing other than message to chat.
		var/list/info = get_tool_manipulation_info()
		if(info)
			to_chat(usr, jointext(info, "<br>"))
			return TOPIC_HANDLED
	if(href_list["power_text"]) // As above. Reports OOC info on how to use installed power sources.
		var/list/info = get_power_sources_info()
		if(info)
			to_chat(usr, jointext(info, "<br>"))
			return TOPIC_HANDLED
	. = ..()
	if(. == TOPIC_REFRESH)
		updateUsrDialog() // Update legacy UIs to the extent possible.
		SSnano.update_uis(src) // And our modern NanoUI ones, too.
		update_icon() // A lot of machines like to do icon updates on refresh, so we'll handle it for them here.
	else if(. == TOPIC_CLOSE)
		usr.unset_machine()
		var/datum/nanoui/open_ui = SSnano.get_open_ui(usr, src, "main")
		if(open_ui)
			open_ui.close()

/obj/machinery/proc/get_tool_manipulation_info()
	return construct_state?.mechanics_info()

/obj/machinery/proc/get_power_sources_info()
	. = list()
	var/list/power_sources = get_all_components_of_type(/obj/item/stock_parts/power, FALSE)
	if(!length(power_sources))
		. += "The machine has no power sources installed."
	for(var/obj/item/stock_parts/power/source in power_sources)
		. += source.get_source_info()

////////////////////////////////////////////////////////////////////////////////////////////

/obj/machinery/attack_ai(mob/living/silicon/ai/user)
	if(CanUseTopic(user, DefaultTopicState()) > STATUS_CLOSE)
		return interface_interact(user)

/obj/machinery/attack_robot(mob/user)
	if((. = attack_hand(user))) // This will make a physical proximity check, and allow them to deal with components and such.
		return
	if(CanUseTopic(user, DefaultTopicState()) > STATUS_CLOSE)
		return interface_interact(user) // This may still work even if the physical checks fail.

// After a recent rework this should mostly be safe.
/obj/machinery/attack_ghost(mob/user)
	interface_interact(user)

// If you don't call parent in this proc, you must make all appropriate checks yourself.
// If you do, you must respect the return value.
/obj/machinery/attack_hand(mob/user)
	if((. = ..())) // Buckling, climbers; unlikely to return true.
		return
	if(!CanPhysicallyInteract(user))
		return FALSE // The interactions below all assume physical access to the machine. If this is not the case, we let the machine take further action.
	if(!user.check_dexterity(required_interaction_dexterity))
		return TRUE
	if((. = component_attack_hand(user)))
		return
	if(wires && (. = wires.Interact(user)))
		return
	if((. = physical_attack_hand(user)))
		return
	if(CanUseTopic(user, DefaultTopicState()) > STATUS_CLOSE)
		return interface_interact(user)

// If you want to have interface interactions handled for you conveniently, use this.
// Return TRUE for handled.
// If you perform direct interactions in here, you are responsible for ensuring that full interactivity checks have been made (i.e CanInteract).
// The checks leading in to here only guarantee that the user should be able to view a UI.
/obj/machinery/proc/interface_interact(user)
	return FALSE

// If you want a physical interaction which happens after all relevant checks but preempts the UI interactions, do it here.
// Return TRUE for handled.
/obj/machinery/proc/physical_attack_hand(user)
	return FALSE

/obj/machinery/proc/RefreshParts()
	set_noinput(TRUE)
	set_noscreen(TRUE)
	for(var/thing in component_parts)
		var/obj/item/stock_parts/part = thing
		part.on_refresh(src)
	var/list/missing = missing_parts(TRUE)
	set_broken(!!missing, MACHINE_BROKEN_NO_PARTS)

/obj/machinery/proc/state(var/msg)
	audible_message(SPAN_NOTICE("[html_icon(src)] [msg]"), null, 2)

/obj/machinery/proc/ping(var/text)
	if (!text)
		text = "\The [src] pings."

	state(text, "blue")
	playsound(src.loc, 'sound/machines/ping.ogg', 50, FALSE)

/obj/machinery/proc/buzz(var/text)
	if (!text)
		text = "\The [src] buzzes."

	state(SPAN_WARNING(text), "red")
	playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, FALSE)

/obj/machinery/proc/shock(mob/user, prb)
	if(inoperable())
		return 0
	if(!prob(prb))
		return 0
	spark_at(src, amount=5, cardinal_only = TRUE)
	if(electrocute_mob(user, get_area(src), src, 0.7))
		var/area/temp_area = get_area(src)
		if(temp_area)
			var/obj/machinery/apc/temp_apc = temp_area.get_apc()
			var/obj/machinery/power/terminal/terminal = temp_apc && temp_apc.terminal()

			if(terminal && terminal.powernet)
				terminal.powernet.trigger_warning()
		if(HAS_STATUS(user, STAT_STUN))
			return 1
	return 0

/obj/machinery/proc/dismantle()
	var/obj/item/stock_parts/circuitboard/circuit = get_component_of_type(/obj/item/stock_parts/circuitboard)
	if(circuit)
		circuit.deconstruct(src)

	var/obj/frame
	if(ispath(frame_type, /obj/item/pipe) || ispath(frame_type, /obj/structure/disposalconstruct))
		frame = new frame_type(get_turf(src), src)
	else if(frame_type)
		frame = new frame_type(get_turf(src), dir)

	var/list/expelled_components = list()
	for(var/I in component_parts)
		var/component = uninstall_component(I, refresh_parts = FALSE)
		if(component)
			expelled_components += component
	while(LAZYLEN(uncreated_component_parts))
		var/path = uncreated_component_parts[1]
		var/component = uninstall_component(path, refresh_parts = FALSE)
		if(component)
			expelled_components += component
	if(frame)
		var/datum/extension/parts_stash/stash = get_extension(frame, /datum/extension/parts_stash)
		if(stash)
			stash.stash(expelled_components)

	dump_contents()

	qdel(src)
	return frame

/datum/proc/apply_visual(mob/M)
	return

/datum/proc/remove_visual(mob/M)
	return

/obj/machinery/proc/get_part_info_strings(mob/user)
	. = list()
	. += SPAN_NOTICE("The following parts are detected in \the [src]:")
	for(var/obj/item/C in component_parts)
		var/line = SPAN_NOTICE("	[C.name]")
		if(!C.current_health)
			line = SPAN_WARNING("	[C.name] (destroyed)")
		else if(C.get_percent_health() < 75)
			line = SPAN_NOTICE("	[C.name] (damaged)")
		. += line
	for(var/path in uncreated_component_parts)
		var/obj/item/thing = path
		. += SPAN_NOTICE("	[initial(thing.name)] ([uncreated_component_parts[path] || 1])")

/obj/machinery/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(component_parts && (hasHUD(user, HUD_SCIENCE) || (construct_state && construct_state.visible_components)))
		. += get_part_info_strings(user)
	if(stat & NOSCREEN)
		. += SPAN_WARNING("It is missing a screen, making it hard to interact with.")
	else if(stat & NOINPUT)
		. += SPAN_WARNING("It is missing any input device.")

	if((stat & NOPOWER))
		if(interact_offline)
			. += SPAN_WARNING("It is not receiving <a href='byond://?src=\ref[src];power_text=1'>power</a>.")
		else
			. += SPAN_WARNING("It is not receiving <a href='byond://?src=\ref[src];power_text=1'>power</a>, making it hard to interact with.")

	if(construct_state?.mechanics_info())
		. += SPAN_NOTICE("It can be <a href='byond://?src=\ref[src];mechanics_text=1'>manipulated</a> using tools.")

	var/list/missing = missing_parts()
	if(missing)
		var/list/parts = list()
		for(var/type in missing)
			var/obj/item/fake_thing = type
			parts += "[num2text(missing[type])] [initial(fake_thing.name)]"
		. += SPAN_WARNING("\The [src] is missing [english_list(parts)], rendering it inoperable.")
	for(var/obj/item/stock_parts/part in component_parts)
		var/part_strings = part.on_machine_examined(user)
		if(LAZYLEN(part_strings))
			. += part_strings

// This is really pretty crap and should be overridden for specific machines.
/obj/machinery/fluid_act(var/datum/reagents/fluids)
	..()
	if(!QDELETED(src) && !(stat & (NOPOWER|BROKEN)) && !waterproof && (fluids?.total_volume > FLUID_DEEP))
		explosion_act(3)

/obj/machinery/Move()
	var/atom/lastloc = loc
	. = ..()
	if(. && !CanFluidPass())
		if(lastloc)
			lastloc.fluid_update()
		fluid_update()

/obj/machinery/get_cell(var/functional_only = TRUE)
	var/obj/item/stock_parts/power/battery/battery = get_component_of_type(/obj/item/stock_parts/power/battery)
	if(battery && (!functional_only || battery.is_functional()))
		return battery.get_cell()

/obj/machinery/emag_act(remaining_charges, mob/user, emag_source)
	. = ..()
	for(var/obj/item/stock_parts/access_lock/lock in get_all_components_of_type(/obj/item/stock_parts/access_lock))
		. = max(., lock.emag_act())

/obj/machinery/proc/on_user_login(var/mob/M)
	return

/obj/machinery/get_req_access()
	. = ..() || list()
	for(var/obj/item/stock_parts/network_receiver/network_lock/lock in get_all_components_of_type(/obj/item/stock_parts/network_receiver/network_lock))
		.+= lock.get_req_access()

/obj/machinery/get_contained_external_atoms()
	. = ..()
	LAZYREMOVE(., component_parts)

// This only includes external atoms by default, so we need to add components back.
/obj/machinery/get_contained_matter(include_reagents = TRUE)
	. = ..()
	var/list/component_types = types_of_component(/obj/item/stock_parts)
	for(var/path in component_types)
		for(var/obj/item/stock_parts/part in get_all_components_of_type(path))
			var/list/part_costs = part.get_contained_matter(include_reagents)
			for(var/key in part_costs)
				.[key] += part_costs[key] * component_types[path]

/obj/machinery/proc/get_auto_access()
	var/area/A = get_area(src)
	return A?.req_access?.Copy()

/obj/machinery/get_matter_amount_modifier()
	. = ..() * HOLLOW_OBJECT_MATTER_MULTIPLIER // machine matter is largely just the frame, and the components contribute most of the matter/value.

///Handles updating stock parts and internal id tag when changing it to something else
/obj/machinery/proc/set_id_tag(var/new_id_tag)
	id_tag = new_id_tag
	//#TODO: Add handling for components, when we're sure it will work for any kind of machinery. Some machines do not use the same id_tag on receiver and transmitters for example.

// Make sure that mapped subtypes get the right codex entry.
/obj/machinery/get_codex_value()
	return base_type || ..()

/obj/machinery/solvent_can_melt(var/solvent_power = MAT_SOLVENT_STRONG)
	return FALSE
