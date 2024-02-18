/obj/effect/gibspawner
	var/sparks = 0 //whether sparks spread on Gib()
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
	Gib(loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/gibspawner/proc/Gib(atom/location)
	if(gibtypes.len != gibamounts.len || gibamounts.len != gibdirections.len)
		log_error("<span class='warning'>Gib list length mismatch!</span>")
		return

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
