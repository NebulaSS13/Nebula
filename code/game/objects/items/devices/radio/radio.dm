/datum/extension/network_device/radio
	expected_type = /obj/item/radio

/datum/extension/network_device/radio/connect()
	. = ..()
	if(. && holder)
		var/datum/computer_network/net = SSnetworking.networks[network_id]
		if(net)
			LAZYADD(net.connected_radios, weakref(holder))
		var/obj/item/radio/radio = holder
		radio.update_icon()

/datum/extension/network_device/radio/disconnect()
	var/datum/computer_network/net = SSnetworking.networks[network_id]
	. = ..()
	if(. && holder)
		if(net)
			LAZYREMOVE(net.connected_radios, weakref(holder))
		var/obj/item/radio/radio = holder
		radio.update_icon()

/obj/item/radio
	name = "dual-band radio"
	desc = "A radio that can transmit in analog or digital modes."
	icon = 'icons/obj/items/device/radio/radio.dmi'
	suffix = "\[3\]"
	icon_state = "walkietalkie"
	item_state = "walkietalkie"

	var/intercom = FALSE // If an intercom, will receive data == 1 packets.
	var/virtual =  FALSE // If virtual, will receive all broadcasts but will never notify nearby listeners.

	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_LOWER_BODY
	throw_speed = 2
	throw_range = 9
	w_class = ITEM_SIZE_SMALL
	material = /decl/material/solid/metal/aluminium
	matter = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)

	var/obj/item/cell/cell = /obj/item/cell/device
	var/power_usage = 2800
	var/last_radio_sound = -INFINITY
	var/initial_network_id
	var/initial_network_key

	var/datum/wires/radio/wires = null
	var/panel_open = FALSE
	var/list/encryption_keys
	var/encryption_key_capacity

	var/on = TRUE
	var/frequency = PUB_FREQ
	var/intercom_handling = FALSE
	var/traitor_frequency = 0 //tune to frequency to unlock traitor supplies
	var/canhear_range = 3 // the range which mobs can hear this radio from
	var/broadcasting = FALSE
	var/listening = TRUE
	var/list/channels
	var/default_color = "#6d3f40"
	var/decrypt_all_messages = FALSE
	var/can_use_analog = TRUE
	var/datum/extension/network_device/radio/radio_device_type = /datum/extension/network_device/radio
	var/analog = FALSE
	var/analog_secured = list() // list of accesses used for encrypted analog, mainly for mercs/raiders
	var/datum/radio_frequency/analog_radio_connection

/obj/item/radio/get_radio(var/message_mode)
	return src

/obj/item/radio/proc/can_decrypt(var/list/secured)
	if(decrypt_all_messages)
		return TRUE
	if(!secured || !length(secured))
		return TRUE
	if(!islist(secured))
		secured = list(secured)
	var/list/needed_access = secured.Copy()
	for(var/obj/item/encryptionkey/key in encryption_keys)
		needed_access -= key.can_decrypt
		if (!length(needed_access))
			return TRUE
	return FALSE // not all keys were removed

/obj/item/radio/proc/set_frequency(new_frequency)
	if(analog_radio_connection)
		radio_controller.remove_object(src, frequency)
		analog_radio_connection = null
	frequency = new_frequency
	if(analog && frequency)
		analog_radio_connection = radio_controller.add_object(src, frequency, RADIO_CHAT)

/obj/item/radio/Initialize()
	. = ..()
	wires = new(src)
	if(ispath(cell))
		cell = new(src)

	global.listening_objects += src
	set_frequency(sanitize_frequency(frequency, RADIO_LOW_FREQ, RADIO_HIGH_FREQ))
	if(radio_device_type)
		set_extension(src, /datum/extension/network_device/radio, initial_network_id, initial_network_key, RECEIVER_STRONG_WIRELESS)

	var/list/created_encryption_keys
	for(var/keytype in encryption_keys)
		LAZYADD(created_encryption_keys, new keytype(src))
	encryption_keys = created_encryption_keys

/obj/item/radio/proc/get_available_channels()
	if(!channels)
		sync_channels_with_network()
	return channels

