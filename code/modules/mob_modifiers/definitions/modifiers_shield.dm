/decl/mob_modifier/shield
	name                 = "Energy Shield"
	desc                 = "You are protected from incoming projectiles."
	hud_icon_state       = "shield"
	on_add_message_1p    = SPAN_NOTICE("You feel your body prickle as your shield comes online.")
	on_end_message_1p    = SPAN_WARNING("Your shield goes offline!")
	can_be_admin_granted = TRUE

/decl/mob_modifier/shield/on_modifier_datum_added(mob/living/_owner, decl/mob_modifier/modifier)
	. = ..()
	if(. && _owner)
		playsound(get_turf(_owner), 'sound/weapons/flash.ogg', 35, 1)

/decl/mob_modifier/shield/on_modifier_datum_removed(mob/living/_owner, decl/mob_modifier/modifier)
	. = ..()
	if(. && _owner)
		playsound(get_turf(_owner), 'sound/mecha/internaldmgalarm.ogg', 25,1)

/decl/mob_modifier/shield/check_modifiers_block_attack(mob/living/_owner, list/modifiers, attack_type, atom/movable/attacker, additional_data)
	if(attack_type != MM_ATTACK_TYPE_PROJECTILE)
		return ..()
	var/obj/item/projectile/projectile = attacker
	if(istype(projectile))
		_owner.visible_message(SPAN_WARNING("\The [_owner]'s [src] flashes before \the [projectile] can hit them!"))
		new /obj/effect/temporary(get_turf(_owner), 2 SECONDS, 'icons/obj/machines/shielding.dmi', "shield_impact")
		playsound(_owner,'sound/effects/basscannon.ogg', 35, 1)
		return (MM_ATTACK_RESULT_BLOCKED|MM_ATTACK_RESULT_DEFLECTED)
	return MM_ATTACK_RESULT_NONE

/decl/mob_modifier/shield/device
	name                 = "Personal Shield"
	desc                 = "You are protected from incoming projectiles by a personal shielding device - at least until it runs out of charges."
	can_be_admin_granted = FALSE // Needs an item.

/decl/mob_modifier/shield/device/check_modifiers_block_attack(mob/living/_owner, list/modifiers, attack_type, atom/movable/attacker, additional_data)
	var/obj/item/projectile/projectile = attacker
	if(!istype(projectile) || attack_type != MM_ATTACK_TYPE_PROJECTILE)
		return ..()
	var/found_shield = FALSE
	for(var/datum/mob_modifier/modifier in modifiers)
		var/obj/item/personal_shield/shield = modifier.source?.resolve()
		if(istype(shield) && shield.expend_charge())
			found_shield = TRUE
			break
	return found_shield ? ..() : MM_ATTACK_RESULT_NONE
