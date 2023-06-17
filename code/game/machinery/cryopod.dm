/*
 * Cryogenic refrigeration unit. Basically a despawner.
 * Stealing a lot of concepts/code from sleepers due to massive laziness.
 * The despawn tick will only fire if it's been more than time_till_despawned ticks
 * since time_entered, which is world.time when the occupant moves in.
 */


//Main cryopod console.

/obj/machinery/computer/cryopod
	name = "cryogenic oversight console"
	desc = "An interface between crew and the cryogenic storage oversight systems."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "cellconsole"
	density = 0
	interact_offline = 1
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	directional_offset = "{'NORTH':{'y':-24}, 'SOUTH':{'y':32}, 'EAST':{'x':-24}, 'WEST':{'x':24}}"

	//Used for logging people entering cryosleep and important items they are carrying.
	var/list/frozen_crew = list()
	var/list/frozen_items = list()
	var/list/_admin_logs = list() // _ so it shows first in VV

	var/storage_type = "crewmembers"
	var/storage_name = "Cryogenic Oversight Control"
	var/allow_items = 1

/obj/machinery/computer/cryopod/Destroy()
	QDEL_NULL_LIST(frozen_items)
	. = ..()

/obj/machinery/computer/cryopod/robot
	name = "robotic storage console"
	desc = "An interface between crew and the robotic storage systems."
	icon = 'icons/obj/robot_storage.dmi'
	icon_state = "console"

	storage_type = "cyborgs"
	storage_name = "Robotic Storage Control"
	allow_items = 0

/obj/machinery/computer/cryopod/interface_interact(mob/user)
	interact(user)
	return TRUE

/obj/machinery/computer/cryopod/interact(mob/user)
	user.set_machine(src)

	var/dat

	dat += "<hr/><br/><b>[storage_name]</b><br/>"
	dat += "<i>Welcome, [user.real_name].</i><br/><br/><hr/>"
	dat += "<a href='?src=\ref[src];log=1'>View storage log</a>.<br>"
	if(allow_items)
		dat += "<a href='?src=\ref[src];view=1'>View objects</a>.<br>"
		dat += "<a href='?src=\ref[src];item=1'>Recover object</a>.<br>"
		dat += "<a href='?src=\ref[src];allitems=1'>Recover all objects</a>.<br>"

	show_browser(user, dat, "window=cryopod_console")
	onclose(user, "cryopod_console")

/obj/machinery/computer/cryopod/OnTopic(user, href_list, state)
	if(href_list["log"])
		var/dat = "<b>Recently stored [storage_type]</b><br/><hr/><br/>"
		for(var/person in frozen_crew)
			dat += "[person]<br/>"
		dat += "<hr/>"
		show_browser(user, dat, "window=cryolog")
		. = TOPIC_REFRESH

	else if(href_list["view"])
		if(!allow_items) return

		var/dat = "<b>Recently stored objects</b><br/><hr/><br/>"
		for(var/obj/item/I in frozen_items)
			dat += "[I.name]<br/>"
		dat += "<hr/>"

		show_browser(user, dat, "window=cryoitems")
		. = TOPIC_HANDLED

	else if(href_list["item"])
		if(!allow_items) return

		if(frozen_items.len == 0)
			to_chat(user, SPAN_NOTICE("There is nothing to recover from storage."))
			return TOPIC_HANDLED

		var/obj/item/I = input(user, "Please choose which object to retrieve.","Object recovery",null) as null|anything in frozen_items
		if(!I || !CanUseTopic(user, state))
			return TOPIC_HANDLED

		if(!(I in frozen_items))
			to_chat(user, SPAN_NOTICE("\The [I] is no longer in storage."))
			return TOPIC_HANDLED

		visible_message(SPAN_NOTICE("The console beeps happily as it disgorges \the [I]."), range = 3)

		I.dropInto(loc)
		frozen_items -= I
		. = TOPIC_REFRESH

	else if(href_list["allitems"])
		if(!allow_items) return TOPIC_HANDLED

		if(frozen_items.len == 0)
			to_chat(user, SPAN_NOTICE("There is nothing to recover from storage."))
			return TOPIC_HANDLED

		visible_message(SPAN_NOTICE("The console beeps happily as it disgorges the desired objects."), range = 3)

		for(var/obj/item/I in frozen_items)
			I.dropInto(loc)
			frozen_items -= I
		. = TOPIC_REFRESH

