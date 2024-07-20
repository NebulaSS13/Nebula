//////////////////////Scrying orb//////////////////////

/obj/item/scrying
	name = "scrying orb"
	desc = "An incandescent orb of otherworldly energy, staring into it gives you vision beyond mortal means."
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "bluespace"
	throw_speed = 3
	throw_range = 7
	atom_damage_type =  BURN
	hitsound = 'sound/magic/forcewall.ogg'
	max_health = ITEM_HEALTH_NO_DAMAGE
	_base_attack_force = 10

/obj/item/scrying/attack_self(mob/user)
	var/decl/special_role/wizard/wizards = GET_DECL(/decl/special_role/wizard)
	if((user.mind && !wizards.is_antagonist(user.mind)))
		to_chat(user, "<span class='warning'>You stare into the orb and see nothing but your own reflection.</span>")
		return

	to_chat(user, "<span class='info'>You can see... everything!</span>") // This never actually happens.
	visible_message("<span class='danger'>[user] stares into [src], their eyes glazing over.</span>")

	user.teleop = user.ghostize()
	announce_ghost_joinleave(user.teleop, 1, "You feel that they used a powerful artifact to [pick("invade","disturb","disrupt","infest","taint","spoil","blight")] this place with their presence.")
	return



/////////////////////////Cursed Dice///////////////////////////
/obj/item/dice/d20/cursed
	desc = "A dice with twenty sides said to have an ill effect on those that are unlucky..."

/obj/item/dice/d20/cursed/attack_self(mob/user)
	..()
	if(isliving(user))
		var/mob/living/M = user
		if(icon_state == "[name][sides]")
			M.heal_damage(BRUTE, 30)
		else if(icon_state == "[name]1")
			M.take_damage(30)
