/obj/item/ability/psionic/tinker
	name = "psychokinetic tool"
	icon_state = "tinker"
	_base_attack_force = 1

/obj/item/ability/psionic/tinker/Initialize()
	. = ..()

	var/use_tool_quality = TOOL_QUALITY_WORST
	var/mob/living/owner = loc
	var/datum/ability_handler/psionics/psi = istype(owner) && owner.get_ability_handler(/datum/ability_handler/psionics)
	if(psi)
		switch(psi.get_rank(PSI_PSYCHOKINESIS))
			if(PSI_RANK_LATENT)
				use_tool_quality = TOOL_QUALITY_BAD
			if(PSI_RANK_OPERANT)
				use_tool_quality = TOOL_QUALITY_MEDIOCRE
			if(PSI_RANK_MASTER)
				use_tool_quality = TOOL_QUALITY_DEFAULT
			if(PSI_RANK_GRANDMASTER)
				use_tool_quality = TOOL_QUALITY_GOOD
			if(PSI_RANK_PARAMOUNT)
				use_tool_quality = TOOL_QUALITY_BEST

	set_extension(src, /datum/extension/tool/variable,
		list(
			TOOL_CROWBAR =     use_tool_quality,
			TOOL_SCREWDRIVER = use_tool_quality,
			TOOL_WRENCH =      use_tool_quality,
			TOOL_WIRECUTTERS = use_tool_quality
		),
		null,
		list(
			TOOL_CROWBAR =     'sound/effects/psi/power_fabrication.ogg',
			TOOL_SCREWDRIVER = 'sound/effects/psi/power_fabrication.ogg',
			TOOL_WRENCH =      'sound/effects/psi/power_fabrication.ogg',
			TOOL_WIRECUTTERS = 'sound/effects/psi/power_fabrication.ogg'
		)
	)

/obj/item/ability/psionic/tinker/on_update_icon()
	. = ..()
	var/datum/extension/tool/variable/tool = get_extension(src, /datum/extension/tool)
	if(istype(tool))
		var/decl/tool_archetype/tool_archetype = GET_DECL(tool.current_tool)
		name = "psychokinetic [lowertext(tool_archetype.name)]"
	else
		name = initial(name)
