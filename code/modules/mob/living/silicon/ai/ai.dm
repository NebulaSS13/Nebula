#define AI_CHECK_WIRELESS 1
#define AI_CHECK_RADIO 2

var/global/list/ai_list = list()
var/global/list/ai_verbs_default = list(
	/mob/living/silicon/ai/proc/ai_announcement,
	/mob/living/silicon/ai/proc/ai_call_shuttle,
	/mob/living/silicon/ai/proc/ai_emergency_message,
	/mob/living/silicon/ai/proc/ai_camera_track,
	/mob/living/silicon/ai/proc/ai_camera_list,
	/mob/living/silicon/ai/proc/ai_goto_location,
	/mob/living/silicon/ai/proc/ai_remove_location,
	/mob/living/silicon/ai/proc/ai_hologram_change,
	/mob/living/silicon/ai/proc/ai_channel_change,
	/mob/living/silicon/ai/proc/ai_statuschange,
	/mob/living/silicon/ai/proc/ai_store_location,
	/mob/living/silicon/ai/proc/ai_checklaws,
	/mob/living/silicon/ai/proc/control_integrated_radio,
	/mob/living/silicon/ai/proc/core,
	/mob/living/silicon/ai/proc/pick_icon,
	/mob/living/silicon/ai/proc/sensor_mode,
	/mob/living/silicon/ai/proc/show_laws_verb,
	/mob/living/silicon/ai/proc/toggle_acceleration,
	/mob/living/silicon/ai/proc/toggle_camera_light,
	/mob/living/silicon/ai/proc/multitool_mode,
	/mob/living/silicon/ai/proc/toggle_hologram_movement,
	/mob/living/silicon/ai/proc/ai_view_images,
	/mob/living/silicon/ai/proc/ai_take_image,
	/mob/living/silicon/ai/proc/change_floor,
	/mob/living/silicon/ai/proc/show_crew_monitor,
	/mob/living/silicon/proc/access_computer,
	/mob/living/silicon/ai/proc/ai_power_override,
	/mob/living/silicon/ai/proc/ai_shutdown,
	/mob/living/silicon/ai/proc/run_program,
	/mob/living/silicon/ai/proc/pick_color
)

//Not sure why this is necessary...
/proc/AutoUpdateAI(obj/subject)
	var/is_in_use = 0
	if (subject!=null)
		for(var/A in ai_list)
			var/mob/living/silicon/ai/M = A
			if ((M.client && M.machine == subject))
				is_in_use = 1
				subject.attack_ai(M)
	return is_in_use


/mob/living/silicon/ai
	name = "AI"
	icon = 'icons/mob/AI.dmi'
	icon_state = "ai"
	mob_sort_value = 2
	anchored = 1 // -- TLE
	density = 1
	status_flags = CANSTUN|CANPARALYSE|CANPUSH
	shouldnt_see = list(/obj/effect/rune)
	maxHealth = 200
	var/obj/machinery/camera/camera = null
	var/list/connected_robots = list()
	var/aiRestorePowerRoutine = 0
	var/viewalerts = 0
	var/icon/holo_icon //Blue hologram. Face is assigned when AI is created.
	var/icon/holo_icon_longrange //Yellow hologram.
	var/holo_icon_malf = FALSE // for new hologram system
	var/obj/item/multitool/aiMulti = null

	silicon_camera = /obj/item/camera/siliconcam/ai_camera
	silicon_radio = /obj/item/radio/headset/heads/ai_integrated
	var/obj/item/radio/headset/heads/ai_integrated/ai_radio

	var/camera_light_on = 0	//Defines if the AI toggled the light on the camera it's looking through.
	var/datum/trackable/track = null
	var/control_disabled = 0
	var/datum/announcement/priority/announcement
	var/obj/machinery/ai_powersupply/psupply = null // Backwards reference to AI's powersupply object.
	var/hologram_follow = 1 //This is used for the AI eye, to determine if a holopad's hologram should follow it or not
	var/power_override_active = 0 				// If set to 1 the AI gains oxyloss (power loss damage) much faster, but is able to work as if powered normally.
	var/admin_powered = 0						// For admin/debug use only, makes the AI have infinite power.
	var/self_shutdown = 0						// Set to 1 when the AI uses self-shutdown verb to turn itself off. Reduces power usage but makes the AI mostly inoperable.

	//NEWMALF VARIABLES
	var/malfunctioning = 0						// Master var that determines if AI is malfunctioning.
	var/obj/machinery/power/apc/hack = null		// APC that is currently being hacked.
	var/list/hacked_apcs = null					// List of all hacked APCs
	var/uncardable = 0							// Whether the AI can be carded when malfunctioning.
	var/hacked_apcs_hidden = 0					// Whether the hacked APCs belonging to this AI are hidden, reduces CPU generation from APCs.

	var/datum/ai_icon/selected_sprite			// The selected icon set
	var/carded

	var/multitool_mode = 0

	var/default_ai_icon = /datum/ai_icon/blue
	var/custom_color_tone //This is a hex, despite being converted to rgb by gethologramicon.

