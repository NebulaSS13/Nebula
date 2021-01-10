/datum/ailment/fault/leaky
	name = "leaky prosthetic"
	var/global/list/chemicals = list(
		/decl/material/liquid/enzyme,
		/decl/material/liquid/frostoil,
		/decl/material/liquid/nanitefluid
	)

/datum/ailment/fault/leaky/on_ailment_event()
	var/reagent = pick(chemicals)
	organ.owner.bloodstr.add_reagent(reagent, rand(1, 3))

