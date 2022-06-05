#define STATE_ERROR -1
#define STATE_MENU  0
#define STATE_SELF  1
#define STATE_OTHER 2

/datum/computer_file/program/accounts
	filename = "accountman"
	filedesc = "Account management program"
	nanomodule_path = /datum/nano_module/program/accounts
	program_icon_state = "id"
	program_key_state = "id_key"
	program_menu_icon = "key"
	extended_desc = "Program for managing network accounts and group membership."
	size = 8
	category = PROG_COMMAND

/datum/nano_module/program/accounts
	name = "Account management program"
	var/prog_state = STATE_MENU
	var/datum/computer_file/data/account/selected_account
	var/selected_parent_group

/datum/nano_module/program/accounts/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = global.default_topic_state)
	var/list/data = host.initial_data()
	var/datum/computer_network/network = get_network()
	if(!network)
		data["error"] = "No accounts found. Check network connectivity."
		prog_state = STATE_ERROR
	switch(prog_state)
		if(STATE_SELF)
			data["account_name"] = selected_account.login
			data["account_password"] = selected_account.password
			data["account_fullname"] = selected_account.fullname
			data["account_groups"] = selected_account.groups
		if(STATE_OTHER) // Modifying other accounts.
			var/datum/extension/network_device/acl/net_acl = network.access_controller
			if(!net_acl)
				data["error"] = "No access controller found on the network!"
				prog_state = STATE_ERROR
			else
				var/list/group_dict = net_acl.get_group_dict()
				if(!istype(selected_account))
					var/list/accounts = network.get_accounts()
					data["accounts"] = list()
					for(var/datum/computer_file/data/account/A in accounts)
						data["accounts"] += list(list(
							"account" = A.login,
							"fullname" = A.fullname
						))
				else
					data["account_name"] = selected_account.login
					data["account_fullname"] = selected_account.fullname
					if(!selected_parent_group)
						data["parent_groups"] = list()
						for(var/parent_group in group_dict)
							data["parent_groups"] += list(list(
										"name" = parent_group,
										"member" = (parent_group in selected_account.groups)
										))
					else
						var/list/child_groups = group_dict[selected_parent_group]
						if(!child_groups)
							data["error"] = "Invalid parent selected!"
							selected_parent_group = null
							return
						data["parent_group"] = selected_parent_group
						data["child_groups"] = list()
						for(var/child_group in child_groups)
							data["child_groups"] += list(list(
										"name" = child_group,
										"member" = (child_group in selected_account.groups)
									))
				data["sub_management"] = net_acl.allow_submanagement
	data["prog_state"] = prog_state
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "account_management.tmpl", name, 600, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/computer_file/program/accounts/Topic(href, href_list, state)
	if(..())
		return 1

	var/mob/user = usr

	var/datum/computer_network/network = computer.get_network()
	var/datum/nano_module/program/accounts/module = NM
	if(!network)
		return
	switch(module.prog_state)
		if(STATE_MENU)
			if(href_list["self_mode"])
				var/datum/computer_file/data/account/A = computer.get_account()
				if(A)
					module.selected_account = A
					module.prog_state = STATE_SELF
					return TOPIC_REFRESH
				else
					to_chat(user, SPAN_WARNING("No account found. Please login through your system before reattempting."))
					return TOPIC_HANDLED

			if(href_list["other_mode"])
				if(!computer.get_network_status(NET_FEATURE_RECORDS))
					to_chat(user, SPAN_WARNING("NETWORK ERROR - The network rejected access to account servers from your current connection."))
					return TOPIC_REFRESH
				module.selected_account = null // Reset selected account just in case.
				module.prog_state = STATE_OTHER
				return TOPIC_REFRESH

		if(STATE_SELF)
			if(!module.selected_account || computer.get_account() != module.selected_account)
				module.selected_account = null
				module.prog_state = STATE_MENU
				to_chat(user, SPAN_WARNING("Authentication error. Please relogin to your account."))
				return TOPIC_REFRESH

			if(href_list["change_password"])
				var/new_password = input(user, "Input new account password.", "Change Password", module.selected_account.password) as text|null
				var/password_check = alert(user, "Your new password will be [new_password]. Is this alright?", "Change Password", "Yes", "No")
				if(password_check == "Yes")
					if(!CanInteract(user,state))
						return TOPIC_HANDLED
					module.selected_account.password = new_password
					// Update the program's password too so the user doesn't have to login again.
					computer.password = new_password
					return TOPIC_REFRESH
				return TOPIC_HANDLED

			if(href_list["change_fullname"])
				var/new_fullname = input(user, "Input your full name.", "Change name", module.selected_account.fullname) as text|null
				if(!CanInteract(user,state))
					return TOPIC_HANDLED
				module.selected_account.fullname = new_fullname
				return TOPIC_REFRESH

		if(STATE_OTHER)
			if(!computer.get_network_status(NET_FEATURE_RECORDS))
				module.prog_state = STATE_MENU
				to_chat(user, SPAN_WARNING("NETWORK ERROR - The network rejected access to account servers from your current connection."))
				return TOPIC_REFRESH

			if(href_list["select_account"])
				var/account_login = href_list["select_account"]
				for(var/datum/computer_file/data/account/A in network.get_accounts())
					if(A.login == account_login)
						module.selected_account = A
						return TOPIC_REFRESH

			// Further actions require the ACL to be present on the network, so check if it exists first.
			var/datum/extension/network_device/acl/net_acl = network.access_controller
			if(!net_acl)
				module.selected_parent_group = null // Just in case.
				return TOPIC_REFRESH
			var/list/group_dict = net_acl.get_group_dict()
			
			if(href_list["create_account"])
				var/list/account_creation_access

				// Passing null access to create_account will ignore access checks on account servers, so only assign this
				// if the user doesn't have parent group account creation authorization.
				if(!net_acl.check_account_creation_auth(computer.get_account()))
					account_creation_access = NM.get_access(user)
				var/new_login = input(user, "Input new account login. Login will be sanitized.", "Account Creation") as text|null

				var/login_check = alert(user, "Account login will be [sanitize_for_account(new_login)]. Is this acceptable?","Account Creation", "Yes", "No")
				if(login_check == "Yes")
					var/new_password = input(user, "Input new account password.", "Account Creation") as text|null
					var/new_fullname = input(user, "Enter full name for account (e.g. John Smith)", "Account Creation") as text|null
					if(!CanInteract(user,state))
						return TOPIC_HANDLED
					if(network.create_account(null, new_login, new_password, new_fullname, account_creation_access, FALSE))
						to_chat(user, SPAN_NOTICE("Account successfully created!"))
						return TOPIC_REFRESH
					else
						to_chat(user, SPAN_WARNING("Account could not be created. It's possible an account with a matching login already exists, or you lack access to account servers."))
						return TOPIC_HANDLED
				else
					to_chat(user, SPAN_NOTICE("Account creation aborted."))
					return TOPIC_HANDLED

			if(href_list["recover_account"])
				var/list/account_recovery_access

				if(!net_acl.check_account_creation_auth(computer.get_account()))
					account_recovery_access = NM.get_access(user)
				
				var/list/backups = network.get_account_backups(account_recovery_access)
				if(!length(backups))
					to_chat(user, SPAN_WARNING("No account backups found on account servers!"))
					return TOPIC_HANDLED

				var/selected_login = input(user, "Select the account backup you would like to recover:", "Account Backups") as anything in backups
				if(!CanInteract(user, state) || !selected_login)
					return TOPIC_HANDLED
				
				if(network.find_account_by_login(selected_login))
					to_chat(user, SPAN_WARNING("An account with that login already exists on the network! Cannot recover backup."))
					return TOPIC_HANDLED
				
				var/datum/computer_file/data/account/backup = backups[selected_login]
				backup.backup = FALSE
				backup.filename = replacetext(backup.filename, backup.copy_string, null) // Remove the backup signifier on the file.
				to_chat(user, SPAN_NOTICE("Successfully recovered account [selected_login] from backup!"))
				return TOPIC_REFRESH

			if(href_list["mod_group"])
				if(!module.selected_account || QDELETED(module.selected_account))
					module.selected_parent_group = null
					return TOPIC_REFRESH
				var/group_name = href_list["mod_group"]
				var/is_parent_group = (group_name in group_dict)
				if(!is_parent_group && !LAZYISIN(group_dict[module.selected_parent_group], group_name)) // Safety check.
					module.selected_parent_group = null
					return TOPIC_REFRESH
				// This is a parent group, or group submanagement is disabled - no matter what, direct access to the ACL is required.
				if(is_parent_group || !net_acl.allow_submanagement)
					if(!net_acl.has_access(module.get_access(user)))
						to_chat(user, SPAN_WARNING("Access denied."))
						return TOPIC_HANDLED
					if(group_name in module.selected_account.groups)
						module.selected_account.groups -= group_name
					else
						module.selected_account.groups += group_name
				else
					// Manual group membership check since the normal parent group access string normally grants child group members access. Modifying child groups is permitted if the program account
					// is a member of the parent group.
					var/datum/computer_file/data/account/A = computer.get_account()
					var/is_parent_member = (module.selected_parent_group in A.groups)
					if(is_parent_member || net_acl.has_access(module.get_access(user)))
						if(group_name in module.selected_account.groups)
							module.selected_account.groups -= group_name
						else
							module.selected_account.groups += group_name
					else
						to_chat(user, SPAN_WARNING("Access denied."))
						return TOPIC_HANDLED

				// Check to see if the account still has membership in a child group of the parent group and add to the parent groups list.
				if(!is_parent_group)
					for(var/group in module.selected_account.groups)
						if(LAZYISIN(group_dict[module.selected_parent_group], group_name))
							module.selected_account.parent_groups |= module.selected_parent_group
							return TOPIC_REFRESH
					module.selected_account.parent_groups -= module.selected_parent_group
				
			if(href_list["select_parent_group"])
				if(module.selected_parent_group)
					return TOPIC_REFRESH
				var/parent_group = href_list["select_parent_group"]
				if(parent_group in group_dict)
					// In order to see child group membership, you need submanagement access or direct ACL access.
					if(!net_acl.has_access(module.get_access(user)))
						if(net_acl.allow_submanagement)
							var/list/child_access = list("[parent_group].[network.network_id]")
							if(!has_access(child_access, module.get_access(user)))
								to_chat(user, SPAN_WARNING("Access denied."))
								return TOPIC_HANDLED
						else
							to_chat(user, SPAN_WARNING("Access denied."))
							return TOPIC_HANDLED
					module.selected_parent_group = parent_group
					return TOPIC_REFRESH
				return TOPIC_HANDLED

	if(href_list["back"])
		switch(module.prog_state)
			if(STATE_ERROR)
				module.prog_state = STATE_MENU
			if(STATE_SELF)
				module.prog_state = STATE_MENU
				module.selected_account = null
			if(STATE_OTHER)
				if(module.selected_parent_group)
					module.selected_parent_group = null
				else if(module.selected_account)
					module.selected_account = null
				else
					module.prog_state = STATE_MENU
		return TOPIC_REFRESH
	SSnano.update_uis(module)
	return 1

#undef STATE_ERROR
#undef STATE_MENU
#undef STATE_SELF
#undef STATE_OTHER