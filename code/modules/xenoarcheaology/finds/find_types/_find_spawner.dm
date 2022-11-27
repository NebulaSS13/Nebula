//For random spawners and mapping, spawns a find item and qdels self
/obj/random/archaeological_find
	name = "archeological find spawner"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "unknown2"
	is_spawnable_type = FALSE // Does not cooperate with the random object unit test currently.

/obj/random/archaeological_find/create_instance(var/build_path, var/spawn_loc)
	var/decl/archaeological_find/F = GET_DECL(build_path)
	return F.create_find(spawn_loc)

/obj/random/archaeological_find/spawn_choices()
	var/static/list/spawnable_choices = list(/decl/archaeological_find)
	return spawnable_choices

/obj/random/archaeological_find/lab/spawn_choices()
	var/static/list/spawnable_choices = list(
		/decl/archaeological_find/statuette,
		/decl/archaeological_find/instrument,
		/decl/archaeological_find/mask,
		/decl/archaeological_find
	)
	return spawnable_choices

/obj/random/archaeological_find/house/spawn_choices()
	var/static/list/spawnable_choices = list(
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
	return spawnable_choices

/obj/random/archaeological_find/construction/spawn_choices()
	var/static/list/spawnable_choices = list(
		/decl/archaeological_find/material,
		/decl/archaeological_find/material/exotic,
		/decl/archaeological_find/parts
	)
	return spawnable_choices

/obj/random/archaeological_find/blade/spawn_choices()
	var/static/list/spawnable_choices = list(
		/decl/archaeological_find/knife,
		/decl/archaeological_find/sword
	)
	return spawnable_choices

/obj/random/archaeological_find/gun/spawn_choices()
	var/static/list/spawnable_choices = list(
		/decl/archaeological_find/gun,
		/decl/archaeological_find/laser
	)
	return spawnable_choices
