/datum/reagent/water/holywater
	name = "holy water"
	description = "An ashen-obsidian-water mix, this solution will alter certain sections of the brain's rationality."
	color = "#e0e8ef"
	glass_name = "holy water"
	glass_desc = "An ashen-obsidian-water mix, this solution will alter certain sections of the brain's rationality."
	hidden_from_codex = TRUE

/datum/reagent/water/holywater/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(ishuman(M)) // Any location
		if(iscultist(M))
			if(prob(10))
				GLOB.cult.offer_uncult(M)
			if(prob(2))
				var/obj/effect/spider/spiderling/S = new /obj/effect/spider/spiderling(M.loc)
				M.visible_message("<span class='warning'>\The [M] coughs up \the [S]!</span>")
		else if(M.mind && GLOB.godcult.is_antagonist(M.mind))
			if(volume > 5)
				M.adjustHalLoss(5)
				M.adjustBruteLoss(1)
				if(prob(10)) //Only annoy them a /bit/
					to_chat(M,"<span class='danger'>You feel your insides curdle and burn!</span> \[<a href='?src=\ref[src];deconvert=\ref[M]'>Give Into Purity</a>\]")

/datum/reagent/water/holywater/Topic(href, href_list)
	. = ..()
	if(!. && href_list["deconvert"])
		var/mob/living/carbon/C = locate(href_list["deconvert"])
		if(C.mind)
			GLOB.godcult.remove_antagonist(C.mind,1)

/datum/reagent/water/holywater/touch_turf(var/turf/T)
	if(volume >= 5)
		T.holy = 1
	return
