/obj/machinery/computer/robotics
	name = "robotics control console"
	desc = "Used to remotely lockdown or monitor linked synthetics."
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "mining_key"
	icon_screen = "robot"
	light_color = "#a97faa"
	initial_access = list(access_robotics)

/obj/machinery/computer/robotics/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/computer/robotics/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]
	data["robots"] = get_cyborgs(user)
	data["is_ai"] = issilicon(user)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "robot_control.tmpl", "Robotic Control Console", 400, 500)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/robotics/CanUseTopic(user)
	if(!allowed(user))
		to_chat(user, "<span class='warning'>Access Denied</span>")
		return STATUS_CLOSE
	return ..()

/obj/machinery/computer/robotics/OnTopic(var/mob/user, href_list)
	// Locks or unlocks the cyborg
	if (href_list["lockdown"])
		var/mob/living/silicon/robot/target = get_cyborg_by_name(href_list["lockdown"])
		if(!target || !istype(target))
			return TOPIC_HANDLED

		if(isAI(user) && (target.connected_ai != user))
			to_chat(user, "<span class='warning'>Access Denied. This robot is not linked to you.</span>")
			return TOPIC_HANDLED

		if(isrobot(user))
			to_chat(user, "<span class='warning'>Access Denied.</span>")
			return TOPIC_HANDLED

		var/choice = input("Really [target.lockcharge ? "unlock" : "lockdown"] [target.name] ?") in list ("Yes", "No")
		if(choice != "Yes")
			return TOPIC_HANDLED

		if(!target || !istype(target))
			return TOPIC_HANDLED

		if(target.SetLockdown(!target.lockcharge))
			log_and_message_admins("[target.lockcharge ? "locked down" : "released"] [target.name]!")
			if(target.lockcharge)
				to_chat(target, "<span class='danger'>You have been locked down!</span>")
			else
				to_chat(target, "<span class='notice'>Your lockdown has been lifted!</span>")
		else
			to_chat(user, "<span class='warning'>ERROR: Lockdown attempt failed.</span>")
		. = TOPIC_REFRESH

	// Remotely hacks the cyborg. Only antag AIs can do this and only to linked cyborgs.
	else if (href_list["hack"])
		var/mob/living/silicon/robot/target = get_cyborg_by_name(href_list["hack"])
		if(!target || !istype(target))
			return TOPIC_HANDLED

		// Antag AI checks
		if(!isAI(user) || !player_is_antag(user.mind))
			to_chat(user, "<span class='warning'>Access Denied</span>")
			return TOPIC_HANDLED

		if(target.emagged)
			to_chat(user, "Robot is already hacked.")
			return TOPIC_HANDLED

		var/choice = input("Really hack [target.name]? This cannot be undone.") in list("Yes", "No")
		if(choice != "Yes")
			return TOPIC_HANDLED

		if(!target || !istype(target))
			return TOPIC_HANDLED

		log_and_message_admins("emagged [target.name] using robotic console!")
		target.emagged = 1
		to_chat(target, "<span class='notice'>Failsafe protocols overriden. New tools available.</span>")
		. = TOPIC_REFRESH

	else if (href_list["message"])
		var/mob/living/silicon/robot/target = get_cyborg_by_name(href_list["message"])
		if(!target || !istype(target))
			return

		var/message = sanitize(input("Enter message to transmit to the synthetic.") as null|text)
		if(!message || !istype(target))
			return

		log_and_message_admins("sent message '[message]' to [target.name] using robotics control console!")
		to_chat(target, "<span class='notice'>New remote message received using R-SSH protocol:</span>")
		to_chat(target, message)
		. = TOPIC_REFRESH

// Proc: get_cyborgs()
// Parameters: 1 (user - mob which is operating the console.)
// Description: Returns NanoUI-friendly list of accessible cyborgs.
/obj/machinery/computer/robotics/proc/get_cyborgs(var/mob/user)
	var/list/robots = list()

	for(var/mob/living/silicon/robot/robot in global.silicon_mob_list)
		// Ignore drones
		if(isdrone(robot))
			continue
		// Ignore antagonistic cyborgs
		if(robot.scrambledcodes)
			continue

		var/list/robot_data = list()
		robot_data["name"] = robot.name
		var/turf/T = get_turf(robot)
		var/area/A = get_area(T)

		if(istype(T) && istype(A) && isContactLevel(T.z))
			robot_data["location"] = "[A.proper_name] ([T.x], [T.y])"
		else
			robot_data["location"] = "Unknown"

		if(robot.stat)
			robot_data["status"] = "Not Responding"
		else if (robot.lockcharge)
			robot_data["status"] = "Lockdown"
		else
			robot_data["status"] = "Operational"

		if(robot.cell)
			robot_data["cell"] = 1
			robot_data["cell_capacity"] = robot.cell.maxcharge
			robot_data["cell_current"] = robot.cell.charge
			robot_data["cell_percentage"] = round(robot.cell.percent())
		else
			robot_data["cell"] = 0

		robot_data["module"] = robot.module ? robot.module.name : "None"
		robot_data["master_ai"] = robot.connected_ai ? robot.connected_ai.name : "None"
		robot_data["hackable"] = 0
		// Antag AIs know whether linked cyborgs are hacked or not.
		if(user && isAI(user) && (robot.connected_ai == user) && player_is_antag(user.mind))
			robot_data["hacked"] = robot.emagged ? 1 : 0
			robot_data["hackable"] = robot.emagged? 0 : 1
		robots.Add(list(robot_data))
	return robots

// Proc: get_cyborg_by_name()
// Parameters: 1 (name - Cyborg we are trying to find)
// Description: Helper proc for finding cyborg by name
/obj/machinery/computer/robotics/proc/get_cyborg_by_name(var/name)
	if (!name)
		return
	for(var/mob/living/silicon/robot/robot in global.silicon_mob_list)
		if(robot.name == name)
			return robot
