/obj/item/organ/internal/augment/faulty/itchy
	name = "itchy metal thing"
	desc = "An augment that was badly installed. Sometimes it itches horribly."

/obj/item/organ/internal/augment/faulty/itchy/on_malfunction()
	to_chat(owner, SPAN_DANGER("A broken augment under in your [limb] itches so badly!"))