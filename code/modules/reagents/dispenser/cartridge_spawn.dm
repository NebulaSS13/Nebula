/client/proc/spawn_chemdisp_cartridge(size in list("small", "medium", "large"), reagent_type in decls_repository.get_decl_paths_of_subtype(/decl/material))
	set name = "Spawn Chemical Dispenser Cartridge"
	set category = "Admin"

	var/cartridge_type
	switch(size)
		if("small") cartridge_type = /obj/item/chems/chem_disp_cartridge/small
		if("medium") cartridge_type = /obj/item/chems/chem_disp_cartridge/medium
		if("large") cartridge_type = /obj/item/chems/chem_disp_cartridge
	var/obj/item/chems/chem_disp_cartridge/cartridge = new cartridge_type(usr.loc)
	cartridge.add_to_reagents(reagent_type, cartridge.reagents?.maximum_volume)
	var/reagent_name = cartridge.reagents.get_primary_reagent_name()
	cartridge.setLabel(reagent_name)
	log_and_message_admins("spawned a [size] reagent container containing [reagent_name] ([reagent_type])")
