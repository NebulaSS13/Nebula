/obj/item/modular_computer/get_contained_external_atoms()
	. = ..()
	var/datum/extension/assembly/assembly = get_extension(src, /datum/extension/assembly)
	if(assembly)
		LAZYREMOVE(., assembly.parts)

/obj/item/modular_computer/get_contained_matter(include_reagents = TRUE)
	. = ..()
	var/datum/extension/assembly/assembly = get_extension(src, /datum/extension/assembly)
	for(var/obj/part in assembly?.parts)
		. = MERGE_ASSOCS_WITH_NUM_VALUES(., part.get_contained_matter(include_reagents))

/obj/item/modular_computer/Process()
	var/datum/extension/assembly/assembly = get_extension(src, /datum/extension/assembly)
	if(assembly)
		assembly.Process()
		if(!assembly.enabled)
			return

	var/datum/extension/interactive/os/os = get_extension(src, /datum/extension/interactive/os)
	if(os)
		os.Process()

	var/static/list/beepsounds = list('sound/effects/compbeep1.ogg','sound/effects/compbeep2.ogg','sound/effects/compbeep3.ogg','sound/effects/compbeep4.ogg','sound/effects/compbeep5.ogg')
	if(assembly.enabled && world.time > ambience_last_played + 60 SECONDS && prob(1))
		ambience_last_played = world.time
		playsound(src.loc, pick(beepsounds),15,1,10, is_ambiance = 1)

/obj/item/modular_computer/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/datum/extension/interactive/os/os = get_extension(src, /datum/extension/interactive/os)
	if(os)
		os.ui_interact(user)

// Used to perform preset-specific hardware changes.
/obj/item/modular_computer/proc/install_default_hardware()
	var/datum/extension/assembly/assembly = get_extension(src, /datum/extension/assembly)
	for(var/T in default_hardware)
		assembly.try_install_component(null, new T(src))

// Used to install preset-specific programs
/obj/item/modular_computer/proc/install_default_programs()
	var/mob/living/human/H = get_recursive_loc_of_type(/mob)
	var/list/job_programs = list()
	if(H)
		var/datum/job/jb = SSjobs.get_by_title(H.job)
		if(istype(jb))
			job_programs = jb.software_on_spawn
	var/datum/extension/assembly/modular_computer/assembly = get_extension(src, /datum/extension/assembly)
	var/obj/item/stock_parts/computer/hard_drive/HDD = assembly.get_component(PART_HDD)
	if(!HDD)
		return
	for(var/prog_type in (job_programs + default_programs))
		var/datum/computer_file/program/prog_file = prog_type
		if(initial(prog_file.usage_flags) & assembly.hardware_flag)
			prog_file = new prog_file
			HDD.store_file(prog_file, OS_PROGRAMS_DIR, TRUE)

/obj/item/modular_computer/Initialize()
	START_PROCESSING(SSobj, src)
	set_extension(src, /datum/extension/interactive/os/device)
	set_extension(src, computer_type)
	if(stores_pen && ispath(stored_pen))
		stored_pen = new stored_pen(src)
	update_icon()
	update_verbs()
	update_name()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/item/modular_computer/LateInitialize()
	. = ..()
	install_default_hardware()
	install_default_programs()
	var/datum/extension/assembly/modular_computer/assembly = get_extension(src, /datum/extension/assembly)
	if(istype(assembly) && assembly.enabled_by_default)
		enable_computer()

/obj/item/modular_computer/Destroy()
	shutdown_computer(loud = FALSE)
	STOP_PROCESSING(SSobj, src)
	if(istype(stored_pen))
		QDEL_NULL(stored_pen)
	return ..()

/obj/item/modular_computer/emag_act(var/remaining_charges, var/mob/user)
	if(computer_emagged)
		to_chat(user, "\The [src] was already emagged.")
		return NO_EMAG_ACT
	else
		computer_emagged = 1
		to_chat(user, "You emag \the [src]. It's screen briefly shows a \"OVERRIDE ACCEPTED: New software downloads available.\" message.")
		return 1

