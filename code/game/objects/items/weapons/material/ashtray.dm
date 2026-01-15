/obj/item/ashtray
	name = "ashtray"
	desc = "A thing to keep your butts in."
	icon = 'icons/obj/objects.dmi'
	icon_state = "ashtray"
	randpixel = 5
	material = /decl/material/solid/metal/bronze
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC
	var/max_butts = 10

/obj/item/ashtray/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(contents.len >= max_butts)
		. += SPAN_WARNING("It's full.")
	else if(contents.len)
		. += "It has [contents.len] cigarette butt\s in it."

/obj/item/ashtray/on_update_icon()
	. = ..()
	if (contents.len == max_butts)
		add_overlay("ashtray_full")
	else if (contents.len >= max_butts/2)
		add_overlay("ashtray_half")

/obj/item/ashtray/attackby(obj/item/used_item, mob/user)
	if (istype(used_item,/obj/item/trash/cigbutt) || istype(used_item,/obj/item/clothing/mask/smokable/cigarette) || istype(used_item, /obj/item/flame/match))
		if (contents.len >= max_butts)
			to_chat(user, "\The [src] is full.")
			return TRUE

		if (istype(used_item,/obj/item/clothing/mask/smokable/cigarette))
			var/obj/item/clothing/mask/smokable/cigarette/cig = used_item
			if (cig.lit == 1)
				visible_message(SPAN_NOTICE("\The [user] crushes \the [cig] in \the [src], putting it out."))
				used_item = cig.extinguish_fire(no_message = TRUE)
			else if (cig.lit == 0)
				to_chat(user, SPAN_NOTICE("You place \the [cig] in \the [src] without even smoking it. Why would you do that?"))
		else
			visible_message(SPAN_NOTICE("\The [user] places \the [used_item] in \the [src]."))

		if(user.try_unequip(used_item, src))
			set_extension(src, /datum/extension/scent/ashtray)
			update_icon()
		return TRUE
	return ..()

/obj/item/ashtray/throw_impact(atom/hit_atom)
	. = ..()
	if(length(contents))
		visible_message(SPAN_DANGER("\The [src] slams into [hit_atom], spilling its contents!"))
		dump_contents()
		remove_extension(src, /datum/extension/scent)
		update_icon()
	take_damage(3, inflicter = hit_atom)

/obj/item/ashtray/plastic
	material = /decl/material/solid/organic/plastic

/obj/item/ashtray/glass
	material = /decl/material/solid/glass

/obj/item/ashtray/bronze
	material = /decl/material/solid/metal/bronze
