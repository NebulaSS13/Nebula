/obj/item/gun/bolt_action
	name = "bolt-action rifle"
	desc = "A slow-firing but reliable bolt-action rifle. Rather old-fashioned."
	icon = 'icons/obj/guns/bolt_action.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_HUGE
	force = 5
	slot_flags = SLOT_BACK
	origin_tech = "{'combat':4,'materials':2}"
	barrel = /obj/item/firearm_component/barrel/ballistic/rifle
	receiver = /obj/item/firearm_component/receiver/ballistic/rifle
	one_hand_penalty = 2
	fire_delay = 8

/obj/item/gun/bolt_action/sniper
	name = "anti-materiel rifle"
	desc = "A portable anti-armour rifle fitted with a scope, the HI PTR-7 Rifle was originally designed to be used against armoured exosuits. It is capable of punching through windows and non-reinforced walls with ease."
	icon = 'icons/obj/guns/heavysniper.dmi'
	force = 10
	origin_tech = "{'combat':7,'materials':2,'esoteric':8}"
	barrel = /obj/item/firearm_component/barrel/ballistic/sniper
	receiver = /obj/item/firearm_component/receiver/ballistic/rifle/sniper
	screen_shake = 2 //extra kickback
	one_hand_penalty = 6
	accuracy = -2
	bulk = 8
	scoped_accuracy = 8 //increased accuracy over the LWAP because only one shot
	scope_zoom = 2
	fire_delay = 12