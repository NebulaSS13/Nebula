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

var/global/datum/radio_channel/peer_to_peer_channel
/proc/get_peer_to_peer_channel()
	if(!global.peer_to_peer_channel)
		global.peer_to_peer_channel = new(list("name" = "P2P", "frequency" = PUB_FREQ))
	return global.peer_to_peer_channel

var/global/list/initial_peer_to_peer_passwords = list()
/proc/get_initial_peer_to_peer_password(var/key)
	if(key && !global.initial_peer_to_peer_passwords[key])
		global.initial_peer_to_peer_passwords[key] = random_id(key, 1000000, 9999999)
	. = global.initial_peer_to_peer_passwords[key]

/obj/item/radio
	icon = 'icons/obj/items/device/radio/radio.dmi'
	name = "shortwave radio"
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
	var/panel_open = 0
	var/list/encryption_keys
	var/encryption_key_capacity

	var/on = 1 // 0 for off
	var/frequency = PUB_FREQ
	var/intercom_handling = FALSE
	var/traitor_frequency = 0 //tune to frequency to unlock traitor supplies
	var/canhear_range = 3 // the range which mobs can hear this radio from
	var/broadcasting = 0
	var/listening = 1
	var/list/channels
	var/default_color = "#6d3f40"
	var/decrypt_all_messages = FALSE

	var/can_use_peer_to_peer = TRUE
	var/peer_to_peer_password
	var/peer_to_peer = FALSE
	var/peer_to_peer_range = 100

/obj/item/radio/proc/can_decrypt(var/secured)
	if(decrypt_all_messages)
		return TRUE
	if(!secured)
		return TRUE
	for(var/obj/item/encryptionkey/key in encryption_keys)
		if(secured in key.can_decrypt)
			return TRUE
	return FALSE

/obj/item/radio/proc/set_frequency(new_frequency)
	frequency = new_frequency

/obj/item/radio/Initialize()
	. = ..()
	wires = new(src)
	if(ispath(cell))
		cell = new(src)

	global.listening_objects += src
	set_frequency(sanitize_frequency(frequency, RADIO_LOW_FREQ, RADIO_HIGH_FREQ))
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
	channels = null
	. = ..()

/obj/item/radio/attack_self(mob/user)
	user.set_machine(src)
	interact(user)
	return TRUE

/obj/item/radio/interact(mob/user)
	if(!user)
		return 0
	if(panel_open)
		wires.Interact(user)
	return ui_interact(user)

/obj/item/radio/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]

	var/datum/extension/network_device/network_device = get_extension(src, /datum/extension/network_device)
	if(network_device)
		var/datum/computer_network/network = network_device?.get_network()
		data["network"] = "[network_device.network_tag] ([network ? network.network_id : "disconnected"])"
	data["can_use_peer_to_peer"] = can_use_peer_to_peer
	data["peer_to_peer_password"] = peer_to_peer_password || "UNSET"
	data["peer_to_peer"] = peer_to_peer
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

	if(can_decrypt(access_syndicate))
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

/obj/item/radio/proc/list_channels(var/mob/user)
	return

/obj/item/radio/proc/has_channel_access(var/mob/user, var/freq)
	return TRUE

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

