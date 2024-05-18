/// Icon to use for the plant growing in the tray.
/decl/plant_trait/plant_icon
	name = "plant icon"
	default_value = null

/decl/plant_trait/plant_icon/handle_post_trait_set(datum/seed/seed)
	seed.update_growth_stages()