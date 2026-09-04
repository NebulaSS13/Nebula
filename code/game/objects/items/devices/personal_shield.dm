/obj/item/personal_shield
	name = "personal shield"
	desc = "Truly a lifesaver: this device protects its user from being hit by objects moving very, very fast, though only for a few shots."
	icon = 'icons/obj/items/weapon/batterer.dmi'
	icon_state = ICON_STATE_WORLD
	material = /decl/material/solid/organic/plastic
	matter = list(
		/decl/material/solid/metal/gold     = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/silicon        = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/titanium = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/metal/uranium  = MATTER_AMOUNT_TRACE,
	)
	var/uses = 5
	var/shield_effect_type = /decl/mob_modifier/shield/device

/obj/item/personal_shield/attack_self(var/mob/user)
	if(loc == user && isliving(user))
		var/mob/living/holder = user
		if(holder.has_mob_modifier(shield_effect_type, source = src))
			holder.remove_mob_modifier(shield_effect_type, source = src)
		else if(uses && shield_effect_type)
			holder.add_mob_modifier(shield_effect_type, source = src)
		else
			return ..()
		return TRUE
	return ..()

/obj/item/personal_shield/Move()
	var/mob/living/holder = loc
	. = ..()
	if(. && istype(holder) && holder.has_mob_modifier(shield_effect_type, source = src))
		holder.remove_mob_modifier(shield_effect_type, source = src)

/obj/item/personal_shield/forceMove()
	var/mob/living/holder = loc
	. = ..()
	if(. && istype(holder) && holder.has_mob_modifier(shield_effect_type, source = src))
		holder.remove_mob_modifier(shield_effect_type, source = src)

/obj/item/personal_shield/proc/expend_charge()
	if(uses <= 0)
		return FALSE
	uses--
	if(uses <= 0 && ismob(loc))
		var/mob/living/holder = loc
		if(istype(holder) && holder.has_mob_modifier(shield_effect_type, source = src))
			holder.remove_mob_modifier(shield_effect_type, source = src)
			to_chat(holder, SPAN_DANGER("\The [src] begins to spark as it breaks!"))
		update_icon()
	return TRUE

/obj/item/personal_shield/on_update_icon()
	. = ..()
	if(uses)
		add_overlay("[icon_state]-on")