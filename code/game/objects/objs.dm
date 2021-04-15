/obj
	layer = OBJ_LAYER
	animate_movement = 2

	var/obj_flags
	var/list/req_access
	var/w_class // Size of the object.
	var/unacidable = 0 //universal "unacidabliness" var, here so you can use it in any obj.
	var/throwforce = 1
	var/sharp = 0		// whether this object cuts
	var/edge = 0		// whether this object is more likely to dismember
	var/in_use = 0 // If we have a user using us, this will be set on. We will check if the user has stopped using us, and thus stop updating and LAGGING EVERYTHING!
	var/damtype = "brute"
	var/armor_penetration = 0
	var/anchor_fall = FALSE
	var/holographic = 0 //if the obj is a holographic object spawned by the holodeck

/obj/hitby(atom/movable/AM, var/datum/thrownthing/TT)
	..()
	if(!anchored)
		step(src, AM.last_move)

// Not called by base /obj, called by /obj/item, /obj/structure and /obj/machinery.
/obj/proc/create_material_composition(var/primary_material, var/reinforcement_material)

	var/matter_amount_modifier = get_matter_amount_modifier()
	var/list/matter = get_material_composition()

	if(!islist(matter))
		matter = list()
	else if(length(matter))
		for(var/mat in matter)
			matter[mat] = matter[mat] * matter_amount_modifier

	if(length(matter))
		var/datum/materials/materials = set_material_composition(matter)
		if(materials)
			if(primary_material)
				materials.set_primary_material(primary_material)
			if(reinforcement_material)
				materials.set_reinforcing_material(reinforcement_material)
			return

	if(primary_material || reinforcement_material)
		var/list/comp = list()
		if(primary_material)
			comp[primary_material] = round(MATTER_AMOUNT_PRIMARY * matter_amount_modifier)
		if(reinforcement_material)
			comp[reinforcement_material] = round(MATTER_AMOUNT_SECONDARY * matter_amount_modifier)
		set_material_composition(comp)

/obj/proc/get_matter_list()
	var/datum/materials/matter = get_material_composition()
	return istype(matter) ? matter.matter : list()

/obj/proc/get_material_composition()
	return

/obj/proc/set_material_composition(var/list/new_materials)
	if(islist(new_materials) && length(new_materials))
		var/datum/materials/matter = get_material_composition()
		if(!istype(matter))
			matter = new(src)
		matter.set_material_composition(new_materials)
		return matter
	return null

/obj/Destroy()
	STOP_PROCESSING(SSobj, src)
	set_material_composition(null)
	return ..()

/obj/proc/get_matter_amount_modifier()
	. = ceil(w_class * 0.25)

/obj/item/proc/is_used_on(obj/O, mob/user)
	return

/obj/assume_air(datum/gas_mixture/giver)
	if(loc)
		return loc.assume_air(giver)
	else
		return null

/obj/remove_air(amount)
	if(loc)
		return loc.remove_air(amount)
	else
		return null

/obj/return_air()
	if(loc)
		return loc.return_air()
	else
		return null

/obj/proc/updateUsrDialog()
	if(in_use)
		var/is_in_use = 0
		var/list/nearby = viewers(1, src) | usr
		for(var/mob/M in nearby)
			if ((M.client && M.machine == src))
				if(CanUseTopic(M, DefaultTopicState()) > STATUS_CLOSE)
					is_in_use = 1
					interact(M)
				else
					M.unset_machine()
		in_use = is_in_use

/obj/proc/updateDialog()
	// Check that people are actually using the machine. If not, don't update anymore.
	if(in_use)
		var/list/nearby = viewers(1, src)
		var/is_in_use = 0
		for(var/mob/M in nearby)
			if ((M.client && M.machine == src))
				if(CanUseTopic(M, DefaultTopicState()) > STATUS_CLOSE)
					is_in_use = 1
					interact(M)
				else
					M.unset_machine()
		var/ai_in_use = AutoUpdateAI(src)

		if(!ai_in_use && !is_in_use)
			in_use = 0

