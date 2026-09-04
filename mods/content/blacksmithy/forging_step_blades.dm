/decl/forging_step/blade_blank
	billet_name        = "blade blank"
	billet_icon_state  = "blade"
	billet_desc        = "A roughly shaped, dull blade. It will need further refinement before it can be finished."
	steps              = list(
		/decl/forging_step/long_blade_blank,
		/decl/forging_step/short_sword_blank
	)

/decl/forging_step/long_blade_blank
	billet_name        = "blade blank"
	billet_name_prefix = "long"
	billet_desc        = "A long, dull and unrefined blade, only a step from being a finished product."

	steps = list(
		/decl/forging_step/product/longsword_blade,
		/decl/forging_step/product/broadsword_blade,
		/decl/forging_step/product/rapier_blade
	)

/decl/forging_step/short_sword_blank
	billet_name        = "blade blank"
	billet_name_prefix = "short"
	billet_desc        = "A short, dull and unrefined blade, only a step from being a finished product."
	steps              = list(
		/decl/forging_step/product/poignard_blade,
		/decl/forging_step/product/knife_blade,
		/decl/forging_step/product/shortsword_blade,
		/decl/forging_step/product/spear_head
	)

// TODO: make these blades, add weapon crafting.
/decl/forging_step/product/longsword_blade
	billet_name  = "longsword"
	product_type = /obj/item/bladed/longsword/forged

/decl/forging_step/product/broadsword_blade
	billet_name  = "broadsword"
	product_type = /obj/item/bladed/broadsword/forged

/decl/forging_step/product/rapier_blade
	billet_name  = "rapier"
	product_type = /obj/item/bladed/rapier/forged

/decl/forging_step/product/poignard_blade
	billet_name  = "poignard"
	product_type = /obj/item/bladed/poignard/forged

/decl/forging_step/product/knife_blade
	billet_name  = "knife"
	product_type = /obj/item/bladed/knife/forged

/decl/forging_step/product/shortsword_blade
	billet_name  = "shortsword"
	product_type = /obj/item/bladed/shortsword/forged

/decl/forging_step/product/spear_head
	billet_name  = "spear"
	product_type = /obj/item/bladed/polearm/spear/forged
