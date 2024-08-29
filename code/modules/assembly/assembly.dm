/obj/item/assembly
	name = "assembly"
	desc = "A small electronic device that should never exist."
	icon = 'icons/obj/assemblies/new_assemblies.dmi'
	icon_state = ""
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	w_class = ITEM_SIZE_SMALL
	material = /decl/material/solid/metal/steel
	throw_speed = 3
	throw_range = 10
	origin_tech = @'{"magnets":1}'

	var/secured = 1
	var/list/attached_overlays = null
	var/obj/item/assembly_holder/holder = null
	var/cooldown = 0//To prevent spam
	var/wires = WIRE_RECEIVE | WIRE_PULSE

	var/const/WIRE_RECEIVE = 1			//Allows Pulsed(0) to call Activate()
	var/const/WIRE_PULSE = 2				//Allows Pulse(0) to act on the holder
	var/const/WIRE_PULSE_SPECIAL = 4		//Allows Pulse(0) to act on the holders special assembly
	var/const/WIRE_RADIO_RECEIVE = 8		//Allows Pulsed(1) to call Activate()
	var/const/WIRE_RADIO_PULSE = 16		//Allows Pulse(1) to send a radio message

/obj/item/assembly/Destroy()
	if(!QDELETED(holder))
		if(holder.a_left == src)
			holder.a_left = null
		if(holder.a_right == src)
			holder.a_right = null
		QDEL_NULL(holder)
	else
		holder = null
	return ..()

/// What the device does when turned on
/obj/item/assembly/proc/activate()
	return

/// Called when another assembly acts on this one, var/radio will determine where it came from for wire calcs
/obj/item/assembly/proc/pulsed(var/radio = 0)
	return

/// Called when this device attempts to act on another device, var/radio determines if it was sent via radio or direct
/obj/item/assembly/proc/pulse_device(var/radio = 0)
	return

/// Code that has to happen when the assembly is un\secured goes here
/obj/item/assembly/proc/toggle_secure()
	return

/// Called when an assembly is attacked by another
/obj/item/assembly/proc/attach_assembly(var/obj/A, var/mob/user)
	return

/// Called via spawn(10) to have it count down the cooldown var
/obj/item/assembly/proc/process_cooldown()
	return

/// Called when the holder is moved
/obj/item/assembly/proc/holder_movement()
	return

/// Called when attack_self is called
/obj/item/assembly/interact(mob/user)
	return

/obj/item/assembly/process_cooldown()
	cooldown--
	if(cooldown <= 0)	return 0
	spawn(10)
		process_cooldown()
	return 1


/obj/item/assembly/pulsed(var/radio = 0)
	if(holder && (wires & WIRE_RECEIVE))
		activate()
	if(radio && (wires & WIRE_RADIO_RECEIVE))
		activate()
	return 1


/obj/item/assembly/pulse_device(var/radio = 0)
	if(holder && (wires & WIRE_PULSE))
		holder.process_activation(src, 1, 0)
	if(holder && (wires & WIRE_PULSE_SPECIAL))
		holder.process_activation(src, 0, 1)
//		if(radio && (wires & WIRE_RADIO_PULSE))
		//Not sure what goes here quite yet send signal?
	return 1


/obj/item/assembly/activate()
	if(!secured || (cooldown > 0))	return 0
	cooldown = 2
	spawn(10)
		process_cooldown()
	return 1


/obj/item/assembly/toggle_secure()
	secured = !secured
	update_icon()
	return secured


/obj/item/assembly/attach_assembly(var/obj/item/assembly/A, var/mob/user)
	holder = new/obj/item/assembly_holder(get_turf(src))
	if(holder.attach(A,src,user))
		to_chat(user, "<span class='notice'>You attach \the [A] to \the [src]!</span>")
		return 1
	return 0


/obj/item/assembly/attackby(obj/item/component, mob/user)
	if(!user_can_attack_with(user) || !component.user_can_attack_with(user))
		return TRUE
	if(isassembly(component))
		var/obj/item/assembly/assembly = component
		if(!assembly.secured && !secured)
			attach_assembly(assembly, user)
			return
	if(IS_SCREWDRIVER(component))
		if(toggle_secure())
			to_chat(user, SPAN_NOTICE("\The [src] is ready!"))
		else
			to_chat(user, SPAN_NOTICE("\The [src] can now be attached!"))
		return
	..()
	return


/obj/item/assembly/Process()
	return PROCESS_KILL


/obj/item/assembly/examine(mob/user, distance)
	. = ..()
	if(distance <= 1 || loc == user)
		if(secured)
			to_chat(user, "\The [src] is ready!")
		else
			to_chat(user, "\The [src] can be attached!")


/obj/item/assembly/attack_self(mob/user)
	if(!user) // is this check even necessary outside of admin proccalls?
		return FALSE
	if(!user_can_attack_with(user))
		return TRUE
	user.set_machine(src)
	interact(user)
	return TRUE

/obj/item/assembly/interact(mob/user)
	return //HTML MENU FOR WIRES GOES HERE

/obj/item/assembly/nano_host()
	if(istype(loc, /obj/item/assembly_holder))
		return loc.nano_host()
	return ..()
