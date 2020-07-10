/obj/item/organ/internal/augment/faulty
	name = "malfunctioning implant"
	desc = "An augment that was badly installed. This one is malfunctioning."
	material = /decl/material/solid/metal/steel
	var/timer_id
	var/min_time = 1 MINUTES
	var/max_time = 10 MINUTES
	var/obj/item/organ/external/limb

/obj/item/organ/internal/augment/faulty/onInstall()
	. = ..()
	limb = owner.get_organ(parent_organ)
	begin_malfunction()

/obj/item/organ/internal/augment/faulty/onRemove()
	. = ..()
	limb = null
	deltimer(timer_id)
	timer_id = null

/obj/item/organ/internal/augment/faulty/proc/begin_malfunction()
	if(!owner)
		return
	timer_id = addtimer(CALLBACK(src, .proc/do_malfunction), rand(min_time, max_time), TIMER_STOPPABLE | TIMER_UNIQUE | TIMER_OVERRIDE | TIMER_NO_HASH_WAIT)

/obj/item/organ/internal/augment/faulty/proc/do_malfunction()
	if(!owner)
		timer_id = null
		return
	begin_malfunction()
	on_malfunction()

/obj/item/organ/internal/augment/faulty/proc/on_malfunction()
	// Insert malfunction code here.