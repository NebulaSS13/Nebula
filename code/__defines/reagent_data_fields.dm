// Currently just used for indexing reagent data without
// having to use strings. UID is provided for serde.

/decl/reagent_data_field
	abstract_type = /decl/reagent_data_field
	decl_flags = DECL_FLAG_MANDATORY_UID

/decl/reagent_data_field/taste
	uid = "rdf_taste"

/decl/reagent_data_field/ingredient_list
	uid = "rdf_ingredient_list"

/decl/reagent_data_field/ingredient_flags
	uid = "rdf_ingredient_flags"

/decl/reagent_data_field/mask_color
	uid = "rdf_mask_color"

/decl/reagent_data_field/mask_name
	uid = "rdf_mask_name"
