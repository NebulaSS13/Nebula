/obj/item/chems/drinks/bottle/vodka
	desc = "Aah, vodka. Prime choice of drink AND fuel by Indies around the galaxy."

/decl/material/liquid/alcohol/vodka
	lore_text = "Number one drink AND fueling choice for Independents around the galaxy."

/obj/item/chems/drinks/bottle/premiumvodka
	desc = "Premium distilled vodka imported directly from the Gilgamesh Colonial Confederation."

/obj/item/chems/drinks/bottle/premiumvodka/make_random_name()
	var/namepick = pick("Four Stripes","Gilgamesh","Novaya Zemlya","Indie","STS-35")
	var/typepick = pick("Absolut","Gold","Quadruple Distilled","Platinum","Standard")
	name = "[namepick] [typepick]"

/decl/material/liquid/alcohol/vodka/premium
	lore_text = "Premium distilled vodka imported directly from the Gilgamesh Colonial Confederation."
