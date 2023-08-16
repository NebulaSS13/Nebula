//Light

/datum/fabricator_recipe/flashlight
	path = /obj/item/flashlight

/datum/fabricator_recipe/flare
	path = /obj/item/flashlight/flare

//glowsticks

/datum/fabricator_recipe/glowstick_green
	path = /obj/item/flashlight/flare/glowstick

/datum/fabricator_recipe/glowstick_red
	path = /obj/item/flashlight/flare/glowstick/red

/datum/fabricator_recipe/glowstick_blue
	path = /obj/item/flashlight/flare/glowstick/blue

/datum/fabricator_recipe/glowstick_orange
	path = /obj/item/flashlight/flare/glowstick/orange

/datum/fabricator_recipe/glowstick_yellow
	path = /obj/item/flashlight/flare/glowstick/yellow

//extinguisher

/datum/fabricator_recipe/extinguisher
	path = /obj/item/chems/spray/extinguisher/empty

/datum/fabricator_recipe/extinguisher/mini
	path = /obj/item/chems/spray/extinguisher/mini/empty

//radio

/datum/fabricator_recipe/radio_headset
	path = /obj/item/radio/headset

/datum/fabricator_recipe/radio_dual
	path = /obj/item/radio/off/empty

/datum/fabricator_recipe/radio_shortwave
	path = /obj/item/radio/shortwave/off/empty

/datum/fabricator_recipe/radio_utility
	path = /obj/item/radio/utility/off/empty

//paperwork

/datum/fabricator_recipe/blackpen
	path = /obj/item/pen

/datum/fabricator_recipe/bluepen
	path = /obj/item/pen/blue

/datum/fabricator_recipe/redpen
	path = /obj/item/pen/red

/datum/fabricator_recipe/greenpen
	path = /obj/item/pen/green

/datum/fabricator_recipe/taperecorder
	path = /obj/item/taperecorder/empty

/datum/fabricator_recipe/taperecorder_tape
	path = /obj/item/magnetic_tape

/datum/fabricator_recipe/clipboard_steel
	path = /obj/item/clipboard/steel

/datum/fabricator_recipe/clipboard_alum
	path = /obj/item/clipboard/aluminium

/datum/fabricator_recipe/clipboard_glass
	path = /obj/item/clipboard/glass

/datum/fabricator_recipe/clipboard_plastic
	path = /obj/item/clipboard/plastic

/datum/fabricator_recipe/labeler
	path = /obj/item/hand_labeler

/datum/fabricator_recipe/tape
	path = /obj/item/stack/tape_roll/duct_tape

//cargo

/datum/fabricator_recipe/destTagger
	path = /obj/item/destTagger

/datum/fabricator_recipe/package_wrapper
	path = /obj/item/stack/package_wrap

/datum/fabricator_recipe/gift_wrapper
	path = /obj/item/stack/package_wrap/gift

//cleaning lol

/datum/fabricator_recipe/mop
	path = /obj/item/mop

/datum/fabricator_recipe/rag
	path = /obj/item/chems/glass/rag

/datum/fabricator_recipe/bucket
	path = /obj/item/chems/glass/bucket

/datum/fabricator_recipe/plunger
	path = /obj/item/plunger

//primitive drinks & food

/datum/fabricator_recipe/drink_glass
	path = /obj/item/chems/drinks/glass2

/datum/fabricator_recipe/drink_mug
	path = /obj/item/chems/drinks/glass2/mug

/datum/fabricator_recipe/coffeecup
	path = /obj/item/chems/drinks/glass2/coffeecup/metal

/datum/fabricator_recipe/knife
	path = /obj/item/knife/kitchen

/datum/fabricator_recipe/ashtray_glass
	path = /obj/item/ashtray/glass

/datum/fabricator_recipe/ecig_cartridge
	path = /obj/item/chems/ecig_cartridge/blank

//equipment

/datum/fabricator_recipe/suit_cooler
	path = /obj/item/suit_cooling_unit/empty

/datum/fabricator_recipe/weldermask
	path = /obj/item/clothing/head/welding

/datum/fabricator_recipe/weldinggoggles
	path = /obj/item/clothing/glasses/welding

/datum/fabricator_recipe/umbrella
	path = /obj/item/umbrella

/datum/fabricator_recipe/cataloguer
	path = /obj/item/cataloguer

/datum/fabricator_recipe/network_id
	path = /obj/item/card/id/network

/datum/fabricator_recipe/handcuffs
	path = /obj/item/handcuffs
	hidden = TRUE

//light misc

/datum/fabricator_recipe/tube/large
	path = /obj/item/light/tube/large

/datum/fabricator_recipe/tube
	path = /obj/item/light/tube

/datum/fabricator_recipe/bulb
	path = /obj/item/light/bulb

/datum/fabricator_recipe/floor_light
	path = /obj/machinery/floor_light

//tanks

/datum/fabricator_recipe/tank
	path = /obj/item/tank/oxygen/empty

/datum/fabricator_recipe/tank_yellow
	path = /obj/item/tank/oxygen/yellow/empty

/datum/fabricator_recipe/tank_nitrogen
	path = /obj/item/tank/nitrogen/empty

/datum/fabricator_recipe/tank_hydrogen
	path = /obj/item/tank/hydrogen/empty

//em tanks

/datum/fabricator_recipe/tank_emergency
	path = /obj/item/tank/emergency/oxygen/empty

/datum/fabricator_recipe/tank_emergency_engi
	path = /obj/item/tank/emergency/oxygen/engi/empty

/datum/fabricator_recipe/tank_emergency_double
	path = /obj/item/tank/emergency/oxygen/double/empty

/datum/fabricator_recipe/tank_emergency_scba
	path = /obj/item/tank/emergency/oxygen/double/red/empty

//Fiberglass

/datum/fabricator_recipe/fiberglass
	path = /obj/item/stack/material/reinforced/mapped/fiberglass
	category = "Textiles"
	fabricator_types = list(
		FABRICATOR_CLASS_GENERAL,
		FABRICATOR_CLASS_TEXTILE
	)

/datum/fabricator_recipe/fiberglass/get_resources()
	resources = list(
		/decl/material/solid/glass =   CEILING((SHEET_MATERIAL_AMOUNT * FABRICATOR_EXTRA_COST_FACTOR)/2),
		/decl/material/solid/plastic = CEILING((SHEET_MATERIAL_AMOUNT * FABRICATOR_EXTRA_COST_FACTOR)/2)
	)