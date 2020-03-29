/decl/language/diona
	name = "Nymph"
	desc = "A language known instinctively by diona nymphs."
	speech_verb = "creaks and rustles"
	ask_verb = "creaks"
	exclaim_verb = "rustles"
	colour = "soghun"
	key = "q"
	flags = RESTRICTED
	syllables = list("hs","zt","kr","st","sh")
	shorthand = "RT"
	machine_understands = FALSE
	hidden_from_codex = TRUE

/decl/language/diona/get_random_name()
	. = "[pick(list("To Sleep Beneath","Wind Over","Embrace of","Dreams of","Witnessing","To Walk Beneath","Approaching the"))] [pick(list("the Void","the Sky","Encroaching Night","Planetsong","Starsong","the Wandering Star","the Empty Day","Daybreak","Nightfall","the Rain"))]"
