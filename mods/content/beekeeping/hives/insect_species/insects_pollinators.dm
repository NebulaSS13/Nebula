/decl/insect_species/honeybees
	name_singular         = "honeybee"
	name_plural           = "honeybees"
	nest_name             = "beehive"
	native_frame_name     = "honeycomb"
	native_frame_desc     = "A lattice of hexagonal wax cells usually filled with honey."
	native_frame_type     = /obj/item/hive_frame/comb
	swarm_desc            = "A swarm of buzzing honeybees."
	insect_desc           = "A single buzzing honeybee."
	swarm_color           = COLOR_GOLD
	swarm_type            = /obj/effect/insect_swarm/pollinator
	sting_reagent         = /decl/material/liquid/bee_venom
	sting_amount          = 0.2
	produce_reagents      = list(/decl/material/liquid/nutriment/honey = 1)
	produce_material      = /decl/material/solid/organic/wax

/*
/decl/insect_species/wasps
	name_singular         = "wasp"
	name_plural           = "wasps"
	nest_name             = "wasp hive"
	swarm_desc            = "A swarm of humming wasps."
	insect_desc           = "A solitary wasp."
	sting_reagent         = /decl/material/liquid/cyanide
	sting_amount          = 1
	swarm_color           = COLOR_BRONZE
	swarm_type            = /obj/effect/insect_swarm/pollinator // tarantula hunter...
*/