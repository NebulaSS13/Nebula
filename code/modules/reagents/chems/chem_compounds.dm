/datum/reagent/acetone
	name = "acetone"
	description = "A colorless liquid solvent used in chemical synthesis."
	taste_description = "acid"
	color = "#808080"
	metabolism = REM * 0.2
	value = 0.2

/datum/reagent/acetone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustToxLoss(removed * 3)

/datum/reagent/acetone/touch_obj(var/obj/O)	//I copied this wholesale from ethanol and could likely be converted into a shared proc. ~Techhead
	if(istype(O, /obj/item/paper))
		var/obj/item/paper/paperaffected = O
		paperaffected.clearpaper()
		to_chat(usr, "The solution dissolves the ink on the paper.")
		return
	if(istype(O, /obj/item/book))
		if(volume < 5)
			return
		if(istype(O, /obj/item/book/tome))
			to_chat(usr, "<span class='notice'>The solution does nothing. Whatever this is, it isn't normal ink.</span>")
			return
		var/obj/item/book/affectedbook = O
		affectedbook.dat = null
		to_chat(usr, "<span class='notice'>The solution dissolves the ink on the book.</span>")
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

/datum/reagent/glowsap
	name = "glowsap"
	description = "A popular party drug for adventurous types who want to BE the glowstick. May be hallucinogenic in high doses."
	overdose = 15
	color = "#9eefff"

/datum/reagent/glowsap/affect_ingest(mob/living/carbon/M, alien, removed)
	affect_blood(M, alien, removed)

/datum/reagent/glowsap/affect_blood(mob/living/carbon/M, alien, removed)
	M.add_chemical_effect(CE_GLOWINGEYES, 1)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.update_eyes()

/datum/reagent/glowsap/on_leaving_metabolism(mob/parent, metabolism_class)
	if(ishuman(parent))
		var/mob/living/carbon/human/H = parent
		addtimer(CALLBACK(H, /mob/living/carbon/human/proc/update_eyes), 5 SECONDS)
	. = ..()

/datum/reagent/glowsap/overdose(var/mob/living/carbon/M, var/alien)
	. = ..()
	M.add_chemical_effect(CE_TOXIN, 1)
	M.hallucination(60, 20)
	M.druggy = max(M.druggy, 2)
