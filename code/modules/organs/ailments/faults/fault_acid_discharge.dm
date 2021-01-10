/datum/ailment/fault/acid
	name = "acidic discharge"

/datum/ailment/fault/acid/on_ailment_event()
	organ.owner.custom_pain("A burning sensation spreads through your [organ].", 5, affecting = organ.owner)
	organ.owner.bloodstr.add_reagent(/decl/material/liquid/acid, rand(1, 3))