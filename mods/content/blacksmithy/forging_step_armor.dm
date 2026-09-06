/decl/forging_step/armour_plates
	billet_desc        = "A set of worked metal plates, a few steps and fittings away from forming some kind of armour."
	billet_name        = "armour plates"
	billet_icon_state  = "armour"
	steps              = list(
		/decl/forging_step/product/breastplate,
		/decl/forging_step/product/cuirass,
		/decl/forging_step/product/banded
	)

/decl/forging_step/armour_segments
	billet_desc        = "A set of small worked metal plates, a few steps and fittings away from forming a helmet, or arm or leg armour."
	billet_name        = "armour segments"
	billet_icon_state  = "helmet"
	steps              = list(
		/decl/forging_step/product/helmet,
		/decl/forging_step/product/sabatons,
		/decl/forging_step/product/vambraces
	)

/decl/forging_step/product/breastplate
	product_type = /obj/item/clothing/suit/armor/forged/breastplate

/decl/forging_step/product/cuirass
	product_type = /obj/item/clothing/suit/armor/forged/cuirass

/decl/forging_step/product/banded
	product_type = /obj/item/clothing/suit/armor/forged/banded

/decl/forging_step/product/helmet
	product_type = /obj/item/clothing/head/helmet/plumed

/decl/forging_step/product/sabatons
	product_type = /obj/item/clothing/shoes/sabatons

/decl/forging_step/product/vambraces
	product_type = /obj/item/clothing/gloves/vambrace
