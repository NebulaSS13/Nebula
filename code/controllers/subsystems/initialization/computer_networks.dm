#define MAX_CONNECTION_ATTEMPTS 5

/datum/proc/handle_post_network_connection()
	return

SUBSYSTEM_DEF(networking)
	name = "Computer Networks"
	priority = SS_PRIORITY_COMPUTER_NETS
	flags = SS_BACKGROUND | SS_NO_INIT
	wait = 2 SECOND
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT

	var/list/networks = list()
	var/list/connection_queue = list()
	var/list/tmp_queue = list()

/datum/controller/subsystem/networking/fire(resumed = FALSE)
	if(!resumed)
		tmp_queue = connection_queue.Copy()
		connection_queue = list()
	while(tmp_queue.len)
		var/datum/extension/network_device/device = tmp_queue[tmp_queue.len]
		tmp_queue.len--

		if(!QDELETED(device))
			var/connected
			if(device.network_id)
				connected = device.connect()
			else
				connected = device.connect_to_any()
			if(connected)
				device.holder?.handle_post_network_connection()
				device.connection_attempts = 0
			else
				if(device.connection_attempts < MAX_CONNECTION_ATTEMPTS)
					device.connection_attempts++
					connection_queue += device
				else // Maximum connection attempts reached. Do not readd to the queue.
					device.connection_attempts = 0
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/networking/stat_entry()
	..("[length(networks)] network\s, [length(connection_queue)] connection\s queued")

/datum/controller/subsystem/networking/proc/queue_connection(var/datum/extension/network_device/device)
	connection_queue |= device

#undef MAX_CONNECTION_ATTEMPTS