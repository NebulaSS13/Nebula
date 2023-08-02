/obj/item/gun/projectile/zipgun
	name = "zip gun"
	desc = "Little more than a barrel, handle, and firing mechanism, cheap makeshift firearms like this one are not uncommon in frontier systems. Uses shotgun ammo."
	icon = 'icons/obj/guns/zipgun.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_NORMAL
	has_safety = FALSE
	load_method = SINGLE_CASING
	handle_casings = CYCLE_CASINGS //player has to take the old casing out manually before reloading
	caliber = CALIBER_SHOTGUN
	max_shells = 1 //literally just a barrel
