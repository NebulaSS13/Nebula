// Armor piercing projs
/obj/item/gun/hand/xray
	name = "x-ray laser carbine"
	desc = "A high-power laser gun capable of emitting concentrated x-ray blasts, that are able to penetrate laser-resistant armor much more readily than standard photonic beams."
	icon = 'icons/obj/guns/xray.dmi'
	icon_state = ICON_STATE_WORLD
	slot_flags = SLOT_LOWER_BODY|SLOT_BACK
	origin_tech = "{'combat':5,'materials':3,'magnets':2,'esoteric':2}"
	w_class = ITEM_SIZE_LARGE
	barrel = /obj/item/firearm_component/barrel/energy/xray
	receiver = /obj/item/firearm_component/receiver/energy/xray
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/uranium = MATTER_AMOUNT_TRACE
	)

/obj/item/firearm_component/barrel/energy/xray
	projectile_type = /obj/item/projectile/beam/xray/midlaser
	charge_cost = 15
	one_hand_penalty = 2

/obj/item/firearm_component/receiver/energy/xray
	max_shots = 10
	combustion = 0
