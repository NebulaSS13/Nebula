/datum/fabricator_recipe/protolathe/organ
	category = "Prosthetic Organs"
	path = /obj/item/organ/internal/stomach

/datum/fabricator_recipe/protolathe/organ/get_product_name()
	. = "prosthetic organ ([..()])"

/datum/fabricator_recipe/protolathe/organ/get_resources()
	. = ..()
	for(var/key in resources)
		if(ispath(key, /decl/reagent))
			resources -= key

/datum/fabricator_recipe/protolathe/organ/build()
	. = ..()
	for(var/obj/item/organ/internal/I in .)
		I.robotize()

/datum/fabricator_recipe/protolathe/organ/heart
	path = /obj/item/organ/internal/heart

/datum/fabricator_recipe/protolathe/organ/liver
	path = /obj/item/organ/internal/liver

/datum/fabricator_recipe/protolathe/organ/kidneys
	path = /obj/item/organ/internal/kidneys

/datum/fabricator_recipe/protolathe/organ/lungs
	path = /obj/item/organ/internal/lungs

/datum/fabricator_recipe/protolathe/organ/eyes
	path = /obj/item/organ/internal/eyes
