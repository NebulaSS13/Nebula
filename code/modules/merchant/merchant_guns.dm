/obj/item/gun/energy/laser/dogan
	desc = "This carbine works just as well as a normal carbine. Most of the time." //removed reference to Dogan, since only the merchant is likely to know who that is.

/obj/item/gun/energy/laser/dogan/consume_next_projectile()
	projectile_type = pick(/obj/item/projectile/beam/midlaser, /obj/item/projectile/beam/lastertag/red, /obj/item/projectile/beam)
	return ..()

/obj/item/gun/automatic/smg/usi
	desc = "A cheap mass produced SMG. This one looks especially run-down. Uses pistol rounds."
	receiver = /obj/item/firearm_component/receiver/ballistic/submachine_gun/cheap
