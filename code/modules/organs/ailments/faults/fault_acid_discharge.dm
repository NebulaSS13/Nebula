/datum/ailment/fault/acid/on_malfunction()
	organ.owner.custom_pain("A burning sensation spreads through your [organ.owner].", 5, affecting = organ.owner)
	organ.owner.bloodstr.add_reagent(/decl/material/liquid/acid, rand(1, 3))