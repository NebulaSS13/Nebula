/datum/computer_network/proc/get_accounts(accesses)
	var/list/result = list()
	for(var/datum/extension/network_device/mainframe/M in get_mainframes_by_role(MF_ROLE_ACCOUNT_SERVER, accesses))
		for(var/datum/computer_file/data/account/E in M.get_all_files())
			if(E.backup)
				continue
			ADD_SORTED(result, E, /proc/cmp_accounts_asc)
	return result

/datum/computer_network/proc/get_accounts_unsorted(accesses)
	var/list/result = list()
	for(var/datum/extension/network_device/mainframe/M in get_mainframes_by_role(MF_ROLE_ACCOUNT_SERVER, accesses))
		for(var/datum/computer_file/data/account/E in M.get_all_files())
			if(E.backup)
				continue
			result |= E
	return result

// Return account backups keyed by account login
/datum/computer_network/proc/get_account_backups(accesses)
	var/list/result = list()
	for(var/datum/extension/network_device/mainframe/M in get_mainframes_by_role(MF_ROLE_ACCOUNT_SERVER, accesses))
		for(var/datum/computer_file/data/account/E in M.get_all_files())
			if(E.login in result)
				continue
			if(E.backup)
				result[E.login] = E

	return result

/datum/computer_network/proc/add_account(datum/computer_file/data/account/acc, accesses)
	for(var/datum/extension/network_device/mainframe/M in get_mainframes_by_role(MF_ROLE_ACCOUNT_SERVER, accesses))
		if(M.store_file(acc, OS_ACCOUNTS_DIR, TRUE))
			return TRUE

/datum/computer_network/proc/find_account_by_login(login, accesses)
	for(var/datum/computer_file/data/account/A in get_accounts(accesses))
		if(A.login == login)
			return A

/datum/computer_network/proc/create_account(mob/user, desired_login, desired_password, full_name, list/accesses, force_create = TRUE)
	desired_login = sanitize_for_account(desired_login)
	var/login = "[desired_login]"
	if(!length(login))
		return FALSE
	if(find_account_by_login(login))
		if(force_create)
			login = "[desired_login][random_id(/datum/computer_file/data/account/, 100, 999)]"
		else
			return FALSE
	if(!desired_password)
		if(force_create)
			desired_password = GenerateKey()
	var/datum/computer_file/data/account/EA = new/datum/computer_file/data/account(login, desired_password, full_name)
	if(add_account(EA, accesses))
		if(user)
			user.store_account_credentials(EA.login, EA.password, network_id)
		return TRUE
	return FALSE

/datum/computer_network/proc/rename_account(old_login, desired_login)
	var/datum/computer_file/data/account/account = find_account_by_login(old_login)
	var/new_login = sanitize_for_account(desired_login)
	if(new_login == old_login)
		return TRUE//If we aren't going to be changing the login, we quit silently.
	if(find_account_by_login(new_login))
		return FALSE
	account.login = new_login
	add_log("Account login changed: [old_login] changed to [new_login]")

// Mob procs
/mob/proc/store_account_credentials(login, password, network_id)
	if(mind)
		mind.initial_account_login["login"] = login
		mind.initial_account_login["password"] = password
		mind.account_network = network_id
	StoreMemory("Your [network_id] login is [login] and the password is [password].", /decl/memory_options/system)
	var/obj/item/card/id/I = GetIdCard()
	if(I)
		I.associated_network_account = list("login" = login, "password" = password)

/mob/proc/create_or_update_account(newname)
	if(!mind)
		return
	var/datum/computer_network/network = get_local_network_at(get_turf(src))
	if(network)
		var/old_account = mind.initial_account_login["login"]
		if(!old_account)
			network.create_account(src, newname)
		else
			network.rename_account(old_account, newname)