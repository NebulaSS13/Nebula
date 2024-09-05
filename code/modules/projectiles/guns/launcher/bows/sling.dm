/obj/item/gun/launcher/bow/sling
	name = "sling"
	desc = "A simple strip of leather with a cup in the center, used to hurl stones with great speed."
	slot_flags = 0
	draw_time = 0.5 SECONDS
	icon = 'icons/obj/guns/launcher/sling.dmi'
	material = /decl/material/solid/organic/leather
	color = /decl/material/solid/organic/leather::color
	string = null
	max_tension = 1
	bow_ammo_type = null

/obj/item/gun/launcher/bow/sling/try_string(mob/user, obj/item/bowstring/new_string)
	return FALSE

/obj/item/gun/launcher/bow/sling/can_load_arrow(obj/item/ammo)
	return istype(ammo, /obj/item/rock) || istype(ammo, /obj/item/stack/material/ore) || istype(ammo, /obj/item/stack/material/lump)

/obj/item/gun/launcher/bow/sling/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE)
	if(overlay && tension)
		overlay.icon_state = "[overlay.icon_state]-swing"
	return ..()

/obj/item/gun/launcher/bow/sling/show_load_message(mob/user)
	if(user)
		user.visible_message(
			SPAN_NOTICE("\The [user] drops \the [_loaded] into \the cup of \the [src]."),
			SPAN_NOTICE("You drop \the [_loaded] into \the cup of \the [src].")
		)

/obj/item/gun/launcher/bow/sling/show_string_relax_message(mob/user)
	if(user)
		user.visible_message(
			"\The [user] ceases swinging \the [src].",
			"You cease swinging \the [src]."
		)

/obj/item/gun/launcher/bow/sling/show_cancel_draw_message(mob/user)
	if(user)
		user.visible_message(
			"\The [user] ceases swinging \the [src].",
			"You cease swinging \the [src]."
		)

/obj/item/gun/launcher/bow/sling/show_draw_message(mob/user)
	if(user)
		user.visible_message(
			SPAN_NOTICE("\The [user] starts swinging \the [src]"),
			SPAN_NOTICE("You start swinging \the [src].")
		)

/obj/item/gun/launcher/bow/sling/show_max_draw_message(mob/user)
	return

/obj/item/gun/launcher/bow/sling/show_working_draw_message(mob/user)
	return
