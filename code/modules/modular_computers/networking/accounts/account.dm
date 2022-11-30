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

	var/broadcaster = FALSE // If sent to true, e-mails sent to this address will be automatically sent to all other accounts in the network.

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

/datum/computer_file/data/account/proc/receive_mail(var/datum/computer_file/data/email_message/received_message, var/datum/computer_network/network)

/datum/computer_file/data/account/Clone(rename)
	. = ..(TRUE) // We always rename the file since a copied account is always a backup.

/datum/computer_file/data/account/PopulateClone(datum/computer_file/data/account/clone)
	clone = ..()
	clone.backup        = TRUE
	clone.login         = login
	clone.password      = password
	clone.can_login     = can_login
	clone.suspended     = suspended
	clone.groups        = groups.Copy()
	clone.parent_groups = parent_groups.Copy()
	clone.fullname      = fullname

	// TODO: Don't backup e-mails for now - they are themselves other files which makes this complicated. In the future
	// accounts will point to e-mails stored seperately on a server.
	return clone

// Address namespace (@internal-services.net) for email addresses with special purpose only!.
/datum/computer_file/data/account/service
	can_login = FALSE

/datum/computer_file/data/account/service/broadcaster
	login = EMAIL_BROADCAST
	broadcaster = TRUE

/datum/computer_file/data/account/service/document
	login = EMAIL_DOCUMENTS

/datum/computer_file/data/account/service/sysadmin
	login = EMAIL_SYSADMIN