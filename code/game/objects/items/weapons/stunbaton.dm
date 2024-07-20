//replaces our stun baton code with /tg/station's code
/obj/item/baton
	name = "stunbaton"
	desc = "A stun baton for incapacitating people with."
	icon = 'icons/obj/items/weapon/stunbaton.dmi'
	icon_state = ICON_STATE_WORLD
	slot_flags = SLOT_LOWER_BODY
	sharp = 0
	edge = 0
	w_class = ITEM_SIZE_NORMAL
	origin_tech = @'{"combat":2}'
	attack_verb = list("beaten")
	base_parry_chance = 30
	material = /decl/material/solid/metal/aluminium
	matter = list(
		/decl/material/solid/organic/plastic      = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/metal/copper = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/silicon      = MATTER_AMOUNT_REINFORCEMENT,
	)
	item_flags = ITEM_FLAG_IS_WEAPON
	_base_attack_force = 15
	var/stunforce = 0
	var/agonyforce = 30
	var/status = 0		//whether the thing is on or not
	var/hitcost = 7

/obj/item/baton/Initialize(var/ml, var/material_key, var/loaded_cell_type)
	. = ..(ml)
	setup_power_supply(loaded_cell_type)

/obj/item/baton/setup_power_supply(loaded_cell_type, accepted_cell_type, power_supply_extension_type, charge_value)
	. = ..(loaded_cell_type, /obj/item/cell/device, /datum/extension/loaded_cell/secured, charge_value)
	update_icon()

/obj/item/baton/loaded/Initialize(var/ml, var/material_key, var/loaded_cell_type)
	return ..(ml, material_key, loaded_cell_type = /obj/item/cell/device/high)

/obj/item/baton/infinite/Initialize(var/ml, var/material_key, var/loaded_cell_type)
	. = ..(ml, material_key, loaded_cell_type = /obj/item/cell/device/infinite)
	set_status(1, null)

/obj/item/baton/proc/update_status()
	var/obj/item/cell/cell = get_cell()
	if(cell?.charge < hitcost)
		status = 0
		update_icon()

/obj/item/baton/proc/deductcharge(var/chrgdeductamt)
	var/obj/item/cell/cell = get_cell()
	if(cell)
		if(cell.checked_use(chrgdeductamt))
			update_status()
			return 1
		else
			status = 0
			update_icon()
			return 0
	return null

/obj/item/baton/on_update_icon()
	. = ..()
	if(status)
		add_overlay("[icon_state]-active")
		set_light(1.5, 2, "#ff6a00")
	else
		if(!get_cell())
			add_overlay("[icon_state]-nocell")
		set_light(0)

/obj/item/baton/attack_self(mob/user)
	set_status(!status, user)
	add_fingerprint(user)

/obj/item/baton/proc/set_status(var/newstatus, mob/user)
	var/obj/item/cell/cell = get_cell()
	if(cell?.charge >= hitcost)
		if(status != newstatus)
			change_status(newstatus)
			to_chat(user, "<span class='notice'>[src] is now [status ? "on" : "off"].</span>")
			playsound(loc, "sparks", 75, 1, -1)
	else
		change_status(0)
		if(!cell)
			to_chat(user, "<span class='warning'>[src] does not have a power source!</span>")
		else
			to_chat(user,  "<span class='warning'>[src] is out of charge.</span>")

// Proc to -actually- change the status, and update the icons as well.
// Also exists to ease "helpful" admin-abuse in case an bug prevents attack_self
// to occur would appear. Hopefully it wasn't necessary.
/obj/item/baton/proc/change_status(var/s)
	if (status != s)
		status = s
		update_icon()

/obj/item/baton/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)
	if(status && user.has_genetic_condition(GENE_COND_CLUMSY) && prob(50))
		to_chat(user, SPAN_DANGER("You accidentally hit yourself with the [src]!"))
		SET_STATUS_MAX(user, STAT_WEAK, 30)
		deductcharge(hitcost)
		return TRUE
	return ..()

