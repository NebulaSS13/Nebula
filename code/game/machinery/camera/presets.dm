/obj/machinery/camera/network/engineering
	preset_channels = list(CAMERA_CAMERA_CHANNEL_ENGINEERING)
	req_access = list(access_engine)

/obj/machinery/camera/network/ert
	preset_channels = list(CAMERA_CHANNEL_ERT)
	cameranet_enabled = FALSE
	req_access = list(access_engine)

/obj/machinery/camera/network/medbay
	preset_channels = list(CAMERA_CHANNEL_MEDICAL)
	req_access = list(access_medical)
/obj/machinery/camera/network/mercenary
	preset_channels = list(CAMERA_CHANNEL_MERCENARY)
	cameranet_enabled = FALSE
	req_access = list(access_mercenary)

/obj/machinery/camera/network/mining
	preset_channels = list(CAMERA_CHANNEL_MINE)
	req_access = list(access_mining)

/obj/machinery/camera/network/research
	preset_channels = list(CAMERA_CHANNEL_RESEARCH)
	req_access = list(access_research)

/obj/machinery/camera/network/security
	preset_channels = list(CAMERA_CHANNEL_SECURITY)
	req_access = list(access_security)

/obj/machinery/camera/network/television
	preset_channels = list(CAMERA_CHANNEL_TELEVISION)
	cameranet_enabled = FALSE
	requires_connection = FALSE

// EMP

/obj/machinery/camera/emp_proof/populate_parts(full_populate)
	. = ..()
	install_component(/obj/item/stock_parts/capacitor/adv, TRUE)

// X-RAY

/obj/machinery/camera/xray
	icon_state = "xraycam" // Thanks to Krutchen for the icons.

/obj/machinery/camera/xray/populate_parts(full_populate)
	. = ..()
	install_component(/obj/item/stock_parts/scanning_module/adv, TRUE)

// MOTION

/obj/machinery/camera/motion/populate_parts(full_populate)
	. = ..()
	install_component(/obj/item/stock_parts/micro_laser, TRUE)

// ALL UPGRADES

/obj/machinery/camera/all/populate_parts(full_populate)
	. = ..()
	install_component(/obj/item/stock_parts/capacitor/adv, TRUE)
	install_component(/obj/item/stock_parts/scanning_module/adv, TRUE)
	install_component(/obj/item/stock_parts/micro_laser, TRUE)

// AUTONAME left as a map stub
/obj/machinery/camera/autoname