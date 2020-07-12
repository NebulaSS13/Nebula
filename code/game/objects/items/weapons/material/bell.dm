// sprite stolen from vgstation

/obj/item/bell
	name = "bell"
	desc = "A bell to ring to get people's attention. Don't break it."
	icon = 'icons/obj/objects.dmi'
	icon_state = "bell"
	thrown_material_force_multiplier = 0.3
	hitsound = 'sound/items/oneding.ogg'
	material = /decl/material/solid/metal/aluminium
	applies_material_colour = TRUE
	applies_material_name = TRUE

/obj/item/bell/attack_hand(mob/user)
	if (user.a_intent == I_GRAB)
		return ..()
	else if (user.a_intent == I_HURT)
		user.visible_message("<span class='warning'>\The [user] hammers \the [src]!</span>")
		playsound(user.loc, 'sound/items/manydings.ogg', 60)
	else
		user.visible_message("<span class='notice'>\The [user] rings \the [src].</span>")
		playsound(user.loc, 'sound/items/oneding.ogg', 20)
	flick("bell_dingeth", src)

/obj/item/bell/apply_hit_effect()
	. = ..()
	shatter()