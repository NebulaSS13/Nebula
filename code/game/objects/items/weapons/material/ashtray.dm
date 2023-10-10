/obj/item/ashtray
	name = "ashtray"
	desc = "A thing to keep your butts in."
	icon = 'icons/obj/objects.dmi'
	icon_state = "ashtray"
	material_force_multiplier = 0.1
	thrown_material_force_multiplier = 0.1
	randpixel = 5
	material = /decl/material/solid/metal/bronze
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME
	var/max_butts = 10

/obj/item/ashtray/examine(mob/user)
	. = ..()
	if(material)
		to_chat(user, "It's made of [material.solid_name].")
	if(contents.len >= max_butts)
		to_chat(user, "It's full.")
	else if(contents.len)
		to_chat(user, "It has [contents.len] cig butts in it.")

/obj/item/ashtray/on_update_icon()
	. = ..()
	if (contents.len == max_butts)
		add_overlay("ashtray_full")
	else if (contents.len >= max_butts/2)
		add_overlay("ashtray_half")

/obj/item/ashtray/attackby(obj/item/W, mob/user)
	if (istype(W,/obj/item/trash/cigbutt) || istype(W,/obj/item/clothing/mask/smokable/cigarette) || istype(W, /obj/item/flame/match))
		if (contents.len >= max_butts)
			to_chat(user, "\The [src] is full.")
			return

		if (istype(W,/obj/item/clothing/mask/smokable/cigarette))
			var/obj/item/clothing/mask/smokable/cigarette/cig = W
			if (cig.lit == 1)
				visible_message(SPAN_NOTICE("\The [user] crushes \the [cig] in \the [src], putting it out."))
				W = cig.extinguish(no_message = 1)
			else if (cig.lit == 0)
				to_chat(user, SPAN_NOTICE("You place \the [cig] in \the [src] without even smoking it. Why would you do that?"))
		else
			visible_message(SPAN_NOTICE("\The [user] places \the [W] in \the [src]."))

		if(user.try_unequip(W, src))
			set_extension(src, /datum/extension/scent/ashtray)
			update_icon()
	return ..()

/obj/item/ashtray/throw_impact(atom/hit_atom)
	. = ..()
	if(length(contents))
		visible_message(SPAN_DANGER("\The [src] slams into [hit_atom], spilling its contents!"))
		dump_contents()
		remove_extension(src, /datum/extension/scent)
		update_icon()
	take_damage(3, BRUTE, 0, hit_atom)

/obj/item/ashtray/plastic
	material = /decl/material/solid/plastic

/obj/item/ashtray/glass
	material = /decl/material/solid/glass
