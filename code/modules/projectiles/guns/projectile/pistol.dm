
/obj/item/gun/projectile/pistol
	name = "pistol"
	load_method = MAGAZINE
	caliber = CALIBER_PISTOL
	magazine_type = /obj/item/ammo_magazine/pistol
	allowed_magazines = /obj/item/ammo_magazine/pistol
	accuracy_power = 7
	safety_icon = "safety"
	var/empty_icon = TRUE  //If it should change icon when empty
	var/ammo_indicator = TRUE

/obj/item/gun/projectile/pistol/on_update_icon()
	..()
	if(empty_icon)
		if(ammo_magazine && ammo_magazine.stored_ammo.len)
			icon_state = initial(icon_state)
		else
			icon_state = "[initial(icon_state)]-e"
	if(ammo_indicator)
		if(!ammo_magazine || !LAZYLEN(ammo_magazine.stored_ammo))
			overlays += image(icon, "ammo_bad")
		else if(LAZYLEN(ammo_magazine.stored_ammo) <= 0.5 * ammo_magazine.max_ammo)
			overlays += image(icon, "ammo_warn")
			return
		else
			overlays += image(icon, "ammo_ok")

/obj/item/gun/projectile/pistol/holdout
	name = "holdout pistol"
	desc = "The Lumoco Arms P3 Whisper. A small, easily concealable gun."
	icon = 'icons/obj/guns/holdout_pistol.dmi'
	icon_state = "pistol"
	item_state = null
	ammo_indicator = FALSE
	w_class = ITEM_SIZE_SMALL
	caliber = CALIBER_PISTOL_SMALL
	silenced = 0
	fire_delay = 4
	origin_tech = "{'" + TECH_COMBAT + "':2,'" + TECH_MATERIAL + "':2,'" + TECH_ESOTERIC + "':8}"
	magazine_type = /obj/item/ammo_magazine/pistol/small
	allowed_magazines = /obj/item/ammo_magazine/pistol/small

/obj/item/gun/projectile/pistol/holdout/attack_hand(mob/user)
	if(user.get_inactive_hand() == src)
		if(silenced)
			if(user.l_hand != src && user.r_hand != src)
				..()
				return
			to_chat(user, "<span class='notice'>You unscrew [silenced] from [src].</span>")
			user.put_in_hands(silenced)
			silenced = initial(silenced)
			w_class = initial(w_class)
			update_icon()
			return
	..()

/obj/item/gun/projectile/pistol/holdout/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/silencer))
		if(user.l_hand != src && user.r_hand != src)	//if we're not in his hands
			to_chat(user, "<span class='notice'>You'll need [src] in your hands to do that.</span>")
			return
		if(!user.unEquip(I, src))
			return//put the silencer into the gun
		to_chat(user, "<span class='notice'>You screw [I] onto [src].</span>")
		silenced = I	//dodgy?
		w_class = ITEM_SIZE_NORMAL
		update_icon()
		return
	..()

/obj/item/gun/projectile/pistol/holdout/on_update_icon()
	..()
	if(silenced)
		icon_state = "pistol-silencer"
	else
		icon_state = "pistol"
	if(!(ammo_magazine && ammo_magazine.stored_ammo.len))
		icon_state = "[icon_state]-e"

/obj/item/silencer
	name = "silencer"
	desc = "A silencer."
	icon = 'icons/obj/guns/holdout_pistol.dmi'
	icon_state = "silencer"
	w_class = ITEM_SIZE_SMALL
