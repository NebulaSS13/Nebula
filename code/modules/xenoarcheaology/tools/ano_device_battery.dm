/obj/item/anobattery
	name = "anomaly power battery"
	desc = "Curious device that can replicate the effects of anomalies without needing to understand their inner workings."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "anobattery0"
	material = /decl/material/solid/plastic
	matter = list(
		/decl/material/solid/metal/chromium   = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/metal/zinc       = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/lithium          = MATTER_AMOUNT_TRACE,
	)
	var/datum/artifact_effect/battery_effect
	var/capacity = 300
	var/stored_charge = 0

/obj/item/anobattery/on_update_icon()
	. = ..()
	icon_state = "anobattery[round(percent(),25)]"

/obj/item/anobattery/proc/percent()
	return round(min(100, (stored_charge/capacity)*100))

/obj/item/anobattery/proc/add_charge(var/amount)
	stored_charge = clamp(stored_charge + amount, 0, capacity)
	update_icon()

/obj/item/anobattery/proc/use_power(var/amount)
	stored_charge = clamp(stored_charge - amount, 0, capacity)
	if(stored_charge <= 0 && !QDELETED(battery_effect))
		qdel(battery_effect)
	update_icon()

/obj/item/anobattery/Destroy()
	QDEL_NULL(battery_effect)
	. = ..()

/obj/item/anodevice
	name = "anomaly power utilizer"
	desc = "APU allows users to safely (relatively) harness powers beyond their understanding, as long as they've been stored in anomaly power cells."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "anodev_empty"
	material = /decl/material/solid/plastic
	matter = list(
		/decl/material/solid/metal/chromium   = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/metal/gold       = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/copper     = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/silicon          = MATTER_AMOUNT_TRACE,
	)
	var/activated = 0
	var/duration = 1
	var/interval = 1
	var/current_tick = 0
	var/obj/item/anobattery/inserted_battery
	var/energy_consumed_on_touch = 100
	var/energy_consumed_on_tick = 10

/obj/item/anodevice/Destroy()
	inserted_battery = null
	. = ..()

/obj/item/anodevice/attackby(var/obj/I, var/mob/user)
	if(istype(I, /obj/item/anobattery))
		if(!inserted_battery)
			if(!user.try_unequip(I, src))
				return
			to_chat(user, "<span class='notice'>You insert \the [I] into \the [src].</span>")
			inserted_battery = I
			update_icon()
	else
		return ..()

/obj/item/anodevice/attack_self(var/mob/user)
	ui_interact(user)
	return TRUE

/obj/item/anodevice/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]

	data["activated"] = activated
	data["duration"] = duration
	data["current_tick"] = current_tick
	data["interval"] = interval
	if(inserted_battery)
		data["battery"] = 1
		data["charge"] = inserted_battery.stored_charge
		data["max_charge"] = inserted_battery.capacity
		if(inserted_battery.battery_effect)
			data["effect_id"] = inserted_battery.battery_effect.artifact_id
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "anomaly_battery_device.tmpl", "Anomaly Power Utiliser", 390, 500)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/item/anodevice/Process()
	if(!activated || !inserted_battery || !inserted_battery.battery_effect || !inserted_battery.stored_charge)
		visible_message("<span class='notice'>[html_icon(src)] [src] buzzes.</span>", "<span class='notice'>[html_icon(src)] You hear something buzz.</span>")
		shutdown_emission()
		return

	current_tick++

	//handle charge
	if(current_tick % interval)
		//make sure the effect is active
		if(!inserted_battery.battery_effect.activated)
			inserted_battery.battery_effect.ToggleActivate(1)
		switch(inserted_battery.battery_effect.operation_type)
			if(EFFECT_TOUCH)
				visible_message("The [src] shudders.")
				if(ismob(loc))
					inserted_battery.battery_effect.DoEffectTouch(loc)
				inserted_battery.use_power(energy_consumed_on_touch)
			if(EFFECT_PULSE)
				inserted_battery.battery_effect.pulse_tick = inserted_battery.battery_effect.pulse_period
				//consume power relative to the time the artifact takes to charge and the effect range
				inserted_battery.use_power(inserted_battery.battery_effect.effect_range * inserted_battery.battery_effect.effect_range * inserted_battery.battery_effect.pulse_period)
			else
				inserted_battery.use_power(energy_consumed_on_tick)

	if(inserted_battery.battery_effect)
		inserted_battery.battery_effect.process()
	else //ran out of charge
		visible_message("<span class='notice'>[html_icon(src)] [src] buzzes.</span>", "<span class='notice'>[html_icon(src)] You hear something buzz.</span>")
		shutdown_emission()

	if(current_tick >= duration)
		visible_message("<span class='notice'>[html_icon(src)] [src] chimes.</span>", "<span class='notice'>[html_icon(src)] You hear something chime.</span>")
		shutdown_emission()

