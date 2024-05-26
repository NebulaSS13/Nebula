/obj/item/organ/internal/brain/handle_severe_damage()
	. = ..()
	var/datum/ability_handler/psionics/psi = owner?.get_ability_handler(/datum/ability_handler/psionics)
	psi?.check_latency_trigger(20, "physical trauma")