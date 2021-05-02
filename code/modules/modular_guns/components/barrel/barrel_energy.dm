/obj/item/firearm_component/barrel/energy
	var/projectile_type = /obj/item/projectile/beam/practice
	var/charge_cost = 20 //How much energy is needed to fire.

/obj/item/firearm_component/barrel/energy/get_projectile_type()
	return projectile_type

/obj/item/firearm_component/barrel/energy/crossbow
	projectile_type = /obj/item/projectile/energy/bolt
	silenced = SILENCER_INHERENT
	fire_sound = 'sound/weapons/Genhit.ogg'

/obj/item/firearm_component/barrel/energy/crossbow/ninja
	projectile_type = /obj/item/projectile/energy/dart

/obj/item/firearm_component/barrel/energy/crossbow/large
	projectile_type = /obj/item/projectile/energy/bolt/large
	one_hand_penalty = 1

/obj/item/firearm_component/barrel/energy/sidearm
	projectile_type = /obj/item/projectile/beam/stun

/obj/item/firearm_component/barrel/energy/sidearm/small
	w_class = ITEM_SIZE_SMALL
	force = 2 //it's the size of a car key, what did you expect?

/obj/item/firearm_component/barrel/energy/plasma
	projectile_type = /obj/item/projectile/energy/plasmastun

/obj/item/firearm_component/barrel/energy/incendiary
	projectile_type = /obj/item/projectile/beam/incendiary_laser

/obj/item/firearm_component/barrel/energy/confusion
	projectile_type = /obj/item/projectile/beam/confuseray

/obj/item/firearm_component/barrel/energy/electrolaser
	projectile_type = /obj/item/projectile/beam/stun
	combustion = 0

/obj/item/firearm_component/barrel/energy/plasmacutter
	projectile_type = /obj/item/projectile/beam/plasmacutter
	fire_sound = 'sound/weapons/plasma_cutter.ogg'

/obj/item/firearm_component/barrel/energy/plasmacutter/mounted

/obj/item/firearm_component/barrel/energy/floral
	projectile_type = /obj/item/projectile/energy/floramut
	charge_cost = 10

/obj/item/firearm_component/barrel/energy/heavy_stun
	projectile_type = /obj/item/projectile/beam/stun/heavy

/obj/item/firearm_component/barrel/energy/laser
	projectile_type = /obj/item/projectile/beam/midlaser
	one_hand_penalty = 2
	bulk = GUN_BULK_RIFLE

/obj/item/firearm_component/barrel/energy/laser/cannon
	projectile_type = /obj/item/projectile/beam/heavylaser
	one_hand_penalty = 6
	charge_cost = 40
	accuracy = 2

/obj/item/firearm_component/barrel/energy/laser/cannon/mounted
 	accuracy = 0

/obj/item/firearm_component/barrel/energy/laser/antique
	projectile_type = /obj/item/projectile/beam

/obj/item/firearm_component/barrel/energy/laser/practice
	projectile_type = /obj/item/projectile/beam/practice
	charge_cost = 10

/*

/obj/item/gun/long/laser/secure/on_update_icon()
	. = ..()
	overlays += mutable_appearance(icon, "[icon_state]_stripe", COLOR_BLUE_GRAY)

/obj/item/gun/long/laser/practice/on_update_icon()
	. = ..()
	overlays += mutable_appearance(icon, "[icon_state]_stripe", COLOR_ORANGE)

/obj/item/gun/long/laser/practice/proc/hacked()
	return projectile_type != /obj/item/projectile/beam/practice

/obj/item/gun/long/laser/practice/emag_act(var/remaining_charges, var/mob/user, var/emag_source)
	if(hacked())
		return NO_EMAG_ACT
	to_chat(user, "<span class='warning'>You disable the safeties on [src] and crank the output to the lethal levels.</span>")
	desc += " Its safeties are disabled and output is set to dangerous levels."
	projectile_type = /obj/item/projectile/beam/midlaser
	charge_cost = 20
	max_shots = rand(3,6) //will melt down after those
	return 1

/obj/item/gun/long/laser/practice/handle_post_fire(mob/user, atom/target, var/pointblank=0, var/reflex=0)
	..()
	if(hacked())
		max_shots--
		if(!max_shots) //uh hoh gig is up
			to_chat(user, "<span class='danger'>\The [src] sizzles in your hands, acrid smoke rising from the firing end!</span>")
			desc += " The optical pathway is melted and useless."
			projectile_type = null
*/

/obj/item/firearm_component/barrel/energy/chameleon
	projectile_type = /obj/item/projectile/chameleon
	charge_cost = 20 //uses next to no power, since it's just holograms
	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'

