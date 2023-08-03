
//Pistol

/obj/item/ammo_magazine/pistol
	name = "pistol magazine"
	icon_state = "pistolds"
	mag_type = MAGAZINE
	caliber = CALIBER_PISTOL
	ammo_type = /obj/item/ammo_casing/pistol
	max_ammo = 12
	multiple_sprites = TRUE

/obj/item/ammo_magazine/pistol/empty
	initial_ammo = 0

/obj/item/ammo_magazine/pistol/rubber
	labels = list("rubber")
	ammo_type = /obj/item/ammo_casing/pistol/rubber

/obj/item/ammo_magazine/pistol/practice
	labels = list("practice")
	ammo_type = /obj/item/ammo_casing/pistol/practice

/obj/item/ammo_magazine/pistol/flash
	labels = list("flash")
	ammo_type = /obj/item/ammo_casing/pistol/flash

/obj/item/ammo_magazine/pistol/emp
	labels = list("haywire")
	ammo_type = /obj/item/ammo_casing/pistol/emp

//Holdout pistol

/obj/item/ammo_magazine/pistol/small
	icon_state = "holdout"
	caliber = CALIBER_PISTOL_SMALL
	ammo_type = /obj/item/ammo_casing/pistol/small
	max_ammo = 8

/obj/item/ammo_magazine/pistol/small/empty
	initial_ammo = 0

/obj/item/ammo_magazine/pistol/small/rubber
	labels = list("rubber")
	ammo_type = /obj/item/ammo_casing/pistol/small/rubber

/obj/item/ammo_magazine/pistol/small/practice
	labels = list("practice")
	ammo_type = /obj/item/ammo_casing/pistol/small/practice

/obj/item/ammo_magazine/pistol/small/flash
	labels = list("flash")
	ammo_type = /obj/item/ammo_casing/pistol/small/flash

/obj/item/ammo_magazine/pistol/small/emp
	labels = list("haywire")
	ammo_type = /obj/item/ammo_casing/pistol/small/emp

//Shotgun

/obj/item/ammo_magazine/shotholder
	name = "shell holder"
	desc = "A convenient pouch that holds shotgun shells."
	icon_state = "shotholder"
	caliber = CALIBER_SHOTGUN
	ammo_type = /obj/item/ammo_casing/shotgun
	max_ammo = 4
	multiple_sprites = TRUE
	var/marking_color = COLOR_GRAY

/obj/item/ammo_magazine/shotholder/on_update_icon()
	..()
	overlays.Cut()
	if(marking_color)
		var/image/I = image(icon, "shotholder-marking")
		I.color = marking_color
		overlays += I

/obj/item/ammo_magazine/shotholder/empty
	initial_ammo = 0
	marking_color = null

/obj/item/ammo_magazine/shotholder/pellet
	ammo_type = /obj/item/ammo_casing/shotgun/pellet
	marking_color = COLOR_RED_GRAY

/obj/item/ammo_magazine/shotholder/beanbag
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag
	marking_color = COLOR_PAKISTAN_GREEN

/obj/item/ammo_magazine/shotholder/flash
	ammo_type = /obj/item/ammo_casing/shotgun/flash
	marking_color = COLOR_PALE_YELLOW

/obj/item/ammo_magazine/shotholder/stun
	ammo_type = /obj/item/ammo_casing/shotgun/stun
	marking_color = COLOR_MUZZLE_FLASH

//Speedloaders

/obj/item/ammo_magazine/speedloader
	name = "speedloader"
	icon = 'icons/obj/ammo/speedloader.dmi'
	icon_state = ICON_STATE_WORLD
	caliber = CALIBER_PISTOL_MAGNUM
	ammo_type = /obj/item/ammo_casing/pistol/magnum
	max_ammo = 6
	var/list/bullet_offsets = list(
		list("x" = 0, "y" = 0),
		list("x" = -2, "y" = -3),
		list("x" = -2, "y" = -7),
		list("x" = 0, "y" = -10),
		list("x" = 2, "y" = -7),
		list("x" = 2, "y" = -3)
	)

/obj/item/ammo_magazine/speedloader/on_update_icon()
	. = ..()
	if(!length(stored_ammo))
		return
	switch(icon_state)
		if("world")
			var/ammo_state = "world-some"
			if(length(stored_ammo) == 1)
				ammo_state = "world-one"
			else if(length(stored_ammo) == max_ammo)
				ammo_state = "world-full"
			var/obj/item/ammo_casing/A = stored_ammo[1]
			add_overlay(overlay_image(icon, ammo_state, A.color, RESET_COLOR))
			add_overlay(overlay_image(icon, "[ammo_state]-bullets", A.bullet_color, flags = RESET_COLOR))
			if(A.marking_color)
				add_overlay(overlay_image(icon, "[ammo_state]-markings", A.marking_color, RESET_COLOR))
		if("inventory")
			for(var/i = 1 to length(stored_ammo))
				var/obj/item/ammo_casing/A = stored_ammo[i]
				var/image/I = overlay_image(icon, "casing", A.color, RESET_COLOR)
				if(A.marking_color)
					I.overlays += overlay_image(icon, "marking", A.marking_color, RESET_COLOR)
				if(A.BB)
					I.overlays += overlay_image(icon, "bullet", A.bullet_color, RESET_COLOR)
				I.pixel_x = bullet_offsets[i]["x"]
				I.pixel_y = bullet_offsets[i]["y"]
				add_overlay(I)

