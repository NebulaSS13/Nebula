/obj/item/gun/long/temperature
	name = "temperature gun"
	icon = 'icons/obj/guns/freezegun.dmi'
	desc = "A gun that changes temperatures. It has a small label on the side, 'More extreme temperatures will cost more charge!'"
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/silver = MATTER_AMOUNT_TRACE
	)
	barrel = /obj/item/firearm_component/barrel/energy/temperature
	receiver = /obj/item/firearm_component/receiver/energy/temperature