/obj/item/radio/Topic(href, href_list)
	if(..())
		return TRUE

	usr.set_machine(src)
	if (href_list["track"])
		var/mob/target = locate(href_list["track"])
		var/mob/living/silicon/ai/A = locate(href_list["track2"])
		if(A && target)
			A.ai_actual_track(target)
		. = TRUE
	else if(href_list["peer_to_peer"])
		if(can_use_peer_to_peer)
			peer_to_peer = text2num(href_list["peer_to_peer"])
			. = TRUE
	else if(href_list["change_peer_to_peer_pass"])
		if(can_use_peer_to_peer)
			var/new_pass = sanitize(input(usr, "Enter a new peer to peer password.", "Peer To Peer Password", peer_to_peer_password) as text)
			if(length_char(new_pass) && CanPhysicallyInteract(usr))
				peer_to_peer_password = new_pass
				. = TRUE
	else if(href_list["clear_peer_to_peer_pass"])
		if(can_use_peer_to_peer)
			peer_to_peer_password = null
			. = TRUE

	else if(href_list["sync"])
		sync_channels_with_network()
		. = TRUE
	else if (href_list["freq"])
		var/new_frequency = (frequency + text2num(href_list["freq"]))
		if ((new_frequency < PUBLIC_LOW_FREQ || new_frequency > PUBLIC_HIGH_FREQ))
			new_frequency = sanitize_frequency(new_frequency)
		set_frequency(new_frequency)
		if(hidden_uplink)
			if(hidden_uplink.check_trigger(usr, frequency, traitor_frequency))
				close_browser(usr, "window=radio")
		. = TRUE
	else if (href_list["talk"])
		toggle_broadcast()
		. = TRUE
	else if(href_list["reception"])
		toggle_reception()
	else if(href_list["listen"])
		var/listen_set = text2num(href_list["listen"])
		var/chan_name = href_list["ch_name"]
		if(chan_name)
			for(var/datum/radio_channel/channel in channels)
				if("[channel.frequency]" == chan_name)
					channels[channel] = listen_set
					break
		. = TRUE
	else if(href_list["spec_freq"])
		var freq = href_list["spec_freq"]
		if(has_channel_access(usr, freq))
			set_frequency(text2num(freq))
		. = TRUE
	if(href_list["nowindow"]) // here for pAIs, maybe others will want it, idk
		return TRUE

	if(href_list["remove_cell"])
		if(cell)
			var/mob/user = usr
			user.put_in_hands(cell)
			to_chat(user, SPAN_NOTICE("You remove [cell] from \the [src]."))
			cell = null
		return TRUE
	if(href_list["network_settings"])
		var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
		D.ui_interact(usr)
		return TRUE
	if(.)
		SSnano.update_uis(src)

/mob/announcer // used only for autosay
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
	if(length(current_channels) && message_mode && message_mode != "headset")
		if(message_mode == "department")
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

	if(speaking && (speaking.flags & (NONVERBAL|SIGNLANG))) return 0

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

	var/turf/position = get_turf(src)
	if(!position)
		return
	var/list/current_sector = GetConnectedZlevels(position.z)

	var/use_frequency = frequency
	var/list/current_channels = get_available_channels()
	if(message_mode)

		message_mode = lowertext(message_mode)
		if(message_mode == "headset")
			for(var/datum/radio_channel/channel in current_channels)
				if(!channel.secured)
					use_frequency = channel.frequency
					break
			if(!use_frequency)
				for(var/datum/radio_channel/channel in current_channels)
					if(channel.secured && can_decrypt(channel.secured))
						use_frequency = channel.frequency
						break

		else if(message_mode == "department")
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

	var/datum/radio_channel/channel
	var/list/send_message_to
	var/last_frequency = frequency
	set_frequency(use_frequency)
	if(peer_to_peer)
		channel = get_peer_to_peer_channel()
		for(var/obj/item/radio/radio in global.listening_objects)
			var/turf/T = get_turf(radio)
			if(!T || !(T.z in current_sector) || get_dist(position, T) > peer_to_peer_range)
				continue
			if(!radio.peer_to_peer || !radio.can_receive_message())
				continue 
			if(!radio.decrypt_all_messages && peer_to_peer_password && radio.peer_to_peer_password != peer_to_peer_password)
				continue
			for(var/mob/listener in hearers(radio.canhear_range, T))
				LAZYDISTINCTADD(send_message_to, listener)
	else
		var/datum/extension/network_device/network_device = get_extension(src, /datum/extension/network_device)
		var/datum/computer_network/network = network_device?.get_network()
		for(var/weakref/H as anything in network?.connected_hubs)
			var/obj/machinery/network/telecomms_hub/hub = H.resolve()
			if(istype(hub) && !QDELETED(hub) && hub.can_receive_message(network))
				send_message_to = hub.get_recipients(current_sector, network, use_frequency)
				channel = hub.get_channel("[use_frequency]")

	set_frequency(last_frequency)

	if(!length(send_message_to))
		return

	var/formatted_msg = "<span style='color:[channel?.color || default_color]'><small><b>\[[channel?.name || format_frequency(frequency)]\]</b></small> <span class='name'>"
	var/send_name = istype(speaker) ? speaker.real_name : ("[speaker]" || "unknown")
	var/send_message = message

	var/turf/T = get_turf(src)
	var/obj/send_overmap_object = istype(T) && global.overmap_sectors["[T.z]"]

	for(var/mob/listener in send_message_to)
		var/per_listener_send_name = send_name
		if(send_overmap_object && send_overmap_object != send_message_to[listener])
			var/obj/effect/overmap/sender_obj = send_message_to[listener]
			if(sender_obj && (!istype(sender_obj) || sender_obj.ident_transmitter))
				per_listener_send_name = "[per_listener_send_name] ([sender_obj.name])"
		listener.hear_radio(send_message, verb, speaking, formatted_msg, "</span> <span class='message'>", "</span></span>", speaker, message_compression, per_listener_send_name)

