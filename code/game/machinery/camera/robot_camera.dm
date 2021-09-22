/datum/extension/network_device/camera/robot
	expected_type = /mob/living/silicon/robot 

/datum/extension/network_device/camera/robot/is_functional()
	var/mob/living/silicon/robot/R = holder
	if(R.wires.IsIndexCut(BORG_WIRE_CAMERA))
		return FALSE
	if(!R.has_power)
		return FALSE
	if(R.stat == DEAD)
		return FALSE
	if(!R.is_component_functioning("camera"))
		return FALSE
	return TRUE