/mob/living/carbon/human/proc/handle_eye_blink()
	eye_blink()

/mob/living/carbon/human
	var/eye_colour_back = null
	var/eye_close_stat = 0

/mob/living/carbon/human/proc/create_eye_blink()
	eye_colour_back = eye_colour

/mob/living/carbon/human/proc/eye_blink_spawn()
	change_eye_color(eye_colour_back)
	eye_close_stat = 0

/mob/living/carbon/human/proc/eye_blink()
	var/RED
	var/GREEN
	var/BLUE
	switch(get_species())
		if(SPECIES_HUMAN)
			RED = 225 + skin_tone
			GREEN = 172 + skin_tone
			BLUE = 119 + skin_tone
		else
			return

	if(!stat)

		if(rand(1,100) <= 20)

			if(!eye_close_stat)

				create_eye_blink()

			change_eye_color(rgb(RED, GREEN, BLUE))
			addtimer(CALLBACK(src, .proc/eye_blink_spawn), 1)

		else if(eye_close_stat)

			change_eye_color(eye_colour_back)

	else if(!eye_close_stat)

		if(!eye_close_stat)

			create_eye_blink()

		change_eye_color(rgb(RED, GREEN, BLUE))
		eye_close_stat = 1
