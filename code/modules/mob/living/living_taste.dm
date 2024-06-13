/mob/living
	/// these two help govern taste. The first is the last time a taste message was shown to the player.
	var/last_taste_time = 0
	/// the second is the message in question.
	var/last_taste_text = ""

/mob/living/proc/ingest(var/datum/reagents/from, var/datum/reagents/target, var/amount = 1, var/multiplier = 1, var/copy = 0)
	if(last_taste_time + 50 < world.time)
		var/datum/reagents/temp = new(amount, global.temp_reagents_holder) //temporary holder used to analyse what gets transfered.
		from.trans_to_holder(temp, amount, multiplier, 1)
		var/text_output = temp.generate_taste_message(src, from)
		if(text_output != last_taste_text || last_taste_time + 1 MINUTE < world.time) //We dont want to spam the same message over and over again at the person. Give it a bit of a buffer.
			to_chat(src, SPAN_NOTICE("You can taste [text_output].")) //no taste means there are too many tastes and not enough flavor.
			last_taste_time = world.time
			last_taste_text = text_output
	RAISE_EVENT(/decl/observ/ingested, src, from, target, amount, multiplier, copy)
	return from?.trans_to_holder(target, amount, multiplier, copy)
