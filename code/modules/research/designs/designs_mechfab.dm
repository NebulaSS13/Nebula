/datum/design/item/mechfab
	build_type = MECHFAB
	category = "Misc"
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/item/mechfab/robot
	category = "Robot"

//if the fabricator is a exosuit fab pass the manufacturer info over to the robot part constructor
/datum/design/item/mechfab/robot/Fabricate(var/newloc, var/fabricator)
	if(istype(fabricator, /obj/machinery/robotics_fabricator))
		var/obj/machinery/robotics_fabricator/mechfab = fabricator
		return new build_path(newloc, mechfab.manufacturer)
	return ..()

/datum/design/item/mechfab/robot/exoskeleton_ground
	name = "Robot frame, standard"
	build_path = /obj/item/robot_parts/robot_suit
	time = 50
	materials = list(MAT_STEEL = 50000)

/datum/design/item/mechfab/robot/exoskeleton_flying
	name = "Robot frame, hover"
	build_path = /obj/item/robot_parts/robot_suit/flyer
	time = 50
	materials = list(MAT_STEEL = 50000)

/datum/design/item/mechfab/robot/torso
	name = "Robot torso"
	build_path = /obj/item/robot_parts/chest
	time = 35
	materials = list(MAT_STEEL = 40000)

/datum/design/item/mechfab/robot/head
	name = "Robot head"
	build_path = /obj/item/robot_parts/head
	time = 35
	materials = list(MAT_STEEL = 25000)

/datum/design/item/mechfab/robot/l_arm
	name = "Robot left arm"
	build_path = /obj/item/robot_parts/l_arm
	time = 20
	materials = list(MAT_STEEL = 18000)

/datum/design/item/mechfab/robot/r_arm
	name = "Robot right arm"
	build_path = /obj/item/robot_parts/r_arm
	time = 20
	materials = list(MAT_STEEL = 18000)

/datum/design/item/mechfab/robot/l_leg
	name = "Robot left leg"
	build_path = /obj/item/robot_parts/l_leg
	time = 20
	materials = list(MAT_STEEL = 15000)

/datum/design/item/mechfab/robot/r_leg
	name = "Robot right leg"
	build_path = /obj/item/robot_parts/r_leg
	time = 20
	materials = list(MAT_STEEL = 15000)

/datum/design/item/mechfab/robot/component
	time = 20
	materials = list(MAT_STEEL = 5000)

/datum/design/item/mechfab/robot/component/binary_communication_device
	name = "Binary communication device"
	build_path = /obj/item/robot_parts/robot_component/binary_communication_device

/datum/design/item/mechfab/robot/component/radio
	name = "Radio"
	build_path = /obj/item/robot_parts/robot_component/radio

/datum/design/item/mechfab/robot/component/actuator
	name = "Actuator"
	build_path = /obj/item/robot_parts/robot_component/actuator

/datum/design/item/mechfab/robot/component/diagnosis_unit
	name = "Diagnosis unit"
	build_path = /obj/item/robot_parts/robot_component/diagnosis_unit

/datum/design/item/mechfab/robot/component/camera
	name = "Camera"
	build_path = /obj/item/robot_parts/robot_component/camera

/datum/design/item/mechfab/robot/component/armour
	name = "Armour plating"
	build_path = /obj/item/robot_parts/robot_component/armour

/datum/design/item/mechfab/robot/component/armour/light
	name = "Light-weight armour plating"
	build_path = /obj/item/robot_parts/robot_component/armour/light
	// Half the armor, half the cost
	time = 10
	materials = list(MAT_STEEL = 2500)

/datum/design/item/mechfab/exosuit
	name = "exosuit frame"
	build_path = /obj/structure/heavy_vehicle_frame
	time = 70
	materials = list(MAT_STEEL = 20000)
	category = "Exosuits"

/datum/design/item/mechfab/exosuit/basic_armour
	name = "basic exosuit armour"
	build_path = /obj/item/robot_parts/robot_component/armour/exosuit
	time = 30
	materials = list(MAT_STEEL = 7500)

/datum/design/item/mechfab/exosuit/radproof_armour
	name = "radiation-proof exosuit armour"
	build_path = /obj/item/robot_parts/robot_component/armour/exosuit/radproof
	time = 50
	req_tech = list(TECH_MATERIAL = 2)
	materials = list(MAT_STEEL = 12500)

/datum/design/item/mechfab/exosuit/em_armour
	name = "EM-shielded exosuit armour"
	build_path = /obj/item/robot_parts/robot_component/armour/exosuit/em
	time = 50
	req_tech = list(TECH_MATERIAL = 2)
	materials = list(MAT_STEEL = 12500, MAT_SILVER = 1000)

