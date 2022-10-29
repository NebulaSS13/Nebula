/decl/special_role/deathsquad/mercenary
	landmark_id = "Syndicate-Commando"
	name = "Syndicate Commando"
	name_plural = "Commandos"
	welcome_text = "You are in the employ of a criminal syndicate hostile to corporate interests."
	flags = ANTAG_RANDOM_EXCEPTED
	hard_cap = 4
	hard_cap_round = 8
	initial_spawn_req = 4
	initial_spawn_target = 6
	default_outfit = /decl/hierarchy/outfit/mercenary_commando
	default_access = list(access_mercenary)
	rig_type = /obj/item/rig/merc
	id_title = "Commando"

/decl/hierarchy/outfit/mercenary_commando
	name =    "Special Role - Mercenary Commando"
	l_ear =   /obj/item/radio/headset/syndicate
	id_type = /obj/item/card/id/centcom/ERT
	uniform = /obj/item/clothing/under/syndicate
	shoes =   /obj/item/clothing/shoes/jackboots/swat
	glasses = /obj/item/clothing/glasses/thermal
	mask =    /obj/item/clothing/mask/gas/syndicate
	backpack_contents = list(/obj/item/ammo_magazine/box/pistol = 1)
	hands = list(
		/obj/item/gun/energy/laser,
		/obj/item/energy_blade/sword
	)
