/obj/structure/banner_frame
	name                   = "banner frame"
	desc                   = "A sturdy frame suitable for hanging a banner."
	icon                   = 'icons/obj/structures/banner_frame.dmi'
	icon_state             = "banner_stand_preview"
	material               = /decl/material/solid/organic/wood/oak
	color                  = /decl/material/solid/organic/wood/oak::color
	anchored               = TRUE
	opacity                = FALSE
	atom_flags             = ATOM_FLAG_CLIMBABLE
	layer                  = ABOVE_WINDOW_LAYER
	obj_flags              = OBJ_FLAG_ANCHORABLE
	tool_interaction_flags = (TOOL_INTERACTION_ANCHOR | TOOL_INTERACTION_DECONSTRUCT)
	material_alteration    = MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_COLOR
	max_health             = 50
	density                = TRUE

	var/force_south_facing = TRUE
	var/base_icon_state = "banner_stand"
	/// Reference to any banner currently hung on the frame.
	var/obj/item/banner/banner
	var/accepts_banner_type = /obj/item/banner

/obj/structure/banner_frame/set_dir(ndir)
	return ..(force_south_facing ? SOUTH : ndir)

/obj/structure/banner_frame/Initialize(ml, _mat, _reinf_mat)
	if(ispath(banner))
		set_banner(new banner(src))
	. = ..()
	update_icon()

/obj/structure/banner_frame/proc/set_banner(var/new_banner)
	if(banner == new_banner)
		return
	banner = new_banner
	if(banner)
		name = banner.name
		var/list/desc_strings = list(initial(desc), banner.hung_desc)
		var/decorations = banner.get_decal_string()
		if(decorations)
			desc_strings += "It is decorated with [decorations]."
		desc = jointext(desc_strings, " ")
	else
		name = initial(name)
		desc = initial(desc)
	update_icon()

/obj/structure/banner_frame/attack_hand(mob/user)
	if(banner && user.check_dexterity(DEXTERITY_HOLD_ITEM))
		user.put_in_hands(banner)
		var/old_banner = banner
		set_banner(null)
		user.visible_message(
			SPAN_NOTICE("\The [user] removes \the [old_banner] from \the [src]."),
			SPAN_NOTICE("You remove \the [old_banner] from \the [src]."),
			SPAN_NOTICE("You hear the rustling of fabric.")
		)
		return TRUE
	return ..()

/obj/structure/banner_frame/attackby(obj/item/used_item, mob/user)
	if(istype(used_item, /obj/item/banner))
		if(banner)
			to_chat(user, SPAN_WARNING("There is already a banner hung on \the [src]."))
			return TRUE

		var/obj/item/banner/other_banner = used_item
		if(other_banner.banner_type != accepts_banner_type)
			to_chat(user, SPAN_WARNING("\The [src] is not suitable for hanging \the [used_item]."))
			return TRUE

		if(user.try_unequip(used_item, src))
			user.visible_message(SPAN_NOTICE("\The [user] hangs \the [used_item] from \the [src]."), SPAN_NOTICE("You hang \the [used_item] from \the [src]."), SPAN_NOTICE("You hear the rustling of fabric."))
			set_banner(used_item)
		return TRUE
	return ..()

/obj/structure/banner_frame/dump_contents(atom/forced_loc = loc, mob/user)
	if(istype(banner))
		banner.dropInto(forced_loc)
		banner = null
	. = ..()

/obj/structure/banner_frame/on_update_icon()
	. = ..()

	icon_state = base_icon_state
	if(!istype(banner))
		return

	var/image/I = image(banner.icon, "[banner.icon_state]-hanging")
	I.appearance_flags |= RESET_COLOR
	I.color = banner.color
	add_overlay(I)

	for(var/decl/banner_symbol/decal as anything in banner.decals)
		I = image(decal.icon, decal.icon_state)
		I.appearance_flags |= RESET_COLOR
		I.blend_mode = BLEND_INSET_OVERLAY // Masks us to the banner icon.
		if(banner.colourise_decal)
			I.color = banner.decals[decal]
		else
			I.color = banner.color
		add_overlay(I)

	if(banner.trim_color)
		I = image(banner.icon, "[banner.icon_state]-trim")
		I.appearance_flags |= RESET_COLOR
		I.color = banner.trim_color
		add_overlay(I)

/obj/structure/banner_frame/Destroy()
	if(istype(banner))
		QDEL_NULL(banner)
	return ..()

// A wall-mounted banner frame with no stand.
/obj/structure/banner_frame/wall
	name               = "hanging banner frame"
	desc               = "A sturdy frame suitable for hanging a banner."
	icon_state         = "banner_hanging_preview"
	base_icon_state    = "banner_hanging"
	directional_offset = @'{"NORTH":{"y":-32},"SOUTH":{"y":-32},"EAST":{"x":-32},"WEST":{"x":-32}}'
	force_south_facing = FALSE
	density            = FALSE
