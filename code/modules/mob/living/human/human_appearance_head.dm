/mob/living/human
	var/_eye_colour

// Eyes! TODO, make these a marking.
/mob/living/human/get_eye_colour()
	return _eye_colour

/mob/living/human/set_eye_colour(var/new_color, var/skip_update = FALSE)
	if((. = ..()))
		_eye_colour = new_color
		if(!skip_update)
			update_eyes()
			update_body()
