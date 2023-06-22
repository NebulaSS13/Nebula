/obj/item/robot_module
	name = "robot module"
	icon = 'icons/obj/modules/module_standard.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_NO_CONTAINER
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	is_spawnable_type = FALSE

	var/associated_department
	var/hide_on_manifest = 0
	var/channels = list()
	var/camera_channels = list()
	var/languages = list(
		/decl/language/human/common = TRUE,
		/decl/language/legal = TRUE,
		/decl/language/sign = FALSE
		)
	var/list/module_sprites = list()
	var/can_be_pushed = 1
	var/no_slip = 0
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

/obj/item/robot_module/Initialize()

	. = ..()

	var/mob/living/silicon/robot/R = loc
	if(!istype(R))
		return INITIALIZE_HINT_QDEL

	R.module = src

	grant_skills(R)
	grant_software(R)
	add_camera_channels(R)
	add_languages(R)
	add_subsystems(R)
	apply_status_flags(R)

	build_equipment(R)
	build_emag(R)
	build_synths(R)

	finalize_equipment(R)
	finalize_emag(R)
	finalize_synths(R)

	if(R.client)
		R.choose_icon(get_sprites_for(R))

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
	for(var/obj/item/I in equipment)
		I.canremove = FALSE

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

/obj/item/robot_module/proc/Reset(var/mob/living/silicon/robot/R)
	remove_camera_channels(R)
	remove_languages(R)
	remove_subsystems(R)
	remove_status_flags(R)
	reset_skills(R)
	R.choose_icon(list("Basic" = initial(R.icon)))

/obj/item/robot_module/proc/get_sprites_for(var/mob/living/silicon/robot/R)
	. = module_sprites
	if(R.ckey)
		for(var/datum/custom_icon/cicon as anything in SScustomitems.custom_icons_by_ckey[R.ckey])
			if(cicon.category == display_name && lowertext(R.real_name) == cicon.character_name)
				for(var/state in cicon.ids_to_icons)
					.[state] = cicon.ids_to_icons[state]

/obj/item/robot_module/Destroy()
	QDEL_NULL_LIST(equipment)
	QDEL_NULL_LIST(synths)
	QDEL_NULL(emag)
	QDEL_NULL(jetpack)
	var/mob/living/silicon/robot/R = loc
	if(istype(R) && R.module == src)
		R.module = null
	. = ..()

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

/obj/item/robot_module/proc/respawn_consumable(var/mob/living/silicon/robot/R, var/rate)
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

/obj/item/robot_module/proc/add_languages(var/mob/living/silicon/robot/R)
	// Stores the languages as they were before receiving the module, and whether they could be synthezized.
	for(var/decl/language/language_datum in R.languages)
		original_languages[language_datum] = (language_datum in R.speech_synthesizer_langs)

	for(var/language in languages)
		R.add_language(language, languages[language])

/obj/item/robot_module/proc/remove_languages(var/mob/living/silicon/robot/R)
	// Clear all added languages, whether or not we originally had them.
	for(var/language in languages)
		R.remove_language(language)

	// Then add back all the original languages, and the relevant synthezising ability
	for(var/original_language in original_languages)
		var/decl/language/language_datum = original_language
		R.add_language(language_datum.name, original_languages[original_language])
	original_languages.Cut()

/obj/item/robot_module/proc/add_camera_channels(var/mob/living/silicon/robot/R)
	var/datum/extension/network_device/camera/robot/D = get_extension(R, /datum/extension/network_device/camera)
	if(D)
		var/list/robot_channels = D.channels
		if(CAMERA_CHANNEL_ROBOTS in robot_channels)
			for(var/channel in camera_channels)
				if(!(channel in robot_channels))
					D.add_channels(channel)
					added_channels |= channel

/obj/item/robot_module/proc/remove_camera_channels(var/mob/living/silicon/robot/R)
	var/datum/extension/network_device/camera/robot/D = get_extension(R, /datum/extension/network_device/camera)
	D.remove_channels(added_channels)
	added_channels.Cut()

/obj/item/robot_module/proc/add_subsystems(var/mob/living/silicon/robot/R)
	for(var/subsystem_type in subsystems)
		R.init_subsystem(subsystem_type)

/obj/item/robot_module/proc/remove_subsystems(var/mob/living/silicon/robot/R)
	for(var/subsystem_type in subsystems)
		R.remove_subsystem(subsystem_type)

/obj/item/robot_module/proc/apply_status_flags(var/mob/living/silicon/robot/R)
	if(!can_be_pushed)
		R.status_flags &= ~CANPUSH

/obj/item/robot_module/proc/remove_status_flags(var/mob/living/silicon/robot/R)
	if(!can_be_pushed)
		R.status_flags |= CANPUSH

/obj/item/robot_module/proc/handle_emagged()
	return

/obj/item/robot_module/proc/grant_skills(var/mob/living/silicon/robot/R)
	reset_skills(R) // for safety
	var/list/skill_mod = list()
	for(var/skill_type in skills)
		skill_mod[skill_type] = skills[skill_type] - SKILL_MIN // the buff is additive, so normalize accordingly
	R.buff_skill(skill_mod, buff_type = /datum/skill_buff/robot)

/obj/item/robot_module/proc/reset_skills(var/mob/living/silicon/robot/R)
	for(var/datum/skill_buff/buff in R.fetch_buffs_of_type(/datum/skill_buff/robot))
		buff.remove()

/obj/item/robot_module/proc/grant_software(var/mob/living/silicon/robot/R)
	var/datum/extension/interactive/os/os = get_extension(R, /datum/extension/interactive/os)
	if(os && os.has_component(PART_HDD))
		var/obj/item/stock_parts/computer/hard_drive/disk = os.get_component(PART_HDD)
		for(var/T in software)
			disk.store_file(new T(disk), OS_PROGRAMS_DIR, TRUE)
