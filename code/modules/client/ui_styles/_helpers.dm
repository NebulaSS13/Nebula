/proc/get_ui_styles(var/filter_available = TRUE)
	var/list/all_ui_styles = decls_repository.get_decls_of_subtype(/decl/ui_style)
	for(var/ui_type in all_ui_styles)
		var/decl/ui_style/style = all_ui_styles[ui_type]
		if(!style.restricted || !filter_available)
			LAZYADD(., style)

/proc/get_ui_icon(decl/ui_style/ui_style, ui_key)

	if(ispath(ui_style))
		ui_style = GET_DECL(ui_style)
	if(!istype(ui_style))
		ui_style = GET_DECL(global.using_map.default_ui_style)
	return ui_style.get_icon(ui_key)