/obj/item/radio/proc/sync_channels_with_network()
	channels = null
	var/datum/extension/network_device/network_device = get_extension(src, /datum/extension/network_device)
	var/datum/computer_network/network = network_device?.get_network()
	for(var/weakref/H as anything in network?.connected_hubs)
		var/obj/machinery/network/telecomms_hub/hub = H.resolve()
		if(!istype(hub) || QDELETED(hub) || !hub.can_receive_message(network) || !length(hub.channels))
			continue
		for(var/datum/radio_channel/channel in hub.channels)
			if(channel.receive_only)
				continue
			if(can_decrypt(channel.secured))
				LAZYSET(channels, channel, TRUE)

/obj/item/radio/Destroy()
	QDEL_NULL(wires)
	QDEL_NULL_LIST(encryption_keys)
	global.listening_objects -= src
	set_frequency(null) // clean up the radio connection
	channels = null
	. = ..()

/obj/item/radio/attack_self(mob/user)
	if(!user.check_dexterity(DEXTERITY_SIMPLE_MACHINES))
		return
	user.set_machine(src)
	add_fingerprint(user)
	interact(user)
	return TRUE

/obj/item/radio/interact(mob/user)
	if(!user)
		return FALSE
	if(panel_open)
		wires.Interact(user)
	return ui_interact(user)

/obj/item/radio/proc/sanitize_analog_secured()
	var/list/collected_access = list()
	for(var/obj/item/encryptionkey/other_key in encryption_keys)
		collected_access |= other_key.can_decrypt
	analog_secured &= collected_access

/obj/item/radio/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]

	var/datum/extension/network_device/network_device = get_extension(src, /datum/extension/network_device)
	if(network_device)
		var/datum/computer_network/network = network_device?.get_network()
		data["network"] = "[network_device.network_tag] ([network ? network.network_id : "disconnected"])"
	data["can_use_analog"] = can_use_analog
	data["analog"] = analog
	data["analog_secured"] = analog_secured
	var/list/collected_access = list()
	for(var/obj/item/encryptionkey/other_key in encryption_keys)
		collected_access |= other_key.can_decrypt
	data["available_keys"] = collected_access
	data["mic_status"] = broadcasting
	data["speaker"] = listening
	data["freq"] = format_frequency(frequency)
	data["rawfreq"] = "[frequency]"
	var/obj/item/cell/has_cell = get_cell()
	if(has_cell)
		var/charge = round(has_cell.percent())
		data["charge"] = charge ? "[charge]%" : "NONE"
	data["mic_cut"] = (wires.IsIndexCut(WIRE_TRANSMIT) || wires.IsIndexCut(WIRE_SIGNAL))
	data["spk_cut"] = (wires.IsIndexCut(WIRE_RECEIVE) || wires.IsIndexCut(WIRE_SIGNAL))

	var/list/current_channels = get_available_channels()
	if(length(current_channels))
		data["show_channels"] = TRUE
		data["channel_list"] = list()
		for(var/datum/radio_channel/channel in current_channels)
			if(!can_decrypt(channel.secured))
				continue
			var/list/channel_data = list()
			channel_data["display_name"] = channel.name || format_frequency(channel.frequency)
			channel_data["chan"] = "[channel.frequency]"
			channel_data["secure_channel"] = !!(channel.secured)
			channel_data["listening"] = !!(current_channels[channel])
			channel_data["chan_span"] = channel.span_class
			data["channel_list"] += list(channel_data)

	if(can_decrypt(access_hacked))
		data["useSyndMode"] = TRUE

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "radio_basic.tmpl", "[name]", 400, 430)
		ui.set_initial_data(data)
		ui.open()

// Used for radios that need to do something upon chatter.
/obj/item/radio/proc/received_chatter(display_freq, level)
	if((last_radio_sound + 1 SECOND) < world.time)
		playsound(loc, 'sound/effects/radio_chatter.ogg', 10, 0, -6)
		last_radio_sound = world.time

/obj/item/radio/proc/has_channel_access(var/mob/user, var/freq)
	return TRUE // TODO: add antag/valid bounds checking

/obj/item/radio/get_cell()
	return cell

