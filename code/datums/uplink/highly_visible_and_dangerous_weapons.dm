/***************************************
* Highly Visible and Dangerous Weapons *
***************************************/
/datum/uplink_item/item/visible_weapons
	category = /datum/uplink_category/visible_weapons

/datum/uplink_item/item/visible_weapons/zipgun
	name = "Zip Gun"
	desc = "A pipe attached to crude wooden stock with firing mechanism, holds one round."
	item_cost = 8
	path = /obj/item/gun/projectile/zipgun

/datum/uplink_item/item/visible_weapons/smallenergy_gun
	name = "Small Energy Gun"
	desc = "A pocket-sized energy based sidearm with three different lethality settings."
	item_cost = 16
	path = /obj/item/gun/energy/gun/small

/datum/uplink_item/item/visible_weapons/dartgun
	name = "Dart Gun"
	desc = "A gas-powered dart gun capable of delivering chemical payloads across short distances. \
			Uses a unique cartridge loaded with hollow darts."
	item_cost = 20
	path = /obj/item/gun/projectile/dartgun

/datum/uplink_item/item/visible_weapons/crossbow
	name = "Energy Crossbow"
	desc = "A self-recharging, almost silent weapon employed by stealth operatives."
	item_cost = 24
	path = /obj/item/gun/energy/crossbow

/datum/uplink_item/item/visible_weapons/energy_sword
	name = "Energy Sword"
	desc = "A hilt, that when activated, creates a solid beam of pure energy in the form of a sword. \
			Able to slice through people like butter!"
	item_cost = 32
	path = /obj/item/energy_blade/sword

/datum/uplink_item/item/visible_weapons/silenced
	name = "Small Silenced Pistol"
	desc = "A kit with a pocket-sized holdout pistol, silencer, and an extra magazine. \
			Attaching the silencer will make it too big to conceal in your pocket."
	item_cost = 32
	path = /obj/item/storage/box/syndie_kit/silenced

/datum/uplink_item/item/badassery/money_cannon
	name = "Modified Money Cannon"
	item_cost = 48
	path = /obj/item/gun/launcher/money/hacked
	desc = "Too much money? Not enough screaming? Try the Money Cannon."

/datum/uplink_item/item/visible_weapons/energy_gun
	name = "Energy Gun"
	desc = "A energy based sidearm with three different lethality settings."
	item_cost = 32
	path = /obj/item/gun/energy/gun

/datum/uplink_item/item/visible_weapons/revolver
	name = "Magnum Revolver"
	desc = "A high-caliber revolver. Includes an extra speedloader of ammo."
	item_cost = 56
	path = /obj/item/storage/backpack/satchel/syndie_kit/revolver

/datum/uplink_item/item/visible_weapons/grenade_launcher
	name = "Grenade Launcher"
	desc = "A pump action grenade launcher loaded with a random assortment of grenades"
	item_cost = 60
	antag_roles = list(/decl/special_role/mercenary)
	path = /obj/item/gun/launcher/grenade/loaded

//These are for traitors (or other antags, perhaps) to have the option of purchasing some merc gear.
/datum/uplink_item/item/visible_weapons/smg
	name = "Standard Submachine Gun"
	desc = "A quick-firing weapon with three togglable fire modes."
	item_cost = 52
	path = /obj/item/gun/projectile/automatic/smg
	antag_roles = list(/decl/special_role/mercenary)

/datum/uplink_item/item/visible_weapons/assaultrifle
	name = "Assault Rifle"
	desc = "A common rifle with three togglable fire modes."
	item_cost = 60
	path = /obj/item/gun/projectile/automatic/assault_rifle
	antag_roles = list(/decl/special_role/mercenary)

/datum/uplink_item/item/visible_weapons/advanced_energy_gun
	name = "Advanced Energy Gun"
	desc = "A highly experimental heavy energy weapon, with three different lethality settings."
	item_cost = 60
	path = /obj/item/gun/energy/gun/nuclear

/datum/uplink_item/item/visible_weapons/heavysniper
	name = "Anti-materiel Sniper Rifle"
	desc = "A secure briefcase that contains an immensely powerful penetrating rifle, as well as seven extra sniper rounds."
	item_cost = 68
	path = /obj/item/storage/secure/briefcase/heavysniper
	antag_roles = list(/decl/special_role/mercenary)

/datum/uplink_item/item/visible_weapons/combat_shotgun
	name = "Pump Shotgun"
	desc = "A high compacity, pump-action shotgun regularly used for repelling boarding parties in close range scenarios."
	item_cost = 52
	path = /obj/item/gun/projectile/shotgun/pump
	antag_roles = list(/decl/special_role/mercenary)

/datum/uplink_item/item/visible_weapons/sawnoff
	name = "Sawnoff Shotgun"
	desc = "A shortened double-barrel shotgun, able to fire either one, or both, barrels at once."
	item_cost = 45
	path = /obj/item/gun/projectile/shotgun/doublebarrel/sawn

/datum/uplink_item/item/visible_weapons/flechetterifle
	name = "Flechette Rifle"
	desc = "A railgun with two togglable fire modes, able to launch flechette ammunition at incredible speeds."
	item_cost = 60
	path = /obj/item/gun/magnetic/railgun/flechette
	antag_roles = list(/decl/special_role/mercenary)

/datum/uplink_item/item/visible_weapons/railgun // Like a semi-auto AMR
	name = "Railgun"
	desc = "An anti-armour magnetic launching system fed by a high-capacity matter cartridge, \
			capable of firing slugs at intense speeds."
	item_cost = DEFAULT_TELECRYSTAL_AMOUNT - (DEFAULT_TELECRYSTAL_AMOUNT - (DEFAULT_TELECRYSTAL_AMOUNT % 6)) / 6
	antag_roles = list(/decl/special_role/mercenary)
	path = /obj/item/gun/magnetic/railgun

/datum/uplink_item/item/visible_weapons/harpoonbomb
	name = "Explosive Harpoon"
	item_cost = 12
	path = /obj/item/harpoon/bomb

/datum/uplink_item/item/visible_weapons/incendiary_laser
	name = "Incendiary Laser Blaster"
	desc = "A laser weapon developed at great expense and subsequently banned, it sets its targets on fire with dispersed laser technology. \
			Most of these blasters were swiftly bought back and destroyed - but not this one."
	item_cost = 40
	path = /obj/item/gun/energy/incendiary_laser
