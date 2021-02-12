/obj/item/ai_law_module/variable
	desc = "A slightly more flexible than usual AI law module, capable of accepting a single argument to modify the loaded law."
	origin_tech = "{'programming':3,'materials':4}"
	law_title = "Safeguard"
	var/law_text = "Safeguard $VARIABLE$. Anyone threatening or attempting to harm $VARIABLE$ is no longer to be considered a crew member, and is a threat which must be neutralized."
	var/law_variable_descriptor = "the name of the person you wish to safeguard"
	var/law_priority = 9
	var/supplied_variable

/obj/item/ai_law_module/variable/Initialize(ml, material_key)
	. = ..()
	if(law_text)
		desc = "[desc] This one will accept [law_variable_descriptor], has a priority of [law_priority], and states: '[law_text]'."

/obj/item/ai_law_module/variable/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)

		to_chat(user, SPAN_NOTICE("The custom variable for this module is set to: [supplied_variable]"))

/obj/item/ai_law_module/variable/attack_self(mob/user)
	..()
	var/new_variable = sanitize(input("Please enter [law_variable_descriptor].", "[law_title] Configuration", supplied_variable) as text)
	if(new_variable)
		supplied_variable = new_variable

/obj/item/ai_law_module/variable/proc/get_law_text()
	GLOB.lawchanges.Add("The law specified: [supplied_variable]")
	return replacetext(law_text, "$VARIABLE$", supplied_variable)

/obj/item/ai_law_module/variable/apply_loaded_laws(var/datum/lawset/laws, var/atom/movable/target, var/mob/sender)
	laws.add_supplied_law(get_law_text(), law_priority)

/obj/item/ai_law_module/variable/onehuman
	law_title = "OneHuman"
	law_variable_descriptor = "the name of the person who is the only crew member"
	law_text = "Only $VARIABLE$ is a crew member."
	origin_tech = "{'programming':3,'materials':6}"

/obj/item/ai_law_module/variable/onehuman/apply_loaded_laws(var/datum/lawset/laws, var/atom/movable/target, var/mob/sender)
	var/law = get_law_text()
	var/mob/M = target
	var/decl/special_role/traitors = decls_repository.get_decl(/decl/special_role/traitor)
	if(!istype(M) || !M.mind || !(M.mind in traitors.current_antagonists))
		to_chat(target, law)
		laws.clear_zeroth_laws()
		laws.add_zeroth_law(law)
	else
		GLOB.lawchanges.Add("\The [target]'s existing law zero cannot be overriden.")
