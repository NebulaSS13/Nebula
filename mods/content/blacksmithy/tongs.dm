/obj/item/tongs
	name        = "tongs"
	desc        = "Long-handled grippers well suited to fishing white-hot iron out of a forge fire."
	icon        = 'mods/content/blacksmithy/icons/tongs.dmi'
	icon_state  = ICON_STATE_WORLD
	material    = /decl/material/solid/metal/iron
	color       = /decl/material/solid/metal/iron::color
	obj_flags   = OBJ_FLAG_INSULATED_HANDLE
	material_alteration = MAT_FLAG_ALTERATION_ALL
	var/obj/item/holding_bar

/obj/item/tongs/on_update_icon()
	. = ..()
	if(holding_bar)
		// Note, not get_color(); heat color is temporarily applied over the top of base color.
		add_overlay(overlay_image(icon, "[icon_state]-bar", holding_bar.color, RESET_COLOR))

/obj/item/tongs/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing)
	if(overlay && holding_bar)
		var/check_state = "[overlay.icon_state]-bar"
		if(check_state_in_icon(check_state, overlay.icon))
			overlay.overlays += overlay_image(overlay.icon, check_state, holding_bar.get_color(), RESET_COLOR)
	. = ..()

/obj/item/tongs/Exited(atom/movable/AM, atom/new_loc)
	. = ..()
	if(AM == holding_bar)
		holding_bar = null
		update_icon()

/obj/item/tongs/Destroy()
	QDEL_NULL(holding_bar)
	. = ..()
