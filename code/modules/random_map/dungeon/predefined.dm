/datum/random_map/winding_dungeon/premade
	name = "winding dungeon (PREMADE)"
	room_theme_common = list(/datum/room_theme = 1)
	room_theme_uncommon = list(/datum/room_theme = 3, /datum/room_theme/metal = 1)
	room_theme_rare = list(/datum/room_theme/metal = 1, /datum/room_theme = 3, /datum/room_theme/metal/secure = 1)

	monsters_common = list(/mob/living/critter/hostile/carp = 50, /mob/living/critter/hostile/carp/pike = 1)
	monsters_uncommon = list(/mob/living/critter/hostile/hivebot = 10, /mob/living/critter/hostile/hivebot/strong = 1)

/datum/random_map/winding_dungeon/premade/New()
	loot_common = subtypesof(/obj/item/energy_blade/sword) + subtypesof(/obj/item/baton) + subtypesof(/obj/item/chems/food)
	loot_uncommon += subtypesof(/obj/item/gun/projectile) + subtypesof(/obj/item/ammo_magazine)
	monsters_rare += typesof(/mob/living/critter/hostile/syndicate) + typesof(/mob/living/critter/hostile/pirate)
	..()