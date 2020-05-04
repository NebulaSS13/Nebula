/obj/item/stock_parts/network_lock
	name = "network access lock"
	desc = "An id-based access lock preventing tampering with a machine's hardware and software. Connects wirelessly to network."
	icon_state = "scan_module"
	part_flags = PART_FLAG_QDEL
	base_type = /obj/item/stock_parts/network_lock

	var/auto_deny_all								// Set this to TRUE to deny all access attempts if network connection is lost.
	var/initial_network_id							// The address to the network
	var/initial_network_key							// network KEY
	var/list/grants = list()						// List of grants required to operate the device.
	var/emagged										// Whether or not this has been emagged.
	var/error
	var/signal_strength = NETWORK_SPEED_LOWSIGNAL	// How good the wireless capabilities are of this card.
	var/interact_sounds = list("keyboard", "keystroke")
	var/interact_sound_volume = 40

/obj/item/stock_parts/network_lock/Initialize()
	. = ..()
	set_extension(src, /datum/extension/network_device, initial_network_id, initial_network_key, signal_strength)

/obj/item/stock_parts/network_lock/emag_act(remaining_charges, mob/user, emag_source)
	. = ..()
	if(length(req_access) && istype(loc, /obj/machinery)) // Don't emag it outside; you can just cut access without it anyway.
		emagged = TRUE
		to_chat(user, SPAN_NOTICE("You slide the card into \the [src]. It flashes purple briefly, then disengages."))
		. = max(., 1)

// Override. This checks the network and builds a dynamic req_access list for the device it's attached to.
/obj/item/stock_parts/network_lock/get_req_access()
	. = get_default_access()
	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	var/datum/computer_network/network = D.get_network()
	if(!network)
		return

	var/datum/extension/network_device/acl/access_controller = network.access_controller
	if(!access_controller)
		return

	var/list/resulting_grants = list()
	for(var/grant_data in grants)
		var/datum/computer_file/data/grant_record/grant = access_controller.get_grant(grant_data)
		if(!grant)
			continue // couldn't find.
		resulting_grants |= uppertext("[D.network_id].[grant_data]")

	if(!resulting_grants.len)
		return
	return list(resulting_grants) // List of lists is an OR type access configuration.

/obj/item/stock_parts/network_lock/proc/get_default_access()
	if(auto_deny_all)
		return list("NO_PERMISSIONS_DENY_ALL")
	return list()

/obj/item/stock_parts/network_lock/examine(mob/user)
	. = ..()
	if(emagged && user.skill_check_multiple(list(SKILL_FORENSICS = SKILL_EXPERT, SKILL_COMPUTER = SKILL_EXPERT)))
		to_chat(user, SPAN_WARNING("On close inspection, there is something odd about the interface. You suspect it may have been tampered with."))

/obj/item/stock_parts/network_lock/attack_self(var/mob/user)
	ui_interact(user)

/obj/item/stock_parts/network_lock/ui_data(mob/user, ui_key)
	var/list/data[0]
	. = data

	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	if(!istype(D))
		error = "HARDWARE FAILURE: NETWORK DEVICE NOT FOUND"
		data["error"] = error
		return
	data["error"] = error
	data += D.ui_data(user, ui_key)

	var/datum/computer_network/network = D.get_network()
	if(!network)
		data["connected"] = FALSE
		return
	data["connected"] = TRUE
	data["default_state"] = auto_deny_all
	var/list/grants = list()
	if(!network.access_controller)
		return
	for(var/datum/computer_file/data/grant_record/GR in network.access_controller.get_all_grants())
		grants.Add(list(list(
			"grant_name" = GR.stored_data,
			"assigned" = (GR.stored_data in grants)
		)))
	data["grants"] = grants

/obj/item/stock_parts/network_lock/OnTopic(mob/user, href_list, datum/topic_state/state)
	. = ..()
	if(.)
		return
	. = TOPIC_HANDLED

	if(href_list["refresh"])
		error = null
		return TOPIC_REFRESH
	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	if(!D)
		return

	if(href_list["settings"])
		D.ui_interact(user)
		return TOPIC_REFRESH

	if(href_list["allow_all"])
		auto_deny_all = FALSE
		return TOPIC_REFRESH

	if(href_list["deny_all"])
		auto_deny_all = TRUE
		return TOPIC_REFRESH

	if(href_list["remove_grant"])
		grants -= href_list["remove_grant"]
		return TOPIC_REFRESH

	if(href_list["assign_grant"])
		grants |= href_list["assign_grant"]
		return TOPIC_REFRESH

/obj/item/stock_parts/network_lock/ui_interact(mob/user, ui_key, datum/nanoui/ui, force_open, datum/nanoui/master_ui, datum/topic_state/state)
	var/data = ui_data(user)
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "network_lock.tmpl", capitalize(name), 380, 500)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/item/stock_parts/network_lock/CouldUseTopic(var/mob/user)
	..()
	if(LAZYLEN(interact_sounds) && CanPhysicallyInteract(user))
		playsound(src, pick(interact_sounds), interact_sound_volume)

/obj/item/stock_parts/network_lock/CanUseTopic()
	return STATUS_INTERACTIVE

/obj/item/stock_parts/network_lock/buildable
	part_flags = PART_FLAG_HAND_REMOVE
	material = MAT_STEEL
	matter = list(MAT_GLASS = MATTER_AMOUNT_REINFORCEMENT)