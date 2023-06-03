// Notes on new tcomms system:
// - Telecomms hubs will initialize a list of channels based on the default map configuration
//   or their own initial channel list.
// - Radios will connect to the network and query all telecomms hubs for their channel information.
// - Radios contain encryption keys that in turn contain a list of access constants used to decide
//   whether or not the radio can send and receive traffic encrypted with those  access constants.
// - Radios will not retrieve and cannot broadcast on receive-only channels (such as Entertainment).
// - Network hubs or relays that share a z-chunk will share traffic on channels using the same name,
//   frequency and encryption (ex. a merc ship with a relay will relay merc Common to ship Common).

/datum/extension/network_device/telecomms_hub
	expected_type = /obj/machinery/network/telecomms_hub

/datum/extension/network_device/telecomms_hub/connect()
	. = ..()
	if(. && holder)
		var/datum/computer_network/net = SSnetworking.networks[network_id]
		if(net)
			LAZYADD(net.connected_hubs, weakref(holder))
		var/obj/machinery/network/telecomms_hub/hub = holder
		hub.update_icon()

/datum/extension/network_device/telecomms_hub/disconnect()
	var/datum/computer_network/net = SSnetworking.networks[network_id]
	. = ..()
	if(. && holder)
		if(net)
			LAZYREMOVE(net.connected_hubs, weakref(holder))
		var/obj/machinery/network/telecomms_hub/hub = holder
		hub.update_icon()

/datum/radio_channel
	var/name = "New channel"
	var/key
	var/frequency
	var/color
	var/secured
	var/span_class = ".syndradio"
	var/receive_only = FALSE

/datum/radio_channel/New(var/list/data)
	if(islist(data))
		if(!isnull(data["name"]))         name =         data["name"]
		if(!isnull(data["key"]))          key =          data["key"]
		if(!isnull(data["frequency"]))    frequency =    data["frequency"]
		if(!isnull(data["color"]))        color =        data["color"]
		if(!isnull(data["secured"]))      secured =      data["secured"]
		if(!isnull(data["span_class"]))   span_class =   data["span_class"]
		if(!isnull(data["receive_only"])) receive_only = data["receive_only"]

	if(key && (key in global.special_channel_keys))
		PRINT_STACK_TRACE("Comms channel '[name]' created with reserved key '[key]'.")

/obj/machinery/network/telecomms_hub
	name = "telecommunications hub"
	desc = "A black box network machine used to route comms traffic."
	density = TRUE
	anchored = TRUE
	construct_state = /decl/machine_construction/default/panel_closed
	base_type = /obj/machinery/network/telecomms_hub
	req_access = list(access_tcomsat)
	network_device_type = /datum/extension/network_device/telecomms_hub

	var/default_color = "#6d3f40"
	var/list/channels
	var/list/channels_by_key
	var/list/channels_by_frequency
	var/const/max_channels = 15
	var/outage_probability = 75
	var/overloaded_for = 0
	var/global_radio_broadcaster = FALSE

/obj/machinery/network/telecomms_hub/entertainment
	channels = list(list(
		"name" = "Entertainment",
		"key" = "z",
		"frequency" = 1461,
		"color" = COMMS_COLOR_ENTERTAIN,
		"span_class" = CSS_CLASS_RADIO
	))
	global_radio_broadcaster = TRUE

var/global/list/telecomms_hubs = list()
/obj/machinery/network/telecomms_hub/Initialize()

	global.telecomms_hubs += src
	. = ..()

	// Create our preloaded channels.
	if(isnull(channels))
		channels = global.using_map.default_telecomms_channels.Copy()
	if(length(channels))
		var/list/channel_data
		for(var/i = 1 to length(channels))
			var/datum/radio_channel/channel = new(channels[i])
			LAZYDISTINCTADD(channel_data, channel)
		channels = channel_data
	rebuild_channels()

	var/datum/extension/network_device/network_device = get_extension(src, /datum/extension/network_device)
	var/datum/computer_network/network = network_device?.get_network()
	for(var/weakref/R in network?.connected_radios)
		var/obj/item/radio/radio = R.resolve()
		if(istype(radio) && !QDELETED(radio))
			radio.sync_channels_with_network()

	// Pre-init an announcer for this Z-level.
	get_announcer(src)

