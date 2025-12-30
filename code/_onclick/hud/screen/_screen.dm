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
	/// Whether or not we look for/draw an additional detail overlay.
	var/apply_screen_overlay = TRUE

	// Do we take supplied color in Initialize()?
	var/use_supplied_ui_color = FALSE
	// Do we take supplied alpha in Initialize()?
	var/use_supplied_ui_alpha = FALSE
	// Do we take supplied icon in Initialize()?
	var/use_supplied_ui_icon  = TRUE

/obj/screen/Initialize(mapload, mob/_owner, decl/ui_style/ui_style, ui_color, ui_alpha, ui_cat)

	if(requires_ui_style)
		if(!ispath(ui_cat, /decl/hud_element) && !ispath(ui_style_category, /decl/hud_element))
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
	if(!isnull(ui_color) && use_supplied_ui_color)
		color = ui_color
	if(!isnull(ui_alpha) && use_supplied_ui_alpha)
		alpha = ui_alpha

	return ..()

/obj/screen/proc/get_owner_ui_style()
	var/mob/owner = owner_ref?.resolve()
	return (istype(owner) && istype(owner.hud_used)) ? owner.hud_used.get_ui_style_data() : null

/obj/screen/get_color()
	return color

/obj/screen/set_color(new_color)
	if(color != new_color)
		color = new_color
		return TRUE
	return FALSE

/obj/screen/proc/set_ui_style(decl/ui_style/ui_style, ui_cat)
	if(!isnull(ui_cat))
		ui_style_category = ui_cat
	if(istype(ui_style) && ui_style_category && use_supplied_ui_icon)
		icon = ui_style.get_icon(ui_style_category)
	update_icon()

/obj/screen/Destroy()
	var/mob/owner = owner_ref?.resolve()
	if(istype(owner) && owner.client?.screen)
		owner.client.screen -= src
	return ..()

/obj/screen/proc/handle_click(mob/user, params)
	return TRUE

/obj/screen/Click(location, control, params)
	var/list/paramlist = params2list(params)
	if(paramlist["shift"])
		return examined_by(usr, 0)
	if(ismob(usr) && usr.client && usr.canClick() && (!user_incapacitation_flags || !usr.incapacitated(user_incapacitation_flags)))
		return handle_click(usr, params)
	return FALSE

/obj/screen/receive_mouse_drop(atom/dropping, mob/user)
	return TRUE

/obj/screen/check_mousedrop_interactivity(var/mob/user)
	return user.client && (src in user.client.screen)

/obj/screen/on_update_icon()
	rebuild_screen_overlays()
	compile_overlays()

/obj/screen/proc/get_screen_overlay_state()
	return icon_state

/obj/screen/proc/rebuild_screen_overlays()
	SHOULD_CALL_PARENT(TRUE)
	cut_overlays()
	if(!apply_screen_overlay)
		return
	var/check_for_state = "[get_screen_overlay_state()]-overlay"
	if(!check_state_in_icon(check_for_state, icon))
		return
	var/decl/ui_style/ui_style = get_owner_ui_style()
	if(ui_style?.use_overlay_color)
		var/mob/living/owner = owner_ref?.resolve()
		add_overlay(overlay_image(icon, check_for_state, istype(owner) ? (owner?.client?.prefs.UI_style_highlight_color || COLOR_WHITE) : COLOR_WHITE, RESET_COLOR))
	else
		add_overlay(check_for_state)
