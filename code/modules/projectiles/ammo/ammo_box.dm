//Ammo boxes

/obj/item/ammo_magazine/box
	name = "ammo box"
	desc = "An ammunition box."
	w_class = ITEM_SIZE_NORMAL
	mag_type = null //sorry revolver rambo :c
	var/glyph_color = null

/obj/item/ammo_magazine/box/Initialize()
	. = ..()
	if(glyph_color)
		add_overlay(mutable_appearance(icon, "[icon_state]-glyph", glyph_color))
	else
		icon_state = "[icon_state]-plain"

//Pistol

/obj/item/ammo_magazine/box/pistol
	icon_state = "box"
	caliber = CALIBER_PISTOL
	ammo_type = /obj/item/ammo_casing/pistol
	max_ammo = 40

/obj/item/ammo_magazine/box/pistol/rubber
	glyph_color = COLOR_GRAY40
	labels = list("rubber")
	ammo_type = /obj/item/ammo_casing/pistol/rubber

/obj/item/ammo_magazine/box/pistol/practice
	glyph_color = COLOR_SUN
	labels = list("practice")
	ammo_type = /obj/item/ammo_casing/pistol/practice

/obj/item/ammo_magazine/box/pistol/flash
	glyph_color = COLOR_ORANGE
	labels = list("flash")
	ammo_type = /obj/item/ammo_casing/pistol/flash

/obj/item/ammo_magazine/box/pistol/emp
	glyph_color = COLOR_LUMINOL
	labels = list("haywire")
	ammo_type = /obj/item/ammo_casing/pistol/emp

//Holdout

/obj/item/ammo_magazine/box/pistol_small
	icon_state = "holdoutbox"
	caliber = CALIBER_PISTOL_SMALL
	ammo_type = /obj/item/ammo_casing/pistol/small

/obj/item/ammo_magazine/box/pistol_small/rubber
	glyph_color = COLOR_GRAY40
	labels = list("rubber")
	ammo_type = /obj/item/ammo_casing/pistol/small/rubber

/obj/item/ammo_magazine/box/pistol_small/practice
	glyph_color = COLOR_SUN
	labels = list("practice")
	ammo_type = /obj/item/ammo_casing/pistol/small/practice

/obj/item/ammo_magazine/box/pistol_small/flash
	glyph_color = COLOR_ORANGE
	labels = list("flash")
	ammo_type = /obj/item/ammo_casing/pistol/small/flash

/obj/item/ammo_magazine/box/pistol_small/emp
	glyph_color = COLOR_LUMINOL
	labels = list("haywire")
	ammo_type = /obj/item/ammo_casing/pistol/small/emp

//Big holdout (/SMG, they are the same caliber)

/obj/item/ammo_magazine/box/pistol_small/big
	name = "big ammo box"
	icon_state = "bigholdoutbox"
	w_class = ITEM_SIZE_LARGE
	max_ammo = 80

/obj/item/ammo_magazine/box/pistol_small/big/rubber
	glyph_color = COLOR_GRAY40
	labels = list("rubber")
	ammo_type = /obj/item/ammo_casing/pistol/small/rubber

/obj/item/ammo_magazine/box/pistol_small/big/practice
	glyph_color = COLOR_SUN
	labels = list("practice")
	ammo_type = /obj/item/ammo_casing/pistol/small/practice

/obj/item/ammo_magazine/box/pistol_small/big/flash
	glyph_color = COLOR_ORANGE
	labels = list("flash")
	ammo_type = /obj/item/ammo_casing/pistol/small/flash

/obj/item/ammo_magazine/box/pistol_small/big/emp //holy mother of OP shit
	glyph_color = COLOR_LUMINOL
	labels = list("haywire")
	ammo_type = /obj/item/ammo_casing/pistol/small/emp

//Rifle

/obj/item/ammo_magazine/box/rifle
	name = "rifle ammo box"
	icon_state = "riflebox"
	w_class = ITEM_SIZE_LARGE
	caliber = CALIBER_RIFLE
	ammo_type = /obj/item/ammo_casing/rifle
	max_ammo = 72