/mob/living/silicon/ai/proc/add_ai_verbs()
	src.verbs |= ai_verbs_default
	src.verbs -= /mob/living/verb/ghost

/mob/living/silicon/ai/proc/remove_ai_verbs()
	src.verbs -= ai_verbs_default
	src.verbs += /mob/living/verb/ghost

/mob/living/silicon/ai/Initialize(mapload, var/datum/ai_laws/L, var/obj/item/mmi/B, var/safety = 0)
	announcement = new()
	announcement.title = "A.I. Announcement"
	announcement.announcement_type = "A.I. Announcement"
	announcement.newscast = 1

	var/list/possibleNames = global.ai_names

	var/pickedName = null
	while(!pickedName)
		pickedName = pick(global.ai_names)
		for (var/mob/living/silicon/ai/A in global.silicon_mob_list)
			if (A.real_name == pickedName && possibleNames.len > 1) //fixing the theoretically possible infinite loop
				possibleNames -= pickedName
				pickedName = null

	fully_replace_character_name(pickedName)
	anchored = 1
	set_density(1)

	holo_icon = getHologramIcon(icon('icons/mob/hologram.dmi',"Face"), custom_color_tone)
	holo_icon_longrange = getHologramIcon(icon('icons/mob/hologram.dmi',"Face"), hologram_color = HOLOPAD_LONG_RANGE)

	if(istype(L, /datum/ai_laws))
		laws = L

	aiMulti = new(src)

	additional_law_channels["Holopad"] = "h"

	if (isturf(loc))
		add_ai_verbs(src)

	//Languages
	add_language(/decl/language/binary, 1)
	add_language(/decl/language/machine, 1)
	add_language(/decl/language/human/common, 1)
	add_language(/decl/language/sign, 0)

	if(!safety)//Only used by AIize() to successfully spawn an AI.
		if (!B)//If there is no player/brain inside.
			empty_playable_ai_cores += new/obj/structure/aicore/deactivated(loc)//New empty terminal.
			. = INITIALIZE_HINT_QDEL
		else if(B.brainmob.mind)
			B.brainmob.mind.transfer_to(src)
			hud_list[HEALTH_HUD]      = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
			hud_list[STATUS_HUD]      = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
			hud_list[LIFE_HUD] 		  = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
			hud_list[ID_HUD]          = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
			hud_list[WANTED_HUD]      = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
			hud_list[IMPLOYAL_HUD]    = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
			hud_list[IMPCHEM_HUD]     = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
			hud_list[IMPTRACK_HUD]    = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
			hud_list[SPECIALROLE_HUD] = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
			ai_list += src

	create_powersupply()
	// Slightly wonky structures here due silicon init being a spaghetti
	// mess and returning early causing Destroy() to qdel paths.
	var/base_return_val = ..()
	if(. == INITIALIZE_HINT_QDEL)
		return

	ai_radio = silicon_radio
	return base_return_val

/mob/living/silicon/ai/proc/on_mob_init()
	//Prevents more than one active core spawning on the same tile. Technically just a sanitization for roundstart join
	for(var/obj/structure/aicore/C in src.loc)
		qdel(C)
	job = "AI"
	setup_icon()
	eyeobj.possess(src)
	CreateModularRecord(src, /datum/computer_file/report/crew_record/synth)
	show_join_message()

