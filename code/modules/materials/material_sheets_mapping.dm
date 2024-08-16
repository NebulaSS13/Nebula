#define STACK_SUBTYPES(MAT_ID, MAT_NAME, MAT_TYPE, STACK_TYPE, REINF_TYPE) \
/obj/item/stack/material/##STACK_TYPE/mapped/##MAT_ID {                    \
	name = "1 " + MAT_NAME;                                               \
	material = /decl/material/MAT_TYPE;                                    \
	reinf_material = REINF_TYPE;                                           \
	amount = 1;                                                            \
	is_spawnable_type = TRUE;                                              \
}                                                                          \
/obj/item/stack/material/##STACK_TYPE/mapped/##MAT_ID/five {               \
	name = "5 " + MAT_NAME;                                                \
	amount = 5;                                                            \
}                                                                          \
/obj/item/stack/material/##STACK_TYPE/mapped/##MAT_ID/ten {                \
	name = "10 " + MAT_NAME;                                               \
	amount = 10;                                                           \
}                                                                          \
/obj/item/stack/material/##STACK_TYPE/mapped/##MAT_ID/fifteen {            \
	name = "15 " + MAT_NAME;                                               \
	amount = 15;                                                           \
}                                                                          \
/obj/item/stack/material/##STACK_TYPE/mapped/##MAT_ID/twenty {             \
	name = "20 " + MAT_NAME;                                               \
	amount = 20;                                                           \
}                                                                          \
/obj/item/stack/material/##STACK_TYPE/mapped/##MAT_ID/twentyfive {         \
	name = "25 " + MAT_NAME;                                               \
	amount = 25;                                                           \
}                                                                          \
/obj/item/stack/material/##STACK_TYPE/mapped/##MAT_ID/thirty {             \
	name = "30 " + MAT_NAME;                                               \
	amount = 30;                                                           \
}                                                                          \
/obj/item/stack/material/##STACK_TYPE/mapped/##MAT_ID/forty {              \
	name = "40 " + MAT_NAME;                                               \
	amount = 40;                                                           \
}                                                                          \
/obj/item/stack/material/##STACK_TYPE/mapped/##MAT_ID/fifty {              \
	name = "50 " + MAT_NAME;                                               \
	amount = 50;                                                           \
}

