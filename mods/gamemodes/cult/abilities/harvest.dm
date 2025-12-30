/decl/ability/cult/construct/harvest
	name                    = "Harvest"
	desc                    = "Back to where I come from, and you're coming with me."
	ability_cooldown_time   = 20 SECONDS
	ability_use_channel     = 10 SECONDS
	overlay_icon_state      = "rune_teleport"
	overlay_lifespan        = 0
	ability_icon_state      = "const_harvest"
	prepare_message_3p_str  = "Space around $USER$ begins to bubble and decay as a terrible vista begins to intrude..."
	prepare_message_1p_str  = "You bore through space and time, seeking the essence of the Geometer of Blood."
	fail_cast_1p_str        = "Reality reasserts itself, preventing your return to Nar-Sie."
	target_selector         = /decl/ability_targeting/living_mob

/decl/ability/cult/construct/harvest/can_use_ability(mob/user, list/metadata, silent)
	. = ..()
	if(.)
		var/destination
		for(var/obj/effect/narsie/N in global.narsie_list)
			destination = N.loc
			break
		if(!destination)
			to_chat(user, SPAN_DANGER("You cannot sense the Geometer of Blood!"))
			return FALSE

/decl/ability/cult/construct/harvest/apply_effect(mob/user, atom/hit_target, list/metadata, obj/item/projectile/ability/projectile)
	..()
	var/destination = null
	for(var/obj/effect/narsie/N in global.narsie_list)
		destination = N.loc
		break
	if(!destination)
		to_chat(user, SPAN_DANGER("You cannot sense the Geometer of Blood!"))
		return
	if(ismob(hit_target) && hit_target != user)
		var/mob/living/victim = hit_target
		to_chat(user, SPAN_SINISTER("You warp back to Nar-Sie along with your prey."))
		to_chat(victim, SPAN_SINISTER("You are wrenched through time and space and thrown into chaos!"))
		victim.dropInto(destination)
	else
		to_chat(user, SPAN_SINISTER("You warp back to Nar-Sie."))
	user.dropInto(destination)