// Give our radio a bit of time to connect to the network and get its channels.
/mob/living/silicon/ai/proc/show_join_message()
	set waitfor = FALSE
	var/timeout_mob_init = world.time + 5 SECONDS
	while(world.time < timeout_mob_init && length(ai_radio?.get_accessible_channel_descriptions(src)) <= 1)
		sleep(1)
	to_chat(src, "<B>You are playing the [station_name()]'s AI. The AI cannot move, but can interact with many objects while viewing them (through cameras).</B>")
	to_chat(src, "<B>To look at other areas, click on yourself to get a camera menu.</B>")
	to_chat(src, "<B>While observing through a camera, you can use most (networked) devices which you can see, such as computers, APCs, intercoms, doors, etc.</B>")
	to_chat(src, "To use something, simply click on it.")
	var/list/channel_descriptions = ai_radio?.get_accessible_channel_descriptions(src)
	if(length(channel_descriptions))
		to_chat(src, "You can speak on comms channels with the following [length(channel_descriptions) == 1 ? "shortcut" : "shortcuts"]:")
		for(var/line in channel_descriptions)
			to_chat(src, line)
	show_laws()
	to_chat(src, "<b>These laws may be changed by other players or by other random events.</b>")

/mob/living/silicon/ai/Destroy()
	for(var/robot in connected_robots)
		var/mob/living/silicon/robot/S = robot
		S.connected_ai = null
	connected_robots.Cut()

	ai_list -= src
	ai_radio = null

	QDEL_NULL(announcement)
	QDEL_NULL(eyeobj)
	QDEL_NULL(psupply)
	QDEL_NULL(aiMulti)
	hack = null

	. = ..()

var/global/list/custom_ai_icons_by_ckey_and_name = list()
/mob/living/silicon/ai/proc/setup_icon()
	if(ckey)
		if(global.custom_ai_icons_by_ckey_and_name["[ckey][real_name]"])
			selected_sprite = global.custom_ai_icons_by_ckey_and_name["[ckey][real_name]"]
		else
			for(var/datum/custom_icon/cicon as anything in SScustomitems.custom_icons_by_ckey[ckey])
				if(cicon.category == "AI Icon" && lowertext(real_name) == cicon.character_name)
					selected_sprite = new /datum/ai_icon("Custom Icon - [cicon.character_name]", cicon.ids_to_icons[1], cicon.ids_to_icons[2], COLOR_WHITE, cicon.ids_to_icons[cicon.ids_to_icons[1]])
					global.custom_ai_icons_by_ckey_and_name["[ckey][real_name]"] = selected_sprite
					break
	update_icon()

/mob/living/silicon/ai/pointed(atom/A as mob|obj|turf in view())
	set popup_menu = 0
	set src = usr.contents
	return 0

/mob/living/silicon/ai/fully_replace_character_name(pickedName as text)
	..()
	announcement.announcer = pickedName
	if(eyeobj)
		eyeobj.SetName("[pickedName] (AI Eye)")

	setup_icon()

/mob/living/silicon/ai/proc/pick_icon()
	set category = "Silicon Commands"
	set name = "Set AI Core Display"
	if(stat || !has_power())
		return

	var/new_sprite = input("Select an icon!", "AI", selected_sprite) as null|anything in available_icons()
	if(new_sprite)
		selected_sprite = new_sprite

	update_icon()

/mob/living/silicon/ai/proc/pick_color()
	set category = "Silicon Commands"
	set name = "Set AI Hologram Color"
	if(stat || !has_power())
		return

	var/new_color = input("Select or enter a color!", "AI") as color
	if(new_color)
		custom_color_tone = new_color
		to_chat(src, SPAN_NOTICE("You need to change your holopad icon in order for the color change to take effect!"))

/mob/living/silicon/ai/proc/available_icons()
	. = list()
	for(var/ai_icon_type in get_ai_icon_subtypes())
		var/datum/ai_icon/ai_icon = global.ai_icon_subtypes[ai_icon_type]
		if(ai_icon.may_used_by_ai(src))
			dd_insertObjectList(., ai_icon)

	// Placing custom icons first to have them be at the top
	. = global.custom_ai_icons_by_ckey_and_name["[ckey][real_name]"] | .

