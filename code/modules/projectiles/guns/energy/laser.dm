/obj/item/gun/long/laser
	name = "laser carbine"
	desc = "A G40E carbine, designed to kill with concentrated energy blasts."
	icon = 'icons/obj/guns/laser_carbine.dmi'
	icon_state = ICON_STATE_WORLD
	slot_flags = SLOT_LOWER_BODY|SLOT_BACK
	w_class = ITEM_SIZE_LARGE
	force = 10
	origin_tech = "{'combat':3,'magnets':2}"
	material = /decl/material/solid/metal/steel
	receiver = /obj/item/firearm_component/receiver/energy/laser
	barrel = /obj/item/firearm_component/barrel/energy/laser

/obj/item/gun/long/laser/mounted
	receiver = /obj/item/firearm_component/receiver/energy/laser/mounted

/obj/item/gun/long/laser/practice
	name = "practice laser carbine"
	desc = "A modified version of the HI G40E, this one fires less concentrated energy bolts designed for target practice."
	receiver = /obj/item/firearm_component/barrel/energy/laser/practice
	receiver = /obj/item/firearm_component/receiver/energy/laser

/obj/item/gun/hand/antique
	name = "antique laser gun"
	icon = 'icons/obj/guns/caplaser.dmi'
	icon_state = ICON_STATE_WORLD
	desc = "A rare weapon, handcrafted by a now defunct specialty manufacturer on Luna for a small fortune. It's certainly aged well."
	force = 5
	slot_flags = SLOT_LOWER_BODY //too unusually shaped to fit in a holster
	w_class = ITEM_SIZE_NORMAL
	origin_tech = null
	receiver = /obj/item/firearm_component/receiver/energy/laser/antique
	barrel = /obj/item/firearm_component/barrel/energy/laser/antique

/obj/item/gun/cannon/laser
	name = "laser cannon"
	desc = "With the laser cannon, the lasing medium is enclosed in a tube lined with uranium-235 and subjected to high neutron flux in a nuclear reactor core. This incredible technology may help YOU achieve high excitation rates with small laser volumes!"
	icon_state = "lasercannon"
	icon = 'icons/obj/guns/laser_cannon.dmi'
	icon_state = ICON_STATE_WORLD
	origin_tech = "{'combat':4,'materials':3,'powerstorage':3}"
	slot_flags = SLOT_LOWER_BODY|SLOT_BACK
	w_class = ITEM_SIZE_HUGE
	accuracy = 2
	fire_delay = 20
	material = /decl/material/solid/metal/steel
	receiver = /obj/item/firearm_component/receiver/energy/laser/cannon
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_TRACE
	)

/obj/item/gun/cannon/laser/mounted
	name = "mounted laser cannon"
	accuracy = 0 //mounted laser cannons don't need any help, thanks
	receiver = /obj/item/firearm_component/receiver/energy/laser/cannon/mounted
