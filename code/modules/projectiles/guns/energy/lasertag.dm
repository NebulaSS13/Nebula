
/obj/item/gun/energy/lasertag
	name = "laser tag gun"
	icon = 'icons/obj/guns/laser_carbine.dmi'
	icon_state = ICON_STATE_WORLD
	desc = "Standard issue weapon of the Imperial Guard."
	origin_tech = @'{"combat":1,"magnets":2}'
	self_recharge = 1
	material = /decl/material/solid/metal/steel
	projectile_type = /obj/item/projectile/beam/lastertag/blue
	var/required_vest

/obj/item/gun/energy/lasertag/special_check(var/mob/living/human/M)
	if(ishuman(M) && !istype(M.get_equipped_item(slot_wear_suit_str), required_vest))
		to_chat(M, SPAN_WARNING("You need to be wearing your laser tag vest!"))
		return FALSE
	return ..()

/obj/item/gun/energy/lasertag/blue
	color = COLOR_SKY_BLUE
	projectile_type = /obj/item/projectile/beam/lastertag/blue
	required_vest = /obj/item/clothing/suit/bluetag

/obj/item/gun/energy/lasertag/red
	color = COLOR_RED
	projectile_type = /obj/item/projectile/beam/lastertag/red
	required_vest = /obj/item/clothing/suit/redtag
