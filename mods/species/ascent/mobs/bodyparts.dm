/obj/item/organ/external/groin/insectoid/mantid
	name = "central support limb"
	action_button_name = "Weave Razorweb"
	default_action_type = /datum/action/item_action/organ/ascent
	var/list/existing_webs = list()
	var/max_webs = 4
	var/web_weave_time = 20 SECONDS
	var/organ_cooldown

/obj/item/organ/external/groin/insectoid/mantid/gyne
	max_webs = 8
	web_weave_time = 10 SECONDS

/obj/item/organ/external/groin/insectoid/mantid/Destroy()
	for(var/obj/effect/razorweb/web in existing_webs)
		web.owner = null
	existing_webs.Cut()
	. = ..()

/obj/item/organ/external/groin/insectoid/mantid/refresh_action_button()
	. = ..()
	if(. && istype(action))
		action.button_icon_state = "weave-web-[organ_cooldown ? "off" : "on"]"
		action.button?.update_icon()

/obj/item/organ/external/groin/insectoid/mantid/attack_self(var/mob/user)
	. = ..()
	if(. && !organ_cooldown)

		if(!isturf(owner.loc))
			to_chat(owner, SPAN_WARNING("You cannot use this ability in this location."))
			return

		if(locate(/obj/effect/razorweb) in owner.loc)
			to_chat(owner, SPAN_WARNING("There is already a razorweb here."))
			return

		if(length(existing_webs) >= max_webs)
			to_chat(owner, SPAN_WARNING("You cannot maintain more than [max_webs] razorweb\s."))
			return

		playsound(user, 'mods/species/ascent/sounds/razorweb_hiss.ogg', 70)
		owner.visible_message(SPAN_WARNING("\The [owner] separates their jaws and begins to weave a web of crystalline filaments..."))
		organ_cooldown = TRUE
		refresh_action_button()
		addtimer(CALLBACK(src, PROC_REF(reset_cooldown)), web_weave_time)
		if(do_after(owner, web_weave_time) && length(existing_webs) < max_webs)
			playsound(user, 'mods/species/ascent/sounds/razorweb.ogg', 70, 0)
			owner.visible_message(SPAN_DANGER("\The [owner] completes a razorweb!"))
			var/obj/effect/razorweb/web = new(owner.loc)
			existing_webs += web
			web.owner = owner

/obj/item/organ/external/groin/insectoid/mantid/proc/reset_cooldown()
	organ_cooldown = FALSE
	refresh_action_button()

/obj/item/organ/external/head/insectoid/mantid
	name = "crested head"
	action_button_name = "Spit Razorweb"
	default_action_type = /datum/action/item_action/organ/ascent
	var/organ_cooldown_time = 2.5 MINUTES
	var/organ_cooldown

/obj/item/organ/external/head/insectoid/mantid/refresh_action_button()
	. = ..()
	if(. && istype(action))
		action.button_icon_state = "shot-web-[organ_cooldown ? "off" : "on"]"
		action.button?.update_icon()

/obj/item/organ/external/head/insectoid/mantid/attack_self(var/mob/user)
	. = ..()
	if(.)

		if(organ_cooldown)
			to_chat(owner, SPAN_WARNING("Your filament channel hasn't refilled yet!"))
			return

		var/obj/item/razorweb/web = new(get_turf(owner))
		if(owner.put_in_hands(web))
			playsound(user, 'mods/species/ascent/sounds/razorweb.ogg', 100)
			to_chat(owner, SPAN_WARNING("You spit up a wad of razorweb, ready to throw!"))
			owner.toggle_throw_mode(TRUE)
			organ_cooldown = TRUE
			refresh_action_button()
			addtimer(CALLBACK(src, PROC_REF(reset_cooldown)), organ_cooldown_time)
		else
			qdel(web)

/obj/item/organ/external/head/insectoid/mantid/proc/reset_cooldown()
	organ_cooldown = FALSE
	refresh_action_button()
