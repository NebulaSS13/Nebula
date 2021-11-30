/*
 This system is used to generate idle NPC chatter on radio channels. The idea was stolen from Polaris.
 Example implementation:

/decl/radio_chatter/debug
	interruption_responses = list("Sorry, $TARGET$, could you repeat that?")
	chatter_on_frequency = PUB_FREQ
	listener_landmark = "radioChatterDebugLandmark"

/obj/abstract/landmark/radio_chatter_debug
	name = "radioChatterDebugLandmark"

/decl/radio_chatter/debug/create_conversations()
	calls_and_responses = list(
		new /datum/chatter_conversation/debug_one
	)
	
/datum/chatter_conversation/debug_one/create_lines()
	chatter_lines = list(
		new /datum/chatter_line("Sir One",  "Dame Two", "This is $NAME$ to $TARGET$, what's our vector, Victor?"),
		new /datum/chatter_line("Dame Two", "Sir One",  "$NAME$ to $TARGET$, I preferred Naked Gun, over."),
		new /datum/chatter_line("Sir One",  "Dame Two", "Hi, $NAME$ to $TARGET$, roger, Roger.")
	)

/datum/map/tradeship/get_radio_chatter_types()
	return list(/decl/radio_chatter/debug)
*/

/decl/radio_chatter
	var/list/calls_and_responses
	var/list/interruption_responses
	var/next_chatter_time
	var/interrupted
	var/last_speaker
	var/last_subject
	var/min_line_time =            3 SECONDS
	var/max_line_time =            6 SECONDS
	var/min_chatter_time_elapsed = 4 MINUTES
	var/max_chatter_time_elapsed = 8 MINUTES
	var/chatter_on_frequency =     PUB_FREQ
	var/datum/chatter_conversation/current_dialogue_sequence
	var/obj/item/radio/virtual/listener_instance = /obj/item/radio/virtual
	var/listener_landmark

/decl/radio_chatter/Initialize()
	. = ..()
	START_PROCESSING(SSradiochatter, src)
	create_conversations()
	next_chatter_time = world.time + rand(min_chatter_time_elapsed, max_chatter_time_elapsed)
	if(listener_landmark && ispath(listener_instance))
		for(var/obj/abstract/landmark/landmark in global.landmarks_list)
			if(landmark.name != listener_landmark)
				continue
			var/turf/T = get_turf(landmark)
			if(!T)
				continue
			var/obj/item/radio/virtual/existing_listener = locate() in T
			if(existing_listener)
				listener_instance = existing_listener
			else
				listener_instance = new listener_instance(T, src)
			break
	if(!istype(listener_instance))
		listener_instance = null
	else
		listener_instance.frequency = chatter_on_frequency

/decl/radio_chatter/proc/create_conversations()
	return

/decl/radio_chatter/Process()

	if(!length(calls_and_responses))
		return

	if(world.time < next_chatter_time)
		return

	if(!current_dialogue_sequence)
		current_dialogue_sequence = pick(calls_and_responses)
		current_dialogue_sequence.reset()
	else if(interrupted)
		interrupted = FALSE
		if(length(interruption_responses))
			broadcast(last_subject, last_speaker, pick(interruption_responses))
			current_dialogue_sequence.step_to_previous_line()
			next_chatter_time = world.time + rand(min_line_time, max_line_time)
			return

	var/list/broadcasting = current_dialogue_sequence.get_message_details()
	broadcast(broadcasting[1], broadcasting[2], broadcasting[3])
	if(!current_dialogue_sequence.step_to_next_line())
		current_dialogue_sequence = null
		next_chatter_time = world.time + rand(min_chatter_time_elapsed, max_chatter_time_elapsed)
	else
		next_chatter_time = world.time + rand(min_line_time, max_line_time)
		
/decl/radio_chatter/proc/hear_chat()
	if(current_dialogue_sequence)
		interrupted = TRUE
	else
		next_chatter_time = world.time + min_line_time

/decl/radio_chatter/proc/broadcast(var/speaker, var/subject, var/message)
	if(!listener_instance)
		return
	last_speaker = speaker
	message = replacetext(message, "$NAME$", last_speaker)
	last_subject = subject
	message = replacetext(message, "$TARGET$", last_subject)
	listener_instance.frequency = chatter_on_frequency
	listener_instance.autosay(capitalize(trim(message)), capitalize(trim(last_speaker)), sayverb = "says")
