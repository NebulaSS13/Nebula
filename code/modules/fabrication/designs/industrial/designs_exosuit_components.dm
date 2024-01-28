/datum/fabricator_recipe/industrial/exosuit
	category = "Exosuit Components"
	path = /obj/structure/heavy_vehicle_frame

/datum/fabricator_recipe/industrial/exosuit/basic_armour
	path = /obj/item/robot_parts/robot_component/armour/exosuit

/datum/fabricator_recipe/industrial/exosuit/radproof_armour
	path = /obj/item/robot_parts/robot_component/armour/exosuit/radproof

/datum/fabricator_recipe/industrial/exosuit/em_armour
	path = /obj/item/robot_parts/robot_component/armour/exosuit/em

/datum/fabricator_recipe/industrial/exosuit/combat_armour
	path = /obj/item/robot_parts/robot_component/armour/exosuit/combat

/datum/fabricator_recipe/industrial/exosuit/control_module
	path = /obj/item/mech_component/control_module

/datum/fabricator_recipe/industrial/exosuit/combat_head
	path = /obj/item/mech_component/sensors/combat

/datum/fabricator_recipe/industrial/exosuit/combat_torso
	path = /obj/item/mech_component/chassis/combat

/datum/fabricator_recipe/industrial/exosuit/combat_arms
	path = /obj/item/mech_component/manipulators/combat

/datum/fabricator_recipe/industrial/exosuit/combat_legs
	path = /obj/item/mech_component/propulsion/combat

/datum/fabricator_recipe/industrial/exosuit/powerloader_head
	path = /obj/item/mech_component/sensors/powerloader

/datum/fabricator_recipe/industrial/exosuit/powerloader_torso
	path = /obj/item/mech_component/chassis/powerloader

/datum/fabricator_recipe/industrial/exosuit/powerloader_arms
	path = /obj/item/mech_component/manipulators/powerloader

/datum/fabricator_recipe/industrial/exosuit/powerloader_legs
	path = /obj/item/mech_component/propulsion/powerloader

/datum/fabricator_recipe/industrial/exosuit/light_head
	path = /obj/item/mech_component/sensors/light

/datum/fabricator_recipe/industrial/exosuit/light_torso
	path = /obj/item/mech_component/chassis/light

/datum/fabricator_recipe/industrial/exosuit/light_arms
	path = /obj/item/mech_component/manipulators/light

/datum/fabricator_recipe/industrial/exosuit/light_legs
	path = /obj/item/mech_component/propulsion/light

/datum/fabricator_recipe/industrial/exosuit/heavy_head
	path = /obj/item/mech_component/sensors/heavy

/datum/fabricator_recipe/industrial/exosuit/heavy_torso
	path = /obj/item/mech_component/chassis/heavy

/datum/fabricator_recipe/industrial/exosuit/heavy_arms
	path = /obj/item/mech_component/manipulators/heavy

/datum/fabricator_recipe/industrial/exosuit/heavy_legs
	path = /obj/item/mech_component/propulsion/heavy

/datum/fabricator_recipe/industrial/exosuit/spider
	path = /obj/item/mech_component/propulsion/spider

/datum/fabricator_recipe/industrial/exosuit/track
	path = /obj/item/mech_component/propulsion/tracks

/datum/fabricator_recipe/industrial/exosuit/sphere_torso
	path = /obj/item/mech_component/chassis/pod

/datum/fabricator_recipe/industrial/exosuit_gear
	category = "Exosuit Equipment"
	path = /obj/item/mech_equipment/clamp

/datum/fabricator_recipe/industrial/exosuit_gear/flash
	path = /obj/item/mech_equipment/flash

/datum/fabricator_recipe/industrial/exosuit_gear/gravity_catapult
	path = /obj/item/mech_equipment/catapult

/datum/fabricator_recipe/industrial/exosuit_gear/ionjets
	path = /obj/item/mech_equipment/ionjets

/datum/fabricator_recipe/industrial/exosuit_gear/camera
	path = /obj/item/mech_equipment/camera

/datum/fabricator_recipe/industrial/exosuit_gear/shields
	path = /obj/item/mech_equipment/shields

/datum/fabricator_recipe/industrial/exosuit_gear/ballistic_shield
	path = /obj/item/mech_equipment/ballistic_shield

/datum/fabricator_recipe/industrial/exosuit_gear/atmos_shields
	path = /obj/item/mech_equipment/atmos_shields

/datum/fabricator_recipe/industrial/exosuit_gear/drill
	path = /obj/item/mech_equipment/drill

/datum/fabricator_recipe/industrial/exosuit_gear/mounted
	path = /obj/item/mech_equipment/mounted_system/taser

// Add the resources from whatever is mounted on the system
/datum/fabricator_recipe/industrial/exosuit_gear/mounted/get_resources()
	. = ..()
	if(!ispath(path, /obj/item/mech_equipment/mounted_system))
		return
	var/obj/item/mech_equipment/mounted_system/system = path
	var/mounted_type = initial(system.holding)
	if(!mounted_type)
		return
	var/list/mounted_cost = atom_info_repository.get_matter_for(mounted_type)
	for(var/mat in mounted_cost)
		resources[mat] += mounted_cost[mat] * FABRICATOR_EXTRA_COST_FACTOR

/datum/fabricator_recipe/industrial/exosuit_gear/mounted/machete
	path = /obj/item/mech_equipment/mounted_system/melee/machete

/datum/fabricator_recipe/industrial/exosuit_gear/mounted/plasma
	path = /obj/item/mech_equipment/mounted_system/taser/plasma

/datum/fabricator_recipe/industrial/exosuit_gear/mounted/ion
	path = /obj/item/mech_equipment/mounted_system/taser/ion

/datum/fabricator_recipe/industrial/exosuit_gear/mounted/laser
	path = /obj/item/mech_equipment/mounted_system/taser/laser

/datum/fabricator_recipe/industrial/exosuit_gear/mounted/autoplasma
	path = /obj/item/mech_equipment/mounted_system/taser/autoplasma

/datum/fabricator_recipe/industrial/exosuit_gear/mounted/smg
	path = /obj/item/mech_equipment/mounted_system/projectile

/datum/fabricator_recipe/industrial/exosuit_gear/mounted/rifle
	path = /obj/item/mech_equipment/mounted_system/projectile/assault_rifle

/datum/fabricator_recipe/industrial/exosuit_gear/mounted/rcd
	path = /obj/item/mech_equipment/mounted_system/rcd

/datum/fabricator_recipe/industrial/exosuit_gear/mounted/floodlight
	path = /obj/item/mech_equipment/light

/datum/fabricator_recipe/industrial/exosuit_gear/mounted/sleeper
	path = /obj/item/mech_equipment/sleeper

/datum/fabricator_recipe/industrial/exosuit_gear/mounted/extinguisher
	path = /obj/item/mech_equipment/mounted_system/extinguisher

/datum/fabricator_recipe/industrial/exosuit_ammo
	category = "Exosuit Ammunition"
	path = /obj/item/ammo_magazine/mech/smg_top

/datum/fabricator_recipe/industrial/exosuit_ammo
	path = /obj/item/ammo_magazine/mech/rifle