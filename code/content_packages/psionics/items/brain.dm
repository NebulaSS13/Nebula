/obj/item/organ/internal/brain/handle_severe_brain_damage()
	. = ..()
	if(owner.psi)
		owner.psi.check_latency_trigger(20, "physical trauma")