/mob/living/silicon/ai/var/message_cooldown = 0
/mob/living/silicon/ai/proc/ai_announcement()
	set category = "Silicon Commands"
	set name = "Make Announcement"

	if(check_unable(AI_CHECK_WIRELESS | AI_CHECK_RADIO))
		return

	if(message_cooldown)
		to_chat(src, "Please allow one minute to pass between announcements.")
		return
	var/input = input(usr, "Please write a message to announce to the [station_name()] crew.", "A.I. Announcement") as null|message
	if(!input)
		return

	if(check_unable(AI_CHECK_WIRELESS | AI_CHECK_RADIO))
		return

	announcement.Announce(input)
	message_cooldown = 1
	spawn(600)//One minute cooldown
		message_cooldown = 0

/mob/living/silicon/ai/proc/ai_call_shuttle()
	set category = "Silicon Commands"
	set name = "Call Evacuation"

	if(check_unable(AI_CHECK_WIRELESS))
		return

	var/confirm = alert("Are you sure you want to evacuate?", "Confirm Evacuation", "Yes", "No")

	if(check_unable(AI_CHECK_WIRELESS))
		return

	if(confirm == "Yes")
		call_shuttle_proc(src)

	post_status("shuttle")

/mob/living/silicon/ai/proc/ai_recall_shuttle()
	set category = "Silicon Commands"
	set name = "Cancel Evacuation"

	if(check_unable(AI_CHECK_WIRELESS))
		return

	var/confirm = alert("Are you sure you want to cancel the evacuation?", "Confirm Cancel", "Yes", "No")
	if(check_unable(AI_CHECK_WIRELESS))
		return

	if(confirm == "Yes")
		cancel_call_proc(src)

/mob/living/silicon/ai/var/emergency_message_cooldown = 0
/mob/living/silicon/ai/proc/ai_emergency_message()
	set category = "Silicon Commands"
	set name = "Send Emergency Message"

	if(check_unable(AI_CHECK_WIRELESS))
		return
	if(!is_relay_online())
		to_chat(usr, "<span class='warning'>No emergency communication relay detected. Unable to transmit message.</span>")
		return
	if(emergency_message_cooldown)
		to_chat(usr, "<span class='warning'>Arrays cycling. Please stand by.</span>")
		return
	var/input = sanitize(input(usr, "Please choose a message to transmit to [global.using_map.boss_short] via quantum entanglement.  Please be aware that this process is very expensive, and abuse will lead to... termination.  Transmission does not guarantee a response. There is a 30 second delay before you may send another message, be clear, full and concise.", "To abort, send an empty message.", ""))
	if(!input)
		return
	Centcomm_announce(input, usr)
	to_chat(usr, "<span class='notice'>Message transmitted.</span>")
	log_say("[key_name(usr)] has made an IA [global.using_map.boss_short] announcement: [input]")
	emergency_message_cooldown = 1
	spawn(300)
		emergency_message_cooldown = 0


/mob/living/silicon/ai/check_eye(var/mob/user)
	if (!camera)
		return -1
	return 0

/mob/living/silicon/ai/restrained()
	return 0

/mob/living/silicon/ai/emp_act(severity)
	if (prob(30))
		view_core()
	..()

/mob/living/silicon/ai/OnSelfTopic(href_list)
	if (href_list["mach_close"]) // Overrides behavior handled in the ..()
		if (href_list["mach_close"] == "aialerts")
			viewalerts = 0
		return ..() // Does further work on this key

	if (href_list["switchcamera"])
		switchCamera(locate(href_list["switchcamera"])) in cameranet.cameras
		return TOPIC_HANDLED

	if (href_list["showalerts"])
		open_subsystem(/datum/nano_module/alarm_monitor/all)
		return TOPIC_HANDLED

	//Carn: holopad requests
	if (href_list["jumptoholopad"])
		var/obj/machinery/hologram/holopad/H = locate(href_list["jumptoholopad"])
		if(stat == CONSCIOUS)
			if(H)
				H.attack_ai(src) //may as well recycle
			else
				to_chat(src, "<span class='notice'>Unable to locate the holopad.</span>")
		return TOPIC_HANDLED

	if (href_list["track"])
		var/mob/target = locate(href_list["track"]) in SSmobs.mob_list
		var/mob/living/carbon/human/H = target

		if(!istype(H) || (html_decode(href_list["trackname"]) == H.get_visible_name()) || (html_decode(href_list["trackname"]) == H.get_id_name()))
			ai_actual_track(target)
		else
			to_chat(src, "<span class='warning'>System error. Cannot locate [html_decode(href_list["trackname"])].</span>")
		return TOPIC_HANDLED

	return ..()

