/mob/living/carbon/alien/diona/death(gibbed)
	var/obj/structure/diona_gestalt/gestalt = loc
	if(istype(gestalt))
		gestalt.shed_atom(src, TRUE, FALSE)
	if(holding_item)
		try_unequip(holding_item)
	return ..(gibbed,death_msg)
