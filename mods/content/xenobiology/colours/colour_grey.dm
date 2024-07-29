/decl/slime_colour/grey
	name = "grey"
	descendants = list(
		/decl/slime_colour/orange,
		/decl/slime_colour/metal,
		/decl/slime_colour/blue,
		/decl/slime_colour/purple
	)
	reaction_strings = list(
		/decl/material/liquid/blood =        "Synthesises some monkey cubes.",
		/decl/material/solid/metal/uranium = "Revives a baby slime from a core."
	)

/decl/slime_colour/grey/handle_blood_reaction(var/datum/reagents/holder)
	var/location = get_turf(holder.get_reaction_loc())
	if(location)
		for(var/i = 1, i <= 3, i++)
			new /obj/item/food/monkeycube(location)
	return TRUE

/decl/slime_colour/grey/handle_uranium_reaction(var/datum/reagents/holder)
	var/turf/location = get_turf(holder.get_reaction_loc())
	if(istype(location))
		location.visible_message(SPAN_WARNING("The core begins to quiver and grow, and soon a new baby slime emerges from it!"))
		new /mob/living/slime(location)
	return TRUE