/mob/living/silicon/ai/reset_view(atom/A)
	if(camera)
		camera.set_light(0)

	if(istype(A,/obj/machinery/camera))
		camera = A

	..()

	if(istype(A,/obj/machinery/camera))
		if(camera_light_on)
			A.set_light(AI_CAMERA_LUMINOSITY)
		else
			A.set_light(0)


/mob/living/silicon/ai/proc/switchCamera(var/obj/machinery/camera/C)
	if (!C || stat == DEAD) //C.can_use())
		return 0

	if(!src.eyeobj)
		view_core()
		return
	// ok, we're alive, camera is good and in our network...
	eyeobj.setLoc(get_turf(C))
	//machine = src

	return 1

/mob/living/silicon/ai/cancel_camera()
	set category = "Silicon Commands"
	set name = "Cancel Camera View"

	//src.cameraFollow = null
	src.view_core()

//Replaces /mob/living/silicon/ai/verb/change_network() in ai.dm & camera.dm
//Adds in /mob/living/silicon/ai/proc/ai_channel_change() instead
//Addition by Mord_Sith to define AI's channel change ability
/mob/living/silicon/ai/proc/get_camera_channel_list()
	if(check_unable())
		return

	var/list/valid_channels = list()
	var/list/devices_by_channel = camera_repository.get_devices_by_channel()
	for(var/channel in devices_by_channel)
		for(var/datum/extension/network_device/camera/D in devices_by_channel[channel])
			if(D.cameranet_enabled && D.is_functional())
				valid_channels += channel
				break
	return valid_channels

/mob/living/silicon/ai/proc/ai_channel_change(var/channel in get_camera_channel_list())
	set category = "Silicon Commands"
	set name = "Jump To Channel"
	unset_machine()

	if(!channel)
		return

	if(!eyeobj)
		view_core()
		return

	for(var/datum/extension/network_device/camera/D in camera_repository.devices_in_channel(channel))
		if(D.cameranet_enabled && D.is_functional())
			eyeobj.setLoc(get_turf(D.holder))
			break
	to_chat(src, "<span class='notice'>Switched to [channel] camera channel.</span>")
//End of code by Mord_Sith

/mob/living/silicon/ai/proc/ai_statuschange()
	set category = "Silicon Commands"
	set name = "AI Status"

	if(check_unable(AI_CHECK_WIRELESS))
		return

	set_ai_status_displays(src)
	return

//I am the icon meister. Bow fefore me.	//>fefore
/mob/living/silicon/ai/proc/ai_hologram_change()
	set name = "Change Hologram"
	set desc = "Change the default hologram available to AI to something else."
	set category = "Silicon Commands"

	if(check_unable())
		return

	var/input
	if(alert("Would you like to select a hologram based on a crew member or switch to unique avatar?",,"Crew Member","Unique")=="Crew Member")

		var/personnel_list[] = list()

		for(var/datum/computer_file/report/crew_record/t in global.all_crew_records)//Look in data core locked.
			personnel_list["[t.get_name()]: [t.get_rank()]"] = t.photo_front//Pull names, rank, and image.

		if(personnel_list.len)
			input = input("Select a crew member:") as null|anything in personnel_list
			var/icon/character_icon = personnel_list[input]
			if(character_icon)
				qdel(holo_icon)//Clear old icon so we're not storing it in memory.
				qdel(holo_icon_longrange)
				holo_icon = getHologramIcon(icon(character_icon), custom_tone = custom_color_tone)
				holo_icon_longrange = getHologramIcon(icon(character_icon), hologram_color = HOLOPAD_LONG_RANGE)
		else
			alert("No suitable records found. Aborting.")

	else
		var/list/hologramsAICanUse = list()
		var/holograms_by_type = decls_repository.get_decls_of_subtype(/decl/ai_holo)
		for (var/holo_type in holograms_by_type)
			var/decl/ai_holo/holo = holograms_by_type[holo_type]
			if (holo.may_be_used_by_ai(src))
				hologramsAICanUse.Add(holo)
		var/decl/ai_holo/choice = input("Please select a hologram:") as null|anything in hologramsAICanUse
		if(choice)
			qdel(holo_icon)
			qdel(holo_icon_longrange)
			holo_icon = getHologramIcon(icon(choice.icon, choice.icon_state), noDecolor=choice.bypass_colorize, custom_tone = custom_color_tone)
			holo_icon_longrange = getHologramIcon(icon(choice.icon, choice.icon_state), noDecolor=choice.bypass_colorize, hologram_color = HOLOPAD_LONG_RANGE)
			holo_icon_malf = choice.requires_malf
	return