/obj/item/ammo_magazine/box/rifle/rubber
	glyph_color = COLOR_GRAY40
	labels = list("rubber")
	ammo_type = /obj/item/ammo_casing/rifle/rubber

/obj/item/ammo_magazine/box/rifle/practice
	glyph_color = COLOR_SUN
	labels = list("practice")
	ammo_type = /obj/item/ammo_casing/rifle/practice

/obj/item/ammo_magazine/box/rifle/flash
	glyph_color = COLOR_ORANGE
	labels = list("flash")
	ammo_type = /obj/item/ammo_casing/rifle/flash

/obj/item/ammo_magazine/box/rifle/emp
	glyph_color = COLOR_LUMINOL
	labels = list("haywire")
	ammo_type = /obj/item/ammo_casing/rifle/emp

//Magnum

/obj/item/ammo_magazine/box/magnum
	icon_state = "magnumbox"
	caliber = CALIBER_PISTOL_MAGNUM
	ammo_type = /obj/item/ammo_casing/pistol/magnum
	max_ammo = 30

/obj/item/ammo_magazine/box/magnum/rubber
	glyph_color = COLOR_GRAY40
	labels = list("rubber")
	ammo_type = /obj/item/ammo_casing/pistol/magnum/rubber

/obj/item/ammo_magazine/box/magnum/practice
	glyph_color = COLOR_SUN
	labels = list("practice")
	ammo_type = /obj/item/ammo_casing/pistol/magnum/practice

/obj/item/ammo_magazine/box/magnum/flash
	glyph_color = COLOR_ORANGE
	labels = list("flash")
	ammo_type = /obj/item/ammo_casing/pistol/magnum/flash

/obj/item/ammo_magazine/box/magnum/emp
	glyph_color = COLOR_LUMINOL
	labels = list("haywire")
	ammo_type = /obj/item/ammo_casing/pistol/magnum/emp

/obj/item/ammo_magazine/box/magnum/stun
	glyph_color = COLOR_YELLOW
	labels = list("stun")
	ammo_type = /obj/item/ammo_casing/pistol/magnum/stun


//Lasbulb

/obj/item/ammo_magazine/box/lasbulb
	icon_state = "lasbox"
	caliber = CALIBER_PISTOL_LASBULB
	ammo_type = /obj/item/ammo_casing/lasbulb
	max_ammo = 30

/obj/item/ammo_magazine/box/lasbulb/stun
	icon_state = "lasbox-stun"
	labels = list("stun")
	ammo_type = /obj/item/ammo_casing/lasbulb/stun

//Shotgun

/obj/item/ammo_magazine/box/shotgun
	icon_state = "shotbox"
	caliber = CALIBER_SHOTGUN
	labels = list("slug")
	ammo_type = /obj/item/ammo_casing/shotgun
	max_ammo = 24

/obj/item/ammo_magazine/box/shotgun/pellet
	glyph_color = COLOR_RED_GRAY
	labels = list("pellet")
	ammo_type = /obj/item/ammo_casing/shotgun/pellet

/obj/item/ammo_magazine/box/shotgun/beanbag
	glyph_color = COLOR_PAKISTAN_GREEN
	labels = list("beanbag")
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag

/obj/item/ammo_magazine/box/shotgun/practice
	glyph_color = COLOR_GRAY40
	labels = list("practice")
	ammo_type = /obj/item/ammo_casing/shotgun/practice

/obj/item/ammo_magazine/box/shotgun/flash
	glyph_color = COLOR_PALE_YELLOW
	labels = list("flash")
	ammo_type = /obj/item/ammo_casing/shotgun/flash

/obj/item/ammo_magazine/box/shotgun/stun
	glyph_color = COLOR_MUZZLE_FLASH
	labels = list("stun")
	ammo_type = /obj/item/ammo_casing/shotgun/stun

/obj/item/ammo_magazine/box/shotgun/emp
	glyph_color = COLOR_LUMINOL
	labels = list("haywire")
	ammo_type = /obj/item/ammo_casing/shotgun/emp