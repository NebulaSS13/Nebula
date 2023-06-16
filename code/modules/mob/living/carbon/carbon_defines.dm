/mob/living/carbon
	gender = MALE
	abstract_type = /mob/living/carbon

	//Surgery info
	//Active emote/pose
	var/pose = null
	var/datum/reagents/metabolism/bloodstr
	var/datum/reagents/metabolism/touching
	var/losebreath = 0 //if we failed to breathe last tick

	var/coughedtime = null
	var/ignore_rads = FALSE
	/// Whether the mob is performing cpr or not.
	var/performing_cpr = FALSE
	var/lastpuke = 0
	var/lastcough = 0

	var/nutrition = 400
	var/hydration = 400

	var/obj/item/tank/internal = null//Human/Monkey
	var/decl/species/species   // Contains environment tolerances and language information, set during New().
	var/decl/bodytype/bodytype // Contains icon generation info, set during set_species().

	//these two help govern taste. The first is the last time a taste message was shown to the plaer.
	//the second is the message in question.
	var/last_taste_time = 0
	var/last_taste_text = ""

	// organ-related variables, see organ.dm and human_organs.dm
	//Shouldn't be accessed directly
	var/list/organs_by_tag
	var/tmp/list/internal_organs
	var/tmp/list/external_organs

	var/player_triggered_sleeping = 0
