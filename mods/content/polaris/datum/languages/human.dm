/*//////////////////////////////////////////////////////////////////////////////////////////////////////
	Syllable list compiled in this file based on work by Stefan Trost, available at the following URLs
						https://www.sttmedia.com/syllablefrequency-english
						https://www.sttmedia.com/syllablefrequency-french
						https://www.sttmedia.com/syllablefrequency-german
						https://www.sttmedia.com/syllablefrequency-spanish
						http://www.sttmedia.com/syllablefrequency-russian
	Additional Mandarin syllables originally sourced from:
						http://www.chinahighlights.com/
*///////////////////////////////////////////////////////////////////////////////////////////////////////

/decl/language/human/common
	name = "Galactic Common"
	desc = "Galactic Common, or GalCom is by far the most commonly spoken language in human space, Galactic Common was \
	deliberately engineered over long years by dedicated teams of linguists from 2360 onwards as a hybrid of the earlier \
	Sol Common and Common Skrellian in order to facilitate interspecies communication with the skrell. The language has \
	been adopted as the official language of the Solar Confederate Government, and some degree of fluency is often a \
	requirement for employment by major Trans-Stellar Corporations to ensure that all of their employees are capable of \
	at least basic communication. "
	speech_verb = "says"
	whisper_verb = "whispers"
	colour = ""
	key = "0"
	flags = LANG_FLAG_WHITELISTED
	shorthand = "C"
	partial_understanding = list()
	syllables = list(
	"vol", "zum", "coo","zoo","bi","do","ooz","ite","og","re","si","ite","ish","ar","at","on","ee","east","ma","da", "rim")

