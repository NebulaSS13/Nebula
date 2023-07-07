// Notes on new tcomms system:
// - Telecomms hubs will initialize a list of channels based on the default map configuration
//   or their own initial channel list.
// - Radios will connect to the network and query all telecomms hubs for their channel information.
// - Radios contain encryption keys that in turn contain a list of access constants used to decide
//   whether or not the radio can send and receive traffic encrypted with those  access constants.
// - Radios will not retrieve and cannot broadcast on receive-only channels (such as Entertainment).
// - Network hubs that share a z-chunk or are connected via masers and receivers will share traffic
//   on channels using the same frequency (ex. a merc ship with a relay will relay merc Common to ship Common).
//   Each network hub a message "passes" through will add its encryption to the message.

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
	var/allow_external_signals = TRUE // Whether or not the telecomms hub will route signals from other networks

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

/obj/machinery/network/telecomms_hub/proc/transmit_message(mob/speaker, message, message_verb, decl/language/speaking, frequency, message_compression, list/checked_hubs, list/encryption = list(), obj/effect/overmap/send_overmap_object, chain_transmit = TRUE)
	if(src in checked_hubs)
		return
	checked_hubs += src

	var/datum/extension/network_device/network_device = get_extension(src, /datum/extension/network_device)
	var/datum/computer_network/network = network_device?.get_network()
	if(!network)
		return
	// TODO: cache this somehow. :( Generally make it cheaper.
	var/datum/radio_channel/channel = get_channel_from_freq_or_key(frequency)
	if(!channel) // We don't have a channel corresponding to this frequency, don't send any messages or chain transmit
		return

	if(!send_overmap_object)
		var/turf/T = get_turf(src)
		send_overmap_object = istype(T) && global.overmap_sectors["[T.z]"]

	if(channel.secured)
		encryption |= channel.secured

	var/formatted_msg = "<span style='color:[channel?.color || default_color]'><small><b>\[[channel?.name || format_frequency(frequency)]\]</b></small> <span class='name'>"
	var/send_name = istype(speaker) ? speaker.real_name : ("[speaker]" || "unknown")
	var/overmap_send_name = "[send_name] ([send_overmap_object.name])"

	var/list/listeners = list() // Dictionary of listener -> boolean (include overmap origin)

	// Broadcast to all radio devices in our network.
	for(var/weakref/W as anything in network.connected_radios)
		var/obj/item/radio/R = W.resolve()
		if(!istype(R) || QDELETED(R) || !R.can_receive_message(network))
			continue
		var/turf/speaking_from = get_turf(R)
		if(!speaking_from)
			continue
		if(!R.can_decrypt(encryption))
			continue
		// TODO: This check seems extraneous, given how headsets find their available channels.
		var/list/check_channels = R.get_available_channels()
		if(!LAZYACCESS(check_channels, channel))
			continue

		var/listener_overmap_object = istype(speaking_from) && global.overmap_sectors["[speaking_from.z]"]
		for(var/mob/listener in hearers(R.canhear_range, speaking_from))
			// If we're sending from an overmap object AND our overmap object transmits its identity AND it's different than the listener's
			// then append the overmap object name to it, so they know where we're from
			var/send_overmap = send_overmap_object && send_overmap_object.ident_transmitter && send_overmap_object != listener_overmap_object
			LAZYSET(listeners, listener, send_overmap)

	// Ghostship is magic: Ghosts can hear radio chatter from anywhere
	for(var/mob/observer/ghost/ghost_listener as anything in global.ghost_mob_list)
		if(ghost_listener.get_preference_value(/datum/client_preference/ghost_radio) == PREF_ALL_CHATTER)
			LAZYSET(listeners, ghost_listener, TRUE)

	for(var/mob/listener in listeners)
		var/per_listener_send_name = listeners[listener] ? overmap_send_name : send_name
		listener.hear_radio(message, message_verb, speaking, formatted_msg, "</span> <span class='message'>", "</span></span>", speaker, message_compression, per_listener_send_name)

	if(!chain_transmit)
		return

	// Collect the hubs that are accessible from this hub's network.
	var/list/receiving_hubs = list()
	if(global_radio_broadcaster)
		receiving_hubs = global.telecomms_hubs
	else
		// Find the z-chunks we can chain the transmission to, which is our local chunk plus any overmap sites in range,
		// assuming we have a functioning comms maser and the overmap site has a telecomms hub and comms antenna.
		var/list/levels = SSmapping.get_connected_levels(z)
		var/obj/effect/overmap/O = global.overmap_sectors["[z]"]
		for(var/obj/machinery/shipcomms/broadcaster/our_maser in O?.comms_masers)
			levels |= our_maser.get_available_z_levels()

		// Add the hubs available via masers/receivers.
		for(var/obj/machinery/network/telecomms_hub/other_hub in global.telecomms_hubs)
			if(!(other_hub.z in levels) || other_hub == src)
				continue
			if(weakref(other_hub) in network.connected_hubs)
				continue
			receiving_hubs |= other_hub

		// Add the hubs available via PLEXUS connection.
		for(var/other_network in SSnetworking.networks)
			if(other_network == network.network_id)
				continue
			var/datum/computer_network/internet_connection = network.get_internet_connection(other_network, NET_FEATURE_COMMUNICATION)
			if(internet_connection)
				for(var/weakref/hub_ref in internet_connection.connected_hubs)
					var/obj/machinery/network/telecomms_hub/other_hub = hub_ref.resolve()
					if(istype(other_hub))
						receiving_hubs |= other_hub

	receiving_hubs = receiving_hubs - checked_hubs

	for(var/obj/machinery/network/telecomms_hub/other_hub in receiving_hubs)
		var/check_network_membership = other_hub.allow_external_signals ? FALSE : network
		if(QDELETED(other_hub) || !other_hub.can_receive_message(check_network_membership))
			continue
		// Don't allow further chaining of the message.
		other_hub.transmit_message(speaker, message, message_verb, speaking, frequency, message_compression, checked_hubs, encryption.Copy(), send_overmap_object, FALSE)

