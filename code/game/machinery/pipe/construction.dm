/*CONTENTS
Buildable pipes
Buildable meters
*/

/obj/item/pipe
	name = "pipe"
	desc = "A pipe."
	var/pipename
	var/connect_types = CONNECT_TYPE_REGULAR
	force = 7
	icon = 'icons/obj/pipe-item.dmi'
	icon_state = "simple"
	randpixel = 5
	item_state = "buildpipe"
	w_class = ITEM_SIZE_NORMAL
	level = 2
	obj_flags = OBJ_FLAG_ROTATABLE
	dir = SOUTH
	var/constructed_path = /obj/machinery/atmospherics/pipe/simple/hidden
	var/pipe_class = PIPE_CLASS_BINARY
	var/rotate_class = PIPE_ROTATE_STANDARD

/obj/item/pipe/Initialize(var/mapload, var/obj/machinery/atmospherics/P)
	. = ..(mapload, null)
	set_extension(src, /datum/extension/parts_stash)
	if(!istype(P))
		return
	if(!P.dir)
		set_dir(SOUTH)
	else
		set_dir(P.dir)
	SetName(P.name)
	desc = P.desc

	connect_types = P.connect_types
	color = P.pipe_color
	icon = P.build_icon
	icon_state = P.build_icon_state
	pipe_class = P.pipe_class
	rotate_class = P.rotate_class
	constructed_path = P.base_type || P.type

//called when a turf is attacked with a pipe item
/obj/item/pipe/afterattack(turf/simulated/floor/target, mob/user, proximity)
	if(!proximity) return
	if(istype(target))
		user.unEquip(src, target)
	else
		return ..()

/obj/item/pipe/rotate(mob/user)
	. = ..()
	sanitize_dir()

/obj/item/pipe/Move()
	var/old_dir = dir
	. = ..()
	set_dir(old_dir)

/obj/item/pipe/proc/sanitize_dir()
	switch(rotate_class)
		if(PIPE_ROTATE_TWODIR)
			if(dir==2)
				set_dir(1)
			else if(dir==8)
				set_dir(4)
		if(PIPE_ROTATE_ONEDIR)
			set_dir(2)

/obj/item/pipe/attack_self(mob/user)
	return rotate(user)

/obj/item/pipe/attackby(var/obj/item/W, var/mob/user)
	if(!isWrench(W))
		return ..()
	if (!isturf(loc))
		return 1
	construct_pipe(user)
	return TRUE

/obj/item/pipe/proc/construct_pipe(mob/user)
	sanitize_dir()
	var/obj/machinery/atmospherics/fake_machine = constructed_path
	var/pipe_dir = base_pipe_initialize_directions(dir, initial(fake_machine.connect_dir_type))

	for(var/obj/machinery/atmospherics/M in loc)
		if((M.initialize_directions & pipe_dir) && M.check_connect_types_construction(M,src))	// matches at least one direction on either type of pipe & same connection type
			to_chat(user, "<span class='warning'>There is already a pipe of the same type at this location.</span>")
			return
	// no conflicts found

	var/obj/machinery/atmospherics/P = new constructed_path(get_turf(src))
	var/datum/extension/parts_stash/stash = get_extension(src, /datum/extension/parts_stash)
	if(stash)
		stash.install_into(P)

	P.pipe_color = color
	P.set_dir(dir)
	P.set_initial_level()
	P.build(src)
	. = P

	playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
	if(user)
		user.visible_message( \
			"[user] fastens the [src].", \
			"<span class='notice'>You have fastened the [src].</span>", \
			"You hear ratchet.")
	qdel(src)	// remove the pipe item

/obj/item/machine_chassis
	var/build_type

/obj/item/machine_chassis/Initialize()
	. = ..()
	set_extension(src, /datum/extension/parts_stash)

/obj/item/machine_chassis/examine(mob/user, distance)
	. = ..()
	if(distance <= 2)
		to_chat(user, "Use a wrench to secure \the [src] here.")

/obj/item/machine_chassis/attackby(var/obj/item/W, var/mob/user)
	if(!isWrench(W))
		return ..()
	var/obj/machinery/machine = new build_type(get_turf(src), dir, TRUE)
	var/datum/extension/parts_stash/stash = get_extension(src, /datum/extension/parts_stash)
	if(stash)
		stash.install_into(machine)
	if(machine.construct_state)
		machine.construct_state.post_construct(machine)
	playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
	to_chat(user, "<span class='notice'>You have fastened the [src].</span>")
	qdel(src)

/obj/item/machine_chassis/air_sensor
	name = "gas sensor"
	desc = "A sensor. It detects gasses."
	icon = 'icons/obj/machines/gas_sensor.dmi'
	icon_state = "gsensor1"
	w_class = ITEM_SIZE_LARGE
	build_type = /obj/machinery/air_sensor

/obj/item/machine_chassis/air_sensor/base
	build_type = /obj/machinery/air_sensor/buildable

/obj/item/machine_chassis/pipe_meter
	name = "meter"
	desc = "A meter that can measure gas inside pipes or in the general area."
	icon = 'icons/obj/pipe-item.dmi'
	icon_state = "meter"
	item_state = "buildpipe"
	w_class = ITEM_SIZE_LARGE
	build_type = /obj/machinery/meter

/obj/item/machine_chassis/pipe_meter/base
	build_type = /obj/machinery/meter/buildable

/obj/item/machine_chassis/igniter
	name = "igniter"
	desc = "A device which will ignite surrounding gasses."
	icon = 'icons/obj/machines/igniter.dmi'
	icon_state = "igniter1"
	w_class = ITEM_SIZE_NORMAL
	build_type = /obj/machinery/igniter

/obj/item/machine_chassis/igniter/base
	build_type = /obj/machinery/igniter/buildable

/obj/item/machine_chassis/power_sensor
	name = "power sensor"
	desc = "A small machine which transmits data about specific powernet."
	icon = 'icons/obj/objects.dmi'
	icon_state = "floor_beacon" // If anyone wants to make better sprite, feel free to do so without asking me.
	w_class = ITEM_SIZE_NORMAL
	build_type = /obj/machinery/power/sensor