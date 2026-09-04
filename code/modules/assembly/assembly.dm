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
	var/obj/item/assembly_holder/holder = null // currently can be a TTV or assemblyholder, todo make ttv use assemblyholder
	var/cooldown = 0//To prevent spam
	var/wires = WIRE_RECEIVE | WIRE_PULSE

	var/const/WIRE_RECEIVE = 1			//Allows Pulsed(0) to call Activate()
	var/const/WIRE_PULSE = 2				//Allows Pulse(0) to act on the holder
	var/const/WIRE_PULSE_SPECIAL = 4		//Allows Pulse(0) to act on the holders special assembly
	var/const/WIRE_RADIO_RECEIVE = 8		//Allows Pulsed(1) to call Activate()
	var/const/WIRE_RADIO_PULSE = 16		//Allows Pulse(1) to send a radio message

/obj/item/assembly/Destroy()
	if(holder)
		if(istype(holder))
			if(holder.a_left == src)
				holder.a_left = null
			if(holder.a_right == src)
				holder.a_right = null
		if(istype(holder, /datum) && !QDELETED(holder))
			// the holder has the responsibility to clear its associated vars on destroy
			qdel(holder)
		holder = null
	return ..()

/// What the device does when turned on
/obj/item/assembly/proc/activate()
	if(!secured || (cooldown > 0))	return 0
	cooldown = 2
	spawn(10)
		process_cooldown()
	return 1

/// Code that has to happen when the assembly is un\secured goes here
/obj/item/assembly/proc/toggle_secure()
	secured = !secured
	update_icon()
	return secured

/// Called when an assembly is attacked by another
/obj/item/assembly/proc/attach_assembly(var/obj/item/A, var/mob/user)
	holder = new/obj/item/assembly_holder(get_turf(src))
	if(holder.attach(A,src,user))
		to_chat(user, "<span class='notice'>You attach \the [A] to \the [src]!</span>")
		return 1
	return 0

/// Called when the holder is moved
/obj/item/assembly/proc/holder_movement()
	return

/// Called via spawn(10) to have it count down the cooldown var
/// This is really bad. Please just make it process...
/obj/item/assembly/proc/process_cooldown()
	cooldown--
	if(cooldown <= 0)	return 0
	spawn(10)
		process_cooldown()
	return 1

/// Called when another assembly acts on this one, var/radio will determine where it came from for wire calcs
/obj/item/assembly/proc/pulsed(var/radio = 0)
	if(holder && (wires & WIRE_RECEIVE))
		activate()
	if(radio && (wires & WIRE_RADIO_RECEIVE))
		activate()
	return 1

/// Called when this device attempts to act on another device, var/radio determines if it was sent via radio or direct
/obj/item/assembly/proc/pulse_device(var/radio = 0)
	if(holder && (wires & WIRE_PULSE))
		holder.process_activation(src, 1, 0)
	if(holder && (wires & WIRE_PULSE_SPECIAL))
		holder.process_activation(src, 0, 1)
//		if(radio && (wires & WIRE_RADIO_PULSE))
		//Not sure what goes here quite yet send signal?
	return 1

/obj/item/assembly/attackby(obj/item/used_item, mob/user)
	if(!user_can_attack_with(user) || !used_item.user_can_attack_with(user))
		return TRUE
	if(isassembly(used_item))
		var/obj/item/assembly/assembly = used_item
		if(!assembly.secured && !secured)
			attach_assembly(assembly, user)
			return TRUE
	if(IS_SCREWDRIVER(used_item))
		if(toggle_secure())
			to_chat(user, SPAN_NOTICE("\The [src] is ready!"))
		else
			to_chat(user, SPAN_NOTICE("\The [src] can now be attached!"))
		return TRUE
	return ..()


/obj/item/assembly/Process()
	return PROCESS_KILL


/obj/item/assembly/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(distance <= 1 || loc == user)
		if(secured)
			. += "\The [src] is ready!"
		else
			. += "\The [src] can be attached!"


/obj/item/assembly/attack_self(mob/user)
	if(!user) // is this check even necessary outside of admin proccalls?
		return FALSE
	if(!user_can_attack_with(user))
		return TRUE
	user.set_machine(src)
	interact(user)
	return TRUE

/// Called when attack_self is called
/obj/item/assembly/interact(mob/user)
	return //HTML MENU FOR WIRES GOES HERE

/obj/item/assembly/nano_host()
	if(istype(loc, /obj/item/assembly_holder))
		return loc.nano_host()
	return ..()
