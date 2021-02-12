// These modules are used to upload custom laws.
/obj/item/ai_law_module/freeform
	name = "freeform core AI module"
	desc = "A freeform core AI module, capable of being loaded with an entirely custom core law."
	origin_tech = "{'programming':3,'materials':6}"
	var/hacked = FALSE
	var/new_freeform_law = "\[0x0\]"

/obj/item/ai_law_module/freeform/apply_laws_to(var/atom/movable/target, mob/user)
	if(!new_freeform_law || new_freeform_law == initial(new_freeform_law))
		to_chat(user, "No data detected on \the [src], please initialize the buffer with a new law.")
		return FALSE
	..()

/obj/item/ai_law_module/freeform/proc/apply_freeform_law(var/datum/lawset/laws, var/atom/movable/target, var/mob/sender)	
	laws.add_inherent_law(new_freeform_law)

/obj/item/ai_law_module/freeform/apply_additional_laws(var/datum/lawset/laws, var/atom/movable/target, var/mob/sender)
	log_law_changes(target, sender)
	GLOB.lawchanges.Add("The law is '[new_freeform_law]'")
	if(!hacked)
		..()
	apply_freeform_law(laws, target, sender)

/obj/item/ai_law_module/freeform/attack_self(var/mob/user)

	var/new_law = sanitize(input("Please enter a new law for the AI, or enter a blank law to clear it.", "Freeform Law Entry", new_freeform_law) as text)
	if(QDELETED(src) || QDELETED(user) || !CanPhysicallyInteract(user))
		return TRUE

	new_freeform_law = new_law || initial(new_freeform_law)
	if(new_freeform_law && new_freeform_law != initial(new_freeform_law))
		to_chat(user, SPAN_NOTICE("You encode your custom law onto \the [src]."))
		update_desc()
	else
		to_chat(user, SPAN_NOTICE("You clear out the memory of \the [src]."))
		desc = initial(desc)
	return TRUE

/obj/item/ai_law_module/freeform/proc/update_desc()
	desc = "[initial(desc)] This one is loaded with a custom law: '[new_freeform_law]'."

/obj/item/ai_law_module/freeform/apply_to_ai_core(var/obj/structure/aicore/ai)
	var/datum/lawset/laws = ai?.get_laws()
	if(laws)
		laws.add_inherent_law(new_freeform_law)
	return TRUE

// Subtypes (non-core and hacked)
/obj/item/ai_law_module/freeform/auxillary
	name = "freeform AI module"
	desc = "A freeform AI module, capable of being loaded with an entirely custom law."
	origin_tech = "{'programming':4,'materials':4}"
	var/law_priority = 15

/obj/item/ai_law_module/freeform/auxillary/apply_to_ai_core(var/obj/structure/aicore/ai)
	var/datum/lawset/laws = ai?.get_laws()
	if(laws)
		laws.add_supplied_law(new_freeform_law, law_priority)
	return TRUE

/obj/item/ai_law_module/freeform/auxillary/update_desc()
	desc = "[initial(desc)] This one is loaded with a custom law with a priority of [law_priority]: '[new_freeform_law]'."

/obj/item/ai_law_module/freeform/auxillary/attack_self(var/mob/user)
	var/new_law_priority = input("Please enter the priority for your new law. Can only write to law sectors between [MIN_SUPPLIED_LAW_NUMBER] and [MAX_SUPPLIED_LAW_NUMBER].", "Law Priority", law_priority) as num
	if(QDELETED(src) || QDELETED(user) || !CanPhysicallyInteract(user))
		return TRUE
	law_priority = Clamp(new_law_priority, MIN_SUPPLIED_LAW_NUMBER, MAX_SUPPLIED_LAW_NUMBER)
	. = ..()

/obj/item/ai_law_module/freeform/auxillary/apply_freeform_law(var/datum/lawset/laws, var/atom/movable/target, var/mob/sender)
	laws.add_supplied_law(new_freeform_law, law_priority)

/obj/item/ai_law_module/freeform/hacked
	name = "hacked AI module"
	desc = "A hacked AI law module."
	origin_tech = "{'programming':3,'materials':6,'esoteric':7}"
	hacked = TRUE

/obj/item/ai_law_module/freeform/hacked/apply_to_ai_core(var/obj/structure/aicore/ai)
	var/datum/lawset/laws = ai?.get_laws()
	if(laws)
		laws.add_ion_law(new_freeform_law)
	return TRUE

/obj/item/ai_law_module/freeform/hacked/apply_freeform_law(var/datum/lawset/laws, var/atom/movable/target, var/mob/sender)
	to_chat(target, SPAN_DANGER("BZZZZT!"))
	laws.add_ion_law(new_freeform_law)
	laws.show_laws(target)
