/spell/targeted/equip_item/burning_hand
	name = "Burning Hand"
	desc = "Bathes your hand in fire, giving you all the perks and disadvantages that brings."
	feedback = "BH"
	school = "conjuration"
	invocation = "Horila Kiha!"
	invocation_type = SpI_SHOUT
	spell_flags = INCLUDEUSER
	range = -1
	duration = 0
	max_targets = 1
	equipped_summons = list("active hand" = /obj/item/burning_hands)
	delete_old = 0
	hud_state = "gen_burnhand"

/obj/item/burning_hands
	name = "Burning Hand"
	icon = 'icons/mob/screen/grabs.dmi'
	icon_state = "grabbed+1"
	_base_attack_force = 10
	atom_damage_type =  BURN
	simulated = 0
	max_health = ITEM_HEALTH_NO_DAMAGE
	obj_flags = OBJ_FLAG_NO_STORAGE
	var/burn_power = 0
	var/burn_timer

/obj/item/burning_hands/on_picked_up(var/mob/user)
	burn_power = 0
	burn_timer = world.time + 10 SECONDS
	START_PROCESSING(SSobj,src)

/obj/item/burning_hands/get_heat()
	return 1000

/obj/item/burning_hands/isflamesource()
	return TRUE

/obj/item/burning_hands/Process()
	if(world.time < burn_timer)
		return
	burn_timer = world.time + 5 SECONDS
	burn_power++
	set_base_attack_force(get_base_attack_force()+2)
	if(!ishuman(src.loc))
		qdel(src)
		return
	var/mob/living/human/user = src.loc
	var/obj/item/organ/external/hand
	if(src == user.get_equipped_item(BP_L_HAND))
		hand = GET_INTERNAL_ORGAN(user, BP_L_HAND)
	else if(src == user.get_equipped_item(BP_R_HAND))
		hand = GET_INTERNAL_ORGAN(user, BP_R_HAND)
	if(hand)
		hand.take_external_damage(burn = 2 * burn_power)
	if(burn_power > 5)
		user.fire_stacks += 15
		user.IgniteMob()
		user.visible_message("<span class='danger'>\The [user] bursts into flames!</span>")
		user.drop_from_inventory(src)
	else
		if(burn_power == 5)
			to_chat(user, "<span class='danger'>You begin to lose control of \the [src]'s flames as they rapidly move up your arm...</span>")
		else
			to_chat(user, "<span class='warning'>You feel \the [src] grow hotter and hotter!</span>")

/obj/item/burning_hands/dropped()
	..()
	qdel(src)