/*
	var/obj/item/projectile/copy_projectile
	var/global/list/gun_choices

/obj/item/gun/hand/chameleon/Initialize()
	. = ..()
	if(!gun_choices)
		gun_choices = generate_chameleon_choices(/obj/item/gun)

/obj/item/gun/hand/chameleon/consume_next_projectile()
	var/obj/item/projectile/P = ..()
	if(P && ispath(copy_projectile))
		P.SetName(initial(copy_projectile.name))
		P.icon = initial(copy_projectile.icon)
		P.icon_state = initial(copy_projectile.icon_state)
		P.pass_flags = initial(copy_projectile.pass_flags)
		P.hitscan = initial(copy_projectile.hitscan)
		P.step_delay = initial(copy_projectile.step_delay)
		P.muzzle_type = initial(copy_projectile.muzzle_type)
		P.tracer_type = initial(copy_projectile.tracer_type)
		P.impact_type = initial(copy_projectile.impact_type)
	return P

/obj/item/gun/hand/chameleon/OnDisguise(var/obj/item/gun/copy)
	if(!istype(copy))
		return

	flags_inv = copy.flags_inv
	fire_sound = copy.fire_sound
	fire_sound_text = copy.fire_sound_text
	icon = copy.icon

	copy_projectile = null
	var/obj/item/gun/E = copy
	if(istype(E))
		copy_projectile = E.get_projectile_type()

/obj/item/gun/hand/chameleon/verb/change(picked in gun_choices)
	set name = "Change Gun Appearance"
	set category = "Chameleon Items"
	set src in usr

	if (!(usr.incapacitated()))
		if(!ispath(gun_choices[picked]))
			return

		disguise(gun_choices[picked], usr)

	//so our overlays update.
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_hands()
*/

/obj/item/firearm_component/barrel/energy/radpistol
	projectile_type = /obj/item/projectile/energy/radiation

/obj/item/firearm_component/barrel/energy/decloner
	projectile_type = /obj/item/projectile/energy/declone
	combustion = 0

/obj/item/firearm_component/barrel/energy/ionrifle
	charge_cost = 30
	projectile_type = /obj/item/projectile/ion
	one_hand_penalty = 4

/obj/item/firearm_component/barrel/energy/laser/dogan
/*
/obj/item/gun/long/laser/dogan/consume_next_projectile()
	projectile_type = pick(/obj/item/projectile/beam/midlaser, /obj/item/projectile/beam/lastertag/red, /obj/item/projectile/beam)
	return ..()
*/

/obj/item/firearm_component/barrel/energy/sniper
	projectile_type = /obj/item/projectile/beam/sniper
	one_hand_penalty = 5 // The weapon itself is heavy, and the long barrel makes it hard to hold steady with just one hand.
	charge_cost = 40
	accuracy = -2 //shooting at the hip
	scoped_accuracy = 9
	scope_zoom = 2

/obj/item/firearm_component/barrel/energy/lasertag
	projectile_type = /obj/item/projectile/beam/lastertag/blue

/obj/item/firearm_component/barrel/energy/lasertag/blue
	projectile_type = /obj/item/projectile/beam/lastertag/blue

/obj/item/firearm_component/barrel/energy/lasertag/red
	projectile_type = /obj/item/projectile/beam/lastertag/red

/obj/item/firearm_component/barrel/energy/pulse
	projectile_type = /obj/item/projectile/beam/pulse
	accuracy = -1

/obj/item/firearm_component/barrel/energy/temperature
	one_hand_penalty = 2
	charge_cost = 10
	projectile_type = /obj/item/projectile/temp
	fire_sound = 'sound/weapons/pulse3.ogg'
	var/firing_temperature = T20C
	var/current_temperature = T20C

/*
/obj/item/gun/long/temperature/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)


/obj/item/gun/long/temperature/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/gun/long/temperature/Topic(user, href_list, state = global.inventory_topic_state)
	..()

/obj/item/gun/long/temperature/OnTopic(user, href_list)
	if(href_list["temp"])
		var/amount = text2num(href_list["temp"])
		if(amount > 0)
			src.current_temperature = min(500, src.current_temperature+amount)
		else
			src.current_temperature = max(0, src.current_temperature+amount)
		if(current_temperature < T0C)
			indicator_color = COLOR_LUMINOL
		else if(current_temperature > T0C + 100)
			indicator_color = COLOR_ORANGE
		else
			indicator_color = COLOR_GREEN
		. = TOPIC_REFRESH

		update_icon()
		attack_self(user)

/obj/item/gun/long/temperature/Process()
	switch(firing_temperature)
		if(0 to 100) charge_cost = 100
		if(100 to 250) charge_cost = 50
		if(251 to 300) charge_cost = 10
		if(301 to 400) charge_cost = 50
		if(401 to 500) charge_cost = 100

	if(current_temperature != firing_temperature)
		var/difference = abs(current_temperature - firing_temperature)
		if(difference >= 10)
			if(current_temperature < firing_temperature)
				firing_temperature -= 10
			else
				firing_temperature += 10
		else
			firing_temperature = current_temperature
*/