/datum/design/item/mechfab/exosuit/combat_armour
	name = "Combat exosuit armour"
	build_path = /obj/item/robot_parts/robot_component/armour/exosuit/combat
	time = 50
	req_tech = list(TECH_MATERIAL = 4)
	materials = list(MAT_STEEL = 20000, MAT_DIAMOND = 5000)

/datum/design/item/mechfab/exosuit/control_module
	name = "exosuit control module"
	build_path = /obj/item/mech_component/control_module
	time = 15
	materials = list(MAT_STEEL = 5000)

/datum/design/item/mechfab/exosuit/combat_head
	name = "combat exosuit sensors"
	time = 30
	materials = list(MAT_STEEL = 10000)
	build_path = /obj/item/mech_component/sensors/combat
	req_tech = list(TECH_COMBAT = 2)

/datum/design/item/mechfab/exosuit/combat_torso
	name = "combat exosuit chassis"
	time = 60
	materials = list(MAT_STEEL = 45000)
	build_path = /obj/item/mech_component/chassis/combat
	req_tech = list(TECH_COMBAT = 2)

/datum/design/item/mechfab/exosuit/combat_arms
	name = "combat exosuit manipulators"
	time = 30
	materials = list(MAT_STEEL = 15000)
	build_path = /obj/item/mech_component/manipulators/combat
	req_tech = list(TECH_COMBAT = 2)

/datum/design/item/mechfab/exosuit/combat_legs
	name = "combat exosuit motivators"
	time = 30
	materials = list(MAT_STEEL = 15000)
	build_path = /obj/item/mech_component/propulsion/combat
	req_tech = list(TECH_COMBAT = 2)

/datum/design/item/mechfab/exosuit/powerloader_head
	name = "power loader sensors"
	build_path = /obj/item/mech_component/sensors/powerloader
	time = 15
	materials = list(MAT_STEEL = 5000)

/datum/design/item/mechfab/exosuit/powerloader_torso
	name = "power loader chassis"
	build_path = /obj/item/mech_component/chassis/powerloader
	time = 50
	materials = list(MAT_STEEL = 20000)

/datum/design/item/mechfab/exosuit/powerloader_arms
	name = "power loader manipulators"
	build_path = /obj/item/mech_component/manipulators/powerloader
	time = 30
	materials = list(MAT_STEEL = 6000)

/datum/design/item/mechfab/exosuit/powerloader_legs
	name = "power loader motivators"
	build_path = /obj/item/mech_component/propulsion/powerloader
	time = 30
	materials = list(MAT_STEEL = 6000)

/datum/design/item/mechfab/exosuit/light_head
	name = "light exosuit sensors"
	time = 20
	materials = list(MAT_STEEL = 8000)
	build_path = /obj/item/mech_component/sensors/light
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/item/mechfab/exosuit/light_torso
	name = "light exosuit chassis"
	time = 40
	materials = list(MAT_STEEL = 30000)
	build_path = /obj/item/mech_component/chassis/light
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/item/mechfab/exosuit/light_arms
	name = "light exosuit manipulators"
	time = 20
	materials = list(MAT_STEEL = 10000)
	build_path = /obj/item/mech_component/manipulators/light
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/item/mechfab/exosuit/light_legs
	name = "light exosuit motivators"
	time = 25
	materials = list(MAT_STEEL = 10000)
	build_path = /obj/item/mech_component/propulsion/light
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/item/mechfab/exosuit/heavy_head
	name = "heavy exosuit sensors"
	time = 35
	materials = list(MAT_STEEL = 16000)
	build_path = /obj/item/mech_component/sensors/heavy
	req_tech = list(TECH_COMBAT = 2)

/datum/design/item/mechfab/exosuit/heavy_torso
	name = "heavy exosuit chassis"
	time = 75
	materials = list(MAT_STEEL = 70000, MAT_URANIUM = 10000)
	build_path = /obj/item/mech_component/chassis/heavy

/datum/design/item/mechfab/exosuit/heavy_arms
	name = "heavy exosuit manipulators"
	time = 35
	materials = list(MAT_STEEL = 20000)
	build_path = /obj/item/mech_component/manipulators/heavy

/datum/design/item/mechfab/exosuit/heavy_legs
	name = "heavy exosuit motivators"
	time = 35
	materials = list(MAT_STEEL = 20000)
	build_path = /obj/item/mech_component/propulsion/heavy

/datum/design/item/mechfab/exosuit/spider
	name = "quadruped motivators"
	time = 20
	materials = list(MAT_STEEL = 12000)
	build_path = /obj/item/mech_component/propulsion/spider
	req_tech = list(TECH_ENGINEERING = 2)

/datum/design/item/mechfab/exosuit/track
	name = "armored treads"
	time = 35
	materials = list(MAT_STEEL = 25000)
	build_path = /obj/item/mech_component/propulsion/tracks
	req_tech = list(TECH_MATERIAL = 4)

