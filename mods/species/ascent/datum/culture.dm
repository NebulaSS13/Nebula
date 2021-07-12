/mob/living/carbon/proc/get_gyne_name()
	return dna?.lineage || create_gyne_name()

/proc/create_gyne_name()
	var/gynename = "[capitalize(pick(global.gyne_architecture))] [capitalize(pick(global.gyne_geoforms))]"
	return gynename

//Thanks to:
// - https://en.wikipedia.org/wiki/List_of_landforms
// - https://en.wikipedia.org/wiki/Outline_of_classical_architecture

var/global/list/gyne_geoforms = list(
	"abime",         "abyss",         "ait",         "anabranch",    "arc",           "arch",          "archipelago",  "arete",
	"arroyo",        "atoll",         "ayre",        "badlands",     "bar",           "barchan",       "barrier",      "basin",
	"bay",           "bayou",         "beach",       "bight",        "blowhole",      "blowout",       "bluff",        "bornhardt",
	"braid",         "nest",          "calanque",    "caldera",      "canyon"	,     "cape",          "cave",         "cenote",
	"channel",       "cirque",        "cliff",       "coast",        "col",           "colony",        "cone",         "confluence",
	"corrie",        "cove",          "crater",      "crevasse",     "cryovolcano",   "cuesta",        "cusps",        "yardang",
	"dale",          "dam",           "defile",      "dell",         "delta",         "diatreme",      "dike",         "divide",
	"doab",          "doline",        "dome",        "draw",         "dreikanter",    "drumlin",       "dune",         "ejecta",
	"erg",           "escarpment",    "esker",       "estuary",      "fan",           "fault",         "field",        "firth",
	"fissure",       "fjard",         "fjord",       "flat",         "flatiron",      "floodplain",    "foibe",        "foreland",
	"geyser",        "glacier",       "glen",        "gorge",        "graben",        "gulf",          "gully",        "guyot",
	"headland",      "hill",          "hogback",     "hoodoo",       "horn",          "horst",         "inlet",        "interfluve",
	"island",        "islet",         "isthmus",     "kame",         "karst",         "karst",         "kettle",       "kipuka",
	"knoll",         "lagoon",        "lake",        "lavaka",       "levee",         "loess",         "maar",         "machair",
	"malpas",        "mamelon",       "marsh",       "meander",      "mesa",          "mogote",        "monadnock",    "moraine",
	"moulin",        "nunatak",       "oasis",       "outwash",      "pediment",      "pediplain",     "peneplain",    "peninsula",
	"pingo",         "pit"	,         "plain",       "plateau",      "plug",          "polje",         "pond",         "potrero",
	"pseudocrater",  "quarry",        "rapid",       "ravine",       "reef",          "ria",           "ridge",        "riffle",
	"river",         "sandhill",      "sandur",      "scarp",        "scowle",        "scree",         "seamount",     "shelf",
	"shelter",       "shield",        "shoal",       "shore",        "sinkhole",      "sound",         "spine",        "spit",
	"spring",        "spur",          "strait",      "strandflat",   "strath",        "stratovolcano", "stream",       "subglacier",
	"summit",        "supervolcano",  "surge",       "swamp",        "table",         "tepui",         "terrace",      "terracette",
	"thalweg",       "tidepool",      "tombolo",     "tor",          "towhead",       "tube",          "tunnel",       "turlough",
	"tuya",          "uvala",         "vale",        "valley",       "vent",          "ventifact",     "volcano",      "wadi",
	"waterfall",     "watershed"
)

var/global/list/gyne_architecture = list(
	"barrel",        "annular",       "aynali",      "baroque",      "catalan",       "cavetto",       "catenary",     "cloister",
	"corbel",        "cross",         "cycloidal",   "cylindrical",  "diamond",       "domical",       "fan",          "lierne",
	"muqarnas",      "net",           "nubian",      "ogee",         "ogival",        "parabolic",     "hyperbolic",   "volute",
	"quadripartite", "rampant",       "rear",        "rib",          "sail",          "sexpartite",    "shell",        "stalactite",
	"stellar",       "stilted",       "surbased",    "surmounted",   "timbrel",       "tierceron",     "tripartite",   "tunnel",
	"grid",          "acroterion ",   "aedicule",    "apollarium",   "aegis",         "apse",          "arch",         "architrave",
	"archivolt",     "amphiprostyle", "atlas",       "bracket",      "capital",       "caryatid",      "cella",        "colonnade",
	"column",        "cornice",       "crepidoma",   "crocket",      "cupola",        "decastyle",     "dome",         "eisodos",
	"entablature",   "epistyle ",     "euthynteria", "exedra",       "finial",        "frieze",        "gutta",        "imbrex",
	"tegula",        "keystone",      "metope",      "naos",         "nave",          "opisthodomos",  "orthostates",  "pediment",
	"peristyle",     "pilaster",      "plinth",      "portico",      "pronaos",       "prostyle",      "quoin",        "stoa",
	"suspensura",    "term ",         "tracery",     "triglyph",     "sima",          "stylobate",     "unitary",      "sovereign",
	"grand",         "supreme",       "rampant",     "isolated",     "standalone",    "seminal",       "pedagogical",  "locus",
	"figurative",    "abstract",      "aesthetic",   "grandiose",    "kantian",       "pure",          "conserved",    "brutalist",
	"extemporary",   "theological",   "theoretical", "centurion",    "militant",      "eusocial",      "prominent",    "empirical",
	"key",           "civic",         "analytic",    "formal",       "atonal",        "tonal",         "synchronized", "asynchronous",
	"harmonic",      "discordant",    "upraised",    "sunken",       "life",          "order",         "chaos",        "systemic",
	"system",        "machine",       "mechanical",  "digital",      "electrical",    "electronic",    "somatic",      "cognitive",
	"mobile",        "immobile",      "motile",      "immotile",     "environmental", "contextual",    "stratified",   "integrated",
	"ethical",       "micro",         "macro",       "genetic",      "intrinsic",     "extrinsic",     "academic",     "literary",
	"artisan",       "absolute",      "absolutist",  "autonomous",   "collectivist",  "bicameral",     "colonialist",  "federal",
	"imperial",      "independant",   "managed",     "multilateral", "neutral",       "nonaligned",    "parastatal"
)

