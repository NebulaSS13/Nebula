/obj/item/organ/internal/brain/transfer_identity(var/mob/living/carbon/H)
	if(!brainmob)
		brainmob = new(src)
		brainmob.SetName(H.real_name)
		brainmob.real_name = H.real_name
		brainmob.dna = H.dna.Clone()
		brainmob.timeofhostdeath = H.timeofdeath

	if(H.mind)
		H.mind.transfer_to(brainmob)

	to_chat(brainmob, "<span class='notice'>You feel slightly disoriented. That's normal when you're just \a [initial(src.name)].</span>")
	callHook("debrain", list(brainmob))
	if(!switchToStack(brainmob.ckey))
		crash_with("TODO: Switch to backup or destroy.")
	if(!switchToStack(H.ckey))
		crash_with("TODO: actually do mind shit.")
	var/mob/new_player/player = new()
	player.ckey = src
	to_chat(player, "The lack of a backup or stack means your character is dead for good. Create a new one to continue playing!")
