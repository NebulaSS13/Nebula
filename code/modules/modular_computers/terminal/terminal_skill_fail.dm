var/global/list/terminal_fails
/proc/get_terminal_fails()
	if(!global.terminal_fails)
		global.terminal_fails = init_subtypes(/datum/terminal_skill_fail)
	return global.terminal_fails

/datum/terminal_skill_fail
	var/weight = 1
	var/message

/datum/terminal_skill_fail/proc/can_run(mob/user, datum/terminal/terminal)
	return 1

/datum/terminal_skill_fail/proc/execute(datum/terminal/terminal)
	return message

/datum/terminal_skill_fail/no_fail
	weight = 10

/datum/terminal_skill_fail/random_ban/unban
	message = "Entered id successfully unbanned!"

/datum/terminal_skill_fail/random_ban/unban/execute(datum/terminal/terminal)
	var/datum/computer_network/network = terminal.computer.get_network()
	if(network)
		var/id = pick_n_take(network.banned_nids)
		if(id)
			return ..()

/datum/terminal_skill_fail/random_ban/email_logs
	weight = 2
	message = "System log backup successful. Chosen method: email attachment. Recipients: all."

/datum/terminal_skill_fail/random_ban/email_logs/execute(datum/terminal/terminal)
	var/datum/computer_network/network = terminal.computer.get_network()
	if(!network)
		return ..()
	var/list/logs = network.get_log_files()
	if(!length(logs))
		return ..()
	var/fulldata = ""
	for(var/datum/computer_file/data/L in logs)
		fulldata += L.generate_file_data()
	var/datum/computer_file/data/account/server = network.find_account_by_login(EMAIL_DOCUMENTS)
	if(!server)
		return
	for(var/datum/computer_file/data/account/email in network.get_accounts_unsorted())
		if(!email.can_login || email.suspended)
			continue
		var/datum/computer_file/data/email_message/message = new()
		message.title = "IMPORTANT NETWORK ALERT!"
		message.stored_data = fulldata
		message.source = server.login
		network.send_email(server, email.login, message)
	return ..()