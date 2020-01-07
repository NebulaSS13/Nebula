/mob/living/carbon/alien/diona/death(gibbed)

	var/obj/structure/diona_gestalt/gestalt = loc
	if(istype(gestalt))
		gestalt.shed_atom(src, TRUE, FALSE)

	if(holding_item)
		unEquip(holding_item)
	if(hat)
		unEquip(hat)

	return ..(gibbed,death_msg)
