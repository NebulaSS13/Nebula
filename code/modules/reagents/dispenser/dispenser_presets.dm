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

	buildable = FALSE

/obj/machinery/chemical_dispenser/ert
	name = "medicine dispenser"
	spawn_cartridges = list(
			/obj/item/chems/chem_disp_cartridge/adrenaline,
			/obj/item/chems/chem_disp_cartridge/retrovirals,
			/obj/item/chems/chem_disp_cartridge/painkillers,
			/obj/item/chems/chem_disp_cartridge/antiseptic,
			/obj/item/chems/chem_disp_cartridge/burn_meds,
			/obj/item/chems/chem_disp_cartridge/oxy_meds,
			/obj/item/chems/chem_disp_cartridge/regenerator,
			/obj/item/chems/chem_disp_cartridge/antitoxins,
			/obj/item/chems/chem_disp_cartridge/antirads,
			/obj/item/chems/chem_disp_cartridge/neuroannealer,
			/obj/item/chems/chem_disp_cartridge/eyedrops,
			/obj/item/chems/chem_disp_cartridge/brute_meds,
			/obj/item/chems/chem_disp_cartridge/amphetamines,
			/obj/item/chems/chem_disp_cartridge/antibiotics,
			/obj/item/chems/chem_disp_cartridge/sedatives
		)

	buildable = FALSE


/obj/machinery/chemical_dispenser/bar_soft
	name = "soft drink dispenser"
	desc = "A soft drink machine." //Doesn't just serve soda --BlueNexus
	icon_state = "soda_dispenser"
	ui_title = "Soda Dispenser"
	accept_drinking = 1
	core_skill = SKILL_COOKING
	can_contaminate = FALSE //It's not a complex panel, and I'm fairly sure that most people don't haymaker the control panel on a soft drinks machine. -- Chaoko99
	base_type = /obj/machinery/chemical_dispenser/bar_soft
	beaker_offset = -2
	beaker_positions = list(-1,3,7,11,15)

/obj/machinery/chemical_dispenser/bar_soft/full
	spawn_cartridges = list(
			/obj/item/chems/chem_disp_cartridge/water,
			/obj/item/chems/chem_disp_cartridge/ice,
			/obj/item/chems/chem_disp_cartridge/coffee,
			/obj/item/chems/chem_disp_cartridge/hot_coco,
			/obj/item/chems/chem_disp_cartridge/cream,
			/obj/item/chems/chem_disp_cartridge/black_tea,
			/obj/item/chems/chem_disp_cartridge/green_tea,
			/obj/item/chems/chem_disp_cartridge/chai_tea,
			/obj/item/chems/chem_disp_cartridge/red_tea,
			/obj/item/chems/chem_disp_cartridge/cola,
			/obj/item/chems/chem_disp_cartridge/citrussoda,
			/obj/item/chems/chem_disp_cartridge/cherrycola,
			/obj/item/chems/chem_disp_cartridge/lemonade,
			/obj/item/chems/chem_disp_cartridge/tonic,
			/obj/item/chems/chem_disp_cartridge/sodawater,
			/obj/item/chems/chem_disp_cartridge/lemon_lime,
			/obj/item/chems/chem_disp_cartridge/sugar,
			/obj/item/chems/chem_disp_cartridge/orange,
			/obj/item/chems/chem_disp_cartridge/lime,
			/obj/item/chems/chem_disp_cartridge/watermelon
		)

	buildable = FALSE

/obj/machinery/chemical_dispenser/bar_alc
	name = "booze dispenser"
	desc = "A beer machine. Like a soda machine, but more fun!"
	icon_state = "booze_dispenser"
	ui_title = "Booze Dispenser"
	accept_drinking = 1
	core_skill = SKILL_COOKING
	can_contaminate = FALSE //See above.
	base_type = /obj/machinery/chemical_dispenser/bar_alc
	beaker_offset = -2
	beaker_positions = list(-3,2,7,12,17)


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

	buildable = FALSE

/obj/machinery/chemical_dispenser/bar_coffee
	name = "coffee dispenser"
	desc = "Driving crack dealers out of employment since 2280."
	icon_state = "coffee_dispenser"
	ui_title = "Coffee Dispenser"
	accept_drinking = 1
	core_skill = SKILL_COOKING
	can_contaminate = FALSE //See above.
	base_type = /obj/machinery/chemical_dispenser/bar_coffee
	beaker_offset = -2
	beaker_positions = list(0,14)


/obj/machinery/chemical_dispenser/bar_coffee/full
	spawn_cartridges = list(
			/obj/item/chems/chem_disp_cartridge/coffee,
			/obj/item/chems/chem_disp_cartridge/hot_coco,
			/obj/item/chems/chem_disp_cartridge/milk,
			/obj/item/chems/chem_disp_cartridge/soymilk,
			/obj/item/chems/chem_disp_cartridge/cream,
			/obj/item/chems/chem_disp_cartridge/black_tea,
			/obj/item/chems/chem_disp_cartridge/green_tea,
			/obj/item/chems/chem_disp_cartridge/chai_tea,
			/obj/item/chems/chem_disp_cartridge/red_tea,
			/obj/item/chems/chem_disp_cartridge/ice,
			/obj/item/chems/chem_disp_cartridge/syrup_chocolate,
			/obj/item/chems/chem_disp_cartridge/syrup_caramel,
			/obj/item/chems/chem_disp_cartridge/syrup_vanilla,
			/obj/item/chems/chem_disp_cartridge/syrup_pumpkin
		)

	buildable = FALSE