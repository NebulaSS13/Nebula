
/obj/item/gun/energy/lasertag
	name = "laser tag gun"
	icon = 'icons/obj/guns/laser_carbine.dmi'
	on_mob_icon = 'icons/obj/guns/laser_carbine.dmi'
	icon_state = "world"
	desc = "Standard issue weapon of the Imperial Guard."
	origin_tech = "{'combat':1,'magnets':2}"
	self_recharge = 1
	material = MAT_STEEL
	projectile_type = /obj/item/projectile/beam/lastertag/blue
	var/required_vest

/obj/item/gun/energy/lasertag/special_check(var/mob/living/carbon/human/M)
	if(ishuman(M))
		if(!istype(M.wear_suit, required_vest))
			to_chat(M, "<span class='warning'>You need to be wearing your laser tag vest!</span>")
			return 0
	return ..()

/obj/item/gun/energy/lasertag/blue
	color = COLOR_SKY_BLUE
	projectile_type = /obj/item/projectile/beam/lastertag/blue
	required_vest = /obj/item/clothing/suit/bluetag

/obj/item/gun/energy/lasertag/red
	color = COLOR_RED
	projectile_type = /obj/item/projectile/beam/lastertag/red
	required_vest = /obj/item/clothing/suit/redtag
