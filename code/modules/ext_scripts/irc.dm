/proc/send2irc(var/channel, var/msg)
	export2irc(list(type="msg", mesg=msg, chan=channel, pwd=get_config_value(/decl/config/text/comms_password)))

/proc/export2irc(params)
	if(!get_config_value(/decl/config/toggle/use_irc_bot))
		return
	var/irc_bot_host = get_config_value(/decl/config/text/irc_bot_host)
	if(irc_bot_host)
		spawn(-1) // spawn here prevents hanging in the case that the bot isn't reachable
			world.Export("http://[irc_bot_host]:45678?[list2params(params)]")

/proc/runtimes2irc(runtimes, revision)
	export2irc(list(pwd=get_config_value(/decl/config/text/comms_password), type="runtime", runtimes=runtimes, revision=revision))

/proc/send2mainirc(var/msg)
	var/main_irc = get_config_value(/decl/config/text/main_irc)
	if(main_irc)
		send2irc(main_irc, msg)
	return

/proc/send2adminirc(var/msg)
	var/admin_irc = get_config_value(/decl/config/text/admin_irc)
	if(admin_irc)
		send2irc(admin_irc, msg)
	return

/proc/adminmsg2adminirc(client/source, client/target, msg)
	var/admin_irc = get_config_value(/decl/config/text/admin_irc)
	if(admin_irc)
		var/list/params[0]

		params["pwd"] = get_config_value(/decl/config/text/comms_password)
		params["chan"] = admin_irc
		params["msg"] = msg
		params["src_key"] = source.key
		params["src_char"] = source.mob.real_name || source.mob.name
		if(!target)
			params["type"] = "adminhelp"
		else if(istext(target))
			params["type"] = "ircpm"
			params["target"] = target
			params["rank"] = source.holder ? source.holder.rank : "Player"
		else
			params["type"] = "adminpm"
			params["trg_key"] = target.key
			params["trg_char"] = target.mob.real_name || target.mob.name

		export2irc(params)

/proc/get_world_url()
	return "byond://[get_config_value(/decl/config/text/server) || get_config_value(/decl/config/text/serverurl) || "[world.address]:[world.port]"]"

/hook/startup/proc/ircNotify()
	send2mainirc("Server starting up on [get_world_url()]")
	return 1
