/obj/item/organ/internal/augment/faulty/overstimulator
	name = "motor control overstimulator"
	desc = "An augment that was badly installed. This one causes full body paralysis and seizures at the worst times."

/obj/item/organ/internal/augment/faulty/overstimulator/on_malfunction()
	owner.emote("collapse")
	owner.Stun(rand(2, 4))