/obj/structure/loot_pile/exosuit/explorer
	name = "exploration exosuit wreckage"
	desc = "The ruins of some unfortunate exploration exosuit. Perhaps something is salvageable."

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