/datum/design/item/mechfab/exosuit/sphere_torso
	name = "spherical chassis"
	build_path = /obj/item/mech_component/chassis/pod
	time = 50
	materials = list(MAT_STEEL = 18000)

/datum/design/item/robot_upgrade
	build_type = MECHFAB
	time = 12
	materials = list(MAT_STEEL = 10000)
	category = "Cyborg Upgrade Modules"

/datum/design/item/robot_upgrade/rename
	name = "Rename module"
	desc = "Used to rename a cyborg."
	build_path = /obj/item/borg/upgrade/rename

/datum/design/item/robot_upgrade/reset
	name = "Reset module"
	desc = "Used to reset a cyborg's module. Destroys any other upgrades applied to the robot."
	build_path = /obj/item/borg/upgrade/reset

/datum/design/item/robot_upgrade/floodlight
	name = "Floodlight module"
	desc = "Used to boost cyborg's integrated light intensity."
	build_path = /obj/item/borg/upgrade/floodlight

/datum/design/item/robot_upgrade/restart
	name = "Emergency restart module"
	desc = "Used to force a restart of a disabled-but-repaired robot, bringing it back online."
	materials = list(MAT_STEEL = 60000, MAT_GLASS = 5000)
	build_path = /obj/item/borg/upgrade/restart

/datum/design/item/robot_upgrade/vtec
	name = "VTEC module"
	desc = "Used to kick in a robot's VTEC systems, increasing their speed."
	materials = list(MAT_STEEL = 80000, MAT_GLASS = 6000, MAT_GOLD = 5000)
	build_path = /obj/item/borg/upgrade/vtec

/datum/design/item/robot_upgrade/weaponcooler
	name = "Rapid weapon cooling module"
	desc = "Used to cool a mounted energy gun, increasing the potential current in it and thus its recharge rate."
	materials = list(MAT_STEEL = 80000, MAT_GLASS = 6000, MAT_GOLD = 2000, MAT_DIAMOND = 500)
	build_path = /obj/item/borg/upgrade/weaponcooler

/datum/design/item/robot_upgrade/jetpack
	name = "Jetpack module"
	desc = "A carbon dioxide jetpack suitable for low-gravity mining operations."
	materials = list(MAT_STEEL = 10000, MAT_PHORON = 15000, MAT_URANIUM = 20000)
	build_path = /obj/item/borg/upgrade/jetpack

/datum/design/item/robot_upgrade/rcd
	name = "RCD module"
	desc = "A rapid construction device module for use during construction operations."
	materials = list(MAT_STEEL = 25000, MAT_PHORON = 10000, MAT_GOLD = 1000, MAT_SILVER = 1000)
	build_path = /obj/item/borg/upgrade/rcd

/datum/design/item/robot_upgrade/syndicate
	name = "Illegal upgrade"
	desc = "Allows for the construction of lethal upgrades for cyborgs."
	req_tech = list(TECH_COMBAT = 4, TECH_ESOTERIC = 3)
	materials = list(MAT_STEEL = 10000, MAT_GLASS = 15000, MAT_DIAMOND = 10000)
	build_path = /obj/item/borg/upgrade/syndicate

/datum/design/item/exosuit
	build_type = MECHFAB
	category = "Exosuit Equipment"
	time = 10
	materials = list(MAT_STEEL = 10000)

/datum/design/item/exosuit/AssembleDesignDesc()
	if(!desc)
		desc = "Allows for the construction of \a [item_name] for installation in an exosuit hardpoint."

/datum/design/item/exosuit/hydraulic_clamp
	name = "hydraulic clamp"
	build_path = /obj/item/mech_equipment/clamp

/datum/design/item/exosuit/gravity_catapult
	name = "gravity catapult"
	build_path = /obj/item/mech_equipment/catapult

/datum/design/item/exosuit/drill
	name = "drill"
	build_path = /obj/item/mech_equipment/drill

/datum/design/item/exosuit/taser
	name = "mounted electrolaser"
	req_tech = list(TECH_COMBAT = 1)
	build_path = /obj/item/mech_equipment/mounted_system/taser

/datum/design/item/exosuit/weapon/plasma
	name = "mounted plasma cutter"
	materials = list(MAT_STEEL = 20000)
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 4, TECH_ENGINEERING = 3)
	build_path = /obj/item/mech_equipment/mounted_system/taser/plasma

/datum/design/item/exosuit/weapon/ion
	name = "mounted ion rifle"
	req_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 4)
	build_path = /obj/item/mech_equipment/mounted_system/taser/ion

/datum/design/item/exosuit/weapon/laser
	name = "mounted laser gun"
	req_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 4)
	build_path = /obj/item/mech_equipment/mounted_system/taser/laser

