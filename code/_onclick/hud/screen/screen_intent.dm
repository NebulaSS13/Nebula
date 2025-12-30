// Sub-element used for clickable intent selection.
/obj/screen/intent_button
	layer             = FLOAT_LAYER
	plane             = FLOAT_PLANE
	icon              = 'icons/screen/intents.dmi'
	icon_state        = "blank"
	requires_ui_style = FALSE
	screen_loc        = null // Technically a screen element, but we use vis_contents to draw them.
	var/obj/screen/intent/parent
	var/decl/intent/intent
	var/selected

/obj/screen/intent_button/Initialize(mapload, mob/_owner, decl/ui_style/ui_style, ui_color, ui_alpha, ui_cat, intent_owner)
	parent = intent_owner
	. = ..()

/obj/screen/intent_button/Destroy()
	parent = null
	intent = null
	return ..()

/obj/screen/intent_button/proc/set_selected(decl/intent/_intent)
	intent = _intent
	selected = TRUE
	update_icon()

/obj/screen/intent_button/proc/set_deselected(decl/intent/_intent)
	intent = _intent
	selected = FALSE
	update_icon()

/obj/screen/intent_button/handle_click(mob/user, params)
	. = ..()
	if(. && intent && parent)
		parent.set_intent(intent)

/obj/screen/intent_button/examined_by(mob/user, distance, infix, suffix)
	SHOULD_CALL_PARENT(FALSE)
	if(desc)
		to_chat(user, desc)
	return TRUE

/obj/screen/intent_button/on_update_icon()
	. = ..()
	screen_loc = null
	if(intent)
		name = intent.name
		desc = intent.desc
		icon = intent.icon
		icon_state = selected ? intent.icon_state : "[intent.icon_state]_off"

/obj/screen/intent_button/MouseEntered(location, control, params)
	if(intent && (intent.name || intent.desc))
		openToolTip(user = usr, tip_src = src, params = params, content = intent.desc)
	return ..()

/obj/screen/intent_button/MouseDown()
	closeToolTip(usr)
	return ..()

/obj/screen/intent_button/MouseExited()
	closeToolTip(usr)
	return ..()

/obj/screen/intent
	name                 = "intent"
	icon                 = 'icons/screen/intents.dmi'
	icon_state           = "blank"
	screen_loc           = ui_acti
	requires_ui_style    = FALSE
	apply_screen_overlay = FALSE
	var/intent_width     = 16
	var/intent_height    = 16
	var/list/intent_selectors

/obj/screen/intent/Initialize(mapload, mob/_owner, decl/ui_style/ui_style, ui_color, ui_alpha, ui_cat)
	. = ..()
	update_icon()
	// Hide from right-click.
	name = ""
	verbs.Cut()

/obj/screen/intent/Destroy()
	QDEL_NULL_LIST(intent_selectors)
	vis_contents.Cut()
	return ..()

/obj/screen/intent/proc/set_intent(decl/intent/intent)
	var/mob/owner = owner_ref?.resolve()
	if(istype(owner) && istype(intent))
		owner.set_intent(intent)
		update_icon()

/obj/screen/intent/proc/apply_intent_button_offset(atom/intent_button, index, intent_count)
	intent_button.pixel_z = 0
	intent_button.pixel_w = 0
	intent_button.pixel_y = 0
	intent_button.pixel_x = -((intent_count * intent_width)/2) + ((index-1) * intent_width)

/obj/screen/intent/proc/get_intent_button(index)
	. = (index >= 1 && index <= length(intent_selectors)) ? intent_selectors[index] : null
	if(!.)
		. = new /obj/screen/intent_button(null, owner_ref?.resolve(), null, null, null, null, src)
		LAZYADD(intent_selectors, .)

/obj/screen/intent/on_update_icon()
	..()

	var/mob/owner = owner_ref?.resolve()
	if(!istype(owner) || QDELETED(owner))
		return

	var/decl/intent/owner_intent = owner.get_intent()
	var/i = 1
	var/list/unused_selectors = intent_selectors?.Copy()
	var/list/all_intents = owner.get_available_intents(skip_update = TRUE)
	for(var/decl/intent/intent as anything in all_intents)
		var/obj/screen/intent_button/intent_button = get_intent_button(i)
		if(intent == owner_intent)
			intent_button.set_selected(intent)
		else
			intent_button.set_deselected(intent)
		LAZYREMOVE(unused_selectors, intent_button)
		i++
		apply_intent_button_offset(intent_button, i, length(all_intents))
		add_vis_contents(intent_button)

	if(length(unused_selectors))
		remove_vis_contents(unused_selectors)

/obj/screen/intent/binary
	intent_width     = 32