/obj/item/radio/proc/can_receive_message(var/check_network_membership)
	. = on
	if(. && check_network_membership)
		var/datum/extension/network_device/network_device = get_extension(src, /datum/extension/network_device)
		return network_device?.get_network() == check_network_membership

/obj/item/radio/hear_talk(mob/M, msg, var/verb = "says", var/decl/language/speaking = null)
	if(on && broadcasting && get_dist(src, M) <= canhear_range)
		talk_into(M, msg, null, verb, speaking)

/obj/item/radio/proc/receive_range(freq, level)
	// check if this radio can receive on the given frequency, and if so,
	// what the range is in which mobs will hear the radio
	// returns: -1 if can't receive, range otherwise

	if(!on || !listening || wires.IsIndexCut(WIRE_RECEIVE))
		return -1
	if(!(0 in level))
		var/turf/position = get_turf(src)
		if(!position || !(position.z in level))
			return -1
	return canhear_range

/obj/item/radio/proc/send_hear(freq, level)
	var/range = receive_range(freq, level)
	if(range > -1)
		return get_mobs_or_objects_in_view(canhear_range, src)

/obj/item/radio/examine(mob/user, distance)
	. = ..()
	if (distance <= 1 || loc == user)
		var/list/current_channels = get_available_channels()
		if(LAZYLEN(current_channels))
			to_chat(user, "You have the following channel shortcuts configured:")
			var/prefix = user.get_prefix_key(/decl/prefix/radio_channel_selection)
			for(var/datum/radio_channel/channel in current_channels)
				to_chat(user, "<b>- [channel.name || format_frequency(channel.frequency)]:</b> [prefix][channel.key]")
		if(panel_open)
			to_chat(user, SPAN_WARNING("A panel on the back of \the [src] is hanging open."))

/obj/item/radio/attackby(obj/item/W, mob/user)
	user.set_machine(src)

	if(istype(W, /obj/item/encryptionkey))
		if(!encryption_key_capacity)
			to_chat(W, SPAN_WARNING("\The [src] cannot accept an encryption key."))
			return TRUE
		if(length(encryption_keys) >= encryption_key_capacity)
			to_chat(W, SPAN_WARNING("\The [src] cannot fit any more encryption keys."))
			return TRUE
		if(user.unEquip(W, src))
			LAZYADD(encryption_keys, W)
			channels = null
			return TRUE

	if(IS_SCREWDRIVER(W) && length(encryption_keys))
		var/obj/item/encryptionkey/ekey = pick(encryption_keys)
		ekey.dropInto(loc)
		encryption_keys -= ekey
		channels = null
		to_chat(user, SPAN_NOTICE("You pop \the [ekey] out of \the [src]."))
		return TRUE

	if(!cell && power_usage && istype(W, /obj/item/cell/device) && user.unEquip(W, target = src))
		to_chat(user, SPAN_NOTICE("You slot \the [W] into \the [src]."))
		cell = W
		return TRUE
	. = ..()

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
//The exosuit  radio subtype. It allows pilots to interact and consumes exosuit power

/obj/item/radio/exosuit
	name = "exosuit radio"
	cell = null
	intercom_handling = TRUE

/obj/item/radio/exosuit/get_cell()
	. = ..()
	if(!.)
		var/mob/living/exosuit/E = loc
		if(istype(E))
			return E.get_cell()

/obj/item/radio/exosuit/nano_host()
	var/mob/living/exosuit/E = loc
	if(istype(E))
		return E
	return null

/obj/item/radio/exosuit/attack_self(var/mob/user)
	var/mob/living/exosuit/exosuit = loc
	if(istype(exosuit) && exosuit.head && exosuit.head.radio && exosuit.head.radio.is_functional())
		user.set_machine(src)
		interact(user)
	else
		to_chat(user, SPAN_WARNING("The radio is too damaged to function."))

/obj/item/radio/exosuit/CanUseTopic()
	. = ..()
	if(.)
		var/mob/living/exosuit/exosuit = loc
		if(istype(exosuit) && exosuit.head && exosuit.head.radio && exosuit.head.radio.is_functional())
			return ..()

/obj/item/radio/exosuit/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = global.mech_topic_state)
	. = ..()
