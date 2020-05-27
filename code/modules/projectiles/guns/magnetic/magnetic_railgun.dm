/obj/item/gun/magnetic/railgun
	name = "railgun"
	desc = "The HelTek Arms LM-76 Thunderclap. A portable linear motor cannon produced during the Gaia Conflict for anti-armour and anti-fortification operations. Today, it sees wide use among private militaries, and is a staple on the black market."
	icon = 'icons/obj/guns/railgun.dmi'
	on_mob_icon = 'icons/obj/guns/railgun.dmi'
	removable_components = TRUE // Can swap out the capacitor for more shots, or cell for longer usage before recharge
	load_type = /obj/item/rcd_ammo
	origin_tech = "{'combat':5,'materials':4,'magnets':4}"
	projectile_type = /obj/item/projectile/bullet/magnetic/slug
	one_hand_penalty = 6
	power_cost = 300
	fire_delay = 35
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	loaded = /obj/item/rcd_ammo/large // ~30 shots
	combustion = 1
	bulk = GUN_BULK_RIFLE + 3

	var/initial_cell_type = /obj/item/cell/hyper
	var/initial_capacitor_type = /obj/item/stock_parts/capacitor/adv // 6-8 shots
	gun_unreliable = 0
	var/slowdown_held = 3
	var/slowdown_worn = 2

/obj/item/gun/magnetic/railgun/Initialize()

	capacitor = new initial_capacitor_type(src)
	capacitor.charge = capacitor.max_charge

	cell = new initial_cell_type(src)
	if (ispath(loaded))
		loaded = new loaded (src, load_sheet_max)
	slowdown_per_slot[slot_l_hand] =  slowdown_held
	slowdown_per_slot[slot_r_hand] =  slowdown_held
	slowdown_per_slot[slot_back] =    slowdown_worn
	slowdown_per_slot[slot_belt] =    slowdown_worn
	slowdown_per_slot[slot_s_store] = slowdown_worn

	. = ..()

// Not going to check type repeatedly, if you code or varedit
// load_type and get runtime errors, don't come crying to me.
/obj/item/gun/magnetic/railgun/show_ammo(var/mob/user)
	var/obj/item/rcd_ammo/ammo = loaded
	if (ammo)
		to_chat(user, "<span class='notice'>There are [ammo.remaining] shot\s remaining in \the [loaded].</span>")
	else
		to_chat(user, "<span class='notice'>There is nothing loaded.</span>")

/obj/item/gun/magnetic/railgun/check_ammo()
	var/obj/item/rcd_ammo/ammo = loaded
	return ammo && ammo.remaining

/obj/item/gun/magnetic/railgun/use_ammo()
	var/obj/item/rcd_ammo/ammo = loaded
	ammo.remaining--
	if(ammo.remaining <= 0)
		spawn(3)
			playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 1)
		out_of_ammo()

/obj/item/gun/magnetic/railgun/proc/out_of_ammo()
	qdel(loaded)
	loaded = null
	visible_message("<span class='warning'>\The [src] beeps and ejects its empty cartridge.</span>")

/obj/item/gun/magnetic/railgun/flechette
	name = "flechette gun"
	desc = "The MI-12 Skadi is a burst fire capable railgun that fires flechette rounds at high velocity. Deadly against armour, but much less effective against soft targets."
	on_mob_icon = 'icons/obj/guns/flechette.dmi'
	icon = 'icons/obj/guns/flechette.dmi'
	one_hand_penalty = 2
	fire_delay = 8
	removable_components = FALSE
	initial_cell_type = /obj/item/cell/hyper
	initial_capacitor_type = /obj/item/stock_parts/capacitor/adv
	slot_flags = SLOT_BACK
	power_cost = 100
	load_type = /obj/item/magnetic_ammo
	projectile_type = /obj/item/projectile/bullet/magnetic/flechette
	loaded = /obj/item/magnetic_ammo
	material = MAT_STEEL
	matter = list(
		MAT_GOLD = MATTER_AMOUNT_REINFORCEMENT,
		MAT_SILVER = MATTER_AMOUNT_TRACE,
		MAT_DIAMOND = MATTER_AMOUNT_TRACE
	)
	firemodes = list(
		list(mode_name="semiauto",    burst=1, fire_delay=0,     one_hand_penalty=1, burst_accuracy=null, dispersion=null),
		list(mode_name="short bursts", burst=3, fire_delay=null, one_hand_penalty=2, burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 0.6, 1.0)),
		)

/obj/item/gun/magnetic/railgun/flechette/out_of_ammo()
	visible_message("<span class='warning'>\The [src] beeps to indicate the magazine is empty.</span>")
