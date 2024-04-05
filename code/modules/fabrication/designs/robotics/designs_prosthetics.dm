#define DEFINE_ROBOLIMB_DESIGNS(MODEL_PATH, MODEL_ID)                      \
/datum/fabricator_recipe/robotics/prosthetic/model_##MODEL_ID {            \
	model = MODEL_PATH;                                                    \
}                                                                          \
/datum/fabricator_recipe/robotics/prosthetic/model_##MODEL_ID/left_leg {   \
	path = /obj/item/organ/external/leg;                                   \
}                                                                          \
/datum/fabricator_recipe/robotics/prosthetic/model_##MODEL_ID/left_foot {  \
	path = /obj/item/organ/external/foot;                                  \
}                                                                          \
/datum/fabricator_recipe/robotics/prosthetic/model_##MODEL_ID/right_leg {  \
	path = /obj/item/organ/external/leg/right;                             \
}                                                                          \
/datum/fabricator_recipe/robotics/prosthetic/model_##MODEL_ID/right_foot { \
	path = /obj/item/organ/external/foot/right;                            \
}                                                                          \
/datum/fabricator_recipe/robotics/prosthetic/model_##MODEL_ID/left_arm {   \
	path = /obj/item/organ/external/arm;                                   \
}                                                                          \
/datum/fabricator_recipe/robotics/prosthetic/model_##MODEL_ID/left_hand {  \
	path = /obj/item/organ/external/hand;                                  \
}                                                                          \
/datum/fabricator_recipe/robotics/prosthetic/model_##MODEL_ID/right_arm {  \
	path = /obj/item/organ/external/arm/right;                             \
}                                                                          \
/datum/fabricator_recipe/robotics/prosthetic/model_##MODEL_ID/right_hand { \
	path = /obj/item/organ/external/hand/right;                            \
}                                                                          \
/datum/fabricator_recipe/robotics/prosthetic/model_##MODEL_ID/head {       \
	path = /obj/item/organ/external/head;                                  \
}                                                                          \
/datum/fabricator_recipe/robotics/prosthetic/model_##MODEL_ID/groin {      \
	path = /obj/item/organ/external/groin;                                 \
}                                                                          \
/datum/fabricator_recipe/robotics/prosthetic/model_##MODEL_ID/chest {      \
	path = /obj/item/organ/external/chest;                                 \
}                                                                          \
/datum/fabricator_recipe/robotics/prosthetic/model_##MODEL_ID/head {       \
	path = /obj/item/organ/external/head;                                  \
}                                                                          \
/datum/fabricator_recipe/robotics/prosthetic/model_##MODEL_ID/groin {      \
	path = /obj/item/organ/external/groin;                                 \
}

/datum/fabricator_recipe/robotics/prosthetic
	var/model

/datum/fabricator_recipe/robotics/prosthetic/New()
	if(model)
		var/decl/bodytype/prosthetic/model_manufacturer = GET_DECL(model)
		category = "[model_manufacturer.name] Prosthetics"
	else
		category = "Unbranded Prosthetics"
	..()

/datum/fabricator_recipe/robotics/prosthetic/is_available_to_fab(var/obj/machinery/fabricator/fab)
	. = ..() && model
	if(.)
		var/obj/machinery/fabricator/robotics/robofab = fab
		if(!istype(robofab))
			return FALSE
		var/decl/bodytype/prosthetic/company = GET_DECL(model)
		if(!istype(company))
			return FALSE
		var/decl/species/species = get_species_by_key(robofab.picked_prosthetic_species)
		if(!istype(species))
			return FALSE
		var/obj/item/organ/target_limb = path
		if(!ispath(target_limb, /obj/item/organ))
			return FALSE
		return company.check_can_install(initial(target_limb.organ_tag), species.default_bodytype.bodytype_category)

/datum/fabricator_recipe/robotics/prosthetic/get_resources()
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

/datum/fabricator_recipe/robotics/prosthetic/get_product_name()
	. = "prosthetic limb ([..()])"
	if(ispath(model))
		var/decl/bodytype/prosthetic/brand = GET_DECL(model)
		return "[.] ([brand.name])"

/datum/fabricator_recipe/robotics/prosthetic/build(var/turf/location, var/datum/fabricator_build_order/order)
	. = ..()
	var/species_name = order.get_data("species", global.using_map.default_species)
	var/decl/species/species = get_species_by_key(species_name)
	if(species)
		for(var/obj/item/organ/external/E in .)
			E.set_species(species_name)
			E.set_bodytype(model)
			E.status |= ORGAN_CUT_AWAY

DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/basic_human, generic)
