#define STACK_SUBTYPES(MAT_ID, MAT_NAME, MAT_TYPE, STACK_TYPE, REINF_TYPE) \
/obj/item/stack/material/##STACK_TYPE/mapped/##MAT_ID {                    \
	name = "1 " + #MAT_NAME;                                               \
	material = /decl/material/MAT_TYPE;                                    \
	reinf_material = REINF_TYPE;                                           \
	amount = 1;                                                            \
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

STACK_SUBTYPES(tritium,       "tritium",                       gas/hydrogen/tritium,     aerogel,    null)
STACK_SUBTYPES(deuterium,     "deuterium",                     gas/hydrogen/deuterium,   aerogel,    null)
STACK_SUBTYPES(iron,          "iron",                          solid/metal/iron,         ingot,      null)
STACK_SUBTYPES(copper,        "copper",                        solid/metal/copper,       ingot,      null)
STACK_SUBTYPES(sandstone,     "sandstone",                     solid/stone/sandstone,    brick,      null)
STACK_SUBTYPES(marble,        "marble",                        solid/stone/marble,       brick,      null)
STACK_SUBTYPES(diamond,       "diamond",                       solid/gemstone/diamond,   gemstone,   null)
STACK_SUBTYPES(uranium,       "uranium",                       solid/metal/uranium,      puck,       null)
STACK_SUBTYPES(plastic,       "plastic",                       solid/plastic,            panel,      null)
STACK_SUBTYPES(fiberglass,    "fiberglass",                    solid/fiberglass,         reinforced, null)
STACK_SUBTYPES(gold,          "gold",                          solid/metal/gold,         ingot,      null)
STACK_SUBTYPES(silver,        "silver",                        solid/metal/silver,       ingot,      null)
STACK_SUBTYPES(platinum,      "platinum",                      solid/metal/platinum,     ingot,      null)
STACK_SUBTYPES(mhydrogen,     "metallic hydrogen",             solid/metallic_hydrogen,  segment,    null)
STACK_SUBTYPES(osmium,        "osmium",                        solid/metal/osmium,       ingot,      null)
STACK_SUBTYPES(ocp,           "osmium-carbide plasteel",       solid/metal/plasteel/ocp, reinforced, null)
STACK_SUBTYPES(steel,         "steel",                         solid/metal/steel,        sheet,      null)
STACK_SUBTYPES(aluminium,     "aluminium",                     solid/metal/aluminium,    shiny,      null)
STACK_SUBTYPES(titanium,      "titanium",                      solid/metal/titanium,     reinforced, null)
STACK_SUBTYPES(plasteel,      "plasteel",                      solid/metal/plasteel,     reinforced, null)
STACK_SUBTYPES(wood,          "wood",                          solid/wood,               plank,      null)
STACK_SUBTYPES(mahogany,      "mahogany",                      solid/wood/mahogany,      plank,      null)
STACK_SUBTYPES(maple,         "maple",                         solid/wood/maple,         plank,      null)
STACK_SUBTYPES(ebony,         "ebony",                         solid/wood/ebony,         plank,      null)
STACK_SUBTYPES(walnut,        "walnut",                        solid/wood/walnut,        plank,      null)
STACK_SUBTYPES(bamboo,        "bamboo",                        solid/wood/bamboo,        plank,      null)
STACK_SUBTYPES(yew,           "yew",                           solid/wood/yew,           plank,      null)
STACK_SUBTYPES(cloth,         "cloth",                         solid/cloth,              bolt,       null)
STACK_SUBTYPES(cardboard,     "cardboard",                     solid/cardboard,          cardstock,  null)
STACK_SUBTYPES(leather,       "leather",                       solid/leather,            skin,       null)
STACK_SUBTYPES(synthleather,  "synthleather",                  solid/leather/synth,      skin,       null)
STACK_SUBTYPES(glass,         "glass",                         solid/glass,              pane,       null)
STACK_SUBTYPES(borosilicate,  "borosilicate glass",            solid/glass/borosilicate, pane,       null)
STACK_SUBTYPES(aliumium,      "aliumium",                      solid/metal/aliumium,     cubes,      null)
STACK_SUBTYPES(rglass,        "reinforced glass",              solid/glass,              pane,       /decl/material/solid/metal/steel)
STACK_SUBTYPES(rborosilicate, "reinforced borosilicate glass", solid/glass/borosilicate, pane,       /decl/material/solid/metal/steel)

#undef STACK_SUBTYPES