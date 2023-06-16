/datum/mind
	var/list/learned_spells

/mob/Stat()
	. = ..()
	if(. && istype(hud_used))
		hud_used.refresh_stat_panel()

/proc/restore_spells(var/mob/H)
	if(H.mind && H.mind.learned_spells)
		var/list/spells = list()
		for(var/spell/spell_to_remove in H.mind.learned_spells) //remove all the spells from other people.
			if(ismob(spell_to_remove.holder))
				var/mob/M = spell_to_remove.holder
				spells += spell_to_remove
				M.remove_spell(spell_to_remove)

		for(var/spell/spell_to_add in spells)
			H.add_spell(spell_to_add)
	var/obj/screen/ability_master/ability_master = H.get_hud_element(/decl/hud_element/ability_master)
	if(ability_master)
		ability_master.update_abilities(0,H)

/mob/proc/add_spell(var/spell/spell_to_add, var/spell_base = "wiz_spell_ready")
	var/obj/screen/ability_master/ability_master = get_hud_element(/decl/hud_element/ability_master)
	if(!ability_master)
		return
	spell_to_add.holder = src
	if(mind)
		if(!mind.learned_spells)
			mind.learned_spells = list()
		mind.learned_spells |= spell_to_add
	ability_master.add_spell(spell_to_add, spell_base)
	return 1

/mob/proc/remove_spell(var/spell/spell_to_remove)
	if(!spell_to_remove || !istype(spell_to_remove))
		return

	if(mind)
		mind.learned_spells -= spell_to_remove
	var/obj/screen/ability_master/ability_master = get_hud_element(/decl/hud_element/ability_master)
	if (ability_master)
		ability_master.remove_ability(ability_master.get_ability_by_spell(spell_to_remove))
	return 1

/mob/proc/silence_spells(var/amount = 0)
	if(amount < 0)
		return
	var/obj/screen/ability_master/ability_master = get_hud_element(/decl/hud_element/ability_master)
	if(ability_master)
		ability_master.silence_spells(amount)
