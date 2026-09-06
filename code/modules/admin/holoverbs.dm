
/datum/admins/proc/ai_hologram_set(mob/appear as mob in global.living_mob_list_)
	set name = "Set AI Hologram"
	set desc = "Set an AI's hologram to a mob. Use this verb on the mob you want the hologram to look like."
	set category = "Fun"

	if(!check_rights(R_FUN)) return

	var/list/AIs = list()
	for(var/mob/living/silicon/ai/AI in SSmobs.mob_list)
		AIs += AI

	var/mob/living/silicon/ai/AI = input("Which AI do you want to apply [appear] to as a hologram?") as null|anything in AIs
	if(!AI) return

	var/icon/character_icon = getFlatIcon(appear)
	if(character_icon)
		qdel(AI.holo_icon)//Clear old icon so we're not storing it in memory.
		qdel(AI.holo_icon_longrange)
		AI.holo_icon = getHologramIcon(icon(character_icon), custom_tone = AI.custom_color_tone)
		AI.holo_icon_longrange = getHologramIcon(icon(character_icon), hologram_color = HOLOPAD_LONG_RANGE)

	to_chat(AI, "Your hologram icon has been set to [appear].")
	log_and_message_admins("set [key_name(AI)]'s hologram icon to [key_name(appear)]")
