/obj/item/ammo_magazine/speedloader
	name = "speed loader"
	desc = "A speed loader for revolvers."
	icon_state = "spdloader"
	caliber = CALIBER_PISTOL
	ammo_type = /obj/item/ammo_casing/pistol
	material = MAT_STEEL
	max_ammo = 6
	multiple_sprites = 1

/obj/item/ammo_magazine/speedloader/rubber
	labels = list("rubber")
	ammo_type = /obj/item/ammo_casing/pistol/rubber

/obj/item/ammo_magazine/speedloader/magnum
	icon_state = "spdloader_magnum"
	caliber = CALIBER_PISTOL_MAGNUM
	ammo_type = /obj/item/ammo_casing/pistol/magnum
	material = MAT_STEEL
	max_ammo = 6
	multiple_sprites = 1

/obj/item/ammo_magazine/speedloader/small
	name = "speed loader"
	icon_state = "spdloader_small"
	caliber = CALIBER_PISTOL_SMALL
	ammo_type = /obj/item/ammo_casing/pistol/small
	material = MAT_STEEL
	max_ammo = 6
	multiple_sprites = 1

/obj/item/ammo_magazine/speedloader/clip
	name = "stripper clip"
	desc = "A stripper clip for bolt action rifles."
	icon_state = "clip"
	caliber = CALIBER_RIFLE
	ammo_type = /obj/item/ammo_casing/rifle
	material = MAT_STEEL
	max_ammo = 5
	multiple_sprites = 1

/obj/item/ammo_magazine/shotholder
	name = "shotgun slug holder"
	desc = "A convenient pouch that holds 12 gauge shells."
	icon_state = "shotholder"
	caliber = CALIBER_SHOTGUN
	ammo_type = /obj/item/ammo_casing/shotgun
	material = MAT_STEEL
	max_ammo = 4
	multiple_sprites = 1
	var/marking_color

/obj/item/ammo_magazine/shotholder/on_update_icon()
	..()
	overlays.Cut()
	if(marking_color)
		var/image/I = image(icon, "shotholder-marking")
		I.color = marking_color
		overlays += I

/obj/item/ammo_magazine/shotholder/attack_hand(mob/user)
	if((user.a_intent == I_HURT) && (stored_ammo.len))
		var/obj/item/ammo_casing/C = stored_ammo[stored_ammo.len]
		stored_ammo-=C
		user.put_in_hands(C)
		user.visible_message("\The [user] removes \a [C] from [src].", "<span class='notice'>You remove \a [C] from [src].</span>")
		update_icon()
	else
		..()

/obj/item/ammo_magazine/shotholder/shell
	name = "shotgun shell holder"
	ammo_type = /obj/item/ammo_casing/shotgun/pellet
	marking_color = COLOR_RED_GRAY

/obj/item/ammo_magazine/shotholder/beanbag
	name = "beanbag shell holder"
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag
	material = MAT_STEEL
	marking_color = COLOR_PAKISTAN_GREEN

/obj/item/ammo_magazine/shotholder/flash
	name = "illumination shell holder"
	ammo_type = /obj/item/ammo_casing/shotgun/flash
	material = MAT_STEEL
	marking_color = COLOR_PALE_YELLOW

/obj/item/ammo_magazine/shotholder/stun
	name = "stun shell holder"
	ammo_type = /obj/item/ammo_casing/shotgun/stunshell
	material = MAT_STEEL
	marking_color = COLOR_MUZZLE_FLASH

/obj/item/ammo_magazine/shotholder/empty
	name = "shotgun ammunition holder"
	material = MAT_STEEL
	initial_ammo = 0

/obj/item/ammo_magazine/machine_pistol
	name = "stick magazine"
	icon_state = "machine_pistol"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/pistol
	material = MAT_STEEL
	caliber = CALIBER_PISTOL
	max_ammo = 16
	multiple_sprites = 1

/obj/item/ammo_magazine/machine_pistol/empty
	initial_ammo = 0

/obj/item/ammo_magazine/smg_top
	name = "top mounted magazine"
	icon_state = "smg_top"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/pistol/small
	material = MAT_STEEL
	caliber = CALIBER_PISTOL_SMALL
	max_ammo = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/smg_top/empty
	initial_ammo = 0

/obj/item/ammo_magazine/smg_top/rubber
	labels = list("rubber")
	ammo_type = /obj/item/ammo_casing/pistol/small/rubber

/obj/item/ammo_magazine/smg_top/practice
	labels = list("practice")
	ammo_type = /obj/item/ammo_casing/pistol/small/practice

/obj/item/ammo_magazine/smg
	name = "box magazine"
	icon_state = "smg"
	origin_tech = "{'" + TECH_COMBAT + "':2}"
	mag_type = MAGAZINE
	caliber = CALIBER_PISTOL
	material = MAT_STEEL
	ammo_type = /obj/item/ammo_casing/pistol
	max_ammo = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/smg/empty
	initial_ammo = 0

/obj/item/ammo_magazine/pistol
	name = "pistol magazine"
	icon_state = "pistol"
	origin_tech = "{'" + TECH_COMBAT + "':2}"
	mag_type = MAGAZINE
	caliber = CALIBER_PISTOL
	material = MAT_STEEL
	ammo_type = /obj/item/ammo_casing/pistol
	max_ammo = 10
	multiple_sprites = 1

/obj/item/ammo_magazine/pistol/empty
	initial_ammo = 0

/obj/item/ammo_magazine/pistol/rubber
	labels = list("rubber")
	ammo_type = /obj/item/ammo_casing/pistol/rubber

