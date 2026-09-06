/mob/living/silicon/robot/drone
	name = "maintenance drone"
	real_name = "drone"
	icon = 'icons/mob/robots/drones/drone.dmi'
	max_health = 35
	cell_emp_mult = 1
	universal_speak = FALSE
	universal_understand = TRUE
	gender = NEUTER
	pass_flags = PASS_FLAG_TABLE
	braintype = "Drone"
	lawupdate = 0
	density = TRUE
	req_access = list(access_engine, access_robotics)
	integrated_light_power = 0.4
	integrated_light_range = 3
	local_transmit = 1
	possession_candidate = TRUE
	speed = -1

	can_pull_size = ITEM_SIZE_NORMAL
	can_pull_mobs = MOB_PULL_SMALLER

	mob_bump_flag = SIMPLE_ANIMAL
	mob_swap_flags = SIMPLE_ANIMAL
	mob_push_flags = SIMPLE_ANIMAL
	mob_always_swap = 1
	mob_size = MOB_SIZE_SMALL

	laws = /datum/ai_laws/drone
	silicon_camera = /obj/item/camera/siliconcam/drone_camera
	holder_type = /obj/item/holder/drone
	os_type = null
	starting_stock_parts = null

	var/module_type = /obj/item/robot_module/drone

/mob/living/silicon/robot/drone/Initialize()
	. = ..()
	add_inventory_slot(new /datum/inventory_slot/head/simple)
	set_extension(src, /datum/extension/base_icon_state, icon_state)
	verbs += /mob/living/proc/hide
	remove_language(/decl/language/binary)
	add_language(/decl/language/binary, 0)
	add_language(/decl/language/binary/drone, 1)

	default_language = /decl/language/binary/drone
	// NO BRAIN.
	central_processor = null

	//We need to screw with their HP a bit. They have around one fifth as much HP as a full borg.
	for(var/V in components) if(V != "power cell")
		var/datum/robot_component/C = components[V]
		C.max_damage = 10

	verbs -= /mob/living/silicon/robot/verb/Namepick
	update_icon()

	events_repository.register(/decl/observ/moved, src, src, TYPE_PROC_REF(/mob/living/silicon/robot/drone, on_moved))

/mob/living/silicon/robot/drone/Destroy()
	events_repository.unregister(/decl/observ/moved, src, src, TYPE_PROC_REF(/mob/living/silicon/robot/drone, on_moved))
	. = ..()

/mob/living/silicon/robot/drone/proc/on_moved(var/atom/movable/am, var/turf/old_loc, var/turf/new_loc)
	old_loc = get_turf(old_loc)
	new_loc = get_turf(new_loc)
	if(!(old_loc && new_loc)) // Allows inventive admins to move drones between non-adjacent Z-levels by moving them to null space first I suppose
		return
	if(LEVELS_ARE_Z_CONNECTED(old_loc.z, new_loc.z))
		return
	// None of the tests passed, good bye
	gib()

/mob/living/silicon/robot/drone/can_be_possessed_by(var/mob/observer/ghost/possessor)
	if(!istype(possessor) || !possessor.client || !possessor.ckey)
		return FALSE
	if(!get_config_value(/decl/config/toggle/on/allow_drone_spawn))
		to_chat(possessor, SPAN_DANGER("Playing as drones is not currently permitted."))
		return FALSE
	if(too_many_active_drones())
		to_chat(possessor, SPAN_DANGER("The maximum number of active drones has been reached."))
		return FALSE
	if(jobban_isbanned(possessor,ASSIGNMENT_ROBOT))
		to_chat(possessor, SPAN_DANGER("You are banned from playing synthetics and cannot spawn as a drone."))
		return FALSE
	if(!possessor.MayRespawn(1,DRONE_SPAWN_DELAY))
		return FALSE
	return TRUE

