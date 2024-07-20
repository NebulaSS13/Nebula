/obj/item/dociler
	name = "dociler"
	desc = "A complex single use recharging injector that spreads a complex neurological serum that makes animals docile and friendly. Somewhat."
	w_class = ITEM_SIZE_NORMAL
	origin_tech = @'{"biotech":5,"materials":2}'
	icon = 'icons/obj/items/device/animal_tagger.dmi'
	icon_state = ICON_STATE_WORLD
	_base_attack_force = 1
	material = /decl/material/solid/organic/plastic
	matter = list(/decl/material/solid/metal/copper = MATTER_AMOUNT_REINFORCEMENT, /decl/material/solid/silicon = MATTER_AMOUNT_REINFORCEMENT)
	var/loaded = 1
	var/mode = "completely"

/obj/item/dociler/examine(mob/user)
	. = ..()
	to_chat(user, "<span class='notice'>It is currently set to [mode] docile mode.</span>")

/obj/item/dociler/attack_self(var/mob/user)
	if(mode == "somewhat")
		mode = "completely"
	else
		mode = "somewhat"

	to_chat(user, "You set \the [src] to [mode] docile mode.")

/obj/item/dociler/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)

	if(!isanimal(target))
		to_chat(user, SPAN_WARNING("\The [src] cannot not work on \the [target]."))
		return TRUE

	if(!loaded)
		to_chat(user, SPAN_WARNING("\The [src] isn't loaded!"))
		return TRUE

	user.visible_message("\The [user] stabs \the [src] into \the [target], injecting something!")
	var/decl/pronouns/G = user.get_pronouns()
	to_chat(target, SPAN_NOTICE("You feel a stabbing pain as \the [user] injects something into you. All of a sudden you feel as if [user] is the friendliest and nicest person you've ever know. You want to be friends with [G.him] and all [G.his] friends."))
	if(mode == "somewhat")
		target.faction = user.faction
	else
		target.faction = null
	target.ai?.pacify(user)
	target.desc += "<br><span class='notice'>It looks especially docile.</span>"
	var/name = input(user, "Would you like to rename \the [target]?", "Dociler", target.name) as text
	if(length(name))
		target.real_name = name
		target.SetName(name)

	loaded = FALSE
	icon_state = get_world_inventory_state()
	spawn(2.5 MINUTES)
		loaded = TRUE
		icon_state = "[icon_state]-charged"
		src.visible_message("\The [src] beeps, refilling itself.")

	return TRUE