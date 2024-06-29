/datum/mob_controller/nymph
	name = "nymph"
	expected_type = /mob/living/simple_animal/alien/diona
	var/emote_prob = 3
	var/wander_prob = 44

/datum/mob_controller/nymph/do_process(var/time_elapsed)
	if(body.stat != CONSCIOUS)
		return
	if(prob(wander_prob) && !LAZYLEN(body.grabbed_by) && isturf(body.loc)) //won't move if being pulled
		body.SelfMove(pick(global.cardinal))
	if(prob(emote_prob))
		body.emote(pick(/decl/emote/visible/scratch, /decl/emote/visible/jump, /decl/emote/audible/chirp, /decl/emote/visible/tail))