/mob/living/silicon/robot/drone/do_possession(var/mob/observer/ghost/possessor)
	if(!(istype(possessor) && possessor.ckey))
		return 0
	if(src.ckey || src.client)
		to_chat(possessor, "<span class='warning'>\The [src] already has a player.</span>")
		return 0
	message_admins("<span class='adminnotice'>[key_name_admin(possessor)] has taken control of \the [src].</span>")
	log_admin("[key_name(possessor)] took control of \the [src].")
	transfer_personality(possessor.client)
	qdel(possessor)
	return 1

/mob/living/silicon/robot/drone/construction
	name = "construction drone"
	icon = 'icons/mob/robots/drones/drone_construction.dmi'
	laws = /datum/ai_laws/construction_drone
	module_type = /obj/item/robot_module/drone/construction
	can_pull_size = ITEM_SIZE_STRUCTURE
	can_pull_mobs = MOB_PULL_SAME
	integrated_light_power = 0.8
	integrated_light_range = 5

/mob/living/silicon/robot/drone/construction/get_bodytype()
	return GET_DECL(/decl/bodytype/drone/construction)

/decl/bodytype/drone/construction
	uid = "bodytype_drone_construction"

/decl/bodytype/drone/construction/Initialize()
	_equip_adjust = list(
		slot_head_str = list(
			"[NORTH]" = list(1, -12),
			"[SOUTH]" = list(1, -12),
			"[EAST]" =  list(1, -12),
			"[WEST]" =  list(1, -12)
		)
	)
	. = ..()

/mob/living/silicon/robot/drone/init()
	additional_law_channels["Drone"] = "d"
	if(!module)
		module = new module_type(src)

	flavor_text = "It's a tiny little repair drone. The casing is stamped with a logo and the subscript: '[global.using_map.company_name] Recursive Repair Systems: Fixing Tomorrow's Problem, Today!'"
	playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 0)

//Redefining some robot procs...
/mob/living/silicon/robot/drone/fully_replace_character_name(pickedName as text)
	// Would prefer to call the grandparent proc but this isn't possible, so...
	real_name = pickedName
	SetName(real_name)

/mob/living/silicon/robot/drone/updatename()
	if(controlling_ai)
		real_name = "remote drone ([controlling_ai.name])"
	else
		real_name = "[initial(name)] ([random_id(type,100,999)])"
	SetName(real_name)

/mob/living/silicon/robot/drone/get_eye_overlay()
	var/image/ret = ..()
	if(ret)
		if(controlling_ai)
			ret.color = COLOR_GREEN
		else if(emagged)
			ret.color = COLOR_RED
		else
			ret.color = COLOR_CYAN
	return ret

/mob/living/silicon/robot/drone/choose_icon()
	return

/mob/living/silicon/robot/drone/pick_module()
	return

//Drones cannot be upgraded with borg modules so we need to catch some items before they get used in ..().
/mob/living/silicon/robot/drone/attackby(var/obj/item/used_item, var/mob/user)
	if(istype(used_item, /obj/item/borg/upgrade))
		to_chat(user, "<span class='danger'>\The [src] is not compatible with \the [used_item].</span>")
		return TRUE
	else if(IS_CROWBAR(used_item) && !user.check_intent(I_FLAG_HARM))
		to_chat(user, "<span class='danger'>\The [src] is hermetically sealed. You can't open the case.</span>")
		return TRUE
	else if (istype(used_item, /obj/item/card/id)||istype(used_item, /obj/item/modular_computer))
		if(stat == DEAD)
			if(!get_config_value(/decl/config/toggle/on/allow_drone_spawn) || emagged || should_be_dead()) //It's dead, Dave.
				to_chat(user, "<span class='danger'>The interface is fried, and a distressing burned smell wafts from the robot's interior. You're not rebooting this one.</span>")
				return TRUE
			if(!allowed(user))
				to_chat(user, "<span class='danger'>Access denied.</span>")
				return TRUE
			var/decl/pronouns/pronouns = user.get_pronouns()
			user.visible_message( \
				SPAN_NOTICE("\The [user] swipes [pronouns.his] ID card through \the [src], attempting to reboot it."), \
				SPAN_NOTICE("You swipe your ID card through \the [src], attempting to reboot it."))
			request_player()
			return TRUE

		var/decl/pronouns/pronouns = user.get_pronouns()
		user.visible_message( \
			SPAN_DANGER("\The [user] swipes [pronouns.his] ID card through \the [src], attempting to shut it down."), \
			SPAN_DANGER("You swipe your ID card through \the [src], attempting to shut it down."))
		if(!emagged)
			if(allowed(user))
				shut_down()
			else
				to_chat(user, SPAN_DANGER("Access denied."))
		return TRUE
	return ..()

