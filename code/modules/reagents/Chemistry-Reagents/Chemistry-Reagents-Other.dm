/datum/reagent/water/holywater
	name = "holy water"
	description = "An ashen-obsidian-water mix, this solution will alter certain sections of the brain's rationality."
	color = "#e0e8ef"

	glass_name = "holy water"
	glass_desc = "An ashen-obsidian-water mix, this solution will alter certain sections of the brain's rationality."

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

/datum/reagent/surfactant // Foam precursor
	name = "azosurfactant"
	description = "A isocyanate liquid that forms a foam when mixed with water."
	taste_description = "metal"
	color = "#9e6b38"
	value = 0.05

/datum/reagent/foaming_agent // Metal foaming agent. This is lithium hydride. Add other recipes (e.g. LiH + H2O -> LiOH + H2) eventually.
	name = "foaming agent"
	description = "A agent that yields metallic foam when mixed with light metal and a strong acid."
	taste_description = "metal"
	color = "#664b63"

/datum/reagent/lube
	name = "lubricant"
	description = "Lubricant is a substance introduced between two moving surfaces to reduce the friction and wear between them. giggity."
	taste_description = "slime"
	color = "#009ca8"
	value = 0.6

/datum/reagent/lube/touch_turf(var/turf/simulated/T)
	if(!istype(T))
		return
	if(volume >= 1)
		T.wet_floor(80)

/datum/reagent/woodpulp
	name = "wood pulp"
	description = "A mass of wood fibers."
	taste_description = "wood"
	color = WOOD_COLOR_GENERIC

/datum/reagent/bamboo
	name = "bamboo pulp"
	description = "A mass of bamboo fibers."
	taste_description = "grass"
	color = WOOD_COLOR_PALE2

/datum/reagent/luminol
	name = "luminol"
	description = "A compound that interacts with blood on the molecular level."
	taste_description = "metal"
	color = "#f2f3f4"
	value = 1.4

/datum/reagent/luminol/touch_obj(var/obj/O)
	O.reveal_blood()

/datum/reagent/luminol/touch_mob(var/mob/living/L)
	L.reveal_blood()
