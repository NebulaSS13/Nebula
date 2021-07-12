//IPC-face object for FPB.
/obj/item/clothing/mask/monitor
	name = "display monitor"
	desc = "A rather clunky old CRT-style display screen, fit for mounting on an optical output."
	flags_inv = HIDEEYES
	body_parts_covered = SLOT_EYES
	dir = SOUTH
	icon = 'icons/clothing/mask/monitor.dmi'

	action_button_name = "Set Monitor State"
	action_button_desc = "Allows you to choose state for your monitor"

	var/monitor_state_index = "blank"
	var/static/list/monitor_states = list(
		"blank" =    "ipc_blank",
		"pink" =     "ipc_pink",
		"red" =      "ipc_red",
		"green" =    "ipc_green",
		"blue" =     "ipc_blue",
		"breakout" = "ipc_breakout",
		"eight" =    "ipc_eight",
		"goggles" =  "ipc_goggles",
		"heart" =    "ipc_heart",
		"monoeye" =  "ipc_monoeye",
		"nature" =   "ipc_nature",
		"orange" =   "ipc_orange",
		"purple" =   "ipc_purple",
		"shower" =   "ipc_shower",
		"static" =   "ipc_static",
		"yellow" =   "ipc_yellow",
		"smiley" =   "ipc_smiley",
		"list" =     "ipc_database",
		"yes" =      "ipc_yes",
		"no" =       "ipc_no",
		"frown" =    "ipc_frowny",
		"stars" =    "ipc_stars",
		"crt" =      "ipc_crt",
		"scroll" =   "ipc_scroll",
		"console" =  "ipc_console",
		"rgb" =      "ipc_rgb",
		"tetris" =   "ipc_tetris",
		"doom" =     "ipc_doom"
		)

/obj/item/clothing/mask/monitor/Initialize()
	. = ..()
	update_icon()

/obj/item/clothing/mask/monitor/get_mob_overlay(mob/user_mob, slot, bodypart)
	var/image/ret = ..()
	if(ret)
		if(!(monitor_state_index in monitor_states))
			monitor_state_index = initial(monitor_state_index)
		var/check_state = "[ret.icon_state]-[monitor_states[monitor_state_index]]"
		if(check_state_in_icon(check_state, ret.icon))
			ret.overlays += emissive_overlay(ret.icon, check_state)
	return ret

/obj/item/clothing/mask/monitor/set_dir()
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/obj/item/clothing/mask/monitor/equipped()
	..()
	var/mob/living/carbon/human/H = loc
	if(istype(H) && H.wear_mask == src)
		canremove = 0
		to_chat(H, SPAN_NOTICE("\The [src] connects to your display output."))

/obj/item/clothing/mask/monitor/dropped()
	canremove = 1
	return ..()

/obj/item/clothing/mask/monitor/mob_can_equip(var/mob/living/carbon/human/user, var/slot)
	. = ..()
	if(. && (slot == slot_head_str || slot == slot_wear_mask_str))
		var/obj/item/organ/external/E = user.organs_by_name[BP_HEAD]
		if(!istype(E) || !BP_IS_PROSTHETIC(E))
			to_chat(user, SPAN_WARNING("You must have a robotic head to install this upgrade."))
			return FALSE

/obj/item/clothing/mask/monitor/attack_self(mob/user)
	set_monitor_state()
	return TRUE

/obj/item/clothing/mask/monitor/verb/set_monitor_state()
	set name = "Set Monitor State"
	set desc = "Choose an icon for your monitor."
	set category = "IC"
	set src in usr

	var/mob/living/carbon/human/H = loc
	if(!istype(H) || H != usr)
		return

	if(H.wear_mask != src)
		to_chat(usr, "<span class='warning'>You have not installed \the [src] yet.</span>")
		return

	var/list/options = list()
	for(var/i in monitor_states)
		var/image/radial_button = image(icon, icon_state = "[initial(icon_state)]-[monitor_states[i]]")
		radial_button.name = i
		options[i] = radial_button

	var/choice = show_radial_menu(usr, usr, options, radius = 42, require_near = TRUE, tooltips = TRUE)
	if(choice && (H.wear_mask == src) && !QDELETED(src) && !H.incapacitated(INCAPACITATION_DISABLED))
		monitor_state_index = choice
		update_icon()

/obj/item/clothing/mask/monitor/on_update_icon()
	if(!(monitor_state_index in monitor_states))
		monitor_state_index = initial(monitor_state_index)
	icon_state = "[initial(icon_state)]-[monitor_states[monitor_state_index]]"
	var/mob/living/carbon/human/H = loc
	if(istype(H))
		H.update_inv_wear_mask()
