/obj/item/projectile/bullet/chemdart
	name = "dart"
	icon_state = "dart"
	damage = 5
	sharp = TRUE
	embed = 1 //the dart is shot fast enough to pierce space suits, so I guess splintering inside the target can be a thing. Should be rare due to low damage.
	life_span = 15 //shorter range
	muzzle_type = null
	material = /decl/material/solid/glass
	chem_volume = 15

/obj/item/projectile/bullet/chemdart/on_hit(var/atom/target, var/blocked = 0, var/def_zone = null)
	if(REAGENT_TOTAL_VOLUME(reagents) && blocked < 100 && isliving(target))
		var/mob/living/L = target
		if(L.can_inject(null, def_zone) == CAN_INJECT)
			reagents.trans_to_mob(L, REAGENT_TOTAL_VOLUME(reagents), CHEM_INJECT)

/obj/item/ammo_casing/chemdart
	name = "chemical dart"
	desc = "A small hardened, hollow dart."
	icon_state = "dart"
	caliber = CALIBER_DART
	projectile_type = /obj/item/projectile/bullet/chemdart
	leaves_residue = FALSE
	material = /decl/material/solid/organic/plastic
	color = null
	material_alteration = MAT_FLAG_ALTERATION_NONE

/obj/item/ammo_casing/chemdart/expend()
	qdel(src)

/obj/item/ammo_magazine/chemdart
	name = "dart cartridge"
	desc = "A rack of hollow darts."
	icon_state = "darts"
	item_state = "rcdammo"
	origin_tech = @'{"materials":2}'
	mag_type = MAGAZINE
	caliber = CALIBER_DART
	ammo_type = /obj/item/ammo_casing/chemdart
	max_ammo = 5
	multiple_sprites = 1