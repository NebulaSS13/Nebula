// Used to deploy the bacon.
/obj/item/supply_beacon
	name = "inactive supply beacon"
	icon = 'icons/obj/supplybeacon.dmi'
	desc = "An inactive, hacked supply beacon stamped with the Nyx Rapid Fabrication logo. Good for one (1) ballistic supply pod shipment."
	icon_state = "beacon"
	material = /decl/material/solid/metal/steel
	w_class = ITEM_SIZE_NO_CONTAINER

	var/deploy_path = /obj/structure/supply_beacon
	var/deploy_time = 30

/obj/item/supply_beacon/supermatter
	name = "inactive supermatter supply beacon"
	deploy_path = /obj/structure/supply_beacon/supermatter

/obj/item/supply_beacon/attack_self(var/mob/user)
	user.visible_message(SPAN_NOTICE("\The [user] begins setting up \the [src]."))
	if(!do_after(user, deploy_time, src))
		return
	if(!user.try_unequip(src))
		return
	var/obj/S = new deploy_path(get_turf(user))
	user.visible_message(SPAN_NOTICE("\The [user] deploys \the [S]."))
	qdel(src)

/obj/structure/supply_beacon
	name = "supply beacon"
	desc = "A bulky long-distance supply beacon. Someone has been messing with the wiring."
	icon = 'icons/obj/supplybeacon.dmi'
	icon_state = "beacon"
	anchored = FALSE
	density =  TRUE
	material = /decl/material/solid/metal/steel

	var/drop_type
	var/expended =   FALSE
	var/activated =  FALSE
	var/drop_delay = 45 SECONDS
	var/target_drop_time

/obj/structure/supply_beacon/Initialize()
	. = ..()
	if(!drop_type)
		drop_type = pick(supply_drop_random_loot_types())

/obj/structure/supply_beacon/supermatter
	name = "supermatter supply beacon"
	drop_type = "supermatter"

/obj/structure/supply_beacon/attackby(var/obj/item/W, var/mob/user)
	if(!activated && IS_WRENCH(W))
		anchored = !anchored
		user.visible_message(SPAN_NOTICE("\The [user] [anchored ? "secures" : "unsecures"] \the [src]."))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		return TRUE
	return ..()

/obj/structure/supply_beacon/attack_hand(var/mob/user)
	if(!user.check_dexterity(DEXTERITY_SIMPLE_MACHINES, TRUE))
		return ..()
	if(expended)
		to_chat(user, SPAN_WARNING("\The [src] has used up its charge."))
		return TRUE
	if(!anchored)
		to_chat(user, SPAN_WARNING("You need to secure \the [src] with a wrench first!"))
		return TRUE
	if(activated)
		deactivate(user)
	else
		activate(user)
	return TRUE

/obj/structure/supply_beacon/proc/activate(var/mob/user)
	if(expended)
		return
	set_light(3, 3, "#00ccaa")
	icon_state = "beacon_active"
	activated = TRUE
	START_PROCESSING(SSobj, src)
	admin_attacker_log(user, "has activated \a [src] at [get_area_name(src)]")
	if(user)
		to_chat(user, SPAN_NOTICE("You activate \the [src]. The supply drop will be dispatched soon."))

/obj/structure/supply_beacon/proc/deactivate(var/mob/user, var/permanent)
	if(permanent)
		expended = 1
		icon_state = "beacon_depleted"
	else
		icon_state = "beacon"

	set_light(0)
	activated = FALSE
	STOP_PROCESSING(SSobj, src)
	target_drop_time = null
	if(user)
		to_chat(user, SPAN_NOTICE("You deactivate \the [src]."))

/obj/structure/supply_beacon/Destroy()
	if(activated)
		deactivate()
	return ..()

/obj/structure/supply_beacon/Process()
	if(expended || !activated)
		return PROCESS_KILL
	if(!target_drop_time)
		target_drop_time = world.time + drop_delay
	if(world.time >= target_drop_time)
		deactivate(permanent = TRUE)
		command_announcement.Announce("Nyx Rapid Fabrication priority supply request #[rand(1000,9999)]-[rand(100,999)] recieved. Shipment dispatched via ballistic supply pod for immediate delivery. Have a nice day.", "Thank You For Your Patronage")
		addtimer(CALLBACK(src, .proc/drop_cargo), rand(20 SECONDS, 30 SECONDS))

/obj/structure/supply_beacon/proc/drop_cargo(var/drop_x, var/drop_y, var/drop_z)
	if(!QDELETED(src) && isturf(loc))
		var/turf/T = loc
		new /datum/random_map/droppod/supply(T.x-2, T.y-2, T.z, supplied_drop = drop_type) // Splat.
