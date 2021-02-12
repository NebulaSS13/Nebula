/obj/item/ai_law_module/purge
	name = "\improper AI law purge module"
	desc = "A customized AI Module that purges all laws."
	origin_tech = "{'programming':3,'materials':6}"

/obj/item/ai_law_module/purge/apply_laws_to(var/atom/movable/target, var/mob/sender)

	var/datum/lawset/laws = target.get_laws()
	if(!laws)
		to_chat(sender, SPAN_WARNING("\The [target] is not compatible with \the [src]."))
		return

	log_law_changes(target, sender)
	var/mob/M = target
	var/decl/special_role/traitors = decls_repository.get_decl(/decl/special_role/traitor)
	laws.purge_laws(!istype(M) || !M.mind || !(M.mind in traitors.current_antagonists))
	to_chat(target, "[capitalize(sender.real_name)] attempted to wipe your laws using a purge module.")
	laws.show_laws(target)

/obj/item/ai_law_module/purge/apply_to_ai_core(var/obj/structure/aicore/ai)
	var/datum/lawset/laws = ai?.get_laws()
	if(laws)
		laws.purge_laws()
	return TRUE
