/obj/item/ai_law_module
	name = "AI module"
	icon = 'icons/obj/modules/module_standard.dmi'
	icon_state = ICON_STATE_WORLD
	desc = "An AI Module for transmitting encrypted instructions to the AI."
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	force = 5
	w_class = ITEM_SIZE_SMALL
	throwforce = 5
	throw_speed = 3
	throw_range = 15
	origin_tech = "{'programming':3}"
	material = /decl/material/solid/glass
	matter = list(/decl/material/solid/metal/gold = MATTER_AMOUNT_REINFORCEMENT)
	var/law_title

/obj/item/ai_law_module/Initialize(ml, material_key)
	if(law_title)
		name = "\improper '[law_title]' [name]"
	. = ..()

/obj/item/ai_law_module/proc/apply_to_ai_core(var/obj/structure/aicore/ai)
	return FALSE

/obj/item/ai_law_module/proc/apply_loaded_laws(var/datum/lawset/laws, var/atom/movable/target, var/mob/sender)	
	return

/obj/item/ai_law_module/proc/apply_laws_to(var/atom/movable/target, var/mob/sender)

	var/datum/lawset/laws = target.get_laws()
	if(!laws)
		to_chat(sender, SPAN_WARNING("\The [target] is not compatible with \the [src]."))
		return

	log_law_changes(target, sender)
	apply_loaded_laws(laws, target, sender)
	apply_additional_laws(laws, target, sender)

	if(ismob(target))
		var/mob/M = target
		to_chat(M, "\The [sender] has uploaded a change to the laws you must follow, using \a [src]. From now on:")
		laws.show_laws(M)

/obj/item/ai_law_module/proc/log_law_changes(var/mob/target, var/mob/sender)
	if(istype(target) && istype(sender))
		GLOB.lawchanges.Add("[time2text(world.realtime,"hh:mm:ss")] <B>:</B> \the [sender] ([sender.key]) used \the [src] on \the [target] ([target.key])")
		log_and_message_admins("used \the [src] on \the [target] ([target.key])")

/obj/item/ai_law_module/proc/apply_additional_laws(var/datum/lawset/laws, var/atom/movable/target, var/mob/sender)
	return