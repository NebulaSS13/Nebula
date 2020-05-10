
// folding/locking knives
/obj/item/material/knife/folding
	name = "pocketknife"
	desc = "A small folding knife."
	icon = 'icons/obj/items/weapon/knives/folding/basic.dmi'
	on_mob_icon = 'icons/obj/items/weapon/knives/folding/basic.dmi'
	material_force_multiplier = 0.2
	applies_material_name = FALSE
	unbreakable = TRUE
	w_class = ITEM_SIZE_SMALL
	attack_verb = list("prodded", "tapped")
	hitsound = "swing_hit"
	edge = FALSE
	sharp = FALSE
	draw_handle = TRUE
	valid_handle_colors = list(COLOR_DARK_GRAY, COLOR_RED_GRAY, COLOR_BLUE_GRAY, COLOR_DARK_BLUE_GRAY, COLOR_GREEN_GRAY, COLOR_DARK_GREEN_GRAY)

	var/open = FALSE
	var/closed_attack_verbs = list("prodded", "tapped") //initial doesnt work with lists, rip

/obj/item/material/knife/folding/attack_self(mob/user)
	open = !open
	update_force()
	update_icon()
	if(open)
		user.visible_message("<span class='warning'>\The [user] opens \the [src].</span>")
		playsound(user, 'sound/weapons/flipblade.ogg', 15, 1)
	else
		user.visible_message("<span class='notice'>\The [user] closes \the [src].</span>")
	add_fingerprint(user)

/obj/item/material/knife/folding/update_force()
	if(open)
		edge = 1
		sharp = 1
		hitsound = 'sound/weapons/bladeslice.ogg'
		w_class = ITEM_SIZE_NORMAL
		attack_verb = list("slashed", "stabbed")
		..()
	else
		edge = initial(edge)
		sharp = initial(sharp)
		hitsound = initial(hitsound)
		w_class = initial(w_class)
		attack_verb = closed_attack_verbs
		..()

/obj/item/material/knife/folding/on_update_icon()
	icon_state = get_world_inventory_state()
	if(open)
		icon_state = "[get_world_inventory_state()]_open"
	if(ismob(loc))
		var/mob/M = loc
		if(M.hand)
			M.update_inv_l_hand()
		else
			M.update_inv_r_hand()
	..()

/obj/item/material/knife/folding/experimental_mob_overlay(mob/user_mob, slot)
	if(open)
		return ..()
	
//Subtypes
/obj/item/material/knife/folding/wood
	name = "peasant knife"
	desc = "A small folding knife with a wooden handle and carbon steel blade. Knives like this have been used on Earth for centuries."
	on_mob_icon = 'icons/obj/items/weapon/knives/folding/peasant.dmi'
	valid_handle_colors = list(WOOD_COLOR_GENERIC, WOOD_COLOR_RICH, WOOD_COLOR_BLACK, WOOD_COLOR_CHOCOLATE, WOOD_COLOR_PALE)

/obj/item/material/knife/folding/tacticool
	name = "folding knife"
	desc = "A small folding knife with a polymer handle and a blackened steel blade. These are typically marketed for self defense purposes."
	on_mob_icon = 'icons/obj/items/weapon/knives/folding/tacticool.dmi'
	valid_handle_colors = list("#0f0f2a", "#2a0f0f", "#0f2a0f", COLOR_GRAY20, COLOR_DARK_GUNMETAL)

/obj/item/material/knife/folding/combat //master obj
	name = "switchblade"
	desc = "This is a master item - berate the admin or mapper who spawned this"
	material_force_multiplier = 0.25
	thrown_material_force_multiplier = 0.25
	valid_handle_colors = null

/obj/item/material/knife/folding/combat/balisong
	name = "butterfly knife"
	desc = "A basic metal blade concealed in a lightweight plasteel grip. Small enough when folded to fit in a pocket."
	on_mob_icon = 'icons/obj/items/weapon/knives/folding/butterfly.dmi'

/obj/item/material/knife/folding/combat/switchblade
	name = "switchblade"
	desc = "A classic switchblade with gold engraving. Just holding it makes you feel like a gangster."
	on_mob_icon = 'icons/obj/items/weapon/knives/folding/switchblade.dmi'
