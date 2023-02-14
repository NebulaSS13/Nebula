/mob/living
	var/dreaming = 0

/mob/living/proc/dream()
	set waitfor = FALSE
	dreaming = 1

	for(var/i = rand(1,4),i > 0, i--)
		to_chat(src, "<span class='notice'><i>... [pick(SSlore.dreams)] ...</i></span>")
		sleep(rand(40,70))
		if(!HAS_STATUS(src, STAT_PARA))
			dreaming = 0
			return
	dreaming = 0

/mob/living/proc/handle_dreams()
	if(client && !dreaming && prob(5))
		dream()
