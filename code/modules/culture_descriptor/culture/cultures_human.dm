/decl/cultural_info/culture/other
	name = "Other Culture"
	description = "You are from one of the many small, relatively unknown cultures scattered across the galaxy."
	secondary_langs = list(
		/decl/language/human/common,
		/decl/language/sign
	)

/decl/cultural_info/culture/human
	name = "Human Culture"
	description = "You are from one of various planetary cultures of humankind."
	secondary_langs = list(
		/decl/language/human/common,
		/decl/language/sign
	)

/decl/cultural_info/culture/synthetic
	name = "Artificial Intelligence"
	description = "You are a simple artificial intelligence created by humanity to serve a menial purpose."
	secondary_langs = list(
		/decl/language/machine,
		/decl/language/human/common,
		/decl/language/sign
	)

/decl/cultural_info/culture/synthetic/sanitize_name(new_name)
	return sanitizeName(new_name, allow_numbers = TRUE)
