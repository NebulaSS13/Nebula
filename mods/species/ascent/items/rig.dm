// Rigs and gear themselves.
/obj/item/rig/mantid
	name = "alate support exosuit"
	desc = "A powerful support exosuit with integrated power supply, weapon and atmosphere. It's closer to a mech than a rig."
	icon_state = "kexosuit"
	item_state = null
	suit_type = "support exosuit"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = 1.1 * ARMOR_BALLISTIC_RESISTANT,
		laser = 1.1 * ARMOR_LASER_RIFLES,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
	)
	armor_type = /datum/extension/armor/ablative
	armor_degradation_speed = 0.05
	online_slowdown = 0
	offline_slowdown = 1
	equipment_overlay_icon = null
	air_type =   /obj/item/tank/mantid/reactor
	cell_type =  /obj/item/cell/mantid
	chest_type = /obj/item/clothing/suit/space/rig/mantid
	helm_type =  /obj/item/clothing/head/helmet/space/rig/mantid
	boot_type =  /obj/item/clothing/shoes/magboots/rig/mantid
	glove_type = /obj/item/clothing/gloves/rig/mantid
	update_visible_name = TRUE
	icon = 'mods/species/ascent/icons/rig/inventory.dmi'
	sprite_sheets = list(
		BODYTYPE_MANTID_LARGE = 'mods/species/ascent/icons/rig/gyne.dmi',
		BODYTYPE_MANTID_SMALL = 'mods/species/ascent/icons/rig/alate.dmi',
		BODYTYPE_SNAKE =        'mods/species/ascent/icons/rig/serpentid.dmi'
		)
	initial_modules = list(
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/chem_dispenser/mantid,
		/obj/item/rig_module/device/multitool,
		/obj/item/rig_module/device/cable_coil,
		/obj/item/rig_module/device/welder,
		/obj/item/rig_module/device/clustertool,
		/obj/item/rig_module/mounted/plasmacutter,
		/obj/item/rig_module/maneuvering_jets
		)
	req_access = list(access_ascent)
	var/mantid_caste = SPECIES_MANTID_ALATE

// Renamed blade.
/obj/item/rig_module/mounted/energy_blade/mantid
	name = "nanoblade projector"
	desc = "A fusion-powered blade nanofabricator of Ascent design."
	interface_name = "nanoblade projector"
	interface_desc = "A fusion-powered blade nanofabricator of Ascent design."
	icon = 'mods/species/ascent/icons/ascent.dmi'
	icon_state = "blade"
	interface_name = "nanoblade"
	usable = FALSE
	gun = null

/obj/item/rig_module/mounted/flechette_rifle
	name = "flechette rifle"
	desc = "A flechette nanofabricator and launch system of Ascent design."
	interface_name = "flechette rifle"
	interface_desc = "A flechette nanofabricator and launch system of Ascent design."
	icon = 'mods/species/ascent/icons/ascent.dmi'
	icon_state = "rifle"
	gun = /obj/item/gun/magnetic/railgun/flechette/ascent

/obj/item/rig_module/mounted/particle_rifle
	name = "particle rifle"
	desc = "A mounted particle rifle of Ascent design."
	interface_name = "particle rifle"
	interface_desc = "A mounted particle rifle of Ascent design."
	icon = 'mods/species/ascent/icons/ascent.dmi'
	icon_state = "rifle"
	gun = /obj/item/gun/energy/particle

/obj/item/rig_module/device/multitool
	name = "mantid integrated multitool"
	desc = "A limited-sentience integrated multitool capable of interfacing with any number of systems."
	interface_name = "multitool"
	interface_desc = "A limited-sentience integrated multitool capable of interfacing with any number of systems."
	device = /obj/item/multitool/mantid
	icon = 'mods/species/ascent/icons/ascent.dmi'
	icon_state = "multitool"
	usable = FALSE
	selectable = TRUE

/obj/item/rig_module/device/multitool/ismultitool()
	return device && device.ismultitool()

