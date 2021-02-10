/obj/item/firearm_component/barrel
	name = "barrel"
	desc = "A long tube forming the barrel of a firearm."
	icon_state = "world-barrel"
	firearm_component_category = FIREARM_COMPONENT_BARREL
	accuracy_power = 5
	is_underlay = TRUE

	var/silenced = SILENCER_INVALID
	var/fire_sound = 'sound/weapons/gunshot/gunshot.ogg'
	var/fire_sound_text = "gunshot"
	var/scoped_accuracy = null  //accuracy used when zoomed in a scope
	var/scope_zoom = 0
	var/list/burst_accuracy = list(0) //allows for different accuracies for each shot in a burst. Applied on top of accuracy
	var/list/dispersion = list(0)

/obj/item/firearm_component/barrel/Initialize()
	. = ..()
	if(isnull(scoped_accuracy))
		scoped_accuracy = accuracy

/obj/item/firearm_component/barrel/holder_attackby(obj/item/W, mob/user)
	if(silenced != SILENCER_INVALID && !silenced && istype(W, /obj/item/silencer) && user.unEquip(W, src))
		to_chat(user, SPAN_NOTICE("You screw \the [W] onto \the [holder || src]."))
		silenced = W
		w_class = max(w_class, ITEM_SIZE_NORMAL)
		if(holder)
			holder.update_from_components()
		update_icon()
		return TRUE
	. = ..()

/obj/item/firearm_component/barrel/holder_attack_self(mob/user)
	if(istype(silenced, /obj/item))
		var/obj/item/silencer = silenced
		to_chat(user, SPAN_NOTICE("You unscrew \the [silencer] from \the [src]."))
		silencer.dropInto(loc)
		user.put_in_hands(silencer)
		silenced = null
		w_class = initial(w_class)
		if(holder)
			holder.update_from_components()
		return TRUE
	. = ..()

/obj/item/firearm_component/barrel/proc/get_relative_projectile_size(var/obj/item/projectile/projectile)
	return 1

/obj/item/firearm_component/barrel/proc/get_caliber()
	return

/obj/item/firearm_component/barrel/proc/set_caliber(var/_caliber)
	return

/obj/item/firearm_component/barrel/apply_additional_firearm_tweaks(var/obj/item/gun/firearm)
	if(scope_zoom)
		firearm |= /obj/item/gun/proc/scope
