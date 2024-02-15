// Has large amounts of possible items, most of which may or may not be useful.
/obj/structure/loot_pile/maint
	abstract_type = /obj/structure/loot_pile/maint

/obj/structure/loot_pile/maint/get_icon_states_to_use()
	var/static/list/icon_states_to_use = list(
		"junk_pile1",
		"junk_pile2",
		"junk_pile3",
		"junk_pile4",
		"junk_pile5"
	)
	return icon_states_to_use

/obj/structure/loot_pile/maint/junk
	name = "pile of junk"
	desc = "Lots of junk lying around.  They say one man's trash is another man's treasure."

/obj/structure/loot_pile/maint/junk/get_common_loot()
	var/static/list/common_loot = list(
		/obj/item/flashlight/flare,
		/obj/item/flashlight/flare/glowstick,
		/obj/item/flashlight/flare/glowstick/blue,
		/obj/item/flashlight/flare/glowstick/orange,
		/obj/item/flashlight/flare/glowstick/red,
		/obj/item/flashlight/flare/glowstick/yellow,
		/obj/item/flashlight/pen,
		/obj/item/cell,
		/obj/item/cell/device,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/mask/gas/half,
		/obj/item/clothing/mask/breath,
		/obj/item/chems/glass/rag,
		/obj/item/chems/food/liquidfood,
		/obj/item/storage/secure/briefcase,
		/obj/item/storage/briefcase,
		/obj/item/storage/backpack,
		/obj/item/storage/backpack/satchel,
		/obj/item/storage/backpack/dufflebag,
		/obj/item/storage/box,
		/obj/item/storage/wallet,
		/obj/item/clothing/shoes/galoshes,
		/obj/item/clothing/shoes/color/black,
		/obj/item/clothing/shoes/dress,
		/obj/item/clothing/shoes/dress/white,
		/obj/item/clothing/gloves/thick/botany,
		/obj/item/clothing/gloves/latex,
		/obj/item/clothing/gloves/color/white,
		/obj/item/clothing/gloves/rainbow,
		/obj/item/clothing/gloves/insulated/cheap,
		/obj/item/clothing/glasses/sunglasses,
		/obj/item/clothing/glasses/meson,
		/obj/item/clothing/glasses/meson/prescription,
		/obj/item/clothing/glasses/welding,
		/obj/item/clothing/head/bio_hood/general,
		/obj/item/clothing/head/hardhat,
		/obj/item/clothing/head/hardhat/red,
		/obj/item/clothing/head/ushanka,
		/obj/item/clothing/head/welding,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/suit/space/emergency,
		/obj/item/clothing/suit/storage/toggle/bomber,
		/obj/item/clothing/suit/bio_suit/general,
		/obj/item/clothing/suit/storage/toggle/hoodie/black,
		/obj/item/clothing/suit/storage/toggle/brown_jacket,
		/obj/item/clothing/suit/storage/leather_jacket,
		/obj/item/clothing/suit/apron,
		/obj/item/clothing/under/color/grey,
		/obj/item/clothing/under/syndicate/tacticool,
		/obj/item/clothing/pants/casual/camo,
		/obj/item/clothing/under/harness,
		/obj/item/clothing/accessory/storage,
		/obj/item/cash/c1,
		/obj/item/cash/c10,
		/obj/item/cash/c20,
		/obj/item/cash/c50,
		/obj/item/frame/camera/kit,
		/obj/item/caution,
		/obj/item/caution/cone,
		/obj/item/card/emag_broken,
		/obj/item/camera,
		/obj/item/modular_computer/pda,
		/obj/item/radio/headset,
		/obj/item/paicard,
	)
	return common_loot

/obj/structure/loot_pile/maint/junk/get_uncommon_loot()
	var/static/list/uncommon_loot = list(
		/obj/item/clothing/shoes/syndigaloshes,
		/obj/item/clothing/gloves/insulated,
		/obj/item/clothing/under/tactical,
		/obj/item/beartrap,
		/obj/item/clothing/accessory/badge/press,
		/obj/item/knife/combat,
		/obj/item/knife/folding/combat/switchblade,
	)
	return uncommon_loot

/obj/structure/loot_pile/maint/junk/get_rare_loot()
	var/static/list/rare_loot = list(
		/obj/item/clothing/suit/armor/vest/heavy,
		/obj/item/clothing/shoes/jackboots/swat/combat,
	)
	return rare_loot

// Contains mostly useless garbage.
/obj/structure/loot_pile/maint/trash
	name = "pile of trash"
	desc = "Lots of garbage in one place.  Might be able to find something if you're in the mood for dumpster diving."

/obj/structure/loot_pile/maint/trash/get_icon_states_to_use()
	var/static/list/icon_states_to_use = list(
		"trash_pile1",
		"trash_pile2")
	return icon_states_to_use

