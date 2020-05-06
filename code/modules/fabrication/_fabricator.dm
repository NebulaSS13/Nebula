/obj/machinery/fabricator
	name = "autolathe"
	desc = "It produces common day to day items from a variety of materials."
	icon = 'icons/obj/machines/fabricators/autolathe.dmi'
	icon_state = "autolathe"
	density = 1
	anchored = 1
	idle_power_usage = 10
	active_power_usage = 2000
	clicksound = "keyboard"
	clickvol = 30
	uncreated_component_parts = null
	stat_immune = 0
	wires =           /datum/wires/fabricator
	base_type =       /obj/machinery/fabricator
	construct_state = /decl/machine_construction/default/panel_closed

	var/has_recycler = TRUE
	var/color_selectable = FALSE // Allows selecting a color by the user in the UI, to do with as you please.
	var/selected_color = "white"

	var/list/material_overlays = list()
	var/base_icon_state = "autolathe"
	var/image/panel_image

	var/list/queued_orders = list()
	var/datum/fabricator_build_order/currently_building

	var/fabricator_class = FABRICATOR_CLASS_GENERAL

	var/list/stored_material
	var/list/storage_capacity
	var/list/base_storage_capacity = list(
		MAT_STEEL =     SHEET_MATERIAL_AMOUNT * 20,
		MAT_ALUMINIUM = SHEET_MATERIAL_AMOUNT * 20,
		MAT_GLASS =     SHEET_MATERIAL_AMOUNT * 10,
		MAT_PLASTIC =   SHEET_MATERIAL_AMOUNT * 10
	)

	var/initial_id_tag
	var/show_category = "All"
	var/fab_status_flags = 0
	var/mat_efficiency = 1.1
	var/build_time_multiplier = 1
	var/global/list/stored_substances_to_names = list()

	var/list/design_cache
	var/list/installed_designs

	var/sound_id
	var/datum/sound_token/sound_token
	var/fabricator_sound = 'sound/machines/fabricator_loop.ogg'

	var/output_dir

/obj/machinery/fabricator/Destroy()
	QDEL_NULL(currently_building)
	QDEL_NULL_LIST(queued_orders)
	QDEL_NULL(sound_token)
	. = ..()

/obj/machinery/fabricator/examine(mob/user)
	. = ..()
	if(length(storage_capacity))
		var/list/material_names = list()
		for(var/thing in storage_capacity)
			material_names += "[storage_capacity[thing]] [stored_substances_to_names[thing]]"
		to_chat(user, SPAN_NOTICE("It can store [english_list(material_names)]."))
	if(has_recycler)
		to_chat(user, SPAN_NOTICE("It has a built-in shredder that can recycle most items, although any materials it cannot use will be wasted."))

/obj/machinery/fabricator/Initialize()

	panel_image = image(icon, "[base_icon_state]_panel")
	. = ..()
	sound_id = "[fabricator_sound]"

	// Get any local network we need to be part of.
	set_extension(src, /datum/extension/local_network_member)
	if(initial_id_tag)
		var/datum/extension/local_network_member/lanm = get_extension(src, /datum/extension/local_network_member)
		lanm.set_tag(null, initial_id_tag)

	// Initialize material storage lists.
	stored_material = list()
	for(var/mat in base_storage_capacity)
		stored_material[mat] = 0

		// Update global type to string cache.
		if(!stored_substances_to_names[mat])
			if(ispath(mat, /decl/material))
				var/decl/material/mat_instance = decls_repository.get_decl(mat)
				if(istype(mat_instance))
					stored_substances_to_names[mat] =  lowertext(mat_instance.display_name)
			else if(ispath(mat, /decl/material))
				var/decl/material/reg = mat
				stored_substances_to_names[mat] = lowertext(initial(reg.name))

	var/list/base_designs = SSfabrication.get_initial_recipes(fabricator_class)
	design_cache = islist(base_designs) ? base_designs.Copy() : list() // Don't want to mutate the subsystem cache.
	refresh_design_cache()

/obj/machinery/fabricator/proc/refresh_design_cache(var/list/known_tech)
	if(length(installed_designs))
		design_cache |= installed_designs
	if(!known_tech)
		known_tech = list()
		var/datum/extension/local_network_member/lanm = get_extension(src, /datum/extension/local_network_member)
		if(lanm)
			var/datum/local_network/lan = lanm.get_local_network()
			if(lan)
				for(var/obj/machinery/design_database/db in lan.network_entities[/obj/machinery/design_database])
					for(var/tech in db.tech_levels)
						if(db.tech_levels[tech] > known_tech[tech])
							known_tech[tech] = db.tech_levels[tech]
	if(length(known_tech))
		var/list/unlocked_tech = SSfabrication.get_unlocked_recipes(fabricator_class, known_tech)
		if(length(unlocked_tech))
			design_cache |= unlocked_tech

/obj/machinery/fabricator/state_transition(var/decl/machine_construction/default/new_state)
	. = ..()
	if(istype(new_state))
		updateUsrDialog()

/obj/machinery/fabricator/components_are_accessible(path)
	return !(fab_status_flags & FAB_BUSY) && ..()

/obj/machinery/fabricator/cannot_transition_to(state_path)
	if(fab_status_flags & FAB_BUSY)
		return SPAN_NOTICE("You must wait for \the [src] to finish first.")
	return ..()

/obj/machinery/fabricator/proc/is_functioning()
	. = use_power != POWER_USE_OFF && !(stat & NOPOWER) && !(stat & BROKEN) && !(fab_status_flags & FAB_DISABLED)

/obj/machinery/fabricator/Process(var/wait)
	..()
	if(use_power == POWER_USE_ACTIVE && (fab_status_flags & FAB_BUSY))
		update_current_build(wait)

/obj/machinery/fabricator/on_update_icon()
	overlays.Cut()
	if(stat & NOPOWER)
		icon_state = "[base_icon_state]_d"
	else if(currently_building)
		icon_state = "[base_icon_state]_p"
	else
		icon_state = base_icon_state

	var/list/new_overlays = material_overlays.Copy()
	if(panel_open)
		new_overlays += panel_image
	overlays = new_overlays

/obj/machinery/fabricator/proc/remove_mat_overlay(var/mat_overlay)
	material_overlays -= mat_overlay
	update_icon()

//Updates overall lathe storage size.
/obj/machinery/fabricator/RefreshParts()
	..()
	var/mb_rating = Clamp(total_component_rating_of_type(/obj/item/stock_parts/matter_bin), 0, 10)
	var/man_rating = Clamp(total_component_rating_of_type(/obj/item/stock_parts/manipulator), 0.5, 3.5)
	storage_capacity = list()
	for(var/mat in base_storage_capacity)
		storage_capacity[mat] = mb_rating * base_storage_capacity[mat]
	mat_efficiency = initial(mat_efficiency) - man_rating * 0.1
	build_time_multiplier = initial(build_time_multiplier) * man_rating

/obj/machinery/fabricator/dismantle()
	for(var/mat in stored_material)
		if(ispath(mat, /decl/material))
			var/mat_name = stored_substances_to_names[mat]
			var/decl/material/M = decls_repository.get_decl(mat_name)
			if(stored_material[mat] > SHEET_MATERIAL_AMOUNT)
				M.place_sheet(get_turf(src), round(stored_material[mat] / SHEET_MATERIAL_AMOUNT), M.type)
	..()
	return TRUE

/obj/machinery/fabricator/proc/get_color_list()
	return pipe_colors //override with null for hex color selections