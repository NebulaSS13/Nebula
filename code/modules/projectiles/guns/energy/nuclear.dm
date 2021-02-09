/obj/item/gun/energy/gun/nuclear
	name = "advanced energy gun"
	desc = "An energy gun with an experimental miniaturized reactor."
	icon = 'icons/obj/guns/adv_egun.dmi'
	origin_tech = "{'combat':3,'materials':5,'powerstorage':3}"
	slot_flags = SLOT_LOWER_BODY
	w_class = ITEM_SIZE_LARGE
	force = 8 //looks heavier than a pistol
	self_recharge = 1
	one_hand_penalty = 1 //bulkier than an e-gun, but not quite the size of a carbine
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/uranium = MATTER_AMOUNT_TRACE
	)
	receiver = /obj/item/firearm_component/receiver/energy/advanced
