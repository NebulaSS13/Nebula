/obj/structure/salvage
	icon = 'icons/obj/structures/salvage.dmi'
	abstract_type = /obj/structure/salvage
	tool_interaction_flags = TOOL_INTERACTION_DECONSTRUCT
	material = /decl/material/solid/metal/steel
	var/frame_type = /obj/machinery/constructable_frame/machine_frame
	var/work_skill = SKILL_CONSTRUCTION

/obj/structure/salvage/proc/get_salvageable_components()
	return

/obj/structure/salvage/Initialize(ml, _mat, _reinf_mat)
	. = ..()
	name_prefix = pick("broken", "ruined", "destroyed", "slagged", "damaged")

/obj/structure/salvage/create_dismantled_products(turf/T)
	. = ..()
	if(frame_type)
		new frame_type(T)
	var/list/salvageable_components = get_salvageable_components()
	for(var/comp in salvageable_components)
		if(!salvageable_components[comp] || prob(salvageable_components[comp]))
			new comp(T)
