/datum/computer_file/program/email_client
	filename = "emailc"
	filedesc = "Email Client"
	extended_desc = "This program may be used to log in into your email account."
	program_icon_state = "generic"
	program_key_state = "generic_key"
	program_menu_icon = "mail-closed"
	size = 7
	available_on_network = 1
	usage_flags = PROGRAM_ALL
	category = PROG_OFFICE

	nanomodule_path = /datum/nano_module/program/email_client

/datum/computer_file/program/email_client/on_startup()
	. = ..()

	if(NM)
		var/datum/nano_module/program/email_client/NME = NM
		NME.error = ""
		NME.check_for_new_messages(TRUE, computer.get_account_nocheck())

/datum/computer_file/program/email_client/proc/new_mail_notify(notification_sound)
	computer.visible_notification(notification_sound)
	computer.audible_notification("sound/machines/ping.ogg")

/datum/computer_file/program/email_client/proc/mail_received(datum/computer_file/data/email_message/received)
	if(NM)
		var/datum/nano_module/program/email_client/NME = NM
		NME.mail_received(received)

/datum/computer_file/program/email_client/process_tick()
	..()
	var/datum/nano_module/program/email_client/NME = NM
	if(!istype(NME))
		return
	NME.relayed_process(computer.get_network_status())
	var/datum/computer_file/data/account/current_account = computer.get_account_nocheck()
	if(current_account)
		var/check_count = NME.check_for_new_messages(FALSE, current_account)
		if(check_count)
			if(check_count == 2 && !current_account.notification_mute)
				new_mail_notify(current_account.notification_sound)
			ui_header = "ntnrc_new.gif"
		else
			ui_header = "ntnrc_idle.gif"

/datum/nano_module/program/email_client/
	name = "Email Client"
	var/error = ""

	var/msg_title = ""
	var/msg_body = ""
	var/msg_recipient = ""
	var/datum/computer_file/msg_attachment = null
	var/folder = "Inbox"
	var/addressbook = FALSE
	var/new_message = FALSE

	var/last_message_count = 0	// How many messages were there during last check.
	var/read_message_count = 0	// How many messages were there when user has last accessed the UI.

	var/datum/computer_file/downloading = null
	var/download_progress = 0
	var/download_speed = 0

	var/datum/computer_file/data/email_message/current_message = null

/datum/nano_module/program/email_client/proc/get_functional_drive()
	return program.computer.get_component(/obj/item/stock_parts/computer/hard_drive)

/datum/nano_module/program/email_client/proc/get_email_addresses()
	var/datum/computer_network/net = get_network()
	if(net)
		return net.get_accounts()

/datum/nano_module/program/email_client/proc/mail_received(var/datum/computer_file/data/email_message/received_message)
	var/mob/living/L = host.get_recursive_loc_of_type(/mob/living)
	if(L)
		var/list/msg = list()
		msg += "*--*\n"
		msg += "<span class='notice'>New mail received from [received_message.source]:</span>\n"
		msg += "<b>Subject:</b> [received_message.title]\n<b>Message:</b>\n[received_message.generate_file_data()]\n"
		if(received_message.attachment)
			msg += "<b>Attachment:</b> [received_message.attachment.filename].[received_message.attachment.filetype] ([received_message.attachment.size]GQ)\n"
		msg += "<a href='byond://?src=\ref[src];open;reply=[received_message.uid]'>Reply</a>\n"
		msg += "*--*"
		to_chat(L, jointext(msg, null))

// Returns 0 if no new messages were received, 1 if there is an unread message but notification has already been sent.
// and 2 if there is a new message that appeared in this tick (and therefore notification should be sent by the program).
/datum/nano_module/program/email_client/proc/check_for_new_messages(var/messages_read = FALSE, var/datum/computer_file/data/account/current_account)
	if(!current_account)
		return
	var/list/allmails = current_account.all_incoming_emails()

	if(allmails.len > last_message_count)
		. = 2
	else if(allmails.len > read_message_count)
		. = 1
	else
		. = 0

	if(.) // See if we can actually find the passed account. We wait to do this til now because finding the account requires some hoop jumping that shouldn't occur every tick.
		if(program.computer.get_account() != current_account)
			return 0

	last_message_count = allmails.len
	if(messages_read)
		read_message_count = allmails.len

