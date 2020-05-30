/mob/observer/eye/freelook/cult
	name = "Mask of God"
	desc = "A terrible fracture of reality coinciding into a mirror to another world."
	living_eye = FALSE

mob/observer/eye/freelook/cult/EyeMove()
	if(owner && istype(owner, /mob/living/deity))
		var/mob/living/deity/D = owner
		if(D.following)
			D.stop_follow()
	return ..()