/decl/language/human/solcom
	name = "Solar Common"
	desc = "An early standardized hybrid of many languages, including  elements of English, French, Standard \
	Chinese, Hindi, Spanish, Arabic, and Russian, while eliminating phonemes that would prove difficult for any \
	particular existing cultural group to pronounce. It is the common language of the Sol system, but has been \
	phased out of official usage and is beginning to fade like so many of Earth's ancient languages did in \
	centuries prior."
	speech_verb = "says"
	whisper_verb = "whispers"
	colour = ""
	key = "1"
	flags = LANG_FLAG_WHITELISTED
	shorthand = "Sol"
	partial_understanding = list()
	// Duplicates are from different root languages, net effect is symbols that are more common across langs are more common in the generated text
	syllables = list(
		"a", "ad", "ad", "ad", "ah", "ah", "ah", "ai", "ai", "ai", "ai","al", "al", "al", "al", "al", "al", "al", "al", "al",
		"all", "all", "all", "all", "all", "all", "an", "an", "an", "an", "an", "an", "an", "an", "an", "an", "an", "an", "an",
		"and", "and", "and", "and", "and", "and", "ang", "ao", "ar", "ar", "ar", "ar", "ar", "ar", "ar", "ar", "ar", "ar", "ar", "ar",
		"are", "are", "are", "are", "are", "are", "as", "as", "as", "as", "as", "as", "as", "as", "as", "at", "at", "at", "at", "at", "at", "au", "au", "au",
		"ba", "bai", "ban", "bang", "bao", "be", "be", "be", "bei", "ben", "beng", "bi", "bian", "biao", "bie",
		"bin", "bing", "bo", "bo", "bo", "bo", "bu", "but", "but", "but", "but", "but", "but",
		"ca", "cai", "can", "cang", "cao", "ce", "ce", "ce", "ce", "cei", "cen", "ceng", "ci", "ci", "ci", "ci",
		"co", "co", "co", "co", "co", "co", "cong", "cou", "ct", "ct", "ct", "cu", "cuan", "cui", "cun", "cuo",
		"ch", "ch", "ch", "cha", "chai", "chan", "chang", "chao", "che", "chen", "cheng", "chi",
		"chong", "chou", "chu", "chua", "chuai", "chuan", "chuang", "chui", "chun", "chuo",
		"da", "dai", "dan", "dang", "dao", "de", "de", "de", "de", "de", "de", "de", "dei", "den", "deng", "di", "dian",
		"diao", "die", "ding", "diu", "dly", "dly", "dly", "do", "do", "do", "dong", "dou", "du", "duan", "dui", "dun", "duo",
		"e", "e", "e", "e", "ea", "ea", "ea", "ea", "ea", "ea", "ed", "ed", "ed", "ed", "ed", "ed", "eh", "eh", "eh", "ei",
		"el", "el", "el", "el", "el", "el", "em", "em", "em", "en", "en", "en", "en", "en", "en", "en", "en", "en", "en", "en", "en", "en",
		"ent", "ent", "ent", "ent", "ent", "ent", "ep", "ep", "ep", "epo", "epo", "epo",
		"er", "er", "er", "er", "er", "er", "er", "er", "er", "er", "er", "er", "er", "era", "era", "era", "era", "era", "era",
		"ere", "ere", "ere", "ere", "ere", "ere", "es", "es", "es", "es", "es", "es", "es", "es", "es", "es", "es", "es",
		"et", "et", "et", "et", "et", "et", "eu", "eu", "eu", "eve", "eve", "eve", "eve", "eve", "eve", "eve", "eve", "eve",
		"fa", "fan", "fang", "fei", "fen", "feng", "fo", "for", "for", "for", "for", "for", "for", "fou", "fu",
		"ga", "gai", "gan", "gang", "gao", "ge", "gei", "gen", "geng", "gong", "gou", "gu", "gua", "guai", "guan", "guang", "gui", "gun", "guo",
		"ha", "ha", "ha", "ha", "ha", "ha", "ha", "ha", "ha", "ha", "had", "had", "had", "had", "had", "had", "hai", "han", "hang",
		"hao", "hat", "hat", "hat", "hat", "hat", "hat", "he", "he", "he", "he", "he", "he", "he", "he", "he", "he", "hei",
		"hen", "hen", "hen", "hen", "hen", "hen", "hen", "hen", "hen", "hen", "heng", "her", "her", "her", "her", "her", "her",
		"hi", "hi", "hi", "hi", "hi", "hi", "hin", "hin", "hin", "hin", "hin", "hin", "his", "his", "his", "his", "his", "his",
		"hm", "hng", "ho", "ho", "ho", "hong", "hou", "hu", "hua", "huai", "huan", "huang", "hui", "hun", "huo",
		"ie", "ie", "ie", "il", "il", "il", "ime", "ime", "ime", "in", "in", "in", "in", "in", "in", "in", "in", "in", "in", "in", "in",
		"ing", "ing", "ing", "ing", "ing", "ing", "ion", "ion", "ion", "ion", "ion", "ion", "ion", "ion", "ion",
		"is", "is", "is", "is", "is", "is", "is", "is", "is", "it", "it", "it", "it", "it", "it", "ith", "ith", "ith", "ith", "ith", "ith",
		"ji", "jia", "jian", "jiang", "jiao", "jie", "jin", "jing", "jiong", "jiu", "ju", "juan", "jue", "jun", "ka",
		"ka", "ka", "ka", "kai", "kan", "kan", "kan", "kan", "kang", "kao", "ke", "kei", "ken", "keng", "khi", "khi", "khi",
		"ko", "ko", "ko", "kong", "kou", "ku", "kua", "kuai", "kuan", "kuang", "kui", "kun", "kuo", "kur", "kur", "kur",
		"la", "la", "la", "la", "la", "la", "la", "lai", "lan", "lang", "lao",
		"le", "le", "le", "le", "le", "le", "le", "le", "le", "le", "le", "le", "le", "lei", "leng", "li", "lia",
		"lian", "liang","liao", "lie", "lin", "ling", "liu", "lo", "lo", "lo", "long", "lou", "lu", "luan", "lun", "luo",
		"ma", "ma", "ma", "ma", "mai", "man", "mang", "mao", "me", "me", "me", "me", "me", "me", "me", "me", "me", "me", "me", "me", "me",
		"mei", "men", "meng", "mi", "mian", "miao", "mie", "min", "ming", "miu", "mo", "mou", "mu",
		"na", "na", "na", "na", "nai", "nak", "nak", "nak", "nan", "nang", "nao", "nas", "nas", "nas","nd", "nd", "nd", "nd", "nd", "nd",
		"ne", "ne", "ne", "ne", "ne", "ne", "ne", "ne", "ne", "ne", "ne", "ne", "ne", "ne", "ne", "ne", "nei", "nen", "neng",
		"ng", "ng", "ng", "ng", "ng", "ng", "ng", "ni", "nian", "niang", "niao", "nie", "nin", "ning", "niu",
		"no", "no", "no", "no", "no", "no", "no", "no", "no", "non", "non", "non", "nong",
		"not", "not", "not", "not", "not", "not", "not", "not", "not", "nou", "ns", "ns", "ns",
		"nt", "nt", "nt", "nt", "nt", "nt", "nt", "nt", "nt", "nt", "nt", "nt", "nu", "nuan", "nue", "nue", "nue", "nuo",
		"o", "ob", "ob", "ob", "oc", "oc", "oc", "oh", "oh", "oh", "ome", "ome", "ome", "ome", "ome", "ome",
		"on", "on", "on", "on", "on", "on", "on", "on", "on", "op", "op", "op", "or", "or", "or", "or", "or", "or", "or", "or", "or",
		"os", "os", "os", "ot", "ot", "ot", "ou", "ou", "ou", "ou", "ou", "ou", "ou", "ou", "ou", "ou",
		"oul", "oul", "oul", "oul", "oul", "oul", "our", "our", "our", "our", "our", "our",
		"pa", "pa", "pa", "pa", "pa", "pa", "pa", "pa", "pa", "pa", "pai", "pan", "pang", "pao",
		"pe", "pe", "pe", "pei", "pen", "peng", "pi", "pian", "piao", "pie", "pin", "ping", "po", "pou", "pre", "pre", "pre", "pu",
		"qi", "qia", "qian", "qiang", "qiao", "qie", "qin", "qing", "qiong", "qiu", "qu", "qu", "qu", "qu", "qu", "qu", "qu", "quan", "que", "qun",
		"ra", "ra", "ra", "ra", "ra", "ra", "ran", "rang", "rao", "re", "re", "re", "re", "re", "re", "re", "re", "re", "re", "re", "re", "re",
		"ren", "reng", "ri", "ro", "ro", "ro", "rong", "rou", "ru", "rua", "ruan", "rui", "run", "ruo",
		"sa", "sai", "san", "sang", "sao", "se", "se", "se", "se", "se", "se", "se", "se", "se", "se", "se", "se", "se",
		"sei", "sen", "seng", "ser", "ser", "ser", "si", "son", "son", "son", "song", "sou",
		"st", "st", "st", "st", "st", "st", "st", "st", "st", "su", "su", "su", "su", "suan", "sui", "sun", "suo",
		"sha", "sha", "sha", "sha", "shai", "shan", "shang", "shao", "she", "shei", "shen", "sheng", "shi",
		"sho", "sho", "sho", "sho", "sho", "sho", "shou", "shu", "shua", "shuai", "shuan", "shuang", "shui", "shun", "shuo",
		"ta", "ta", "ta", "ta", "ta", "ta", "ta", "tai", "tak", "tak", "tak", "tan", "tang", "tao",
		"te", "te", "te", "te", "te", "te", "te", "te", "te", "te", "te", "te", "te", "te", "te", "te",
		"ted", "ted", "ted", "ted", "ted", "ted", "teng", "ter", "ter", "ter", "ter", "ter", "ter",
		"th", "th", "th", "th", "th", "th", "tha", "tha", "tha", "tha", "tha", "tha", "the", "the", "the", "the", "the", "the",
		"thi", "thi", "thi", "thi", "thi", "thi", "ti", "ti", "ti", "ti", "ti", "ti", "ti", "ti", "ti", "ti", "tian", "tiao", "tie",
		"ting", "to", "to", "to", "to", "to", "to", "to", "to", "to", "to", "to", "to", "tod", "tod", "tod", "tong",
		"tou", "tou", "tou", "tou", "tr", "tr", "tr", "tu", "tuan", "tui", "tun", "tuo",
		"ue", "ue", "ue", "ue", "ue", "ue", "un", "un", "un", "ur", "ur", "ur", "us", "us", "us",
		"v", "v", "v", "ve", "ve", "ve", "ve", "ve", "ve", "ve", "ve", "ve", "vse", "vse", "vse",
		"wa", "wa", "wa", "wa", "wa", "wa", "wa", "wai", "wan", "wang", "wei", "wen", "weng", "wo", "wu",
		"xi", "xia", "xian", "xiang", "xiao", "xie", "xin", "xing", "xiong", "xiu", "xu", "xuan", "xue", "xun",
		"ya", "yan", "yang", "yao", "ye", "yeg", "yeg", "yeg", "yey", "yey", "yey", "yi", "yin", "ying", "yong", "you", "yu", "yuan", "yue", "yun",
		"za", "zai", "zan", "zang", "zao", "ze", "zei", "zen", "zeng", "zi", "zong", "zou", "zu", "zuan", "zui", "zun", "zuo", 
		"zha", "zhai", "zhan", "zhang", "zhao", "zhe", "zhei", "zhen", "zheng", "zhi",
		"zhong", "zhou", "zhu", "zhua", "zhuai", "zhuan", "zhuang", "zhui", "zhun", "zhuo"
	)

