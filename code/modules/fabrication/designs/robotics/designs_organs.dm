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
	var/organ_meat_amount = LAZYACCESS(resources, /decl/material/solid/organic/meat)
	if(organ_meat_amount)
		if(LAZYACCESS(resources, /decl/material/solid/metal/steel))
			resources[/decl/material/solid/metal/steel] += organ_meat_amount
		else
			LAZYSET(resources, /decl/material/solid/metal/steel, organ_meat_amount)
		LAZYREMOVE(resources, /decl/material/solid/organic/meat)

/datum/fabricator_recipe/robotics/organ/build(turf/location, datum/fabricator_build_order/order)
	. = ..()
	var/decl/species/species = get_species_by_key(order.get_data("species", global.using_map.default_species))
	for(var/obj/item/organ/internal/I in .)
		I.set_species(species)
		I.set_bodytype(species.base_internal_prosthetics_model)
		I.status |= ORGAN_CUT_AWAY

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
