/obj/item/ai_law_module/reset
	name = "\improper AI law reset module"
	desc = "A customized AI Module that clears all nonstandard laws and preserves core laws."
	origin_tech = "{'programming':3,'materials':4}"

/obj/item/ai_law_module/reset/apply_laws_to(var/atom/movable/target, var/mob/sender)

	var/datum/lawset/laws = target.get_laws()
	if(!laws)
		to_chat(sender, SPAN_WARNING("\The [target] is not compatible with \the [src]."))
		return

	log_law_changes(target, sender)
	to_chat(target, "[capitalize(sender.real_name)] attempted to reset your laws using a reset module.")
	laws.reset_laws()
	laws.show_laws()

/obj/item/ai_law_module/reset/apply_to_ai_core(var/obj/structure/aicore/ai)
	var/datum/lawset/laws = ai?.get_laws()
	if(laws)
		laws.reset_laws()
	return TRUE
