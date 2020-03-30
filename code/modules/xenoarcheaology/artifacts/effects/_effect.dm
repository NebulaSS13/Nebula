/datum/artifact_effect
	var/name = "unknown"
	var/effect = EFFECT_TOUCH
	var/effectrange = 4
	var/atom/holder
	var/activated = 0
	var/chargelevel = 0
	var/chargelevelmax = 10
	var/artifact_id = ""
	var/effect_type = 0

	var/datum/artifact_trigger/trigger

/datum/artifact_effect/New(var/atom/location)
	..()
	holder = location
	effect = rand(0, MAX_EFFECT)
	var/triggertype = pick(subtypesof(/datum/artifact_trigger))
	trigger = new triggertype

	//this will be replaced by the excavation code later, but it's here just in case
	artifact_id = "[pick(GLOB.greek_letters)]-[rand(100,999)]"

	//random charge time and distance
	switch(pick(100;1, 50;2, 25;3))
		if(1)
			//short range, short charge time
			chargelevelmax = rand(3, 20)
			effectrange = rand(1, 3)
		if(2)
			//medium range, medium charge time
			chargelevelmax = rand(15, 40)
			effectrange = rand(5, 15)
		if(3)
			//large range, long charge time
			chargelevelmax = rand(20, 120)
			effectrange = rand(20, 40)

/datum/artifact_effect/Destroy()
	QDEL_NULL(trigger)
	. = ..()
	
/datum/artifact_effect/proc/ToggleActivate(var/reveal_toggle = 1)
	//so that other stuff happens first
	spawn(0)
		if(activated)
			activated = 0
		else
			activated = 1
		if(reveal_toggle && holder)
			holder.update_icon()
			var/display_msg
			if(activated)
				display_msg = pick("momentarily glows brightly!","distorts slightly for a moment!","flickers slightly!","vibrates!","shimmers slightly for a moment!")
			else
				display_msg = pick("grows dull!","fades in intensity!","suddenly becomes very still!","suddenly becomes very quiet!")
			var/atom/toplevelholder = holder
			while(!istype(toplevelholder.loc, /turf))
				toplevelholder = toplevelholder.loc
			toplevelholder.visible_message("<span class='warning'>\icon[toplevelholder] [toplevelholder] [display_msg]</span>")

/datum/artifact_effect/proc/DoEffectTouch(var/mob/user)
/datum/artifact_effect/proc/DoEffectAura(var/atom/holder)
/datum/artifact_effect/proc/DoEffectPulse(var/atom/holder)
/datum/artifact_effect/proc/UpdateMove()

/datum/artifact_effect/proc/process()
	if(chargelevel < chargelevelmax)
		chargelevel++

	if(activated)
		if(effect == EFFECT_AURA)
			DoEffectAura()
		else if(effect == EFFECT_PULSE && chargelevel >= chargelevelmax)
			chargelevel = 0
			DoEffectPulse()

/datum/artifact_effect/proc/getDescription()
	. = "<b>"
	switch(effect_type)
		if(EFFECT_ENERGY)
			. += "Concentrated energy emissions"
		if(EFFECT_PSIONIC)
			. += "Intermittent psionic wavefront"
		if(EFFECT_ELECTRO)
			. += "Electromagnetic energy"
		if(EFFECT_PARTICLE)
			. += "High frequency particles"
		if(EFFECT_ORGANIC)
			. += "Organically reactive exotic particles"
		if(EFFECT_BLUESPACE)
			. += "Interdimensional/bluespace? phasing"
		if(EFFECT_SYNTH)
			. += "Atomic synthesis"
		else
			. += "Low level energy emissions"

	. += "</b> have been detected <b>"

	switch(effect)
		if(EFFECT_TOUCH)
			. += "interspersed throughout substructure and shell."
		if(EFFECT_AURA)
			. += "emitting in an ambient energy field."
		if(EFFECT_PULSE)
			. += "emitting in periodic bursts."
		else
			. += "emitting in an unknown way."

	. += "</b>"

	. += " Activation index involves [trigger]."

//returns 0..1, with 1 being no protection and 0 being fully protected
/proc/GetAnomalySusceptibility(var/mob/living/carbon/human/H)
	if(!istype(H))
		return 1

	. = 1
	for(var/obj/item/I in H.get_equipped_items())
		. -= I.anomaly_shielding

	return max(0, .)

//used by anomaly power harvesters
/datum/artifact_effect/proc/copy()
	var/datum/artifact_effect/E = new type()
	E.effectrange = effectrange
	E.artifact_id = artifact_id
	E.effect = effect
	E.effect = effect
	E.chargelevelmax = chargelevelmax
	E.trigger = trigger.copy()
	return E