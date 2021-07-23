/datum/random_map/winding_dungeon/premade
	name = "winding dungeon (PREMADE)"
	room_theme_common = list(/datum/room_theme = 1)
	room_theme_uncommon = list(/datum/room_theme = 3, /datum/room_theme/metal = 1)
	room_theme_rare = list(/datum/room_theme/metal = 1, /datum/room_theme = 3, /datum/room_theme/metal/secure = 1)

	monsters_common = list(/mob/living/simple_animal/hostile/carp = 50, /mob/living/simple_animal/hostile/carp/pike = 1)
	monsters_uncommon = list(/mob/living/simple_animal/hostile/hivebot = 10, /mob/living/simple_animal/hostile/hivebot/strong = 1)

/datum/random_map/winding_dungeon/premade/New()
	loot_common = subtypesof(/obj/item/energy_blade/sword) + subtypesof(/obj/item/baton) + subtypesof(/obj/item/chems/food) + subtypesof(/obj/item/chems/condiment) + subtypesof(/obj/item/chems/drinks)
	loot_uncommon += subtypesof(/obj/item/gun/projectile) + subtypesof(/obj/item/ammo_magazine)
	monsters_rare += typesof(/mob/living/simple_animal/hostile/syndicate) + typesof(/mob/living/simple_animal/hostile/pirate)
	..()