/obj/item/ammo_magazine/speedloader/empty
	initial_ammo = 0

/obj/item/ammo_magazine/speedloader/rubber
	labels = list("rubber")
	ammo_type = /obj/item/ammo_casing/pistol/magnum/rubber

/obj/item/ammo_magazine/speedloader/practice
	labels = list("practice")
	ammo_type = /obj/item/ammo_casing/pistol/magnum/practice

/obj/item/ammo_magazine/speedloader/flash
	labels = list("flash")
	ammo_type = /obj/item/ammo_casing/pistol/magnum/flash

/obj/item/ammo_magazine/speedloader/emp
	labels = list("haywire")
	ammo_type = /obj/item/ammo_casing/pistol/magnum/emp

/obj/item/ammo_magazine/speedloader/stun
	labels = list("stun")
	ammo_type = /obj/item/ammo_casing/pistol/magnum/stun

//lasbulb

/obj/item/ammo_magazine/speedloader/lasbulb
	caliber = CALIBER_PISTOL_LASBULB
	ammo_type = /obj/item/ammo_casing/lasbulb

//toyys

/obj/item/ammo_magazine/speedloader/caps
	desc = "A cheap plastic speed loader for some kind of revolver."
	caliber = CALIBER_CAPS
	material = /decl/material/solid/plastic
	ammo_type = /obj/item/ammo_casing/cap

//SMG

/obj/item/ammo_magazine/smg
	name = "top mounted magazine"
	icon_state = "smg_top"
	mag_type = MAGAZINE
	caliber = CALIBER_PISTOL_SMALL
	ammo_type = /obj/item/ammo_casing/pistol/small
	max_ammo = 20
	multiple_sprites = TRUE

/obj/item/ammo_magazine/smg/empty
	initial_ammo = 0

/obj/item/ammo_magazine/smg/rubber
	labels = list("rubber")
	ammo_type = /obj/item/ammo_casing/pistol/small/rubber

/obj/item/ammo_magazine/smg/practice
	labels = list("practice")
	ammo_type = /obj/item/ammo_casing/pistol/small/practice

/obj/item/ammo_magazine/smg/flash
	labels = list("flash")
	ammo_type = /obj/item/ammo_casing/pistol/small/flash

/obj/item/ammo_magazine/smg/emp
	labels = list("haywire")
	ammo_type = /obj/item/ammo_casing/pistol/small/emp

//Rifle

/obj/item/ammo_magazine/rifle
	name = "assault rifle magazine"
	icon_state = "bullup"
	mag_type = MAGAZINE
	caliber = CALIBER_RIFLE
	ammo_type = /obj/item/ammo_casing/rifle
	max_ammo = 18 //if we lived in a world where normal mags had 30 rounds, this would be a 20 round mag
	//increased by 3 from 15, now there's 6 dead people in one mag!
	multiple_sprites = TRUE

/obj/item/ammo_magazine/rifle/empty
	initial_ammo = 0

/obj/item/ammo_magazine/rifle/rubber
	labels = list("rubber")
	ammo_type = /obj/item/ammo_casing/rifle/rubber

/obj/item/ammo_magazine/rifle/practice
	labels = list("practice")
	ammo_type = /obj/item/ammo_casing/rifle/practice

/obj/item/ammo_magazine/rifle/flash
	labels = list("flash")
	ammo_type = /obj/item/ammo_casing/rifle/flash

/obj/item/ammo_magazine/rifle/emp
	labels = list("haywire")
	ammo_type = /obj/item/ammo_casing/rifle/emp

//Machinegun

/obj/item/ammo_magazine/machinegun
	name = "machine gun magazine"
	icon_state = "drum"
	mag_type = MAGAZINE
	caliber = CALIBER_RIFLE
	ammo_type = /obj/item/ammo_casing/rifle
	max_ammo = 100

//Chemdart

/obj/item/ammo_magazine/chemdart
	name = "dart cartridge"
	desc = "A rack of hollow darts."
	icon_state = "darts"
	mag_type = MAGAZINE
	caliber = CALIBER_DART
	ammo_type = /obj/item/ammo_casing/chemdart
	max_ammo = 5
	multiple_sprites = TRUE