/datum/storage/robot_module
	storage_slots = 24
	// No real limits since mobs generally won't be able to freely interact with this storage.
	max_w_class = ITEM_SIZE_GARGANTUAN

/datum/storage/robot_module/can_be_inserted(obj/item/W, mob/user, stop_messages, click_params)
	var/mob/living/silicon/robot/robot = user
	return istype(robot) && (W in robot.module?.equipment)

/obj/item/robot_module/get_stored_inventory()
	. = ..()
	var/mob/living/silicon/robot/robot = loc
	if(LAZYLEN(.) && emag && (!istype(robot) || !robot.emagged))
		LAZYREMOVE(., emag)

/obj/item/robot_module
	name = "robot module"
	icon = 'icons/obj/modules/module_standard.dmi'
	icon_state = ICON_STATE_WORLD
	obj_flags = OBJ_FLAG_CONDUCTIBLE | OBJ_FLAG_NO_STORAGE
	is_spawnable_type = FALSE
	storage = /datum/storage/robot_module

	var/associated_department
	var/hide_on_manifest = 0
	var/list/channels = list()
	var/list/camera_channels = list()
	var/list/languages = list(
		/decl/language/human/common = TRUE,
		/decl/language/legal = TRUE,
		/decl/language/sign = FALSE
	)
	var/list/module_sprites = list()
	var/can_be_pushed = 1
	// Equivalent to shoes with ITEM_FLAG_NOSLIP
	var/has_nonslip_feet  = FALSE
	// Equivalent to shoes with ITEM_FLAG_MAGNETIZED
	var/has_magnetic_feet = FALSE
	var/obj/item/borg/upgrade/jetpack = null
	var/list/subsystems = list()
	var/list/obj/item/borg/upgrade/supported_upgrades = list()

	// Module subsystem category and ID vars.
	var/display_name
	var/module_category = ROBOT_MODULE_TYPE_GROUNDED
	var/crisis_locked =   FALSE
	var/upgrade_locked =  FALSE

	// Bookkeeping
	var/list/original_languages = list()
	var/list/added_channels = list()

	// Gear lists/types.
	var/obj/item/emag
	// Please note that due to how locate() works, equipments that are subtypes of other equipment need to be placed after their closest parent
	var/list/equipment = list()
	var/list/synths = list()
	var/list/skills = list() // Skills that this module grants. Other skills will remain at minimum levels.
	var/list/software = list() // Apps to preinstall on robot's inbiult computer

// Override because storage is created very early.
/obj/item/robot_module/New(loc, material_key, reference_only = FALSE)
	if(reference_only)
		storage = null
	..(loc, material_key)

/obj/item/robot_module/Initialize(ml, material_key, reference_only = FALSE)

	. = ..()

	if(reference_only)
		return

	var/mob/living/silicon/robot/robot = loc
	if(!istype(robot))
		// Clear refs to avoid attempting to qdel a type in module Destroy().
		equipment = null
		synths    = null
		emag      = null
		jetpack   = null
		return INITIALIZE_HINT_QDEL

	robot.module = src

	grant_skills(robot)
	grant_software(robot)
	add_camera_channels(robot)
	add_languages(robot)
	add_subsystems(robot)
	apply_status_flags(robot)

	build_equipment(robot)
	build_emag(robot)
	build_synths(robot)

	finalize_equipment(robot)
	finalize_emag(robot)
	finalize_synths(robot)

	if(robot.client)
		robot.choose_icon(get_sprites_for(robot))

/obj/item/robot_module/proc/build_equipment()
	var/list/created_equipment = list()
	for(var/thing in equipment)
		if(ispath(thing, /obj/item))
			created_equipment |= new thing(src)
		else if(isitem(thing))
			var/obj/item/I = thing
			I.forceMove(src)
			created_equipment |= I
		else
			log_debug("Invalid var type in [type] equipment creation - [thing]")
	equipment = created_equipment

/obj/item/robot_module/proc/finalize_equipment()
	return

/obj/item/robot_module/proc/build_synths()
	var/list/created_synths = list()
	for(var/thing in synths)
		if(ispath(thing, /datum/matter_synth))
			if(!isnull(synths[thing]))
				created_synths += new thing(synths[thing])
			else
				created_synths += new thing
		else if(istype(thing, /datum/matter_synth))
			created_synths |= thing
		else
			log_debug("Invalid var type in [type] synth creation - [thing]")
	synths = created_synths

/obj/item/robot_module/proc/finalize_synths()
	return

/obj/item/robot_module/proc/build_emag()
	if(ispath(emag))
		emag = new emag(src)

/obj/item/robot_module/proc/finalize_emag()
	if(istype(emag))
		emag.canremove = FALSE
	else if(emag)
		log_debug("Invalid var type in [type] emag creation - [emag]")
		emag = null

/obj/item/robot_module/proc/Reset(var/mob/living/silicon/robot/robot)
	remove_camera_channels(robot)
	remove_languages(robot)
	remove_subsystems(robot)
	remove_status_flags(robot)
	reset_skills(robot)
	robot.choose_icon(list("Basic" = initial(robot.icon)))

