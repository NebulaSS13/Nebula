/obj/item/organ/internal/augment/faulty/acid_discharge
	name = "acidic discharge"
	desc = "An augment that was badly installed, which occasionally discharges acid into your body."

/obj/item/organ/internal/augment/faulty/acid_discharge/on_malfunction()
	owner.custom_pain("A burning sensation spreads through your [limb].", 5, affecting = owner)
	owner.bloodstr.add_reagent(/decl/material/liquid/acid, rand(1, 3))