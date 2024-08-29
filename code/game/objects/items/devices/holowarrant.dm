/obj/item/holowarrant
	name = "warrant projector"
	desc = "The practical paperwork replacement for the officer on the go."
	icon = 'icons/obj/items/device/holowarrant.dmi'
	icon_state = "holowarrant"
	item_state = "holowarrant"
	w_class = ITEM_SIZE_SMALL
	throw_speed = 4
	throw_range = 10
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_LOWER_BODY
	req_access = list(list(access_heads, access_security))
	material = /decl/material/solid/organic/plastic
	matter = list(
		/decl/material/solid/metal/copper    = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/silicon         = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/glass           = MATTER_AMOUNT_TRACE,
	)
	var/datum/computer_file/report/warrant/active

/obj/item/holowarrant/Initialize(ml, material_key)
	. = ..()
	set_extension(src, /datum/extension/network_device/lazy)

//look at it
/obj/item/holowarrant/examine(mob/user, distance)
	. = ..()
	if(active)
		to_chat(user, "It's a holographic warrant for '[active.fields["namewarrant"]]'.")
	if(distance <= 1)
		show_content(user)
	else
		to_chat(user, "<span class='notice'>You have to be closer if you want to read it.</span>")

//hit yourself with it
/obj/item/holowarrant/attack_self(mob/user)
	ui_interact(user)

/obj/item/holowarrant/ui_interact(mob/user, ui_key = "main",var/datum/nanoui/ui = null)
	var/list/data = list()
	if(active)
		data["text"] += active.get_formatted_version()
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data)
	if (!ui)
		ui = new(user, src, ui_key, "holowarrant.tmpl", "Holowarrant Settings", 540, 326)
		ui.set_initial_data(data)
		ui.open()

/obj/item/holowarrant/OnTopic(mob/user, href_list, datum/topic_state/state)
	. = ..()
	if(.)
		return
	if(href_list["clear"])
		active = null
		update_icon()
		return TOPIC_REFRESH

	if(href_list["select"])
		var/list/active_warrants = list()
		for(var/datum/computer_file/report/warrant/W in global.all_warrants)
			if(!W.archived)
				active_warrants["[capitalize(W.get_category())] - [W.get_name()]"] = W
		if(!length(active_warrants))
			to_chat(user,SPAN_WARNING("There are no active warrants available."))
			return TOPIC_HANDLED

		var/selected_name = input(user, "Which warrant would you like to load?") as null|anything in active_warrants
		if(!selected_name)
			return TOPIC_HANDLED
		var/datum/computer_file/report/warrant/selected = active_warrants[selected_name]
		if(selected.archived || !(selected in global.all_warrants))
			to_chat(user,SPAN_WARNING("Invalid selection, try again."))
			return TOPIC_HANDLED
		active = selected
		update_icon()
		return TOPIC_REFRESH

	if(href_list["settings"])
		var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
		D.ui_interact(user)
		return TOPIC_HANDLED

/obj/item/holowarrant/attackby(obj/item/W, mob/user)
	if(active)
		var/obj/item/card/id/I = W.GetIdCard()
		if(I && check_access_list(I.GetAccess()))
			var/choice = alert(user, "Would you like to authorize this warrant?","Warrant authorization","Yes","No")
			var/datum/report_field/signature/auth = active.field_from_name("Authorized by")
			if(choice == "Yes")
				auth.ask_value(user)
			user.visible_message(SPAN_NOTICE("You swipe \the [I] through the [src]."),
								 SPAN_NOTICE("[user] swipes \the [I] through the [src]."))
			broadcast_security_hud_message("[active.get_broadcast_summary()] has been authorized by [auth.get_value()].", src)
		else
			to_chat(user, "<span class='notice'>A red \"Access Denied\" light blinks on \the [src]</span>")
		return 1
	..()

//hit other people with it
/obj/item/holowarrant/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)
	user.visible_message(
		SPAN_NOTICE("\The [user] holds up a warrant projector and shows the contents to \the [target]."),
		SPAN_NOTICE("You show the warrant to \the [target].")
	)
	target.examinate(src)
	return TRUE

/obj/item/holowarrant/on_update_icon()
	. = ..()
	if(active)
		icon_state = "holowarrant_filled"
	else
		icon_state = "holowarrant"

/obj/item/holowarrant/proc/show_content(mob/user, forceshow)
	if(!active)
		return
	show_browser(user, active.get_formatted_version(), "window=Warrant")
