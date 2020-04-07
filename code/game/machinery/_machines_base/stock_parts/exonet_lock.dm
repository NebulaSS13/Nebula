/obj/item/stock_parts/exonet_lock
	name = "exonet access lock"
	desc = "An id-based access lock preventing tampering with a machine's hardware. Connects wirelessly to exonet."
	icon_state = "scan_module"
	part_flags = PART_FLAG_QDEL
	req_access = null
	var/auto_deny_all								// Set this to TRUE to deny all access attempts if EXONET connection is lost.
	var/ennid										// The address to the network
	var/keydata										// Exonet KEY
	var/list/grants = list()						// List of grants required to operate the device.
	var/emagged										// Whether or not this has been emagged.
	var/signal_strength = NETWORKSPEED_LOWSIGNAL	// How good the wireless capabilities are of this card.

/obj/item/stock_parts/exonet_lock/Initialize()
	. = ..()
	set_extension(src, /datum/extension/exonet_device)

/obj/item/stock_parts/exonet_lock/emag_act(remaining_charges, mob/user, emag_source)
	. = ..()
	if(length(req_access) && istype(loc, /obj/machinery)) // Don't emag it outside; you can just cut access without it anyway.
		emagged = TRUE
		to_chat(user, SPAN_NOTICE("You slide the card into \the [src]. It flashes purple briefly, then disengages."))
		. = max(., 1)

/obj/item/stock_parts/exonet_lock/on_install(obj/machinery/machine)
	. = ..()
	// Boot up the network.
	if(ennid)
		var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)
		exonet.connect_network(null, ennid, signal_strength, keydata)

/obj/item/stock_parts/exonet_lock/on_uninstall(obj/machinery/machine)
	. = ..()
	// Remove from network.
	var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)
	exonet.disconnect_network()

// Override. This checks the network and builds a dynamic req_access list for the device it's attached to.
/obj/item/stock_parts/exonet_lock/get_req_access()
	var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)
	var/datum/exonet/network = exonet.get_local_network()
	if(!network)
		return get_default_access()
	var/list/resulting_grants = list()
	for(var/datum/computer_file/data/grant_record/grant in grants)
		for(var/obj/machinery/computer/exonet/mainframe/MF in network.mainframes)
			if(grant in MF.stored_files)
				resulting_grants.Add(uppertext("[ennid].[grant.stored_data]"))
				break
	return resulting_grants

/obj/item/stock_parts/exonet_lock/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/modular_computer))
		// Being attacked by a modular computer. Check to see if it has anything interesting...
		var/datum/extension/interactive/ntos/os = get_extension(I, /datum/extension/interactive/ntos)
		if(os)
			// See if we can get a special device...
			var/obj/item/stock_parts/computer/rfid_programmer/programmer = os.get_component(/obj/item/stock_parts/computer/rfid_programmer)
			if(programmer && programmer.check_functionality())
				programmer.link_device(user, src)
				return TRUE


/obj/item/stock_parts/exonet_lock/proc/get_default_access()
	if(auto_deny_all)
		return list("NO_PERMISSIONS_DENY_ALL")
	return list()

/obj/item/stock_parts/exonet_lock/examine(mob/user)
	. = ..()
	if(emagged && user.skill_check_multiple(list(SKILL_FORENSICS = SKILL_EXPERT, SKILL_COMPUTER = SKILL_EXPERT)))
		to_chat(user, SPAN_WARNING("On close inspection, there is something odd about the interface. You suspect it may have been tampered with."))

/obj/item/stock_parts/exonet_lock/buildable
	part_flags = PART_FLAG_HAND_REMOVE
	matter = list(MAT_STEEL = 400, MAT_GLASS = 200)

/decl/stock_part_preset/exonet_lock
	expected_part_type = /obj/item/stock_parts/exonet_lock
	var/list/req_access = list()

/decl/stock_part_preset/exonet_lock/do_apply(obj/machinery/machine, obj/item/stock_parts/exonet_lock/part)
	part.req_access = req_access.Copy()