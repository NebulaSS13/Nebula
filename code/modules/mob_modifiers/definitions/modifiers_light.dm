/datum/mob_modifier/object/light
	var/light_range = 6
	var/light_power = 6
	var/light_color = COLOR_BEIGE

/decl/mob_modifier/light
	name                 = "Light Aura"
	desc                 = "You are emitting a gentle radiance."
	hud_icon_state       = "light"
	on_add_message_1p    = SPAN_NOTICE("A gentle radiance emanates from your body.")
	on_end_message_1p    = SPAN_NOTICE("The light spilling from your body fades.")
	modifier_type        = /datum/mob_modifier/object/light
	can_be_admin_granted = TRUE

/datum/mob_modifier/object/light/on_modifier_added(skip_update)
	. = ..()
	if(istype(object) && (light_range || light_power || light_color))
		object.set_light(light_range, light_power, light_color)

/decl/mob_modifier/light/radiant
	name               = "Radiant Aura"
	desc               = "You are guarded from laser weapons by a radiant aura."
	mob_overlay_icon   = 'icons/effects/effects.dmi'
	mob_overlay_state  = "fire_goon"
	on_add_message_1p  = SPAN_NOTICE("A bubble of light appears around you, exuding protection and warmth.")
	on_end_message_1p  = SPAN_DANGER("Your protective aura dissipates, leaving you feeling cold and unsafe.")
	modifier_type      = /datum/mob_modifier/object/light

/datum/mob_modifier/object/light/radiant
	light_color = "#e09d37"

/decl/mob_modifier/light/radiant/check_modifiers_block_attack(mob/living/_owner, list/modifiers, attack_type, atom/movable/attacker, additional_data)
	if(attack_type != MM_ATTACK_TYPE_PROJECTILE)
		return ..()
	var/obj/item/projectile/projectile = attacker
	if(istype(projectile) && (projectile.damage_flags() & DAM_LASER))
		_owner.visible_message(SPAN_WARNING("\The [projectile] refracts, bending into \the [_owner]'s radiance."))
		return (MM_ATTACK_RESULT_BLOCKED|MM_ATTACK_RESULT_DEFLECTED)
	return MM_ATTACK_RESULT_NONE
