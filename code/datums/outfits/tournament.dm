/decl/hierarchy/outfit/tournament_gear
	abstract_type = /decl/hierarchy/outfit/tournament_gear
	head = /obj/item/clothing/head/helmet/thunderdome
	suit = /obj/item/clothing/suit/armor/vest
	hands = list(
		/obj/item/knife/combat,
		/obj/item/gun/energy/laser
	)
	r_pocket = /obj/item/grenade/smokebomb
	shoes = /obj/item/clothing/shoes/color/black

/decl/hierarchy/outfit/tournament_gear/red
	name = "Tournament - Red"
	pants = /obj/item/clothing/jumpsuit/red

/decl/hierarchy/outfit/tournament_gear/green
	name = "Tournament gear - Green"
	pants = /obj/item/clothing/jumpsuit/green

/decl/hierarchy/outfit/tournament_gear/gangster
	name     = "Tournament gear - Gangster"
	head     = /obj/item/clothing/head/det
	pants    = /obj/item/clothing/pants/slacks
	uniform  = /obj/item/clothing/shirt/button/blue_clip_tie
	suit     = /obj/item/clothing/suit/det_trench
	glasses  = /obj/item/clothing/glasses/thermal/plain/monocle
	hands    = list(
		/obj/item/knife/combat,
		/obj/item/gun/projectile/revolver
	)
	l_pocket = /obj/item/ammo_magazine/speedloader

/decl/hierarchy/outfit/tournament_gear/chef
	name = "Tournament gear - Chef"
	head = /obj/item/clothing/head/chefhat
	pants = /obj/item/clothing/pants/slacks/white
	uniform = /obj/item/clothing/shirt/button
	suit = /obj/item/clothing/suit/chef
	hands = list(
		/obj/item/knife/combat,
		/obj/item/kitchen/rollingpin
	)
	l_pocket = /obj/item/knife/combat
	r_pocket = /obj/item/knife/combat

/decl/hierarchy/outfit/tournament_gear/janitor
	name = "Tournament gear - Janitor"
	pants = /obj/item/clothing/jumpsuit/janitor
	back = /obj/item/backpack
	hands = list(
		/obj/item/mop,
		/obj/item/chems/glass/bucket
	)
	l_pocket = /obj/item/grenade/chem_grenade/cleaner
	r_pocket = /obj/item/grenade/chem_grenade/cleaner
	backpack_contents = list(/obj/item/stack/tile/floor = 6)

/decl/hierarchy/outfit/tournament_gear/janitor/post_equip(var/mob/living/carbon/human/H)
	..()
	var/obj/item/chems/glass/bucket/bucket = locate(/obj/item/chems/glass/bucket) in H
	if(bucket)
		bucket.add_to_reagents(/decl/material/liquid/water, 70)
