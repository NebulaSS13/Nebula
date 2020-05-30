/datum/reagents/proc/get_color()
	if(!LAZYLEN(reagent_volumes))
		return "#ffffffff"
	if(LAZYLEN(reagent_volumes) == 1) // It's pretty common and saves a lot of work
		var/decl/material/R = decls_repository.get_decl(reagent_volumes[1])
		return R.color + num2hex(R.alpha)

	var/list/colors = list(0, 0, 0, 0)
	var/tot_w = 0
	for(var/rtype in reagent_volumes)
		var/decl/material/R = decls_repository.get_decl(rtype)
		if(R.color_weight <= 0)
			continue
		var/hex = uppertext(R.color) + num2hex(R.alpha)
		var/mod = REAGENT_VOLUME(src, rtype) * R.color_weight
		colors[1] += HEX_RED(hex)   * mod
		colors[2] += HEX_GREEN(hex) * mod
		colors[3] += HEX_BLUE(hex)  * mod
		colors[4] += HEX_ALPHA(hex) * mod
		tot_w += mod

	return rgb(colors[1] / tot_w, colors[2] / tot_w, colors[3] / tot_w, colors[4] / tot_w)