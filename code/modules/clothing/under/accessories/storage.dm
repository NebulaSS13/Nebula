/obj/item/clothing/accessory/storage
	name = "webbing"
	desc = "Sturdy mess of synthcotton belts and buckles, ready to share your burden."
	icon = 'icons/clothing/accessories/storage/webbing.dmi'
	slot = ACCESSORY_SLOT_UTILITY
	w_class = ITEM_SIZE_NORMAL
	high_visibility = 1
	on_rolled = list("down" = "none")
	var/slots = 3
	var/max_w_class = ITEM_SIZE_SMALL //pocket sized
	var/obj/item/storage/internal/pockets/hold

/obj/item/clothing/accessory/storage/Initialize()
	. = ..()
	create_storage()

/obj/item/clothing/accessory/storage/proc/create_storage()
	hold = new/obj/item/storage/internal/pockets(src, slots, max_w_class)

/obj/item/clothing/accessory/storage/attack_hand(mob/user)
	if(has_suit && hold)	//if we are part of a suit
		hold.open(user)
		return

	if(hold && hold.handle_attack_hand(user))	//otherwise interact as a regular storage item
		..(user)

/obj/item/clothing/accessory/storage/MouseDrop(obj/over_object)
	if(has_suit)
		return

	if(hold && hold.handle_mousedrop(usr, over_object))
		..(over_object)

/obj/item/clothing/accessory/storage/attackby(obj/item/W, mob/user)
	if(hold)
		return hold.attackby(W, user)

/obj/item/clothing/accessory/storage/emp_act(severity)
	if(hold)
		hold.emp_act(severity)
		..()

/obj/item/clothing/accessory/storage/attack_self(mob/user)
	to_chat(user, "<span class='notice'>You empty [src].</span>")
	var/turf/T = get_turf(src)
	hold.hide_from(usr)
	for(var/obj/item/I in hold)
		hold.remove_from_storage(I, T, 1)
	hold.finish_bulk_removal()
	src.add_fingerprint(user)

/obj/item/clothing/accessory/storage/webbing_large
	name = "large webbing"
	desc = "A large collection of synthcotton pockets and pouches."
	icon = 'icons/clothing/accessories/storage/webbing_large.dmi'
	slots = 4

/obj/item/clothing/accessory/storage/vest
	name = "webbing vest"
	desc = "Durable synthcotton vest with lots of pockets to carry essentials."
	icon = 'icons/clothing/accessories/storage/vest.dmi'
	slots = 5

/obj/item/clothing/accessory/storage/vest/black
	name = "black webbing vest"
	desc = "Robust black synthcotton vest with lots of pockets to hold whatever you need, but cannot hold in hands."
	icon = 'icons/clothing/accessories/storage/vest_black.dmi'

/obj/item/clothing/accessory/storage/vest/brown
	name = "brown webbing vest"
	desc = "Worn brownish synthcotton vest with lots of pockets to unload your hands."
	icon = 'icons/clothing/accessories/storage/vest_brown.dmi'

/obj/item/clothing/accessory/storage/drop_pouches
	slots = 4 //to accomodate it being slotless

/obj/item/clothing/accessory/storage/drop_pouches/create_storage()
	hold = new/obj/item/storage/internal/pouch(src, slots*BASE_STORAGE_COST(max_w_class))

/obj/item/clothing/accessory/storage/drop_pouches/black
	name = "black drop pouches"
	desc = "Robust black synthcotton bags to hold whatever you need, but cannot hold in hands."
	icon = 'icons/clothing/accessories/pouches/thigh_black.dmi'

/obj/item/clothing/accessory/storage/drop_pouches/brown
	name = "brown drop pouches"
	desc = "Worn brownish synthcotton bags to hold whatever you need, but cannot hold in hands."
	icon = 'icons/clothing/accessories/pouches/thigh_brown.dmi'

/obj/item/clothing/accessory/storage/drop_pouches/white
	name = "white drop pouches"
	desc = "Durable white synthcotton bags to hold whatever you need, but cannot hold in hands."
	icon = 'icons/clothing/accessories/pouches/thigh_white.dmi'

/obj/item/clothing/accessory/storage/knifeharness
	name = "decorated harness"
	desc = "A heavily decorated harness of sinew and leather with two knife loops."
	icon = 'icons/clothing/accessories/clothing/harness_unathi.dmi'
	slots = 2
	max_w_class = ITEM_SIZE_NORMAL //for knives

/obj/item/clothing/accessory/storage/knifeharness/Initialize()
	. = ..()
	hold.can_hold = list(
		/obj/item/hatchet,
		/obj/item/knife,
	)
	new /obj/item/knife/table/primitive(hold)
	new /obj/item/knife/table/primitive(hold)
	update_icon()

/obj/item/clothing/accessory/storage/knifeharness/on_update_icon()
	icon_state = get_world_inventory_state()
	var/contents_count = min(length(contents), 2)
	if(contents_count > 0 && check_state_in_icon("[icon_state]-[contents_count]", icon))
		icon_state = "[icon_state]-[contents_count]"
	
/obj/item/clothing/accessory/storage/knifeharness/experimental_mob_overlay(mob/user_mob, slot, bodypart)
	var/image/ret = ..()
	var/contents_count = min(length(contents), 2)
	if(contents_count > 0 && check_state_in_icon("[ret.icon_state]-[contents_count]", ret.icon))
		ret.icon_state = "[ret.icon_state]-[contents_count]"
	return ret

/obj/item/clothing/accessory/storage/bandolier
	name = "bandolier"
	desc = "A lightweight synthethic bandolier with straps for holding ammunition or other small objects."
	icon = 'icons/obj/items/bandolier.dmi'
	slots = 10
	max_w_class = ITEM_SIZE_NORMAL

/obj/item/clothing/accessory/storage/bandolier/Initialize()
	. = ..()
	hold.can_hold = list(
		/obj/item/ammo_casing,
		/obj/item/grenade,
		/obj/item/knife,
		/obj/item/star,
		/obj/item/rcd_ammo,
		/obj/item/chems/syringe,
		/obj/item/chems/hypospray,
		/obj/item/chems/hypospray/autoinjector,
		/obj/item/syringe_cartridge,
		/obj/item/plastique,
		/obj/item/clothing/mask/smokable,
		/obj/item/screwdriver,
		/obj/item/multitool,
		/obj/item/magnetic_ammo,
		/obj/item/ammo_magazine,
		/obj/item/chems/glass/beaker/vial,
		/obj/item/paper,
		/obj/item/pen,
		/obj/item/photo,
		/obj/item/marshalling_wand,
		/obj/item/chems/pill,
		/obj/item/storage/pill_bottle
	)

