/datum/fabricator_recipe/bucket
	path = /obj/item/chems/glass/bucket

/datum/fabricator_recipe/flashlight
	path = /obj/item/flashlight

/datum/fabricator_recipe/floor_light
	path = /obj/machinery/floor_light

/datum/fabricator_recipe/extinguisher
	path = /obj/item/chems/spray/extinguisher/empty

/datum/fabricator_recipe/extinguisher/mini
	path = /obj/item/chems/spray/extinguisher/mini/empty

/datum/fabricator_recipe/jar
	path = /obj/item/glass_jar

/datum/fabricator_recipe/pot
	path = /obj/item/chems/cooking_vessel/pot

/datum/fabricator_recipe/skillet
	path = /obj/item/chems/cooking_vessel/skillet

/datum/fabricator_recipe/radio_headset
	path = /obj/item/radio/headset

/datum/fabricator_recipe/radio_dual
	path = /obj/item/radio/off

/datum/fabricator_recipe/radio_shortwave
	path = /obj/item/radio/shortwave/off

/datum/fabricator_recipe/suit_cooler
	path = /obj/item/suit_cooling_unit

/datum/fabricator_recipe/weldermask
	path = /obj/item/clothing/head/welding

/datum/fabricator_recipe/knife
	path = /obj/item/knife/kitchen

/datum/fabricator_recipe/taperecorder
	path = /obj/item/taperecorder/empty

/datum/fabricator_recipe/taperecorder_tape
	path = /obj/item/magnetic_tape

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
	path = /obj/item/stack/material/sheet/reinforced/mapped/fiberglass
	category = "Textiles"
	fabricator_types = list(
		FABRICATOR_CLASS_GENERAL,
		FABRICATOR_CLASS_TEXTILE
	)

/datum/fabricator_recipe/fiberglass/get_resources()
	resources = list(
		/decl/material/solid/glass =   ceil((SHEET_MATERIAL_AMOUNT * FABRICATOR_EXTRA_COST_FACTOR)/2),
		/decl/material/solid/organic/plastic = ceil((SHEET_MATERIAL_AMOUNT * FABRICATOR_EXTRA_COST_FACTOR)/2)
	)

/datum/fabricator_recipe/struts
	name = "strut, steel"
	path = /obj/item/stack/material/strut/mapped/steel

/datum/fabricator_recipe/struts/get_resources()
	resources = list(
		/decl/material/solid/metal/steel =   ceil((SHEET_MATERIAL_AMOUNT * FABRICATOR_EXTRA_COST_FACTOR)),
	)

/datum/fabricator_recipe/struts/plastic
	name = "strut, plastic"
	path = /obj/item/stack/material/strut/mapped/plastic

/datum/fabricator_recipe/struts/plastic/get_resources()
	resources = list(
		/decl/material/solid/organic/plastic =   ceil((SHEET_MATERIAL_AMOUNT * FABRICATOR_EXTRA_COST_FACTOR)),
	)

/datum/fabricator_recipe/struts/aluminium
	name = "strut, aluminium"
	path = /obj/item/stack/material/strut/mapped/aluminium
	fabricator_types = list(FABRICATOR_CLASS_INDUSTRIAL)

/datum/fabricator_recipe/struts/aluminium/get_resources()
	resources = list(
		/decl/material/solid/metal/aluminium =   ceil((SHEET_MATERIAL_AMOUNT * FABRICATOR_EXTRA_COST_FACTOR)),
	)

/datum/fabricator_recipe/struts/titanium
	name = "strut, titanium"
	path = /obj/item/stack/material/strut/mapped/titanium
	fabricator_types = list(FABRICATOR_CLASS_INDUSTRIAL)

/datum/fabricator_recipe/struts/titanium/get_resources()
	resources = list(
		/decl/material/solid/metal/titanium =   ceil((SHEET_MATERIAL_AMOUNT * FABRICATOR_EXTRA_COST_FACTOR)),
	)

/datum/fabricator_recipe/umbrella
	path = /obj/item/umbrella

/datum/fabricator_recipe/network_id
	path = /obj/item/card/id/network
	fabricator_types = list(
		FABRICATOR_CLASS_GENERAL
	)

/datum/fabricator_recipe/emergency_tank
	path = /obj/item/tank/emergency

/datum/fabricator_recipe/package_wrapper
	path = /obj/item/stack/package_wrap

/datum/fabricator_recipe/package_wrapper/gift
	path = /obj/item/stack/package_wrap/gift

/datum/fabricator_recipe/clothes_iron
	path = /obj/item/ironingiron

/datum/fabricator_recipe/ironing_board
	path = /obj/item/roller/ironingboard

/datum/fabricator_recipe/duct_tape
	path = /obj/item/stack/tape_roll/duct_tape
	pass_multiplier_to_product_new = FALSE // they are printed as single items with 32 uses

/datum/fabricator_recipe/fishing_line
	path = /obj/item/fishing_line

/datum/fabricator_recipe/fishing_line_high_quality
	path = /obj/item/fishing_line/high_quality