/obj/item/radio/proc/toggle_broadcast()
	broadcasting = !broadcasting && !(wires.IsIndexCut(WIRE_TRANSMIT) || wires.IsIndexCut(WIRE_SIGNAL))

/obj/item/radio/proc/toggle_reception()
	listening = !listening && !(wires.IsIndexCut(WIRE_RECEIVE) || wires.IsIndexCut(WIRE_SIGNAL))

/obj/item/radio/CanUseTopic()
	if(!on)
		return STATUS_CLOSE
	return ..()

/obj/item/radio/OnTopic(href, href_list)
	if((. = ..()))
		return

	usr.set_machine(src)
	if(href_list["analog"])
		if(can_use_analog)
			analog = text2num(href_list["analog"])
			set_frequency(frequency) // update analog status
		. = TOPIC_REFRESH
	else if(href_list["analog_secured"])
		if(can_use_analog)
			if(length(encryption_keys))
				var/secured_key = href_list["analog_secured"]
				if(can_decrypt(secured_key)) // making sure we're not href hacking
					analog_secured[secured_key] = !analog_secured[secured_key]
				sanitize_analog_secured()
			else
				analog_secured = list()
			. = TOPIC_REFRESH
	else if(href_list["clear_analog_secured"])
		if(can_use_analog)
			analog_secured = list()
			. = TOPIC_REFRESH
	else if(href_list["sync"])
		sync_channels_with_network()
		. = TOPIC_REFRESH
	else if (href_list["freq"])
		var/new_frequency = sanitize_frequency(frequency + text2num(href_list["freq"]))
		set_frequency(new_frequency)
		if(hidden_uplink)
			if(hidden_uplink.check_trigger(usr, frequency, traitor_frequency))
				close_browser(usr, "window=radio")
		. = TOPIC_REFRESH
	else if (href_list["talk"])
		toggle_broadcast()
		. = TOPIC_REFRESH
	else if(href_list["reception"])
		toggle_reception()
		. = TOPIC_REFRESH
	else if(href_list["listen"])
		var/listen_set = text2num(href_list["listen"])
		var/chan_name = href_list["ch_name"]
		if(chan_name)
			for(var/datum/radio_channel/channel in channels)
				if("[channel.frequency]" == chan_name)
					channels[channel] = listen_set
					break
		. = TOPIC_REFRESH
	else if(href_list["spec_freq"])
		var freq = href_list["spec_freq"]
		if(has_channel_access(usr, freq))
			set_frequency(text2num(freq))
		. = TOPIC_REFRESH
	if(href_list["nowindow"]) // here for pAIs, maybe others will want it, idk
		return TOPIC_HANDLED

	if(href_list["remove_cell"])
		if(cell)
			var/mob/user = usr
			user.put_in_hands(cell)
			to_chat(user, SPAN_NOTICE("You remove [cell] from \the [src]."))
			cell = null
		. = TOPIC_REFRESH
	if(href_list["network_settings"])
		var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
		D.ui_interact(usr)
		. = TOPIC_HANDLED
	if(. & TOPIC_REFRESH)
		SSnano.update_uis(src)
		update_icon()

/mob/announcer // used only for autosay
	is_spawnable_type = FALSE
	simulated = FALSE

/obj/item/radio/proc/autosay(var/message, var/from, var/channel, var/sayverb = "states") //BS12 EDIT
	if(!channel)
		channel = frequency
	var/list/current_channels = get_available_channels()
	for(var/datum/radio_channel/comms in current_channels)
		if(!current_channels[comms] || !can_decrypt(comms.secured))
			continue
		if(comms.name == channel || "[comms.frequency]" == "[channel]" || comms.key == channel)
			transmit(from, message, comms.key, sayverb)
			break

/obj/item/radio/proc/resolve_frequency(mob/living/M, message, message_mode)
	var/list/current_channels = get_available_channels()
	if(length(current_channels) && message_mode && message_mode != MESSAGE_MODE_DEFAULT)
		if(message_mode == MESSAGE_MODE_DEPARTMENT)
			var/datum/radio_channel/channel = current_channels[1]
			return channel.frequency
		for(var/datum/radio_channel/channel in current_channels)
			if(message_mode == lowertext(channel.name || format_frequency(channel.frequency)))
				return channel.frequency
	return frequency

