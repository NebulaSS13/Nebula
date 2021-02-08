
/obj/item/gun/projectile/zipgun
	name = "zip gun"
	desc = "Little more than a barrel, handle, and firing mechanism, cheap makeshift firearms like this one are not uncommon in frontier systems."
	icon = 'icons/obj/guns/zipgun.dmi'
	icon_state = ICON_STATE_WORLD
	barrel = /obj/item/firearm_component/barrel/ballistic/pistol
	receiver = /obj/item/firearm_component/receiver/ballistic/zipgun
	has_safety = FALSE
	w_class = ITEM_SIZE_NORMAL

	var/static/list/ammo_types = list(
		/obj/item/ammo_casing/pistol,
		/obj/item/ammo_casing/shotgun,
		/obj/item/ammo_casing/shotgun,
		/obj/item/ammo_casing/shotgun/pellet,
		/obj/item/ammo_casing/shotgun/pellet,
		/obj/item/ammo_casing/shotgun/pellet,
		/obj/item/ammo_casing/shotgun/beanbag ,
		/obj/item/ammo_casing/shotgun/stunshell,
		/obj/item/ammo_casing/shotgun/flash,
		/obj/item/ammo_casing/rifle,
		/obj/item/ammo_casing/rifle
		)

/obj/item/gun/projectile/zipgun/toggle_safety(var/mob/user)
	to_chat(user, "<span class='warning'>There's no safety on \the [src]!</span>")

/obj/item/gun/projectile/zipgun/Initialize()
	. = ..()
	var/obj/item/ammo_casing/ammo = pick(ammo_types)
	set_caliber(initial(ammo.caliber))
	desc += " Uses [get_load_caliber() || "unmarked"] rounds."
