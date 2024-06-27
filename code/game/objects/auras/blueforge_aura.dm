/obj/aura/blueforge_aura
	name = "Blueforge Aura"
	icon = 'icons/mob/human_races/species/blueforged/eyes.dmi'
	icon_state = "eyes"
	layer = MOB_LAYER

/obj/aura/blueforge_aura/life_tick()
	user.heal_damage(TOX, 10)
	return 0

/obj/aura/blueforge_aura/bullet_act(var/obj/item/projectile/P)
	if(P.atom_damage_type == BURN)
		P.damage *=2
	else if(P.agony || P.stun)
		return AURA_FALSE
	return 0