/obj/item/radio/talk_into(mob/living/M, message, message_mode, var/verb = "says", var/decl/language/speaking = null)
	set waitfor = FALSE
	if(!on) return 0 // the device has to be on
	//  Fix for permacell radios, but kinda eh about actually fixing them.
	if(!M || !message) return 0

	if(speaking && (speaking.flags & (LANG_FLAG_NONVERBAL|LANG_FLAG_SIGNLANG))) return 0

	if (!broadcasting)
		// Sedation chemical effect should prevent radio use.
		var/mob/living/carbon/C = M
		if(istype(C) && (C.has_chemical_effect(CE_SEDATE, 1) || C.incapacitated(INCAPACITATION_DISRUPTED)))
			to_chat(M, SPAN_WARNING("You're unable to reach \the [src]."))
			return 0

		if((istype(C)) && C.radio_interrupt_cooldown > world.time)
			to_chat(M, SPAN_WARNING("You're disrupted as you reach for \the [src]."))
			return 0

		if(istype(M))
			M.trigger_aiming(TARGET_CAN_RADIO)

	addtimer(CALLBACK(src, .proc/transmit, M, message, message_mode, verb, speaking), 0)

/obj/item/radio/proc/can_transmit_binary()
	for(var/obj/item/encryptionkey/key in encryption_keys)
		if(key.translate_binary)
			return TRUE
	return FALSE

/obj/item/radio/proc/transmit(var/mob/speaker, message, message_mode, var/verb = "says", var/decl/language/speaking = null)

	if(wires.IsIndexCut(WIRE_TRANSMIT))
		return 0

	var/message_compression = 0
	if(power_usage)
		var/obj/item/cell/has_cell = get_cell()
		if(!has_cell)
			return 0
		if(!has_cell.checked_use(power_usage * CELLRATE))
			return 0
		if(has_cell.percent() < 20)
			message_compression = max(0, 80 - has_cell.percent()*3)

	if(loc && loc == speaker)
		playsound(loc, 'sound/effects/walkietalkie.ogg', 20, 0, -1)

	if(message_mode == MESSAGE_MODE_SPECIAL && can_transmit_binary())
		var/decl/language/binary/binary = GET_DECL(/decl/language/binary)
		binary.broadcast(speaker, message)
		return TRUE

	var/turf/position = get_turf(src)
	if(!position)
		return

	var/list/current_sector = SSmapping.get_connected_levels(position.z)
	var/use_frequency = frequency
	if(message_mode && !analog)
		var/list/current_channels = get_available_channels()
		message_mode = lowertext(message_mode)
		if(message_mode == MESSAGE_MODE_DEFAULT)
			for(var/datum/radio_channel/channel in current_channels)
				if(!channel.secured)
					use_frequency = channel.frequency
					break
			if(!use_frequency)
				for(var/datum/radio_channel/channel in current_channels)
					if(channel.secured && can_decrypt(channel.secured))
						use_frequency = channel.frequency
						break

		else if(message_mode == MESSAGE_MODE_DEPARTMENT)
			for(var/datum/radio_channel/channel in current_channels)
				if(channel.secured && can_decrypt(channel.secured))
					use_frequency = channel.frequency
					break
			if(!use_frequency)
				for(var/datum/radio_channel/channel in current_channels)
					if(!channel.secured)
						use_frequency = channel.frequency
						break
		else
			for(var/datum/radio_channel/channel in current_channels)
				if(channel.key != message_mode || !(LAZYACCESS(channels, channel)))
					continue
				if(can_decrypt(channel.secured))
					use_frequency = channel.frequency
					break

	if(analog && istype(analog_radio_connection))
		var/last_frequency = frequency
		if(last_frequency != use_frequency)
			set_frequency(use_frequency)

		broadcast_analog_radio_message(analog_radio_connection, speaker, src, message, intercom, message_compression, current_sector, verb, speaking, analog_secured)
		if(frequency != last_frequency)
			set_frequency(last_frequency)
	else
		// List passed around to make sure a hub only checks for transmission once.
		var/list/checked_hubs = list()
		var/datum/extension/network_device/network_device = get_extension(src, /datum/extension/network_device)
		var/datum/computer_network/network = network_device?.get_network()
		for(var/weakref/H as anything in network?.connected_hubs)
			var/obj/machinery/network/telecomms_hub/hub = H.resolve()
			if(istype(hub) && !QDELETED(hub) && hub.can_receive_message(network))
				hub.transmit_message(speaker, message, verb, speaking, use_frequency, message_compression, checked_hubs)
				break // Only one hub per message, since it transmits over the whole network.

