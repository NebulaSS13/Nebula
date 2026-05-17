/datum/trader/devices/New()
	LAZYSET(possible_trading_items, /obj/item/organ/internal/brain_interface, TRADER_SUBTYPES_ONLY)
	. = ..()

/datum/controller/subsystem/robots/PreInit()
	. = ..()
	LAZYSET(mob_types_by_title, "cyborg, flying", /mob/living/silicon/robot/flying)
	LAZYSET(processor_types_by_title, "cyborg", /obj/item/organ/internal/brain_interface)
	LAZYSET(processor_types_by_title, "cyborg, flying", /obj/item/organ/internal/brain_interface)

// Override to use MMIs for mobs with brains
/obj/item/projectile/change/make_robot(var/mob/living/victim, robot_title = ASSIGNMENT_ROBOT)
	var/obj/item/organ/internal/brain/victim_brain = victim.get_organ(BP_BRAIN, /obj/item/organ/internal/brain)
	if(istype(victim_brain) && victim_brain.can_use_brain_interface)
		robot_title = "Cyborg"
	return ..(victim, robot_title)

/obj/item/robot_parts/robot_suit/is_valid_processor(obj/item/used_item)
	return ..() || istype(used_item, /obj/item/organ/internal/brain_interface)

/decl/bodytype/prosthetic/Initialize()
	LAZYSET(has_organ, BP_BRAIN, /obj/item/organ/internal/brain_interface)
	. = ..()

/obj/item/rig_module/ai_container/Initialize(mapload)
	simple_insert_types |= /obj/item/organ/internal/brain_interface
	. = ..()

/obj/item/gripper/research/Initialize(ml, material_key)
	can_hold += /obj/item/organ/internal/brain_interface
	. = ..()
