/obj/item/ironingiron
	name = "iron"
	desc = "An ironing iron for ironing your iro- err... clothes."
	icon = 'icons/obj/items/clothes_iron.dmi'
	icon_state = "iron"
	item_state = "ironingiron"
	w_class = ITEM_SIZE_NORMAL
	throw_speed = 2
	throw_range = 10
	attack_verb = list("slammed", "whacked", "bashed", "thunked", "battered", "bludgeoned", "thrashed")
	material = /decl/material/solid/metal/steel
	_base_attack_force = 8
	var/enabled = 0

/obj/item/ironingiron/attack_self(var/mob/user)
	enabled = !enabled
	to_chat(user, "<span class='notice'>You turn \the [src.name] [enabled ? "on" : "off"].</span>")
	..()