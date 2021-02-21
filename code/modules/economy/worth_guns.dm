// Can't think of a good way to get gun price from projectile (due to 
// firemodes, projectile types, etc) so this'll have to  do for now.
/obj/item/gun/get_base_value()
	. = 100

/obj/item/gun/energy/get_base_value()
	. = 150

/obj/item/gun/get_base_value()
	. = 0
	if(silenced)
		. += 20
	. += one_hand_penalty * -2
	. += bulk * -5
	. += accuracy * 10
	. += scoped_accuracy * 5
	if(!autofire_enabled)
		for(var/datum/firemode/F in firemodes)
			if(F.settings["autofire_enabled"])
				. += 100
	. *= 10
	. += ..()

/obj/item/gun/energy/get_base_value()
	. = ..()
	if(self_recharge)
		. += 100
	var/projectile_value = 1
	if(projectile_type)
		projectile_value = atom_info_repository.get_combined_worth_for(projectile_type)
	for(var/datum/firemode/F in firemodes)
		if(F.settings["projectile_type"])
			projectile_value = max(projectile_value, atom_info_repository.get_combined_worth_for(F.settings["projectile_type"]))
	. += max_shots * projectile_value

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