/obj/item/stock_parts/circuitboard/cryopodcontrol
	name = "circuit board (Cryogenic Oversight Console)"
	build_path = /obj/machinery/computer/cryopod
	origin_tech = "{'programming':3}"

/obj/item/stock_parts/circuitboard/robotstoragecontrol
	name = "circuit board (Robotic Storage Console)"
	build_path = /obj/machinery/computer/cryopod/robot
	origin_tech = "{'programming':3}"

//Decorative structures to go alongside cryopods.
/obj/structure/cryofeed

	name = "cryogenic feed"
	desc = "A bewildering tangle of machinery and pipes."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "cryo_rear"
	anchored = 1
	dir = WEST

//Cryopods themselves.
/obj/machinery/cryopod
	name = "cryogenic freezer"
	desc = "A man-sized pod for entering suspended animation."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "body_scanner_0"
	density = 1
	anchored = 1
	dir = WEST

	var/base_icon_state = "body_scanner_0"
	var/occupied_icon_state = "body_scanner_1"
	var/on_store_message = "has entered long-term storage."
	var/on_store_name = "Cryogenic Oversight"
	var/on_enter_occupant_message = "You feel cool air surround you. You go numb as your senses turn inward."
	var/allow_occupant_types = list(/mob/living/carbon/human)
	var/disallow_occupant_types = list()

	var/mob/living/occupant       // Person waiting to be despawned.
	var/time_till_despawn = 9000  // Down to 15 minutes //30 minutes-ish is too long
	var/time_entered = 0          // Used to keep track of the safe period.

	var/obj/machinery/computer/cryopod/control_computer
	var/applies_stasis = 1

	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0
	var/open_sound = 'sound/machines/podopen.ogg'
	var/close_sound = 'sound/machines/podclose.ogg'

/obj/machinery/cryopod/robot
	name = "robotic storage unit"
	desc = "A storage unit for robots."
	icon = 'icons/obj/robot_storage.dmi'
	icon_state = "pod_0"
	base_icon_state = "pod_0"
	occupied_icon_state = "pod_1"
	on_store_message = "has entered robotic storage."
	on_store_name = "Robotic Storage Oversight"
	on_enter_occupant_message = "The storage unit broadcasts a sleep signal to you. Your systems start to shut down, and you enter low-power mode."
	allow_occupant_types = list(/mob/living/silicon/robot)
	disallow_occupant_types = list(/mob/living/silicon/robot/drone)
	applies_stasis = 0

/obj/machinery/cryopod/lifepod
	name = "life pod"
	desc = "A man-sized pod for entering suspended animation. Dubbed 'cryocoffin' by more cynical spacers, it is pretty barebone, counting on stasis system to keep the victim alive rather than packing extended supply of food or air. Can be ordered with symbols of common religious denominations to be used in space funerals too."
	on_store_name = "Life Pod Oversight"
	time_till_despawn = 15 SECONDS
	icon_state = "redpod0"
	base_icon_state = "redpod0"
	occupied_icon_state = "redpod1"
	var/launched = 0
	var/datum/gas_mixture/airtank

/obj/machinery/cryopod/lifepod/Initialize()
	. = ..()
	airtank = new()
	airtank.temperature = T0C
	airtank.adjust_gas(/decl/material/gas/oxygen, MOLES_O2STANDARD, 0)
	airtank.adjust_gas(/decl/material/gas/nitrogen, MOLES_N2STANDARD)

/obj/machinery/cryopod/lifepod/return_air()
	return airtank

