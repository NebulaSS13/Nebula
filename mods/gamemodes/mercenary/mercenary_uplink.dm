// Ammunition
/datum/uplink_item/item/ammo/sniperammo
	name = "Ammobox of Sniper Rounds"
	desc = "A container of rounds for the anti-materiel rifle. Contains 7 rounds."
	item_cost = 8
	path = /obj/item/box/ammo/sniperammo
	antag_roles = list(/decl/special_role/mercenary)

/datum/uplink_item/item/ammo/sniperammo/apds
	name = "Ammobox of APDS Sniper Rounds"
	desc = "A container of armor piercing rounds for the anti-materiel rifle. Contains 3 rounds."
	item_cost = 12
	path = /obj/item/box/ammo/sniperammo/apds
	antag_roles = list(/decl/special_role/mercenary)

/datum/uplink_item/item/ammo/smg
	name = "Standard Box Magazine"
	desc = "A magazine for standard SMGs. Contains 20 rounds."
	item_cost = 8
	path = /obj/item/ammo_magazine/smg
	antag_roles = list(/decl/special_role/mercenary)

/datum/uplink_item/item/ammo/flechette
	name = "Flechette Rifle Magazine"
	desc = "A rifle magazine loaded with flechette rounds. Contains 9 rounds."
	item_cost = 8
	path = /obj/item/magnetic_ammo
	antag_roles = list(/decl/special_role/mercenary)

// Highly Visible and Dangerous Weapons
/datum/uplink_item/item/visible_weapons/grenade_launcher
	name = "Grenade Launcher"
	desc = "A pump action grenade launcher loaded with a random assortment of grenades"
	item_cost = 60
	antag_roles = list(/decl/special_role/mercenary)
	path = /obj/item/gun/launcher/grenade/random

/datum/uplink_item/item/visible_weapons/smg
	name = "Standard Submachine Gun"
	desc = "A quick-firing weapon with three toggleable fire modes."
	item_cost = 52
	path = /obj/item/gun/projectile/automatic/smg
	antag_roles = list(/decl/special_role/mercenary)

/datum/uplink_item/item/visible_weapons/assaultrifle
	name = "Assault Rifle"
	desc = "A common rifle with three toggleable fire modes."
	item_cost = 60
	path = /obj/item/gun/projectile/automatic/assault_rifle
	antag_roles = list(/decl/special_role/mercenary)

/datum/uplink_item/item/visible_weapons/heavysniper
	name = "Anti-materiel Sniper Rifle"
	desc = "A secure briefcase that contains an immensely powerful penetrating rifle, as well as seven extra sniper rounds."
	item_cost = 68
	path = /obj/item/secure_storage/briefcase/heavysniper
	antag_roles = list(/decl/special_role/mercenary)

/datum/uplink_item/item/visible_weapons/combat_shotgun
	name = "Pump Shotgun"
	desc = "A high capacity, pump-action shotgun regularly used for repelling boarding parties in close range scenarios."
	item_cost = 52
	path = /obj/item/gun/projectile/shotgun/pump
	antag_roles = list(/decl/special_role/mercenary)

/datum/uplink_item/item/visible_weapons/flechetterifle
	name = "Flechette Rifle"
	desc = "A railgun with two toggleable fire modes, able to launch flechette ammunition at incredible speeds."
	item_cost = 60
	path = /obj/item/gun/magnetic/railgun/flechette
	antag_roles = list(/decl/special_role/mercenary)

/datum/uplink_item/item/visible_weapons/railgun // Like a semi-auto AMR
	name = "Railgun"
	desc = "An anti-armour magnetic launching system fed by a high-capacity matter cartridge, \
			capable of firing slugs at intense speeds."
	item_cost = DEFAULT_TELECRYSTAL_AMOUNT - (DEFAULT_TELECRYSTAL_AMOUNT - (DEFAULT_TELECRYSTAL_AMOUNT % 6)) / 6
	antag_roles = list(/decl/special_role/mercenary)
	path = /obj/item/gun/magnetic/railgun

