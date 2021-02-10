/obj/item/gun/long/railgun
	name = "railgun"
	desc = "The HelTek Arms LM-76 Thunderclap. A portable linear motor cannon produced during the Gaia Conflict for anti-armour and anti-fortification operations. Today, it sees wide use among private militaries, and is a staple on the black market."
	icon = 'icons/obj/guns/railgun.dmi'
	origin_tech = "{'combat':5,'materials':4,'magnets':4}"
	barrel = /obj/item/firearm_component/barrel/magnetic/railgun
	receiver = /obj/item/firearm_component/receiver/magnetic/railgun
	fire_delay = 35
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK

/obj/item/gun/long/railgun/flechette
	name = "flechette gun"
	desc = "The MI-12 Skadi is a burst fire capable railgun that fires flechette rounds at high velocity. Deadly against armour, but much less effective against soft targets."
	icon = 'icons/obj/guns/flechette.dmi'
	fire_delay = 8
	slot_flags = SLOT_BACK
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/metal/gold = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/silver = MATTER_AMOUNT_TRACE,
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_TRACE
	)
	barrel = /obj/item/firearm_component/barrel/magnetic/railgun/flechette
	receiver = /obj/item/firearm_component/receiver/magnetic/railgun/flechette
