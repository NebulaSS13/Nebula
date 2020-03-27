/client/proc/give_spell(mob/T as mob in SSmobs.mob_list) // -- Urist
	set category = "Fun"
	set name = "Give Spell"
	set desc = "Gives a spell to a mob."
	var/spell/S = input("Choose the spell to give to that guy", "ABRAKADABRA") as null|anything in spells
	if(!S) return
	T.add_spell(new S)
	SSstatistics.add_field_details("admin_verb","GS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	log_and_message_admins("gave [key_name(T)] the spell [S].")