/obj/item/baton/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	if(isrobot(target))
		return ..()

	var/agony = agonyforce
	var/stun = stunforce
	var/obj/item/organ/external/affecting = null
	if(ishuman(target))
		var/mob/living/human/H = target
		affecting = GET_EXTERNAL_ORGAN(H, hit_zone)
	var/abuser =  user ? "" : "by [user]"
	if(user && user.a_intent == I_HURT)
		. = ..()
		if(.)
			return

		//whacking someone causes a much poorer electrical contact than deliberately prodding them.
		stun *= 0.5
		if(status)		//Checks to see if the stunbaton is on.
			agony *= 0.5	//whacking someone causes a much poorer contact than prodding them.
		else
			agony = 0	//Shouldn't really stun if it's off, should it?
		//we can't really extract the actual hit zone from ..(), unfortunately. Just act like they attacked the area they intended to.
	else if(!status)
		if(affecting)
			target.visible_message("<span class='warning'>[target] has been prodded in the [affecting.name] with [src][abuser]. Luckily it was off.</span>")
		else
			target.visible_message("<span class='warning'>[target] has been prodded with [src][abuser]. Luckily it was off.</span>")
	else
		if(affecting)
			target.visible_message("<span class='danger'>[target] has been prodded in the [affecting.name] with [src]!</span>")
		else
			target.visible_message("<span class='danger'>[target] has been prodded with [src][abuser]!</span>")
		playsound(loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)

	//stun effects
	if(status)
		target.stun_effect_act(stun, agony, hit_zone, src)
		msg_admin_attack("[key_name(user)] stunned [key_name(target)] with the [src].")
		deductcharge(hitcost)

		if(ishuman(target))
			var/mob/living/human/H = target
			H.forcesay(global.hit_appends)

	return 1

// Stunbaton module for Security synthetics
/obj/item/baton/robot
	hitcost = 20

// Addition made by Techhead0, thanks for fullfilling the todo!
/obj/item/baton/robot/examine(mob/user, distance, infix, suffix)
	. = ..()
	if(distance == 1)
		to_chat(user, SPAN_NOTICE("The baton is running off an external power supply."))

// Override proc for the stun baton module, found in PC Security synthetics
// Refactored to fix #14470 - old proc defination increased the hitcost beyond
// usability without proper checks.
// Also hard-coded to be unuseable outside their righteous synthetic owners.
/obj/item/baton/robot/attack_self(mob/user)
	var/mob/living/silicon/robot/R = isrobot(user) ? user : null // null if the user is NOT a robot
	if (R)
		return ..()
	else	// Stop pretending and get out of your cardborg suit, human.
		to_chat(user, "<span class='warning'>You don't seem to be able to interact with this by yourself.</span>")
		add_fingerprint(user)
	return 0

/obj/item/baton/robot/attackby(obj/item/W, mob/user)
	return

/obj/item/baton/robot/setup_power_supply(loaded_cell_type, accepted_cell_type, power_supply_extension_type, charge_value)
	SHOULD_CALL_PARENT(FALSE)
	return

/obj/item/baton/robot/get_cell()
	var/mob/living/silicon/robot/holder = loc
	if(istype(holder))
		return holder.cell
	return ..()

// Traitor variant for Engineering synthetics.
/obj/item/baton/robot/electrified_arm
	name = "electrified arm"
	icon = 'icons/obj/items/borg_module/electrified_arm.dmi'
	icon_state = "electrified_arm"

/obj/item/baton/robot/electrified_arm/on_update_icon()
	. = ..()
	if(status)
		icon_state = "electrified_arm_active"
		set_light(1.5, 2, "#006aff")
	else
		icon_state = "electrified_arm"
		set_light(0)

//Makeshift stun baton. Replacement for stun gloves.
/obj/item/baton/cattleprod
	name = "stunprod"
	desc = "An improvised stun baton."
	icon = 'icons/obj/items/weapon/stunprod.dmi'
	icon_state = "stunprod_nocell"
	item_state = "prod"
	stunforce = 0
	agonyforce = 60	//same force as a stunbaton, but uses way more charge.
	hitcost = 25
	attack_verb = list("poked")
	slot_flags = null
	matter = list(
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/copper = MATTER_AMOUNT_TRACE
	)
	_base_attack_force = 3
