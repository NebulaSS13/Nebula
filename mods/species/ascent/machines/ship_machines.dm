MANTIDIFY(/obj/machinery/power/apc/hyper, "mantid power node", "power controller")
MANTIDIFY(/obj/machinery/atmospherics/unary/vent_pump/on, "mantid atmosphere outlet", "vent")
MANTIDIFY(/obj/machinery/atmospherics/unary/vent_scrubber/on, "mantid atmosphere intake", "scrubber")
MANTIDIFY(/obj/machinery/hologram/holopad/longrange, "mantid holopad", "holopad")
MANTIDIFY(/obj/machinery/optable, "mantid operating table", "operating table")
MANTIDIFY(/obj/machinery/door/airlock/external/bolted, "mantid airlock", "door")

/obj/machinery/optable/ascent
	construct_state = /decl/machine_construction/default/no_deconstruct
	base_type = /obj/machinery/optable

/obj/machinery/portable_atmospherics/hydroponics/ascent
	name = "mantid algae vat"
	desc = "Some kind of strange alien hydroponics technology."
	icon = 'mods/species/ascent/icons/mantid_hydroponics.dmi'
	closed_system = TRUE
	construct_state = /decl/machine_construction/default/no_deconstruct
	base_type = /obj/machinery/portable_atmospherics/hydroponics

// No maintenance needed.
/obj/machinery/portable_atmospherics/hydroponics/ascent/Process()
	if(dead)
		seed = null
		update_icon()
	if(!seed)
		seed = SSplants.seeds["algae"]
		update_icon()
	waterlevel = 100
	nutrilevel = 10
	pestlevel = 0
	weedlevel = 0
	mutation_level = 0
	plant_health = 100
	sampled = 0
	. = ..()

/obj/machinery/atmospherics/unary/vent_scrubber/on/ascent/Initialize()
	. = ..()
	scrubbing_gas -= /decl/material/gas/methyl_bromide

/obj/machinery/atmospherics/unary/vent_scrubber/on/ascent/shuttle
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/vent_scrubber/shuttle = 1,
		/decl/stock_part_preset/radio/event_transmitter/vent_scrubber/shuttle = 1
	)
/obj/machinery/recharge_station/ascent
	name = "mantid recharging dock"
	desc = "An oddly organic aperture stuffed with power connectors."
	icon = 'mods/species/ascent/icons/mantid_charger.dmi'
	overlay_icon = 'mods/species/ascent/icons/mantid_charger.dmi'
	construct_state = /decl/machine_construction/default/no_deconstruct
	base_type = /obj/machinery/recharge_station

MANTIDIFY(/obj/item/chems/chem_disp_cartridge, "canister", "chemical storage")
/obj/item/chems/chem_disp_cartridge/ascent/crystal/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/crystal_agent, reagents.maximum_volume)

/obj/item/chems/chem_disp_cartridge/ascent/bromide/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/bromide, reagents.maximum_volume)

/obj/machinery/sleeper/ascent
	name = "mantid sleeper"
	desc = "Some kind of strange alien sleeper technology."
	icon = 'mods/species/ascent/icons/ascent_sleepers.dmi'
	base_type = /obj/machinery/sleeper
	construct_state = /decl/machine_construction/default/no_deconstruct

/obj/machinery/sleeper/ascent/Initialize(mapload, d, populate_parts)
	. = ..()
	add_reagent_canister(null, new /obj/item/chems/chem_disp_cartridge/ascent/crystal())
	add_reagent_canister(null, new /obj/item/chems/chem_disp_cartridge/ascent/bromide())

/obj/machinery/fabricator/ascent
	name = "\improper Ascent nanofabricator"
	desc = "A squat, complicated fabrication system clad in purple polymer."
	icon = 'mods/species/ascent/icons/nanofabricator.dmi'
	icon_state = "nanofab"
	base_icon_state = "nanofab"
	req_access = list(access_ascent)
	base_type = /obj/machinery/fabricator
	construct_state = /decl/machine_construction/default/no_deconstruct

/obj/machinery/hologram/holopad/longrange/ascent
	req_access = list(access_ascent)

/obj/effect/catwalk_plated/ascent
	color = COLOR_GRAY40

/obj/machinery/door/airlock/ascent
	desc = "Some kind of strange alien door technology."
	icon =                'mods/species/ascent/icons/doors/base.dmi'
	bolts_file =          'mods/species/ascent/icons/doors/lights_bolts.dmi'
	deny_file =           'mods/species/ascent/icons/doors/lights_deny.dmi'
	lights_file =         'mods/species/ascent/icons/doors/lights_green.dmi'
	panel_file =          'mods/species/ascent/icons/doors/panel.dmi'
	sparks_damaged_file = 'mods/species/ascent/icons/doors/sparks_damaged.dmi'
	sparks_broken_file =  'mods/species/ascent/icons/doors/sparks_broken.dmi'
	welded_file =         'mods/species/ascent/icons/doors/welded.dmi'
	emag_file =           'mods/species/ascent/icons/doors/emag.dmi'

