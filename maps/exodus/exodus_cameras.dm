var/global/const/CAMERA_CHANNEL_COMMAND = "Command"
var/global/const/CAMERA_CHANNEL_ENGINE  = "Engine"
var/global/const/CAMERA_CHANNEL_ENGINEERING_OUTPOST = "Engineering Outpost"
//
// Cameras
//

// Networks
/obj/machinery/camera/network/command
	preset_channels = list(CAMERA_CHANNEL_COMMAND)
	req_access = list(access_heads)

/obj/machinery/camera/network/crescent
	preset_channels = list(CAMERA_CHANNEL_CRESCENT)

/obj/machinery/camera/network/engine
	preset_channels = list(CAMERA_CHANNEL_ENGINE)
	req_access = list(access_engine)

/obj/machinery/camera/network/engineering_outpost
	preset_channels = list(CAMERA_CHANNEL_ENGINEERING_OUTPOST)
	req_access = list(access_engine)

// Motion
/obj/machinery/camera/motion/engineering_outpost
	preset_channels = list(CAMERA_CHANNEL_ENGINEERING_OUTPOST)
	req_access = list(access_engine)

// All Upgrades
/obj/machinery/camera/all/command
	preset_channels = list(CAMERA_CHANNEL_COMMAND)
	req_access = list(access_heads)

// Compile stubs.
/obj/machinery/camera/motion/command
	preset_channels = list(CAMERA_CHANNEL_COMMAND)
	req_access = list(access_heads)

/obj/machinery/camera/network/maintenance
	preset_channels = list(CAMERA_CHANNEL_ENGINEERING)
	req_access = list(access_engine)

/obj/machinery/camera/xray/security
	preset_channels = list(CAMERA_CHANNEL_SECURITY)

/obj/machinery/camera/network/exodus
	preset_channels = list(CAMERA_CHANNEL_SECURITY)

/obj/machinery/camera/network/civilian_east
	preset_channels = list(CAMERA_CHANNEL_SECURITY)

/obj/machinery/camera/network/civilian_west
	preset_channels = list(CAMERA_CHANNEL_SECURITY)

/obj/machinery/camera/network/prison
	preset_channels = list(CAMERA_CHANNEL_SECURITY)

/obj/machinery/camera/xray/medbay
	preset_channels = list(CAMERA_CHANNEL_SECURITY)

/obj/machinery/camera/xray/research
	preset_channels = list(CAMERA_CHANNEL_SECURITY)
