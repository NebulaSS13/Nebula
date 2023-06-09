/obj/structure/banner_frame
	name = "banner frame"
	desc = "A sturdy frame suitable for hanging a banner."
	icon = 'icons/obj/structures/banner_frame.dmi'
	icon_state = "banner_stand"
	material = /decl/material/solid/wood
	anchored = TRUE
	density = FALSE
	opacity = FALSE
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CLIMBABLE
	layer = ABOVE_WINDOW_LAYER
	obj_flags = OBJ_FLAG_ANCHORABLE
	tool_interaction_flags = (TOOL_INTERACTION_ANCHOR | TOOL_INTERACTION_DECONSTRUCT)
	material_alteration = MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_COLOR
	maxhealth = 50
	/// Reference to any banner currently hung on the frame.
	var/obj/item/banner/banner

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
		desc = "[initial(desc)] [banner.hung_desc]"
	else
		name = initial(name)
		desc = initial(desc)
	update_icon()

/obj/structure/banner_frame/attack_hand(mob/user)
	if(banner && user.check_dexterity(DEXTERITY_GRIP))
		user.put_in_hands(banner)
		var/old_banner = banner
		set_banner(null)
		visible_message(SPAN_NOTICE("\The [user] removes \the [old_banner] from \the [src]."))
		return TRUE
	return ..()

/obj/structure/banner_frame/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/banner))
		if(banner)
			to_chat(user, SPAN_WARNING("There is already a banner hung on \the [src]."))
			return TRUE
		if(user.try_unequip(O, src))
			visible_message(SPAN_NOTICE("\The [user] hangs \the [O] from \the [src]."))
			set_banner(O)
		return TRUE
	return ..()

/obj/structure/banner_frame/dump_contents()
	if(istype(banner))
		banner.dropInto(loc)
		banner = null
	. = ..()

/obj/structure/banner_frame/on_update_icon()
	. = ..()
	if(istype(banner))
		var/image/I = image(banner.icon, "banner_base")
		I.appearance_flags |= RESET_COLOR
		I.color = banner.color
		add_overlay(I)
		for(var/decal in banner.decals)
			I = image(banner.icon, decal)
			I.appearance_flags |= RESET_COLOR
			I.color = banner.decals[decal]
			add_overlay(I)

/obj/structure/banner_frame/Destroy()
	if(istype(banner))
		QDEL_NULL(banner)
	return ..()

/obj/item/banner
	name = "banner"
	desc = "A furled-up banner."
	icon = 'icons/obj/banner.dmi'
	icon_state = "banner"
	material = /decl/material/solid/cloth
	max_health = 20
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME
	w_class = ITEM_SIZE_NORMAL
	var/hung_desc = "The banner is rather plain, with no markings."
	var/list/decals

/obj/item/banner/green
	name = "green banner"
	material_alteration = MAT_FLAG_ALTERATION_NONE
	color = COLOR_GREEN

/obj/item/banner/red
	name = "red banner"
	material_alteration = MAT_FLAG_ALTERATION_NONE
	color = COLOR_RED

/obj/item/banner/blue
	name = "blue banner"
	material_alteration = MAT_FLAG_ALTERATION_NONE
	color = COLOR_BLUE

// Mapping helpers below.
/obj/structure/banner_frame/blue
	banner = /obj/item/banner/blue

/obj/structure/banner_frame/red
	banner = /obj/item/banner/red

/obj/structure/banner_frame/green
	banner = /obj/item/banner/green
