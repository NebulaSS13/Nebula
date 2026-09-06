/datum/salvage_repair_requirement
	var/repair_type
	var/repair_material
	var/repair_amount

/datum/salvage_repair_requirement/New(_type, _mat, _amt)
	repair_amount   = _amt
	repair_material = _mat
	repair_type     = _type
