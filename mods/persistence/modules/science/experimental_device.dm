/obj/item/experiment
	name = "experimental device"
	icon = 'icons/obj/assemblies/electronic_setups.dmi'
	material = MAT_STEEL
	var/max_components = 3
	var/list/components = list()
	var/wired = FALSE
	var/welded = FALSE
	var/datum/computer_file/code_fragment
	var/cables_required = 5
	var/assembly_icon
	var/experiment_id

	var/list/assembly_icons = list(
		"small" 		= list("setup_small-open", "setup_small"),
		"calc" 			= list("setup_small_calc-open", "setup_small_calc"),
		"clam" 			= list("setup_small_clam-open", "setup_small_clam"),
		"simple" 		= list("setup_small_simple-open", "setup_small_simple"),
		"hook" 			= list("setup_small_hook-open", "setup_small_hook"),
		"pda" 			= list("setup_small_pda-open", "setup_small_pda"),
		"medium" 		= list("setup_medium-open", "setup_medium"),
		"box" 			= list("setup_medium_box-open", "setup_medium_box"),
		"radio" 		= list("setup_medium_radio-open", "setup_medium_radio"),
		"large" 		= list("setup_large-open", "setup_large"),
		"scope" 		= list("setup_large_scope-open", "setup_large_scope"),
		"industrial" 	= list("setup_large_industrial-open", "setup_large_industrial"),
		"stationary" 	= list("setup_stationary-open", "setup_stationary")
	)

/obj/item/experiment/Initialize()
	. = ..()
	if(!assembly_icon)
		assembly_icon = pick(assembly_icons)
	if(name == initial(name) && !experiment_id)
		name = "experimental invention ([replacetext(uniqueness_repository.Generate(/datum/uniqueness_generator/phrase), " ", "_")])"
	update_icon()

/obj/item/experiment/on_update_icon()
	. = ..()
	if(!assembly_icon)
		return
	if(welded && wired)
		icon_state = assembly_icons[assembly_icon][2]
	else
		icon_state = assembly_icons[assembly_icon][1]

/obj/item/experiment/attackby(var/obj/item/W, var/mob/user)
	if(isWirecutter(W) && wired && !welded)
		user.visible_message(SPAN_WARNING("\The [user] dismantles the wiring from [src]."), \
							"You begin to cut the cables...")
		playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)
		if(do_after(user, 50, src))
			new /obj/item/stack/cable_coil(src, cables_required)
			wired = FALSE
			update_icon()
			to_chat(user, SPAN_NOTICE("You cut the cables and dismantle [src]."))

	// Wiring construction stage.
	if(!welded && !wired && max_components == length(components) && istype(W, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/C = W
		if(!C.can_use(cables_required))
			to_chat(user, SPAN_WARNING("You need [cables_required] lengths of cable for [src]."))
			return TRUE
		user.visible_message(SPAN_WARNING("\The [user] adds cables to [src]."), \
					"You start adding cables to [src]...")
		playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)
		if(do_after(user, 20, src))
			if(C.can_use(cables_required))
				C.use(cables_required)
				user.visible_message(\
					SPAN_WARNING("\The [user] has added cables to the [src]!"),\
					"You add cables to [src].")
				wired = TRUE
				update_icon()
				return TRUE

	// Welding construction stage.
	if(wired && max_components == length(components) && isWelder(W))
		var/obj/item/weldingtool/WT = W
		if(!WT.isOn())
			to_chat(user, "\The [W] is off.")
			return TRUE

		if(!welded)
			to_chat(user, "You begin welding [src] together...")
			if(WT.remove_fuel(25) && do_after(usr, 7))
				to_chat(user, "You finish [src].")
				welded = TRUE
				update_icon()
			return TRUE
		else
			to_chat(user, "You begin disassembling [src]...")
			if(WT.remove_fuel(25) && do_after(usr, 7))
				to_chat(user, "You disassemble [src].")
				welded = FALSE
				update_icon()
			return TRUE


	if(welded || wired)
		to_chat(user, SPAN_WARNING("[src] cannot be modified after wiring or welding."))
		return TRUE

	if(isScrewdriver(W))
		if(!length(components))
			to_chat(user, "[src] doesn't have any components installed.")
			return TRUE
		var/list/component_names = list()
		for(var/obj/item/H in components)
			component_names.Add(H.name)
		var/choice = input(usr, "Which component do you want to uninstall?", "Experiment tinkering", null) as null|anything in component_names
		if(!choice)
			return
		if(!Adjacent(user))
			return
		for(var/obj/item/H in components)
			if(H.name == choice)
				components -= H
				user.put_in_hands(H)
				to_chat(user, "You remove \the [H] from [src].")
				break
		return TRUE

	if(length(components) >= max_components)
		to_chat(user, SPAN_WARNING("Nothing more can fit in [src]."))
		return TRUE

	if(!W.origin_tech)
		to_chat(user, SPAN_WARNING("Nothing can be learned from \the [W]."))
		return TRUE

	var/list/techlvls = json_decode(W.origin_tech)
	if(!length(techlvls) || W.holographic)
		to_chat(user, SPAN_WARNING("You cannot experiment with this item."))
		return TRUE

	if(user.unEquip(W, src))
		to_chat(user, SPAN_NOTICE("You add \the [W] to [src]."))
		components += W
		return TRUE

	. = ..()

/obj/item/experiment/proc/get_tech_levels()
	var/list/tech_levels = list()
	for(var/obj/item/H in src)
		if(!H.origin_tech)
			continue
		var/list/item_levels = json_decode(H.origin_tech)
		for(var/item_level in item_levels)
			if(item_level in tech_levels)
				tech_levels[item_level] += item_levels[item_level]
			else
				tech_levels[item_level] = item_levels[item_level]
	return tech_levels



/datum/fabricator_recipe/experimental_device
	name = "experimental device"
	path = /obj/item/experiment
	disabled = TRUE
	var/experiment_id
	var/experiment_name

/datum/fabricator_recipe/experimental_device/New(var/_id, var/_name)
	experiment_id = _id
	experiment_name = _name

/datum/fabricator_recipe/experimental_device/build(var/turf/location, var/amount = 1)
	var/obj/item/experiment/experiment = ..()
	if(experiment_id)
		experiment.experiment_id = experiment_id
	if(experiment_name)
		experiment.name = "experimental device ([experiment_name])"
	return experiment