/obj/machinery/network/telecomms_hub/Destroy()
	global.telecomms_hubs -= src
	. = ..()

/obj/machinery/network/telecomms_hub/proc/rebuild_channels()
	channels_by_frequency = null
	channels_by_key = null
	for(var/datum/radio_channel/channel in channels)
		if(channel.frequency)
			LAZYSET(channels_by_frequency, "[channel.frequency]", channel)
		if(channel.key)
			LAZYSET(channels_by_key, channel.key, channel)

/obj/machinery/network/telecomms_hub/Process()
	..()
	if(overloaded_for > 0)
		overloaded_for--

/// Accepts either a raw frequency (numeric), or or a frequency/key string, and returns the associated channel data.
/obj/machinery/network/telecomms_hub/proc/get_channel_from_freq_or_key(var/cid)
	cid = "[cid]"
	. = LAZYACCESS(channels_by_frequency, cid) || LAZYACCESS(channels_by_key, cid)

/obj/machinery/network/telecomms_hub/proc/can_receive_message(var/check_network_membership)
	. = operable() && (overloaded_for <= 0)
	if(. && check_network_membership)
		var/datum/extension/network_device/network_device = get_extension(src, /datum/extension/network_device)
		return network_device?.get_network() == check_network_membership

/obj/machinery/network/telecomms_hub/proc/get_recipients(list/levels, datum/computer_network/network, frequency)
	// TODO: cache this somehow. :( Generally make it cheaper.

	// Find the z-chunks we can broadcast to, which is our local chunk plus any overmap sites in range,
	// assuming we have a functioning comms maser and the overmap site has a telecomms hub and comms antenna.
	levels |= SSmapping.get_connected_levels(z)
	var/obj/effect/overmap/O = global.overmap_sectors["[z]"]
	for(var/obj/machinery/shipcomms/broadcaster/our_maser in O?.comms_masers)
		levels |= our_maser.get_available_z_levels()

	// Collect the hubs that are accessible from this hub's network.
	var/list/receiving_hubs = list()
	if(global_radio_broadcaster)
		receiving_hubs = global.telecomms_hubs
	else
		var/list/checked_networks = list()
		var/list/checking_networks =  list(network)
		// Collect networks from the local z-stack and any comms masers
		for(var/obj/machinery/network/telecomms_hub/other_hub in global.telecomms_hubs)
			if(!(other_hub.z in levels))
				continue
			var/datum/extension/network_device/other_network_device = get_extension(other_hub, /datum/extension/network_device)
			var/datum/computer_network/other_network = other_network_device?.get_network()
			if(other_network)
				checking_networks |= other_network
		while(length(checking_networks))
			var/datum/computer_network/check_network = checking_networks[1]
			checking_networks -= check_network
			checked_networks[check_network] = TRUE
			for(var/weakref/hub_ref as anything in check_network.connected_hubs)
				var/obj/machinery/network/telecomms_hub/other_hub = hub_ref.resolve()
				if(!istype(other_hub) || QDELETED(other_hub) || !other_hub.can_receive_message(FALSE))
					continue
				receiving_hubs |= other_hub
				for(var/network_id in SSnetworking.networks)
					var/datum/computer_network/internet_connection = check_network.get_internet_connection(network_id, NET_FEATURE_COMMUNICATION)
					if(internet_connection && !checked_networks[internet_connection])
						checking_networks |= internet_connection

	// Check if the hubs we can reach are capable of broadcasting our channel.
	// If they are, collect their network for the actual broadcast checks.
	var/list/receiving_networks = list()
	var/datum/radio_channel/channel = get_channel_from_freq_or_key(frequency)
	for(var/obj/machinery/network/telecomms_hub/other_hub in receiving_hubs)
		var/datum/radio_channel/other_channel = other_hub.get_channel_from_freq_or_key(frequency)
		if(!other_channel || other_channel.name != channel.name)
			continue
		if(islist(other_channel.secured) && islist(channel.secured))
			for(var/access_req in other_channel.secured)
				if(!(access_req in channel.secured))
					continue
			for(var/access_req in channel.secured)
				if(!(access_req in other_channel.secured))
					continue
		var/datum/extension/network_device/other_network_device = get_extension(other_hub, /datum/extension/network_device)
		var/datum/computer_network/other_network = other_network_device?.get_network()
		if(other_network)
			receiving_networks |= other_network

	// Broadcast to all radio devices in the receiving networks.
	for(var/datum/computer_network/use_network in receiving_networks)
		var/datum/radio_channel/other_channel = channel
		if (use_network != network)
			for(var/weakref/other_hub_ref in use_network.connected_hubs)
				var/obj/machinery/network/telecomms_hub/other_hub = other_hub_ref.resolve()
				if(other_hub)
					other_channel = other_hub.get_channel_from_freq_or_key("[channel.frequency]")
		for(var/weakref/W as anything in use_network.connected_radios)
			var/obj/item/radio/R = W.resolve()
			if(!istype(R) || QDELETED(R) || !R.can_receive_message(use_network))
				continue
			var/turf/speaking_from = get_turf(R)
			if(!speaking_from)
				continue
			if(!other_channel || !R.can_decrypt(other_channel.secured))
				continue
			var/list/check_channels = R.get_available_channels()
			if(!LAZYACCESS(check_channels, other_channel))
				continue
			var/turf/T = get_turf(R)
			var/overmap_object = istype(T) && global.overmap_sectors["[T.z]"]
			for(var/mob/M in hearers(R.canhear_range, speaking_from))
				LAZYSET(., M, overmap_object)

	for(var/mob/observer/ghost/ghost_listener as anything in global.ghost_mob_list)
		// Ghostship is magic: Ghosts can hear radio chatter from anywhere
		if(ghost_listener.get_preference_value(/datum/client_preference/ghost_radio) == PREF_ALL_CHATTER)
			LAZYSET(., ghost_listener, TRUE) // no overmap object, but tell us which the source is anyway

