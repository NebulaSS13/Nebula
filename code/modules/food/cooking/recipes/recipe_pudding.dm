// Notes on process:
// - Mix reagents in bowl
// - Chill or heat to set

/decl/recipe/spacylibertyduff
	reagents = list(/decl/material/liquid/water = 10, /decl/material/liquid/ethanol/vodka = 5, /decl/material/liquid/psychotropics = 5)
	result = /obj/item/chems/food/spacylibertyduff

/decl/recipe/amanitajelly
	reagents = list(/decl/material/liquid/water = 10, /decl/material/liquid/ethanol/vodka = 5, /decl/material/liquid/amatoxin = 5)
	result = /obj/item/chems/food/amanitajelly

/decl/recipe/amanitajelly/produce_result(obj/container)
	var/obj/item/chems/food/amanitajelly/being_cooked = ..(container)
	being_cooked.reagents.clear_reagent(/decl/material/liquid/amatoxin)
	return being_cooked

/decl/recipe/chazuke
	reagents = list(/decl/material/liquid/nutriment/rice/chazuke = 10)
	result = /obj/item/chems/food/boiledrice/chazuke

/decl/recipe/ricepudding
	reagents = list(/decl/material/liquid/drink/milk = 5, /decl/material/liquid/nutriment/rice = 10)
	result = /obj/item/chems/food/ricepudding