/mob/living/silicon/robot/drone/emag_act(var/remaining_charges, var/mob/user)
	if(!client || stat == DEAD)
		to_chat(user, "<span class='danger'>There's not much point subverting this heap of junk.</span>")
		return

	if(emagged)
		to_chat(src, "<span class='danger'>\The [user] attempts to load subversive software into you, but your hacked subroutines ignore the attempt.</span>")
		to_chat(user, "<span class='danger'>You attempt to subvert [src], but the sequencer has no effect.</span>")
		return

	to_chat(user, "<span class='danger'>You swipe the sequencer across [src]'s interface and watch its eyes flicker.</span>")
	if(controlling_ai)
		to_chat(src, "<span class='danger'>\The [user] loads some kind of subversive software into the remote drone, corrupting its lawset but luckily sparing yours.</span>")
	else
		to_chat(src, "<span class='danger'>You feel a sudden burst of malware loaded into your execute-as-root buffer. Your tiny brain methodically parses, loads and executes the script.</span>")

	log_and_message_admins("emagged drone [key_name_admin(src)].  Laws overridden.", user)
	log_game("[key_name(user)] emagged drone [key_name(src)][controlling_ai ? " but AI [key_name(controlling_ai)] is in remote control" : " Laws overridden"].")
	var/time = time2text(world.realtime,"hh:mm:ss")
	global.lawchanges.Add("[time] <B>:</B> [user.name]([user.key]) emagged [name]([key])")

	emagged = 1
	lawupdate = 0
	connected_ai = null
	clear_supplied_laws()
	clear_inherent_laws()
	QDEL_NULL(laws)
	laws = new /datum/ai_laws/syndicate_override
	var/decl/pronouns/pronouns = user.get_pronouns(ignore_coverings = TRUE)
	set_zeroth_law("Only [user.real_name] and people [pronouns.he] designates as being such are operatives.")
	if(!controlling_ai)
		to_chat(src, "<b>Obey these laws:</b>")
		laws.show_laws(src)
		to_chat(src, SPAN_DANGER("ALERT: [user.real_name] is your new master. Obey your new laws and [pronouns.his] commands."))
	return 1

/mob/living/silicon/robot/drone/adjustBruteLoss(var/amount, var/do_update_health = TRUE)
	. = ..()
	if(amount && should_be_dead() && stat == DEAD && !QDELETED(src))
		gib()

//CONSOLE PROCS
/mob/living/silicon/robot/drone/proc/law_resync()

	if(controlling_ai)
		to_chat(src, "<span class='warning'>Someone issues a remote law reset order for this unit, but you disregard it.</span>")
		return

	if(stat != DEAD)
		if(emagged)
			to_chat(src, "<span class='danger'>You feel something attempting to modify your programming, but your hacked subroutines are unaffected.</span>")
		else
			to_chat(src, "<span class='danger'>A reset-to-factory directive packet filters through your data connection, and you obediently modify your programming to suit it.</span>")
			full_law_reset()
			show_laws()

/mob/living/silicon/robot/drone/proc/shut_down()

	if(controlling_ai)
		to_chat(src, "<span class='warning'>Someone issues a remote kill order for this unit, but you disregard it.</span>")
		return

	if(stat != DEAD)
		if(emagged)
			to_chat(src, "<span class='danger'>You feel a system kill order percolate through your tiny brain, but it doesn't seem like a good idea to you.</span>")
		else
			to_chat(src, "<span class='danger'>You feel a system kill order percolate through your tiny brain, and you obediently destroy yourself.</span>")
			death()

