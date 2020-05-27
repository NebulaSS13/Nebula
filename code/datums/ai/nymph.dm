/datum/ai/nymph
	name = "nymph"
	var/emote_prob = 1
	var/wander_prob = 33

/datum/ai/nymph/do_process()
	if(body.stat != CONSCIOUS)
		return
	if(prob(wander_prob) && !LAZYLEN(body.grabbed_by) && isturf(body.loc)) //won't move if being pulled
		body.SelfMove(pick(GLOB.cardinal))
	if(prob(emote_prob))
		body.emote(pick("scratch","jump","chirp","tail"))