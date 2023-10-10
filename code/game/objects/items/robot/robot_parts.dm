/obj/item/robot_parts
	name = "robot parts"
	icon = 'icons/obj/robot_parts.dmi'
	item_state = "buildpipe"
	icon_state = "blank"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_LOWER_BODY
	material = /decl/material/solid/metal/steel

	var/sabotaged = 0 //Emagging limbs can have repercussions when installed as prosthetics.
	var/model_info
	var/bp_tag = null // What part is this?
	dir = SOUTH

/obj/item/robot_parts/set_dir()
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/obj/item/robot_parts/Initialize(mapload, var/model)
	. = ..(mapload)
	if(model_info)
		if(!ispath(model, /decl/prosthetics_manufacturer))
			model = /decl/prosthetics_manufacturer/basic_human
		model_info = model
		var/decl/prosthetics_manufacturer/R = GET_DECL(model)
		if(R)
			SetName("[R.name] [initial(name)]")
			desc = "[R.desc]"
			if(icon_state in icon_states(R.icon))
				icon = R.icon
	else
		SetDefaultName()

/obj/item/robot_parts/proc/SetDefaultName()
	SetName("robot [initial(name)]")

/obj/item/robot_parts/proc/can_install(mob/user)
	return TRUE

/obj/item/robot_parts/l_arm
	name = "left arm"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	icon_state = "l_arm"
	model_info = 1
	bp_tag = BP_L_ARM
	material = /decl/material/solid/metal/steel

/obj/item/robot_parts/r_arm
	name = "right arm"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	icon_state = "r_arm"
	model_info = 1
	bp_tag = BP_R_ARM
	material = /decl/material/solid/metal/steel

/obj/item/robot_parts/l_leg
	name = "left leg"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	icon_state = "l_leg"
	model_info = 1
	bp_tag = BP_L_LEG
	material = /decl/material/solid/metal/steel

/obj/item/robot_parts/r_leg
	name = "right leg"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	icon_state = "r_leg"
	model_info = 1
	bp_tag = BP_R_LEG
	material = /decl/material/solid/metal/steel

/obj/item/robot_parts/head
	name = "head"
	desc = "A standard reinforced braincase, with spine-plugged neural socket and sensor gimbals."
	icon_state = "head"
	model_info = 1
	bp_tag = BP_HEAD
	material = /decl/material/solid/metal/steel
	var/obj/item/flash/flash1 = null
	var/obj/item/flash/flash2 = null

/obj/item/robot_parts/head/can_install(mob/user)
	var/success = TRUE
	if(!flash1 || !flash2)
		to_chat(user, "<span class='warning'>You need to attach a flash to it first!</span>")
		success = FALSE
	return success && ..()

/obj/item/robot_parts/chest
	name = "torso"
	desc = "A heavily reinforced case containing cyborg logic boards, with space for a standard power cell."
	icon_state = "chest"
	model_info = 1
	bp_tag = BP_CHEST
	material = /decl/material/solid/metal/steel
	var/wires = 0.0
	var/obj/item/cell/cell = null

/obj/item/robot_parts/chest/can_install(mob/user)
	var/success = TRUE
	if(!wires)
		to_chat(user, "<span class='warning'>You need to attach wires to it first!</span>")
		success = FALSE
	if(!cell)
		to_chat(user, "<span class='warning'>You need to attach a cell to it first!</span>")
		success = FALSE
	return success && ..()

/obj/item/robot_parts/chest/attackby(obj/item/W, mob/user)
	..()
	if(istype(W, /obj/item/cell))
		if(src.cell)
			to_chat(user, "<span class='warning'>You have already inserted a cell!</span>")
			return
		else
			if(!user.try_unequip(W, src))
				return
			src.cell = W
			to_chat(user, "<span class='notice'>You insert the cell!</span>")
	if(IS_COIL(W))
		if(src.wires)
			to_chat(user, "<span class='warning'>You have already inserted wire!</span>")
			return
		else
			var/obj/item/stack/cable_coil/coil = W
			if(coil.use(1))
				src.wires = 1.0
				to_chat(user, "<span class='notice'>You insert the wire!</span>")

/obj/item/robot_parts/head/attackby(obj/item/W, mob/user)
	..()
	if(istype(W, /obj/item/flash))
		if(istype(user,/mob/living/silicon/robot))
			var/current_module = user.get_active_hand()
			if(current_module == W)
				to_chat(user, "<span class='warning'>How do you propose to do that?</span>")
				return
			else
				add_flashes(W,user)
		else
			add_flashes(W,user)

/obj/item/robot_parts/head/proc/add_flashes(obj/item/W, mob/user) //Made into a seperate proc to avoid copypasta
	if(src.flash1 && src.flash2)
		to_chat(user, "<span class='notice'>You have already inserted the eyes!</span>")
		return
	else if(src.flash1)
		if(!user.try_unequip(W, src))
			return
		src.flash2 = W
		to_chat(user, "<span class='notice'>You insert the flash into the eye socket!</span>")
	else
		if(!user.try_unequip(W, src))
			return
		src.flash1 = W
		to_chat(user, "<span class='notice'>You insert the flash into the eye socket!</span>")


/obj/item/robot_parts/emag_act(var/remaining_charges, var/mob/user)
	if(sabotaged)
		to_chat(user, "<span class='warning'>[src] is already sabotaged!</span>")
	else
		to_chat(user, "<span class='warning'>You short out the safeties.</span>")
		sabotaged = 1
		return 1
