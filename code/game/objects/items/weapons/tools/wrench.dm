/obj/item/wrench
	name = "wrench"
	desc = "A good, durable combination wrench, with self-adjusting, universal open- and ring-end mechanisms to match a wide variety of nuts and bolts."
	icon = 'icons/obj/items/tool/wrench.dmi'
	icon_state = ICON_STATE_WORLD
	slot_flags = SLOT_LOWER_BODY
	w_class = ITEM_SIZE_SMALL
	origin_tech = @'{"materials":1,"engineering":1}'
	material = /decl/material/solid/metal/steel
	center_of_mass = @'{"x":17,"y":16}'
	attack_verb = list("bashed", "battered", "bludgeoned", "whacked")
	material_alteration = MAT_FLAG_ALTERATION_COLOR
	drop_sound = 'sound/foley/bardrop1.ogg'
	var/handle_color
	var/static/list/valid_colours = list(COLOR_RED_GRAY, COLOR_MAROON, COLOR_DARK_BROWN, COLOR_GRAY20)

/obj/item/wrench/Initialize()
	. = ..()
	set_extension(src, /datum/extension/tool, list(TOOL_WRENCH = TOOL_QUALITY_DEFAULT))

/obj/item/wrench/proc/get_handle_color()
	return pick(valid_colours)

/obj/item/wrench/on_update_icon()
	. = ..()
	if(!handle_color)
		handle_color = get_handle_color()
	if(handle_color)
		add_overlay(mutable_appearance(icon, "[get_world_inventory_state()]_handle", handle_color))

// Twohanded wrench.
/obj/item/wrench/pipe
	name                       = "pipe wrench"
	desc                       = "You are no longer asking nicely."
	icon                       = 'icons/obj/items/tool/pipewrench.dmi'
	attack_verb                = list("bludgeoned", "slammed", "smashed", "wrenched")
	material                   = /decl/material/solid/metal/steel
	material_alteration        = MAT_FLAG_ALTERATION_NAME
	w_class                    = ITEM_SIZE_GARGANTUAN
	can_be_twohanded           = TRUE
	obj_flags                  = OBJ_FLAG_NO_STORAGE
	pickup_sound               = 'sound/foley/scrape1.ogg'
	drop_sound                 = 'sound/foley/tooldrop1.ogg'
	slot_flags                 = SLOT_BACK
	_base_attack_force         = 20

/obj/item/wrench/pipe/get_handle_color()
	return null

/obj/item/wrench/pipe/update_name()
	. = ..()
	SetName("enormous [name]")

/obj/item/wrench/pipe/Initialize()
	. = ..()
	set_extension(src, /datum/extension/tool, list(TOOL_WRENCH = TOOL_QUALITY_DEFAULT))

/obj/item/wrench/pipe/get_tool_quality(archetype)
	if(is_held_twohanded() && archetype == TOOL_WRENCH)
		return ..()
	return 0

/obj/item/wrench/pipe/afterattack(atom/A, mob/user, proximity)
	. = ..()
	if(proximity && istype(A,/obj/structure/window) && is_held_twohanded())
		var/obj/structure/window/W = A
		W.shatter()
