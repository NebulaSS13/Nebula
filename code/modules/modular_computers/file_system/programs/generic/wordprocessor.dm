/datum/computer_file/program/wordprocessor
	filename = "wordprocessor"
	filedesc = "NanoWord"
	extended_desc = "This program allows the editing and preview of text documents."
	program_icon_state = "word"
	program_key_state = "atmos_key"
	size = 4
	available_on_network = 1

	usage_flags = PROGRAM_ALL
	category = PROG_OFFICE

	var/open_file		// Name of the file currently open.
	var/file_directory	// Directory of the file currently open.

	var/loaded_data
	var/error
	var/is_edited

/datum/computer_file/program/wordprocessor/on_shutdown(forced)
	. = ..()
	open_file = null
	file_directory = null
	loaded_data = null
	error = null
	is_edited = FALSE

/datum/computer_file/program/wordprocessor/on_file_select(datum/file_storage/disk, datum/computer_file/directory/dir, datum/computer_file/selected, selecting_key, mob/user)
	var/datum/computer_file/data/text/T = selected
	loaded_data = T.stored_data
	open_file = T.filename
	file_directory = disk.get_dir_path(dir, TRUE)
	is_edited = FALSE
	. = ..()

/datum/computer_file/program/wordprocessor/proc/save_file(mob/user)
	var/datum/computer_file/result = computer.save_file(open_file, file_directory, loaded_data, /datum/computer_file/data/text, null, computer.get_access(user), user)
	. = FALSE
	if(istype(result))
		to_chat(user, SPAN_NOTICE("Successfully saved file '[open_file]'."))
		is_edited = FALSE
		return TRUE
	// Errored!
	switch(result)
		if(OS_BAD_NAME)
			error = "I/O error: Invalid file name '[open_file]'."
		if(OS_FILE_NOT_FOUND)
			error = "I/O error: Directory not found."
		if(OS_FILE_NO_WRITE)
			error = "I/O error: You do not have permission to modify file '[open_file]'"
		else
			error = "I/O error: Harddrive may be non-functional."

#define MAX_FIELDS_NUM 50

/datum/computer_file/program/wordprocessor/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["PRG_txtpreview"])
		show_browser(usr,"<HTML><HEAD><TITLE>[open_file]</TITLE></HEAD>[digitalPencode2html(loaded_data)]</BODY></HTML>", "window=[open_file]")
		return TOPIC_HANDLED

	if(href_list["PRG_taghelp"])
		var/datum/codex_entry/entry = SScodex.get_codex_entry("pen")
		if(entry)
			SScodex.present_codex_entry(usr, entry)
		return TOPIC_HANDLED

	if(href_list["PRG_backtomenu"])
		error = null
		return TOPIC_REFRESH

	if(href_list["PRG_openfile"])
		if(is_edited)
			if(alert("Would you like to save your changes first?",,"Yes","No") == "Yes")
				if(!save_file(usr))
					return TOPIC_HANDLED
		var/browser_desc = "Select a file to open"
		view_file_browser(usr, "open_file", /datum/computer_file/data/text, OS_READ_ACCESS, browser_desc)
		return TOPIC_HANDLED

	if(href_list["PRG_newfile"])
		if(is_edited)
			if(alert("Would you like to save your changes first?",,"Yes","No") == "Yes")
				if(!save_file(usr))
					return TOPIC_HANDLED

		var/browser_desc = "Create new file"
		var/datum/computer_file/data/text/saving = new()
		view_file_browser(usr, "create_file", /datum/computer_file/data/text, OS_WRITE_ACCESS, browser_desc, saving)
		return TOPIC_HANDLED

	if(href_list["PRG_saveasfile"])
		var/browser_desc = "Save file as"
		var/datum/computer_file/data/text/saving = new()
		saving.filename = open_file ? open_file :  "NewFile"
		saving.stored_data = loaded_data
		view_file_browser(usr, "saveas_file", /datum/computer_file/data/text, OS_WRITE_ACCESS, browser_desc, saving)
		return TOPIC_HANDLED

	if(href_list["PRG_savefile"])
		if(!open_file)
			var/browser_desc = "Save file as"
			var/datum/computer_file/data/text/saving = new()
			saving.stored_data = loaded_data
			view_file_browser(usr, "saveas_file", /datum/computer_file/data/text, OS_WRITE_ACCESS, browser_desc, saving)
			return TOPIC_HANDLED

		save_file(usr)
		return TOPIC_REFRESH

	if(href_list["PRG_editfile"])
		var/oldtext = html_decode(loaded_data)
		oldtext = replacetext(oldtext, "\[br\]", "\n")
		if(open_file)
			var/datum/computer_file/data/F = get_file(open_file, file_directory, computer.get_access(usr), usr)
			if(istype(F) && !(F.get_file_perms(computer.get_access(usr), usr) & OS_WRITE_ACCESS))
				error = "I/O error: You do not have permission to edit this file."
				return TOPIC_REFRESH
		var/newtext = sanitize(replacetext(input(usr, "Editing file '[open_file]'. You may use most tags used in paper formatting:", "Text Editor", oldtext) as message|null, "\n", "\[br\]"), MAX_TEXTFILE_LENGTH)
		if(!newtext)
			return

		//Count the fields
		var/fields = 0
		var/regex/re = regex(@"\[field\]","g")
		while(re.Find(newtext))
			fields++

		if(fields > MAX_FIELDS_NUM)
			to_chat(usr, SPAN_WARNING("Too many fields. Sorry, you can't do this."))
			return

		loaded_data = newtext
		is_edited = 1
		return TOPIC_REFRESH

	if(href_list["PRG_printfile"])
		if(!computer.print_paper(digitalPencode2html(loaded_data)))
			error = "Hardware error: Printer missing or out of paper."
		return TOPIC_HANDLED

#undef MAX_FIELDS_NUM

/datum/computer_file/program/wordprocessor/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = global.default_topic_state)
	. = ..()
	if(!.)
		return
	var/list/data = computer.initial_data()

	if(error)
		data["error"] = error
	if(open_file)
		data["filedata"] = digitalPencode2html(loaded_data)
		data["filename"] = is_edited ? "[open_file]*" : open_file
	else
		data["filedata"] = digitalPencode2html(loaded_data)
		data["filename"] = "UNNAMED"

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "word_processor.tmpl", "Word Processor", 575, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
