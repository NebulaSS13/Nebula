/decl/ability/deity/open_gateway
	name = "Open Gateway"
	desc = "Open a gateway for your master. Don't do it for too long, or you will die."

	cooldown_time = 60 SECONDS
	invocation = "none"
	invocation_type = SpI_NONE

	number_of_channels = 0
	time_between_channels = 200
	ability_icon_state = "const_wall"
	cast_sound = 'sound/effects/meteorimpact.ogg'

/decl/ability/deity/open_gateway/choose_targets()
	var/mob/living/spellcaster = holder
	var/turf/source_turf = get_turf(spellcaster)
	holder.visible_message(SPAN_NOTICE("A gateway opens up underneath \the [spellcaster]!"))
	var/deity
	var/decl/special_role/godcultist/godcult = GET_DECL(/decl/special_role/godcultist)
	if(spellcaster.mind && (spellcaster.mind in godcult.current_antagonists))
		deity = godcult.get_deity(spellcaster.mind)
	return list(new /obj/structure/deity/gateway(source_turf, deity))

/decl/ability/deity/open_gateway/cast(var/list/targets, var/mob/holder, var/channel_count)
	if(prob((channel_count / 5) * 100))
		to_chat(holder, SPAN_DANGER("If you hold the portal open for much longer you'll be ripped apart!"))
	if(channel_count == 6)
		to_chat(holder, SPAN_DANGER("The gateway consumes you... leaving nothing but dust."))
		holder.dust()

/decl/ability/deity/open_gateway/after_spell(var/list/targets)
	QDEL_NULL_LIST(targets)