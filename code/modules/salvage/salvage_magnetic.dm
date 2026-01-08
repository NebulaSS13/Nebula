/obj/item/salvage/magnetic
	name = "broken magnetic weapon"
	icon = /obj/item/gun/magnetic/railgun/flechette::icon
	icon_state = /obj/item/gun/magnetic/railgun/flechette::icon_state
	abstract_type = /obj/item/salvage/magnetic

/obj/item/salvage/magnetic/get_repair_options()
	return ..() + /decl/salvage_repair_option/magnetic

/obj/item/salvage/magnetic/flechette
	salvaged_type = /obj/item/gun/magnetic/railgun/flechette

