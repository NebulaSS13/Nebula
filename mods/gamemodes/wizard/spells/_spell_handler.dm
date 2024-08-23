/obj/screen/ability/category/spells
	ability_category_tag = "wizard_spells"

/datum/ability_handler/spells
	ability_category_tag = "wizard_spells"
	category_toggle_type = /obj/screen/ability/category/spells

/datum/ability_handler/spells/copy_abilities_to(mob/living/donor)
//	var/datum/ability_handler/spells/spells = donor.get_ability_handler(/datum/ability_handler/spells, create_if_missing = TRUE)
/*
	for (var/spell/S in M.mind.learned_spells)
		new_mob.add_ability(S.type, donor.get_ability_metadata(S.type, create_if_missing = FALSE))
*/

/obj/screen/ability/spell_debugger/handle_click(mob/user, params)
	to_chat(user, "[name] click!")

/obj/screen/ability/spell_debugger/one
	name = "debug spell one"

/obj/screen/ability/spell_debugger/two
	name = "debug spell two"

/obj/screen/ability/spell_debugger/three
	name = "debug spell three"

/obj/screen/ability/spell_debugger/four
	name = "debug spell four"

/obj/screen/ability/spell_debugger/five
	name = "debug spell five"

/obj/screen/ability/spell_debugger/six
	name = "debug spell six"

/obj/screen/ability/spell_debugger/seven
	name = "debug spell seven"

/obj/screen/ability/spell_debugger/eight
	name = "debug spell eight"

/client/verb/debug_wizard_handler()
	set name = "Debug Wizard Handler"
	set category = "Debug"
	set src = usr
	usr.add_ability_handler(/datum/ability_handler/spells)
