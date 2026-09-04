// Stub definitions for future work and to pass CI.
/datum/inventory_slot/gripper/robot
	abstract_type = /datum/inventory_slot/gripper/robot

/datum/inventory_slot/gripper/robot/can_equip_to_slot(var/mob/user, var/obj/item/prop, var/disable_warning)
	var/mob/living/silicon/robot/robot = user
	if(!istype(robot) || !robot.module || !(prop in robot.module.equipment))
		return FALSE
	return ..()

/datum/inventory_slot/gripper/robot/one
	slot_name = "Primary Hardpoint"
	slot_id   = "slot_robot_one"
	ui_label  = "1"

/datum/inventory_slot/gripper/robot/two
	slot_name = "Secondary Hardpoint"
	slot_id   = "slot_robot_two"
	ui_label  = "2"

/datum/inventory_slot/gripper/robot/three
	slot_name = "Tertiary Hardpoint"
	slot_id   = "slot_robot_three"
	ui_label  = "3"
