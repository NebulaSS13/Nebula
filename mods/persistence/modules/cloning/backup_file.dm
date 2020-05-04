#define BASE_CLONE_BACKUP_SIZE 10

/datum/computer_file/data/cloning
	filetype = "CLN"
	read_only = TRUE
	var/mob_age			// Mob's age in years.
	var/list/skill_list = list()
	var/list/languages  = list()
	var/mind_id			// Fingerprint of the mob's mind.
	var/datum/dna/dna
	var/backup_date

// Initializes all the data on a backup with an existing mob.
/datum/computer_file/data/cloning/proc/initialize_backup(var/mob/living/H)
	languages = H.languages.Copy()
	skill_list = H.skillset.skill_list
	if(H.mind)
		mind_id = H.mind.unique_id
		mob_age = H.mind.age
	dna = H.dna.Clone()
	backup_date = world.realtime
	var/prefix = copytext(num2hex(backup_date, 8),1,5)
	var/postfix = copytext(num2text(world.timeofday, 6), 2, 7)
	filename = "[prefix]_clone_[postfix]"
	calculate_size()

/datum/computer_file/data/cloning/calculate_size()
	var/file_size = BASE_CLONE_BACKUP_SIZE + round(mob_age / 2) + languages.len
	for(var/decl/hierarchy/skill/S in GLOB.skills)
		file_size += skill_list[S.type]
	size = file_size