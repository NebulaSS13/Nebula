//This handy augment protects you to a degree, keeping it online after critical damage however is bad
/decl/mob_modifier/nanoswarm
	name              = "Defensive Nanoswarm"
	desc              = "You are surrounded by nanomachines that harden in response to projectiles."
	hud_icon_state    = "nanomachines"
	on_add_message_1p = SPAN_NOTICE("Your skin tingles as the nanites spread over your body.")
	on_end_message_1p = SPAN_WARNING("The nanites dissolve!")

/decl/mob_modifier/nanoswarm/on_modifier_datum_added(mob/living/_owner, decl/mob_modifier/modifier)
	. = ..()
	playsound(_owner.loc,'sound/weapons/flash.ogg',35,1)

/decl/mob_modifier/nanoswarm/check_modifiers_block_attack(mob/living/_owner, list/modifiers, attack_type, atom/movable/attacker, additional_data)
	if(attack_type != MM_ATTACK_TYPE_PROJECTILE)
		return ..()

	var/obj/item/organ/internal/augment/active/nanounit/unit
	for(var/datum/mob_modifier/modifier in modifiers)
		var/obj/item/organ/internal/augment/active/nanounit/implant = modifier.source?.resolve()
		if(istype(implant) && implant.active && implant.charges >= 0) // active with 0 charges means it's about to critically fail.
			unit = implant
			break

	if(!istype(unit))
		return ..()

	_owner.visible_message(SPAN_WARNING("The nanomachines harden as a response to physical trauma!"))
	playsound(_owner, 'sound/effects/basscannon.ogg',35,1)
	unit.charges--
	if(unit.charges <= 0)
		to_chat(_owner, SPAN_DANGER("Warning: Critical damage threshold passed. Shut down unit to avoid further damage."))
	else
		unit.catastrophic_failure()
	return MM_ATTACK_RESULT_BLOCKED|MM_ATTACK_RESULT_DEFLECTED
