/obj/machinery/chemical_dispenser/full
	spawn_cartridges = list(
			/obj/item/chems/chem_disp_cartridge/hydrazine,
			/obj/item/chems/chem_disp_cartridge/lithium,
			/obj/item/chems/chem_disp_cartridge/carbon,
			/obj/item/chems/chem_disp_cartridge/ammonia,
			/obj/item/chems/chem_disp_cartridge/acetone,
			/obj/item/chems/chem_disp_cartridge/sodium,
			/obj/item/chems/chem_disp_cartridge/aluminium,
			/obj/item/chems/chem_disp_cartridge/silicon,
			/obj/item/chems/chem_disp_cartridge/phosphorus,
			/obj/item/chems/chem_disp_cartridge/sulfur,
			/obj/item/chems/chem_disp_cartridge/hclacid,
			/obj/item/chems/chem_disp_cartridge/potassium,
			/obj/item/chems/chem_disp_cartridge/iron,
			/obj/item/chems/chem_disp_cartridge/copper,
			/obj/item/chems/chem_disp_cartridge/mercury,
			/obj/item/chems/chem_disp_cartridge/radium,
			/obj/item/chems/chem_disp_cartridge/water,
			/obj/item/chems/chem_disp_cartridge/ethanol,
			/obj/item/chems/chem_disp_cartridge/sugar,
			/obj/item/chems/chem_disp_cartridge/sacid,
			/obj/item/chems/chem_disp_cartridge/tungsten
		)

/obj/machinery/chemical_dispenser/ert
	name = "medicine dispenser"
	spawn_cartridges = list(
			/obj/item/chems/chem_disp_cartridge/inaprov,
			/obj/item/chems/chem_disp_cartridge/ryetalyn,
			/obj/item/chems/chem_disp_cartridge/paracetamol,
			/obj/item/chems/chem_disp_cartridge/tramadol,
			/obj/item/chems/chem_disp_cartridge/oxycodone,
			/obj/item/chems/chem_disp_cartridge/sterilizine,
			/obj/item/chems/chem_disp_cartridge/leporazine,
			/obj/item/chems/chem_disp_cartridge/kelotane,
			/obj/item/chems/chem_disp_cartridge/dermaline,
			/obj/item/chems/chem_disp_cartridge/dexalin,
			/obj/item/chems/chem_disp_cartridge/dexalin_p,
			/obj/item/chems/chem_disp_cartridge/tricord,
			/obj/item/chems/chem_disp_cartridge/dylovene,
			/obj/item/chems/chem_disp_cartridge/synaptizine,
			/obj/item/chems/chem_disp_cartridge/hyronalin,
			/obj/item/chems/chem_disp_cartridge/arithrazine,
			/obj/item/chems/chem_disp_cartridge/alkysine,
			/obj/item/chems/chem_disp_cartridge/imidazoline,
			/obj/item/chems/chem_disp_cartridge/peridaxon,
			/obj/item/chems/chem_disp_cartridge/bicaridine,
			/obj/item/chems/chem_disp_cartridge/hyperzine,
			/obj/item/chems/chem_disp_cartridge/rezadone,
			/obj/item/chems/chem_disp_cartridge/spaceacillin,
			/obj/item/chems/chem_disp_cartridge/ethylredox,
			/obj/item/chems/chem_disp_cartridge/sleeptox,
			/obj/item/chems/chem_disp_cartridge/chloral,
			/obj/item/chems/chem_disp_cartridge/cryoxadone,
			/obj/item/chems/chem_disp_cartridge/clonexadone
		)

/obj/machinery/chemical_dispenser/bar_soft
	name = "soft drink dispenser"
	desc = "A soft drink machine." //Doesn't just serve soda --BlueNexus
	icon_state = "soda_dispenser"
	ui_title = "Soda Dispenser"
	accept_drinking = 1
	core_skill = SKILL_COOKING
	can_contaminate = FALSE //It's not a complex panel, and I'm fairly sure that most people don't haymaker the control panel on a soft drinks machine. -- Chaoko99

