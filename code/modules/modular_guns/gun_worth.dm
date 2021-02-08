
/obj/item/gun/projectile/get_base_value()
	. = ..()
	if(load_method & (SINGLE_CASING|SPEEDLOADER))
		var/projectile_value = ammo_type ? atom_info_repository.get_combined_worth_for(ammo_type) : 1
		. += 0.5 * projectile_value * max_shells
	else if(load_method & MAGAZINE)
		if(auto_eject)
			. += 20
		var/obj/item/ammo_magazine/mag = magazine_type
		var/mag_type = initial(mag.ammo_type)
		var/projectile_value = mag_type ? atom_info_repository.get_combined_worth_for(mag_type) : 1
		. += 0.5 * projectile_value * initial(mag.max_ammo)
