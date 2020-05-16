var/list/adjectives
var/list/nouns

/datum/uniqueness_generator/phrase/Generate()
	if(!adjectives)
		adjectives = file2list('mods/persistence/english-adjectives.txt')
	if(!nouns)
		nouns = file2list('mods/persistence/english-nouns.txt')

	var/phrase = "[pick(adjectives)] [pick(nouns)]"
	return phrase