/obj/item/robot_module/proc/get_sprites_for(var/mob/living/silicon/robot/robot)
	. = module_sprites
	if(robot.ckey)
		for(var/datum/custom_icon/cicon as anything in SScustomitems.custom_icons_by_ckey[robot.ckey])
			if(cicon.category == display_name && lowertext(robot.real_name) == cicon.character_name)
				for(var/state in cicon.ids_to_icons)
					.[state] = cicon.ids_to_icons[state]

/obj/item/robot_module/Destroy()
	for(var/datum/thing in (equipment|synths))
		qdel(thing)
	equipment = null
	synths = null
	QDEL_NULL_LIST(synths)
	if(istype(emag))
		QDEL_NULL(emag)
	if(istype(jetpack))
		QDEL_NULL(jetpack)
	. = ..()
	var/mob/living/silicon/robot/robot = loc
	if(istype(robot) && robot.module == src)
		robot.module = null

/obj/item/robot_module/emp_act(severity)
	if(equipment)
		for(var/obj/O in equipment)
			O.emp_act(severity)
	if(emag)
		emag.emp_act(severity)
	if(synths)
		for(var/datum/matter_synth/S in synths)
			S.emp_act(severity)
	..()

/obj/item/robot_module/proc/respawn_consumable(var/mob/living/silicon/robot/robot, var/rate)
	var/obj/item/flash/F = locate() in equipment
	if(F)
		if(F.broken)
			F.broken = 0
			F.times_used = 0
			F.update_icon()
		else if(F.times_used)
			F.times_used--
	if(!synths || !synths.len)
		return
	for(var/datum/matter_synth/T in synths)
		T.add_charge(T.recharge_rate * rate)

/obj/item/robot_module/proc/add_languages(var/mob/living/silicon/robot/robot)
	// Stores the languages as they were before receiving the module, and whether they could be synthezized.
	for(var/decl/language/language_datum in robot.languages)
		original_languages[language_datum] = (language_datum in robot.speech_synthesizer_langs)

	for(var/language in languages)
		robot.add_language(language, languages[language])

/obj/item/robot_module/proc/remove_languages(var/mob/living/silicon/robot/robot)
	// Clear all added languages, whether or not we originally had them.
	for(var/language in languages)
		robot.remove_language(language)

	// Then add back all the original languages, and the relevant synthezising ability
	for(var/original_language in original_languages)
		var/decl/language/language_datum = original_language
		robot.add_language(language_datum.type, original_languages[original_language])
	original_languages.Cut()

/obj/item/robot_module/proc/add_camera_channels(var/mob/living/silicon/robot/robot)
	var/datum/extension/network_device/camera/robot/D = get_extension(robot, /datum/extension/network_device/camera)
	if(D)
		var/list/robot_channels = D.channels
		if(CAMERA_CHANNEL_ROBOTS in robot_channels)
			for(var/channel in camera_channels)
				if(!(channel in robot_channels))
					D.add_channels(channel)
					added_channels |= channel

/obj/item/robot_module/proc/remove_camera_channels(var/mob/living/silicon/robot/robot)
	var/datum/extension/network_device/camera/robot/D = get_extension(robot, /datum/extension/network_device/camera)
	D.remove_channels(added_channels)
	added_channels.Cut()

/obj/item/robot_module/proc/add_subsystems(var/mob/living/silicon/robot/robot)
	for(var/subsystem_type in subsystems)
		robot.init_subsystem(subsystem_type)

/obj/item/robot_module/proc/remove_subsystems(var/mob/living/silicon/robot/robot)
	for(var/subsystem_type in subsystems)
		robot.remove_subsystem(subsystem_type)

/obj/item/robot_module/proc/apply_status_flags(var/mob/living/silicon/robot/robot)
	if(!can_be_pushed)
		robot.status_flags &= ~CANPUSH

/obj/item/robot_module/proc/remove_status_flags(var/mob/living/silicon/robot/robot)
	if(!can_be_pushed)
		robot.status_flags |= CANPUSH

/obj/item/robot_module/proc/handle_emagged()
	return

/obj/item/robot_module/proc/grant_skills(var/mob/living/silicon/robot/robot)
	reset_skills(robot) // for safety
	var/list/skill_mod = list()
	for(var/skill_type in skills)
		skill_mod[skill_type] = skills[skill_type] - SKILL_MIN // the buff is additive, so normalize accordingly
	robot.buff_skill(skill_mod, buff_type = /datum/skill_buff/robot)

/obj/item/robot_module/proc/reset_skills(var/mob/living/silicon/robot/robot)
	for(var/datum/skill_buff/buff in robot.fetch_buffs_of_type(/datum/skill_buff/robot))
		buff.remove()

/obj/item/robot_module/proc/grant_software(var/mob/living/silicon/robot/robot)
	var/datum/extension/interactive/os/os = get_extension(robot, /datum/extension/interactive/os)
	if(os && os.has_component(PART_HDD))
		var/obj/item/stock_parts/computer/hard_drive/disk = os.get_component(PART_HDD)
		for(var/T in software)
			disk.store_file(new T(disk), OS_PROGRAMS_DIR, TRUE)

/obj/item/robot_module/proc/handle_turf(turf/target, mob/user)
	return
