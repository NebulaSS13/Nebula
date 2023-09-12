/obj/item/scanner/network
	name = "network analyzer"
	desc = "A hand-held network scanner which detects nearby network devices and returns information about them."
	icon = 'icons/obj/items/device/scanner/network_scanner.dmi'
	origin_tech = "{'magnets':1,'engineering':1}"
	window_width = 350
	window_height = 400

/obj/item/scanner/network/is_valid_scan_target(atom/A)
	return istype(A)

/obj/item/scanner/network/scan(atom/A, mob/user)
	scan_title = "Network scan data"

	scan_data = network_scan_results(A)
	scan_data = jointext(scan_data, "<br>")
	user.show_message(SPAN_NOTICE(scan_data))

/proc/network_scan_results(atom/target)
	var/list/found_devices = list()
	var/target_device = get_extension(target, /datum/extension/network_device)
	if(target_device) found_devices |= target_device

	for(var/obj/thing in target.contents)
		var/thing_device = get_extension(thing, /datum/extension/network_device)
		if(thing_device) found_devices |= thing_device

	if(!length(found_devices))
		return "No network devices found!"
	. = list()
	. += "Results of the analysis of \the [target]:"
	for(var/datum/extension/network_device/device in found_devices)
		. += "*----------------------*"
		. += "Network Tag: [device.network_tag]"
		. += "Network Address: [device.address]"
		. += "Connected to: [device.network_id]"
		. += "*----------------------*"