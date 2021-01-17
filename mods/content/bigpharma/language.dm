// This really shouldn't be used inround except as a joke, it's primarily just to abuse 
// the random string generator to produce medication names without lots of boilerplate.
/decl/language/bigpharma
	name = "Big Pharma"
	desc = "An arcane series of runes invoked by masters of the dark arts of capitalism and medicine."
	speech_verb = "chants"
	exclaim_verb = "invokes"
	ask_verb = "wails"
	space_chance = 0
	key = "p"
	allow_repeated_syllables = FALSE
	syllables = list(
		"o", "a","flu","o","me","phyto","doce","tha","facto","bena","zeco","ni",
		"me","pro","dize","da","le","ta","to","ba","re","mbi","no","ffi",
		"niu","ven","pedi","lo","tre","pilo","paro","xeti","xyco","lio"
	)
	var/list/endings = list(
		"zole","scept","ban","rone","mide","vir","max","fine","zac","trol",
		"phen","m","tam", "gen", "tol", "dine","ne","taine"
	)
	var/list/marks = list("™️","©️","®️")

/decl/language/bigpharma/get_random_name()
	. = capitalize("[..(FEMALE, 1, rand(2,3), 1)][pick(endings)][pick(marks)]")
