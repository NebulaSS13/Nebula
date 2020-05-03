/mob/living/Move(a, b, flag)
	if(SSautosave.saving)
		return
	. = ..()