/obj/item/magnetic_ammo
	name = "flechette magazine"
	desc = "A magazine containing steel flechettes."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "assault_rifle"
	var/projectile_type = /obj/item/projectile/bullet/magnetic/flechette
	var/projectile_name = "flechette"
	var/basetype = /obj/item/magnetic_ammo
	w_class = ITEM_SIZE_SMALL
	material = MAT_STEEL
	origin_tech = "{'" + TECH_COMBAT + "':1}"
	var/remaining = 9

/obj/item/magnetic_ammo/examine(mob/user)
	. = ..()
	to_chat(user, "There [(remaining == 1)? "is" : "are"] [remaining] [projectile_name]\s left!")
