/datum/computer_network/proc/send_email(datum/computer_file/data/account/sender, recipient_address, datum/computer_file/data/email_message/sent)
	var/list/address_comp = splittext(recipient_address, "@")
	if(length(address_comp) < 2)
		return FALSE
	var/recipient_login = address_comp[1]
	var/recipient_net_id = address_comp[2]

	var/datum/computer_network/recipient_network = get_internet_connection(recipient_net_id, NET_FEATURE_COMMUNICATION)
	if(!istype(recipient_network))
		return FALSE

	var/datum/computer_file/data/account/recipient = recipient_network.find_account_by_login(recipient_login)
	if(!istype(recipient))
		return FALSE

	if(!recipient_network.receive_email(recipient, "[sender.login]@[network_id]", sent))
		return FALSE

	sender.outbox.Add(sent)
	if(intrusion_detection_enabled)
		add_log("EMAIL LOG: [sender.login]@[network_id] -> [recipient.login]@[recipient_network.network_id] title: [sent.title].")
	return TRUE

/datum/computer_network/proc/receive_email(datum/computer_file/data/account/recipient, sender_address, datum/computer_file/data/email_message/received)
	if(!(recipient in get_accounts_unsorted()))
		return FALSE

	var/datum/computer_file/data/email_message/received_copy = received.Clone()
	received_copy.set_timestamp()
	recipient.inbox.Add(received_copy)
	recipient.receive_mail(received_copy, src)

	for(var/weakref/os_ref in recipient.logged_in_os)
		var/datum/extension/interactive/os/os = os_ref.resolve()
		if(istype(os))
			os.mail_received(received_copy)
		else
			recipient.logged_in_os -= os_ref

	if(recipient.broadcaster)
		for(var/datum/computer_file/data/account/email_account in get_accounts_unsorted())
			if(email_account.broadcaster)
				continue
			var/datum/computer_file/data/email_message/new_message = received.Clone()
			send_email(recipient, "[email_account.login]@[network_id]", new_message)
	return TRUE