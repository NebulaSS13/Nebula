/datum/computer_network/proc/get_email_addresses()
	var/list/result = list()
	for(var/datum/extension/network_device/mainframe/M in get_mainframes_by_role(MF_ROLE_EMAIL_SERVER))
		for(var/datum/computer_file/data/email_account/E in M.get_all_files())
			ADD_SORTED(result, E, /proc/cmp_emails_asc)
	return result

/datum/computer_network/proc/add_email_account(datum/computer_file/data/email_account/acc)
	for(var/datum/extension/network_device/mainframe/M in get_mainframes_by_role(MF_ROLE_EMAIL_SERVER))
		if(M.store_file(acc))
			return TRUE

/datum/computer_network/proc/find_email_by_name(var/login)
	for(var/datum/computer_file/data/email_account/A in get_email_addresses())
		if(A.login == login)
			return A

/datum/computer_network/proc/create_email(mob/user, desired_name, domain, assignment)
	desired_name = sanitize_for_email(desired_name)
	var/login = "[desired_name]@[domain]"
	if(find_email_by_name(login))
		login = "[desired_name][random_id(/datum/computer_file/data/email_account/, 100, 999)]@[domain]"
	
	var/datum/computer_file/data/email_account/EA = new/datum/computer_file/data/email_account(login, user.real_name, assignment)
	EA.password = GenerateKey()
	add_email_account(EA)
	user.store_email_credentials(EA.login, EA.password)

/datum/computer_network/proc/rename_email(mob/user, old_login, desired_name, domain)
	var/datum/computer_file/data/email_account/account = find_email_by_name(old_login)
	var/new_login = sanitize_for_email(desired_name)
	new_login += "@[domain]"
	if(new_login == old_login)
		return	//If we aren't going to be changing the login, we quit silently.
	if(find_email_by_name(new_login))
		to_chat(user, "Your email could not be updated: the new username is invalid.")
		return
	account.login = new_login
	add_log("Email address changed for [user]: [old_login] changed to [new_login]")
	user.update_email_name(new_login)


// Mob procs
/mob/proc/store_email_credentials(login, password)
	if(mind)
		mind.initial_email_login["login"] = login
		mind.initial_email_login["password"] = password
	StoreMemory("Your email account address is [login] and the password is [password].", /decl/memory_options/system)
	var/obj/item/card/id/I = GetIdCard()
	if(I)
		I.associated_email_login = list("login" = login, "password" = password)

/mob/proc/update_email_name(login)
	if(mind)
		mind.initial_email_login["login"] = login
	StoreMemory("Your email account address has been changed to [login].", /decl/memory_options/system)
	var/obj/item/card/id/I = GetIdCard()
	if(I && I.associated_email_login)
		I.associated_email_login["login"] = login

/mob/proc/create_or_rename_email(newname, domain)
	if(!mind)
		return
	var/datum/computer_network/network = get_local_network_at(get_turf(src))
	if(network)
		var/old_email = mind.initial_email_login["login"]
		if(!old_email)
			network.create_email(src, newname, domain)
		else
			network.rename_email(src, old_email, newname, domain)