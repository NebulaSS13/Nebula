/obj/item/scanner
	name = "handheld scanner"
	desc = "A hand-held scanner of some sort. You shouldn't be seeing it."
	icon = 'icons/obj/items/device/scanner/atmos_scanner.dmi'
	icon_state = "atmos"
	item_state = "analyzer"
	w_class = ITEM_SIZE_SMALL
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_LOWER_BODY
	item_flags = ITEM_FLAG_NO_BLUDGEON
	material = /decl/material/solid/metal/aluminium
	matter = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)
	drop_sound = 'sound/foley/drop1.ogg'
	pickup_sound = 'sound/foley/pickup2.ogg'

	var/scan_title
	var/scan_data
	var/window_width = 450
	var/window_height = 600
	var/use_delay
	var/scan_sound
	var/printout_color

/obj/item/scanner/attack_self(mob/user)
	show_menu(user)

/obj/item/scanner/proc/show_menu(mob/user)
	var/datum/browser/written_digital/popup = new(user, "scanner", scan_title, window_width, window_height)
	popup.set_content("[get_header()]<hr>[scan_data]")
	popup.open()

/obj/item/scanner/proc/get_header()
	return "<a href='?src=\ref[src];print=1'>Print Report</a><a href='?src=\ref[src];clear=1'>Clear data</a>"

/obj/item/scanner/proc/can_use(mob/user)
	if (user.incapacitated())
		return
	if (!user.check_dexterity(DEXTERITY_COMPLEX_TOOLS))
		return
	return TRUE

/obj/item/scanner/afterattack(atom/A, mob/user, proximity)
	if(!proximity)
		return
	if(!can_use(user))
		return
	if(is_valid_scan_target(A) && A.simulated)
		user.visible_message("<span class='notice'>[user] runs \the [src] over \the [A].</span>", range = 2)
		if(scan_sound)
			playsound(src, scan_sound, 30)
		if(check_state_in_icon("[icon_state]_active", icon))
			flick("[icon_state]_active", src)
		if(use_delay && !do_after(user, use_delay, A))
			to_chat(user, "You stop scanning \the [A] with \the [src].")
			return
		scan(A, user)
		if(!scan_title)
			scan_title = "[capitalize(name)] scan - [A]"
	else
		to_chat(user, "You cannot get any results from \the [A] with \the [src].")

/obj/item/scanner/proc/is_valid_scan_target(atom/O)
	return FALSE

/obj/item/scanner/proc/scan(atom/A, mob/user)

/obj/item/scanner/proc/print_report_verb()
	set name = "Print Report"
	set category = "Object"
	set src = usr

	var/mob/user = usr
	if(!istype(user))
		return
	if (user.incapacitated())
		return
	print_report(user)

/obj/item/scanner/OnTopic(var/user, var/list/href_list)
	if(href_list["print"])
		print_report(user)
		return 1
	if(href_list["clear"])
		to_chat(user, "You clear data buffer on [src].")
		scan_data = null
		scan_title = null
		return 1

/obj/item/scanner/proc/print_report(var/mob/living/user)
	if(!scan_data)
		to_chat(user, "There is no scan data to print.")
		return
	playsound(loc, "sound/machines/dotprinter.ogg", 20, 1)
	var/obj/item/paper/P = new(get_turf(src), null, scan_data, "paper - [scan_title]")
	if(printout_color)
		P.color = printout_color
	user.put_in_hands(P)
	user.visible_message("\The [src] spits out a piece of paper.")