/obj/machinery/network/telecomms_hub/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)

	var/list/data = list()
	var/datum/extension/network_device/device = get_extension(src, /datum/extension/network_device)
	data["network_id"] = device.network_tag
	data["authenticated"] = (access_keycard_auth in user.GetAccess())
	var/list/data_channels = list()
	for(var/datum/radio_channel/channel_datum in channels)
		var/list/channel_data = list()
		channel_data["channel_name"] =   channel_datum.name
		channel_data["channel_freq"] =   channel_datum.frequency
		channel_data["channel_key"] =    channel_datum.key
		channel_data["channel_color"] = channel_datum.color || COLOR_BLACK
		if(channel_datum.secured)
			channel_data["channel_access"] = jointext(channel_datum.secured, " ")
		else
			channel_data["channel_access"] = "PUBLIC"
		channel_data["channel_ref"] =    "\ref[channel_datum]"
		data_channels += list(channel_data)
	data["channels"] = data_channels
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "telecomms_hub.tmpl", "Telecommunications Hub")
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/network/telecomms_hub/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/network/telecomms_hub/OnTopic(mob/user, href_list, datum/topic_state/state)
	. = ..()
	if(!.)
		if(href_list["channel"])
			var/datum/radio_channel/channel_datum = locate(href_list["channel"])
			if(!istype(channel_datum) || !(channel_datum in channels))
				. = TOPIC_HANDLED
			else

				if(href_list["change_name"])
					var/new_name = input(user, "Enter a new channel name.", "Channel Configuration", channel_datum.name) as text|null
					new_name = sanitize(new_name, MAX_NAME_LEN)
					if(new_name != channel_datum.name && new_name && CanPhysicallyInteract(user))
						channel_datum.name = new_name
						. = TOPIC_REFRESH

				if(href_list["change_key"])
					var/new_key = lowertext(input(user, "Enter a new key character.", "Channel Configuration", channel_datum.key) as text|null)
					new_key = sanitize(new_key, 1)
					if(new_key != channel_datum.key && new_key && CanPhysicallyInteract(user))
						if(new_key in global.special_channel_keys)
							to_chat(user, SPAN_WARNING("You may not use any of the following keys: [english_list(global.special_channel_keys)]."))
							return
						channel_datum.key = new_key
						rebuild_channels()
						. = TOPIC_REFRESH

				if(href_list["change_freq"])

					var/lower_freq
					var/upper_freq
					if(access_keycard_auth in user.GetAccess())
						lower_freq = RADIO_LOW_FREQ
						upper_freq = RADIO_HIGH_FREQ
					else
						lower_freq = PUBLIC_LOW_FREQ
						upper_freq = PUBLIC_HIGH_FREQ

					var/new_freq = input(user, "Enter a new frequency beween [lower_freq] and [upper_freq].", "Channel Configuration", channel_datum.frequency) as num

					if(access_keycard_auth in user.GetAccess())
						lower_freq = RADIO_LOW_FREQ
						upper_freq = RADIO_HIGH_FREQ
					else
						lower_freq = PUBLIC_LOW_FREQ
						upper_freq = PUBLIC_HIGH_FREQ
					new_freq = clamp(new_freq, lower_freq, upper_freq)

					if(new_freq != channel_datum.frequency && new_freq && CanPhysicallyInteract(user))
						channel_datum.frequency = new_freq
						rebuild_channels()
						. = TOPIC_REFRESH

				if(href_list["change_colour"])
					var/new_color = input(user, "Select a new display colour.", "Channel Configuration", channel_datum.color) as null|anything in global.telecomms_colours
					if(new_color  && new_color != channel_datum.color && new_color && CanPhysicallyInteract(user))
						channel_datum.color = new_color
						. = TOPIC_REFRESH

				if(href_list["change_access"])
					var/choice = input(user, "How do you wish to modify the channel encryption?", "Channel Configuration") as null|anything in list("Add", "Remove", "Clear", "Sync to personal access")
					if(choice && CanPhysicallyInteract(user))
						switch(choice)
							if("Add")
								choice = input(user, "Which access do you wish to add?", "Channel Configuration") as null|anything in get_all_station_access()
								if(choice && CanPhysicallyInteract(user))
									LAZYDISTINCTADD(channel_datum.secured, choice)
							if("Remove")
								if(!LAZYLEN(channel_datum.secured))
									to_chat(user, SPAN_WARNING("[channel_datum.name] has no access to remove."))
								else
									choice = input(user, "Which key do you wish to remove?", "Channel Configuration") as null|anything in channel_datum.secured
									if(choice && CanPhysicallyInteract(user))
										LAZYREMOVE(channel_datum.secured, choice)
							if("Clear")
								channel_datum.secured = null
							if("Sync to personal access")
								var/list/new_access = user.GetAccess()
								channel_datum.secured = (new_access && new_access.Copy())
						. = TOPIC_REFRESH

				if(href_list["delete_channel"])
					var/confirm = alert(user, "Are you sure you want to delete the [channel_datum.name] channel? This action is not reversible.", "Channel Deletion", "No", "Yes") == "Yes"
					if(confirm && CanPhysicallyInteract(user))
						LAZYREMOVE(channels, channel_datum)
						rebuild_channels()
						. = TOPIC_REFRESH

		if(href_list["new_channel"])
			if(LAZYLEN(channels) >= max_channels)
				to_chat(user, SPAN_WARNING("\The [src] has no available configuration slots for new channels."))
				. = TOPIC_HANDLED
			else
				LAZYADD(channels, new /datum/radio_channel)
				rebuild_channels()
				. = TOPIC_REFRESH

		if(href_list["factory_reset"])
			var/confirm = alert(user, "Are you sure you want to perform a factory reset? This action is not reversible.", "Factory Reset", "No", "Yes") == "Yes"
			if(confirm && CanPhysicallyInteract(user))
				channels_by_frequency = null
				channels_by_key = null
				channels = initial(channels) || global.using_map.default_telecomms_channels.Copy()
				var/list/channel_data
				for(var/i = 1 to length(channels))
					var/datum/radio_channel/channel = new(channels[i])
					LAZYDISTINCTADD(channel_data, channel)
				channels = channel_data
				rebuild_channels()
				. = TOPIC_REFRESH
