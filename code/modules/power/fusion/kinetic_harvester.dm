/obj/machinery/kinetic_harvester
	name = "kinetic harvester"
	desc = "A complicated mechanism for harvesting rapidly moving particles from a fusion toroid and condensing them into a usable form."
	density = TRUE
	anchored = TRUE
	use_power = POWER_USE_IDLE
	icon = 'icons/obj/kinetic_harvester.dmi'
	icon_state = "off"
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0

	var/initial_id_tag
	var/list/stored =     list()
	var/list/harvesting = list()
	var/obj/machinery/fusion_core/harvest_from

/obj/machinery/kinetic_harvester/Initialize()
	set_extension(src, /datum/extension/local_network_member)
	if(initial_id_tag)
		var/datum/extension/local_network_member/lanm = get_extension(src, /datum/extension/local_network_member)
		lanm.set_tag(null, initial_id_tag)
	find_core()
	queue_icon_update()
	. = ..()

/obj/machinery/kinetic_harvester/modify_mapped_vars(map_hash)
	..()
	ADJUST_TAG_VAR(initial_id_tag, map_hash)

/obj/machinery/kinetic_harvester/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/kinetic_harvester/attackby(var/obj/item/thing, var/mob/user)
	if(IS_MULTITOOL(thing))
		var/datum/extension/local_network_member/lanm = get_extension(src, /datum/extension/local_network_member)
		if(lanm.get_new_tag(user))
			find_core()
		return
	return ..()

/obj/machinery/kinetic_harvester/proc/find_core()
	harvest_from = null
	var/datum/extension/local_network_member/lanm = get_extension(src, /datum/extension/local_network_member)
	var/datum/local_network/lan = lanm.get_local_network()

	if(lan)
		var/list/fusion_cores = lan.get_devices(/obj/machinery/fusion_core)
		if(fusion_cores && fusion_cores.len)
			harvest_from = fusion_cores[1]
	return harvest_from

/obj/machinery/kinetic_harvester/ui_interact(var/mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)

	if(!harvest_from && !find_core())
		to_chat(user, SPAN_WARNING("This machine cannot locate a fusion core. Please ensure the machine is correctly configured to share a fusion plant network."))
		return

	var/datum/extension/local_network_member/fusion = get_extension(src, /datum/extension/local_network_member)
	var/datum/local_network/plant = fusion.get_local_network()
	var/list/data = list()

	data["id"] = plant ? plant.id_tag : "unset"
	data["status"] = (use_power >= POWER_USE_ACTIVE)
	data["materials"] = list()
	for(var/mat in stored)
		var/decl/material/material = GET_DECL(mat)
		var/sheets = floor(stored[mat]/(SHEET_MATERIAL_AMOUNT * 1.5))
		data["materials"] += list(list("name" = material.solid_name, "amount" = sheets, "harvest" = harvesting[mat], "mat_ref" = "\ref[material]"))

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "kinetic_harvester.tmpl", name, 400, 600)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/kinetic_harvester/Process()

	if(harvest_from && get_dist(src, harvest_from) > 10)
		harvest_from = null

	if(use_power >= POWER_USE_ACTIVE)
		if(harvest_from && harvest_from.owned_field)
			for(var/mat in harvest_from.owned_field.reactants)
				if(!(mat in stored))
					stored[mat] = 0
			for(var/mat in harvesting)
				if(!harvest_from.owned_field.reactants[mat])
					harvesting -= mat
				else
					var/harvest = min(harvest_from.owned_field.reactants[mat], rand(100,200))
					harvest_from.owned_field.reactants[mat] -= harvest
					if(harvest_from.owned_field.reactants[mat] <= 0)
						harvest_from.owned_field.reactants -= mat
					stored[mat] += harvest
		else
			harvesting.Cut()

/obj/machinery/kinetic_harvester/on_update_icon()
	if(stat & (BROKEN|NOPOWER))
		icon_state = "broken"
	else if(use_power >= POWER_USE_ACTIVE)
		icon_state = "on"
	else
		icon_state = "off"

/obj/machinery/kinetic_harvester/OnTopic(var/mob/user, var/href_list, var/datum/topic_state/state)

	if(href_list["remove_mat"])
		var/decl/material/material = locate(href_list["remove_mat"])
		if(istype(material))
			var/sheet_cost = (SHEET_MATERIAL_AMOUNT * 1.5)
			var/sheets = floor(stored[material.type]/sheet_cost)
			if(sheets > 0)
				material.create_object(loc, sheets)
				stored[material.type] -= (sheets * sheet_cost)
				if(stored[material.type] <= 0)
					stored -= material.type
				return TOPIC_REFRESH

	if(href_list["toggle_power"])
		use_power = (use_power >= POWER_USE_ACTIVE ? POWER_USE_IDLE : POWER_USE_ACTIVE)
		queue_icon_update()
		return TOPIC_REFRESH

	if(href_list["toggle_harvest"])
		var/decl/material/material = locate(href_list["toggle_harvest"])
		if(istype(material))
			if(harvesting[material.type])
				harvesting -= material.type
			else
				harvesting[material.type] = TRUE
				if(!(material.type in stored))
					stored[material.type] = 0
		return TOPIC_REFRESH