/obj/item/anodevice/proc/start_emission()
	activated = 1
	current_tick = 0
	START_PROCESSING(SSobj, src)
	events_repository.register(/decl/observ/moved, src, src, /obj/item/anodevice/proc/on_move)
	if(inserted_battery?.battery_effect?.activated == 0)
		inserted_battery.battery_effect.ToggleActivate(1)

/obj/item/anodevice/proc/shutdown_emission()
	activated = 0
	STOP_PROCESSING(SSobj, src)
	events_repository.unregister(/decl/observ/moved, src, src)
	if(inserted_battery?.battery_effect?.activated == 1)
		inserted_battery.battery_effect.ToggleActivate(1)

/obj/item/anodevice/proc/on_move()
	if(activated && inserted_battery?.battery_effect)
		inserted_battery.battery_effect.UpdateMove()

/obj/item/anodevice/DefaultTopicState()
	return global.inventory_topic_state

/obj/item/anodevice/OnTopic(user, href_list)
	if(..())
		return TOPIC_HANDLED
	if(href_list["duration"])
		var/timedif = text2num(href_list["duration"])
		duration = clamp(duration + timedif, 1, 30)
		. = TOPIC_REFRESH
	else if(href_list["interval"])
		var/timedif = text2num(href_list["interval"])
		interval = clamp(interval + timedif, 1, 10)
		. = TOPIC_REFRESH
	else if(href_list["startup"])
		if(inserted_battery && inserted_battery.battery_effect && (inserted_battery.stored_charge > 0) )
			visible_message("<span class='notice'>[html_icon(src)] [src] whirrs.</span>", "<span class='notice'>[html_icon(src)] You hear something whirr.</span>")
			start_emission()
			. = TOPIC_REFRESH
	else if(href_list["shutdown"])
		shutdown_emission()
		. = TOPIC_REFRESH
	else if(href_list["refresh"])
		. = TOPIC_REFRESH
	else if(href_list["ejectbattery"])
		shutdown_emission()
		inserted_battery.dropInto(loc)
		inserted_battery = null
		update_icon()
		. = TOPIC_REFRESH

/obj/item/anodevice/on_update_icon()
	. = ..()
	if(inserted_battery)
		icon_state = "anodev[round(inserted_battery.percent(),25)]"
	else
		icon_state = "anodev_empty"

/obj/item/anodevice/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/anodevice/attack(mob/living/M, mob/living/user, def_zone)
	if (!istype(M))
		return

	if(activated && inserted_battery?.battery_effect?.operation_type == EFFECT_TOUCH)
		inserted_battery.battery_effect.DoEffectTouch(M)
		inserted_battery.use_power(energy_consumed_on_touch)
		user.visible_message("<span class='notice'>[user] taps [M] with [src], and it shudders on contact.</span>")
		admin_attack_log(user, M, "Tapped their victim with \a [src] (EFFECT: [inserted_battery.battery_effect.name])", "Was tapped by \a [src] (EFFECT: [inserted_battery.battery_effect.name])", "used \a [src] (EFFECT: [inserted_battery.battery_effect.name]) to tap")
	else
		user.visible_message("<span class='notice'>[user] taps [M] with [src], but nothing happens.</span>")
