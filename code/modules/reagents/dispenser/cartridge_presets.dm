/obj/item/chems/chem_disp_cartridge/small
	volume = CARTRIDGE_VOLUME_SMALL

/obj/item/chems/chem_disp_cartridge/medium
	volume = CARTRIDGE_VOLUME_MEDIUM

/**
 * Helper macro to define a new cartridge type for a given reagent.
 * CART_TYPE: the type suffix to append to the cartridge type path.
 * REAGENT_TYPE: The reagent decl path to fill the cartridge with.
 */
#define DEFINE_CARTRIDGE_FOR_CHEM(CART_TYPE, REAGENT_TYPE) /obj/item/chems/chem_disp_cartridge/##CART_TYPE/populate_reagents(){add_to_reagents(REAGENT_TYPE, reagents.maximum_volume);}

// Multiple
DEFINE_CARTRIDGE_FOR_CHEM(water, /decl/material/liquid/water)
DEFINE_CARTRIDGE_FOR_CHEM(sugar, /decl/material/liquid/nutriment/sugar)

// Chemistry
DEFINE_CARTRIDGE_FOR_CHEM(hydrazine,  /decl/material/liquid/fuel/hydrazine)
DEFINE_CARTRIDGE_FOR_CHEM(lithium,    /decl/material/solid/lithium)
DEFINE_CARTRIDGE_FOR_CHEM(carbon,     /decl/material/solid/carbon)
DEFINE_CARTRIDGE_FOR_CHEM(ammonia,    /decl/material/gas/ammonia)
DEFINE_CARTRIDGE_FOR_CHEM(acetone,    /decl/material/liquid/acetone)
DEFINE_CARTRIDGE_FOR_CHEM(sodium,     /decl/material/solid/sodium)
DEFINE_CARTRIDGE_FOR_CHEM(aluminium,  /decl/material/solid/metal/aluminium)
DEFINE_CARTRIDGE_FOR_CHEM(silicon,    /decl/material/solid/silicon)
DEFINE_CARTRIDGE_FOR_CHEM(phosphorus, /decl/material/solid/phosphorus)
DEFINE_CARTRIDGE_FOR_CHEM(sulfur,     /decl/material/solid/sulfur)
DEFINE_CARTRIDGE_FOR_CHEM(hclacid,    /decl/material/liquid/acid/hydrochloric)
DEFINE_CARTRIDGE_FOR_CHEM(potassium,  /decl/material/solid/potassium)
DEFINE_CARTRIDGE_FOR_CHEM(iron,       /decl/material/solid/metal/iron)
DEFINE_CARTRIDGE_FOR_CHEM(copper,     /decl/material/solid/metal/copper)
DEFINE_CARTRIDGE_FOR_CHEM(mercury,    /decl/material/liquid/mercury)
DEFINE_CARTRIDGE_FOR_CHEM(radium,     /decl/material/solid/metal/radium)
DEFINE_CARTRIDGE_FOR_CHEM(ethanol,    /decl/material/liquid/ethanol)
DEFINE_CARTRIDGE_FOR_CHEM(sacid,      /decl/material/liquid/acid)
DEFINE_CARTRIDGE_FOR_CHEM(tungsten,   /decl/material/solid/metal/tungsten)


// Bar, alcoholic
DEFINE_CARTRIDGE_FOR_CHEM(beer,     /decl/material/liquid/ethanol/beer)
DEFINE_CARTRIDGE_FOR_CHEM(kahlua,   /decl/material/liquid/ethanol/coffee)
DEFINE_CARTRIDGE_FOR_CHEM(whiskey,  /decl/material/liquid/ethanol/whiskey)
DEFINE_CARTRIDGE_FOR_CHEM(wine,     /decl/material/liquid/ethanol/wine)
DEFINE_CARTRIDGE_FOR_CHEM(vodka,    /decl/material/liquid/ethanol/vodka)
DEFINE_CARTRIDGE_FOR_CHEM(gin,      /decl/material/liquid/ethanol/gin)
DEFINE_CARTRIDGE_FOR_CHEM(rum,      /decl/material/liquid/ethanol/rum)
DEFINE_CARTRIDGE_FOR_CHEM(tequila,  /decl/material/liquid/ethanol/tequila)
DEFINE_CARTRIDGE_FOR_CHEM(vermouth, /decl/material/liquid/ethanol/vermouth)
DEFINE_CARTRIDGE_FOR_CHEM(cognac,   /decl/material/liquid/ethanol/cognac)
DEFINE_CARTRIDGE_FOR_CHEM(ale,      /decl/material/liquid/ethanol/ale)
DEFINE_CARTRIDGE_FOR_CHEM(mead,     /decl/material/liquid/ethanol/mead)