/obj/item/rig_module/device/cable_coil
	name = "mantid cable extruder"
	desc = "A cable nanofabricator of Ascent design."
	interface_name = "cable fabricator"
	interface_desc = "A cable nanofabricator of Ascent design."
	device = /obj/item/stack/cable_coil/fabricator
	icon = 'mods/species/ascent/icons/ascent.dmi'
	icon_state = "cablecoil"
	usable = FALSE
	selectable = TRUE

/obj/item/rig_module/device/welder
	name = "mantid welding arm"
	desc = "An electrical cutting torch of Ascent design."
	interface_name = "welding arm"
	interface_desc = "An electrical cutting torch of Ascent design."
	icon = 'mods/species/ascent/icons/ascent.dmi'
	icon_state = "welder1"
	engage_string = "Toggle Welder"
	device = /obj/item/weldingtool/electric/mantid
	usable = TRUE
	selectable = TRUE

/obj/item/rig_module/device/clustertool
	name = "mantid clustertool"
	desc = "A complex assembly of self-guiding, modular heads capable of performing most manual tasks."
	interface_name = "modular clustertool"
	interface_desc = "A complex assembly of self-guiding, modular heads capable of performing most manual tasks."
	icon = 'mods/species/ascent/icons/ascent.dmi'
	icon_state = "clustertool"
	engage_string = "Select Mode"
	device = /obj/item/clustertool
	usable = TRUE
	selectable = TRUE

/obj/item/rig_module/device/clustertool/iswrench()
	return device && device.iswrench()

/obj/item/rig_module/device/clustertool/iswirecutter()
	return device && device.iswirecutter()

/obj/item/rig_module/device/clustertool/isscrewdriver()
	return device && device.isscrewdriver()

/obj/item/rig_module/device/clustertool/iscrowbar()
	return device && device.iscrowbar()

// Atmosphere/jetpack filler.
/obj/item/tank/mantid
	name = "mantid gas tank"
	icon = 'mods/species/ascent/icons/tank.dmi'
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD
	volume = 180

/obj/item/tank/mantid/methyl_bromide
	starting_pressure = list(/decl/material/gas/methyl_bromide = 6 * ONE_ATMOSPHERE)

/obj/item/tank/mantid/oxygen
	name = "mantid oxygen tank"
	starting_pressure = list(OXYGEN = 6 * ONE_ATMOSPHERE)

// Boilerplate due to hard typechecks in jetpack code. Todo: make it an extension.
/obj/item/tank/jetpack/ascent
	name = "catalytic maneuvering pack"
	desc = "An integrated Ascent gas processing plant and maneuvering pack that continuously synthesises 'breathable' atmosphere and propellant."
	icon = 'mods/species/ascent/icons/clothing/jetpack.dmi'
	var/refill_gas_type = /decl/material/gas/methyl_bromide
	var/gas_regen_amount = 0.03
	var/gas_regen_cap = 30

/obj/item/tank/jetpack/ascent/Initialize()
	starting_pressure = list(refill_gas_type = 6 * ONE_ATMOSPHERE)
	. = ..()

/obj/item/tank/jetpack/ascent/Process()
	..()
	if(air_contents.total_moles < gas_regen_cap)
		air_contents.adjust_gas(refill_gas_type, gas_regen_amount)

/obj/item/tank/mantid/reactor
	name = "mantid gas reactor"
	desc = "A mantid gas processing plant that continuously synthesises 'breathable' atmosphere."
	var/charge_cost = 12
	var/refill_gas_type = /decl/material/gas/methyl_bromide
	var/gas_regen_amount = 0.05
	var/gas_regen_cap = 50

/obj/item/tank/mantid/reactor/Initialize()
	starting_pressure = list(refill_gas_type = 6 * ONE_ATMOSPHERE)
	. = ..()

/obj/item/tank/mantid/reactor/oxygen
	name = "serpentid gas reactor"
	refill_gas_type = /decl/material/gas/oxygen
	distribute_pressure = 31