/datum/nano_module/program/email_client/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = global.default_topic_state)
	var/list/data = host.initial_data()
	var/datum/computer_network/network = get_network()
	var/datum/computer_file/data/account/current_account = program.computer.get_account()
	if(!network)
		error = "No network found. Check network connection."
	else
		if(istype(current_account))
			if(current_account.suspended)
				error = "This account has been suspended. Please contact the system administrator for assistance."
		else
			error = "No account logged in. Please login through your system to proceed."
	if(error)
		data["error"] = error
	else if(downloading)
		data["downloading"] = 1
		data["down_filename"] = "[downloading.filename].[downloading.filetype]"
		data["down_progress"] = download_progress
		data["down_size"] = downloading.size
		data["down_speed"] = download_speed
	else
		data["current_account"] = current_account.login
		data["notification_mute"] = current_account.notification_mute
		if(addressbook)
			var/list/all_accounts = list()
			for(var/datum/computer_file/data/account/account in get_email_addresses())
				if(!account.can_login)
					continue
				var/datum/computer_file/report/crew_record/record = network.get_crew_record_by_name(account.fullname)
				var/job = record ? record.get_job() : "Undefined"
				var/domain = "@[network.network_id]"
				all_accounts.Add(list(list(
					"name" = account.fullname,
					"job" = job,
					"address" = account.login + domain
				)))
			data["addressbook"] = 1
			data["accounts"] = all_accounts
		else if(new_message)
			data["new_message"] = 1
			data["msg_title"] = msg_title
			data["msg_body"] = digitalPencode2html(msg_body)
			data["msg_recipient"] = msg_recipient
			if(msg_attachment)
				data["msg_hasattachment"] = 1
				data["msg_attachment_filename"] = "[msg_attachment.filename].[msg_attachment.filetype]"
				data["msg_attachment_size"] = msg_attachment.size
		else if (current_message)
			data["cur_title"] = current_message.title
			data["cur_body"] = current_message.generate_file_data()
			data["cur_timestamp"] = current_message.timestamp
			data["cur_source"] = current_message.source
			data["cur_uid"] = current_message.uid
			if(istype(current_message.attachment))
				data["cur_hasattachment"] = 1
				data["cur_attachment_filename"] = "[current_message.attachment.filename].[current_message.attachment.filetype]"
				data["cur_attachment_size"] = current_message.attachment.size
		else
			data["label_inbox"] = "Inbox ([current_account.inbox.len])"
			data["label_outbox"] = "Sent ([current_account.outbox.len])"
			data["label_spam"] = "Spam ([current_account.spam.len])"
			data["label_deleted"] = "Deleted ([current_account.deleted.len])"
			var/list/message_source
			if(folder == "Inbox")
				message_source = current_account.inbox
			else if(folder == "Sent")
				message_source = current_account.outbox
			else if(folder == "Spam")
				message_source = current_account.spam
			else if(folder == "Deleted")
				message_source = current_account.deleted

			if(message_source)
				data["folder"] = folder
				var/list/all_messages = list()
				for(var/datum/computer_file/data/email_message/message in message_source)
					all_messages.Add(list(list(
						"title" = message.title,
						"body" = message.generate_file_data(),
						"source" = message.source,
						"timestamp" = message.timestamp,
						"uid" = message.uid
					)))
				data["messages"] = all_messages
				data["messagecount"] = all_messages.len

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "email_client.tmpl", "Email Client", 600, 450, state = state)
		if(host.update_layout())
			ui.auto_update_layout = 1
		ui.set_auto_update(1)
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/email_client/proc/find_message_by_fuid(var/fuid, var/datum/computer_file/data/account/current_account)
	if(!istype(current_account))
		return

	// href_list works with strings, so this makes it a bit easier for us
	if(istext(fuid))
		fuid = text2num(fuid)

	for(var/datum/computer_file/data/email_message/message in current_account.all_emails())
		if(message.uid == fuid)
			return message