// Grenades
/datum/uplink_item/item/grenades/frag_high_yield
	name = "Fragmentation Bomb"
	item_cost = 24
	antag_roles = list(/decl/special_role/mercenary) // yeah maybe regular traitors shouldn't be able to get these
	path = /obj/item/grenade/frag/high_yield

/datum/uplink_item/item/grenades/fragshell
	name = "1x Fragmentation Shell"
	desc = "Weaker than standard fragmentation grenades, these devices can be fired from a grenade launcher."
	item_cost = 10
	antag_roles = list(/decl/special_role/mercenary)
	path = /obj/item/grenade/frag/shell

/datum/uplink_item/item/grenades/fragshells
	name = "5x Fragmentation Shells"
	desc = "Weaker than standard fragmentation grenades, these devices can be fired from a grenade launcher."
	item_cost = 40
	antag_roles = list(/decl/special_role/mercenary)
	path = /obj/item/box/fragshells

/datum/uplink_item/item/grenades/frag
	name = "1x Fragmentation Grenade"
	item_cost = 10
	antag_roles = list(/decl/special_role/mercenary)
	path = /obj/item/grenade/frag

/datum/uplink_item/item/grenades/frags
	name = "5x Fragmentation Grenades"
	item_cost = 40
	antag_roles = list(/decl/special_role/mercenary)
	path = /obj/item/box/frags

// Hardsuit Modules
/datum/uplink_item/item/hardsuit_modules/laser_canon
	name = "\improper Mounted Laser Cannon"
	desc = "A module capable of draining your suit's power reserves in order to fire a shoulder mounted laser cannon."
	item_cost = 64
	path = /obj/item/rig_module/mounted/lcannon
	antag_roles = list(/decl/special_role/mercenary)

// Devices and Tools
/datum/uplink_item/item/tools/teleporter
	name = "Teleporter Circuit Board"
	desc = "A circuit board that can be used to create a teleporter console, able to lock onto detected \
	teleportation beacons. Requires a projector and teleporter hub nearby to work."
	item_cost = 40
	path = /obj/item/stock_parts/circuitboard/teleporter
	antag_roles = list(/decl/special_role/mercenary)

// Badassery
/**************************
* Mercenary Surplus Crate *
**************************/
/datum/uplink_item/item/badassery/surplus
	name = "\improper Surplus Crate"
	item_cost = DEFAULT_TELECRYSTAL_AMOUNT * 4
	antag_roles = list(/decl/special_role/mercenary)
	var/item_worth = DEFAULT_TELECRYSTAL_AMOUNT * 6
	var/icon

/datum/uplink_item/item/badassery/surplus/New()
	..()
	desc = "A crate containing [item_worth] telecrystal\s worth of surplus leftovers. If you can find some help to pay for it, you might strike gold."

/datum/uplink_item/item/badassery/surplus/get_goods(var/obj/item/uplink/the_uplink, var/loc)
	var/obj/structure/largecrate/the_crate = new(loc)
	var/random_items = get_random_uplink_items(the_uplink, item_worth, the_crate)
	for(var/datum/uplink_item/orderable in random_items)
		orderable.purchase_log(the_uplink)
		orderable.get_goods(the_uplink, the_crate)
	return the_crate

/datum/uplink_item/item/badassery/surplus/log_icon()
	if(!icon)
		var/obj/structure/largecrate/C = /obj/structure/largecrate
		icon = image(initial(C.icon), initial(C.icon_state))
	return html_icon(icon)

// Overrides
/datum/uplink_item/item/tools/camera_mask/New()
	..()
	LAZYSET(antag_costs, /decl/special_role/mercenary, 30)

// These couldn't be rolled by non-mercs anyway, because that checks can_buy, which checks the allowed/excluded antag lists.
/datum/uplink_random_selection/default/New()
	..()
	items += new/datum/uplink_random_item(/datum/uplink_item/item/visible_weapons/heavysniper, 15, 0)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/tools/teleporter, 10, 0)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/hardsuit_modules/laser_canon, reselect_probability = 5)

/datum/uplink_random_selection/blacklist/New()
	// do this before parent stuff just in case
	LAZYADD(blacklist, /datum/uplink_item/item/tools/teleporter)
	..()