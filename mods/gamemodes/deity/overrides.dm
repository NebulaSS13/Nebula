/obj/item/sword/cultblade/can_use_safely(mob/living/user)
	var/decl/special_role/godcult = GET_DECL(/decl/special_role/godcultist)
	return ..() || (user.mind in godcult.current_antagonists)

/datum/reagents/Topic(href, href_list)
	. = ..()
	if(!. && href_list["deconvert"])
		var/list/data = REAGENT_DATA(src, /decl/material/liquid/water)
		if(LAZYACCESS(data, "holy"))
			var/mob/living/target = locate(href_list["deconvert"])
			if(istype(target) && !QDELETED(target) && target.mind)
				var/decl/special_role/godcult = GET_DECL(/decl/special_role/godcultist)
				godcult.remove_antagonist(target.mind, TRUE)

/decl/material/liquid/water/affect_holy(mob/living/M, removed, datum/reagents/holder)
	. = ..()
	if(.)
		return .
	var/decl/special_role/godcult = GET_DECL(/decl/special_role/godcultist)
	if(M.mind && godcult.is_antagonist(M.mind))
		if(REAGENT_VOLUME(holder, type) > 5)
			M.take_damage(5, PAIN, do_update_health = FALSE)
			M.take_damage(1, BRUTE)
			if(prob(10)) //Only annoy them a /bit/
				to_chat(M, SPAN_DANGER("You feel your insides curdle and burn! \[<a href='byond://?src=\ref[holder];deconvert=\ref[M]'>Give Into Purity</a>\]"))
		return TRUE
	return FALSE