// Armor piercing projs
/obj/item/gun/energy/xray
	name = "x-ray laser carbine"
	desc = "A high-power laser gun capable of emitting concentrated x-ray blasts, that are able to penetrate laser-resistant armor much more readily than standard photonic beams."
	on_mob_icon = 'icons/obj/guns/xray.dmi'
	icon = 'icons/obj/guns/xray.dmi'
	icon_state = "world"
	slot_flags = SLOT_BELT|SLOT_BACK
	origin_tech = "{'combat':5,'materials':3,'magnets':2,'esoteric':2}"
	projectile_type = /obj/item/projectile/beam/xray/midlaser
	one_hand_penalty = 2
	w_class = ITEM_SIZE_LARGE
	charge_cost = 15
	max_shots = 10
	combustion = 0
	material = MAT_STEEL
	matter = list(
		MAT_GLASS = MATTER_AMOUNT_REINFORCEMENT,
		MAT_URANIUM = MATTER_AMOUNT_TRACE
	)

