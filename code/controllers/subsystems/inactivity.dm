SUBSYSTEM_DEF(inactivity)
	name = "Inactivity"
	wait = 1 MINUTE
	priority = SS_PRIORITY_INACTIVITY
	flags = SS_NO_INIT
	var/tmp/list/client_list
	var/number_kicked = 0

/datum/controller/subsystem/inactivity/fire(resumed = FALSE)
	var/kick_inactive_time = get_config_value(/decl/config/num/kick_inactive) MINUTES
	if (!kick_inactive_time)
		suspend()
		return
	if (!resumed)
		client_list = global.clients.Copy()

	while(client_list.len)
		var/client/C = client_list[client_list.len]
		client_list.len--
		if(!C.holder && C.is_afk(kick_inactive_time) && !isobserver(C.mob))
			log_access("AFK: [key_name(C)]")
			to_chat(C, SPAN_WARNING("You have been inactive for more than [kick_inactive_time] minute\s and have been disconnected."))
			qdel(C)
			number_kicked++
		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/inactivity/stat_entry()
	..("Kicked: [number_kicked]")