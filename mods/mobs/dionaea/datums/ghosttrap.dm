#define isdiona(X) istype(X, /mob/living/simple_animal/alien/diona)

/decl/ghosttrap/sentient_plant/welcome_candidate(var/mob/target)
	..()
	// This is a hack, replace with some kind of species blurb proc.
	if(isdiona(target))
		to_chat(target, "<B>You are \a [target], one of a race of drifting interstellar plantlike creatures that sometimes share their seeds with human traders.</B>")
		to_chat(target, "<B>Too much darkness will send you into shock and starve you, but light will help you heal.</B>")
