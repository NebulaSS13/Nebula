/datum/computer_file/data/account
	filetype = "ACT"
	var/login = ""
	var/password = ""

	var/can_login = TRUE	// Whether you can log in with this account. Set to false for system accounts
	var/suspended = FALSE	// Whether the account is banned by the SA.
	var/list/logged_in_os = list() // OS which are currently logged into this account. Used for e-mail notifications, currently.

	var/list/groups = list() // Groups which this account is a member of. 
	var/list/parent_groups = list() // Parent groups with a child/children which this account is a member of.

	var/fullname	= "N/A"

	// E-Mail
	var/list/inbox = list()
	var/list/outbox = list()
	var/list/spam = list()
	var/list/deleted = list()

	var/notification_mute = FALSE
	var/notification_sound = "*beep*"
	var/backup = FALSE // Backups are not returned when searching for accounts, but can be recovered using the accounts program.

	copy_string = "(Backup)"

/datum/computer_file/data/account/calculate_size()
	size = 1
	for(var/datum/computer_file/data/email_message/stored_message in all_emails())
		stored_message.calculate_size()
		size += stored_message.size

/datum/computer_file/data/account/New(_login, _password, _fullname)
	if(_login)
		login = _login
		stored_data = "[login]"
	if(_password)
		password = _password
	if(_fullname)
		fullname = _fullname
	if(filename == initial(filename))
		filename = "account[random_id(type, 100,999)]"
	..()

/datum/computer_file/data/account/Destroy()
	for(var/weakref/os_ref in logged_in_os)
		var/datum/extension/interactive/os/os = os_ref.resolve()
		if(os.login == login)
			os.logout_account()

	logged_in_os.Cut()
	groups.Cut()
	parent_groups.Cut()
	
	QDEL_NULL_LIST(inbox)
	QDEL_NULL_LIST(outbox)
	QDEL_NULL_LIST(spam)
	QDEL_NULL_LIST(deleted)
	. = ..()

/datum/computer_file/data/account/proc/all_emails()
	return (inbox | spam | deleted | outbox)

/datum/computer_file/data/account/proc/all_incoming_emails()
	return (inbox | spam | deleted)

/datum/computer_file/data/account/proc/send_mail(var/recipient_address, var/datum/computer_file/data/email_message/message, var/datum/computer_network/network)
	if(!network)
		return
	var/datum/computer_file/data/account/recipient
	for(var/datum/computer_file/data/account/account in network.get_accounts())
		if((account.login + "@[network.network_id]") == recipient_address) // TODO: Add support for cross network email.
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

/datum/computer_file/data/account/proc/receive_mail(var/datum/computer_file/data/email_message/received_message, var/datum/computer_network/network)
	if(!network)
		return
	var/datum/computer_file/data/email_message/received_copy = received_message.clone()
	received_copy.set_timestamp()
	inbox.Add(received_copy)
	
	for(var/weakref/os_ref in logged_in_os)
		var/datum/extension/interactive/os/os = os_ref.resolve()
		if(istype(os))
			os.mail_received(received_copy)
		else
			logged_in_os -= os_ref
	return 1

/datum/computer_file/data/account/clone()
	var/datum/computer_file/data/account/copy = ..(TRUE) // We always rename the file since a copied account is always a backup.
	copy.backup = TRUE

	copy.login = login
	copy.password = password
	copy.can_login = can_login
	copy.suspended = suspended

	copy.groups = groups.Copy()
	copy.parent_groups = parent_groups.Copy()

	copy.fullname = fullname

	// TODO: Don't backup e-mails for now - they are themselves other files which makes this complicated. In the future
	// accounts will point to e-mails stored seperately on a server.
	return copy

// Address namespace (@internal-services.net) for email addresses with special purpose only!.
/datum/computer_file/data/account/service
	can_login = FALSE

/datum/computer_file/data/account/service/broadcaster
	login = EMAIL_BROADCAST

/datum/computer_file/data/account/service/broadcaster/receive_mail(var/datum/computer_file/data/email_message/received_message, var/datum/computer_network/network)
	if(!network || !istype(received_message))
		return 0
	// Possibly exploitable for user spamming so keep admins informed.
	if(!received_message.spam)
		log_and_message_admins("Broadcast email address used by [usr]. Message title: [received_message.title].")

	for(var/datum/computer_file/data/account/email_account in network.get_accounts())
		if(istype(email_account, /datum/computer_file/data/account/service/broadcaster))
			continue
		var/datum/computer_file/data/email_message/new_message = received_message.clone()
		send_mail(email_account.login + "@[network.network_id]", new_message, network)

	return 1

/datum/computer_file/data/account/service/document
	login = EMAIL_DOCUMENTS

/datum/computer_file/data/account/service/sysadmin
	login = EMAIL_SYSADMIN