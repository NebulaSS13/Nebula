/obj/item/documents/tradehouse/account
	name = "tradehouse accounting documents"
	desc = "These contain exhaustive information about tradehouse dealings, with up-to-date information regarding wealth and resources controlled by the house."
	description_antag = "In the wrong hands, the house could certainly find itself disavantaged in dealings in the future."

/obj/item/documents/tradehouse/personnel
	name = "tradehouse personnel data"
	desc = "Val Salian interests are furthered by those who serve the house.  A good house must know all who work for it."
	description_antag = "An enemy of the house could use this to figure out where personnel live and who among them might be a problem to them."

/obj/item/book/skill/organizational/literacy/basic
	name = "younglet's alphabet book"
	author = "Matriarch Ivalini"

/obj/item/book/skill/organizational/literacy/basic/Initialize()
	. = ..()
	title = pick("Younglet's First Human Letterz", "The Curious, Funny, Tasty Snaprat", "The Hungry Hungry Quilldog")
	desc = "A copy of [title] by [author]. It's a thick book, mostly because the pages are made of cardboard. Looks like it's designed to teach juvenile yinglets basic literacy."

/obj/item/book/skill/engineering/engines/prof/magazine
	title = "\"Bad Baxxid\""