/obj/machinery/network/telecomms_hub/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)

	var/list/data = list()
	var/datum/extension/network_device/device = get_extension(src, /datum/extension/network_device)
	data["network_id"] = device.network_tag
	data["authenticated"] = (access_keycard_auth in user.GetAccess())
	data["allow_external"] = allow_external_signals
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
		ui = new(user, src, ui_key, "telecomms_hub.tmpl", "Telecommunications Hub", 700, 400)
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
						if(channels_by_frequency && ("[new_freq]" in channels_by_frequency))
							to_chat(user, SPAN_WARNING("A channel with this frequency already exists."))
							return TOPIC_HANDLED
						channel_datum.frequency = new_freq
						rebuild_channels()
						. = TOPIC_REFRESH

				if(href_list["change_colour"])
					var/new_colour = input(user, "Select a new display colour.", "Channel Configuration") as null|anything in global.telecomms_colours
					if(new_colour && CanPhysicallyInteract(user))
						channel_datum.color = global.telecomms_colours[new_colour]
						. = TOPIC_REFRESH

				if(href_list["change_access"])
					var/choice = input(user, "How do you wish to modify the channel encryption?", "Channel Configuration") as null|anything in list("Add", "Remove", "Add Network Group", "Clear", "Sync to personal access")
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
							if("Add Network Group")
								var/datum/extension/network_device/network_device = get_extension(src, /datum/extension/network_device)
								var/datum/computer_network/network = network_device?.get_network()
								if(!network)
									to_chat(user, SPAN_WARNING("Unable to connect to the network."))
									return TOPIC_HANDLED

								var/datum/extension/network_device/acl/net_acl = network.access_controller
								if(!net_acl)
									to_chat(user, SPAN_WARNING("No access controller on the network."))
									return

								var/list/all_groups = net_acl.get_all_groups()
								if(!length(all_groups))
									to_chat(user, SPAN_WARNING("No groups were found on the network access controller"))
									return TOPIC_HANDLED

								choice = input(user, "Which group do you wish to add? Adding a parent group will allow all members of its children groups to access the channel.", "Channel Configuration") as null|anything in all_groups
								if(choice && CanPhysicallyInteract(user))
									LAZYDISTINCTADD(channel_datum.secured, choice + ".[network.network_id]")
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

		if(href_list["toggle_external"])
			allow_external_signals = !allow_external_signals
			return TOPIC_REFRESH