/proc/iswizard(var/mob/player)
	var/decl/special_role/wizard = GET_DECL(/decl/special_role/wizard)
	if(player.mind && (player.mind in wizard.current_antagonists))
		return TRUE
	return FALSE

/decl/special_role/wizard
	name = "Wizard"
	name_plural = "Wizards"
	landmark_id = "wizard"
	welcome_text = "You will find a list of available spells in your spell book. Choose your magic arsenal carefully.<br>In your pockets you will find a teleport scroll. Use it as needed."
	flags = ANTAG_OVERRIDE_JOB | ANTAG_OVERRIDE_MOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_CHOOSE_NAME | ANTAG_VOTABLE | ANTAG_SET_APPEARANCE
	antaghud_indicator = "hudwizard"
	default_access = list(access_wizard)
	hard_cap = 1
	hard_cap_round = 3
	initial_spawn_req = 1
	initial_spawn_target = 1
	min_player_age = 18

	faction = "wizard"
	base_to_load = "Wizard Base"

/decl/special_role/wizard/create_objectives(var/datum/mind/wizard)

	if(!..())
		return

	var/kill
	var/escape
	var/steal
	var/hijack

	switch(rand(1,100))
		if(1 to 30)
			escape = 1
			kill = 1
		if(31 to 60)
			escape = 1
			steal = 1
		if(61 to 99)
			kill = 1
			steal = 1
		else
			hijack = 1

	if(kill)
		var/datum/objective/assassinate/kill_objective = new
		kill_objective.owner = wizard
		kill_objective.find_target()
		wizard.objectives |= kill_objective
	if(steal)
		var/datum/objective/steal/steal_objective = new
		steal_objective.owner = wizard
		steal_objective.find_target()
		wizard.objectives |= steal_objective
	if(escape)
		var/datum/objective/survive/survive_objective = new
		survive_objective.owner = wizard
		wizard.objectives |= survive_objective
	if(hijack)
		var/datum/objective/hijack/hijack_objective = new
		hijack_objective.owner = wizard
		wizard.objectives |= hijack_objective
	return

/decl/special_role/wizard/update_antag_mob(var/datum/mind/wizard)
	..()
	wizard.StoreMemory("<B>Remember:</B> do not forget to prepare your spells.", /decl/memory_options/system)
	wizard.current.real_name = "[pick(global.wizard_first)] [pick(global.wizard_second)]"
	wizard.current.SetName(wizard.current.real_name)

/decl/special_role/wizard/equip_role(var/mob/living/human/wizard_mob)
	default_outfit = pick(decls_repository.get_decl_paths_of_subtype(/decl/outfit/wizard))
	. = ..()

/decl/special_role/wizard/print_player_summary()
	..()
/*	for(var/p in current_antagonists)
		var/datum/mind/player = p
		var/text = "<b>[player.name]'s spells were:</b>"
		if(!player.learned_spells || !player.learned_spells.len)
			text += "<br>None!"
		else
			for(var/s in player.learned_spells)
				var/spell/spell = s
				text += "<br><b>[spell.name]</b> - "
				text += "Speed: [spell.spell_levels["speed"]] Power: [spell.spell_levels["power"]]"
		text += "<br>"
		to_world(text)
*/

/obj/item/proc/is_wizard_garb()
	return FALSE

/obj/item/clothing/is_wizard_garb()
	return wizard_garb

/*Checks if the wizard is wearing the proper attire.
Made a proc so this is not repeated 14 (or more) times.*/
/mob/proc/wearing_wizard_garb()
	return "Silly creature, you can't wear clothes. Only clothed wizards can cast this spell."

/mob/living/wearing_wizard_garb()

	var/decl/species/species = get_species()
	if(!species || !istype(species.species_hud))
		return ..()

	var/list/static/slot_check = list(
		slot_wear_suit_str = "robe",
		slot_shoes_str     = "sandals",
		slot_head_str      = "hat"
	)
	for(var/slot in slot_check)
		var/obj/item/thing = get_equipped_item(slot)
		if(!istype(thing) || !thing.is_wizard_garb())
			return "You don't feel strong enough without your [slot_check[slot]]..."
