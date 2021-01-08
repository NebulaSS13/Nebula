GLOBAL_LIST_INIT(all_objectives, new)

/datum/objective
	var/datum/mind/owner             //Who owns the objective.
	var/explanation_text = "Nothing" //What that person is supposed to do.
	var/datum/mind/target            //If they are focused on a particular person.
	var/target_amount = 0            //If they are focused on a particular number. Steal objectives have their own counter.

/datum/objective/New(var/text)
	GLOB.all_objectives |= src
	if(text)
		explanation_text = text
	..()

/datum/objective/Destroy()
	GLOB.all_objectives -= src
	. = ..()

/datum/objective/proc/find_target()
	var/list/possible_targets = list()
	for(var/datum/mind/possible_target in SSticker.minds)
		if(possible_target != owner && ishuman(possible_target.current) && (possible_target.current.stat != DEAD))
			possible_targets += possible_target
	if(possible_targets.len > 0)
		target = pick(possible_targets)
