/obj/item/implant/imprinting
	name = "imprinting implant"
	desc = "Latest word in training your peons."
	origin_tech = @'{"materials":1,"biotech":2,"programming":3}'
	hidden = TRUE
	var/list/instructions = list("Do your job.", "Respect your superiors.", "Wash you hands after using the toilet.")
	var/brainwashing = FALSE

/obj/item/implant/imprinting/get_data()
	. = {"
	<b>Implant Specifications:</b><BR>
	<b>Name:</b> BB-56 "Educator" Employee Assistance Implant<BR>
	<b>Life:</b> 1 year.<BR>
	<HR>
	<b>Function:</b> Adjusts itself to host's brainwaves, and presents supplied instructions as their 'inner voice' for less intrusive reminding. It will transmit them every 5 minutes in non-obtrusive manner.<BR>
	<b>Special Features:</b> Do NOT implant if subject is under effect of any mind-altering drugs.
	It carries risk of over-tuning, making subject unable to question the suggestions received, treating them as beliefs they feel strongly about.<BR>
	It is HIGLY ILLEGAL and the seller does NOT endorse use of this device in such way.
	Any amount of "Mind-Breaker"(TM) present in bloodstream will trigger this side-effect.<BR>"}
	. += "<HR><B>Instructions:</B><BR>"
	for(var/i = 1 to length(instructions))
		. += "- [instructions[i]] <A href='byond://?src=\ref[src];edit=[i]'>Edit</A> <A href='byond://?src=\ref[src];del=[i]'>Remove</A><br>"
	. += "<A href='byond://?src=\ref[src];add=1'>Add</A>"

/obj/item/implant/imprinting/OnTopic(mob/user, href_list, datum/topic_state/state)
	if (href_list["add"])
		var/mod = sanitize(input("Add an instruction", "Instructions") as text|null)
		if(mod)
			instructions += mod
			return TOPIC_REFRESH
		return TOPIC_HANDLED
	if (href_list["edit"])
		var/idx = text2num(href_list["edit"])
		var/mod = sanitize(input("Edit the instruction", "Instruction Editing", instructions[idx]) as text|null)
		if(mod)
			instructions[idx] = mod
			return TOPIC_REFRESH
		return TOPIC_HANDLED
	if (href_list["del"])
		instructions -= instructions[text2num(href_list["del"])]
		return TOPIC_REFRESH
	return TOPIC_NOACTION

/obj/item/implant/imprinting/implanted(mob/living/victim)
	var/mob/living/human/human_victim = victim
	if(!istype(human_victim))
		return FALSE
	if(human_victim.reagents.has_reagent(/decl/material/liquid/hallucinogenics))
		brainwashing = TRUE
	var/msg = get_instructions()
	to_chat(human_victim, msg)
	if(human_victim.mind)
		human_victim.StoreMemory(msg, /decl/memory_options/system)
	if(brainwashing)
		log_and_message_admins("was implanted with a brainwashing implant holding the following laws: [jointext(instructions, ";")].", human_victim)
	addtimer(CALLBACK(src,PROC_REF(activate)), 5 MINUTES, (TIMER_UNIQUE|TIMER_OVERRIDE))
	return TRUE

/obj/item/implant/imprinting/proc/get_instructions()
	. = list()
	if(brainwashing)
		. += SPAN_DANGER("The fog in your head clears, and you remember some important things. You hold the following as deep convictions, almost like synthetics' laws:")
	else
		. += SPAN_NOTICE("You hear an annoying voice in the back of your head. The things it keeps reminding you of are:")
	for(var/thing in instructions)
		. += "- [thing]"
	. = jointext(., "<br>")

/obj/item/implant/imprinting/disable(time)
	. = ..()
	if(. && brainwashing)//add deactivate and reactivate messages?
		show_deactivate_message()

/obj/item/implant/imprinting/restore()
	. = ..()
	if(. && brainwashing)
		to_chat(imp_in, get_instructions())
		activate()

/obj/item/implant/imprinting/activate()
	if(malfunction || !implanted || imp_in)
		return
	var/instruction = pick(instructions)
	if(brainwashing)
		instruction = SPAN_WARNING("You recall one of your beliefs: \"[instruction]\"")
	else
		instruction = SPAN_NOTICE("You remember suddenly: \"[instruction]\"")
	to_chat(imp_in, instruction)
	addtimer(CALLBACK(src, PROC_REF(activate)), 5 MINUTES, (TIMER_UNIQUE|TIMER_OVERRIDE))

/obj/item/implant/imprinting/removed()
	if(brainwashing && !malfunction)
		show_deactivate_message()
	..()

/obj/item/implant/imprinting/emp_act(severity)
	var/power = 4 - severity
	if(prob(power * 15))
		meltdown()
	else if(prob(power * 40))
		disable(rand(power*10 SECONDS,power*100 SECONDS))//a few precious seconds of freedom

/obj/item/implant/imprinting/proc/show_deactivate_message()
	to_chat(imp_in, SPAN_WARNING("A wave of nausea comes over you."))
	to_chat(imp_in, SPAN_GOOD("You are no longer so sure of those beliefs you've had..."))

/obj/item/implant/imprinting/meltdown()
	if(brainwashing && !malfunction)//if it's already broken don't send the message again
		show_deactivate_message()
	. = ..()

/obj/item/implant/imprinting/can_implant(mob/living/victim, mob/living/user, target_zone)
	var/mob/living/human/human_victim = victim
	if(istype(human_victim))
		var/obj/item/organ/internal/victim_brain = GET_INTERNAL_ORGAN(human_victim, BP_BRAIN)
		if(!victim_brain || human_victim.isSynthetic())
			to_chat(user, SPAN_WARNING("\The [human_victim] cannot be imprinted."))
			return FALSE
		if(!(victim_brain.parent_organ == check_zone(target_zone, human_victim)))
			to_chat(user, SPAN_WARNING("\The [src] must be implanted in [GET_EXTERNAL_ORGAN(human_victim, victim_brain.parent_organ)]."))
			return FALSE
	return TRUE

/obj/item/implanter/imprinting
	name = "imprinting implanter"
	imp = /obj/item/implant/imprinting

/obj/item/implantcase/imprinting
	name = "glass case - 'imprinting'"
	imp = /obj/item/implant/imprinting