// Bar, soft
DEFINE_CARTRIDGE_FOR_CHEM(ice,        /decl/material/solid/ice)
DEFINE_CARTRIDGE_FOR_CHEM(black_tea,  /decl/material/liquid/drink/tea/black)
DEFINE_CARTRIDGE_FOR_CHEM(green_tea,  /decl/material/liquid/drink/tea/green)
DEFINE_CARTRIDGE_FOR_CHEM(chai_tea,   /decl/material/liquid/drink/tea/chai)
DEFINE_CARTRIDGE_FOR_CHEM(red_tea,    /decl/material/liquid/drink/tea/red)
DEFINE_CARTRIDGE_FOR_CHEM(cola,       /decl/material/liquid/drink/cola)
DEFINE_CARTRIDGE_FOR_CHEM(citrussoda, /decl/material/liquid/drink/citrussoda)
DEFINE_CARTRIDGE_FOR_CHEM(cherrycola, /decl/material/liquid/drink/cherrycola)
DEFINE_CARTRIDGE_FOR_CHEM(lemonade,   /decl/material/liquid/drink/lemonade)
DEFINE_CARTRIDGE_FOR_CHEM(tonic,      /decl/material/liquid/drink/tonic)
DEFINE_CARTRIDGE_FOR_CHEM(sodawater,  /decl/material/liquid/drink/sodawater)
DEFINE_CARTRIDGE_FOR_CHEM(lemon_lime, /decl/material/liquid/drink/lemon_lime)
DEFINE_CARTRIDGE_FOR_CHEM(orange,     /decl/material/liquid/drink/juice/orange)
DEFINE_CARTRIDGE_FOR_CHEM(lime,       /decl/material/liquid/drink/juice/lime)
DEFINE_CARTRIDGE_FOR_CHEM(watermelon, /decl/material/liquid/drink/juice/watermelon)

// Bar, syrups
DEFINE_CARTRIDGE_FOR_CHEM(syrup_chocolate, /decl/material/liquid/drink/syrup/chocolate)
DEFINE_CARTRIDGE_FOR_CHEM(syrup_caramel,   /decl/material/liquid/drink/syrup/caramel)
DEFINE_CARTRIDGE_FOR_CHEM(syrup_vanilla,   /decl/material/liquid/drink/syrup/vanilla)
DEFINE_CARTRIDGE_FOR_CHEM(syrup_pumpkin,   /decl/material/liquid/drink/syrup/pumpkin)

// Bar, coffee
DEFINE_CARTRIDGE_FOR_CHEM(coffee,   /decl/material/liquid/drink/coffee)
DEFINE_CARTRIDGE_FOR_CHEM(hot_coco, /decl/material/liquid/drink/hot_coco)
DEFINE_CARTRIDGE_FOR_CHEM(milk,     /decl/material/liquid/drink/milk)
DEFINE_CARTRIDGE_FOR_CHEM(soymilk,  /decl/material/liquid/drink/milk/soymilk)
DEFINE_CARTRIDGE_FOR_CHEM(cream,    /decl/material/liquid/drink/milk/cream)

// ERT
DEFINE_CARTRIDGE_FOR_CHEM(adrenaline,     /decl/material/liquid/adrenaline)
DEFINE_CARTRIDGE_FOR_CHEM(retrovirals,    /decl/material/liquid/retrovirals)
DEFINE_CARTRIDGE_FOR_CHEM(painkillers,    /decl/material/liquid/painkillers)
DEFINE_CARTRIDGE_FOR_CHEM(antiseptic,     /decl/material/liquid/antiseptic)
DEFINE_CARTRIDGE_FOR_CHEM(burn_meds,      /decl/material/liquid/burn_meds)
DEFINE_CARTRIDGE_FOR_CHEM(oxy_meds,       /decl/material/liquid/oxy_meds)
DEFINE_CARTRIDGE_FOR_CHEM(regenerator,    /decl/material/liquid/regenerator)
DEFINE_CARTRIDGE_FOR_CHEM(antitoxins,     /decl/material/liquid/antitoxins)
DEFINE_CARTRIDGE_FOR_CHEM(antirads,       /decl/material/liquid/antirads)
DEFINE_CARTRIDGE_FOR_CHEM(neuroannealer,  /decl/material/liquid/neuroannealer)
DEFINE_CARTRIDGE_FOR_CHEM(eyedrops,       /decl/material/liquid/eyedrops)
DEFINE_CARTRIDGE_FOR_CHEM(brute_meds,     /decl/material/liquid/brute_meds)
DEFINE_CARTRIDGE_FOR_CHEM(amphetamines,   /decl/material/liquid/amphetamines)
DEFINE_CARTRIDGE_FOR_CHEM(antibiotics,    /decl/material/liquid/antibiotics)
DEFINE_CARTRIDGE_FOR_CHEM(sedatives,      /decl/material/liquid/sedatives)
DEFINE_CARTRIDGE_FOR_CHEM(stabilizer,     /decl/material/liquid/stabilizer)