///Contains generated xenorach flavor text for engravings. Was moved out of exoplanet gen.
/datum/xenoarch_engraving_flavor
	//#TODO: This stuff could definitely be datumized into some /decl?

	///Possible actor being acted upon.
	var/list/possible_actors_singular = list(
		"alien humanoid",
		"an amorphic blob",
		"a short, hairy being",
		"a rodent-like creature",
		"a robot",
		"a primate",
		"a reptilian alien",
		"an unidentifiable object",
		"a statue",
		"a starship",
		"unusual devices",
		"a structure"
	)
	///Possible actors acting upon the other actor
	var/list/possible_actors_plural = list(
		"alien humanoids",
		"amorphic blobs",
		"short, hairy beings",
		"rodent-like creatures",
		"robots","primates",
		"reptilian aliens"
	)
	///Possible verbs the plural actors are performing on the singular actor
	var/list/possible_activities = list(
		"surrounded by",
		"being held aloft by",
		"being struck by",
		"being examined by",
		"communicating with"
	)
	///Possible observations made by the narrator
	var/list/possible_observations = list(
		"they seem to be enjoying themselves",
		"they seem extremely angry",
		"they look pensive",
		"they are making gestures of supplication",
		"the scene is one of subtle horror",
		"the scene conveys a sense of desperation",
		"the scene is completely bizarre"
	)

	///Possible activities an actor can do during a violent vision.
	var/list/possible_vision_activities = list(
		"killing",
		"dying",
		"gored",
		"expiring",
		"exploding",
		"mauled",
		"burning",
		"flayed",
		"in agony",
	)

	///Actors this instance will use when generating engravings flavor text.
	var/list/picked_actors

///Decides the possible singular and plural actors that this instance of engraving generator may use.
/datum/xenoarch_engraving_flavor/proc/setup_actors()
	picked_actors = list(pick(possible_actors_singular), pick(possible_actors_plural))

///attempt at more consistent history generation for xenoarch finds.
/datum/xenoarch_engraving_flavor/proc/generate_engraving_text()
	if(!LAZYLEN(picked_actors))
		setup_actors()
	var/engravings = "[picked_actors[1]] \
	[pick(possible_activities)] \
	[picked_actors[2]]"
	if(prob(50))
		engravings += ", [pick(possible_observations)]"
	engravings += "."
	return engravings

///Generate the text for a violent vision event when touching a monolith.
/datum/xenoarch_engraving_flavor/proc/generate_violent_vision_text()
	if(!LAZYLEN(picked_actors))
		setup_actors()
	. = ""
	for(var/i = 1 to 10)
		. += "[pick(picked_actors)] [pick(possible_vision_activities)] . "
