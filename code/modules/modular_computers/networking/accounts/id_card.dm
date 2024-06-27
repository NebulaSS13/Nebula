/obj/item/card/id/network
	var/network_id												// The network_id that this card is paired to.
	var/weakref/current_account
	color = COLOR_GRAY80
	detail_color = COLOR_SKY_BLUE

/obj/item/card/id/network/Initialize()
	set_extension(src, /datum/extension/network_device/id_card, network_id)
	return ..()

/obj/item/card/id/network/GetAccess(var/ignore_account)
	. = ..()
	var/datum/computer_file/data/account/access_account = resolve_account()
	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	var/datum/computer_network/network = D.get_network(NET_FEATURE_ACCESS)
	if(network && access_account && access_account.login != ignore_account)
		var/location = "[network.network_id]"
		if(access_account)
			. += "[access_account.login]@[location]" // User access uses '@'
			for(var/group in access_account.groups)
				. += "[group].[location]"	// Group access uses '.'
			for(var/group in access_account.parent_groups) // Membership in a child group grants access to anything with an access requirement set to the parent group.
				. += "[group].[location]"

/obj/item/card/id/network/proc/resolve_account()
	if(!current_account)
		return
	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	var/datum/computer_network/network = D.get_network(NET_FEATURE_ACCESS)

	var/login = associated_network_account["login"]
	var/password = associated_network_account["password"]

	var/error
	var/datum/computer_file/data/account/check_account = current_account.resolve()
	if(!network) // No network or connectivity.
		error = "No network found"
	else if(!istype(check_account))
		error = "The specified account could not be found"
	else if(check_account.login != login || check_account.password != password) // The most likely case - login or password were changed.
		error = "Incorrect username or password"
	// Check if the account can be located on the network in case it was moved.
	else if(!(check_account in network.get_accounts()))
		error = "The specified account could not be found"

	if(error)
		current_account = null
		visible_message(SPAN_WARNING("\The [src] flashes an error: \'[error]!\'"), null, null,1)
	else
		return check_account

/obj/item/card/id/network/ui_interact(mob/user, ui_key = "main",var/datum/nanoui/ui = null)
	var/data[0]
	var/login  = associated_network_account["login"]
	var/password = associated_network_account["password"]

	data["login"] = login ? login : "Enter Login"
	data["password"] = password ? stars(password, 0) : "Enter Password"
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data)
	if (!ui)
		ui = new(user, src, ui_key, "network_id.tmpl", "Network ID Settings", 540, 326)
		ui.set_initial_data(data)
		ui.open()

/obj/item/card/id/network/Topic(href, href_list, datum/topic_state/state)
	. = ..()
	if(.)
		return
	var/login  = associated_network_account["login"]
	var/password = associated_network_account["password"]
	if(href_list["change_login"])
		var/new_login = sanitize(input(usr, "Enter your account login:", "Account login", login) as text|null)
		if(new_login == login || !CanInteract(usr, DefaultTopicState()))
			return TOPIC_NOACTION
		associated_network_account["login"] = new_login

		current_account = null
		password = null
		return TOPIC_REFRESH

	if(href_list["change_password"])
		var/new_password = sanitize(input(usr, "Enter your account password:", "Account password") as text|null)
		if(new_password == password || !CanInteract(usr, DefaultTopicState()))
			return TOPIC_NOACTION
		associated_network_account["password"] = new_password

		current_account = null
		return TOPIC_REFRESH

	if(href_list["login_account"])
		if(login_account())
			to_chat(usr, SPAN_NOTICE("Account successfully logged in."))
		else
			to_chat(usr, SPAN_WARNING("Could not login to account. Check password or network connectivity."))
		return TOPIC_REFRESH

	if(href_list["settings"])
		var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
		D.ui_interact(usr)
		return TOPIC_HANDLED

/obj/item/card/id/network/proc/login_account()
	. = FALSE
	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	var/datum/computer_network/network = D.get_network(NET_FEATURE_ACCESS)
	if(!network)
		return
	var/login  = associated_network_account["login"]
	var/password = associated_network_account["password"]
	for(var/datum/computer_file/data/account/check_account in network.get_accounts())
		if(check_account.login == login && check_account.password == password)
			current_account = weakref(check_account)
			return TRUE

/obj/item/card/id/network/verb/adjust_settings()
	set name = "Adjust Settings"
	set category = "Object"
	set src in usr

	ui_interact(usr)