/datum/fabricator_recipe/meat/organ
	category = "Cloned Organs"
	path = /obj/item/organ/internal/stomach

/datum/fabricator_recipe/meat/organ/get_product_name()
	. = "cloned organ ([..()])"

/datum/fabricator_recipe/meat/organ/get_resources()
	. = ..()
	for(var/key in resources)
		if(!ispath(key, /decl/material/solid))
			resources -= key

/datum/fabricator_recipe/meat/organ/heart
	path = /obj/item/organ/internal/heart

/datum/fabricator_recipe/meat/organ/liver
	path = /obj/item/organ/internal/liver

/datum/fabricator_recipe/meat/organ/kidneys
	path = /obj/item/organ/internal/kidneys

/datum/fabricator_recipe/meat/organ/lungs
	path = /obj/item/organ/internal/lungs

/datum/fabricator_recipe/meat/organ/eyes
	path = /obj/item/organ/internal/eyes
