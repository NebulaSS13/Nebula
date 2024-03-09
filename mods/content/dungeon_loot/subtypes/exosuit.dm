// Subtype for mecha and mecha accessories. These might not always be on the surface.
/obj/structure/loot_pile/exosuit
	name = "pod wreckage"
	desc = "The ruins of some unfortunate pod. Perhaps something is salvageable."
	icon_state = "wreck"
	icon = 'icons/mecha/mech_part_items.dmi'
	density = TRUE
	anchored = FALSE // In case a dead mecha-mob dies in a bad spot.
	chance_uncommon = 20
	chance_rare = 10
	loot_depletion = TRUE
	loot_left = 9
	abstract_type = /obj/structure/loot_pile/exosuit

// Subtypes below.
/obj/structure/loot_pile/exosuit/powerloader
	name = "powerloader exosuit wreckage"
	desc = "The ruins of some unfortunate powerloader exosuit. Perhaps something is salvageable."

/obj/structure/loot_pile/exosuit/powerloader/get_common_loot()
	var/static/list/common_loot = list(
		/obj/item/mech_component/manipulators/powerloader/painted,
		/obj/item/mech_component/propulsion/powerloader/painted
	)
	return common_loot

/obj/structure/loot_pile/exosuit/powerloader/get_uncommon_loot()
	var/static/list/uncommon_loot = list(
		/obj/item/mech_equipment/drill/steel,
		/obj/item/mech_equipment/clamp
	)
	return uncommon_loot

/obj/structure/loot_pile/exosuit/powerloader/get_rare_loot()
	var/static/list/rare_loot = list(
		/obj/item/mech_component/sensors/powerloader/painted,
		/obj/item/mech_component/chassis/powerloader/painted
	)
	return rare_loot

/obj/structure/loot_pile/exosuit/firefighter
	name = "firefighter exosuit wreckage"
	desc = "The ruins of some unfortunate firefighter exosuit. Perhaps something is salvageable."

/obj/structure/loot_pile/exosuit/firefighter/get_common_loot()
	var/static/list/common_loot = list(
		/obj/item/mech_component/manipulators/powerloader/painted,
		/obj/item/mech_component/propulsion/powerloader/painted,
		/obj/item/mech_component/chassis/heavy
	)
	return common_loot

/obj/structure/loot_pile/exosuit/firefighter/get_uncommon_loot()
	var/static/list/uncommon_loot = list(
		/obj/item/mech_equipment/drill/steel,
		/obj/item/mech_equipment/mounted_system/extinguisher
	)
	return uncommon_loot

/obj/structure/loot_pile/exosuit/firefighter/get_rare_loot()
	var/static/list/rare_loot = list(
		/obj/item/mech_component/sensors/powerloader/painted
	)
	return rare_loot

/obj/structure/loot_pile/exosuit/combat
	name = "combat exosuit wreckage"
	desc = "The ruins of some unfortunate combat exosuit. Perhaps something is salvageable."

/obj/structure/loot_pile/exosuit/combat/get_common_loot()
	var/static/list/common_loot = list(
		/obj/item/mech_component/manipulators/combat/painted,
		/obj/item/mech_component/propulsion/combat/painted,
		/obj/item/mech_equipment/flash,
		/obj/item/mech_equipment/light
	)
	return common_loot

/obj/structure/loot_pile/exosuit/combat/get_uncommon_loot()
	var/static/list/uncommon_loot = list(
		/obj/item/mech_component/chassis/combat/painted,
		/obj/item/mech_equipment/mounted_system/taser
	)
	return uncommon_loot

/obj/structure/loot_pile/exosuit/combat/get_rare_loot()
	var/static/list/rare_loot = list(
		/obj/item/mech_component/sensors/combat/painted,
		/obj/item/mech_equipment/mounted_system/projectile/assault_rifle
	)
	return rare_loot

/obj/structure/loot_pile/exosuit/explorer
	name = "exploration exosuit wreckage"
	desc = "The ruins of some unfortunate exploration exosuit. Perhaps something is salvagable."

/obj/structure/loot_pile/exosuit/explorer/get_common_loot()
	var/static/list/common_loot = list(
		/obj/item/mech_component/manipulators/powerloader/exploration,
		/obj/item/mech_component/chassis/pod/exploration,
		/obj/item/mech_equipment/light
	)
	return common_loot

/obj/structure/loot_pile/exosuit/explorer/get_uncommon_loot()
	var/static/list/uncommon_loot = list(
		/obj/item/mech_component/propulsion/tracks/exploration,
		/obj/item/mech_equipment/clamp
	)
	return uncommon_loot

/obj/structure/loot_pile/exosuit/explorer/get_rare_loot()
	var/static/list/rare_loot = list(
		/obj/item/mech_component/sensors/light/painted,
		/obj/item/mech_equipment/mounted_system/taser/plasma
	)
	return rare_loot

/obj/structure/loot_pile/exosuit/heavy
	name = "heavy exosuit wreckage"
	desc = "The ruins of some unfortunate heavy exosuit. Perhaps something is salvagable."

/obj/structure/loot_pile/exosuit/heavy/get_common_loot()
	var/static/list/common_loot = list(
		/obj/item/mech_component/manipulators/heavy/painted,
		/obj/item/mech_component/propulsion/heavy/painted,
		/obj/item/mech_component/chassis/heavy/painted
	)
	return common_loot

/obj/structure/loot_pile/exosuit/heavy/get_uncommon_loot()
	var/static/list/uncommon_loot = list(
		/obj/item/mech_equipment/shields,
		/obj/item/mech_equipment/mounted_system/taser
	)
	return uncommon_loot

/obj/structure/loot_pile/exosuit/heavy/get_rare_loot()
	var/static/list/rare_loot = list(
		/obj/item/mech_equipment/mounted_system/taser/laser,
		/obj/item/mech_component/sensors/heavy/painted
	)
	return rare_loot

/obj/structure/loot_pile/exosuit/light
	name = "light exosuit wreckage"
	desc = "The ruins of some unfortunate light exosuit. Perhaps something is salvagable."

/obj/structure/loot_pile/exosuit/light/get_common_loot()
	var/static/list/common_loot = list(
		/obj/item/mech_component/manipulators/light/painted,
		/obj/item/mech_component/propulsion/light/painted,
		/obj/item/mech_component/chassis/light/painted
	)
	return common_loot

/obj/structure/loot_pile/exosuit/light/get_uncommon_loot()
	var/static/list/uncommon_loot = list(
		/obj/item/mech_component/sensors/light/painted,
		/obj/item/mech_equipment/light
	)
	return uncommon_loot

/obj/structure/loot_pile/exosuit/light/get_rare_loot()
	var/static/list/rare_loot = list(
		/obj/item/mech_equipment/catapult,
		/obj/item/mech_equipment/sleeper
	)
	return rare_loot
