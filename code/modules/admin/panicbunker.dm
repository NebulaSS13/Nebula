var/global/list/panic_bunker_bypass = list()

/datum/admins/proc/panicbunker()
	set category = "Server"
	set name = "Toggle Panic Bunker"

	if(!check_rights(R_SERVER))
		return
	toggle_config_value(/decl/config/toggle/panic_bunker)
	log_and_message_admins("[key_name(usr)] has toggled the Panic Bunker, it is now [(get_config_value(/decl/config/toggle/panic_bunker) ? "on" : "off")]")
	if (get_config_value(/decl/config/toggle/panic_bunker) && (!dbcon || !dbcon.IsConnected()))
		message_admins("The SQL database is not connected, player age cannot be checked and the panic bunker will not function until the database connection is restored.")

/datum/admins/proc/addbunkerbypass(ckeytobypass as text)
	set category = "Server"
	set name = "Add Panic Bunker Bypass"
	set desc = "Allows a given ckey to connect despite the panic bunker for a given round."

	if(!check_rights(R_SERVER))
		return

	global.panic_bunker_bypass |= ckey(ckeytobypass)

	log_admin("[key_name(usr)] has added [ckeytobypass] to the current round's bunker bypass list.")
	message_admins("[key_name_admin(usr)] has added [ckeytobypass] to the current round's bunker bypass list.")

/datum/admins/proc/revokebunkerbypass(ckeytobypass in global.panic_bunker_bypass)
	set category = "Server"
	set name = "Revoke Panic Bunker Bypass"
	set desc = "Revoke's a ckey's permission to bypass the panic bunker for a given round."

	global.panic_bunker_bypass -= ckey(ckeytobypass)

	log_admin("[key_name(usr)] has removed [ckeytobypass] from the current round's bunker bypass list.")
	message_admins("[key_name_admin(usr)] has removed [ckeytobypass] from the current round's bunker bypass list.")
