/obj/item/wallet
	name = "wallet"
	desc = "It can hold a few small and personal things."
	icon = 'icons/obj/items/wallet.dmi'
	icon_state = "wallet-white"
	w_class = ITEM_SIZE_SMALL
	storage = /datum/storage/wallet
	slot_flags = SLOT_ID
	material = /decl/material/solid/organic/leather

	var/obj/item/card/id/front_id = null
	var/obj/item/charge_stick/front_stick = null

/obj/item/wallet/leather
	color = COLOR_SEDONA

/obj/item/wallet/Destroy()
	if(front_id)
		front_id.dropInto(loc)
		front_id = null
	if(front_stick)
		front_stick.dropInto(loc)
		front_stick = null
	. = ..()

/obj/item/wallet/on_update_icon()
	. = ..()
	if(front_id)
		var/tiny_state = "id-generic"
		if(("id-"+front_id.icon_state) in icon_states(icon))
			tiny_state = "id-"+front_id.icon_state
		add_overlay(overlay_image(icon, tiny_state, flags = RESET_COLOR))

/obj/item/wallet/GetIdCards(list/exceptions)
	. = ..()
	if(istype(front_id) && !is_type_in_list(front_id, exceptions))
		LAZYDISTINCTADD(., front_id)

/obj/item/wallet/GetChargeStick()
	return front_stick

/obj/item/wallet/random/WillContain()
	. = list(
		new /datum/atom_creator/weighted(list(/obj/item/cash/c10,/obj/item/cash/c100,/obj/item/cash/c1000,/obj/item/cash/c20,/obj/item/cash/c200,/obj/item/cash/c50, /obj/item/cash/c500)),
		new /datum/atom_creator/weighted(list(/obj/item/coin/silver, /obj/item/coin/silver, /obj/item/coin/gold, /obj/item/coin/iron, /obj/item/coin/iron, /obj/item/coin/iron)),
	)
	if(prob(50))
		. += new /datum/atom_creator/weighted(list(/obj/item/cash/c10,/obj/item/cash/c100,/obj/item/cash/c1000,/obj/item/cash/c20,/obj/item/cash/c200,/obj/item/cash/c50, /obj/item/cash/c500))

/obj/item/wallet/random/Initialize(ml, material_key)
	. = ..()
	update_icon()

/obj/item/wallet/poly
	name = "polychromic wallet"
	desc = "You can recolor it! Fancy! The future is NOW!"

/obj/item/wallet/poly/Initialize(ml, material_key)
	. = ..()
	set_color(get_random_colour())
	update_icon()

/obj/item/wallet/poly/verb/change_color()
	set name = "Change Wallet Color"
	set category = "Object"
	set desc = "Change the color of the wallet."
	set src in usr

	if(usr.incapacitated())
		return

	var/new_color = input(usr, "Pick a new color", "Wallet Color", color) as color|null
	if(!new_color || new_color == color || usr.incapacitated())
		return
	set_color(new_color)

/obj/item/wallet/poly/emp_act()
	icon_state = "wallet-emp"
	update_icon()

	spawn(200)
		if(src)
			icon_state = initial(icon_state)
			update_icon()

/obj/item/wallet/get_alt_interactions(var/mob/user)
	. = ..()
	LAZYADD(., /decl/interaction_handler/remove_id/wallet)

/decl/interaction_handler/remove_id/wallet
	expected_target_type = /obj/item/wallet
	examine_desc = "remove an ID card"

/decl/interaction_handler/remove_id/wallet/is_possible(atom/target, mob/user, obj/item/prop)
	. = ..() && ishuman(user)

/decl/interaction_handler/remove_id/wallet/invoked(atom/target, mob/user, obj/item/prop)
	if(target?.storage)
		var/atom/movable/atom_target = target
		var/obj/item/card/id/id = atom_target.GetIdCard()
		if (istype(id))
			target.storage.remove_from_storage(user, id)
			user.put_in_hands(id)