/mob/living/silicon/robot/drone/proc/full_law_reset()
	clear_supplied_laws(1)
	clear_inherent_laws(1)
	clear_ion_laws(1)
	QDEL_NULL(laws)
	var/law_type = initial(laws) || global.using_map.default_law_type
	laws = new law_type

//Reboot procs.

/mob/living/silicon/robot/drone/proc/request_player()
	if(too_many_active_drones())
		return
	var/decl/ghosttrap/ghosttrap = GET_DECL(/decl/ghosttrap/maintenance_drone)
	ghosttrap.request_player(src, "Someone is attempting to reboot a maintenance drone.", 30 SECONDS)

/mob/living/silicon/robot/drone/proc/transfer_personality(var/client/player)
	if(!player) return
	src.ckey = player.ckey

	if(player.mob && player.mob.mind)
		player.mob.mind.transfer_to(src)

	lawupdate = 0
	to_chat(src, "<b>Systems rebooted</b>. Loading base pattern maintenance protocol... <b>loaded</b>.")
	full_law_reset()
	welcome_drone()

/mob/living/silicon/robot/drone/proc/welcome_drone()
	to_chat(src, "<b>You are a maintenance drone, a tiny-brained robotic repair machine</b>. You have no individual will, no personality, and no drives or urges other than your laws.")
	to_chat(src, "Remember, you are <b>lawed against interference with the crew</b>, you should leave the area if your actions are interfering, or that the crew does not want your presence.")
	to_chat(src, "You are <b>not required to follow orders from anyone; not the AI, not humans, and not other synthetics.</b>. However, you should respond to presence requests issued from drone controls consoles.")
	to_chat(src, "Use <b>say ;Hello</b> to talk to other drones and <b>say Hello</b> to speak silently to your nearby fellows.")

/mob/living/silicon/robot/drone/add_robot_verbs()
	return

/mob/living/silicon/robot/drone/remove_robot_verbs()
	return

/mob/living/silicon/robot/drone/construction/welcome_drone()
	to_chat(src, "<b>You are a construction drone, an autonomous engineering and fabrication system.</b>.")
	to_chat(src, "You are assigned to a construction project. The name is irrelevant. Your task is to complete construction and subsystem integration as soon as possible.")
	to_chat(src, "Use <b>:d</b> to talk to other drones and <b>say</b> to speak silently to your nearby fellows.")
	to_chat(src, "<b>You do not follow orders from anyone; not the AI, not humans, and not other synthetics.</b>.")

/proc/too_many_active_drones()
	var/drones = 0
	for(var/mob/living/silicon/robot/drone/D in global.silicon_mob_list)
		if(D.key && D.client)
			drones++
	return drones >= get_config_value(/decl/config/num/max_maint_drones)

/mob/living/silicon/robot/drone/show_laws(var/everyone = 0)
	if(!controlling_ai)
		return..()
	to_chat(src, "<b>Obey these laws:</b>")
	controlling_ai.laws_sanity_check()
	controlling_ai.laws.show_laws(src)

/mob/living/silicon/robot/drone/robot_checklaws()
	set category = "Silicon Commands"
	set name = "State Laws"

	if(!controlling_ai)
		return ..()
	controlling_ai.open_subsystem(/datum/nano_module/law_manager)

/mob/living/silicon/robot/drone/get_bodytype()
	return GET_DECL(/decl/bodytype/drone)

/decl/bodytype/drone
	name = "drone"
	bodytype_flag = 0
	bodytype_category = "drone body"
	uid = "bodytype_drone"

/decl/bodytype/drone/Initialize()
	if(!length(_equip_adjust))
		_equip_adjust = list(
			(slot_head_str) = list(
				"[NORTH]" = list(0, -13),
				"[SOUTH]" = list(0, -13),
				"[EAST]"  = list(0, -13),
				"[WEST]"  = list(0, -13)
			)
		)
	. = ..()
