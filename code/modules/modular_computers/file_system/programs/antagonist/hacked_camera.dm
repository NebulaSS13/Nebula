/datum/computer_file/program/camera_monitor/hacked
	filename = "camcrypt"
	filedesc = "Camera Decryption Tool"
	nanomodule_path = /datum/nano_module/program/camera_monitor/hacked
	program_icon_state = "hostile"
	program_key_state = "security_key"
	program_menu_icon = "zoomin"
	extended_desc = "This very advanced piece of software uses adaptive programming and large database of cipherkeys to bypass most encryptions used on security cameras. Be warned that system administrator may notice this."
	size = 20
	requires_network_feature = 0
	available_on_network = 0

/datum/computer_file/program/camera_monitor/hacked/process_tick()
	..()
	if(program_state != PROGRAM_STATE_ACTIVE) // Background programs won't trigger alarms.
		return

	var/datum/nano_module/program/camera_monitor/hacked/HNM = NM

	// The program is active and connected to one of the station's channels. Has a very small chance to trigger IDS alarm every tick.
	if(HNM && HNM.current_channel && prob((SKILL_MAX - operator_skill) * 0.05))
		var/datum/computer_network/net = computer.get_network()
		if(net.intrusion_detection_enabled)
			computer.add_log("IDS WARNING - Unauthorised access detected to camera channel [HNM.current_channel] by device with NID [computer.get_network_tag()].")
			net.intrusion_detection_alarm = 1

/datum/computer_file/program/camera_monitor/hacked/ui_interact(mob/user)
	operator_skill = user.get_skill_value(SKILL_COMPUTER)
	. = ..() // Actual work done by nanomodule's parent.

/datum/nano_module/program/camera_monitor/hacked
	name = "Hacked Camera Monitoring Program"
	available_to_ai = FALSE
	bypass_access = TRUE