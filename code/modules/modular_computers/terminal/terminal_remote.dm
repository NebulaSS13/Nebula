// The computer var is for the remote computer with these.
/datum/terminal/remote
	name = "Remote Terminal"
	var/datum/extension/interactive/os/origin_computer

/datum/terminal/remote/New(mob/user, datum/extension/interactive/os/computer, datum/extension/interactive/os/origin)
	origin_computer = origin
	..(user, computer)

/datum/terminal/remote/Destroy()
	if(origin_computer && origin_computer.terminals)
		origin_computer.terminals -= src
	origin_computer = null
	return ..()

/datum/terminal/remote/can_use(mob/user)
	if(!user)
		return FALSE

	if(!computer || !computer.on || !origin_computer || !origin_computer.on)
		return FALSE
	if(!CanInteractWith(user, origin_computer, global.default_topic_state))
		return FALSE

	if(!origin_computer.get_network_status() || !computer.get_network_status())
		return FALSE

	return TRUE

/datum/terminal/remote/get_account_computer()
	return origin_computer