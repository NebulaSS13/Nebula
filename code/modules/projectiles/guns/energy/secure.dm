/obj/item/gun/hand/egun/small/secure
	name = "compact smartgun"
	desc = "Combining the two LAEP90 variants, the secure and compact LAEP90-CS is the next best thing to keeping your security forces on a literal leash."
	icon = 'icons/obj/guns/small_egun_secure.dmi'
	req_access = list(list(access_brig, access_bridge))
	grip = /obj/item/firearm_component/grip/secure

/obj/item/gun/hand/egun/secure
	name = "smartgun"
	desc = "A more secure LAEP90, the LAEP90-S is designed to please paranoid constituents. Body cam not included."
	icon = 'icons/obj/guns/energy_gun_secure.dmi'
	item_state = null	//so the human update icon uses the icon_state instead.
	req_access = list(list(access_brig, access_bridge))
	grip = /obj/item/firearm_component/grip/secure

/obj/item/gun/hand/egun/secure/mounted
	name = "robot energy gun"
	desc = "A robot-mounted equivalent of the LAEP90-S, which is always registered to its owner."
	item_flags = ITEM_FLAG_INVALID_FOR_CHAMELEON
	receiver = /obj/item/firearm_component/receiver/energy/sidearm/mounted

/obj/item/gun/long/laser/secure
	name = "laser carbine"
	desc = "A G40E carbine, designed to kill with concentrated energy blasts. Fitted with an NT1019 chip to make sure killcount is tracked appropriately."
	req_access = list(list(access_brig, access_bridge))
	grip = /obj/item/firearm_component/grip/secure
