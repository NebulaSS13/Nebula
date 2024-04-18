/mob/proc/spawn_gibber(atom/location = loc)
	var/gibber_type = get_gibber_type()
	if(!gibber_type)
		return
	if(ispath(gibber_type, /obj/effect/gibspawner))
		return new gibber_type(location, get_blood_type(), get_unique_enzymes(), get_flesh_color(), get_blood_color())
	. = new gibber_type(location)
	if(!istype(., /obj/effect/decal/cleanable/blood/gibs))
		return
	var/obj/effect/decal/cleanable/blood/gibs/gib = .
	gib.fleshcolor = get_flesh_color()
	gib.basecolor  = get_blood_color()
	var/gib_unique_enzymes = get_unique_enzymes()
	var/gib_blood_type = get_blood_type()
	if(gib_unique_enzymes && gib_blood_type)
		LAZYSET(gib.blood_DNA, gib_unique_enzymes, gib_blood_type)
	gib.update_icon()

/obj/effect/gibspawner
	var/sparks = 0 //whether sparks spread on spawn_gibs()
	var/list/gibtypes = list()
	var/list/gibamounts = list()
	var/list/gibdirections = list() //of lists
	var/fleshcolor //Used for gibbed humans.
	var/bloodcolor //Used for gibbed humans.
	var/blood_type
	var/unique_enzymes

/obj/effect/gibspawner/Initialize(mapload, var/_blood_type, var/_unique_enzymes, var/_fleshcolor, var/_bloodcolor)
	..(mapload)
	if(_fleshcolor)
		fleshcolor = _fleshcolor
	if(_bloodcolor)
		bloodcolor = _bloodcolor
	if(_blood_type)
		blood_type = _blood_type
	if(_unique_enzymes)
		unique_enzymes = _unique_enzymes
	spawn_gibs(loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/gibspawner/proc/spawn_gibs(atom/location)
	if(gibtypes.len != gibamounts.len || gibamounts.len != gibdirections.len)
		CRASH("Gib list length mismatch!")

	if(sparks)
		spark_at(location, amount = 2, cardinal_only = TRUE)

	var/obj/effect/decal/cleanable/blood/gibs/gib = null
	for(var/i = 1, i<= gibtypes.len, i++)
		if(gibamounts[i])
			for(var/j = 1, j<= gibamounts[i], j++)
				var/gibType = gibtypes[i]
				gib = new gibType(location)

				// Apply human species colouration to masks.
				if(fleshcolor)
					gib.fleshcolor = fleshcolor
				if(bloodcolor)
					gib.basecolor = bloodcolor

				gib.update_icon()

				if(unique_enzymes && blood_type)
					LAZYSET(gib.blood_DNA, unique_enzymes, blood_type)
				else if(istype(src, /obj/effect/gibspawner/human)) // Probably a monkey
					LAZYSET(gib.blood_DNA, "Non-human DNA", "A+")
				if(istype(location,/turf/))
					var/list/directions = gibdirections[i]
					if(directions.len)
						gib.streak(directions)
