//For random spawners and mapping, spawns a find item and qdels self
/obj/random/archaeological_find
	name = "archeological find spawner"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "unknown2"

/obj/random/archaeological_find/spawn_item()
	var/decl/archaeological_find/F = GET_DECL(pickweight(spawn_choices()))
	var/atom/A = F.create_find(loc)
	if(pixel_x || pixel_y)
		A.pixel_x = pixel_x
		A.pixel_y = pixel_y
	return A

/obj/random/archaeological_find/spawn_choices()
	return list(/decl/archaeological_find)

/obj/random/archaeological_find/lab/spawn_choices()
	return list(
		/decl/archaeological_find/statuette,
		/decl/archaeological_find/instrument,
		/decl/archaeological_find/mask,
		/decl/archaeological_find
	)

/obj/random/archaeological_find/house/spawn_choices()
	return list(
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

/obj/random/archaeological_find/construction/spawn_choices()
	return list(
		/decl/archaeological_find/material,
		/decl/archaeological_find/material/exotic,
		/decl/archaeological_find/parts
	)

/obj/random/archaeological_find/blade/spawn_choices()
	return list(
		/decl/archaeological_find/knife,
		/decl/archaeological_find/sword
	)

/obj/random/archaeological_find/gun/spawn_choices()
	return list(
		/decl/archaeological_find/gun,
		/decl/archaeological_find/laser
	)