/obj/item/radio/proc/can_receive_message(var/check_network_membership)
	. = on
	if(. && check_network_membership)
		var/datum/extension/network_device/network_device = get_extension(src, /datum/extension/network_device)
		return network_device?.get_network() == check_network_membership

/obj/item/radio/hear_talk(mob/M, msg, var/verb = "says", var/decl/language/speaking = null)
	if(on && broadcasting && get_dist(src, M) <= canhear_range)
		talk_into(M, msg, null, verb, speaking)

/obj/item/radio/proc/get_accessible_channel_descriptions(var/mob/user)
	var/prefix = user?.get_department_radio_prefix()
	if(!prefix)
		return
	for(var/datum/radio_channel/channel in get_available_channels())
		LAZYADD(., "<b>- [channel.name || format_frequency(channel.frequency)]:</b> [prefix][channel.key]")
	if(can_transmit_binary())
		LAZYADD(., "<b>- Robot talk:</b> [prefix]+")

/obj/item/radio/examine(mob/user, distance)
	. = ..()
	if (distance <= 1 || loc == user)
		var/list/channel_descriptions = get_accessible_channel_descriptions(user)
		if(length(channel_descriptions))
			to_chat(user, "\The [src] has the following channel [length(channel_descriptions) == 1 ? "shortcut" : "shortcuts"] configured:")
			for(var/line in channel_descriptions)
				to_chat(user, line)
		if(panel_open)
			to_chat(user, SPAN_WARNING("A panel on the back of \the [src] is hanging open."))

/obj/item/radio/attackby(obj/item/W, mob/user)
	user.set_machine(src)

	if(istype(W, /obj/item/encryptionkey))
		if(!encryption_key_capacity)
			to_chat(user, SPAN_WARNING("\The [src] cannot accept an encryption key."))
			return TRUE
		if(length(encryption_keys) >= encryption_key_capacity)
			to_chat(user, SPAN_WARNING("\The [src] cannot fit any more encryption keys."))
			return TRUE
		if(user.try_unequip(W, src))
			LAZYADD(encryption_keys, W)
			channels = null
			return TRUE

	if(IS_SCREWDRIVER(W))
		if(length(encryption_keys))
			var/obj/item/encryptionkey/ekey = pick(encryption_keys)
			ekey.dropInto(loc)
			encryption_keys -= ekey
			channels = null
			to_chat(user, SPAN_NOTICE("You pop \the [ekey] out of \the [src]."))
			sanitize_analog_secured()
			return TRUE
		return toggle_panel(user)

	if(!cell && power_usage && istype(W, /obj/item/cell/device) && user.try_unequip(W, target = src))
		to_chat(user, SPAN_NOTICE("You slot \the [W] into \the [src]."))
		cell = W
		return TRUE

	. = ..()

/obj/item/radio/proc/toggle_panel(var/mob/user)
	panel_open = !panel_open
	if(user)
		user.show_message(SPAN_NOTICE("\The [src] can [panel_open ? "now" : "no longer"] be attached or modified!"))
	return TRUE

/obj/item/radio/emp_act(severity)
	broadcasting = 0
	listening = 0
	var/list/current_channels = get_available_channels()
	for(var/channel in current_channels)
		LAZYSET(channels, channel, FALSE)
	if(cell)
		cell.emp_act(severity)
	..()

/obj/item/radio/CouldUseTopic(var/mob/user)
	..()
	if(istype(user, /mob/living/carbon))
		playsound(src, "button", 10)

/obj/item/radio/off
	listening = FALSE
