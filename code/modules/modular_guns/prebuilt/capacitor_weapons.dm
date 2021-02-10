/obj/item/gun/hand/capacitor_pistol
	name = "capacitor pistol"
	desc = "An excitingly chunky directed energy weapon that uses a modular capacitor array to charge each shot."
	icon = 'icons/obj/guns/capacitor_pistol.dmi'
	icon_state = ICON_STATE_WORLD
	origin_tech = "{'combat':4,'materials':4,'powerstorage':4}"
	w_class = ITEM_SIZE_NORMAL
	slot_flags = SLOT_LOWER_BODY
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_TRACE
	)
	barrel = /obj/item/firearm_component/barrel/energy/capacitor
	receiver = /obj/item/firearm_component/receiver/energy/capacitor
	grip = /obj/item/firearm_component/grip/capacitor

// Subtypes.
/obj/item/gun/long/capacitor_rifle
	name = "capacitor rifle"
	desc = "A heavy, unwieldly directed energy weapon that uses a linear capacitor array to charge a powerful beam."
	icon = 'icons/obj/guns/capacitor_rifle.dmi'
	barrel = /obj/item/firearm_component/barrel/energy/capacitor/rifle
	receiver = /obj/item/firearm_component/receiver/energy/capacitor/rifle
	grip = /obj/item/firearm_component/grip/capacitor/long

/obj/item/firearm_component/barrel/energy/capacitor/rifle
	one_hand_penalty = 6

/obj/item/firearm_component/receiver/energy/capacitor/rifle
	cell_type = /obj/item/cell/super
	max_capacitors = 4
	fire_delay = 20

/obj/item/gun/long/linear_fusion
	name = "linear fusion rifle"
	desc = "A chunky, angular, carbon-fiber-finish capacitor rifle, shipped complete with a self-charging power cell. The operating instructions seem to be written in backwards Cyrillic."
	color = COLOR_GRAY40
	barrel = /obj/item/firearm_component/barrel/energy/capacitor/rifle/lfr
	receiver = /obj/item/firearm_component/receiver/energy/capacitor/rifle/lfr
	grip = /obj/item/firearm_component/grip/capacitor/long/lfr

/obj/item/firearm_component/barrel/energy/capacitor/rifle/lfr
	projectile_type = /obj/item/projectile/beam/variable/split

/obj/item/firearm_component/receiver/energy/capacitor/rifle/lfr
	cell_type = /obj/item/cell/infinite
	capacitors = /obj/item/stock_parts/capacitor/super
