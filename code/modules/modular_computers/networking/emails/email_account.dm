/datum/computer_file/data/email_account/
	var/list/inbox = list()
	var/list/outbox = list()
	var/list/spam = list()
	var/list/deleted = list()

	var/login = ""
	var/password = ""
	var/can_login = TRUE	// Whether you can log in with this account. Set to false for system accounts
	var/suspended = FALSE	// Whether the account is banned by the SA.
	var/connected_clients = list()

	var/fullname	= "N/A"
	var/assignment	= "N/A"

	var/notification_mute = FALSE
	var/notification_sound = "*beep*"

/datum/computer_file/data/email_account/calculate_size()
	size = 1
	for(var/datum/computer_file/data/email_message/stored_message in all_emails())
		stored_message.calculate_size()
		size += stored_message.size

/datum/computer_file/data/email_account/New(_login, _fullname, _assignment)
	login = _login
	if(_fullname)
		fullname = _fullname
	if(_assignment)
		assignment = _assignment
	..()

/datum/computer_file/data/email_account/proc/all_emails()
	return (inbox | spam | deleted | outbox)

/datum/computer_file/data/email_account/proc/send_mail(var/recipient_address, var/datum/computer_file/data/email_message/message, var/datum/computer_network/network)
	if(!network)
		return
	var/datum/computer_file/data/email_account/recipient
	for(var/datum/computer_file/data/email_account/account in network.get_email_addresses())
		if(account.login == recipient_address)
			recipient = account
			break

	if(!istype(recipient))
		return 0

	if(!recipient.receive_mail(message, network))
		return

	outbox.Add(message)
	if(network.intrusion_detection_enabled)
		network.add_log("EMAIL LOG: [login] -> [recipient.login] title: [message.title].")
	return 1

/datum/computer_file/data/email_account/proc/receive_mail(var/datum/computer_file/data/email_message/received_message, var/datum/computer_network/network)
	if(!network)
		return
	received_message.set_timestamp()
	inbox.Add(received_message)
	for(var/datum/nano_module/program/email_client/ec in connected_clients)
		if(ec.get_network() == network)
			ec.mail_received(received_message)
	return 1

// Address namespace (@internal-services.net) for email addresses with special purpose only!.
/datum/computer_file/data/email_account/service/
	can_login = FALSE

/datum/computer_file/data/email_account/service/broadcaster/
	login = EMAIL_BROADCAST

/datum/computer_file/data/email_account/service/broadcaster/receive_mail(var/datum/computer_file/data/email_message/received_message, var/datum/computer_network/network)
	if(!network || !istype(received_message))
		return 0
	// Possibly exploitable for user spamming so keep admins informed.
	if(!received_message.spam)
		log_and_message_admins("Broadcast email address used by [usr]. Message title: [received_message.title].")

	for(var/datum/computer_file/data/email_account/email_account in network.get_email_addresses())
		if(istype(email_account, /datum/computer_file/data/email_account/service/broadcaster/))
			continue
		var/datum/computer_file/data/email_message/new_message = received_message.clone()
		send_mail(email_account.login, new_message, network)

	return 1

/datum/computer_file/data/email_account/service/document
	login = EMAIL_DOCUMENTS

/datum/computer_file/data/email_account/service/sysadmin
	login = EMAIL_SYSADMIN