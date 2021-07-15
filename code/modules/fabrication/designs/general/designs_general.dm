/datum/fabricator_recipe/bucket
	path = /obj/item/chems/glass/bucket

/datum/fabricator_recipe/flashlight
	path = /obj/item/flashlight

/datum/fabricator_recipe/floor_light
	path = /obj/machinery/floor_light

/datum/fabricator_recipe/extinguisher
	path = /obj/item/extinguisher/empty

/datum/fabricator_recipe/extinguisher/mini
	path = /obj/item/extinguisher/mini/empty

/datum/fabricator_recipe/jar
	path = /obj/item/glass_jar

/datum/fabricator_recipe/radio_headset
	path = /obj/item/radio/headset

/datum/fabricator_recipe/radio_bounced
	path = /obj/item/radio/off

/datum/fabricator_recipe/suit_cooler
	path = /obj/item/suit_cooling_unit

/datum/fabricator_recipe/weldermask
	path = /obj/item/clothing/head/welding

/datum/fabricator_recipe/knife
	path = /obj/item/knife/kitchen

/datum/fabricator_recipe/taperecorder
	path = /obj/item/taperecorder/empty

/datum/fabricator_recipe/tape
	path = /obj/item/tape

/datum/fabricator_recipe/tube/large
	path = /obj/item/light/tube/large

/datum/fabricator_recipe/tube
	path = /obj/item/light/tube

/datum/fabricator_recipe/bulb
	path = /obj/item/light/bulb

/datum/fabricator_recipe/ashtray_glass
	path = /obj/item/ashtray/glass

/datum/fabricator_recipe/weldinggoggles
	path = /obj/item/clothing/glasses/welding

/datum/fabricator_recipe/blackpen
	path = /obj/item/pen

/datum/fabricator_recipe/bluepen
	path = /obj/item/pen/blue

/datum/fabricator_recipe/redpen
	path = /obj/item/pen/red

/datum/fabricator_recipe/greenpen
	path = /obj/item/pen/green

/datum/fabricator_recipe/clipboard_steel
	name = "clipboard, steel"
	path = /obj/item/clipboard/steel

/datum/fabricator_recipe/clipboard_alum
	name = "clipboard, aluminium"
	path = /obj/item/clipboard/aluminium

/datum/fabricator_recipe/clipboard_glass
	name = "clipboard, glass"
	path = /obj/item/clipboard/glass

/datum/fabricator_recipe/clipboard_alum
	name = "clipboard, plastic"
	path = /obj/item/clipboard/plastic

/datum/fabricator_recipe/destTagger
	path = /obj/item/destTagger

/datum/fabricator_recipe/labeler
	path = /obj/item/hand_labeler

/datum/fabricator_recipe/handcuffs
	path = /obj/item/handcuffs
	hidden = TRUE

/datum/fabricator_recipe/plunger
	path = /obj/item/plunger

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
