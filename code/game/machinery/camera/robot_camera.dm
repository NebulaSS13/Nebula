/datum/extension/network_device/camera/robot
	expected_type = /mob/living/silicon/robot

/datum/extension/network_device/camera/robot/is_functional()
	var/mob/living/silicon/robot/robot = holder
	if(robot.wires.IsIndexCut(BORG_WIRE_CAMERA))
		return FALSE
	if(!robot.has_power)
		return FALSE
	if(robot.stat == DEAD)
		return FALSE
	if(!robot.is_component_functioning("camera"))
		return FALSE
	return TRUE