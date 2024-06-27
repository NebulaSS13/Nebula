/mob/living/simple_animal/alien/diona/death(gibbed)
	. = ..()
	if(.)
		var/obj/structure/diona_gestalt/gestalt = loc
		if(istype(gestalt))
			gestalt.shed_atom(src, TRUE, FALSE)