/obj/machinery/cryopod/lifepod/proc/launch()
	launched = 1
	for(var/d in global.cardinal)
		var/turf/T = get_step(src,d)
		var/obj/machinery/door/blast/B = locate() in T
		if(B && B.density)
			B.force_open()
			break

	var/newz
	if(prob(10))
		var/list/possible_locations
		var/obj/effect/overmap/visitable/O = global.overmap_sectors[num2text(z)]
		if(istype(O))
			for(var/obj/effect/overmap/visitable/OO in range(O,2))
				if((OO.sector_flags & OVERMAP_SECTOR_IN_SPACE) || istype(OO,/obj/effect/overmap/visitable/sector/planetoid))
					LAZYDISTINCTADD(possible_locations, text2num(level))
		if(length(possible_locations))
			newz = pick(possible_locations)
	if(!newz)
		var/datum/level_data/level = SSmapping.increment_world_z_size(/datum/level_data/space)
		newz = level.level_z

	if(newz)
		var/turf/nloc = locate(rand(TRANSITIONEDGE, world.maxx-TRANSITIONEDGE), rand(TRANSITIONEDGE, world.maxy-TRANSITIONEDGE), newz)
		if(!isspaceturf(nloc))
			explosion(nloc, 1, 2, 3)
		playsound(loc,'sound/effects/rocket.ogg',100)
		forceMove(nloc)

//Don't use these for in-round leaving
// don't tell me what to do chinsky
/obj/machinery/cryopod/lifepod/Process()
	if(SSevac.evacuation_controller && SSevac.evacuation_controller.state >= EVAC_LAUNCHING)
		if(occupant && !launched)
			launch()
	..()

/obj/machinery/cryopod/Destroy()
	clear_control_computer()
	if(occupant)
		occupant.forceMove(loc)
		occupant.resting = 1
	. = ..()

/obj/machinery/cryopod/Initialize()
	. = ..()
	find_control_computer()

/obj/machinery/cryopod/proc/find_control_computer()
	if(!control_computer)
		control_computer = locate(/obj/machinery/computer/cryopod) in get_area(src)
		if(control_computer)
			events_repository.register(/decl/observ/destroyed, control_computer, src, .proc/clear_control_computer)
	return control_computer

/obj/machinery/cryopod/proc/clear_control_computer()
	if(control_computer)
		events_repository.unregister(/decl/observ/destroyed, control_computer, src)
		control_computer = null

/obj/machinery/cryopod/proc/check_occupant_allowed(mob/M)

	if(!istype(M) || M.anchored)
		return FALSE

	var/correct_type = 0
	for(var/type in allow_occupant_types)
		if(istype(M, type))
			correct_type = 1
			break

	if(!correct_type)
		return FALSE

	for(var/type in disallow_occupant_types)
		if(istype(M, type))
			return FALSE

	return TRUE

/obj/machinery/cryopod/examine(mob/user)
	. = ..()
	if (occupant && user.Adjacent(src))
		occupant.examine(arglist(args))

//Lifted from Unity stasis.dm and refactored.
/obj/machinery/cryopod/Process()
	if(occupant)
		if(applies_stasis && (world.time > time_entered + 20 SECONDS))
			occupant.set_stasis(2)

		//Allow a ten minute gap between entering the pod and actually despawning.
		// Only provide the gap if the occupant hasn't ghosted
		if ((world.time - time_entered < time_till_despawn) && (occupant.ckey))
			return

		if(!occupant.client && occupant.stat<2) //Occupant is living and has no client.
			if(!control_computer)
				if(!find_control_computer())
					return

			despawn_occupant()

// This function can not be undone; do not call this unless you are sure
// Also make sure there is a valid control computer
/obj/machinery/cryopod/robot/despawn_occupant()
	var/mob/living/silicon/robot/R = occupant
	if(!istype(R)) return ..()

	qdel(R.mmi)
	for(var/obj/item/I in R.module) // the tools the borg has; metal, glass, guns etc
		for(var/obj/item/O in I.get_contained_external_atoms()) // the things inside the tools, if anything; mainly for janiborg trash bags
			O.forceMove(R)
		qdel(I)
	qdel(R.module)

	. = ..()

