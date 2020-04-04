// Ballistic gun
/decl/archaeological_find/gun
	item_type = "gun"
	responsive_reagent = /datum/reagent/iron
	possible_types = list(/obj/item/gun/projectile/revolver)

/decl/archaeological_find/gun/spawn_item(atom/loc)
	var/obj/item/gun/projectile/revolver/new_gun = ..()

	//33% chance to be able to reload the gun with human ammunition
	if(prob(66))
		new_gun.caliber = "999"
	//33% chance to fill it with a random amount of bullets
	new_gun.max_shells = rand(1,12)
	new_gun.loaded.Cut()
	if(prob(33))
		var/num_bullets = rand(1, new_gun.max_shells)
		for(var/i = 1 to num_bullets)
			var/obj/item/ammo_casing/A = new new_gun.ammo_type(new_gun)
			new_gun.loaded += A
			if(A.caliber != new_gun.caliber)
				A.caliber = new_gun.caliber
				A.desc = "A bullet casing of unknown caliber."

	return new_gun

/decl/archaeological_find/gun/new_icon_state()
	return "gun[rand(1,4)]"

/decl/archaeological_find/gun/get_additional_description()
	return "This is an antique weapon, you're not sure if it will fire or not."

// Energy gun
/decl/archaeological_find/laser
	item_type = "gun"
	modification_flags = XENOFIND_APPLY_DECOR | XENOFIND_REPLACE_ICON
	responsive_reagent = /datum/reagent/iron
	possible_types = list(
		/obj/item/gun/energy/laser/practice,
		/obj/item/gun/energy/laser,
		/obj/item/gun/energy/xray,
		/obj/item/gun/energy/captain
	)

/decl/archaeological_find/laser/spawn_item(atom/loc)
	var/obj/item/gun/energy/new_gun = ..()
	new_gun.charge_meter = 0

	//10% chance to have an unchargeable cell
	//15% chance to gain a random amount of starting energy, otherwise start with an empty cell
	if(prob(10))
		new_gun.power_supply.maxcharge = 0
	if(prob(15))
		new_gun.power_supply.charge = rand(0, new_gun.power_supply.maxcharge)
	else
		new_gun.power_supply.charge = 0

	return new_gun

/decl/archaeological_find/laser/new_icon_state()
	return "egun[rand(1,6)]"

/decl/archaeological_find/laser/get_additional_description()
	return "This is an antique weapon, you're not sure if it will fire or not."