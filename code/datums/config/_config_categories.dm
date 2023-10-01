/decl/configuration_category
	abstract_type = /decl/configuration_category
	var/name
	var/desc
	var/configuration_file_location = "config/configuration.txt"
	var/list/associated_configuration

/decl/configuration_category/Initialize()
	if(length(associated_configuration))
		for(var/decl_type in associated_configuration)
			associated_configuration -= decl_type
			associated_configuration += GET_DECL(decl_type)
	return ..()

/decl/configuration_category/validate()
	. = ..()
	if(!name)
		. += "no name set"
	if(!desc)
		. += "no description supplied"
	if(isnull(configuration_file_location))
		. += "null dump file target"

/decl/configuration_category/proc/get_config_category_text()

	if(!length(associated_configuration))
		return ""

	var/list/header = list(
		"##",
		"# [uppertext(name)]",
		"# [desc]",
		"##"
	)

	. = list("[jointext(header, "\n")]")
	associated_configuration = sortTim(associated_configuration, /proc/cmp_decl_uid_asc)
	for(var/decl/config/config_option in associated_configuration)
		. += config_option.get_config_file_text()
	return jointext(., "\n\n")
