#define DEFINE_ROBOLIMB_DESIGNS(MODEL_PATH, MODEL_ID, MODEL_NAME)          \
/datum/fabricator_recipe/robotics/prosthetic/model_##MODEL_ID {            \
	category = MODEL_NAME + " Prosthetics";                                \
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
}
/* Readd if FBP construction is desirable
/datum/fabricator_recipe/robotics/prosthetic/model_##MODEL_ID/chest {      \
	path = /obj/item/organ/external/chest;                                 \
}                                                                          \
*/

/datum/fabricator_recipe/robotics/prosthetic
	var/model

/datum/fabricator_recipe/robotics/prosthetic/get_resources()
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

/datum/fabricator_recipe/robotics/prosthetic/get_product_name()
	. = "prosthetic limb ([..()])"
	if(ispath(model))
		var/decl/prosthetics_manufacturer/brand = GET_DECL(model)
		return "[.] ([brand.name])"

/datum/fabricator_recipe/robotics/prosthetic/build()
	. = ..()
	for(var/obj/item/organ/external/E in .)
		E.robotize(model)

DEFINE_ROBOLIMB_DESIGNS(/decl/prosthetics_manufacturer, generic, "Unbranded")
