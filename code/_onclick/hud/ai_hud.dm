/decl/ai_hud
	abstract_type = /decl/ai_hud
	var/screen_loc
	var/name
	var/icon_state
	var/proc_path
	var/list/input_procs
	var/list/input_args

/decl/ai_hud/ai_core
	screen_loc = ui_ai_core
	name = "AI Core"
	icon_state = "ai_core"
	proc_path = /mob/living/silicon/ai/proc/core

/decl/ai_hud/ai_announcement
	screen_loc = ui_ai_announcement
	name = "AI Announcement"
	icon_state = "announcement"
	proc_path = /mob/living/silicon/ai/proc/ai_announcement

/decl/ai_hud/ai_cam_track
	screen_loc = ui_ai_cam_track
	name = "Track With Camera"
	icon_state = "track"
	proc_path = /mob/living/silicon/ai/proc/ai_camera_track
	input_procs = list(/mob/living/silicon/ai/proc/trackable_mobs = (AI_BUTTON_PROC_BELONGS_TO_CALLER|AI_BUTTON_INPUT_REQUIRES_SELECTION))

/decl/ai_hud/ai_cam_light
	screen_loc = ui_ai_cam_light
	name = "Toggle Camera Lights"
	icon_state = "camera_light"
	proc_path = /mob/living/silicon/ai/proc/toggle_camera_light

/decl/ai_hud/ai_cam_change_channel
	screen_loc = ui_ai_cam_change_channel
	name = "Jump to Camera Channel"
	icon_state = "camera"
	proc_path = /mob/living/silicon/ai/proc/ai_channel_change
	input_procs = list(/mob/living/silicon/ai/proc/get_camera_channel_list = (AI_BUTTON_PROC_BELONGS_TO_CALLER|AI_BUTTON_INPUT_REQUIRES_SELECTION))

/decl/ai_hud/ai_sensor
	screen_loc = ui_ai_sensor
	name = "Set Sensor Mode"
	icon_state = "ai_sensor"
	proc_path = /mob/living/silicon/ai/proc/sensor_mode

/decl/ai_hud/ai_manifest
	screen_loc = ui_ai_crew_manifest
	name = "Show Crew Manifest"
	icon_state = "manifest"
	proc_path = /mob/living/silicon/ai/proc/run_program
	input_args = list("crewmanifest")

/decl/ai_hud/ai_take_image
	screen_loc = ui_ai_take_image
	name = "Toggle Camera Mode"
	icon_state = "take_picture"
	proc_path = /mob/living/silicon/ai/proc/ai_take_image

/decl/ai_hud/ai_view_images
	screen_loc = ui_ai_view_images
	name = "View Images"
	icon_state = "view_images"
	proc_path = /mob/living/silicon/ai/proc/ai_view_images

/decl/ai_hud/ai_laws
	screen_loc = ui_ai_state_laws
	name = "State Laws"
	icon_state = "state_laws"
	proc_path = /mob/living/silicon/ai/proc/ai_checklaws

/decl/ai_hud/ai_call_shuttle
	screen_loc = ui_ai_call_shuttle
	name = "Call Shuttle"
	icon_state = "call_shuttle"
	proc_path = /mob/living/silicon/ai/proc/ai_call_shuttle

/decl/ai_hud/ai_up
	screen_loc = ui_ai_up
	name = "Move Upwards"
	icon_state = "ai_up"
	proc_path = /mob/verb/up

/decl/ai_hud/ai_down
	screen_loc = ui_ai_down
	name = "Move Downwards"
	icon_state = "ai_down"
	proc_path = /mob/verb/down

/decl/ai_hud/ai_color
	screen_loc = ui_ai_color
	name = "Change Floor Color"
	icon_state = "ai_floor"
	proc_path = /mob/living/silicon/ai/proc/change_floor

/decl/ai_hud/ai_hologram
	screen_loc = ui_ai_holo_change
	name = "Change Hologram"
	icon_state = "ai_holo_change"
	proc_path = /mob/living/silicon/ai/proc/ai_hologram_change

/decl/ai_hud/ai_crew_monitor
	screen_loc = ui_ai_crew_mon
	name = "Crew Monitor"
	icon_state = "crew_monitor"
	proc_path = /mob/living/silicon/ai/proc/run_program
	input_args = list("sensormonitor")

/decl/ai_hud/ai_power_override
	screen_loc = ui_ai_power_override
	name = "Toggle Power Override"
	icon_state = "ai_p_override"
	proc_path = /mob/living/silicon/ai/proc/ai_power_override

/decl/ai_hud/ai_shutdown
	screen_loc = ui_ai_shutdown
	name = "Shutdown"
	icon_state = "ai_shutdown"
	proc_path = /mob/living/silicon/ai/proc/ai_shutdown

/decl/ai_hud/ai_move_hologram
	screen_loc = ui_ai_holo_mov
	name = "Toggle Hologram Movement"
	icon_state = "ai_holo_mov"
	proc_path = /mob/living/silicon/ai/proc/toggle_hologram_movement

/decl/ai_hud/ai_core_icon
	screen_loc = ui_ai_core_icon
	name = "Pick Icon"
	icon_state = "ai_core_pick"
	proc_path = /mob/living/silicon/ai/proc/pick_icon

/decl/ai_hud/ai_status
	screen_loc = ui_ai_status
	name = "Pick Status"
	icon_state = "ai_status"
	proc_path = /mob/living/silicon/ai/proc/ai_statuschange

/decl/ai_hud/ai_inbuilt_comp
	screen_loc = ui_ai_crew_rec
	name = "Inbuilt Computer"
	icon_state = "ai_crew_rec"
	proc_path = /mob/living/silicon/proc/access_computer
