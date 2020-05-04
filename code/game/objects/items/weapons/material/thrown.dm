/obj/item/material/star
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

/obj/item/material/star/throw_impact(atom/hit_atom)
	..()
	if(material.radioactivity>0 && istype(hit_atom,/mob/living))
		var/mob/living/M = hit_atom
		var/urgh = material.radioactivity
		M.adjustToxLoss(rand(urgh/2,urgh))

/obj/item/material/star/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(user.a_intent == I_HURT)
		user.throw_item(target)

/obj/item/material/star/ninja
	material = MAT_URANIUM