// This function can not be undone; do not call this unless you are sure
// Also make sure there is a valid control computer
/obj/machinery/cryopod/proc/despawn_occupant()
	//Drop all items into the pod.
	for(var/obj/item/W in occupant.get_equipped_items(include_carried = TRUE))
		occupant.drop_from_inventory(W)
		W.forceMove(src)

		//Make sure we catch anything not handled by qdel() on the items.
		for(var/obj/item/O in W.get_contained_external_atoms())
			if(istype(O,/obj/item/storage/internal)) //Stop eating pockets, you fuck!
				continue
			O.forceMove(src)

	//Delete all items not on the preservation list.
	var/list/items = src.contents.Copy()
	items -= occupant // Don't delete the occupant
	items -= component_parts

	for(var/obj/item/W in items)

		if(!W.preserve_in_cryopod())
			qdel(W)
			continue
		if(control_computer && control_computer.allow_items)
			control_computer.frozen_items += W
			W.forceMove(null)
		else
			W.forceMove(get_turf(src))

	//Update any existing objectives involving this mob.
	for(var/datum/objective/O in global.all_objectives)
		// We don't want revs to get objectives that aren't for heads of staff. Letting
		// them win or lose based on cryo is silly so we remove the objective.
		if(O.target == occupant.mind)
			if(O.owner && O.owner.current)
				to_chat(O.owner.current, SPAN_DANGER("You get the feeling your target, [occupant.real_name], is no longer within your reach..."))
			qdel(O)

	//Handle job slot/tater cleanup.
	if(occupant.mind)
		if(occupant.mind.assigned_job)
			occupant.mind.assigned_job.clear_slot()

		if(occupant.mind.objectives.len)
			occupant.mind.objectives = null
			occupant.mind.assigned_special_role = null

	// Delete them from datacore.
	var/sanitized_name = occupant.real_name
	sanitized_name = sanitize(sanitized_name)
	var/datum/computer_file/report/crew_record/R = get_crewmember_record(sanitized_name)
	if(R)
		qdel(R)

	icon_state = base_icon_state

	//TODO: Check objectives/mode, update new targets if this mob is the target, spawn new antags?


	//Make an announcement and log the person entering storage.

	// Titles should really be fetched from data records
	//  and records should not be fetched by name as there is no guarantee names are unique
	var/role_alt_title = occupant.mind ? occupant.mind.role_alt_title : "Unknown"

	if(control_computer)
		control_computer.frozen_crew += "[occupant.real_name], [role_alt_title] - [stationtime2text()]"
		control_computer._admin_logs += "[key_name(occupant)] ([role_alt_title]) at [stationtime2text()]"
	log_and_message_admins("[key_name(occupant)] ([role_alt_title]) entered cryostorage.")

	do_telecomms_announcement(src, "[occupant.real_name], [role_alt_title], [on_store_message]", "[on_store_name]")

	//This should guarantee that ghosts don't spawn.
	occupant.ckey = null

	// Delete the mob.
	qdel(occupant)
	set_occupant(null)

/obj/machinery/cryopod/proc/attempt_enter(var/mob/target, var/mob/user)
	if(target.client)
		if(target != user)
			if(alert(target,"Would you like to enter long-term storage?",,"Yes","No") != "Yes")
				return
	if(!user.incapacitated() && !user.anchored && user.Adjacent(src) && user.Adjacent(target))
		visible_message("[user] starts putting [target] into \the [src].", range = 3)
		if(!do_after(user, 20, src)|| QDELETED(target))
			return
		set_occupant(target)
		if(close_sound)
			playsound(src, close_sound, 40)

		// Book keeping!
		log_and_message_admins("has entered a stasis pod")

		//Despawning occurs when process() is called with an occupant without a client.
		src.add_fingerprint(target)

//Like grap-put, but for mouse-drop.
/obj/machinery/cryopod/receive_mouse_drop(var/atom/dropping, var/mob/user)
	. = ..()
	if(!. && check_occupant_allowed(dropping))
		if(occupant)
			to_chat(user, SPAN_WARNING("\The [src] is in use."))
			return TRUE
		user.visible_message( \
			SPAN_NOTICE("\The [user] begins placing \the [dropping] into \the [src]."), \
			SPAN_NOTICE("You start placing \the [dropping] into \the [src]."))
		attempt_enter(dropping, user)
		return TRUE