/decl/language/human/sivian
	name = "Sivian Creole"
	desc = "A hybrid language local to the Vir system, heavily incorporating elements from the local languages of early Scandinavian colonists into a form of Galactic Common."
	speech_verb = "says"
	whisper_verb = "whispers"
	colour = ""
	key = "7"
	flags = LANG_FLAG_WHITELISTED
	shorthand = "Sif"
	space_chance = 45
	partial_understanding = list()
	syllables = list (
	"all", "are", "det", "enn", "ere", "hen", "kan", "lig", "men", "ren", "som", "ver", "vir", "var", "vis", "ikk", "ter", "ork",
	"den", "ing", "jeg", "jag", "han", "hir", "hil", "ans", "kan", "kir", "bor", "bir", "um", "om", "ve", "ur", "ha", "he", "hyu",
	"er", "ad", "ath", "bjo,", "gun", "gur", "gir", "fyr", "thar", "thir", "thad", "thei", "ayr", "for", "fjo", "jor", "jik", "jar",
	"yor", "yar", "yik", "rik", "os", "olm", "erm", "ferk", "borg", "bork", "smorg", // Scandi
	"meng", "tao", "bu", "qu", "ai", "xin", "pin", "wa", "cang", "chun", "ding", "gang", "ling", "gao", "jian", "sun", "tong",
	"xie", "zu", "miao", "po", "nu", // Chinese (galcom)
	"our", "oul", "tou", "eve", "ome", "ion", "ais", // Romance (galcom)
	"zaoo", "zix", "vol") //Skrell (galcom)
