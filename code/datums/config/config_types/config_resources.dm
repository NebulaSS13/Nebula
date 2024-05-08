/decl/configuration_category/resources
	name = "Resources"
	desc = "Configuration options relating to server resources."
	associated_configuration = list(
		/decl/config/text/custom_item_icon_location,
		/decl/config/text/custom_icon_icon_location,
		/decl/config/lists/resource_urls
	)

/decl/config/text/custom_item_icon_location
	uid = "custom_item_icon_location"
	default_value = "config/custom_items/icons"
	desc = "Set this to a file path relative to the executing binary to prefix all custom item icon locations with this location ie. '\[CUSTOM_ITEM_ICON_LOCATION\]/\[custom item icon path value\]'"

/decl/config/text/custom_icon_icon_location
	uid = "custom_icon_icon_location"
	default_value = "config/custom_icons/icons"
	desc = "Set this to a file path relative to the executing binary to prefix all custom icon locations with this location ie. '\[CUSTOM_ICON_ICON_LOCATION\]/\[custom icon path value\]'"

/decl/config/lists/resource_urls
	uid = "resource_urls"
	desc = list(
		"Direct clients to preload the server resource file from a URL pointing to a .rsc file. NOTE: At this time (byond 512),",
		"the client/resource_rsc var does not function as one would expect. See client_defines.dm, the 'preload_rsc' var's",
		"comments on how to use it properly. If you use a resource URL, you must set preload_rsc to 0 at compile time or",
		"clients will still download from the server *too*. This will randomly select one URL if more than one is provided.",
		"Spaces are prohibited in each URL by spec, you must use encoded spaces.",
		"ex. RESOURCE_URLS URL URL2 URL3"
	)
