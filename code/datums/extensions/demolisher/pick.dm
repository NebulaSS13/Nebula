/datum/extension/demolisher/pick
	demolish_verb = "dismantling"
	demolish_sound = 'sound/items/Crowbar.ogg'

/datum/extension/demolisher/pick/try_demolish(mob/user, turf/wall/wall)
	var/obj/item/pick = holder
	if(pick.material?.hardness < wall.get_material()?.hardness)
		to_chat(user, SPAN_WARNING("\The [holder] is not hard enough to cut through [wall.get_material().solid_name]."))
		return TRUE
	return ..()

/datum/extension/demolisher/pick/get_demolish_delay(turf/wall/wall)
	var/obj/item/pick = holder
	return pick.get_expected_tool_use_delay(TOOL_PICK, ..())

/datum/extension/demolisher/pick/get_demolish_verb()
	var/obj/item/pick = holder
	return pick.get_tool_message(TOOL_PICK)

/datum/extension/demolisher/pick/get_demolish_sound()
	var/obj/item/pick = holder
	return pick.get_tool_sound(TOOL_PICK)
