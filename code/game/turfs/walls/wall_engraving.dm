/datum/engraving
	var/name = "nondescript design"
	var/desc
	var/icon
	var/icon_state
	var/dir

/datum/engraving/New(var/decl/banner_symbol/engraving_symbol)
	if(engraving_symbol)
		icon = engraving_symbol.icon
		icon_state = engraving_symbol.icon_state
		name = engraving_symbol.name

/datum/engraving/random/New()
	var/banner_decls = decls_repository.get_decls_of_subtype_unassociated(/decl/banner_symbol)
	..(pick(banner_decls))
