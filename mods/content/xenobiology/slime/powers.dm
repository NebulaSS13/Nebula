/mob/living/slime/verb/slime_mature()
	set name = "Mature"
	set category = "Slime"
	set desc = "Mature from a baby to an adult."

	if(is_adult)
		to_chat(src, SPAN_WARNING("You are already an adult."))
		return

	if(incapacitated())
		to_chat(src, SPAN_WARNING("You are in no state to mature."))
		return

	if(amount_grown < SLIME_EVOLUTION_THRESHOLD)
		to_chat(src, SPAN_WARNING("You are not yet developed enough to mature."))
		return

	is_adult = TRUE
	maxHealth = 200
	amount_grown = 0
	update_name()
	update_icon()

/mob/living/slime/verb/slime_split()
	set name = "Fission"
	set category = "Slime"
	set desc = "Split into four baby slimes, keeping control of a single one."

	if(incapacitated())
		to_chat(src, SPAN_WARNING("You are in no state to fission."))
		return

	if(!is_adult || amount_grown < SLIME_EVOLUTION_THRESHOLD)
		to_chat(src, SPAN_WARNING("You are not yet developed enough to fission."))
		return

	var/decl/slime_colour/slime_data = GET_DECL(slime_type)
	var/list/babies
	for(var/i = 1 to rand(slime_data.min_children, slime_data.max_children))
		var/baby_colour = (length(slime_data.descendants) && prob(mutation_chance)) ? pick(slime_data.descendants) : slime_type
		LAZYADD(babies, new slime_data.child_type(loc, baby_colour))
		var/decl/slime_colour/baby_slime_data = GET_DECL(baby_colour)
		SSstatistics.add_field_details("slime_babies_born","slimebirth_[replacetext(baby_slime_data.name," ","_")]")

	if(length(babies))
		var/mob/living/slime/player_baby = pick(babies)
		player_baby.universal_speak = universal_speak
		if(mind)
			mind.transfer_to(player_baby)
		else
			player_baby.key = key

		var/datum/ai/slime/my_ai = ai
		for(var/mob/living/slime/baby in babies)
			step_away(baby, src)
			var/datum/ai/slime/baby_ai = baby.ai
			if(istype(baby_ai) && istype(my_ai))
				baby_ai.observed_friends = my_ai.observed_friends?.Copy()
	qdel(src)
