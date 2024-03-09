/datum/ailment/fault/leaky
	name = "leaky prosthetic"
	manual_diagnosis_string = "$USER_THEIR$ $ORGAN$ is leaking some kind of chemical."
	var/static/list/chemicals = list(
		/decl/material/liquid/enzyme,
		/decl/material/liquid/frostoil,
		/decl/material/liquid/nanitefluid
	)

/datum/ailment/fault/leaky/on_ailment_event()
	var/reagent = pick(chemicals)
	var/datum/reagents/bloodstr_reagents = organ.owner.get_injected_reagents()
	if(bloodstr_reagents)
		bloodstr_reagents.add_reagent(reagent, rand(1, 3))
