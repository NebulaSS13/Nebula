/decl/interaction_handler/remove_disk
	abstract_type = /decl/interaction_handler/remove_disk
	name          = "Eject Disk"
	icon          = 'icons/screen/radial.dmi'
	icon_state    = "radial_eject"
	examine_desc  = "remove a disk"

/decl/interaction_handler/set_transfer
	name          = "Set Transfer Amount"
	abstract_type = /decl/interaction_handler/set_transfer
	examine_desc  = "set the transfer amount"

/decl/interaction_handler/remove_id
	name          = "Remove ID"
	icon          = 'icons/screen/radial.dmi'
	icon_state    = "radial_eject_id"
	abstract_type = /decl/interaction_handler/remove_id
	examine_desc  = "remove an ID card"

/decl/interaction_handler/remove_pen
	name          = "Remove Pen"
	icon          = 'icons/screen/radial.dmi'
	icon_state    = "radial_eject_pen"
	abstract_type = /decl/interaction_handler/remove_pen
	examine_desc  = "remove a pen"

/decl/interaction_handler/rename
	name          = "Rename"
	icon          = 'icons/screen/radial.dmi'
	icon_state    = "radial_rename"
	abstract_type = /decl/interaction_handler/rename
	examine_desc  = "rename $TARGET_THEM$"
