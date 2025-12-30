/decl/human_examination //This is essentially a stub-method for modpacks to be able to add onto the human examination stuff due to ... messy stuff.
	var/priority = 0
	/// If non-null, this is inserted before this entry if there is not already a postfix before it.
	var/section_prefix = null
	/// If non-null, this is inserted after this entry if there exist entries after it.
	var/section_postfix = null

/decl/human_examination/proc/do_examine(mob/user, distance, mob/living/human/source, hideflags, decl/pronouns/pronouns) //These can either return text, or should return nothing at all if you're doing to_chat()
	return
