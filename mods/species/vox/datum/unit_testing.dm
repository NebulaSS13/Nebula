#ifndef IMMUNE
#define IMMUNE 3
#endif

/datum/unit_test/mob_damage/vox
	name = "MOB: Vox damage check template"
	template = /datum/unit_test/mob_damage/vox
	mob_type = /mob/living/carbon/human/vox

/datum/unit_test/mob_damage/vox/brute
	name = "MOB: Vox Brute Damage Check"
	damagetype = BRUTE

/datum/unit_test/mob_damage/vox/fire
	name = "MOB: Vox Fire Damage Check"
	damagetype = BURN

/datum/unit_test/mob_damage/vox/tox
	name = "MOB: Vox Toxins Damage Check"
	damagetype = TOX

/datum/unit_test/mob_damage/vox/oxy
	name = "MOB: Vox Oxygen Damage Check"
	damagetype = OXY

/datum/unit_test/mob_damage/vox/clone
	name = "MOB: Vox Clone Damage Check"
	damagetype = CLONE
	expected_vulnerability = IMMUNE

/datum/unit_test/mob_damage/vox/halloss
	name = "MOB: Vox Halloss Damage Check"
	damagetype = PAIN