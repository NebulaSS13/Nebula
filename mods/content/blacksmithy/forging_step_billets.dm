/decl/forging_step/billet
	billet_desc        = "An unworked length of metal used to forge items and tools."
	steps              = list(
		/decl/forging_step/thin_billet,
		/decl/forging_step/curved_billet,
		/decl/forging_step/flat_bar,
		/decl/forging_step/punched_billet
	)

/decl/forging_step/thin_billet
	billet_name_prefix = "thin"
	billet_icon_state  = "thin"
	billet_desc        = "A thin, elongated length of metal used to forge items and tools."
	steps              = list(
		/decl/forging_step/blade_blank,
		/decl/forging_step/ornate_blank,
		/decl/forging_step/product/nails
	)

/decl/forging_step/curved_billet
	billet_name_prefix = "curved"
	billet_icon_state  = "curved"
	billet_desc        = "A curved length of metal used to forge items and tools."
	steps              = list(
		/decl/forging_step/product/hook,
		/decl/forging_step/product/chain,
		/decl/forging_step/product/horseshoe
	)

/decl/forging_step/flat_bar
	billet_name        = "bar"
	billet_name_prefix = "flat"
	billet_icon_state  = "flat"
	billet_desc        = "A flattened bar of metal used to forge armour components and plates."
	steps              = list(
		/decl/forging_step/armour_plates,
		/decl/forging_step/armour_segments,
		/decl/forging_step/product/shield_fasteners
	)

/decl/forging_step/punched_billet
	billet_name_prefix = "punched"
	billet_icon_state  = "punched"
	billet_desc        = "A punched bar of metal used to forge items and tools"
	steps              = list(
		/decl/forging_step/tool_head_blank,
		/decl/forging_step/product/tongs
	)
