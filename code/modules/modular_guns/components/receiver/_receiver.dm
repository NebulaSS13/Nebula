/obj/item/firearm_component/receiver
	name = "receiver"
	desc = "A complicated bit of machinery used to feed ammunition into the barrel of a firearm."
	icon_state = "world-receiver"
	firearm_component_category = FIREARM_COMPONENT_RECEIVER
	var/sel_mode = 1 //index of the currently selected mode
	var/list/firemodes
	var/selector_sound = 'sound/weapons/guns/selector.ogg'
	var/screen_shake = 0
	var/space_recoil = 0
	var/combustion =   0
	var/safety_state = 1
	var/safety_icon 	   //overlay to apply to gun based on safety state, if any
	var/has_safety = TRUE
	var/tmp/last_safety_check = -INFINITY

/obj/item/firearm_component/receiver/proc/get_safety_indicator()
	return mutable_appearance(icon, "[icon_state][safety_icon][safety()]")

/obj/item/firearm_component/receiver/proc/safety()
	return has_safety && safety_state

/obj/item/firearm_component/receiver/Initialize(ml, material_key)
	LAZYINITLIST(firemodes)
	for(var/i in 1 to length(firemodes))
		firemodes[i] = new /datum/firemode(src, firemodes[i])
	UNSETEMPTY(firemodes)
	. = ..()

/obj/item/firearm_component/receiver/show_examine_info(mob/user)
	. = ..()
	if(user.skill_check(SKILL_WEAPONS, SKILL_BASIC))
		if(length(firemodes) > 1)
			var/datum/firemode/current_mode = firemodes[sel_mode]
			to_chat(user, "The fire selector is set to [current_mode.name].")
		if(has_safety)
			last_safety_check = world.time
			to_chat(user, "The safety is [safety() ? "on" : "off"].")

/obj/item/firearm_component/receiver/holder_attackby(obj/item/W, mob/user)
	. = load_ammo(user, W) || ..()

/obj/item/firearm_component/receiver/holder_attack_hand(mob/user)
	. = (holder && user.is_holding_offhand(holder) && unload_ammo(user)) || ..()

/obj/item/firearm_component/receiver/holder_attack_self(mob/user)
	if(length(firemodes))
		var/datum/firemode/new_mode = switch_firemodes(user)
		if(prob(20) && !user.skill_check(SKILL_WEAPONS, SKILL_BASIC))
			new_mode = switch_firemodes(user)
		if(new_mode)
			to_chat(user, SPAN_NOTICE("\The [holder] is now set to [new_mode.name]."))
			update_icon()
			holder.update_icon()
			return TRUE
	. = ..()

/obj/item/firearm_component/receiver/proc/switch_firemodes()
	var/next_mode = get_next_firemode()
	if(!next_mode || next_mode == sel_mode)
		return null
	sel_mode = next_mode
	var/datum/firemode/new_mode = firemodes[sel_mode]
	new_mode.apply_to(holder)
	playsound(holder, selector_sound, 50, 1)
	return new_mode

/obj/item/firearm_component/receiver/proc/get_next_firemode()
	if(length(firemodes) <= 1)
		return
	. = sel_mode + 1
	if(. > length(firemodes))
		. = 1

/obj/item/firearm_component/receiver/proc/get_relative_projectile_size(var/obj/item/projectile/projectile)
	return 1

/obj/item/firearm_component/receiver/proc/get_caliber()
	return

/obj/item/firearm_component/receiver/proc/set_caliber(var/_caliber)
	return

/obj/item/firearm_component/receiver/proc/get_next_projectile()
	return

/obj/item/firearm_component/receiver/proc/can_accept_ammo(var/obj/item/ammo)
	return FALSE

/obj/item/firearm_component/receiver/proc/process_point_blank(obj/projectile, mob/user, atom/target)
	return

/obj/item/firearm_component/receiver/proc/handle_post_holder_fire()
	return

/obj/item/firearm_component/receiver/proc/process_chambered()
	return

/obj/item/firearm_component/receiver/proc/special_check(var/mob/user)
	return TRUE

/obj/item/firearm_component/receiver/proc/handle_click_empty()
	if(holder?.check_fire_message_spam("click"))
		visible_message("*click click*", "<span class='danger'>*click*</span>")
	playsound(get_turf(src), 'sound/weapons/empty.ogg', 100, 1)

/obj/item/firearm_component/receiver/proc/load_ammo(var/mob/user, var/obj/item/loading)
	return

/obj/item/firearm_component/receiver/proc/unload_ammo(var/mob/user)
	return

/obj/item/firearm_component/receiver/proc/toggle_safety(var/mob/user)
	if(has_safety)
		safety_state = !safety_state
		update_icon()
		if(user)
			to_chat(user, SPAN_NOTICE("You switch the safety [safety_state ? "on" : "off"] on \the [holder || src]."))
			last_safety_check = world.time
			playsound(src, 'sound/weapons/flipblade.ogg', 30, 1)
	else
		to_chat(user, SPAN_WARNING("There is no safety on \the [holder || src]."))
