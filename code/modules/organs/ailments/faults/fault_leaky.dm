/datum/ailment/fault/leaky
	var/global/list/chemicals = list(
		/decl/material/liquid/enzyme,
		/decl/material/liquid/frostoil,
		/decl/material/liquid/nanitefluid
	)

/datum/ailment/fault/leaky/on_malfunction()
	var/reagent = pick(chemicals)
	organ.owner.bloodstr.add_reagent(reagent, rand(1, 3))