/obj/structure/loot_pile/maint/trash/get_common_loot()
	var/static/list/common_loot = list(
		/obj/item/trash/candle,
		/obj/item/trash/candy,
		/obj/item/trash/candy/proteinbar,
		/obj/item/trash/cigbutt/spitgum,
		/obj/item/trash/cheesie,
		/obj/item/trash/chips,
		/obj/item/trash/stick,
		/obj/item/trash/liquidfood,
		/obj/item/trash/pistachios,
		/obj/item/plate,
		/obj/item/trash/popcorn,
		/obj/item/trash/raisins,
		/obj/item/trash/semki,
		/obj/item/trash/snack_bowl,
		/obj/item/trash/sosjerky,
		/obj/item/trash/syndi_cakes,
		/obj/item/trash/tastybread,
		/obj/item/chems/drinks/sillycup,
		/obj/item/trash/driedfish,
		/obj/item/trash/waffles,
		/obj/item/trash/beef,
		/obj/item/trash/beans,
		/obj/item/trash/tomato,
		/obj/item/trash/spinach,
		/obj/item/chems/food/spider,
		/obj/item/chems/food/mysterysoup,
		/obj/item/chems/food/old/hotdog,
		/obj/item/chems/food/old/pizza,
		/obj/item/ammo_casing,
		/obj/item/stack/material/rods/ten,
		/obj/item/stack/material/sheet/mapped/steel/five,
		/obj/item/stack/material/cardstock/mapped/cardboard/five,
		/obj/item/poster,
		/obj/item/newspaper,
		/obj/item/paper/crumpled,
		/obj/item/paper/crumpled/bloody,
	)
	return common_loot

/obj/structure/loot_pile/maint/trash/get_uncommon_loot()
	var/static/list/uncommon_loot = list(
		/obj/item/plate,
		/obj/item/plate/tray,
		/obj/item/chems/syringe/steroid,
		/obj/item/storage/pill_bottle/zoom,
		/obj/item/storage/pill_bottle/happy,
		/obj/item/storage/pill_bottle/painkillers
	)
	return uncommon_loot

// Contains loads of different types of boxes, which may have items inside!
/obj/structure/loot_pile/maint/boxfort
	name = "pile of boxes"
	desc = "A large pile of boxes sits here."
	density = TRUE

/obj/structure/loot_pile/maint/boxfort/get_icon_states_to_use()
	var/static/list/icon_states_to_use = list("boxfort")
	return icon_states_to_use

/obj/structure/loot_pile/maint/boxfort/get_common_loot()
	var/static/list/common_loot = list(
		/obj/item/storage/box,
		/obj/item/storage/box/beakers,
		/obj/item/storage/box/botanydisk,
		/obj/item/storage/box/cups,
		/obj/item/storage/box/botanydisk,
		/obj/item/storage/box/donkpockets,
		/obj/item/storage/box/fancy/donut,
		/obj/item/storage/box/fancy/donut/empty,
		/obj/item/storage/box/evidence,
		/obj/item/storage/box/lights/mixed,
		/obj/item/storage/box/lights/tubes,
		/obj/item/storage/box/lights/bulbs,
		/obj/item/storage/box/autoinjectors,
		/obj/item/storage/box/masks,
		/obj/item/storage/box/ids,
		/obj/item/storage/box/mousetraps,
		/obj/item/storage/box/syringes,
		/obj/item/storage/box/survival,
		/obj/item/storage/box/gloves,
		/obj/item/storage/box/PDAs,
	)
	return common_loot

/obj/structure/loot_pile/maint/boxfort/get_uncommon_loot()
	var/static/list/uncommon_loot = list(
		/obj/item/storage/box/sinpockets,
		/obj/item/storage/box/ammo/practiceshells,
		/obj/item/storage/box/ammo/blanks,
		/obj/item/storage/box/smokes,
		/obj/item/storage/box/metalfoam,
		/obj/item/storage/box/handcuffs
	)
	return uncommon_loot

/obj/structure/loot_pile/maint/boxfort/get_rare_loot()
	var/static/list/rare_loot = list(
		/obj/item/storage/box/flashbangs,
		/obj/item/storage/box/empslite,
		/obj/item/storage/box/ammo/flashshells,
		/obj/item/storage/box/ammo/stunshells,
		/obj/item/storage/box/teargas,
	)
	return rare_loot

// One of the more useful maint piles, contains electrical components.
/obj/structure/loot_pile/maint/technical
	name = "broken machine"
	desc = "A destroyed machine with unknown purpose, and doesn't look like it can be fixed.  It might still have some functional components?"
	density = TRUE

