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
	var/filter_string

	var/list/stored_material = list()
	var/list/storage_capacity = list()
	var/base_storage_capacity_mult = 20
	var/list/base_storage_capacity = list()

	var/show_category = "All"
	var/fab_status_flags = 0
	var/mat_efficiency = 1.1
	var/build_time_multiplier = 1

	var/list/design_cache = list()
	var/list/installed_designs = list()

	var/sound_id
	var/datum/sound_token/sound_token
	var/fabricator_sound = 'sound/machines/fabricator_loop.ogg'

	var/output_dir

	var/initial_network_id
	var/initial_network_key

	var/species_variation = /decl/species/human // If this fabricator is a variant for a specific species, this will be checked to unlock species-specific designs.

	// If TRUE, fills fabricator with material on initalize
	var/prefilled = FALSE

	//Collapsing Menus stuff
	var/ui_expand_queue     = FALSE
	var/ui_expand_resources = FALSE
	var/ui_expand_config    = FALSE
	var/ui_nb_categories    = 1      //Cached amount of categories in loaded designs. Used to decide if we display the category filter or not

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
			var/decl/material/mat = GET_DECL(thing)
			material_names += "[storage_capacity[thing]] [mat.use_name]"
		to_chat(user, SPAN_NOTICE("It can store [english_list(material_names)]."))
	if(has_recycler)
		to_chat(user, SPAN_NOTICE("It has a built-in shredder that can recycle most items, although any materials it cannot use will be wasted."))

/obj/machinery/fabricator/Initialize()

	panel_image = image(icon, "[base_icon_state]_panel")
	. = ..()
	sound_id = "[fabricator_sound]"

	// Get any local network we need to be part of.
	set_extension(src, /datum/extension/network_device, initial_network_id, initial_network_key, RECEIVER_STRONG_WIRELESS)

	if(SSfabrication.post_recipe_init)
		refresh_design_cache()
	else
		SSfabrication.queue_design_cache_refresh(src)

/obj/machinery/fabricator/modify_mapped_vars(map_hash)
	..()
	ADJUST_TAG_VAR(initial_network_id, map_hash)

/obj/machinery/fabricator/handle_post_network_connection()
	..()
	refresh_design_cache()

/obj/machinery/fabricator/proc/fill_to_capacity()
	for(var/mat in storage_capacity)
		stored_material[mat] = storage_capacity[mat]

/obj/machinery/fabricator/proc/refresh_design_cache(var/list/known_tech)

	var/list/base_designs = SSfabrication.get_initial_recipes(fabricator_class)
	design_cache = islist(base_designs) ? base_designs.Copy() : list() // Don't want to mutate the subsystem cache.

	if(length(installed_designs))
		design_cache |= installed_designs

	if(!known_tech)
		known_tech = get_default_initial_tech_levels()
		var/datum/extension/network_device/device = get_extension(src, /datum/extension/network_device)
		var/datum/computer_network/network = device.get_network()
		if(network)
			for(var/obj/machinery/design_database/db in network.get_devices_by_type(/obj/machinery/design_database))
				for(var/tech in db.tech_levels)
					if(db.tech_levels[tech] > known_tech[tech])
						known_tech[tech] = db.tech_levels[tech]

	var/list/unlocked_tech = SSfabrication.get_unlocked_recipes(fabricator_class, known_tech)
	if(length(unlocked_tech))
		design_cache |= unlocked_tech

	var/list/unique_categories
	var/list/add_mat_to_storage_cap = list()
	for(var/datum/fabricator_recipe/R in design_cache)

		for(var/mat in R.resources)
			add_mat_to_storage_cap |= mat

		LAZYDISTINCTADD(unique_categories, R.category)
		if(!length(R.species_locked))
			continue

		if(isnull(species_variation))
			design_cache.Remove(R)
			continue

		for(var/species_type in R.species_locked)
			if(!(ispath(species_variation, species_type)))
				design_cache.Remove(R)
				continue

	design_cache = sortTim(design_cache, /proc/cmp_name_asc)
	ui_nb_categories = LAZYLEN(unique_categories)

	if(length(add_mat_to_storage_cap))
		var/need_storage_recalc = FALSE
		for(var/mat in add_mat_to_storage_cap)
			if(mat in base_storage_capacity)
				continue
			need_storage_recalc = TRUE
			base_storage_capacity[mat] = (SHEET_MATERIAL_AMOUNT * base_storage_capacity_mult)
			if(!(mat in stored_material))
				stored_material[mat] = 0

		if(need_storage_recalc)
			RefreshParts()

	// We handle this here, as we don't know what materials should be stocked prior to updating our recipes.
	if(prefilled)
		prefilled = FALSE
		fill_to_capacity()

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

/obj/machinery/fabricator/Process(wait, tick)
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
	var/mb_rating = clamp(total_component_rating_of_type(/obj/item/stock_parts/matter_bin), 0, 10)
	var/man_rating = clamp(total_component_rating_of_type(/obj/item/stock_parts/manipulator), 0.5, 3.5)
	for(var/mat in base_storage_capacity)
		storage_capacity[mat] = mb_rating * base_storage_capacity[mat]
		if(!(mat in stored_material))
			stored_material[mat] = 0
	mat_efficiency = initial(mat_efficiency) - man_rating * 0.1
	build_time_multiplier = initial(build_time_multiplier) * man_rating

/obj/machinery/fabricator/dismantle()
	for(var/mat in stored_material)
		if(stored_material[mat] > SHEET_MATERIAL_AMOUNT)
			SSmaterials.create_object(mat, get_turf(src), round(stored_material[mat] / SHEET_MATERIAL_AMOUNT))
	..()
	return TRUE

/obj/machinery/fabricator/proc/get_color_list()
	return pipe_colors //override with null for hex color selections

// Our stored_material is just the right format to be added to the matter list.
/obj/machinery/fabricator/get_contained_matter()
	. = ..()
	. = MERGE_ASSOCS_WITH_NUM_VALUES(., stored_material)