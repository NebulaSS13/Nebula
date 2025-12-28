/obj/item/electronic_assembly/augment
	name = "augment electronic assembly"
	icon_state = "setup_augment"
	desc = "It's a case, for building small electronics with. This one is designed to go inside a cybernetic augment."
	circuit_flags = IC_FLAG_CAN_FIRE

/obj/item/organ/internal/augment/active/simple/circuit
	name = "integrated circuit frame"
	action_button_name = "Activate Circuit"
	icon_state = "circuit"
	allowed_organs = list(BP_AUGMENT_R_ARM, BP_AUGMENT_L_ARM)
	holding = null //We must get the holding item externally
	//Limited to robolimbs
	augment_flags = AUGMENTATION_MECHANIC
	desc = "A DIY modular assembly. Circuitry not included."
	material = /decl/material/solid/metal/steel
	origin_tech = @'{"materials":1,"magnets":1,"engineering":1,"programming":2}'

/obj/item/organ/internal/augment/active/simple/circuit/attackby(obj/item/used_item, mob/user)
	if(IS_CROWBAR(used_item))
		//Remove internal circuit
		if(holding)
			holding.canremove = 1
			holding.dropInto(loc)
			to_chat(user, SPAN_NOTICE("You take out \the [holding]."))
			holding = null
			playsound(loc, 'sound/items/Crowbar.ogg', 50, 1)
		else to_chat(user, SPAN_WARNING("The augment is empty!"))
		return TRUE
	if(istype(used_item, /obj/item/electronic_assembly/augment))
		if(holding)
			to_chat(user, SPAN_WARNING("There's already an assembly in there."))
		else if(user.try_unequip(used_item, src))
			holding = used_item
			holding.canremove = 0
			playsound(loc, 'sound/items/Crowbar.ogg', 50, 1)
		return TRUE
	return ..()

// And add a fabricator design
/datum/fabricator_recipe/robotics/augment/circuit
	path = /obj/item/organ/internal/augment/active/simple/circuit