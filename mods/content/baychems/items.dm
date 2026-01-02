/obj/item/chems/hypospray/autoinjector/pouch_auto/oxy_meds
	name = "emergency oxygenation autoinjector"

/obj/item/rig_module/chem_dispenser
	charges = list(
		list("dexalin",       "dexalin",      /decl/material/liquid/oxy_meds,     80),
		list("inaprovaline",  "inaprovaline", /decl/material/liquid/stabilizer,   80),
		list("dylovene",      "dylovene",     /decl/material/liquid/antitoxins,   80),
		list("hyronalin",     "hyronalin",    /decl/material/liquid/antirads,     80),
		list("spaceacillin",  "spaceacillin", /decl/material/liquid/antibiotics,  80),
		list("tramadol",      "tramadol",     /decl/material/liquid/painkillers,  80)
		)

/obj/item/rig_module/chem_dispenser/ninja
	//just over a syringe worth of each. Want more? Go refill. Gives the ninja another reason to have to show their face.
	charges = list(
		list("dexalin",      "dexalin",       /decl/material/liquid/oxy_meds,          20),
		list("inaprovaline", "inaprovaline",  /decl/material/liquid/stabilizer,        20),
		list("dylovene",     "dylovene",      /decl/material/liquid/antitoxins,        20),
		list("glucose",      "glucose",       /decl/material/liquid/nutriment/glucose, 80),
		list("hyronalin",    "hyronalin",     /decl/material/liquid/antirads,          20),
		list("kelotane",     "kelotane",      /decl/material/liquid/burn_meds,         20),
		list("spaceacillin", "spaceacillin",  /decl/material/liquid/antibiotics,       20),
		list("tramadol",     "tramadol",      /decl/material/liquid/painkillers,       20)
		)