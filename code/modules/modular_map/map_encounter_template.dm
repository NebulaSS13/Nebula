/decl/mm_encounter_template
	var/name = "Empty Room"
	abstract_type = /decl/mm_encounter_template

/decl/mm_encounter_template/proc/can_be_placed(datum/mm_encounter/previous_encounter, list/cells)
	return FALSE

/decl/mm_encounter_template/monster_closet
	name = "Monster Closet"
