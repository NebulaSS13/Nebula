/datum/computer_file/data/email_account
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

/datum/computer_file/data/email_account/Destroy()
	. = ..()

/datum/computer_file/data/email_account/proc/all_emails()
	return (inbox | spam | deleted | outbox)

/datum/computer_file/data/email_account/proc/send_mail(var/recipient_address, var/datum/computer_file/data/email_message/message, var/relayed = 0)
	var/datum/computer_file/data/email_account/recipient
	var/datum/extension/exonet_device/exonet = get_extension(holder, /datum/extension/exonet_device)
	if(!exonet)
		return 0
	for(var/datum/computer_file/data/email_account/account in exonet.get_email_accounts())
		if(account.login == recipient_address)
			recipient = account
			break

	if(!istype(recipient))
		return 0

	if(!recipient.receive_mail(message, relayed))
		return

	outbox.Add(message)
	return 1

/datum/computer_file/data/email_account/proc/receive_mail(var/datum/computer_file/data/email_message/received_message, var/relayed)
	received_message.set_timestamp()
	inbox.Add(received_message)
	return 1

// Address namespace (@internal-services.net) for email addresses with special purpose only!.
/datum/computer_file/data/email_account/service/
	can_login = FALSE

/datum/computer_file/data/email_account/service/broadcaster/
	login = EMAIL_BROADCAST

/datum/computer_file/data/email_account/service/broadcaster/receive_mail(var/datum/computer_file/data/email_message/received_message, var/relayed)
	if(!istype(received_message) || relayed)
		return 0
	// Possibly exploitable for user spamming so keep admins informed.
	if(!received_message.spam)
		log_and_message_admins("Broadcast email address used by [usr]. Message title: [received_message.title].")

	spawn(0)
		var/datum/extension/exonet_device/exonet = get_extension(holder, /datum/extension/exonet_device)
		if(!exonet)
			return 0
		for(var/datum/computer_file/data/email_account/email_account in exonet.get_email_accounts())
			var/datum/computer_file/data/email_message/new_message = received_message.clone()
			send_mail(email_account.login, new_message, 1)
			sleep(2)
	return 1

/datum/computer_file/data/email_account/service/document
	login = EMAIL_DOCUMENTS

/datum/computer_file/data/email_account/service/sysadmin
	login = EMAIL_SYSADMIN