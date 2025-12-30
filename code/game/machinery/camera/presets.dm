/obj/machinery/camera/network/engineering
	preset_channels = list(CAMERA_CHANNEL_ENGINEERING)
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
/obj/machinery/camera/emp_proof
	uncreated_component_parts = list(/obj/item/stock_parts/capacitor/adv = 1)

// X-RAY
/obj/machinery/camera/xray
	uncreated_component_parts = list(/obj/item/stock_parts/scanning_module/adv = 1)

// MOTION
/obj/machinery/camera/motion
	uncreated_component_parts = list(/obj/item/stock_parts/micro_laser = 1)

// ALL UPGRADES
/obj/machinery/camera/all
	uncreated_component_parts = list(
		/obj/item/stock_parts/capacitor/adv = 1,
		/obj/item/stock_parts/scanning_module/adv = 1,
		/obj/item/stock_parts/micro_laser = 1
	)

// AUTONAME left as a map stub
/obj/machinery/camera/autoname