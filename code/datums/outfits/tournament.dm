/decl/outfit/tournament_gear
	abstract_type = /decl/outfit/tournament_gear
	head = /obj/item/clothing/head/helmet/thunderdome
	suit = /obj/item/clothing/suit/armor/vest
	hands = list(
		/obj/item/knife/combat,
		/obj/item/gun/energy/laser
	)
	r_pocket = /obj/item/grenade/smokebomb
	shoes = /obj/item/clothing/shoes/color/black

/decl/outfit/tournament_gear/red
	name = "Tournament - Red"
	uniform = /obj/item/clothing/jumpsuit/red

/decl/outfit/tournament_gear/green
	name = "Tournament gear - Green"
	uniform = /obj/item/clothing/jumpsuit/green

/decl/outfit/tournament_gear/gangster
	name = "Tournament gear - Gangster"
	head = /obj/item/clothing/head/det
	uniform = /obj/item/clothing/pants/slacks/outfit/detective
	suit_store = /obj/item/clothing/suit/det_trench
	glasses = /obj/item/clothing/glasses/thermal/plain/monocle
	hands = list(
		/obj/item/knife/combat,
		/obj/item/gun/projectile/revolver
	)
	l_pocket = /obj/item/ammo_magazine/speedloader

/decl/outfit/tournament_gear/chef
	name = "Tournament gear - Chef"
	head = /obj/item/clothing/head/chefhat
	uniform = /obj/item/clothing/pants/slacks/outfit_chef
	suit = /obj/item/clothing/suit/chef
	hands = list(
		/obj/item/knife/combat,
		/obj/item/rollingpin
	)
	l_pocket = /obj/item/knife/combat
	r_pocket = /obj/item/knife/combat

/decl/outfit/tournament_gear/janitor
	name = "Tournament gear - Janitor"
	uniform = /obj/item/clothing/jumpsuit/janitor
	back = /obj/item/backpack
	hands = list(
		/obj/item/mop,
		/obj/item/chems/glass/bucket
	)
	l_pocket = /obj/item/grenade/chem_grenade/cleaner
	r_pocket = /obj/item/grenade/chem_grenade/cleaner
	backpack_contents = list(/obj/item/stack/tile/floor = 6)

/decl/outfit/tournament_gear/janitor/post_equip(var/mob/living/wearer)
	..()
	var/obj/item/chems/glass/bucket/bucket = locate(/obj/item/chems/glass/bucket) in wearer
	if(bucket)
		bucket.add_to_reagents(/decl/material/liquid/water, 70)
