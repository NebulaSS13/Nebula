//Subspace Jumper

/obj/item/jumper
	name        = "subspace jumper"
	desc        = "An <b>extremely</b> unsafe gadget that enables user to traverse through matter of the subspace."

	icon        = 'icons/obj/power.dmi'
	icon_state  = "portgen0legacy"

	origin_tech = "{'magnets':3,'wormholes':3}"

/obj/item/jumper/attack_self(var/mob/user)
	subspace_shift(user)

//Reactive Armor

/obj/item/clothing/suit/armor/reactive/handle_shield(var/mob/living/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(prob(60))
		user.visible_message("<span class='danger'>The reactive teleport system flings [user] clear of the attack!</span>")
		timed_shift(user,2)
		return PROJECTILE_FORCE_MISS
	return 0