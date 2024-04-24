/decl/material/liquid/nutriment/soup_stock
	name = "stock"
	uid = "liquid_soup_stock"
	abstract_type = /decl/material/liquid/nutriment/soup_stock

/decl/material/liquid/nutriment/soup_stock/mix_data(var/datum/reagents/reagents, var/list/newdata, var/newamount)
	var/list/ret_data = ..()
	var/list/olddata = LAZYACCESS(reagents.reagent_data, type)
	var/mask_name = islist(newdata) && newdata["mask_name"]
	if(mask_name)
		if(!islist(olddata) || olddata["mask_name"] == mask_name)
			LAZYSET(ret_data, "mask_name", mask_name)
		else if(islist(ret_data))
			LAZYREMOVE(ret_data, "mask_name")
	else if(islist(olddata))
		var/old_stock_name = olddata["mask_name"]
		if(old_stock_name)
			LAZYSET(ret_data, "mask_name", old_stock_name)
		else
			LAZYREMOVE(ret_data, "mask_name")
	return ret_data

/decl/material/liquid/nutriment/soup_stock/meat
	name = "meat stock"
	uid = "liquid_soup_stock_meat"
	liquid_name = "meat stock"
	solid_name = "powdered meat stock"
	codex_name = "meat stock"
	color = "#8a7452"

/decl/material/liquid/nutriment/soup_stock/vegetable
	name = "vegetable stock"
	uid = "liquid_soup_stock_vegetable"
	liquid_name = "vegetable stock"
	solid_name = "powdered vegetable stock"
	codex_name = "vegetable stock"
	color = "#b0c772"

/decl/material/liquid/nutriment/soup_stock/bone
	name = "bone broth"
	uid = "liquid_soup_stock_bone"
	liquid_name = "bone broth"
	solid_name = "powdered bone broth"
	codex_name = "bone broth"
	color = "#c0b067"
