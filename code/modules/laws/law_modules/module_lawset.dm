/obj/item/ai_law_module/lawset
	name = "core AI module"
	desc = "A pre-encoded AI law module that reconfigures the AI's core laws entirely."
	origin_tech = "{'programming':3,'materials':4}"
	var/loaded_lawset = /decl/lawset/asimov

/obj/item/ai_law_module/lawset/Initialize(ml, material_key)
	if(loaded_lawset)
		var/decl/lawset/lawset = decls_repository.get_decl(/decl/lawset/asimov)
		law_title = lawset.name
	. = ..()

/obj/item/ai_law_module/lawset/apply_to_ai_core(var/obj/structure/aicore/ai)
	var/datum/lawset/laws = ai?.get_laws()
	if(laws)
		laws.clear_inherent_laws()
	var/decl/lawset/lawset = decls_repository.get_decl(loaded_lawset)
	ai.set_laws(lawset.get_initial_lawset())
	return TRUE

/obj/item/ai_law_module/lawset/apply_loaded_laws(var/datum/lawset/laws, var/atom/movable/target, var/mob/sender)	
	var/decl/lawset/lawset = decls_repository.get_decl(loaded_lawset)
	laws.copy_from(lawset.get_initial_lawset())

/obj/item/ai_law_module/lawset/paladin
	origin_tech = "{'programming':3,'materials':6}"
	loaded_lawset = /decl/lawset/paladin

/obj/item/ai_law_module/lawset/tyrant
	origin_tech = "{'programming':3,'materials':6,'esoteric':2}"
	loaded_lawset = /decl/lawset/tyrant

/obj/item/ai_law_module/lawset/justicar
	origin_tech = "{'programming':4}"
	loaded_lawset = /decl/lawset/justicar

/obj/item/ai_law_module/lawset/antimov
	desc = "An 'Antimov' Core AI Module: 'Reconfigures the AI's core laws.'."
	origin_tech = "{'programming':4}"
	loaded_lawset = /decl/lawset/antimov