/obj/machinery/door/airlock/ascent/set_airlock_overlays(state)
	return

/obj/machinery/door/airlock/external/bolted/ascent
	door_color = COLOR_PURPLE
	stripe_color = COLOR_GRAY40
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock/shuttle = 1,
		/decl/stock_part_preset/radio/event_transmitter/airlock/shuttle = 1
	)

/obj/machinery/light/ascent
	name = "mantid light"
	light_type = /obj/item/light/tube/ascent
	accepts_light_type = /obj/item/light/tube/ascent
	desc = "Some kind of strange alien lighting technology."

/obj/machinery/computer/ship/helm/ascent
	icon_state = "ascent"
	icon_keyboard = "ascent_key"
	icon_screen = "ascent_screen"
	req_access = list(access_ascent)
	construct_state = /decl/machine_construction/default/panel_closed/computer/no_deconstruct
	base_type = /obj/machinery/computer/ship/helm

/obj/machinery/computer/ship/engines/ascent
	icon_state = "ascent"
	icon_keyboard = "ascent_key"
	icon_screen = "ascent_screen"
	req_access = list(access_ascent)
	construct_state = /decl/machine_construction/default/panel_closed/computer/no_deconstruct
	base_type = /obj/machinery/computer/ship/engines

/obj/machinery/computer/ship/navigation/ascent
	icon_state = "ascent"
	icon_keyboard = "ascent_key"
	icon_screen = "ascent_screen"
	req_access = list(access_ascent)
	construct_state = /decl/machine_construction/default/panel_closed/computer/no_deconstruct
	base_type = /obj/machinery/computer/ship/navigation

/obj/machinery/computer/ship/sensors/ascent
	icon_state = "ascent"
	icon_keyboard = "ascent_key"
	icon_screen = "ascent_screen"
	req_access = list(access_ascent)
	construct_state = /decl/machine_construction/default/panel_closed/computer/no_deconstruct
	base_type = /obj/machinery/computer/ship/sensors

// This is an absolutely stupid machine. Basically the same as the debug one with some alterations.
// It is a placeholder for a proper reactor setup (probably a RUST descendant)
/obj/machinery/power/ascent_reactor
	name = "mantid fusion stack"
	desc = "A tall, gleaming assemblage of advanced alien machinery. It hums and crackles with restrained power."
	icon = 'icons/obj/machines/power/fusion_core.dmi'
	icon_state = "core1"
	color = COLOR_PURPLE
	var/on = TRUE
	var/output_power = 9000 KILOWATTS
	var/image/field_image

/obj/machinery/power/ascent_reactor/attack_hand(mob/user)
	if(!user.check_dexterity(DEXTERITY_COMPLEX_TOOLS, TRUE))
		return ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!(H.species.name in ALL_ASCENT_SPECIES))
			to_chat(H, SPAN_WARNING("You have no idea how to use \the [src]."))
			return TRUE
	else if(!istype(user, /mob/living/silicon/robot/flying/ascent))
		to_chat(user, SPAN_WARNING("You have no idea how to interface with \the [src]."))
		return TRUE
	user.visible_message(SPAN_NOTICE("\The [user] switches \the [src] [on ? "off" : "on"]."))
	on = !on
	update_icon()
	return TRUE

/obj/machinery/power/ascent_reactor/on_update_icon()
	. = ..()

	if(!field_image)
		field_image = image(icon = 'icons/obj/machines/power/fusion.dmi', icon_state = "emfield_s1")
		field_image.color = COLOR_CYAN
		field_image.alpha = 50
		field_image.layer = SINGULARITY_LAYER
		field_image.appearance_flags |= RESET_COLOR

		var/matrix/M = matrix()
		M.Scale(3)
		field_image.transform = M

	if(on)
		overlays |= field_image
		set_light(6, 0.8, COLOR_CYAN)
		icon_state = "core1"
	else
		overlays -= field_image
		set_light(0)
		icon_state = "core0"

/obj/machinery/power/ascent_reactor/Initialize()
	. = ..()
	update_icon()

/obj/machinery/power/ascent_reactor/Process()
	if(on)
		add_avail(output_power)

/obj/machinery/power/smes/buildable/power_shuttle/ascent
	name = "mantid battery"
	desc = "Some kind of strange alien SMES technology."
	icon = 'mods/species/ascent/icons/mantid_smes.dmi'
	overlay_icon = 'mods/species/ascent/icons/mantid_smes.dmi'
	construct_state = /decl/machine_construction/default/no_deconstruct
