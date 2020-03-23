/datum/design/item/weapon/ModifyDesignName()
	name = "Weapon prototype ([name])"

/datum/design/item/weapon/AssembleDesignDesc()
	if(!desc)
		if(build_path)
			var/obj/item/I = build_path
			desc = initial(I.desc)
		..()

/datum/design/item/weapon/chemsprayer
	desc = "An advanced chem spraying device."
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_BIO = 2)
	build_path = /obj/item/chems/spray/chemsprayer

/datum/design/item/weapon/rapidsyringe
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_BIO = 2)
	build_path = /obj/item/gun/launcher/syringe/rapid

/datum/design/item/weapon/temp_gun
	desc = "A gun that shoots high-powered glass-encased energy temperature bullets."
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 4, TECH_POWER = 3, TECH_MAGNET = 2)
	build_path = /obj/item/gun/energy/temperature

/datum/design/item/weapon/large_grenade
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	build_path = /obj/item/grenade/chem_grenade/large

/datum/design/item/weapon/anti_photon
	req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 4)
	build_path = /obj/item/grenade/anti_photon

/datum/design/item/weapon/flora_gun
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_POWER = 3)
	build_path = /obj/item/gun/energy/floragun

/datum/design/item/weapon/advancedflash
	req_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 2)
	build_path = /obj/item/flash/advanced

/datum/design/item/weapon/stunrevolver
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	build_path = /obj/item/gun/energy/stunrevolver

/datum/design/item/weapon/stunrifle
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_POWER = 3)
	build_path = /obj/item/gun/energy/stunrevolver/rifle

/datum/design/item/weapon/confuseray
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 3)
	build_path = /obj/item/gun/energy/confuseray

/datum/design/item/weapon/nuclear_gun
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_POWER = 3)
	build_path = /obj/item/gun/energy/gun/nuclear

/datum/design/item/weapon/lasercannon
	desc = "The lasing medium of this prototype is enclosed in a tube lined with uranium-235 and subjected to high neutron flux in a nuclear reactor core."
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_POWER = 3)
	build_path = /obj/item/gun/energy/lasercannon

/datum/design/item/weapon/xraypistol
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_MAGNET = 2, TECH_ESOTERIC = 2)
	build_path = /obj/item/gun/energy/xray/pistol

/datum/design/item/weapon/xrayrifle
	req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3, TECH_MAGNET = 2, TECH_ESOTERIC = 2)
	build_path = /obj/item/gun/energy/xray

/datum/design/item/weapon/grenadelauncher
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	build_path = /obj/item/gun/launcher/grenade

/datum/design/item/weapon/flechette
	req_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 4, TECH_MAGNET = 4)
	build_path = /obj/item/gun/magnetic/railgun/flechette

/datum/design/item/weapon/phoronpistol
	req_tech = list(TECH_COMBAT = 5, TECH_PHORON = 4)
	build_path = /obj/item/gun/energy/toxgun

/datum/design/item/weapon/decloner
	req_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 7, TECH_BIO = 5, TECH_POWER = 6)
	build_path = /obj/item/gun/energy/decloner

/datum/design/item/weapon/wt550
	req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	build_path = /obj/item/gun/projectile/automatic/smg

/datum/design/item/weapon/bullpup
	req_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 3)
	build_path = /obj/item/gun/projectile/automatic/assault_rifle

/datum/design/item/weapon/ammunition/ModifyDesignName()
	name = "Ammunition prototype ([name])"

/datum/design/item/weapon/ammunition/ammo_small
	desc = "A box of small pistol rounds."
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3)
	build_path = /obj/item/ammo_magazine/box/smallpistol

/datum/design/item/weapon/ammunition/stunshell
	desc = "A stunning shell for a shotgun."
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	build_path = /obj/item/ammo_casing/shotgun/stunshell

/datum/design/item/weapon/ammunition/ammo_emp_small
	name = "haywire 7mm"
	desc = "A box of small pistol rounds with integrated EMP charges."
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	build_path = /obj/item/ammo_magazine/box/emp/smallpistol

/datum/design/item/weapon/ammunition/ammo_emp_pistol
	name = "haywire 10mm"
	desc = "A box of pistol rounds fitted with integrated EMP charges."
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	build_path = /obj/item/ammo_magazine/box/emp/pistol

/datum/design/item/weapon/ammunition/ammo_emp_slug
	desc = "A shotgun slug with an integrated EMP charge."
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3)
	build_path = /obj/item/ammo_casing/shotgun/emp