/datum/nano_module/program/email_client/proc/clear_message()
	new_message = FALSE
	msg_title = ""
	msg_body = ""
	msg_recipient = ""
	msg_attachment = null
	current_message = null

/datum/nano_module/program/email_client/proc/relayed_process(var/netspeed)
	download_speed = netspeed
	if(!downloading)
		return
	download_progress = min(download_progress + netspeed, downloading.size)
	if(download_progress >= downloading.size)
		var/obj/item/stock_parts/computer/hard_drive/drive = get_functional_drive()
		if(!drive)
			downloading = null
			download_progress = 0
			return 1

		var/success = drive.store_file()
		if(success == OS_FILE_SUCCESS)
			error = "File successfully downloaded to local device."
		else if(success == OS_HARDDRIVE_SPACE)
			error = "Error saving file: The hard drive is full"
		else
			error = "Error saving file: I/O Error: The hard drive may be nonfunctional."
		downloading = null
		download_progress = 0
	return 1

/datum/nano_module/program/email_client/Topic(href, href_list)
	if(..())
		return 1
	var/mob/living/user = usr
	var/datum/computer_file/data/account/current_account = program.computer.get_account()

	if(href_list["open"])
		ui_interact()

	check_for_new_messages(TRUE, current_account)	// Any actual interaction (button pressing) is considered as acknowledging received message, for the purpose of notification icons.

	if(href_list["reset"])
		error = ""
		return 1

	if(href_list["new_message"])
		new_message = TRUE
		return 1

	if(href_list["cancel"])
		if(addressbook)
			addressbook = FALSE
		else
			clear_message()
		return 1

	if(href_list["addressbook"])
		addressbook = TRUE
		return 1

	if(href_list["set_recipient"])
		msg_recipient = sanitize(href_list["set_recipient"])
		addressbook = FALSE
		return 1

	if(href_list["edit_title"])
		var/newtitle = sanitize(input(user,"Enter title for your message:", "Message title", msg_title), 100)
		if(newtitle)
			msg_title = newtitle
		return 1

	// This uses similar editing mechanism as the FileManager program, therefore it supports various paper tags and remembers formatting.
	if(href_list["edit_body"])
		var/oldtext = html_decode(msg_body)
		oldtext = replacetext(oldtext, "\[br\]", "\n")

		var/newtext = sanitize(replacetext(input(usr, "Enter your message. You may use most tags from paper formatting", "Message Editor", oldtext) as message|null, "\n", "\[br\]"), 20000)
		if(newtext)
			msg_body = newtext
		return 1

	if(href_list["edit_recipient"])
		var/newrecipient = sanitize(input(user,"Enter recipient's email address:", "Recipient", msg_recipient), 100)
		if(newrecipient)
			msg_recipient = newrecipient
			addressbook = 0
		return 1

	if(href_list["close_addressbook"])
		addressbook = 0
		return 1

	if(href_list["delete"])
		if(!istype(current_account))
			return 1
		var/datum/computer_file/data/email_message/M = find_message_by_fuid(href_list["delete"], current_account)
		if(!istype(M))
			return 1
		if(folder == "Deleted")
			current_account.deleted.Remove(M)
			qdel(M)
		else
			current_account.deleted.Add(M)
			current_account.inbox.Remove(M)
			current_account.spam.Remove(M)
		if(current_message == M)
			current_message = null
		return 1

	if(href_list["send"])
		if(!current_account)
			return 1
		if((msg_body == "") || (msg_recipient == ""))
			error = "Error sending mail: Message body is empty!"
			return 1
		if(!length(msg_title))
			msg_title = "No subject"

		var/datum/computer_network/network = get_network()
		var/datum/computer_file/data/email_message/message = new()
		if(!network)
			return TOPIC_REFRESH
		message.title = msg_title
		message.stored_data = msg_body
		message.source = current_account.login + "@[network.network_id]"
		message.attachment = msg_attachment
		if(!network.send_email(current_account, msg_recipient, message))
			error = "Error sending email: this address doesn't exist."
			return 1
		else
			error = "Email successfully sent."
			clear_message()
			return 1

	if(href_list["set_folder"])
		folder = href_list["set_folder"]
		return 1

	if(href_list["reply"])
		var/datum/computer_file/data/email_message/M = find_message_by_fuid(href_list["reply"], current_account)
		if(!istype(M))
			return 1
		error = null
		new_message = TRUE
		msg_recipient = M.source
		msg_title = "Re: [M.title]"
		var/atom/movable/AM = host
		if(istype(AM))
			if(ismob(AM.loc))
				ui_interact(AM.loc)
		return 1

	if(href_list["view"])
		var/datum/computer_file/data/email_message/M = find_message_by_fuid(href_list["view"], current_account)
		if(istype(M))
			current_message = M
		return 1

	if(href_list["set_notification"])
		var/new_notification = sanitize(input(user, "Enter your desired notification sound:", "Set Notification", current_account.notification_sound) as text|null)
		if(new_notification && current_account)
			current_account.notification_sound = new_notification
		return 1

	if(href_list["mute"])
		current_account.notification_mute = !current_account.notification_mute
		return 1

	// The following entries are Modular Computer framework only, and therefore won't do anything in other cases (like AI View)

	if(href_list["save"])
		// Fully dependant on modular computers here.
		var/obj/item/stock_parts/computer/hard_drive/drive = get_functional_drive()
		if(!drive)
			return 1

		var/filename = sanitize(input(user,"Please specify file name:", "Message export"), 100)
		if(!filename)
			return 1

		var/datum/computer_file/data/email_message/M = find_message_by_fuid(href_list["save"], current_account)
		var/datum/computer_file/data/mail = istype(M) ? M.export() : null
		if(!istype(mail))
			return 1
		mail.filename = filename

		drive = get_functional_drive()
		if(!drive || !drive.store_file(mail))
			error = "Internal I/O error when writing file, the hard drive may be full."
		else
			error = "Email exported successfully"
		return 1

	if(href_list["addattachment"])
		var/obj/item/stock_parts/computer/hard_drive/drive = get_functional_drive()
		msg_attachment = null
		if(!drive)
			return 1

		var/list/filenames = list()
		for(var/datum/computer_file/CF in drive.stored_files)
			if(CF.unsendable)
				continue
			filenames.Add(CF.filename)
		var/picked_file = input(user, "Please pick a file to send as attachment (max 32GQ)") as null|anything in filenames

		if(!picked_file)
			return 1

		drive = get_functional_drive()
		if(!drive)
			return 1

		for(var/datum/computer_file/CF in drive.stored_files)
			if(CF.unsendable)
				continue
			if(CF.filename == picked_file)
				msg_attachment = CF.Clone()
				break
		if(!istype(msg_attachment))
			msg_attachment = null
			error = "Unknown error when uploading attachment."
			return 1

		if(msg_attachment.size > 32)
			error = "Error uploading attachment: File exceeds maximal permitted file size of 32GQ."
			msg_attachment = null
		else
			error = "File [msg_attachment.filename].[msg_attachment.filetype] has been successfully uploaded."
		return 1

	if(href_list["downloadattachment"])
		if(!current_account || !current_message || !current_message.attachment)
			return 1
		var/obj/item/stock_parts/computer/hard_drive/drive = get_functional_drive()
		if(!drive)
			return 1

		downloading = current_message.attachment.Clone()
		download_progress = 0
		return 1

	if(href_list["canceldownload"])
		downloading = null
		download_progress = 0
		return 1

	if(href_list["remove_attachment"])
		msg_attachment = null
		return 1