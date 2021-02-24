/obj/item/storage/wallet
	name = "wallet"
	desc = "It can hold a few small and personal things."
	icon = 'icons/obj/items/wallet.dmi'
	icon_state = "wallet-white"
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_SMALL //Don't worry, see can_hold[]
	max_storage_space = 8
	can_hold = list(
		/obj/item/cash,
		/obj/item/card,
		/obj/item/clothing/mask/smokable,
		/obj/item/lipstick,
		/obj/item/haircomb,
		/obj/item/mirror,
		/obj/item/clothing/accessory/locket,
		/obj/item/clothing/head/hairflower,
		/obj/item/flashlight/pen,
		/obj/item/flashlight,
		/obj/item/seeds,
		/obj/item/coin,
		/obj/item/dice,
		/obj/item/disk,
		/obj/item/implant,
		/obj/item/implanter,
		/obj/item/flame,
		/obj/item/paper,
		/obj/item/paper_bundle,
		/obj/item/pen,
		/obj/item/photo,
		/obj/item/chems/dropper,
		/obj/item/chems/syringe,
		/obj/item/chems/pill,
		/obj/item/chems/hypospray/autoinjector,
		/obj/item/chems/glass/beaker/vial,
		/obj/item/radio/headset,
		/obj/item/paicard,
		/obj/item/stamp,
		/obj/item/key,
		/obj/item/clothing/accessory/badge,
		/obj/item/clothing/accessory/medal,
		/obj/item/clothing/accessory/armor/tag,
		)
	slot_flags = SLOT_ID

	var/obj/item/card/id/front_id = null
	var/obj/item/charge_stick/front_stick = null

/obj/item/storage/wallet/leather
	color = COLOR_SEDONA

/obj/item/storage/wallet/Destroy()
	if(front_id)
		front_id.dropInto(loc)
		front_id = null
	if(front_stick)
		front_stick.dropInto(loc)
		front_stick = null
	. = ..()

/obj/item/storage/wallet/remove_from_storage(obj/item/W, atom/new_location)
	. = ..(W, new_location)
	if(.)
		if(W == front_id)
			front_id = null
			SetName(initial(name))
			update_icon()
		if(W == front_stick)
			front_stick = null

/obj/item/storage/wallet/handle_item_insertion(obj/item/W, prevent_warning = 0)
	. = ..(W, prevent_warning)
	if(.)
		if(!front_id && istype(W, /obj/item/card/id))
			front_id = W
			update_icon()
		if(!front_stick && istype(W, /obj/item/charge_stick))
			front_stick = W

/obj/item/storage/wallet/on_update_icon()
	overlays.Cut()
	if(front_id)
		var/tiny_state = "id-generic"
		if(("id-"+front_id.icon_state) in icon_states(icon))
			tiny_state = "id-"+front_id.icon_state
		var/image/tiny_image = new/image(icon, icon_state = tiny_state)
		tiny_image.appearance_flags = RESET_COLOR
		overlays += tiny_image

/obj/item/storage/wallet/GetIdCard()
	return front_id

/obj/item/storage/wallet/GetChargeStick()
	return front_stick

/obj/item/storage/wallet/GetAccess()
	var/obj/item/I = GetIdCard()
	if(I)
		return I.GetAccess()
	else
		return ..()

/obj/item/storage/wallet/random/Initialize()
	. = ..()
	var/item1_type = pick( /obj/item/cash/c10,/obj/item/cash/c100,/obj/item/cash/c1000,/obj/item/cash/c20,/obj/item/cash/c200,/obj/item/cash/c50, /obj/item/cash/c500)
	var/item2_type
	if(prob(50))
		item2_type = pick( /obj/item/cash/c10,/obj/item/cash/c100,/obj/item/cash/c1000,/obj/item/cash/c20,/obj/item/cash/c200,/obj/item/cash/c50, /obj/item/cash/c500)
	var/item3_type = pick( /obj/item/coin/silver, /obj/item/coin/silver, /obj/item/coin/gold, /obj/item/coin/iron, /obj/item/coin/iron, /obj/item/coin/iron )

	if(item1_type)
		new item1_type(src)
	if(item2_type)
		new item2_type(src)
	if(item3_type)
		new item3_type(src)
	update_icon()

/obj/item/storage/wallet/poly
	name = "polychromic wallet"
	desc = "You can recolor it! Fancy! The future is NOW!"

/obj/item/storage/wallet/poly/Initialize()
	. = ..()
	color = get_random_colour()
	update_icon()

/obj/item/storage/wallet/poly/verb/change_color()
	set name = "Change Wallet Color"
	set category = "Object"
	set desc = "Change the color of the wallet."
	set src in usr

	if(usr.incapacitated())
		return

	var/new_color = input(usr, "Pick a new color", "Wallet Color", color) as color|null
	if(!new_color || new_color == color || usr.incapacitated())
		return
	color = new_color

/obj/item/storage/wallet/poly/emp_act()
	icon_state = "wallet-emp"
	update_icon()

	spawn(200)
		if(src)
			icon_state = initial(icon_state)
			update_icon()
