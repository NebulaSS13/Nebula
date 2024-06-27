/datum/deity_item/blood_crafting
	abstract_type = /datum/deity_item/blood_crafting
	name = DEITY_BLOOD_CRAFT
	desc = "Unlocks the blood smithing structure which allows followers to forge unholy tools from blood and flesh."
	category = DEITY_BLOOD_CRAFT
	max_level = 1
	base_cost = 75
	var/forge_type = /obj/structure/deity/blood_forge
	var/list/recipes = list()

/datum/deity_item/blood_crafting/buy(var/mob/living/deity/user)
	..()
	user.form.buildables |= forge_type //put structure here
	var/list/L = user.feats[name]
	if(!L)
		L = list()
	for(var/type in recipes)
		L[type] = recipes[type]
	user.feats[name] = L