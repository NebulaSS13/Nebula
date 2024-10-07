/spell/targeted/projectile/dumbfire/stuncuff
	name = "Stun Cuff"
	desc = "This spell fires out a small curse that stuns and cuffs the target."
	feedback = "SC"
	proj_type = /obj/item/projectile/spell_projectile/stuncuff

	charge_type = Sp_CHARGES
	charge_max = 6
	charge_counter = 6
	requires_wizard_garb = FALSE
	invocation = "Fu'Reai Diakan!"
	invocation_type = SpI_SHOUT
	range = 20

	level_max = list(Sp_TOTAL = 0, Sp_SPEED = 0, Sp_POWER = 0)

	duration = 20
	projectile_step_delay = 1

	amt_stunned = 6

	ability_icon_state = "wiz_cuff"
	cast_sound = 'sound/magic/wandodeath.ogg'

/spell/targeted/projectile/dumbfire/stuncuff/prox_cast(var/list/targets, spell_holder)
	for(var/mob/living/M in targets)
		if(ishuman(M))
			var/mob/living/human/H = M
			var/obj/item/handcuffs/wizard/cuffs = new()
			H.equip_to_slot(cuffs, slot_handcuffed_str)
			H.visible_message("Beams of light form around \the [H]'s hands!")
		apply_spell_damage(M)


/obj/item/handcuffs/wizard
	name = "beams of light"
	desc = "Undescribable and unpenetrable. Or so they say."

	breakouttime = 300 //30 seconds

/obj/item/handcuffs/wizard/dropped(var/mob/user)
	..()
	qdel(src)

/obj/item/projectile/spell_projectile/stuncuff
	name = "stuncuff"
	icon_state = "spell"