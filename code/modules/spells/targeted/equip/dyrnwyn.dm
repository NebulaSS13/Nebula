/spell/targeted/equip_item/dyrnwyn
	name = "Summon Dyrnwyn"
	desc = "Summons the legendary sword of Rhydderch Hael, said to draw in flame when held by a worthy man."
	feedback = "SD"
	charge_type = Sp_HOLDVAR
	holder_var_type = "fireloss"
	holder_var_amount = 10
	school = "conjuration"
	invocation = "Anrhydeddu Fi!"
	invocation_type = SpI_SHOUT
	spell_flags = INCLUDEUSER
	range = -1
	level_max = list(Sp_TOTAL = 1, Sp_SPEED = 0, Sp_POWER = 1)
	duration = 300 //30 seconds
	max_targets = 1
	equipped_summons = list("active hand" = /obj/item/sword)
	delete_old = 0
	var/material = /decl/material/solid/metal/gold

	hud_state = "gen_immolate"


/spell/targeted/equip_item/dyrnwyn/summon_item(var/new_type)
	var/obj/item/W = new new_type(null,material)
	W.SetName("\improper Dyrnwyn")
	W.damtype = BURN
	W.hitsound = 'sound/items/welder2.ogg'
	LAZYSET(W.slowdown_per_slot, BP_L_HAND, 1)
	LAZYSET(W.slowdown_per_slot, BP_R_HAND, 1)
	return W

/spell/targeted/equip_item/dyrnwyn/empower_spell()
	if(!..())
		return 0

	material = /decl/material/solid/metal/silver
	return "Dyrnwyn has been made pure: it is now made of silver."

/spell/targeted/equip_item/dyrnwyn/tower
	charge_max = 1