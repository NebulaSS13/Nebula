/*
	Screen objects are only used for the hud and should not appear anywhere "in-game".
	They are used with the client/screen list and the screen_loc var.
	For more information, see the byond documentation on the screen_loc and screen vars.
*/
/obj/screen
	name              = ""
	plane             = HUD_PLANE
	layer             = HUD_BASE_LAYER
	appearance_flags  = NO_CLIENT_COLOR
	abstract_type     = /obj/screen
	is_spawnable_type = FALSE
	simulated         = FALSE

	/// The mob that owns this screen object, if any.
	var/weakref/owner_ref
	/// Whether or not this screen element requires an owner.
	var/requires_owner = TRUE
	/// Global screens are not qdeled when the holding mob is destroyed.
	var/is_global_screen = FALSE
	/// A set of flags to check for when the user clicks this element.
	var/user_incapacitation_flags = INCAPACITATION_DEFAULT
	/// A string reference to a /decl/ui_style icon category.
	var/ui_style_category
	/// Set to false for screen objects that do not rely on UI style to set their icon.
	var/requires_ui_style = TRUE

/obj/screen/Initialize(mapload, mob/_owner, decl/ui_style/ui_style, ui_color, ui_alpha, ui_cat)

	if(requires_ui_style)
		if(!istext(ui_cat) && !istext(ui_style_category))
			PRINT_STACK_TRACE("Screen object [type] initializing with invalid UI style category: [ui_cat || "NULL"], [ui_style_category || "NULL"].")
			return INITIALIZE_HINT_QDEL
		if(!istype(ui_style))
			PRINT_STACK_TRACE("Screen object [type] initializing with invalid UI style: [ui_style || "NULL"].")
			return INITIALIZE_HINT_QDEL

	if(ismob(_owner))
		owner_ref = weakref(_owner)

	// Validate ownership.
	if(requires_owner)
		if(!owner_ref)
			PRINT_STACK_TRACE("ERROR: [type]'s Initialize() was not given an owner argument.")
			return INITIALIZE_HINT_QDEL
	else if(owner_ref)
		PRINT_STACK_TRACE("ERROR: [type]'s Initialize() was given an owner argument.")
		return INITIALIZE_HINT_QDEL

	set_ui_style(ui_style, ui_cat)
	if(!isnull(ui_color))
		color = ui_color
	if(!isnull(ui_alpha))
		alpha = ui_alpha
	return ..()

/obj/screen/proc/set_ui_style(decl/ui_style/ui_style, ui_cat)
	if(istext(ui_cat))
		ui_style_category = ui_cat
	if(istype(ui_style) && ui_style_category)
		icon = ui_style.get_icon(ui_style_category)

/obj/screen/Destroy()
	if(owner_ref)
		var/mob/owner = owner_ref.resolve()
		if(istype(owner) && owner?.client?.screen)
			owner.client.screen -= src
	return ..()

/obj/screen/proc/handle_click(mob/user, params)
	if(!user)
		return TRUE
	switch(name)
		if("toggle")
			if(user.hud_used.inventory_shown)
				user.client.screen -= user.hud_used.other
				user.hud_used.hide_inventory()
			else
				user.client.screen += user.hud_used.other
				user.hud_used.show_inventory()
		if("equip")
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				H.quick_equip()
		if("resist")
			if(isliving(user))
				var/mob/living/L = user
				L.resist()
		if("Reset Machine")
			user.unset_machine()
		if("up hint")
			if(isliving(user))
				var/mob/living/L = user
				L.lookup()
		if("internal")
			if(isliving(user))
				var/mob/living/M = user
				M.ui_toggle_internals()
		if("act_intent")
			user.a_intent_change("right")
		if("throw")
			if(!user.stat && isturf(user.loc) && !user.restrained())
				user.toggle_throw_mode()
		if("drop")
			if(user.client)
				user.client.drop_item()
		if("module")
			if(isrobot(user))
				var/mob/living/silicon/robot/R = user
				R.pick_module()
		if("inventory")
			if(isrobot(user))
				var/mob/living/silicon/robot/R = user
				if(R.module)
					R.hud_used.toggle_show_robot_modules()
					return TRUE
				to_chat(R, "You haven't selected a module yet.")
		if("radio")
			if(isrobot(user))
				var/mob/living/silicon/robot/R = user
				R.radio_menu()
		if("panel")
			if(isrobot(user))
				var/mob/living/silicon/robot/R = user
				R.installed_modules()
		if("store")
			if(isrobot(user))
				var/mob/living/silicon/robot/R = user
				if(R.module)
					R.uneq_active()
					R.hud_used.update_robot_modules_display()
				else
					to_chat(R, "You haven't selected a module yet.")

		else
			return FALSE
	return TRUE

/obj/screen/Click(location, control, params)
	if(ismob(usr) && usr.client && usr.canClick() && (!user_incapacitation_flags || !usr.incapacitated(user_incapacitation_flags)))
		return handle_click(usr, params)
	return FALSE

/obj/screen/receive_mouse_drop(atom/dropping, mob/user)
	return TRUE

/obj/screen/check_mousedrop_interactivity(var/mob/user)
	return user.client && (src in user.client.screen)
