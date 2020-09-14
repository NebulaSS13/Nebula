/decl/special_role/deathsquad/mercenary
	landmark_id = "Syndicate-Commando"
	name = "Syndicate Commando"
	name_plural = "Commandos"
	welcome_text = "You are in the employ of a criminal syndicate hostile to corporate interests."
	id_type = /obj/item/card/id/centcom/ERT
	flags = ANTAG_RANDOM_EXCEPTED

	hard_cap = 4
	hard_cap_round = 8
	initial_spawn_req = 4
	initial_spawn_target = 6
	default_outfit = /decl/hierarchy/outfit/mercenary_commando
	rig_type = /obj/item/rig/merc
	id_title = "Commando"

/decl/special_role/deathsquad/mercenary/equip(var/mob/living/carbon/human/player)
	. = ..()
	if(.)
		create_radio(/obj/item/radio/headset/syndicate, player)

/decl/hierarchy/outfit/mercenary_commando
	name =    "Special Role - Mercenary Commando"
	uniform = /obj/item/clothing/under/syndicate
	shoes =   /obj/item/clothing/shoes/jackboots/swat
	glasses = /obj/item/clothing/glasses/thermal
	mask =    /obj/item/clothing/mask/gas/syndicate
	backpack_contents = list(/obj/item/ammo_magazine/box/pistol = 1)
	hands = list(
		/obj/item/gun/energy/laser,
		/obj/item/energy_blade/sword
	)

/obj/item/encryptionkey/syndicate
	icon_state = "cypherkey"
	can_decrypt = list(access_syndicate)
	origin_tech = "{'esoteric':3}"

/obj/item/encryptionkey/syndicate/Initialize(ml, material_key)
	. = ..()
	can_decrypt |= get_all_station_access()

/obj/item/radio/headset/syndicate
	origin_tech = "{'esoteric':3}"
	encryption_keys = list(/obj/item/encryptionkey/syndicate)