/obj/item/tank/mantid/reactor/Process()
	..()
	var/obj/item/rig/holder = loc
	if(air_contents.total_moles < gas_regen_cap && istype(holder) && holder.cell && holder.cell.use(charge_cost))
		air_contents.adjust_gas(refill_gas_type, gas_regen_amount)

// Chem dispenser.
/obj/item/rig_module/chem_dispenser/mantid
	name = "mantid chemical injector"
	desc = "A compact chemical dispenser of mantid design."
	interface_name = "mantid chemical injector"
	interface_desc = "A compact chemical dispenser of mantid design."
	icon = 'mods/species/ascent/icons/ascent.dmi'
	icon_state = "injector"
	charges = list(
		list("bromide",             "bromide",             /decl/material/liquid/bromide, 80),
		list("crystallizing agent", "crystallizing agent", /decl/material/liquid/crystal_agent,       80),
		list("antibiotics",         "antibiotics",         /decl/material/liquid/antibiotics,   80),
		list("painkillers",         "painkillers",         /decl/material/liquid/painkillers,   80)
	)

// Rig definitions.
/obj/item/rig/mantid/gyne
	name = "gyne support exosuit"
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_RIFLE,
		laser = ARMOR_LASER_RIFLES,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
	)
	mantid_caste = SPECIES_MANTID_GYNE
	initial_modules = list(
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/chem_dispenser/mantid,
		/obj/item/rig_module/mounted/energy_blade/mantid,
		/obj/item/rig_module/mounted/flechette_rifle,
		/obj/item/rig_module/mounted/particle_rifle,
		/obj/item/rig_module/device/multitool,
		/obj/item/rig_module/device/cable_coil,
		/obj/item/rig_module/device/welder,
		/obj/item/rig_module/device/clustertool,
		/obj/item/rig_module/mounted/plasmacutter,
		/obj/item/rig_module/maneuvering_jets
	)

/obj/item/rig/mantid/serpentid
	name = "serpentid support exosuit"
	mantid_caste = SPECIES_SERPENTID
	air_type =   /obj/item/tank/mantid/reactor/oxygen
	chest_type = /obj/item/clothing/suit/space/rig/mantid/serpentid
	boot_type =  null

/obj/item/clothing/suit/space/rig/mantid/serpentid
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_FEET

/obj/item/rig/mantid/mob_can_equip(var/mob/M, var/slot)
	. = ..()
	if(. && slot == slot_back_str)
		var/mob/living/carbon/human/H = M
		if(!istype(H) || H.species.get_root_species_name(H) != mantid_caste)
			to_chat(H, "<span class='danger'>Your species cannot wear \the [src].</span>")
			. = 0

/obj/item/clothing/head/helmet/space/rig/mantid
	light_color = "#00ffff"
	desc = "More like a torpedo casing than a helmet."
	bodytype_restricted = list(BODYTYPE_MANTID_LARGE, BODYTYPE_MANTID_SMALL)

/obj/item/clothing/suit/space/rig/mantid
	desc = "It's closer to a mech than a suit."
	bodytype_restricted = list(BODYTYPE_MANTID_LARGE, BODYTYPE_MANTID_SMALL)
	allowed = list(
		/obj/item/clustertool,
		/obj/item/gun/energy/particle/small,
		/obj/item/weldingtool/electric/mantid,
		/obj/item/multitool/mantid,
		/obj/item/stack/medical/resin,
		/obj/item/chems/food/drinks/cans/waterbottle/ascent
	)

/obj/item/clothing/shoes/magboots/rig/mantid
	desc = "It's like a highly advanced forklift."
	bodytype_restricted = list(BODYTYPE_MANTID_LARGE, BODYTYPE_MANTID_SMALL)

/obj/item/clothing/gloves/rig/mantid
	desc = "They look like a cross between a can opener and a Swiss army knife the size of a shoebox."
	bodytype_restricted = list(BODYTYPE_MANTID_LARGE, BODYTYPE_MANTID_SMALL)
