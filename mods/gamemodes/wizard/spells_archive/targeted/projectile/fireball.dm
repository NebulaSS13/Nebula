/spell/targeted/projectile/dumbfire/fireball
	name = "Fireball"
	desc = "A classic spell, grants you the ability to throw an exploding ball of flame in any direction. Does not require wizard garb."
	feedback = "FB"
	proj_type = /obj/item/projectile/spell_projectile/fireball

	school = "conjuration"
	charge_max = 10 SECONDS
	requires_wizard_garb = FALSE
	invocation = "Oni-Soma!"
	invocation_type = SpI_SHOUT
	range = 20

	level_max = list(Sp_TOTAL = 5, Sp_SPEED = 0, Sp_POWER = 5)

	duration = 20
	projectile_step_delay = 1

	amt_dam_brute = 20
	amt_dam_fire = 25

	var/ex_severe = -1
	var/ex_heavy = 1
	var/ex_light = 2
	var/ex_flash = 5

	ability_icon_state = "wiz_fireball"
	cast_sound = 'sound/magic/fireball.ogg'

/spell/targeted/projectile/dumbfire/fireball/prox_cast(var/list/targets, spell_holder)
	for(var/mob/living/M in targets)
		apply_spell_damage(M)
	explosion(get_turf(spell_holder), ex_severe, ex_heavy, ex_light, ex_flash)

/spell/targeted/projectile/dumbfire/fireball/empower_spell()
	if(!..())
		return 0

	if(spell_levels[Sp_POWER]%2 == 1)
		ex_severe++
	ex_heavy++
	ex_light++
	ex_flash++

	return "The spell [src] now has a larger explosion."

//PROJECTILE

/obj/item/projectile/spell_projectile/fireball
	name = "fireball"
	icon_state = "fireball"

/spell/targeted/projectile/dumbfire/fireball/firebolt
	name = "Firebolt"
	desc = "A quick-casted fireball. Burns the user, and their enemies, but is much faster to shoot."
	feedback = "FO"
	charge_type = Sp_HOLDVAR
	invocation = "Ignus!"
	holder_var_type = "fireloss"
	holder_var_amount = 10
	amt_dam_brute = 10
	amt_dam_fire = 15
	ex_heavy = -1
	ex_light = 1
	ex_flash = 3
	ability_icon_state = "firebolt"