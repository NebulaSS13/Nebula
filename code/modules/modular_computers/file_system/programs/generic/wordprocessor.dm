/datum/computer_file/program/wordprocessor
	filename = "wordprocessor"
	filedesc = "NanoWord"
	extended_desc = "This program allows the editing and preview of text documents."
	program_icon_state = "word"
	program_key_state = "atmos_key"
	size = 4
	available_on_network = 1
	nanomodule_path = /datum/nano_module/program/computer_wordprocessor/

	usage_flags = PROGRAM_ALL
	category = PROG_OFFICE

	var/browsing
	var/open_file
	var/loaded_data
	var/error
	var/is_edited

/datum/computer_file/program/wordprocessor/on_shutdown(forced)
	. = ..()
	browsing = null
	open_file = null
	loaded_data = null
	error = null
	is_edited = null

/datum/computer_file/program/wordprocessor/proc/open_file(var/openingfile, var/list/accesses, var/mob/user)
	var/datum/computer_file/data/F = get_file(openingfile)
	if(F)
		if(!(F.get_file_perms(accesses, user) & OS_READ_ACCESS))
			error = "I/O error: You do not have permission to read file '[openingfile]'."
			return FALSE
		open_file = F.filename
		loaded_data = F.stored_data
		return TRUE
	error = "I/O error: Unable to open file '[openingfile]'."

/datum/computer_file/program/wordprocessor/proc/save_file(var/savingfile)
	. = computer.save_file(savingfile, loaded_data, /datum/computer_file/data/text)
	if(.)
		is_edited = 0

#define MAX_FIELDS_NUM 50

/datum/computer_file/program/wordprocessor/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["PRG_txtrpeview"])
		show_browser(usr,"<HTML><HEAD><TITLE>[open_file]</TITLE></HEAD>[digitalPencode2html(loaded_data)]</BODY></HTML>", "window=[open_file]")
		return 1

	if(href_list["PRG_taghelp"])
		var/datum/codex_entry/entry = SScodex.get_codex_entry("pen")
		if(entry)
			SScodex.present_codex_entry(usr, entry)
		return 1

	if(href_list["PRG_closebrowser"])
		browsing = 0
		return 1

	if(href_list["PRG_backtomenu"])
		error = null
		return 1

	if(href_list["PRG_loadmenu"])
		browsing = 1
		return 1

	if(href_list["PRG_openfile"])
		. = 1
		if(is_edited)
			if(alert("Would you like to save your changes first?",,"Yes","No") == "Yes")
				save_file(open_file)
		browsing = 0
		open_file(href_list["PRG_openfile"], NM.get_access(usr), usr)

	if(href_list["PRG_newfile"])
		. = 1
		if(is_edited)
			if(alert("Would you like to save your changes first?",,"Yes","No") == "Yes")
				save_file(open_file)

		var/newname = sanitize(input(usr, "Enter file name:", "New File") as text|null)
		if(!newname)
			return 1
		var/datum/computer_file/data/F = create_file(newname, "", /datum/computer_file/data/text)
		if(F)
			open_file = F.filename
			loaded_data = ""

			// Set the write/mod access to the current account if it exists.
			var/datum/computer_file/data/account/A = computer.get_account()
			if(A)
				var/datum/computer_network/network = computer.get_network()
				LAZYADD(F.write_access, list(list("[A.login]@[network.network_id]")))
				LAZYADD(F.mod_access, list(list("[A.login]@[network.network_id]")))
			return 1
		else
			error = "I/O error: Unable to create file '[href_list["PRG_saveasfile"]]'."

	if(href_list["PRG_saveasfile"])
		. = 1
		var/newname = sanitize(input(usr, "Enter file name:", "Save As") as text|null)
		if(!newname)
			return 1
		var/datum/computer_file/data/F = create_file(newname, loaded_data, /datum/computer_file/data/text)
		if(F)
			var/datum/computer_file/data/account/A = computer.get_account()
			if(A)
				var/datum/computer_network/network = computer.get_network()
				LAZYADD(F.write_access, list(list("[A.login]@[network.network_id]")))
				LAZYADD(F.mod_access, list(list("[A.login]@[network.network_id]")))
				
			open_file = F.filename
		else
			error = "I/O error: Unable to create file '[href_list["PRG_saveasfile"]]'."
		return 1

	if(href_list["PRG_savefile"])
		. = 1
		if(!open_file)
			open_file = sanitize(input(usr, "Enter file name:", "Save As") as text|null)
			if(!open_file)
				return 0
		if(!save_file(open_file))
			error = "I/O error: Unable to save file '[open_file]'. Access may be denied."
		return 1

	if(href_list["PRG_editfile"])
		var/oldtext = html_decode(loaded_data)
		oldtext = replacetext(oldtext, "\[br\]", "\n")
		var/datum/computer_file/data/F = get_file(open_file)
		if(!F)
			error = "I/O error: File not found."
			return 1
		if(!(F.get_file_perms(NM.get_access(usr), usr) & OS_WRITE_ACCESS))
			error = "I/O error: You do not have permission to edit this file."
			return 1
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
		return 1

	if(href_list["PRG_printfile"])
		. = 1
		if(!computer.print_paper(digitalPencode2html(loaded_data)))
			error = "Hardware error: Printer missing or out of paper."
			return 1

#undef MAX_FIELDS_NUM

/datum/nano_module/program/computer_wordprocessor
	name = "Word Processor"

/datum/nano_module/program/computer_wordprocessor/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = global.default_topic_state)
	var/list/data = host.initial_data()
	var/datum/computer_file/program/wordprocessor/PRG
	PRG = program

	if(PRG.error)
		data["error"] = PRG.error
	if(PRG.browsing)
		data["browsing"] = PRG.browsing
		if(!PRG.computer || !PRG.computer.has_component(PART_HDD))
			data["error"] = "I/O ERROR: Unable to access hard drive."
		else
			var/list/files[0]
			for(var/datum/computer_file/F in PRG.computer.get_all_files())
				if(F.filetype == "TXT")
					files.Add(list(list(
						"name" = F.filename,
						"size" = F.size
					)))
			data["files"] = files

			var/obj/item/stock_parts/computer/drive_slot/RHDD = PRG.computer.get_component(PART_D_SLOT)
			if(istype(RHDD) && istype(RHDD.stored_drive))
				data["usbconnected"] = 1
				var/list/usbfiles[0]
				for(var/datum/computer_file/F in PRG.computer.get_all_files(RHDD.stored_drive))
					if(F.filetype == "TXT")
						usbfiles.Add(list(list(
							"name" = F.filename,
							"size" = F.size,
						)))
				data["usbfiles"] = usbfiles
	else if(PRG.open_file)
		data["filedata"] = digitalPencode2html(PRG.loaded_data)
		data["filename"] = PRG.is_edited ? "[PRG.open_file]*" : PRG.open_file
	else
		data["filedata"] = digitalPencode2html(PRG.loaded_data)
		data["filename"] = "UNNAMED"

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "word_processor.tmpl", "Word Processor", 575, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
