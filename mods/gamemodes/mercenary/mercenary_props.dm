/obj/structure/closet/syndicate/nuclear
	desc = "It's a storage unit for nuclear-operative gear."

/obj/structure/closet/syndicate/nuclear/WillContain()
	return list(
		/obj/item/ammo_magazine/smg = 5,
		/obj/item/box/handcuffs = 1,
		/obj/item/box/flashbangs = 1,
		/obj/item/gun/energy/gun = 5,
		/obj/item/pinpointer/nukeop = 5,
		/obj/item/modular_computer/pda/mercenary = 1,
		/obj/item/radio/uplink/mercenary = 1,
	)

// Four times as many TCs, because it used to spawn with 40 when traitors got 10, but that was never updated when TC costs were inflated.
/obj/item/radio/uplink/mercenary
	tc_amount = /obj/item/radio/uplink::tc_amount * 4