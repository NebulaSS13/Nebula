/obj/item/organ/internal/augment/faulty/leaky
	name = "leaky augment"
	desc = "An augment that was badly installed, which occasionally discharges industrial compounds into your body."
	var/list/chemicals = list(
		/decl/material/liquid/enzyme,
		/decl/material/liquid/frostoil,
		/decl/material/liquid/nanitefluid
	)

/obj/item/organ/internal/augment/faulty/leaky/on_malfunction()
	var/reagent = pick(chemicals)
	owner.bloodstr.add_reagent(reagent, rand(1, 3))

