// folding/locking knives
// TODO: Replace these with or merge these into /obj/item/bladed/folding
/obj/item/knife/folding
	name = "pocketknife"
	desc = "A small folding knife."
	icon = 'icons/obj/items/weapon/knives/folding/basic.dmi'
	w_class = ITEM_SIZE_SMALL
	attack_verb = list("prodded", "tapped")
	edge = FALSE
	sharp = FALSE
	draw_handle = TRUE
	valid_handle_colors = list(COLOR_DARK_GRAY, COLOR_RED_GRAY, COLOR_BLUE_GRAY, COLOR_DARK_BLUE_GRAY, COLOR_GREEN_GRAY, COLOR_DARK_GREEN_GRAY)
	material = /decl/material/solid/metal/steel
	material_alteration = MAT_FLAG_ALTERATION_COLOR
	var/open = FALSE
	var/closed_attack_verbs = list("prodded", "tapped") //initial doesnt work with lists, rip

/obj/item/knife/folding/attack_self(mob/user)
	open = !open
	update_attack_force()
	update_icon()
	if(open)
		user.visible_message("<span class='warning'>\The [user] opens \the [src].</span>")
		playsound(user, 'sound/weapons/flipblade.ogg', 15, 1)
	else
		user.visible_message("<span class='notice'>\The [user] closes \the [src].</span>")
	add_fingerprint(user)

/obj/item/knife/folding/update_attack_force()
	if(open)
		edge = 1
		sharp = 1
		w_class = ITEM_SIZE_NORMAL
		attack_verb = list("slashed", "stabbed")
		..()
	else
		edge = initial(edge)
		sharp = initial(sharp)
		w_class = initial(w_class)
		attack_verb = closed_attack_verbs
		..()

/obj/item/knife/folding/on_update_icon()
	. = ..()
	icon_state = get_world_inventory_state()
	if(open)
		icon_state = "[get_world_inventory_state()]_open"
	update_held_icon()

/obj/item/knife/folding/get_mob_overlay(mob/user_mob, slot, bodypart, use_fallback_if_icon_missing = TRUE, skip_adjustment = FALSE)
	. = open ? ..() : new /image

//Subtypes
/obj/item/knife/folding/wood
	name = "peasant knife"
	desc = "A small folding knife with a wooden handle and carbon steel blade. Knives like this have been used on Earth for centuries."
	icon = 'icons/obj/items/weapon/knives/folding/peasant.dmi'
	valid_handle_colors = list(WOOD_COLOR_GENERIC, WOOD_COLOR_RICH, WOOD_COLOR_BLACK, WOOD_COLOR_CHOCOLATE, WOOD_COLOR_PALE)

/obj/item/knife/folding/wood/get_striking_material(mob/user, atom/target)
	. = open ? ..() : GET_DECL(/decl/material/solid/organic/wood) // todo: different handle colors -> different material

/obj/item/knife/folding/tacticool
	name = "folding knife"
	desc = "A small folding knife with a polymer handle and a blackened steel blade. These are typically marketed for self defense purposes."
	icon = 'icons/obj/items/weapon/knives/folding/tacticool.dmi'
	valid_handle_colors = list("#0f0f2a", "#2a0f0f", "#0f2a0f", COLOR_GRAY20, COLOR_DARK_GUNMETAL)

/obj/item/knife/folding/tacticool/get_striking_material(mob/user, atom/target)
	. = open ? ..() : GET_DECL(/decl/material/solid/organic/plastic)

/obj/item/knife/folding/combat //master obj
	name = "switchblade"
	desc = "This is a master item - berate the admin or mapper who spawned this"
	valid_handle_colors = null

/obj/item/knife/folding/combat/balisong
	name = "butterfly knife"
	desc = "A basic metal blade concealed in a lightweight plasteel grip. Small enough when folded to fit in a pocket."
	icon = 'icons/obj/items/weapon/knives/folding/butterfly.dmi'

/obj/item/knife/folding/combat/switchblade
	name = "switchblade"
	desc = "A classic switchblade with gold engraving. Just holding it makes you feel like a gangster."
	icon = 'icons/obj/items/weapon/knives/folding/switchblade.dmi'
