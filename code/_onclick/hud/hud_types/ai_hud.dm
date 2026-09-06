/decl/hud_element/ai
	abstract_type = /decl/hud_element/ai
	elem_type = /obj/screen/ai_button
	var/screen_loc
	var/name
	var/icon_state
	var/proc_path
	var/list/input_procs
	var/list/input_args

/decl/hud_element/ai/core
	screen_loc = ui_ai_core
	name = "AI Core"
	icon_state = "ai_core"
	proc_path = /mob/living/silicon/ai/proc/core

/decl/hud_element/ai/announcement
	screen_loc = ui_ai_announcement
	name = "AI Announcement"
	icon_state = "announcement"
	proc_path = /mob/living/silicon/ai/proc/ai_announcement

/decl/hud_element/ai/cam_track
	screen_loc = ui_ai_cam_track
	name = "Track With Camera"
	icon_state = "track"
	proc_path = /mob/living/silicon/ai/proc/ai_camera_track
	input_procs = list(/mob/living/silicon/ai/proc/trackable_mobs = (AI_BUTTON_PROC_BELONGS_TO_CALLER|AI_BUTTON_INPUT_REQUIRES_SELECTION))

/decl/hud_element/ai/cam_light
	screen_loc = ui_ai_cam_light
	name = "Toggle Camera Lights"
	icon_state = "camera_light"
	proc_path = /mob/living/silicon/ai/proc/toggle_camera_light

/decl/hud_element/ai/cam_change_channel
	screen_loc = ui_ai_cam_change_channel
	name = "Jump to Camera Channel"
	icon_state = "camera"
	proc_path = /mob/living/silicon/ai/proc/ai_channel_change
	input_procs = list(/mob/living/silicon/ai/proc/get_camera_channel_list = (AI_BUTTON_PROC_BELONGS_TO_CALLER|AI_BUTTON_INPUT_REQUIRES_SELECTION))

/decl/hud_element/ai/sensor
	screen_loc = ui_ai_sensor
	name = "Set Sensor Mode"
	icon_state = "ai_sensor"
	proc_path = /mob/living/silicon/ai/proc/sensor_mode

/decl/hud_element/ai/manifest
	screen_loc = ui_ai_crew_manifest
	name = "Show Crew Manifest"
	icon_state = "manifest"
	proc_path = /mob/living/silicon/ai/proc/run_program
	input_args = list("crewmanifest")

/decl/hud_element/ai/take_image
	screen_loc = ui_ai_take_image
	name = "Toggle Camera Mode"
	icon_state = "take_picture"
	proc_path = /mob/living/silicon/ai/proc/ai_take_image

/decl/hud_element/ai/view_images
	screen_loc = ui_ai_view_images
	name = "View Images"
	icon_state = "view_images"
	proc_path = /mob/living/silicon/ai/proc/ai_view_images

/decl/hud_element/ai/laws
	screen_loc = ui_ai_state_laws
	name = "State Laws"
	icon_state = "state_laws"
	proc_path = /mob/living/silicon/ai/proc/ai_checklaws

/decl/hud_element/ai/call_shuttle
	screen_loc = ui_ai_call_shuttle
	name = "Call Shuttle"
	icon_state = "call_shuttle"
	proc_path = /mob/living/silicon/ai/proc/ai_call_shuttle

/decl/hud_element/ai/up
	screen_loc = ui_ai_up
	name = "Move Upwards"
	icon_state = "ai_up"
	proc_path = /mob/verb/up

/decl/hud_element/ai/down
	screen_loc = ui_ai_down
	name = "Move Downwards"
	icon_state = "ai_down"
	proc_path = /mob/verb/down

/decl/hud_element/ai/color
	screen_loc = ui_ai_color
	name = "Change Floor Color"
	icon_state = "ai_floor"
	proc_path = /mob/living/silicon/ai/proc/change_floor

/decl/hud_element/ai/hologram
	screen_loc = ui_ai_holo_change
	name = "Change Hologram"
	icon_state = "ai_holo_change"
	proc_path = /mob/living/silicon/ai/proc/ai_hologram_change

/decl/hud_element/ai/crew_monitor
	screen_loc = ui_ai_crew_mon
	name = "Crew Monitor"
	icon_state = "crew_monitor"
	proc_path = /mob/living/silicon/ai/proc/run_program
	input_args = list("sensormonitor")

/decl/hud_element/ai/power_override
	screen_loc = ui_ai_power_override
	name = "Toggle Power Override"
	icon_state = "ai_p_override"
	proc_path = /mob/living/silicon/ai/proc/ai_power_override

/decl/hud_element/ai/shutdown
	screen_loc = ui_ai_shutdown
	name = "Shutdown"
	icon_state = "ai_shutdown"
	proc_path = /mob/living/silicon/ai/proc/ai_shutdown

/decl/hud_element/ai/move_hologram
	screen_loc = ui_ai_holo_mov
	name = "Toggle Hologram Movement"
	icon_state = "ai_holo_mov"
	proc_path = /mob/living/silicon/ai/proc/toggle_hologram_movement

/decl/hud_element/ai/core_icon
	screen_loc = ui_ai_core_icon
	name = "Pick Icon"
	icon_state = "ai_core_pick"
	proc_path = /mob/living/silicon/ai/proc/pick_icon

/decl/hud_element/ai/status
	screen_loc = ui_ai_status
	name = "Pick Status"
	icon_state = "ai_status"
	proc_path = /mob/living/silicon/ai/proc/ai_statuschange

/decl/hud_element/ai/inbuilt_comp
	screen_loc = ui_ai_crew_rec
	name = "Inbuilt Computer"
	icon_state = "ai_crew_rec"
	proc_path = /mob/living/silicon/proc/access_computer
