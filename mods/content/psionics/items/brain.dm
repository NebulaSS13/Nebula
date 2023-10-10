/obj/item/organ/internal/brain/handle_severe_damage()
	. = ..()
	if(owner.psi)
		owner.psi.check_latency_trigger(20, "physical trauma")