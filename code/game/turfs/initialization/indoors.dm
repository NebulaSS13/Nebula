/// Spawns random 'kitchen' grime near tables: flour spills, smashed eggs, fruit smudges, etc.
/decl/turf_initializer/kitchen
	/// The probability of attempting to place clutter for a turf.
	var/clutter_probability = 10
	/// Clutter types to pick from when placing clutter on a turf.
	var/list/clutter = list(
		/obj/effect/decal/cleanable/flour,
		/obj/effect/decal/cleanable/tomato_smudge,
		/obj/effect/decal/cleanable/egg_smudge
	)

/decl/turf_initializer/kitchen/InitializeTurf(var/turf/tile)
	if(!istype(tile) || tile.density || !tile.simulated)
		return
	if(!prob(clutter_probability))
		return
	var/adjacent_tables = 0
	for(var/obj/structure/table/table in orange(tile, 1))
		adjacent_tables++
		break
	if(!adjacent_tables)
		return
	if(!prob(adjacent_tables * 25)) // far more likely in table corners with 3 or more tables adjacent
		return
	var/obj/clutter_to_spawn = pick(clutter)
	if(!clutter_to_spawn)
		return
	new clutter_to_spawn(tile)