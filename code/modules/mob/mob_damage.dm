/// Returns TRUE if updates should happen, FALSE if not.
/mob/proc/update_health()
	SHOULD_CALL_PARENT(TRUE)
	return !(status_flags & GODMODE)

// Damage stubs to allow for calling on /mob (usr etc)
/mob/proc/getBruteLoss()
	return 0
/mob/proc/getOxyLoss()
	return 0
/mob/proc/getToxLoss()
	return 0
/mob/proc/getFireLoss()
	return 0
/mob/proc/getHalLoss()
	return 0
/mob/proc/getCloneLoss()
	return 0

/mob/proc/setBruteLoss(var/amount)
	return
/mob/proc/setOxyLoss(var/amount)
	return
/mob/proc/setToxLoss(var/amount)
	return
/mob/proc/setFireLoss(var/amount)
	return
/mob/proc/setHalLoss(var/amount)
	return
/mob/proc/setBrainLoss(var/amount)
	return
/mob/proc/setCloneLoss(var/amount)
	return

/mob/proc/adjustToxLoss(var/amount, var/do_update_health = TRUE)
	return
/mob/proc/adjustFireLoss(var/amount, var/do_update_health = TRUE)
	return
/mob/proc/adjustHalLoss(var/amount, var/do_update_health = TRUE)
	return

/mob/proc/adjustBruteLoss(var/amount, var/do_update_health = TRUE)
	SHOULD_CALL_PARENT(TRUE)
	if(do_update_health)
		update_health()

/mob/proc/adjustOxyLoss(var/damage, var/do_update_health = TRUE)
	SHOULD_CALL_PARENT(TRUE)
	if(do_update_health)
		update_health()

/mob/proc/adjustBrainLoss(var/amount, var/do_update_health = TRUE)
	SHOULD_CALL_PARENT(TRUE)
	if(do_update_health)
		update_health()

/mob/proc/adjustCloneLoss(var/amount, var/do_update_health = TRUE)
	SHOULD_CALL_PARENT(TRUE)
	if(do_update_health)
		update_health()
