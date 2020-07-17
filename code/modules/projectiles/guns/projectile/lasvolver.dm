/obj/item/gun/projectile/revolver/lasvolver
	name = "lasvolver"
	desc = "An inane combination of a lasgun and revolver, 'firing' special one-use flash capsules to produce laser bursts."
	icon = 'icons/obj/guns/lasvolver.dmi'
	fire_sound_text = "pop"
	caliber = CALIBER_PISTOL_LASBULB
	ammo_type = /obj/item/ammo_casing/lasbulb
	one_hand_penalty = 0
	bulk = 1
	screen_shake = 0

/obj/item/gun/projectile/revolver/lasvolver/handle_post_fire()
	. = ..()
	playsound(src,'sound/effects/rewind.ogg', 20, 0)