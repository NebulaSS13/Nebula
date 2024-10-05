/// Runs multiple turf initialisers in sequence.
/decl/turf_initializer/combo
	abstract_type = /decl/turf_initializer/combo
	/// A list of initialisers to run, in sequence.
	var/list/initialisers

/decl/turf_initializer/combo/Initialize()
	. = ..()
	var/list/new_initialisers = list()
	for(var/initialiser in initialisers)
		new_initialisers += GET_DECL(initialiser)
	initialisers = new_initialisers
	ASSERT(length(initialisers))

/decl/turf_initializer/combo/InitializeTurf(var/turf/tile)
	if(!istype(tile) || !tile.simulated)
		return
	for(var/decl/turf_initializer/initialiser in initialisers)
		initialiser.InitializeTurf(tile)