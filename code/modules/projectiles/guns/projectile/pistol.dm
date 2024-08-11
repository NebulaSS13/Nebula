/obj/item/gun/projectile/pistol
	name = "pistol"
	icon = 'icons/obj/guns/pistol.dmi'
	load_method = MAGAZINE
	caliber = CALIBER_PISTOL
	magazine_type = /obj/item/ammo_magazine/pistol
	allowed_magazines = /obj/item/ammo_magazine/pistol
	accuracy_power = 7
	safety_icon = "safety"
	ammo_indicator = TRUE

/obj/item/gun/projectile/pistol/rubber
	magazine_type = /obj/item/ammo_magazine/pistol/rubber

/obj/item/gun/projectile/pistol/emp
	magazine_type = /obj/item/ammo_magazine/pistol/emp

/obj/item/gun/projectile/pistol/update_base_icon_state()
	. = ..()
	if(!length(ammo_magazine?.stored_ammo))
		var/empty_state = "[icon_state]-e"
		if(check_state_in_icon(empty_state, icon))
			icon_state = empty_state

/obj/item/gun/projectile/pistol/holdout
	name = "holdout pistol"
	desc = "The Lumoco Arms P3 Whisper. A small, easily concealable gun."
	icon = 'icons/obj/guns/holdout_pistol.dmi'
	item_state = null
	ammo_indicator = FALSE
	w_class = ITEM_SIZE_SMALL
	caliber = CALIBER_PISTOL_SMALL
	fire_delay = 4
	origin_tech = @'{"combat":2,"materials":2,"esoteric":8}'
	magazine_type = /obj/item/ammo_magazine/pistol/small
	allowed_magazines = /obj/item/ammo_magazine/pistol/small

/obj/item/gun/projectile/pistol/holdout/can_have_silencer()
	return TRUE
