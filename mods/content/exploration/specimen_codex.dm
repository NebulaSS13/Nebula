// Lists of strings used by the specimen tracking system to add flavour to
// specimens. Static lists in procs to allow overriding while also not putting
// a massive string list on every single cataloguer fauna entry.
/datum/codex_entry/proc/get_fauna_physical_notes()
	var/static/list/fauna_physical_notes = list(
		"Perpetually smells like mold no matter what we do about it.",
		"Perpetually smells like mildew no matter what we do about it.",
		"Perpetually smells like sifsap no matter what we do about it.",
		"Seems to always have an itch in the spot it can't reach.",
		"Vocalizations are notably harsh and loud for the species.",
		"Vocalizations are notably soft and quiet for the species.",
		"Has a notch in its left ear.",
		"Has a notch in its right ear.",
		"Is missing its left ear.",
		"Is missing its right ear.",
		"Is missing its left eye.",
		"Is missing its right eye.",
		"Has had the very tip of its tail chewed off.",
		"Might have trouble with its hearing.",
		"Is more scar tissue than animal at this point.",
		"Walks with a limp.",
		"Has two differently colored eyes.",
		"Might have a cold...",
		"Is allergic to nuts.",
		"Is allergic to berries.",
		"Is allergic to dairy."
	)
	return fauna_physical_notes

/datum/codex_entry/proc/get_fauna_behavior_notes()
	var/static/list/fauna_behavior_notes = list(
		"Likes rolling around in the moss with reckless abandon.",
		"Enjoys munching on frostbelles the most, as a treat.",
		"Enjoys munching on wabback the most, as a treat.",
		"Enjoys munching on eyebulbs the most, as a treat.",
		"Constantly sniffs around at everything new.",
		"Seems super friendly! Probably won't bite. Probably.",
		"Seems rather stand-offish. Mind the personal bubble.",
		"Loves a good back scritch.",
		"Loves a good head scritch.",
		"Loves a good behind the ear scritch.",
		"Seems to hate the world and everything in it.",
		"Just tolerates being pet, but certainly doesn't enjoy it.",
		"Often sticks its head into snowbanks to contemplate the state of things.",
		"Enjoys singing along to songs only it can hear. Mostly just sounds like an animal wailing.",
		"Would rather be fishing.",
		"Partakes in many siestas.",
		"Struggles with object permanence.",
		"Is very picky about food; maybe it's a texture thing.",
		"Is a sentient garbage disposal for anything even remotely edible.",
		"Loves swimming and splashing around in water.",
		"Sinks like a rock the moment it enters water.",
		"Gets lost easily.",
		"Enjoys soft things. It'd have a bed of plushies if it knew what a bed was.",
		"Never seems to be in a rush to go anywhere...",
		"Has gotta go fast at all times."
	)
	return fauna_behavior_notes
