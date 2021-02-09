/obj/item/gun/temperature
	name = "temperature gun"
	icon = 'icons/obj/guns/freezegun.dmi'
	icon_state = ICON_STATE_WORLD
	fire_sound = 'sound/weapons/pulse3.ogg'
	desc = "A gun that changes temperatures. It has a small label on the side, 'More extreme temperatures will cost more charge!'"
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/silver = MATTER_AMOUNT_TRACE
	)
	origin_tech = "{'combat':3,'materials':4,'powerstorage':3,'magnets':2}"
	slot_flags = SLOT_LOWER_BODY|SLOT_BACK
	barrel = /obj/item/firearm_component/barrel/energy/temperature
	receiver = /obj/item/firearm_component/receiver/energy/temperature
