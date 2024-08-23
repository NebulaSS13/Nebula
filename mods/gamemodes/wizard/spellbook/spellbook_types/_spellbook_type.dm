/decl/spellbook
	var/name        = "\improper Book of Tomes"
	var/desc        = "The legendary book of spells of the wizard."
	var/book_desc   = "Holds information on the various tomes available to a wizard"
	var/feedback    = "" //doesn't need one.
	var/book_flags  = NOREVERT
	var/max_uses    = 1
	var/title       = "Book of Tomes"
	var/title_desc  = "This tome marks down all the available tomes for use. Choose wisely, there are no refunds."
	var/list/spells = list(
		/decl/spellbook/standard   = 1,
		/decl/spellbook/cleric     = 1,
		/decl/spellbook/battlemage = 1,
		/decl/spellbook/spatial    = 1,
		/decl/spellbook/druid      = 1
	)
	var/list/sacrifice_reagents
	var/list/sacrifice_objects
	var/list/sacrifice_materials
