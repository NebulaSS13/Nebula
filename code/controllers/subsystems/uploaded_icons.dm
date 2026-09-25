SUBSYSTEM_DEF(uploaded_icons)
	name       = "Uploaded Icons"
	wait       = 1 MINUTE
	init_order = SS_INIT_VERY_EARLY

	var/need_save            = FALSE
	var/alist/guid_to_icon   = alist()
	var/const/icons_path     = "data/icons/"
	var/const/icons_manifest = "icons.json"

/datum/controller/subsystem/uploaded_icons/stat_entry()
	..("I:[guid_to_icon.len]")

/datum/controller/subsystem/uploaded_icons/fire(resumed)
	save_icons()

/datum/controller/subsystem/uploaded_icons/Initialize(start_timeofday)
	..()
	try
		var/max_guid = 0
		var/manifest_path = "[icons_path][icons_manifest]"
		if(fexists(manifest_path))
			for(var/list/manifest_entry in json_decode(file2text(manifest_path)))
				var/create_type = manifest_entry[/datum::type]
				var/datum/uploaded_icon/uploaded_icon = new create_type(manifest_entry)
				guid_to_icon[uploaded_icon.guid] = uploaded_icon
				max_guid = max(max_guid, uploaded_icon.guid)
				uploaded_icon.icon = icon(file("[icons_path][uploaded_icon.guid].dmi"))
		set_guid(type, max_guid)
		for(var/i = 1 to max_guid)
			if(!guid_to_icon[i])
				free_guid(type, i)
		report_progress("Loaded [length(guid_to_icon)] uploaded icon\s.")

	catch(var/exception/E)
		error("Exception when loading player icons manifest: [EXCEPTION_TEXT(E)]")

/datum/controller/subsystem/uploaded_icons/proc/store_icon(_uploader, _description, _icon_flags, icon/_icon)
	var/datum/uploaded_icon/new_icon = new(get_guid(type))
	new_icon.uploader    = _uploader
	new_icon.description = _description
	new_icon.icon_flags  = _icon_flags
	new_icon.icon        = _icon
	need_save            = TRUE

/datum/controller/subsystem/uploaded_icons/proc/remove_icon(_guid)
	var/datum/uploaded_icon/uploaded_icon = guid_to_icon[_guid]
	if(!uploaded_icon)
		return FALSE
	guid_to_icon -= _guid
	qdel(uploaded_icon)
	free_guid(type, _guid)
	need_save = TRUE

/datum/controller/subsystem/uploaded_icons/Shutdown()
	save_icons(force = TRUE)
	. = ..()

/datum/controller/subsystem/uploaded_icons/proc/save_icons(force = FALSE)

	if(!need_save && !force)
		return

	try
		// Write out our .DMI files and populate our manifest.
		var/list/manifest_entries = list()
		for(var/icon_guid,icon_data in guid_to_icon)
			var/datum/uploaded_icon/uploaded_icon = icon_data
			manifest_entries += list(uploaded_icon.Serialize())
			// Should we back up the .DMI folder first? Seems much more
			// likely to cause memory issues than backing up .json files.
			fcopy(uploaded_icon.icon, "[icons_path][uploaded_icon.guid].dmi")
		// Take a timestamped backup.
		var/manifest_path = "[icons_path][icons_manifest]"
		if(fexists(manifest_path))
			var/backup_contents = file2text(manifest_path)
			var/backup_file = file("[manifest_path].[BACKUP_TIMESTAMP]")
			to_file(backup_file, backup_contents)
		// Write out the manifest.
		to_file(manifest_path, json_encode(manifest_entries))

	catch(var/exception/E)
		error("Exception when saving uploaded icons: [EXCEPTION_TEXT(E)]")

	need_save = FALSE

/datum/uploaded_icon
	var/guid
	var/uploader
	var/description
	var/icon_flags = 0
	// License? Artist?
	var/icon/icon

	var/const/ICON_FLAG_PUBLIC = BITFLAG(0)

/datum/uploaded_icon/New(list/_data)
	if(islist(_data))
		guid        = _data[/datum/uploaded_icon::guid]
		uploader    = _data[/datum/uploaded_icon::uploader]
		icon_flags  = _data[/datum/uploaded_icon::icon_flags]
		description = _data[/datum/uploaded_icon::description]
	else if(isnum(_data))
		guid = _data
	if(isnum(guid))
		// Check for collisions before doing this.
		SSuploaded_icons.guid_to_icon[guid] = src
	// else report an error?

/datum/uploaded_icon/Serialize()
	. = ..()
	// The actual icon is saved to disk and referenced by guid, not handled here.
	.[/datum/uploaded_icon::guid]        = guid
	.[/datum/uploaded_icon::uploader]    = uploader
	.[/datum/uploaded_icon::icon_flags]  = icon_flags
	.[/datum/uploaded_icon::description] = description