//Toggles the luminosity and applies it by re-entereing the camera.
/mob/living/silicon/ai/proc/toggle_camera_light()
	set name = "Toggle Camera Light"
	set desc = "Toggles the light on the camera the AI is looking through."
	set category = "Silicon Commands"

	if(check_unable())
		return

	camera_light_on = !camera_light_on
	to_chat(src, "Camera lights [camera_light_on ? "activated" : "deactivated"].")
	if(!camera_light_on)
		if(camera)
			camera.set_light(0)
			camera = null
	else
		lightNearbyCamera()



// Handled camera lighting, when toggled.
// It will get the nearest camera from the eyeobj, lighting it.

/mob/living/silicon/ai/proc/lightNearbyCamera()
	if(camera_light_on && camera_light_on < world.timeofday)
		if(src.camera)
			var/obj/machinery/camera/camera = near_range_camera(src.eyeobj)
			if(camera && src.camera != camera)
				src.camera.set_light(0)
				if(!camera.light_disabled)
					src.camera = camera
					src.camera.set_light(AI_CAMERA_LUMINOSITY)
				else
					src.camera = null
			else if(isnull(camera))
				src.camera.set_light(0)
				src.camera = null
		else
			var/obj/machinery/camera/camera = near_range_camera(src.eyeobj)
			if(camera && !camera.light_disabled)
				src.camera = camera
				src.camera.set_light(AI_CAMERA_LUMINOSITY)
		camera_light_on = world.timeofday + 1 * 20 // Update the light every 2 seconds.


/mob/living/silicon/ai/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/aicard))

		var/obj/item/aicard/card = W
		card.grab_ai(src, user)

	else if(IS_WRENCH(W))
		if(anchored)
			user.visible_message("<span class='notice'>\The [user] starts to unbolt \the [src] from the plating...</span>")
			if(!do_after(user,40, src))
				user.visible_message("<span class='notice'>\The [user] decides not to unbolt \the [src].</span>")
				return
			user.visible_message("<span class='notice'>\The [user] finishes unfastening \the [src]!</span>")
			anchored = 0
			return
		else
			user.visible_message("<span class='notice'>\The [user] starts to bolt \the [src] to the plating...</span>")
			if(!do_after(user,40,src))
				user.visible_message("<span class='notice'>\The [user] decides not to bolt \the [src].</span>")
				return
			user.visible_message("<span class='notice'>\The [user] finishes fastening down \the [src]!</span>")
			anchored = 1
			return
	if(try_stock_parts_install(W, user))
		return
	if(try_stock_parts_removal(W, user))
		return
	else
		return ..()

/mob/living/silicon/ai/proc/control_integrated_radio()
	set name = "Radio Settings"
	set desc = "Allows you to change settings of your radio."
	set category = "Silicon Commands"

	if(check_unable(AI_CHECK_RADIO))
		return

	to_chat(src, "Accessing Subspace Transceiver control...")
	if (src.silicon_radio)
		src.silicon_radio.interact(src)

/mob/living/silicon/ai/proc/sensor_mode()
	set name = "Set Sensor Augmentation"
	set category = "Silicon Commands"
	set desc = "Augment visual feed with internal sensor overlays"
	toggle_sensor_mode()

/mob/living/silicon/ai/proc/toggle_hologram_movement()
	set name = "Toggle Hologram Movement"
	set category = "Silicon Commands"
	set desc = "Toggles hologram movement based on moving with your virtual eye."

	hologram_follow = !hologram_follow
	to_chat(usr, "<span class='info'>Your hologram will now [hologram_follow ? "follow" : "no longer follow"] you.</span>")