/obj/machinery/cryopod/attackby(var/obj/item/G, var/mob/user)

	if(istype(G, /obj/item/grab))
		var/obj/item/grab/grab = G
		if(occupant)
			to_chat(user, SPAN_NOTICE("\The [src] is in use."))
			return

		if(!ismob(grab.affecting))
			return

		if(!check_occupant_allowed(grab.affecting))
			return

		attempt_enter(grab.affecting, user)
	return ..()

/obj/machinery/cryopod/verb/eject()
	set name = "Eject Pod"
	set category = "Object"
	set src in oview(1)
	if(usr.stat != 0)
		return

	icon_state = base_icon_state

	//Eject any items that aren't meant to be in the pod.
	var/list/items = get_contained_external_atoms()
	if(occupant) items -= occupant

	for(var/obj/item/W in items)
		W.dropInto(loc)

	src.go_out()
	add_fingerprint(usr)

	SetName(initial(name))
	return

/obj/machinery/cryopod/verb/move_inside()
	set name = "Enter Pod"
	set category = "Object"
	set src in oview(1)

	if(usr.stat != 0 || !check_occupant_allowed(usr))
		return

	if(src.occupant)
		to_chat(usr, SPAN_WARNING("\The [src] is in use."))
		return

	if(!usr.can_enter_cryopod(usr))
		return

	visible_message("\The [usr] starts climbing into \the [src].", range = 3)

	if(do_after(usr, 20, src))

		if(!usr || !usr.client)
			return

		if(src.occupant)
			to_chat(usr, SPAN_NOTICE("<B>\The [src] is in use.</B>"))
			return

		set_occupant(usr)

		src.add_fingerprint(usr)

	return

/obj/machinery/cryopod/proc/go_out()

	if(!occupant)
		return

	if(occupant.client)
		occupant.client.eye = src.occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE

	occupant.dropInto(loc)
	set_occupant(null)
	if(open_sound)
		playsound(src, open_sound, 40)

	icon_state = base_icon_state

	return

/obj/machinery/cryopod/proc/set_occupant(var/mob/living/carbon/occupant, var/silent)
	src.occupant = occupant
	if(!occupant)
		SetName(initial(name))
		return

	if(occupant.client)
		if(!silent)
			to_chat(occupant, SPAN_NOTICE("[on_enter_occupant_message]"))
			to_chat(occupant, SPAN_NOTICE("<b>If you ghost, log out or close your client now, your character will shortly be permanently removed from the round.</b>"))
		occupant.client.perspective = EYE_PERSPECTIVE
		occupant.client.eye = src
	occupant.forceMove(src)
	time_entered = world.time

	SetName("[name] ([occupant])")
	icon_state = occupied_icon_state

/obj/machinery/cryopod/relaymove(var/mob/user)
	go_out()

//A prop version for away missions and such

/obj/structure/broken_cryo
	name = "broken cryo sleeper"
	desc = "Whoever was inside isn't going to wake up now. It looks like you could pry it open with a crowbar."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "broken_cryo"
	anchored = 1
	density = 1
	var/closed = 1
	var/busy = 0
	var/remains_type = /obj/item/remains/human

/obj/structure/broken_cryo/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(closed)
		to_chat(user, SPAN_NOTICE("You tug at the glass, but can't open it further without a crowbar."))
	else
		to_chat(user, SPAN_NOTICE("The glass is already open."))
	return TRUE

/obj/structure/broken_cryo/attackby(obj/item/W, mob/user)
	if (busy)
		to_chat(user, SPAN_NOTICE("Someone else is attempting to open this."))
		return
	if (closed)
		if (IS_CROWBAR(W))
			busy = 1
			visible_message("[user] starts to pry the glass cover off of \the [src].")
			if (!do_after(user, 50, src))
				visible_message("[user] stops trying to pry the glass off of \the [src].")
				busy = 0
				return
			closed = 0
			busy = 0
			icon_state = "broken_cryo_open"
			var/obj/dead = new remains_type(loc)
			dead.set_dir(dir) //skeleton is oriented as cryo
	else
		to_chat(user, SPAN_NOTICE("The glass cover is already open."))

/obj/machinery/cryopod/proc/on_mob_spawn()
	playsound(src, 'sound/machines/ding.ogg', 30, 1)