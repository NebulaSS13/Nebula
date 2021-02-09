/obj/item/firearm_component/grip/secure
	var/list/authorized_modes = list(ALWAYS_AUTHORIZED)
	var/default_mode_authorization = UNAUTHORIZED
	var/registered_owner
	var/standby

/obj/item/firearm_component/grip/secure/holder_emag_act(var/charges, var/mob/user)
	if(holder?.is_secure_gun())
		registered_owner = null
		GLOB.registered_weapons -= src
		holder.verbs -= /obj/item/gun/proc/reset_registration
		holder.req_access.Cut()
		to_chat(user, SPAN_NOTICE("\The [holder || src]'s authorization chip fries, giving you full access."))
		return TRUE
	. = ..()

/obj/item/firearm_component/grip/secure/holder_attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/card/id) && holder?.is_secure_gun())
		user.visible_message("\The [user] swipes an ID through \the [holder || src].", range = 3)
		if(!registered_owner)
			var/obj/item/card/id/id = W
			GLOB.registered_weapons |= src
			holder.verbs |= /obj/item/gun/proc/reset_registration
			registered_owner = id.registered_name
			to_chat(user, SPAN_NOTICE("\The [holder || src] chimes quietly as it registers to \"[registered_owner]\"."))
		else
			to_chat(user, SPAN_NOTICE("\The [holder || src] buzzes quietly, refusing to register without first being reset."))
		return TRUE
	. = ..()

/obj/item/firearm_component/grip/secure/Initialize(ml, material_key)
	. = ..()
	if(holder?.is_secure_gun())
		authorized_modes = list()
		for(var/i = authorized_modes.len + 1 to length(holder.receiver?.firemodes))
			authorized_modes.Add(default_mode_authorization)
		set_extension(src, /datum/extension/network_device/lazy)
		holder.verbs |= /obj/item/gun/proc/network_setup

/obj/item/firearm_component/grip/secure/show_examine_info(mob/user)
	. = ..()
	if(holder?.is_secure_gun())
		to_chat(user, "The registration screen shows, \"" + (registered_owner ? "[registered_owner]" : "unregistered") + "\"")

/obj/item/gun/proc/network_setup()
	set name = "Setup Secure Gun Network"
	set category = "Object"
	if(receiver)
		var/datum/extension/network_device/D = get_extension(receiver, /datum/extension/network_device)
		if(D)
			D.ui_interact(usr)
			return TRUE
	to_chat(usr, SPAN_WARNING("\The [src] is not network capable."))

/obj/item/firearm_component/grip/secure/is_secured()
	return TRUE

/obj/item/firearm_component/grip/secure/get_network()
	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	if(D)
		return D.get_network()

/obj/item/firearm_component/grip/secure/get_authorized_mode(var/index)
	return authorized_modes[index]

/obj/item/firearm_component/grip/secure/authorize(var/mode, var/authorized, var/by)
	if(!holder?.receiver)
		return FALSE
	if(mode < 1 || mode > authorized_modes.len || authorized_modes[mode] == authorized)
		return FALSE
	authorized_modes[mode] = authorized
	if((mode == holder.receiver.sel_mode && !authorized))
		holder.receiver.switch_firemodes()
	var/atom/showing = holder || src 
	var/mob/user = get_holder_of_type(showing, /mob)
	if(user)
		to_chat(user, SPAN_NOTICE("Your [showing.name] has been [authorized ? "granted" : "denied"] [holder.receiver.firemodes[mode]] fire authorization by [by]."))
	return TRUE

/*
/obj/item/gun/energy/gun/secure/mounted/Initialize()
	var/mob/borg = get_holder_of_type(src, /mob/living/silicon/robot)
	if(!borg)
		. = INITIALIZE_HINT_QDEL
		CRASH("Invalid spawn location.")
	registered_owner = borg.name
	GLOB.registered_cyborg_weapons += src
	. = ..()
*/
