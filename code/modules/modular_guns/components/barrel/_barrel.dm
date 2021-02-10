/obj/item/firearm_component/barrel
	name = "barrel"
	desc = "A long tube forming the barrel of a firearm."
	icon_state = "world-barrel"
	firearm_component_category = FIREARM_COMPONENT_BARREL
	accuracy_power = 5

	var/silenced =     0
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

/obj/item/firearm_component/barrel/proc/get_relative_projectile_size(var/obj/item/projectile/projectile)
	return 1

/obj/item/firearm_component/barrel/proc/get_caliber()
	return

/obj/item/firearm_component/barrel/proc/set_caliber(var/_caliber)
	return

/obj/item/firearm_component/barrel/apply_additional_firearm_tweaks(var/obj/item/gun/firearm)
	if(scope_zoom)
		firearm |= /obj/item/gun/proc/scope