/obj/machinery/chemical_dispenser/bar_soft/full
	spawn_cartridges = list(
			/obj/item/chems/chem_disp_cartridge/water,
			/obj/item/chems/chem_disp_cartridge/ice,
			/obj/item/chems/chem_disp_cartridge/coffee,
			/obj/item/chems/chem_disp_cartridge/hot_coco,
			/obj/item/chems/chem_disp_cartridge/cream,
			/obj/item/chems/chem_disp_cartridge/tea,
			/obj/item/chems/chem_disp_cartridge/green_tea,
			/obj/item/chems/chem_disp_cartridge/chai_tea,
			/obj/item/chems/chem_disp_cartridge/red_tea,
			/obj/item/chems/chem_disp_cartridge/cola,
			/obj/item/chems/chem_disp_cartridge/smw,
			/obj/item/chems/chem_disp_cartridge/dr_gibb,
			/obj/item/chems/chem_disp_cartridge/spaceup,
			/obj/item/chems/chem_disp_cartridge/tonic,
			/obj/item/chems/chem_disp_cartridge/sodawater,
			/obj/item/chems/chem_disp_cartridge/lemon_lime,
			/obj/item/chems/chem_disp_cartridge/sugar,
			/obj/item/chems/chem_disp_cartridge/orange,
			/obj/item/chems/chem_disp_cartridge/lime,
			/obj/item/chems/chem_disp_cartridge/watermelon
		)

/obj/machinery/chemical_dispenser/bar_alc
	name = "booze dispenser"
	desc = "A beer machine. Like a soda machine, but more fun!"
	icon_state = "booze_dispenser"
	ui_title = "Booze Dispenser"
	accept_drinking = 1
	core_skill = SKILL_COOKING
	can_contaminate = FALSE //See above.

/obj/machinery/chemical_dispenser/bar_alc/full
	spawn_cartridges = list(
			/obj/item/chems/chem_disp_cartridge/lemon_lime,
			/obj/item/chems/chem_disp_cartridge/sugar,
			/obj/item/chems/chem_disp_cartridge/orange,
			/obj/item/chems/chem_disp_cartridge/lime,
			/obj/item/chems/chem_disp_cartridge/sodawater,
			/obj/item/chems/chem_disp_cartridge/tonic,
			/obj/item/chems/chem_disp_cartridge/beer,
			/obj/item/chems/chem_disp_cartridge/kahlua,
			/obj/item/chems/chem_disp_cartridge/whiskey,
			/obj/item/chems/chem_disp_cartridge/wine,
			/obj/item/chems/chem_disp_cartridge/vodka,
			/obj/item/chems/chem_disp_cartridge/gin,
			/obj/item/chems/chem_disp_cartridge/rum,
			/obj/item/chems/chem_disp_cartridge/tequila,
			/obj/item/chems/chem_disp_cartridge/vermouth,
			/obj/item/chems/chem_disp_cartridge/cognac,
			/obj/item/chems/chem_disp_cartridge/ale,
			/obj/item/chems/chem_disp_cartridge/mead
		)

/obj/machinery/chemical_dispenser/bar_coffee
	name = "coffee dispenser"
	desc = "Driving crack dealers out of employment since 2280."
	icon_state = "coffee_dispenser"
	ui_title = "Coffee Dispenser"
	accept_drinking = 1
	core_skill = SKILL_COOKING
	can_contaminate = FALSE //See above.

/obj/machinery/chemical_dispenser/bar_coffee/full
	spawn_cartridges = list(
			/obj/item/chems/chem_disp_cartridge/coffee,
			/obj/item/chems/chem_disp_cartridge/cafe_latte,
			/obj/item/chems/chem_disp_cartridge/soy_latte,
			/obj/item/chems/chem_disp_cartridge/hot_coco,
			/obj/item/chems/chem_disp_cartridge/milk,
			/obj/item/chems/chem_disp_cartridge/cream,
			/obj/item/chems/chem_disp_cartridge/tea,
			/obj/item/chems/chem_disp_cartridge/green_tea,
			/obj/item/chems/chem_disp_cartridge/chai_tea,
			/obj/item/chems/chem_disp_cartridge/red_tea,
			/obj/item/chems/chem_disp_cartridge/ice,
			/obj/item/chems/chem_disp_cartridge/syrup_chocolate,
			/obj/item/chems/chem_disp_cartridge/syrup_caramel,
			/obj/item/chems/chem_disp_cartridge/syrup_vanilla,
			/obj/item/chems/chem_disp_cartridge/syrup_pumpkin
		)