/mob/living/silicon/ai/proc/check_unable(var/flags = 0, var/feedback = 1)
	if(stat == DEAD)
		if(feedback) to_chat(src, "<span class='warning'>You are dead!</span>")
		return 1

	if(!has_power())
		if(feedback) to_chat(src, "<span class='warning'>You lack power!</span>")
		return 1

	if(self_shutdown)
		if(feedback) to_chat(src, "<span class='warning'>You are offline!</span>")
		return 1

	if((flags & AI_CHECK_WIRELESS) && src.control_disabled)
		if(feedback) to_chat(src, "<span class='warning'>Wireless control is disabled!</span>")
		return 1
	if((flags & AI_CHECK_RADIO) && src.ai_radio.disabledAi)
		if(feedback) to_chat(src, "<span class='warning'>System Error - Transceiver Disabled!</span>")
		return 1
	return 0

/mob/living/silicon/ai/proc/is_in_chassis()
	return isturf(loc)

/mob/living/silicon/ai/proc/multitool_mode()
	set name = "Toggle Multitool Mode"
	set category = "Silicon Commands"

	multitool_mode = !multitool_mode
	to_chat(src, "<span class='notice'>Multitool mode: [multitool_mode ? "E" : "Dise"]ngaged</span>")

/mob/living/silicon/ai/on_update_icon()
	..()
	if(!selected_sprite || !(selected_sprite in available_icons()))
		selected_sprite = get_ai_icon(default_ai_icon)

	icon = selected_sprite.icon
	if(stat == DEAD)
		icon_state = selected_sprite.dead_icon
		set_light(3, 1, selected_sprite.dead_light)
	else if(!has_power())
		icon_state = selected_sprite.nopower_icon
		set_light(1, 1, selected_sprite.nopower_light)
	else
		icon_state = selected_sprite.alive_icon
		set_light(1, 1, selected_sprite.alive_light)

// Pass lying down or getting up to our pet human, if we're in a rig.
/mob/living/silicon/ai/lay_down()
	set name = "Rest"
	set category = "IC"

	resting = 0
	var/obj/item/rig/rig = src.get_rig()
	if(rig)
		rig.force_rest(src)

/mob/living/silicon/ai/handle_reading_literacy(var/mob/user, var/text_content, var/skip_delays, var/digital = FALSE)
	. = digital ? ..(user, text_content, skip_delays) : stars(text_content)

/mob/living/silicon/ai/proc/ai_take_image()
	set name = "Take Photo"
	set desc = "Activates the given subsystem"
	set category = "Silicon Commands"

	silicon_camera.toggle_camera_mode()

/mob/living/silicon/ai/proc/ai_view_images()
	set name = "View Photo"
	set desc = "Activates the given subsystem"
	set category = "Silicon Commands"

	silicon_camera.viewpictures()

/mob/living/silicon/ai/proc/change_floor()
	set name = "Change Grid Color"
	set category = "Silicon Commands"

	var/f_color = input("Choose your color, dark colors are not recommended!") as color|null
	if(!length(f_color))
		return

	var/area/A = get_area(src)
	if(!A)
		return

	for(var/turf/simulated/floor/bluegrid/F in A)
		F.color = f_color

	to_chat(usr, SPAN_NOTICE("Proccessing strata color was changed to \"<font color='[f_color]'>[f_color]</font>\""))

/mob/living/silicon/ai/proc/show_crew_monitor()
	set category = "Silicon Commands"
	set name = "Show Crew Lifesigns Monitor"

	run_program("sensormonitor")

/mob/living/silicon/ai/proc/run_program(var/filename)
	var/datum/extension/interactive/os/os = get_extension(src, /datum/extension/interactive/os)
	if(!istype(os))
		to_chat(src, SPAN_WARNING("You seem to be lacking an OS capable device!"))
		return
	if(!os.on)
		os.system_boot()
	if(os.run_program(filename))
		os.ui_interact(src)

/mob/living/silicon/ai/get_admin_job_string()
	return "AI"

/mob/living/silicon/ai/eastface()
	if(holo)
		holo.set_dir_hologram(client.client_dir(EAST), src)
	return ..()

/mob/living/silicon/ai/westface()
	if(holo)
		holo.set_dir_hologram(client.client_dir(WEST), src)
	return ..()

/mob/living/silicon/ai/northface()
	if(holo)
		holo.set_dir_hologram(client.client_dir(NORTH), src)
	return ..()

/mob/living/silicon/ai/southface()
	if(holo)
		holo.set_dir_hologram(client.client_dir(SOUTH), src)
	return ..()

/mob/living/silicon/ai/say_understands(mob/speaker, decl/language/speaking)
	return (!speaking && ispAI(speaker)) || ..()
