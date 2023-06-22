/decl/pronouns/male
	name = MALE
	bureaucratic_term  = "male"
	informal_term = "guy"

	He   = "He"
	he   = "he"
	His  = "His"
	his  = "his"
	him  = "him"
	has  = "has"
	is   = "is"
	does = "does"
	self = "himself"
	s    = "s"
	es   = "es"

	// Thanks oldcoders.
	var/static/list/weird_euphemisms_for_your_balls = list(
		"testicles",
		"crown jewels",
		"clockweights",
		"family jewels",
		"marbles",
		"bean bags",
		"teabags",
		"sweetmeats",
		"goolies",
		"boys",
		"nutsack",
		"block and tackle",
		"cojones"
	)

/decl/pronouns/male/get_message_for_being_kicked_in_the_dick()
	return "Oh no, not your [pick(weird_euphemisms_for_your_balls)]!"
