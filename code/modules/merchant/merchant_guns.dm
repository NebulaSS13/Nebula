/obj/item/gun/projectile/bolt_action/sniper/ant
	name = "anti-material rifle"
	desc = "A portable anti-armour rifle fitted with a scope, the HI PTR-7 Rifle was originally designed to used against armoured exosuits. It is capable of punching through windows and non-reinforced walls with ease. Fires armor piercing 14.5mm shells. This replica however fires pistol rounds."
	ammo_type = /obj/item/ammo_magazine/pistol/small
	caliber = CALIBER_PISTOL_SMALL

/obj/item/gun/energy/laser/dogan
	desc = "This carbine works just as well as a normal carbine. Most of the time." //removed reference to Dogan, since only the merchant is likely to know who that is.

/obj/item/gun/energy/laser/dogan/consume_next_projectile()
	projectile_type = pick(/obj/item/projectile/beam/midlaser, /obj/item/projectile/beam/lastertag/red, /obj/item/projectile/beam)
	return ..()

/obj/item/gun/projectile/automatic/smg/usi
	desc = "A cheap mass produced SMG. This one looks especially run-down. Uses pistol rounds."
	jam_chance = 20