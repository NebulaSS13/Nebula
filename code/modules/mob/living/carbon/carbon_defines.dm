/mob/living/carbon
	gender = MALE
	abstract_type = /mob/living/carbon

	// TODO REMOVE DIRECT REFERENCES
	var/obj/item/_handcuffed = null //Whether or not the mob is cuffed
	// END TODO

	//Surgery info
	//Active emote/pose
	var/pose = null
	var/datum/reagents/metabolism/bloodstr
	var/datum/reagents/metabolism/touching

	var/coughedtime = null
	var/ignore_rads = FALSE
	/// Whether the mob is performing cpr or not.
	var/performing_cpr = FALSE
	var/lastpuke = 0

	var/decl/species/species   // Contains environment tolerances and language information, set during New().
	var/decl/bodytype/bodytype // Contains icon generation info, set during set_species().