/obj/item/ammo_magazine/pistol/double
	name = "doublestack pistol magazine"
	icon_state = "pistol"
	material = MAT_STEEL
	max_ammo = 15

/obj/item/ammo_magazine/pistol/double/rubber
	labels = list("rubber")
	ammo_type = /obj/item/ammo_casing/pistol/rubber

/obj/item/ammo_magazine/pistol/double/practice
	labels = list("practice")
	ammo_type = /obj/item/ammo_casing/pistol/practice

/obj/item/ammo_magazine/pistol/small
	icon_state = "holdout"
	material = MAT_STEEL
	caliber = CALIBER_PISTOL_SMALL
	ammo_type = /obj/item/ammo_casing/pistol/small
	max_ammo = 8

/obj/item/ammo_magazine/pistol/small/empty
	initial_ammo = 0

/obj/item/ammo_magazine/magnum
	name = "magazine"
	icon_state = "magnum"
	origin_tech = "{'" + TECH_COMBAT + "':2}"
	mag_type = MAGAZINE
	caliber = CALIBER_PISTOL_MAGNUM
	material = MAT_STEEL
	ammo_type = /obj/item/ammo_casing/pistol/magnum
	max_ammo = 7
	multiple_sprites = 1

/obj/item/ammo_magazine/magnum/empty
	initial_ammo = 0

/obj/item/ammo_magazine/box/smallpistol
	name = "ammunition box"
	icon_state = "smallpistol"
	origin_tech = "{'" + TECH_COMBAT + "':2}"
	material = MAT_STEEL
	caliber = CALIBER_PISTOL_SMALL
	ammo_type = /obj/item/ammo_casing/pistol/small
	max_ammo = 30

/obj/item/ammo_magazine/box/pistol
	name = "ammunition box"
	icon_state = "smallpistol"
	origin_tech = "{'" + TECH_COMBAT + "':2}"
	caliber = CALIBER_PISTOL
	material = MAT_STEEL
	ammo_type = /obj/item/ammo_casing/pistol
	max_ammo = 30

/obj/item/ammo_magazine/box/pistol/empty
	initial_ammo = 0

/obj/item/ammo_magazine/pistol/throwback
	name = "pistol magazine"
	caliber = CALIBER_PISTOL_ANTIQUE
	ammo_type = /obj/item/ammo_casing/pistol/throwback

/obj/item/ammo_magazine/box/emp/pistol
	name = "ammunition box"
	desc = "A box containing loose rounds of standard EMP ammo."
	labels = list("haywire")
	ammo_type = /obj/item/ammo_casing/pistol/emp
	caliber = CALIBER_PISTOL
	max_ammo = 15

/obj/item/ammo_magazine/box/emp/smallpistol
	name = "ammunition box"
	desc = "A box containing loose rounds of small EMP ammo."
	labels = list("haywire")
	ammo_type = /obj/item/ammo_casing/pistol/small/emp
	caliber = CALIBER_PISTOL_SMALL
	max_ammo = 8

/obj/item/ammo_magazine/proto_smg
	name = "submachine gun magazine"
	icon_state = CALIBER_PISTOL_FLECHETTE
	origin_tech = "{'" + TECH_COMBAT + "':4}"
	mag_type = MAGAZINE
	caliber = CALIBER_PISTOL_FLECHETTE
	material = MAT_STEEL
	ammo_type = /obj/item/ammo_casing/flechette
	max_ammo = 40
	multiple_sprites = 1

/obj/item/ammo_magazine/gyrojet
	name = "microrocket magazine"
	icon_state = "gyrojet"
	mag_type = MAGAZINE
	caliber = CALIBER_GYROJET
	ammo_type = /obj/item/ammo_casing/gyrojet
	multiple_sprites = 1
	max_ammo = 4

/obj/item/ammo_magazine/gyrojet/empty
	initial_ammo = 0

/obj/item/ammo_magazine/box/machinegun
	name = "magazine box"
	icon_state = "machinegun"
	origin_tech = "{'" + TECH_COMBAT + "':2}"
	mag_type = MAGAZINE
	caliber = CALIBER_RIFLE
	material = MAT_STEEL
	ammo_type = /obj/item/ammo_casing/rifle
	max_ammo = 50
	multiple_sprites = 1

/obj/item/ammo_magazine/box/machinegun/empty
	initial_ammo = 0

/obj/item/ammo_magazine/rifle
	name = "assault rifle magazine"
	icon_state = "assault_rifle"
	mag_type = MAGAZINE
	caliber = CALIBER_RIFLE
	material = MAT_STEEL
	ammo_type = /obj/item/ammo_casing/rifle
	max_ammo = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/mil_rifle
	name = "assault rifle magazine"
	icon_state = "bullup"
	origin_tech = "{'" + TECH_COMBAT + "':2}"
	mag_type = MAGAZINE
	caliber = CALIBER_RIFLE_MILITARY
	material = MAT_STEEL
	ammo_type = /obj/item/ammo_casing/rifle/military
	max_ammo = 15 //if we lived in a world where normal mags had 30 rounds, this would be a 20 round mag
	multiple_sprites = 1

/obj/item/ammo_magazine/mil_rifle/empty
	initial_ammo = 0

/obj/item/ammo_magazine/mil_rifle/practice
	labels = list("practice")
	ammo_type = /obj/item/ammo_casing/rifle/military/practice

/obj/item/ammo_magazine/caps
	name = "speed loader"
	desc = "A cheap plastic speed loader for some kind of revolver."
	icon_state = "T38"
	caliber = CALIBER_CAPS
	ammo_type = /obj/item/ammo_casing/cap
	material = MAT_STEEL
	max_ammo = 7
	multiple_sprites = 1