/obj/structure/loot_pile/maint/technical/get_icon_states_to_use()
	var/static/list/icon_states_to_use = list(
		"technical_pile1",
		"technical_pile2",
		"technical_pile3"
	)
	return icon_states_to_use

/obj/structure/loot_pile/maint/technical/get_common_loot()
	var/static/list/common_loot = list(
		/obj/item/stock_parts/network_receiver,
		/obj/item/stock_parts/radio/receiver,
		/obj/item/stock_parts/radio/transmitter,
		/obj/item/stock_parts/power/apc,
		/obj/item/stock_parts/power/terminal,
		/obj/item/stock_parts/power/battery,
		/obj/item/stock_parts/item_holder/card_reader,
		/obj/item/stock_parts/item_holder/disk_reader,
		/obj/item/stock_parts/console_screen,
		/obj/item/stock_parts/keyboard,
		/obj/item/stock_parts/capacitor,
		/obj/item/stock_parts/capacitor/adv,
		/obj/item/stock_parts/capacitor/super,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/manipulator/nano,
		/obj/item/stock_parts/manipulator/pico,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/matter_bin/adv,
		/obj/item/stock_parts/matter_bin/super,
		/obj/item/stock_parts/scanning_module,
		/obj/item/stock_parts/scanning_module/adv,
		/obj/item/stock_parts/scanning_module/phasic,
		/obj/item/stock_parts/subspace/amplifier,
		/obj/item/stock_parts/subspace/analyzer,
		/obj/item/stock_parts/subspace/ansible,
		/obj/item/stock_parts/subspace/crystal,
		/obj/item/stock_parts/subspace/filter,
		/obj/item/stock_parts/subspace/transmitter,
		/obj/item/stock_parts/subspace/treatment,
		/obj/item/borg/upgrade/restart,
		/obj/item/cell,
		/obj/item/cell/high,
		/obj/item/cell/device,
		/obj/item/stock_parts/circuitboard/broken,
		/obj/item/stock_parts/circuitboard/arcade,
		/obj/item/stock_parts/circuitboard/autolathe,
		/obj/item/stock_parts/circuitboard/atmos_alert,
		/obj/item/stock_parts/circuitboard/air_alarm,
		/obj/item/stock_parts/circuitboard/fax_machine,
		/obj/item/stock_parts/circuitboard/jukebox,
		/obj/item/stock_parts/circuitboard/batteryrack,
		/obj/item/stock_parts/circuitboard/message_monitor,
		/obj/item/stock_parts/smes_coil,
		/obj/item/scanner/gas,
		/obj/item/scanner/health,
		/obj/item/robotanalyzer,
		/obj/item/lightreplacer,
		/obj/item/radio,
		/obj/item/hailer,
		/obj/item/gps,
		/obj/item/geiger,
		/obj/item/scanner/spectrometer,
		/obj/item/wrench,
		/obj/item/screwdriver,
		/obj/item/wirecutters,
		/obj/item/scanner/mining,
		/obj/item/multitool,
		/obj/item/robot_parts/robot_component/binary_communication_device,
		/obj/item/robot_parts/robot_component/armour,
		/obj/item/robot_parts/robot_component/actuator,
		/obj/item/robot_parts/robot_component/camera,
		/obj/item/robot_parts/robot_component/diagnosis_unit,
		/obj/item/robot_parts/robot_component/radio,
	)
	return common_loot

/obj/structure/loot_pile/maint/technical/get_uncommon_loot()
	var/static/list/uncommon_loot = list(
		/obj/item/cell/super,
		/obj/item/cell/gun,
		/obj/item/aiModule/reset,
		/obj/item/stock_parts/smes_coil/super_capacity,
		/obj/item/stock_parts/smes_coil/super_io,
		/obj/item/disk/integrated_circuit/upgrade/advanced,
		/obj/item/camera/tvcamera,
		/obj/item/aicard,
		/obj/item/borg/upgrade/jetpack,
		/obj/item/borg/upgrade/vtec,
		/obj/item/borg/upgrade/weaponcooler,
		/obj/item/rig_module/device/drill,
		/obj/item/rig_module/mounted/plasmacutter,
		/obj/item/rig_module/device/healthscanner,
		/obj/item/rig_module/device/orescanner,
		/obj/item/rig_module/device/anomaly_scanner,
		/obj/item/rig_module/datajack,
		/obj/item/rig_module/vision/medhud,
		/obj/item/rig_module/vision/meson,
		/obj/item/rig_module/vision/sechud,
	)
	return uncommon_loot

/obj/structure/loot_pile/maint/technical/get_rare_loot()
	var/static/list/rare_loot = list(
		/obj/item/cell/hyper,
		/obj/item/aiModule/freeform,
		/obj/item/aiModule/asimov,
		/obj/item/aiModule/paladin,
		/obj/item/aiModule/safeguard,
	)
	return rare_loot

