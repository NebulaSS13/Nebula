/datum/fabricator_recipe/robotics/robot_component
	category = "Robot Component"
	path = /obj/item/robot_parts/robot_suit

/datum/fabricator_recipe/robotics/robot_component/get_product_name()
	. = ..()
	return "robot part ([.])"

/datum/fabricator_recipe/robotics/robot_component/exoskeleton_flying
	path = /obj/item/robot_parts/robot_suit/flyer

/datum/fabricator_recipe/robotics/robot_component/torso
	path = /obj/item/robot_parts/chest

/datum/fabricator_recipe/robotics/robot_component/head
	path = /obj/item/robot_parts/head

/datum/fabricator_recipe/robotics/robot_component/l_arm
	path = /obj/item/robot_parts/l_arm

/datum/fabricator_recipe/robotics/robot_component/r_arm
	path = /obj/item/robot_parts/r_arm

/datum/fabricator_recipe/robotics/robot_component/l_leg
	path = /obj/item/robot_parts/l_leg

/datum/fabricator_recipe/robotics/robot_component/r_leg
	path = /obj/item/robot_parts/r_leg

/datum/fabricator_recipe/robotics/robot_component/binary_communication_device
	path = /obj/item/robot_parts/robot_component/binary_communication_device

/datum/fabricator_recipe/robotics/robot_component/radio
	path = /obj/item/robot_parts/robot_component/radio

/datum/fabricator_recipe/robotics/robot_component/actuator
	path = /obj/item/robot_parts/robot_component/actuator

/datum/fabricator_recipe/robotics/robot_component/diagnosis_unit
	path = /obj/item/robot_parts/robot_component/diagnosis_unit

/datum/fabricator_recipe/robotics/robot_component/camera
	path = /obj/item/robot_parts/robot_component/camera

/datum/fabricator_recipe/robotics/robot_component/armour
	path = /obj/item/robot_parts/robot_component/armour

/datum/fabricator_recipe/robotics/robot_component/armour/light
	path = /obj/item/robot_parts/robot_component/armour/light

/datum/fabricator_recipe/robotics/robot_upgrade
	category = "Robot Upgrade Modules"
	path = /obj/item/borg/upgrade/rename

/datum/fabricator_recipe/robotics/robot_upgrade/reset
	path = /obj/item/borg/upgrade/reset

/datum/fabricator_recipe/robotics/robot_upgrade/floodlight
	path = /obj/item/borg/upgrade/floodlight

/datum/fabricator_recipe/robotics/robot_upgrade/restart
	path = /obj/item/borg/upgrade/restart

/datum/fabricator_recipe/robotics/robot_upgrade/vtec
	path = /obj/item/borg/upgrade/vtec

/datum/fabricator_recipe/robotics/robot_upgrade/weaponcooler
	path = /obj/item/borg/upgrade/weaponcooler

/datum/fabricator_recipe/robotics/robot_upgrade/jetpack
	path = /obj/item/borg/upgrade/jetpack

/datum/fabricator_recipe/robotics/robot_upgrade/rcd
	path = /obj/item/borg/upgrade/rcd

/datum/fabricator_recipe/robotics/robot_upgrade/syndicate
	path = /obj/item/borg/upgrade/syndicate

/datum/fabricator_recipe/robotics/party
	path = /obj/item/borg/upgrade/uncertified/party
