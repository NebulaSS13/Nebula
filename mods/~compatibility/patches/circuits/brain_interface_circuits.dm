/obj/item/integrated_circuit/manipulation/ai/can_load_ai(obj/item/used_item, mob/user)
	return ..() || istype(used_item, /obj/item/organ/internal/brain_interface)