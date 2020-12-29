/mob/living/carbon/alien/diona/verb/split_away()
	set name = "Split From Gestalt"
	set category = "IC"
	set src = usr
	if(incapacitated())
		return
	if(istype(loc, /obj/structure/diona_gestalt)) // Handle nymph katamari.
		var/obj/structure/diona_gestalt/gestalt = loc
		gestalt.visible_message("<span class='notice'>\The [src] wriggles out of \the [gestalt] and plops to the ground.</span>")
		gestalt.shed_atom(src, TRUE, FALSE)
		return
	to_chat(src, "<span>You are not within a gestalt currently.</span>")
