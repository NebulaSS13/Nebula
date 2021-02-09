/obj/item/gun/energy/taser
	name = "electrolaser"
	desc = "The Mk30 NL is a small, low capacity gun used for non-lethal takedowns. It can switch between high and low intensity stun shots."
	icon = 'icons/obj/guns/taser.dmi'
	icon_state = ICON_STATE_WORLD
	item_state = null	//so the human update icon uses the icon_state instead.
	max_shots = 5
	receiver = /obj/item/firearm_component/receiver/energy/electrolaser
	barrel =   /obj/item/firearm_component/barrel/energy/electrolaser

/obj/item/gun/energy/taser/mounted
	name = "mounted electrolaser"
	receiver = /obj/item/firearm_component/receiver/energy/electrolaser/mounted

/obj/item/gun/energy/taser/mounted/cyborg
	name = "electrolaser"
	receiver = /obj/item/firearm_component/receiver/energy/electrolaser/mounted/robot

/obj/item/gun/energy/plasmastun
	name = "plasma pulse projector"
	desc = "The Mars Military Industries MA21 Selkie is a weapon that uses a laser pulse to ionise the local atmosphere, creating a disorienting pulse of plasma and deafening shockwave as the wave expands."
	icon = 'icons/obj/guns/plasma_stun.dmi'
	icon_state = ICON_STATE_WORLD
	origin_tech = "{'combat':2,'materials':2,'powerstorage':3}"
	receiver = /obj/item/firearm_component/receiver/energy/plasma
	barrel =   /obj/item/firearm_component/barrel/energy/plasma

/obj/item/gun/energy/confuseray
	name = "disorientator"
	desc = "The W-T Mk. 4 Disorientator is a small, low capacity, and short-ranged energy projector intended for personal defense with minimal risk of permanent damage or cross-fire."
	icon = 'icons/obj/guns/confuseray.dmi'
	icon_state = ICON_STATE_WORLD
	origin_tech = "{'combat':2,'materials':2,'powerstorage':2}"
	w_class = ITEM_SIZE_SMALL
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)
	receiver = /obj/item/firearm_component/receiver/energy/confusion
	barrel =   /obj/item/firearm_component/barrel/energy/confusion
