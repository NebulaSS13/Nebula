/datum/fabricator_recipe/robotics/organ
	category = "Prosthetic Organs"
	path = /obj/item/organ/internal/stomach

/datum/fabricator_recipe/robotics/organ/get_product_name()
	. = "prosthetic organ ([..()])"

/datum/fabricator_recipe/robotics/organ/get_resources()
	. = ..()
	for(var/key in resources)
		if(!ispath(key, /decl/material/solid))
			resources -= key
	var/meat_amount = LAZYACCESS(resources, /decl/material/solid/meat)
	if(meat_amount)
		if(LAZYACCESS(resources, /decl/material/solid/metal/steel))
			resources[/decl/material/solid/metal/steel] += meat_amount
		else
			LAZYSET(resources, /decl/material/solid/metal/steel, meat_amount)
		LAZYREMOVE(resources, /decl/material/solid/meat)

/datum/fabricator_recipe/robotics/organ/build()
	. = ..()
	for(var/obj/item/organ/internal/I in .)
		I.robotize()

/datum/fabricator_recipe/robotics/organ/heart
	path = /obj/item/organ/internal/heart

/datum/fabricator_recipe/robotics/organ/liver
	path = /obj/item/organ/internal/liver

/datum/fabricator_recipe/robotics/organ/kidneys
	path = /obj/item/organ/internal/kidneys

/datum/fabricator_recipe/robotics/organ/lungs
	path = /obj/item/organ/internal/lungs

/datum/fabricator_recipe/robotics/organ/eyes
	path = /obj/item/organ/internal/eyes
