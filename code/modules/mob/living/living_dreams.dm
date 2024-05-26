/mob/living
	var/dreaming = FALSE

/mob/living/proc/handle_dreams()
	set waitfor = FALSE
	if(!client || dreaming || !prob(5))
		return
	dreaming = TRUE
	for(var/i = 1 to rand(1,4))
		to_chat(src, SPAN_NOTICE("<i>... [pick(SSlore.dreams)] ...</i>"))
		sleep(rand(4 SECONDS, 7 SECONDS))
		if(!HAS_STATUS(src, STAT_ASLEEP))
			break
	dreaming = FALSE
