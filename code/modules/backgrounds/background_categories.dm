/decl/background_category
	abstract_type = /decl/background_category
	decl_flags = DECL_FLAG_MANDATORY_UID
	var/name
	var/old_tag
	var/item_type
	var/list/items
	var/background_flags = 0

/decl/background_category/Initialize()
	. = ..()
	if(item_type)
		items = decls_repository.get_decls_of_type_unassociated(item_type)

/decl/background_category/validate()
	. = ..()
	if(!ispath(item_type, /decl/background_detail))
		. += "null or invalid item_type '[item_type || "NULL"]'"
	else if(!length(items))
		. += "empty or null item list"

/decl/background_category/heritage
	name = "Heritage"
	old_tag = "culture"
	uid = "heritage_cat_heritage"
	item_type = /decl/background_detail/heritage
	background_flags = BACKGROUND_FLAG_NAMING

/decl/background_category/homeworld
	name = "Residence"
	old_tag = "home_system"
	uid = "heritage_cat_homeworld"
	item_type = /decl/background_detail/location
	background_flags = BACKGROUND_FLAG_CITIZENSHIP | BACKGROUND_FLAG_LOCATION | BACKGROUND_FLAG_HOMEWORLD | BACKGROUND_FLAG_RESIDENCE

/decl/background_category/faction
	name = "Faction"
	old_tag = "faction"
	uid = "heritage_cat_faction"
	item_type = /decl/background_detail/faction
	background_flags = BACKGROUND_FLAG_IDEOLOGY

/decl/background_category/religion
	name = "Religion"
	old_tag = "religion"
	uid = "heritage_cat_religion"
	item_type = /decl/background_detail/religion
	background_flags = BACKGROUND_FLAG_RELIGION