/datum/design/item/exosuit/rcd
	name = "RCD"
	time = 90
	materials = list(MAT_STEEL = 30000, MAT_PHORON = 25000, MAT_SILVER = 15000, MAT_GOLD = 15000)
	req_tech = list(TECH_MATERIAL = 4, TECH_BLUESPACE = 3, TECH_MAGNET = 4, TECH_POWER = 4, TECH_ENGINEERING = 4)
	build_path = /obj/item/mech_equipment/mounted_system/rcd

/datum/design/item/exosuit/floodlight
	name = "floodlight"
	req_tech = list(TECH_ENGINEERING = 1)
	build_path = /obj/item/mech_equipment/light

/datum/design/item/exosuit/sleeper
	name = "mounted sleeper"
	build_path = /obj/item/mech_equipment/sleeper

/datum/design/item/exosuit/extinguisher
	name = "mounted extinguisher"
	build_path = /obj/item/mech_equipment/mounted_system/extinguisher

/datum/design/item/exosuit/mechshields
	name = "energy shield drone"
	time = 90
	materials = list(MAT_STEEL = 20000, MAT_SILVER = 12000, MAT_GOLD = 12000)
	req_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 4, TECH_POWER = 4, TECH_COMBAT = 2)
	build_path = /obj/item/mech_equipment/shields
// End mechs.

/datum/design/item/synthetic_flash
	name = "Synthetic flash"
	req_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 2)
	build_type = MECHFAB
	materials = list(MAT_STEEL = 750, MAT_GLASS = 750)
	build_path = /obj/item/flash/synthetic
	category = "Misc"

//Augments, son
/datum/design/item/mechfab/augment
	category = "Augments"

/datum/design/item/mechfab/augment/armblade
	name = "Armblade"
	build_path = /obj/item/organ/internal/augment/active/simple/armblade
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 750)
	req_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 2, TECH_MATERIAL = 4, TECH_BIO = 3)

/datum/design/item/mechfab/augment/armblade/wolverine
	name = "Cyberclaws"
	build_path = /obj/item/organ/internal/augment/active/simple/wolverine
	materials = list(MAT_STEEL = 6000, MAT_DIAMOND = 250)
	req_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 4, TECH_MATERIAL = 4, TECH_BIO = 3)

/datum/design/item/mechfab/augment/engineering
	name = "Engineering toolset"
	build_path = /obj/item/organ/internal/augment/active/polytool/engineer
	materials = list(MAT_STEEL = 3000, MAT_GLASS = 1000)
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 4, TECH_BIO = 2)

/datum/design/item/mechfab/augment/surgery
	name = "Surgical toolset"
	build_path = /obj/item/organ/internal/augment/active/polytool/surgical
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 2000)
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 4)

/datum/design/item/mechfab/augment/reflex
	name = "Synapse interceptors"
	build_path = /obj/item/organ/internal/augment/boost/reflex
	materials = list(MAT_STEEL = 750, MAT_GLASS = 750, MAT_SILVER = 100)
	req_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 4, TECH_BIO = 4, TECH_MAGNET = 5)

/datum/design/item/mechfab/augment/shooting
	name = "Gunnery booster"
	build_path = /obj/item/organ/internal/augment/boost/shooting
	materials = list(MAT_STEEL = 750, MAT_GLASS = 750, MAT_SILVER = 100)
	req_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 5, TECH_BIO = 4)

/datum/design/item/mechfab/augment/muscle
	name = "Mechanical muscles"
	build_path = /obj/item/organ/internal/augment/boost/muscle
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 1000)
	req_tech = list(TECH_MATERIAL = 3, TECH_BIO = 4)

/datum/design/item/mechfab/augment/armor
	name = "Subdermal armor"
	build_path = /obj/item/organ/internal/augment/armor
	materials = list(MAT_STEEL = 10000, MAT_GLASS = 750)
	req_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 4, TECH_BIO = 4)

/datum/design/item/mechfab/augment/nanounit
	name = "Nanite MCU"
	build_path = /obj/item/organ/internal/augment/active/nanounit
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 1000, MAT_GOLD = 100, MAT_URANIUM = 500)
	req_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 5, TECH_BIO = 5, TECH_ENGINEERING = 5)

/datum/design/item/mechfab/augment/circuit
	name = "Integrated circuit frame"
	build_path = /obj/item/organ/internal/augment/active/simple/circuit
	materials = list(MAT_STEEL = 3000)

/datum/design/item/mechfab/rig/zero
	category = "Hardsuits"
	name = "Null suit control module"
	build_path = /obj/item/rig/zero
	materials = list(MAT_STEEL = 30000, MAT_GLASS = 5000, MAT_SILVER = 1000)
	time = 120