
/mob/living/Login()
	. = ..()
	update_pheromone_markers()

/mob/living/proc/update_pheromone_markers()
	if(client)
		if(can_read_pheromones())
			client.images |= global.pheromone_markers
		else
			client.images -= global.pheromone_markers

/mob/living/proc/can_read_pheromones()
	var/obj/item/organ/internal/pheromone_gland/gland = GET_INTERNAL_ORGAN(src, BP_PHEROMONE_GLAND)
	if(istype(gland) && !gland.is_broken())
		return TRUE
	var/obj/item/implant/pheromone/imp = locate() in get_organ(BP_HEAD)
	if(imp && imp.implanted && !imp.malfunction)
		return TRUE
	return FALSE

/obj/item/organ/internal/pheromone_gland
	name = "pheromone gland"
	desc = "A miscellenaous lump of flesh full of chemicals."
	icon_state = "stomach"
	organ_tag = BP_PHEROMONE_GLAND
	parent_organ = BP_CHEST

/mob/living/get_default_emotes()
	. = ..()
	if(can_read_pheromones())
		var/static/list/pheromone_emotes = list(
			/decl/emote/pheromone/fear,
			/decl/emote/pheromone/calm,
			/decl/emote/pheromone/storm,
			/decl/emote/pheromone/flood,
			/decl/emote/pheromone/newsisters,
			/decl/emote/pheromone/foodgood,
			/decl/emote/pheromone/foodbad,
			/decl/emote/pheromone/happy,
			/decl/emote/pheromone/sad,
			/decl/emote/pheromone/custom
		)
		LAZYDISTINCTADD(., pheromone_emotes)
