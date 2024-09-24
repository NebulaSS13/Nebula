/obj/item/bedroll
	name = "bedroll"
	desc = "A thick, padded bag big enough for a human to huddle in, rolled into a tight tube for easy-ish transport."
	icon = 'icons/obj/structures/bedroll.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_LARGE
	material = /decl/material/solid/organic/leather
	color = /decl/material/solid/organic/leather::color
	material_alteration = MAT_FLAG_ALTERATION_ALL
	var/padding_material
	var/belt_color = COLOR_BEASTY_BROWN
	var/structure_path = /obj/structure/bed/bedroll

/obj/item/bedroll/fur
	padding_material = /decl/material/solid/organic/skin/fur

/obj/item/bedroll/Initialize()
	// We need to set this initially so that we can pass it to our structure if we get unrolled.
	// In cases where the structure was spawned first, it overwrites matter anyway.
	if(padding_material)
		LAZYSET(matter, padding_material, MATTER_AMOUNT_REINFORCEMENT)
	. = ..()
	update_icon()

/obj/item/bedroll/on_update_icon()
	. = ..()
	icon_state = get_world_inventory_state()
	add_overlay(overlay_image(icon, "[icon_state]-straps", belt_color, RESET_COLOR))

/obj/item/bedroll/attack_self(mob/user)
	if(!user || !isturf(user?.loc))
		return ..()
	if(locate(/obj/structure/bed) in user.loc)
		to_chat(user, SPAN_WARNING("There's no room to unroll \the [src] here."))
		return TRUE
	var/obj/structure/bed = new structure_path(user.loc, material?.type, padding_material)
	user.visible_message(SPAN_NOTICE("\The [user] unrolls \the [src]."))
	bed.matter = matter?.Copy()
	qdel(src)
	return TRUE

/obj/structure/bed/bedroll
	name = "bedroll"
	desc = "A thick, padded bag big enough for a human to huddle in. It's better than sleeping on the ground."
	user_comfort = 0.65
	icon = 'icons/obj/structures/bedroll.dmi'
	icon_state = "bedroll"
	base_icon = "bedroll"
	w_class = ITEM_SIZE_LARGE
	anchored = FALSE
	material = /decl/material/solid/organic/leather
	reinf_material = null
	color = /decl/material/solid/organic/leather::color
	tool_interaction_flags = TOOL_INTERACTION_NONE // just use your hand on it nerd
	buckle_sound = "rustle"
	var/item_path = /obj/item/bedroll

/obj/structure/bed/bedroll/fur
	reinf_material = /decl/material/solid/organic/skin/fur
	color = /decl/material/solid/organic/skin/fur::color

/obj/structure/bed/bedroll/show_buckle_message(var/mob/buckled, var/mob/buckling)
	if(buckled == buckling)
		visible_message(
			SPAN_NOTICE("\The [buckled] climbs into \the [src]."),
			SPAN_NOTICE("You climb into \the [src]."),
			SPAN_NOTICE("You hear a rustling sound.")
		)
	else
		var/decl/pronouns/pronouns = buckled.get_pronouns()
		visible_message(
			SPAN_NOTICE("\The [buckled] [pronouns.is] bundled into \the [src] by \the [buckling]."),
			SPAN_NOTICE("You are bundled into \the [src] by \the [buckling]."),
			SPAN_NOTICE("You hear a rustling sound.")
		)

/obj/structure/bed/bedroll/show_unbuckle_message(var/mob/buckled, var/mob/buckling)
	if(buckled == buckling)
		visible_message(
			SPAN_NOTICE("\The [buckled] climbs out of \the [src]."),
			SPAN_NOTICE("You climb out of \the [src]."),
			SPAN_NOTICE("You hear a rustling sound.")
		)
	else
		visible_message(
			SPAN_NOTICE("\The [buckled] was pulled out of \the [src] by \the [buckling]."),
			SPAN_NOTICE("You were pulled out of \the [src] by \the [buckling]."),
			SPAN_NOTICE("You hear a rustling sound.")
		)

/obj/structure/bed/bedroll/on_update_icon()
	. = ..()
	var/image/I = overlay_image(icon, "[icon_state]_over")
	I.layer = buckled_mob ? ABOVE_HUMAN_LAYER : FLOAT_LAYER
	add_overlay(I)
	compile_overlays()

/obj/structure/bed/bedroll/buckle_mob(mob/M)
	. = ..()
	if(.)
		anchored = !!buckled_mob
		update_icon()

/obj/structure/bed/bedroll/unbuckle_mob()
	. = ..()
	if(.)
		anchored = !!buckled_mob
		update_icon()

/obj/structure/bed/bedroll/attack_hand(mob/user)
	. = ..()
	if(!. && !buckled_mob)
		roll_bed(user)
		return TRUE

/obj/structure/bed/bedroll/proc/roll_bed(mob/user)
	visible_message(SPAN_NOTICE("\The [user] rolls up \the [src]."))
	var/obj/item/bedroll/roll = new item_path(get_turf(src), material?.type)
	roll.padding_material = reinf_material?.type
	roll.matter = matter?.Copy()
	user.put_in_hands(roll)
	qdel(src)
	return roll

/obj/structure/bed/bedroll/handle_mouse_drop(atom/over, mob/user, params)
	if(over == user && Adjacent(src, user) && !user.incapacitated())
		roll_bed(user)
		return TRUE
	. = ..()
