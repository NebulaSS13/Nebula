//Fake telepathy
/datum/hallucination/telepathy
	allow_duplicates = 0
	duration = 20 MINUTES

/datum/hallucination/telepathy/start()
	. = ..()
	to_chat(holder, SPAN_NOTICE("You expand your mind outwards."))
	holder.verbs += /mob/living/human/proc/fakeremotesay

/datum/hallucination/telepathy/end()
	. = ..()
	if(holder)
		holder.verbs -= /mob/living/human/proc/fakeremotesay

/mob/living/human/proc/fakeremotesay()
	set name = "Telepathic Message"
	set category = "Superpower"

	if(!hallucination_power)
		src.verbs -= /mob/living/human/proc/fakeremotesay
		return

	if(stat)
		to_chat(usr, SPAN_WARNING("You're not in any state to use your powers right now!"))
		return

	if(has_chemical_effect(CE_MIND, 1))
		to_chat(usr, SPAN_WARNING("Chemicals in your blood prevent you from using your power!"))

	var/list/creatures = list()
	for(var/mob/living/creature in SSmobs.mob_list)
		creatures += creature
	creatures -= usr
	var/mob/target = input("Who do you want to project your mind to?") as null|anything in creatures
	if (isnull(target))
		return

	var/msg = sanitize(input(usr, "What do you wish to transmit"))
	show_message(SPAN_NOTICE("You project your mind into [target.name]: \"[msg]\""))
	if(!stat && prob(20))
		say(msg)
