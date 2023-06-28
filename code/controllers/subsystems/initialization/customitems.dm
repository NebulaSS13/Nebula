SUBSYSTEM_DEF(customitems)
	name = "Custom Items"
	flags = SS_NO_FIRE
	init_order = SS_INIT_MISC_LATE
	var/list/custom_items_by_ckey = list()
	var/list/custom_icons_by_ckey = list()

/datum/controller/subsystem/customitems/proc/get_json_paths_from_directory(var/category, var/directory)
	if(!fexists(directory))
		report_progress("[capitalize(category)] directory [directory] does not exist, no [category] config will be loaded.")
		return
	var/list/loaded_manifest = load_text_from_directory(directory, ".json")
	if(!islist(loaded_manifest) || !length(loaded_manifest["files"]))
		report_progress("[capitalize(category)] directory returned no files on load.")
		return
	var/dir_count  = loaded_manifest["dir_count"]  || 0
	var/item_count = loaded_manifest["item_count"] || 0
	report_progress("Loaded [item_count] [category]\s from [dir_count] director[dir_count == 1 ? "y" : "ies"].")
	return loaded_manifest["files"]

/datum/controller/subsystem/customitems/Initialize()

	var/list/json_to_load = get_json_paths_from_directory("custom item", CUSTOM_ITEM_CONFIG)
	for(var/key in json_to_load)
		var/datum/custom_item/citem = new(cached_json_decode(json_to_load[key]))
		var/result = citem.validate()
		if(result)
			PRINT_STACK_TRACE("Invalid custom item for '[key]': [result]")
		else
			LAZYDISTINCTADD(custom_items_by_ckey[citem.character_ckey], citem)

	json_to_load = get_json_paths_from_directory("custom icon", CUSTOM_ICON_CONFIG)
	for(var/key in json_to_load)
		var/datum/custom_icon/cicon = new(cached_json_decode(json_to_load[key]))
		var/result = cicon.validate()
		if(result)
			PRINT_STACK_TRACE("Invalid custom icon for '[key]': [result]")
		else
			LAZYDISTINCTADD(custom_icons_by_ckey[cicon.character_ckey], cicon)

	. = ..()

// Places the item on the target mob.
/datum/controller/subsystem/customitems/proc/place_custom_item(mob/living/carbon/human/M, var/datum/custom_item/citem)
	. = M && citem && citem.spawn_item(get_turf(M))
	if(. && !M.equip_to_appropriate_slot(.) && !M.equip_to_storage(.))
		to_chat(M, SPAN_WARNING("Your custom item, \the [.], could not be placed on your character."))
		QDEL_NULL(.)

//gets the relevant list for the key from the listlist if it exists, check to make sure they are meant to have it and then calls the giving function
/datum/controller/subsystem/customitems/proc/equip_custom_items(mob/living/carbon/human/M)
	var/list/key_list = custom_items_by_ckey[M.ckey]
	if(!length(key_list))
		return
	for(var/datum/custom_item/citem in key_list)
		// Check for requisite ckey and character name.
		if(citem.character_ckey != M.ckey || citem.character_name != lowertext(M.real_name))
			continue
		// Check for required access.
		var/obj/item/card/id/current_id = M.get_equipped_item(slot_wear_id_str)
		if(length(citem.req_access) && (!istype(current_id) || !has_access(current_id.access, citem.req_access)))
			continue
		// Check for required job title.
		if(length(citem.req_titles))
			var/check_title = M.mind.role_alt_title || M.mind.assigned_role
			if(!(check_title in citem.req_titles))
				continue

		// Spawn and equip the item.
		if(ispath(citem.apply_to_target_type))
			var/obj/item/existing_item = (locate(citem.apply_to_target_type) in M.get_contents())
			if(existing_item)
				citem.apply_to_item(existing_item)
				return
		place_custom_item(M,citem)

/datum/custom_icon
	var/character_ckey
	var/character_name
	var/category
	var/list/ids_to_icons = list()

/datum/custom_icon/New(var/list/data)
	character_ckey = data["character_ckey"]
	character_name = data["character_name"]
	category =       data["icon_category"]
	ids_to_icons =   data["icons"]

/datum/custom_icon/proc/finalize_data()
	character_ckey =       ckey(character_ckey)
	character_name =       lowertext(character_name)
	for(var/icon_id in ids_to_icons)
		var/icon_loc = ids_to_icons[icon_id]
		if(config.custom_icon_icon_location)
			icon_loc = "[config.custom_icon_icon_location]/[icon_loc]"
		ids_to_icons[icon_id] = file(icon_loc)

/datum/custom_icon/proc/validate()
	if(!length(ids_to_icons))
		return SPAN_WARNING("Icon list is empty.")
	for(var/icon_id in ids_to_icons)
		if(!isfile(ids_to_icons[icon_id]) && !isicon(ids_to_icons[icon_id]))
			return SPAN_WARNING("ID [icon_id] maps to non-file non-icon value [ids_to_icons[icon_id] || "NULL"]")
/datum/custom_item
	var/character_ckey
	var/character_name
	var/item_desc
	var/item_name
	var/item_path
	var/item_icon
	var/item_state
	var/apply_to_target_type
	var/list/req_access
	var/list/req_titles
	var/list/additional_data

/datum/custom_item/New(var/list/data)
	character_ckey =       data["character_ckey"]
	character_name =       data["character_name"]
	item_name =            data["item_name"]
	item_desc =            data["item_desc"]
	item_icon =            data["item_icon"]
	item_state =           data["item_state"]
	req_access =           data["req_access"]
	req_titles =           data["req_titles"]
	item_path =            data["item_path"]
	additional_data =      data["additional_data"]
	apply_to_target_type = data["apply_to_target_type"]
	finalize_data() // Separate proc in case of runtime.

/datum/custom_item/proc/finalize_data()
	character_ckey =       ckey(character_ckey)
	character_name =       lowertext(character_name)
	item_path =            item_path && text2path(item_path)
	apply_to_target_type = apply_to_target_type && text2path(apply_to_target_type)
	if(item_icon)
		if(config.custom_item_icon_location)
			item_icon = "[config.custom_item_icon_location]/[item_path]"
		if(fexists(item_icon))
			item_icon = file(item_icon)

/datum/custom_item/proc/validate()
	if(!ispath(item_path, /obj/item))
		return SPAN_WARNING("The given item path is invalid or does not exist.")
	if(apply_to_target_type && !ispath(apply_to_target_type, /obj/item))
		return SPAN_WARNING("The target item path is invalid or does not exist.")

/datum/custom_item/proc/spawn_item(var/newloc)
	. = new item_path(newloc)
	apply_to_item(.)

/datum/custom_item/proc/apply_to_item(var/obj/item/item)
	. = item.inherit_custom_item_data(src)