/obj/item/modular_computer/on_update_icon()
	. = ..()
	for(var/decal_state in decals)
		var/image/I = image(icon, "[icon_state]-[decal_state]")
		I.color = decals[decal_state]
		I.appearance_flags |= RESET_COLOR
		add_overlay(I)
	var/datum/extension/interactive/os/os = get_extension(src, /datum/extension/interactive/os)
	var/image/screen_overlay = os?.get_screen_overlay()
	if(screen_overlay)
		add_overlay(screen_overlay)
	else if(dark_screen_state)
		add_overlay(dark_screen_state)
	var/image/keyboard_overlay = os?.get_keyboard_overlay()
	if(keyboard_overlay)
		add_overlay(keyboard_overlay)
	update_lighting()

/obj/item/modular_computer/proc/update_lighting()
	var/datum/extension/interactive/os/os = get_extension(src, /datum/extension/interactive/os)
	var/datum/extension/assembly/modular_computer/assembly = get_extension(src, /datum/extension/assembly)
	if(assembly && assembly.enabled)
		set_light(light_strength, l_color = (assembly.bsod || os?.updating) ? "#0000ff" : light_color)
	else
		set_light(0)

/obj/item/modular_computer/proc/shutdown_computer(var/loud = 1)
	QDEL_NULL_LIST(terminals)
	var/datum/extension/assembly/assembly = get_extension(src, /datum/extension/assembly)
	assembly.shutdown_device()

	if(loud)
		visible_message("\The [src] shuts down.", range = 1)

/obj/item/modular_computer/proc/enable_computer(var/mob/user = null)
	var/datum/extension/assembly/assembly = get_extension(src, /datum/extension/assembly)
	assembly.turn_on(user)

	if(assembly.enabled)
		update_icon()
		if(user)
			ui_interact(user)

/obj/item/modular_computer/GetIdCards(list/exceptions)
	. = ..()
	var/datum/extension/assembly/assembly = get_extension(src, /datum/extension/assembly)
	var/obj/item/stock_parts/computer/card_slot/card_slot = assembly.get_component(PART_CARD)
	if(card_slot && card_slot.can_broadcast && istype(card_slot.stored_card) && card_slot.check_functionality() && !is_type_in_list(card_slot.stored_card, exceptions))
		LAZYDISTINCTADD(., card_slot.stored_card)

/obj/item/modular_computer/GetChargeStick()
	var/datum/extension/assembly/assembly = get_extension(src, /datum/extension/assembly)
	var/obj/item/stock_parts/computer/charge_stick_slot/mstick_slot = assembly.get_component(PART_MSTICK)
	if(mstick_slot && mstick_slot.can_broadcast && istype(mstick_slot.stored_stick) && mstick_slot.check_functionality())
		return mstick_slot.stored_stick

/obj/item/modular_computer/update_name()
	return

/obj/item/modular_computer/get_cell()
	var/datum/extension/assembly/assembly = get_extension(src, /datum/extension/assembly)
	var/obj/item/stock_parts/computer/battery_module/battery_module = assembly.get_component(PART_CARD)
	if(battery_module)
		return battery_module.get_cell()

/obj/item/modular_computer/explosion_act(var/severity)
	var/datum/extension/assembly/assembly = get_extension(src, /datum/extension/assembly)
	assembly.ex_act(severity)
	if(!QDELETED(src))
		. = ..()

/obj/item/modular_computer/emp_act(var/severity)
	var/datum/extension/assembly/assembly = get_extension(src, /datum/extension/assembly)
	assembly.emp_act(severity)

/obj/item/modular_computer/bullet_act(var/proj)
	var/datum/extension/assembly/assembly = get_extension(src, /datum/extension/assembly)
	assembly.bullet_act(proj)
