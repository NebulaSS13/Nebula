/obj/item/star
	name = "shuriken"
	desc = "A sharp, perfectly weighted piece of metal."
	icon = 'icons/obj/items/weapon/throwing_star.dmi'
	icon_state = "star"
	randpixel = 12
	material_force_multiplier = 0.1 // 6 with hardness 60 (steel)
	thrown_material_force_multiplier = 0.25 // 15 with weight 60 (steel)
	throw_speed = 10
	throw_range = 15
	sharp = 1
	edge =  1
	material = /decl/material/solid/metal/steel
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME
	item_flags = ITEM_FLAG_IS_WEAPON

/obj/item/star/get_max_weapon_value()
	return throwforce

/obj/item/star/throw_impact(atom/hit_atom)
	..()
	if(material.radioactivity>0 && isliving(hit_atom))
		var/mob/living/M = hit_atom
		var/urgh = material.radioactivity
		M.take_damage(rand(urgh/2,urgh), TOX)

/obj/item/star/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(user.a_intent == I_HURT)
		user.mob_throw_item(target, src)
