/obj/item/organ/internal/augment/faulty/elec_discharge
	name = "electrical discharge"
	desc = "An augment that was badly installed, which occasionally discharges electricity through your body, causing pain and brief paralysis but no damage."

/obj/item/organ/internal/augment/faulty/elec_discharge/on_malfunction()
	owner.custom_pain("Pain jolts through your broken [limb], staggering you!", 50, affecting = owner)
	owner.Stun(2)