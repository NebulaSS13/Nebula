//For random spawners and mapping, spawns a find item and qdels self
/obj/item/archaeological_find
	name = "archeological find spawner"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "unknown2"
	var/list/possible_finds = list(/decl/archaeological_find)

/obj/item/archaeological_find/Initialize()
	..()
	var/decl/archaeological_find/F = GET_DECL(pick(possible_finds))
	F.create_find(loc)
	return INITIALIZE_HINT_QDEL

/obj/item/archaeological_find/lab
	possible_finds = list(
		/decl/archaeological_find/statuette,
		/decl/archaeological_find/instrument,
		/decl/archaeological_find/mask,
		/decl/archaeological_find
	)

/obj/item/archaeological_find/house
	possible_finds = list(
		/decl/archaeological_find/bowl,
		/decl/archaeological_find/remains,
		/decl/archaeological_find/bowl/urn,
		/decl/archaeological_find/cutlery,
		/decl/archaeological_find/statuette,
		/decl/archaeological_find/instrument,
		/decl/archaeological_find/container,
		/decl/archaeological_find/mask,
		/decl/archaeological_find/coin,
		/decl/archaeological_find
	)

/obj/item/archaeological_find/construction
	possible_finds = list(
		/decl/archaeological_find/material,
		/decl/archaeological_find/material/exotic,
		/decl/archaeological_find/parts
	)

/obj/item/archaeological_find/blade
	possible_finds = list(
		/decl/archaeological_find/knife,
		/decl/archaeological_find/sword
	)

/obj/item/archaeological_find/gun
	possible_finds = list(
		/decl/archaeological_find/gun,
		/decl/archaeological_find/laser
	)
