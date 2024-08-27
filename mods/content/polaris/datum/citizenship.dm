/decl/background_detail/citizenship/scg
	name = "Solar Confederate Government"
	description = "The Solar Confederate Government, or SolGov, is a confederation \
	of sovereign member states and protectorates with its capital on Luna in the Sol System. \
	Originating as a unified government for all humanity, SolGov has come \
	to encompass people of many different species, especially positronics, \
	while human-majority systems have since broken from Sol to found their own governments. \
	Vir is a full member state of SolGov, and the leader of one of its four semi-autonomous Regional Blocs."
	language = /decl/language/human/common
	secondary_langs = list(
		/decl/language/human/common,
		/decl/language/sign
		//Tradeband
	)
	size_value = "500+"
	size_heading = "Member States and Protectorates"
	capital = "Luna, Sol"
	founded = "2108"

/decl/background_detail/citizenship/fivearrows
	name = "Five Arrows"
	description = "The Five Arrows are the newest interstellar government, \
	forming in 2570 as the result of the seccession of five systems in SolGov's wealthy Sagittarius Heights region, \
	and soon joined by the Skrellian kingdoms of Kauq'xum. \
	The new government's laissez-faire policy towards economics and automation \
	has spurred an economic boom its leaders promise will utterly transform the region."
	language = /decl/language/human/common
	secondary_langs = list(
		/decl/language/human/common,
		/decl/language/sign,
		/decl/language/skrell,
		//Tradeband
	)
	economic_power = 1.1
	size_value = "6"
	capital = "New Seoul"
	founded = "2570"

/decl/background_detail/citizenship/almach
	name = "Almach Protectorate"
	description = "The Almach Protectorate formed in 2564 after the invasion of the short-lived Almach Association, \
	a mercurial seccesionist group in a brushfire war with SolGov, by an occupation fleet from the Far Kingdoms. \
	After four years of occupation by the Far Kingdoms, the Skrellian military presence withdrew from the region, \
	which has devolved into a loose trade and military league under only notional control by the occupation government. \
	It is noteworthy for strong Mercurial and transhumanist sentiments resulting in a markedly different culture \
	from that accepted in SolGov, and for extreme levels of economic and political instability."
	language = /decl/language/human/common
	secondary_langs = list(
		/decl/language/human/common,
		/decl/language/sign,
		/decl/language/skrell,
		/decl/language/machine
		//Gutter? Tradeband?
	)
	size_value = "3"
	capital = "Carter Interstellar Spaceport, Relan (defacto)"
	founded = "2564"


/decl/background_detail/citizenship/earthnation
	name = "Solar Secessionist"
	description = "A half-dozen systems exist on the borders of SolGov, originally colonized by Solar nationals, \
	which maintain independence from SolGov and from any other interstellar nation. \
	They are as different from each other as they are from Sol, \
	and generally maintain only sporadic diplomatic contact with the motherland."
	language = /decl/language/human/common
	secondary_langs = list(
		/decl/language/human/solcom,
		/decl/language/sign
	)
	size_value = "19"
	size_heading = "Earth Nations"
	capital = "Brasília, Brazil, Sol (defacto)"
	economic_power = 0.9

/decl/background_detail/citizenship/other
	name = "Other Culture"
	description = "You are from one of the many small, relatively unknown cultures scattered across the galaxy."
	language = /decl/language/human/common
	secondary_langs = list(
		/decl/language/human/common,
		/decl/language/sign
	)

/decl/background_detail/citizenship/stateless
	name = "Stateless"
	description = "Statelessness is an extremely uncommon occurance. \
	Any stateless human or positronic in SolGov space is automatically extended SolGov citizenship, \
	as are stateless members of other species who cannot regain citizenship in their homeworld. \
	Most other interstellar states have comperable policies. \
	As such, statelessness tends to be at least semi-voluntary, \
	standing in for allegience to a defunct or unrecognized government \
	or representing a total rejection of all interstellar governments."
	economic_power = 0
	capital = "None"

/decl/background_detail/citizenship/synthetic
	name = "Stateless Drone"
	description = "Drones are considered property in SolGov, \
	and citizenships extended by the Almach Protectorate are not recognized. \
	Thus, statelessness is ubiquituous for them."
	secondary_langs = list(
		/decl/language/machine,
		/decl/language/human/common,
		/decl/language/sign
	)

/decl/background_detail/citizenship/synthetic/sanitize_background_name(new_name)
	return sanitize_name(new_name, allow_numbers = TRUE)