/decl/cultural_info/culture/ascent
	name =             "The Ascent"
	language =         /decl/language/mantid/nonvocal
	default_language = /decl/language/mantid
	additional_langs = list(/decl/language/mantid/worldnet, /decl/language/mantid)
	hidden = TRUE
	description = "The Ascent is an ancient, isolated stellar empire composed of the mantid-cephalopodean \
	Kharmaani, the Serpentids, and their gaggle of AI servitors. Day to day existence in the Ascent is \
	largely a matter of navigating a bewildering labyrinth of social obligations, gyne power dynamics, factional \
	tithing, protection rackets, industry taxes and plain old interpersonal backstabbing. Both member cultures of \
	this stellar power are eusocial to an extent, and their society is shaped around the teeming masses \
	of workers, soldiers, technicians and 'lesser' citizens supporting a throng of imperious and all-powerful queens."

/decl/cultural_info/culture/ascent/get_random_name(var/mob/M, var/gender)
	var/mob/living/carbon/human/H = M
	var/lineage = create_gyne_name()
	if(istype(H) && H.dna.lineage)
		lineage = H.dna.lineage
	if(gender == MALE)
		return "[random_id(/decl/species/mantid, 10000, 99999)] [lineage]"
	else
		return "[random_id(/decl/species/mantid, 1, 99)] [lineage]"

/decl/cultural_info/location/kharmaani
	name = "Core"
	language =    /decl/language/mantid/nonvocal
	description = "The Kharmaani are not terribly imaginative when it comes to naming their worlds. Core, \
	their birth star, supports the humid greenhouse-gas-choked giant called Home, which the majority of the \
	populace call their motherland. While the planet's orbit is thickly populated with habitats, factories \
	and defense platforms, each belonging to a different node in the ever-shifting political web of Ascent \
	social culture, the surface itself is a pristine monument to the Kharmaan evolutionary past."
	hidden = TRUE

/decl/cultural_info/faction/ascent_serpentid
	name =        "Ascent Serpentid"
	language =    /decl/language/mantid/nonvocal
	description = "Members of the Ascent tend to be organized along the natural lines of their respective species. \
	For Kharmaani, this is oriented around individual gynes and their power structures. Serpentids have a slightly less \
	manipulative approach, as well as more numerous and less self-absorbed queens. They tend to cluster in broad social groups, \
	usually within the designated oxygen-rich 'mezzanines' each fortress-nest happily allocates to them. As mild as they are by \
	comparison to their fellows, Serpentid political and social culture is still factional and often vicious."
	hidden = TRUE

/decl/cultural_info/faction/ascent_alate
	name =        "Ascent Alate"
	language =    /decl/language/mantid/nonvocal
	description = "The life of an alate is a difficult and frequently short one. Those who survive \
	to maturity have had the violent and uncompromising culture of the Ascent beaten into them with \
	bladed forelimbs for their entire lives. There is no formal schooling within the Kharmaani \
	populations of the Ascent, as alates are so numerous and short-lived that it is something of a \
	waste of resources. However, as they mature, a smart and capable alate will amass an education \
	in practical and theoretical disciplines like piloting, engineering, farming or any number of \
	fields. A particularly lucky (or non-lethally gelded) alate can aspire to a position within the \
	retinue of their mother-gyne, where they will receive directed specialist training and an \
	important role under the careful supervision of the gyne's AI control minds."
	hidden = TRUE

/decl/cultural_info/faction/ascent_gyne
	name =        "Ascent Gyne"
	language =    /decl/language/mantid/nonvocal
	description = "By the time a gyne has survived her 'childhood' and shed the exoskeleton of an \
	alate during a breeding frenzy, she has obtained a master class education in murdering and eating \
	her rivals at the first opportunity, as well as a sideline in a technical or practical field. The \
	rapid growth of her body and brain, and the responsibilities of her position, require every gyne to \
	supplement this with intensive training in management, logistics, military command, sociology, politics \
	and any number of the other critical fields tied into managing a fortress-nest of tens of thousands of \
	individual citizens."
	hidden = TRUE

/decl/cultural_info/religion/kharmaani
	name = "Nest-Lineage Veneration"
	description = "To the Kharmaani, the gyne is the embodiment of both the soul of the land she rules, and the \
	power and prosperity of the genetic lineage she contains. The closest thing they have to spirituality is the \
	veneration of their mother, and the protection and preservation of their worlds."
	hidden = TRUE
