/decl/hierarchy/supply_pack/exploration
	abstract_type = /decl/hierarchy/supply_pack/exploration
	access = access_explorer

/decl/hierarchy/supply_pack/exploration/bolt_rifles_explorer
 	name = "Weapons - Surplus Hunting Rifles"
 	contains = list(
 		/obj/item/gun/projectile/bolt_action = 2,
 		/obj/item/ammo_casing/rifle = 12
 	)
 	containertype = /obj/structure/closet/crate/secure
 	containername = "hunting rifle crate"

/decl/hierarchy/supply_pack/munitions/phase_carbines_explorer
 	name = "Weapons - Surplus Phase Carbines"
 	contains = list(
 		/obj/item/gun/energy/gun/reloadable/phase = 2,
 	)
 	containertype = /obj/structure/closet/crate/secure
 	containername = "phase carbine crate"

/decl/hierarchy/supply_pack/munitions/phase_rifles_explorer
 	name = "Weapons - Phase Rifles"
 	contains = list(
 		/obj/item/gun/energy/gun/reloadable/phase/rifle = 2,
 	)
 	containertype = /obj/structure/closet/crate/secure
 	containername = "phase rifle crate"

/decl/hierarchy/supply_pack/munitions/tranq_pistols_xenofauna
 	name = "Weapons - Surplus Tranquilizer Pistols"
 	contains = list(
		/obj/item/gun/energy/gun/reloadable/phase/tranq_pistol = 2,
	)
 	containertype = /obj/structure/closet/crate/secure
 	containername = "tranquilizer pistol crate"
 	access        = access_xenofauna

/decl/hierarchy/supply_pack/munitions/tranq_rifles_xenofauna
 	name = "Weapons - Surplus Tranquilizer Rifles"
 	contains = list(
		/obj/item/gun/energy/gun/reloadable/phase/tranq_rifle = 2,
	)
 	containertype = /obj/structure/closet/crate/secure
 	containername = "tranquilizer rifle crate"
 	access        = access_xenofauna
