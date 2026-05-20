/obj/item/mech_equipment/mounted_system
	abstract_type = /obj/item/mech_equipment/mounted_system
	var/obj/item/holding

/obj/item/mech_equipment/mounted_system/attack_self(var/mob/user)
	return holding ? holding.attack_self(user) : ..()

/obj/item/mech_equipment/mounted_system/proc/forget_holding()
	if(holding) //It'd be strange for this to be called with this var unset
		events_repository.unregister(/decl/observ/destroyed, holding, src, PROC_REF(forget_holding))
		holding = null
		if(!QDELETED(src))
			qdel(src)

/obj/item/mech_equipment/mounted_system/Initialize()
	. = ..()
	if(ispath(holding))
		holding = new holding(src)
		events_repository.register(/decl/observ/destroyed, holding, src, PROC_REF(forget_holding))
	if(!istype(holding))
		return
	if(!icon_state)
		icon = holding.icon
		icon_state = holding.icon_state
	SetName(holding.name)
	desc = "[holding.desc] This one is suitable for installation on an exosuit."

/obj/item/mech_equipment/mounted_system/Destroy()
	events_repository.unregister(/decl/observ/destroyed, holding, src, PROC_REF(forget_holding))
	if(holding)
		QDEL_NULL(holding)
	. = ..()

/obj/item/mech_equipment/mounted_system/get_effective_obj()
	return (holding ? holding : src)

/obj/item/mech_equipment/mounted_system/get_hardpoint_status_value()
	return (holding ? holding.get_hardpoint_status_value() : null)

/obj/item/mech_equipment/mounted_system/get_hardpoint_maptext()
	return (holding ? holding.get_hardpoint_maptext() : null)
