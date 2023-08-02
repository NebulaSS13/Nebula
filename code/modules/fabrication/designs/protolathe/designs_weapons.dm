/datum/fabricator_recipe/protolathe/weapon
	category = "Weapons"
	build_time = 30 SECONDS
	fabricator_types = list(FABRICATOR_CLASS_PROTOLATHE)

/datum/fabricator_recipe/protolathe/weapon/get_product_name()
	. = "weapon ([..()])"

//projectile

/datum/fabricator_recipe/protolathe/weapon/doublebarrel
	path = /obj/item/gun/projectile/shotgun/doublebarrel/empty

/datum/fabricator_recipe/protolathe/weapon/shotgun
	path = /obj/item/gun/projectile/shotgun/pump/empty

/datum/fabricator_recipe/protolathe/weapon/revolver
	path = /obj/item/gun/projectile/revolver/empty

/datum/fabricator_recipe/protolathe/weapon/lasvolver
	path = /obj/item/gun/projectile/revolver/lasvolver/empty

/datum/fabricator_recipe/protolathe/weapon/pistol_holdout
	path = /obj/item/gun/projectile/pistol/holdout/empty

/datum/fabricator_recipe/protolathe/weapon/pistol
	path = /obj/item/gun/projectile/pistol/empty

/datum/fabricator_recipe/protolathe/weapon/smg
	path = /obj/item/gun/projectile/automatic/smg/empty

/datum/fabricator_recipe/protolathe/weapon/bullpup
	path = /obj/item/gun/projectile/automatic/assault_rifle/empty

//energy

/datum/fabricator_recipe/protolathe/weapon/taser
	path = /obj/item/gun/energy/taser

/datum/fabricator_recipe/protolathe/weapon/confuseray
	path = /obj/item/gun/energy/taser/light

/datum/fabricator_recipe/protolathe/weapon/capacitor
	path = /obj/item/gun/energy/capacitor

/datum/fabricator_recipe/protolathe/weapon/capacitor_rifle
	path = /obj/item/gun/energy/capacitor/rifle

/datum/fabricator_recipe/protolathe/weapon/lasercarbine
	path = /obj/item/gun/energy/laser

/datum/fabricator_recipe/protolathe/weapon/lasercannon
	path = /obj/item/gun/energy/lasercannon

/datum/fabricator_recipe/protolathe/weapon/egun
	path = /obj/item/gun/energy/gun

/datum/fabricator_recipe/protolathe/weapon/small_egun
	path = /obj/item/gun/energy/gun/small

/datum/fabricator_recipe/protolathe/weapon/nuclear_gun
	path = /obj/item/gun/energy/gun/nuclear

/datum/fabricator_recipe/protolathe/weapon/xrayrifle
	path = /obj/item/gun/energy/xray

///datum/fabricator_recipe/protolathe/weapon/lasersniper
//	path = /obj/item/gun/energy/sniperrifle

/datum/fabricator_recipe/protolathe/weapon/ionrifle
	path = /obj/item/gun/energy/ionrifle

/datum/fabricator_recipe/protolathe/weapon/plasmacutter
	path = /obj/item/gun/energy/plasmacutter

//special

/datum/fabricator_recipe/protolathe/weapon/syringe
	path = /obj/item/gun/launcher/syringe

/datum/fabricator_recipe/protolathe/weapon/rapidsyringe
	path = /obj/item/gun/launcher/syringe/rapid

/datum/fabricator_recipe/protolathe/weapon/dartgun
	path = /obj/item/gun/projectile/dartgun

/datum/fabricator_recipe/protolathe/weapon/chemsprayer
	path = /obj/item/chems/spray/chemsprayer

/datum/fabricator_recipe/protolathe/weapon/flora_gun
	path = /obj/item/gun/energy/floragun

/datum/fabricator_recipe/protolathe/weapon/advancedflash
	path = /obj/item/flash/advanced

/datum/fabricator_recipe/protolathe/weapon/flechette
	path = /obj/item/gun/magnetic/railgun/flechette

//grenades

/datum/fabricator_recipe/protolathe/weapon/grenadelauncher
	path = /obj/item/gun/launcher/grenade

/datum/fabricator_recipe/protolathe/weapon/large_grenade
	path = /obj/item/grenade/chem_grenade/large

/datum/fabricator_recipe/protolathe/weapon/anti_photon
	path = /obj/item/grenade/anti_photon