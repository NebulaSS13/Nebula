/decl/forging_step/ornate_blank
	billet_name        = "blank"
	billet_name_prefix = "ornate"
	billet_icon_state  = "ornate"
	billet_desc        = "An ornate piece of worked metal. It still needs some last touches to be made into something useful."
	steps              = list(
		/decl/forging_step/product/candelabra,
		/decl/forging_step/product/decanter,
		/decl/forging_step/product/goblet
	)

/decl/forging_step/product/candelabra
	billet_name  = "candelabra"
	product_type = /obj/item/candelabra

/decl/forging_step/product/goblet
	billet_name  = "goblet"
	product_type = /obj/item/chems/glass/handmade/fancy/goblet

/decl/forging_step/product/decanter
	billet_name  = "decanter"
	product_type =/obj/item/chems/glass/handmade/fancy/decanter