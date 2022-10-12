// Used by rudimentary mob transform in Topic().
var/global/list/href_to_mob_type = list(
	"Observer" =     /mob/observer/ghost,
	"Crew" = list(
		"Human" =    /mob/living/carbon/human,
		"Monkey" =   /mob/living/carbon/human/monkey,
		"Robot" =    /mob/living/silicon/robot
	),
	"Animals" = list(
		"Cat" =      /mob/living/simple_animal/cat,
		"Runtime" =  /mob/living/simple_animal/cat/fluff/runtime,
		"Corgi" =    /mob/living/simple_animal/corgi,
		"Ian" =      /mob/living/simple_animal/corgi/Ian,
		"Crab" =     /mob/living/simple_animal/crab,
		"Coffee" =   /mob/living/simple_animal/crab/Coffee,
		"Parrot" =   /mob/living/simple_animal/hostile/retaliate/parrot,
		"Poly" =     /mob/living/simple_animal/hostile/retaliate/parrot/Poly,
	),
	"Constructs" = list(
		"Armoured" = /mob/living/simple_animal/construct/armoured,
		"Builder" =  /mob/living/simple_animal/construct/builder,
		"Wraith" =   /mob/living/simple_animal/construct/wraith,
		"Shade" =    /mob/living/simple_animal/shade
	)
)

/mob/proc/try_rudimentary_transform(var/transform_key, var/delmob, var/subspecies)

	// Work out the actual type we want to instantiate.
	var/create_mob_type = global.href_to_mob_type[transform_key]
	if(!create_mob_type) // It's category, do a search.
		for(var/mob_subcat in global.href_to_mob_type)
			var/list/mob_subcat_entries = global.href_to_mob_type[mob_subcat]
			if(!islist(mob_subcat_entries))
				continue
			create_mob_type = mob_subcat_entries[transform_key]
			if(create_mob_type)
				break
	if(!create_mob_type)
		return FALSE

	// Check if we succeeded in creating the mob and transferring the key before we try to qdel the old mob.
	var/mob/new_mob = change_mob_type(create_mob_type, location = (loc || usr?.loc), subspecies = subspecies)
	if(istype(new_mob) && new_mob.ckey)
		if(!ckey && delmob && !QDELETED(src))
			qdel(src)
		return TRUE

	return FALSE

//This proc is the most basic of the procs. All it does is make a new mob on the same tile and transfer over a few variables.
//Returns the new mob
//Note that this proc does NOT do MMI related stuff!
/mob/proc/change_mob_type(var/new_type, var/turf/location, var/new_name, var/subspecies)

	if(!new_type)
		new_type = input("Mob type path:", "Mob type") as text|null
		if(QDELETED(src) || QDELETED(usr))
			return FALSE

	if(!ispath(new_type, /mob))
		PRINT_STACK_TRACE("Invalid new_type supplied to change_mob_type.")
		return FALSE

	if(!location)
		location = loc
	location = get_turf(location)
	if(!isturf(location))
		PRINT_STACK_TRACE("Invalid location supplied to/inferred by change_mob_type.")
		return FALSE

	var/mob/M = new new_type(location)
	if(istext(new_name))
		M.SetName(new_name)
		M.real_name = new_name
	else
		M.SetName(name)
		M.real_name = real_name

	if(dna)
		M.dna = dna.Clone()

	if(mind)
		mind.transfer_to(M)
	if(!M.key) // ghost minds are inactive for reasons that escape me
		M.key = key

	if(subspecies && ishuman(M))
		var/mob/living/carbon/human/H = M
		H.change_species(subspecies)

	return M