STACK_SUBTYPES(tritium,        "tritium",                       gas/hydrogen/tritium,        aerogel,          null)
STACK_SUBTYPES(deuterium,      "deuterium",                     gas/hydrogen/deuterium,      aerogel,          null)
STACK_SUBTYPES(iron,           "iron",                          solid/metal/iron,            ingot,            null)
STACK_SUBTYPES(copper,         "copper",                        solid/metal/copper,          ingot,            null)
STACK_SUBTYPES(sandstone,      "sandstone",                     solid/stone/sandstone,       brick,            null)
STACK_SUBTYPES(marble,         "marble",                        solid/stone/marble,          brick,            null)
STACK_SUBTYPES(basalt,         "basalt",                        solid/stone/basalt,          brick,            null)
STACK_SUBTYPES(concrete,       "concrete",                      solid/stone/concrete,        brick,            null)
STACK_SUBTYPES(graphite,       "graphite",                      solid/graphite,              brick,            null)
STACK_SUBTYPES(diamond,        "diamond",                       solid/gemstone/diamond,      gemstone,         null)
STACK_SUBTYPES(uranium,        "uranium",                       solid/metal/uranium,         puck,             null)
STACK_SUBTYPES(plastic,        "plastic",                       solid/organic/plastic,       panel,            null)
STACK_SUBTYPES(fiberglass,     "fiberglass",                    solid/fiberglass,            sheet/reinforced, null)
STACK_SUBTYPES(gold,           "gold",                          solid/metal/gold,            ingot,            null)
STACK_SUBTYPES(silver,         "silver",                        solid/metal/silver,          ingot,            null)
STACK_SUBTYPES(platinum,       "platinum",                      solid/metal/platinum,        ingot,            null)
STACK_SUBTYPES(mhydrogen,      "metallic hydrogen",             solid/metallic_hydrogen,     segment,          null)
STACK_SUBTYPES(osmium,         "osmium",                        solid/metal/osmium,          ingot,            null)
STACK_SUBTYPES(ocp,            "osmium-carbide plasteel",       solid/metal/plasteel/ocp,    sheet/reinforced, null)
STACK_SUBTYPES(steel,          "steel",                         solid/metal/steel,           sheet,            null)
STACK_SUBTYPES(aluminium,      "aluminium",                     solid/metal/aluminium,       sheet/shiny,      null)
STACK_SUBTYPES(titanium,       "titanium",                      solid/metal/titanium,        sheet/reinforced, null)
STACK_SUBTYPES(plasteel,       "plasteel",                      solid/metal/plasteel,        sheet/reinforced, null)
STACK_SUBTYPES(wood,           "wood",                          solid/organic/wood,          plank,            null)
STACK_SUBTYPES(mahogany,       "mahogany",                      solid/organic/wood/mahogany, plank,            null)
STACK_SUBTYPES(maple,          "maple",                         solid/organic/wood/maple,    plank,            null)
STACK_SUBTYPES(ebony,          "ebony",                         solid/organic/wood/ebony,    plank,            null)
STACK_SUBTYPES(walnut,         "walnut",                        solid/organic/wood/walnut,   plank,            null)
STACK_SUBTYPES(bamboo,         "bamboo",                        solid/organic/wood/bamboo,   plank,            null)
STACK_SUBTYPES(yew,            "yew",                           solid/organic/wood/yew,      plank,            null)
STACK_SUBTYPES(wood,           "wood",                          solid/organic/wood,          log,              null)
STACK_SUBTYPES(mahogany,       "mahogany",                      solid/organic/wood/mahogany, log,              null)
STACK_SUBTYPES(maple,          "maple",                         solid/organic/wood/maple,    log,              null)
STACK_SUBTYPES(ebony,          "ebony",                         solid/organic/wood/ebony,    log,              null)
STACK_SUBTYPES(walnut,         "walnut",                        solid/organic/wood/walnut,   log,              null)
STACK_SUBTYPES(bamboo,         "bamboo",                        solid/organic/wood/bamboo,   log,              null)
STACK_SUBTYPES(yew,            "yew",                           solid/organic/wood/yew,      log,              null)
STACK_SUBTYPES(cardboard,      "cardboard",                     solid/organic/cardboard,     cardstock,        null)
STACK_SUBTYPES(leather,        "leather",                       solid/organic/leather,       skin,             null)
STACK_SUBTYPES(synthleather,   "synthleather",                  solid/organic/leather/synth, skin,             null)
STACK_SUBTYPES(bone,           "bone",                          solid/organic/bone,          bone,             null)
STACK_SUBTYPES(glass,          "glass",                         solid/glass,                 pane,             null)
STACK_SUBTYPES(borosilicate,   "borosilicate glass",            solid/glass/borosilicate,    pane,             null)
STACK_SUBTYPES(aliumium,       "aliumium",                      solid/metal/aliumium,        cubes,            null)
STACK_SUBTYPES(rglass,         "reinforced glass",              solid/glass,                 pane,             /decl/material/solid/metal/steel)
STACK_SUBTYPES(rborosilicate,  "reinforced borosilicate glass", solid/glass/borosilicate,    pane,             /decl/material/solid/metal/steel)
STACK_SUBTYPES(zinc,           "zinc",                          solid/metal/zinc,            ingot,            null)
STACK_SUBTYPES(tin,            "tin",                           solid/metal/tin,             ingot,            null)
STACK_SUBTYPES(lead,           "lead",                          solid/metal/lead,            ingot,            null)
STACK_SUBTYPES(brass,          "brass",                         solid/metal/brass,           ingot,            null)
STACK_SUBTYPES(bronze,         "bronze",                        solid/metal/bronze,          ingot,            null)
STACK_SUBTYPES(chromium,       "chromium",                      solid/metal/chromium,        ingot,            null)
STACK_SUBTYPES(blackbronze,    "black bronze",                  solid/metal/blackbronze,     ingot,            null)
STACK_SUBTYPES(redgold,        "red gold",                      solid/metal/redgold,         ingot,            null)
STACK_SUBTYPES(stainlesssteel, "stainless steel",               solid/metal/stainlesssteel,  ingot,            null)
STACK_SUBTYPES(ice,            "ice",                           liquid/water,                cubes,            null)

STACK_SUBTYPES(cloth,          "cloth",                         solid/organic/cloth,         bolt,             null)
STACK_SUBTYPES(yellow,         "yellow cloth",                  solid/organic/cloth,         bolt/yellow,      null)
STACK_SUBTYPES(teal,           "teal cloth",                    solid/organic/cloth,         bolt/teal,        null)
STACK_SUBTYPES(black,          "black cloth",                   solid/organic/cloth,         bolt/black,       null)
STACK_SUBTYPES(green,          "green cloth",                   solid/organic/cloth,         bolt/green,       null)
STACK_SUBTYPES(purple,         "purple cloth",                  solid/organic/cloth,         bolt/purple,      null)
STACK_SUBTYPES(blue,           "blue cloth",                    solid/organic/cloth,         bolt/blue,        null)
STACK_SUBTYPES(beige,          "beige cloth",                   solid/organic/cloth,         bolt/beige,       null)
STACK_SUBTYPES(lime,           "lime cloth",                    solid/organic/cloth,         bolt/lime,        null)
STACK_SUBTYPES(red,            "red cloth",                     solid/organic/cloth,         bolt/red,         null)

STACK_SUBTYPES(steel,          "steel",                         solid/metal/steel,           strut,            null)
STACK_SUBTYPES(plastic,        "plastic",                       solid/organic/plastic,       strut,            null)
STACK_SUBTYPES(aluminium,      "aluminium",                     solid/metal/aluminium,       strut,            null)
STACK_SUBTYPES(titanium,       "titanium",                      solid/metal/titanium,        strut,            null)

STACK_SUBTYPES(cotton,         "cotton",                        solid/organic/cloth,         thread,           null)
STACK_SUBTYPES(dried_gut,      "dried gut",                     solid/organic/leather/gut,   thread,           null)

#undef STACK_SUBTYPES