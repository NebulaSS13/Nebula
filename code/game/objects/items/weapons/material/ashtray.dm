/obj/item/ashtray
	name = "ashtray"
	desc = "A thing to keep your butts in."
	icon = 'icons/obj/objects.dmi'
	icon_state = "ashtray"
	material_force_multiplier = 0.1
	thrown_material_force_multiplier = 0.1
	randpixel = 5
	material = /decl/material/solid/metal/bronze
	applies_material_colour = TRUE
	applies_material_name = TRUE
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
	..()
	overlays.Cut()
	if (contents.len == max_butts)
		overlays |= image('icons/obj/objects.dmi',"ashtray_full")
	else if (contents.len >= max_butts/2)
		overlays |= image('icons/obj/objects.dmi',"ashtray_half")

/obj/item/ashtray/attackby(obj/item/W, mob/user)
	if (!is_alive())
		return
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

		if(user.unEquip(W, src))
			set_extension(src, /datum/extension/scent/ashtray)
			update_icon()
	else
		..()
		damage_health(W.force, W.damtype, TRUE)
		if (!is_alive())
			shatter()

/obj/item/ashtray/throw_impact(atom/hit_atom)
	..()
	if(health_max)
		damage_health(3, BRUTE, TRUE)
		if(contents.len)
			visible_message(SPAN_DANGER("\The [src] slams into [hit_atom], spilling its contents!"))
			for(var/obj/O in contents)
				O.dropInto(loc)
			remove_extension(src, /datum/extension/scent)
		if(!is_alive())
			shatter()
		else
			update_icon()

/obj/item/ashtray/plastic
	material = /decl/material/solid/plastic

/obj/item/ashtray/glass
	material = /decl/material/solid/glass
