/mob/living/proc/get_pulse()
	if(stat == DEAD || isSynthetic())
		return PULSE_NONE
	if(!should_have_organ(BP_HEART))
		return PULSE_NORM
	var/obj/item/organ/internal/heart/heart = get_organ(BP_HEART, /obj/item/organ/internal/heart)
	if(heart)
		return heart.pulse
	return PULSE_NONE

//generates realistic-ish pulse output based on preset levels as text
/mob/living/proc/get_pulse_as_string(var/method)	//method 0 is for hands, 1 is for machines, more accurate
	if(should_have_organ(BP_HEART))
		var/obj/item/organ/internal/heart/heart_organ = get_organ(BP_HEART, /obj/item/organ/internal/heart)
		if(!heart_organ)
			// No heart, no pulse
			return "0"
		if(heart_organ.open && !method)
			// Heart is a open type (?) and cannot be checked unless it's a machine
			return "muddled and unclear; you can't seem to find a vein"
	var/bpm = get_pulse_as_number()
	if(bpm >= PULSE_MAX_BPM)
		return method ? ">[PULSE_MAX_BPM]" : "extremely weak and fast, patient's artery feels like a thread"
	return "[method ? bpm : bpm + rand(-10, 10)]"
// output for machines ^	 ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ output for people

// Similar to get_pulse, but returns only integer numbers instead of text.
/mob/living/proc/get_pulse_as_number()
	switch(get_pulse())
		if(PULSE_NONE)
			return 0
		if(PULSE_SLOW)
			return rand(40, 60)
		if(PULSE_NORM)
			return rand(60, 90)
		if(PULSE_FAST)
			return rand(90, 120)
		if(PULSE_2FAST)
			return rand(120, 160)
		if(PULSE_THREADY)
			return PULSE_MAX_BPM
	return 0