/obj/attack_ghost(mob/user)
	ui_interact(user)
	..()

/obj/proc/interact(mob/user)
	return

/mob/proc/unset_machine()
	src.machine = null

/mob/proc/set_machine(var/obj/O)
	if(src.machine)
		unset_machine()
	src.machine = O
	if(istype(O))
		O.in_use = 1

/obj/item/proc/updateSelfDialog()
	var/mob/M = src.loc
	if(istype(M) && M.client && M.machine == src)
		src.attack_self(M)

/obj/proc/hide(var/hide)
	set_invisibility(hide ? INVISIBILITY_MAXIMUM : initial(invisibility))

/obj/proc/hides_under_flooring()
	return level == 1

/obj/proc/hear_talk(mob/M, text, verb, decl/language/speaking)
	if(talking_atom)
		talking_atom.catchMessage(text, M)
/*
	var/mob/mo = locate(/mob) in src
	if(mo)
		var/rendered = "<span class='game say'><span class='name'>[M.name]: </span> <span class='message'>[text]</span></span>"
		mo.show_message(rendered, 2)
		*/
	return

/obj/proc/see_emote(mob/M, text, var/emote_type)
	return

/obj/proc/show_message(msg, type, alt, alt_type)//Message, type of message (1 or 2), alternative message, alt message type (1 or 2)
	return

/obj/proc/damage_flags()
	. = 0
	if(has_edge(src))
		. |= DAM_EDGE
	if(is_sharp(src))
		. |= DAM_SHARP
		if(damtype == BURN)
			. |= DAM_LASER

/obj/attackby(obj/item/O, mob/user)
	if(obj_flags & OBJ_FLAG_ANCHORABLE)
		if(isWrench(O))
			wrench_floor_bolts(user)
			update_icon()
			return
	return ..()

/obj/proc/wrench_floor_bolts(mob/user, delay=20)
	playsound(loc, 'sound/items/Ratchet.ogg', 100, 1)
	if(anchored)
		user.visible_message("\The [user] begins unsecuring \the [src] from the floor.", "You start unsecuring \the [src] from the floor.")
	else
		user.visible_message("\The [user] begins securing \the [src] to the floor.", "You start securing \the [src] to the floor.")
	if(do_after(user, delay, src))
		if(!src) return
		to_chat(user, "<span class='notice'>You [anchored? "un" : ""]secured \the [src]!</span>")
		anchored = !anchored
	return 1

/obj/attack_hand(mob/user)
	if(Adjacent(user))
		add_fingerprint(user)
	..()

/obj/is_fluid_pushable(var/amt)
	return ..() && w_class <= round(amt/20)

/obj/proc/can_embed()
	return is_sharp(src)

/obj/AltClick(mob/user)
	if(obj_flags & OBJ_FLAG_ROTATABLE)
		rotate(user)
	..()

/obj/examine(mob/user)
	. = ..()
	if((obj_flags & OBJ_FLAG_ROTATABLE))
		to_chat(user, SPAN_SUBTLE("Can be rotated with alt-click."))

/obj/proc/rotate(mob/user)
	if(!CanPhysicallyInteract(user))
		to_chat(user, SPAN_NOTICE("You can't interact with \the [src] right now!"))
		return

	if(anchored)
		to_chat(user, SPAN_NOTICE("\The [src] is secured to the floor!"))
		return

	set_dir(turn(dir, 90))
	update_icon() 

//For things to apply special effects after damaging an organ, called by organ's take_damage
/obj/proc/after_wounding(obj/item/organ/external/organ, datum/wound)
	return

/obj/can_be_injected_by(var/atom/injector)
	. = ATOM_IS_OPEN_CONTAINER(src) && ..()

/obj/get_mass()
	return min(2**(w_class-1), 100)

/obj/get_object_size()
	return w_class
