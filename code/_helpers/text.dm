/*
 * Holds procs designed to help with filtering text
 * Contains groups:
 *			SQL sanitization
 *			Text sanitization
 *			Text searches
 *			Text modification
 *			Misc
 */


/*
 * SQL sanitization
 */

// Run all strings to be used in an SQL query through this proc first to properly escape out injection attempts.
/proc/sanitize_sql(t)
	var/sqltext = dbcon.Quote("[t]") // http://www.byond.com/forum/post/2218538
	return copytext(sqltext, 2, -1)

/*
 * Text sanitization
 */

/**
 * Strip out the special beyond characters for \proper and \improper
 * from text that will be sent to the browser.
 */
#define strip_improper(input_text) replacetext(replacetext(input_text, "\proper", ""), "\improper", "")

//Used for preprocessing entered text
//Added in an additional check to alert players if input is too long
/proc/sanitize(input, max_length = MAX_MESSAGE_LEN, encode = TRUE, trim = TRUE, extra = TRUE, ascii_only = FALSE)
	if(!input)
		return

	if(max_length)
		var/input_length = length_char(input)
		if(input_length > max_length)
			to_chat(usr, SPAN_WARNING("Your message is too long by [input_length - max_length] character\s."))
			return
		input = copytext_char(input, 1, max_length + 1)

	input = strip_improper(input)

	if(extra)
		input = replace_characters(input, list("\n"=" ","\t"=" "))

	if(ascii_only)
		// Some procs work differently depending on unicode/ascii string
		// You should always consider this with any text processing work
		// More: http://www.byond.com/docs/ref/info.html#/{notes}/Unicode
		//       http://www.byond.com/forum/post/2520672
		input = strip_non_ascii(input)
	else
		// Strip Unicode control/space-like chars here exept for line endings (\n,\r) and normal space (0x20)
		// codes from https://www.compart.com/en/unicode/category/
		//            https://en.wikipedia.org/wiki/Whitespace_character#Unicode
		var/static/regex/unicode_control_chars = regex(@"[\u0001-\u0009\u000B\u000C\u000E-\u001F\u007F\u0080-\u009F\u00A0\u1680\u180E\u2000-\u200D\u2028\u2029\u202F\u205F\u2060\u3000\uFEFF]", "g")
		input = unicode_control_chars.Replace(input, "")

	if(encode)
		// In addition to processing html, html_encode removes byond formatting codes like "\red", "\i" and other.
		// It is important to avoid double-encode text, it can "break" quotes and some other characters.
		// Also, keep in mind that escaped characters don't work in the interface (window titles, lower left corner of the main window, etc.)
		input = html_encode(input)
	else
		// If not need encode text, simply remove < and >
		// note: we can also remove here byond formatting codes: 0xFF + next byte
		input = replace_characters(input, list("<"=" ", ">"=" "))

	if(trim)
		input = trim(input)

	return input

//Run sanitize(), but remove <, >, " first to prevent displaying them as &gt; &lt; &34; in some places after html_encode().
//Best used for sanitize object names, window titles.
//If you have a problem with sanitize() in chat, when quotes and >, < are displayed as html entites -
//this is a problem of double-encode(when & becomes &amp;), use sanitize() with encode=0, but not the sanitize_safe()!
/proc/sanitize_safe(input, max_length = MAX_MESSAGE_LEN, encode = TRUE, trim = TRUE, extra = TRUE, ascii_only = FALSE)
	return sanitize(replace_characters(input, list(">"=" ","<"=" ", "\""="'")), max_length, encode, trim, extra, ascii_only)

/proc/paranoid_sanitize(t)
	var/regex/alphanum_only = regex("\[^a-zA-Z0-9# ,.?!:;()]", "g")
	return alphanum_only.Replace(t, "#")

//Filters out undesirable characters from names
/proc/sanitize_name(input, max_length = MAX_NAME_LEN, allow_numbers = 0, force_first_letter_uppercase = TRUE)
	if(!input || length_char(input) > max_length)
		return //Rejects the input if it is null or if it is longer then the max length allowed

	var/number_of_alphanumeric	= 0
	var/last_char_group			= 0
	var/output = ""

	var/char = ""
	var/bytes_length = length(input)
	var/ascii_char
	for(var/i = 1, i <= bytes_length, i += length(char))
		char = input[i]

		ascii_char = text2ascii(char)

		switch(ascii_char) //todo: unicode names?
			// A  .. Z
			if(65 to 90)			//Uppercase Letters
				output += ascii2text(ascii_char)
				number_of_alphanumeric++
				last_char_group = 4

			// a  .. z
			if(97 to 122)			//Lowercase Letters
				if(last_char_group<2 && force_first_letter_uppercase)
					output += ascii2text(ascii_char-32)	//Force uppercase first character
				else
					output += ascii2text(ascii_char)
				number_of_alphanumeric++
				last_char_group = 4

			// 0  .. 9
			if(48 to 57)			//Numbers
				if(!last_char_group)		continue	//suppress at start of string
				if(!allow_numbers)			continue
				output += ascii2text(ascii_char)
				number_of_alphanumeric++
				last_char_group = 3

			// '  -  .
			if(39,45,46)			//Common name punctuation
				if(!last_char_group) continue
				output += ascii2text(ascii_char)
				last_char_group = 2

			// ~   |   @  :  #  $  %  &  *  +
			if(126,124,64,58,35,36,37,38,42,43)			//Other symbols that we'll allow (mainly for AI)
				if(!last_char_group)		continue	//suppress at start of string
				if(!allow_numbers)			continue
				output += ascii2text(ascii_char)
				last_char_group = 2

			//Space
			if(32)
				if(last_char_group <= 1)	continue	//suppress double-spaces and spaces at start of string
				output += ascii2text(ascii_char)
				last_char_group = 1
			else
				return

	if(number_of_alphanumeric < 2)	return		//protects against tiny names like "A" and also names like "' ' ' ' ' ' ' '"

	if(last_char_group == 1)
		output = copytext(output, 1, -1)	//removes the last character (in this case a space)

	return output

// UNICODE: Convert to regex?

//Used to strip text of everything but letters and numbers, make letters lowercase, and turn spaces into .'s.
//Make sure the text hasn't been encoded if using this.
/proc/sanitize_for_account(text)
	if(!text) return ""
	var/list/dat = list()
	var/last_was_fullstop = 1
	for(var/i=1, i<=length(text), i++)
		var/ascii_char = text2ascii(text,i)
		switch(ascii_char)
			if(65 to 90)	//A-Z, make them lowercase
				dat += ascii2text(ascii_char + 32)
				last_was_fullstop = 0
			if(97 to 122)	//a-z
				dat += ascii2text(ascii_char)
				last_was_fullstop = 0
			if(48 to 57)	//0-9
				dat += ascii2text(ascii_char)
				last_was_fullstop = 0
			if(32)			//space
				if(last_was_fullstop)
					continue
				dat += "."		//We turn these into ., but avoid repeats or . at start.
				last_was_fullstop = 1
			if(46)			//.
				if(last_was_fullstop)
					continue
				dat += "."
				last_was_fullstop = 1
	if(dat[length(dat)] == ".")	//kill trailing .
		dat.Cut(length(dat))
	return jointext(dat, null)

// Strips text of everything alphanumeric characters, '_' and '-'. Converts spaces to '_'
/proc/sanitize_for_group(text)
	if(!text) return ""
	var/list/dat = list()
	for(var/i=1, i<=length(text), i++)
		var/ascii_char = text2ascii(text,i)
		switch(ascii_char)
			if(65 to 90)	//A-Z
				dat += ascii2text(ascii_char)
			if(97 to 122)	//a-z
				dat += ascii2text(ascii_char)
			if(48 to 57)	//0-9
				dat += ascii2text(ascii_char)
			if(45, 95)			//-, _
				dat += ascii2text(ascii_char)
			if(32)			//space
				dat += "_"
	return jointext(dat, null)

//Used to strip text of everything but letters and numbers, and select special symbols.
//Requires that the filename has an alphanumeric character.
/proc/sanitize_for_file(text)
	if(!text) return ""
	var/list/dat = list()
	var/has_alphanumeric = FALSE
	var/last_was_fullstop = FALSE
	for(var/i=1, i<=length(text), i++)
		var/ascii_char = text2ascii(text,i)
		switch(ascii_char)
			if(65 to 90)	//A-Z
				dat += ascii2text(ascii_char)
				has_alphanumeric = TRUE
				last_was_fullstop = FALSE
			if(97 to 122)	//a-z
				dat += ascii2text(ascii_char)
				has_alphanumeric = TRUE
				last_was_fullstop = FALSE
			if(48 to 57)	//0-9
				dat += ascii2text(ascii_char)
				has_alphanumeric = TRUE
				last_was_fullstop = FALSE
			if(32)			//space
				dat += ascii2text(ascii_char)
				last_was_fullstop = FALSE
			if(33, 36, 40, 41, 42, 45, 95) //!, $, (, ), *, -, _
				dat += ascii2text(ascii_char)
				last_was_fullstop = FALSE
			if(46)			//.
				if(last_was_fullstop) // No repeats of . to avoid confusion with ..
					continue
				dat += ascii2text(ascii_char)
				last_was_fullstop = TRUE

	if(!has_alphanumeric)
		return ""

	if(dat[length(dat)] == ".")	//kill trailing .
		dat.Cut(length(dat))
	return jointext(dat, null)


// UNICODE: Convert to regex?

//Returns null if there is any bad text in the string
/proc/reject_bad_text(var/text, var/max_length=512)
	if(length(text) > max_length)	return			//message too long
	var/non_whitespace = 0
	for(var/i=1, i<=length(text), i++)
		switch(text2ascii(text,i))
			if(62,60,92,47)	return			//rejects the text if it contains these bad characters: <, >, \ or /
			if(127 to 255)	return			//rejects non-ASCII letters
			if(0 to 31)		return			//more weird stuff
			if(32)			continue		//whitespace
			else			non_whitespace = 1
	if(non_whitespace)		return text		//only accepts the text if it has some non-spaces


//Old variant. Haven't dared to replace in some places.
/proc/sanitize_old(var/t,var/list/repl_chars = list("\n"="#","\t"="#"))
	return html_encode(replace_characters(t,repl_chars))

/*
 * Text searches
 */

//Checks the beginning of a string for a specified sub-string
//Returns the position of the substring or 0 if it was not found
/proc/dd_hasprefix(text, prefix)
	var/start = 1
	var/end = length(prefix) + 1
	return findtext(text, prefix, start, end)

//Checks the beginning of a string for a specified sub-string. This proc is case sensitive
//Returns the position of the substring or 0 if it was not found
/proc/dd_hasprefix_case(text, prefix)
	var/start = 1
	var/end = length(prefix) + 1
	return findtextEx(text, prefix, start, end)

//Checks the end of a string for a specified substring.
//Returns the position of the substring or 0 if it was not found
/proc/dd_hassuffix(text, suffix)
	var/start = length(text) - length(suffix)
	if(start)
		return findtext(text, suffix, start, null)
	return

//Checks the end of a string for a specified substring. This proc is case sensitive
//Returns the position of the substring or 0 if it was not found
/proc/dd_hassuffix_case(text, suffix)
	var/start = length(text) - length(suffix)
	if(start)
		return findtextEx(text, suffix, start, null)

/*
 * Text modification
 */

/proc/replace_characters(t, list/repl_chars)
	for(var/char in repl_chars)
		t = replacetext(t, char, repl_chars[char])
	return t

/proc/random_string(length, list/characters)
	. = ""
	for (var/i in 1 to length)
		. += pick(characters)

//Adds 'u' number of zeros ahead of the text 't'
/proc/add_zero(t, u)
	return pad_left(t, u, "0")

//Adds 'u' number of spaces ahead of the text 't'
/proc/add_lspace(t, u)
	return pad_left(t, u, " ")

//Adds 'u' number of spaces behind the text 't'
/proc/add_tspace(t, u)
	return pad_right(t, u, " ")

// Adds the required amount of 'character' in front of 'text' to extend the lengh to 'desired_length', if it is shorter
// No consideration are made for a multi-character 'character' input
/proc/pad_left(text, desired_length, character)
	var/padding = generate_padding(length_char(text), desired_length, character)
	return length(padding) ? "[padding][text]" : text

// Adds the required amount of 'character' after 'text' to extend the lengh to 'desired_length', if it is shorter
// No consideration are made for a multi-character 'character' input
/proc/pad_right(text, desired_length, character)
	var/padding = generate_padding(length_char(text), desired_length, character)
	return length(padding) ? "[text][padding]" : text

/proc/generate_padding(current_length, desired_length, character)
	if(current_length >= desired_length)
		return ""
	var/characters = list()
	for(var/i = 1 to (desired_length - current_length))
		characters += character
	return JOINTEXT(characters)

// Returns a string with reserved characters and spaces before the first letter removed
// not work for unicode spaces - you should cleanup them first with sanitize()
/proc/trim_left(text)
	for (var/i = 1 to length(text))
		if (text2ascii(text, i) > 32)
			return copytext(text, i)
	return ""

// Returns a string with reserved characters and spaces after the last letter removed
// not work for unicode spaces - you should cleanup them first with sanitize()
/proc/trim_right(text)
	for (var/i = length(text), i > 0, i--)
		if (text2ascii(text, i) > 32)
			return copytext(text, 1, i + 1)

	return ""

// Returns a string with reserved characters and spaces before the first word and after the last word removed.
// not work for unicode spaces - you should cleanup them first with sanitize()
/proc/trim(text)
	return trim_left(trim_right(text))

//Returns a string with the first element of the string capitalized.
/proc/capitalize(text)
	if(text)
		text = uppertext(text[1]) + copytext(text, 1 + length(text[1]))
	return text

//Returns a string with the first element of the every word of the string capitalized.
/proc/capitalize_words(text)
	var/list/S = splittext(text, " ")
	var/list/M = list()
	for (var/w in S)
		M += capitalize(w)
	return jointext(M, " ")

/proc/strip_non_ascii(text)
	var/static/regex/non_ascii_regex = regex(@"[^\x00-\x7F]+", "g")
	return non_ascii_regex.Replace(text, "")

/proc/strip_html_simple(t, limit = MAX_MESSAGE_LEN)
	var/list/strip_chars = list("<",">")
	t = copytext(t,1,limit)
	for(var/char in strip_chars)
		var/index = findtext(t, char)
		while(index)
			t = copytext(t, 1, index) + copytext(t, index+1)
			index = findtext(t, char)
	return t

//This proc strips html properly, remove < > and all text between
//for complete text sanitizing should be used sanitize()
/proc/strip_html_properly(input)
	if(!input)
		return
	var/opentag = 1 //These store the position of < and > respectively.
	var/closetag = 1
	while(1)
		opentag = findtext(input, "<")
		closetag = findtext(input, ">")
		if(closetag && opentag)
			if(closetag < opentag)
				input = copytext(input, (closetag + 1))
			else
				input = copytext(input, 1, opentag) + copytext(input, (closetag + 1))
		else if(closetag || opentag)
			if(opentag)
				input = copytext(input, 1, opentag)
			else
				input = copytext(input, (closetag + 1))
		else
			break

	return input

//This proc fills in all spaces with the "replace" var (* by default) with whatever
//is in the other string at the same spot (assuming it is not a replace char).
//This is used for fingerprints
/proc/stringmerge_ascii(text, compare,replace = "*")
	var/newtext = text
	if(length(text) != length(compare))
		return 0
	for(var/i = 1, i < length(text), i++)
		var/a = copytext(text,i,i+1)
		var/b = copytext(compare,i,i+1)
		//if it isn't both the same letter, or if they are both the replacement character
		//(no way to know what it was supposed to be)
		if(a != b)
			if(a == replace) //if A is the replacement char
				newtext = copytext(newtext,1,i) + b + copytext(newtext, i+1)
			else if(b == replace) //if B is the replacement char
				newtext = copytext(newtext,1,i) + a + copytext(newtext, i+1)
			else //The lists disagree, Uh-oh!
				return 0
	return newtext

//This proc returns the number of chars of the string that is the character
//This is used for detective work to determine fingerprint completion.
/proc/stringpercent_ascii(text,character = "*")
	if(!text || !character)
		return 0
	var/count = 0
	for(var/i = 1, i <= length(text), i++)
		var/a = copytext(text,i,i+1)
		if(a == character)
			count++
	return count

/proc/reverse_text(text = "")
	var/new_text = ""
	var/bytes_length = length(text)
	var/letter = ""
	for(var/i = 1, i <= bytes_length, i += length(letter))
		letter = text[i]
		new_text = letter + new_text
	return new_text

//Used in preferences' SetFlavorText and human's set_flavor verb
//Previews a string of len or less length
/proc/TextPreview(var/string,var/len=40)
	if(length(string) <= len)
		if(!length(string))
			return "\[...\]"
		else
			return string
	else
		return "[copytext_preserve_html(string, 1, 37)]..."

//alternative copytext() for encoded text, doesn't break html entities (&#34; and other)
/proc/copytext_preserve_html(var/text, var/first, var/last)
	return html_encode(copytext(html_decode(text), first, last))

/proc/create_text_tag(var/tagname, var/tagdesc = tagname, var/client/C = null)
	if(!(C && C.get_preference_value(/datum/client_preference/chat_tags) == PREF_SHOW))
		return tagdesc
	return "<IMG src='\ref['./icons/chattags.dmi']' class='text_tag' iconstate='[tagname]'" + (tagdesc ? " alt='[tagdesc]'" : "") + ">"

/proc/contains_az09(var/input)
	for(var/i=1, i<=length(input), i++)
		var/ascii_char = text2ascii(input,i)
		switch(ascii_char)
			// A  .. Z
			if(65 to 90)			//Uppercase Letters
				return 1
			// a  .. z
			if(97 to 122)			//Lowercase Letters
				return 1

			// 0  .. 9
			if(48 to 57)			//Numbers
				return 1
	return 0

/proc/generateRandomString(var/length)
	. = list()
	for(var/a in 1 to length)
		var/letter = rand(33,126)
		. += ascii2text(letter)
	. = jointext(.,null)

#define starts_with(string, substring) (copytext(string,1,1+length(substring)) == substring)

/proc/pencode2html(t)
	t = replacetext(t, "\n", "<BR>")
	t = replacetext(t, "\[center\]", "<center>")
	t = replacetext(t, "\[/center\]", "</center>")
	t = replacetext(t, "\[br\]", "<BR>")
	t = replacetext(t, "\[b\]", "<B>")
	t = replacetext(t, "\[/b\]", "</B>")
	t = replacetext(t, "\[i\]", "<I>")
	t = replacetext(t, "\[/i\]", "</I>")
	t = replacetext(t, "\[u\]", "<U>")
	t = replacetext(t, "\[/u\]", "</U>")
	t = replacetext(t, "\[time\]", "[stationtime2text()]")
	t = replacetext(t, "\[date\]", "[stationdate2text()]")
	t = replacetext(t, "\[large\]", "<font size=\"4\">")
	t = replacetext(t, "\[/large\]", "</font>")
	t = replacetext(t, "\[field\]", "<span class=\"paper_field\"></span>")
	t = replacetext(t, "\[h1\]", "<H1>")
	t = replacetext(t, "\[/h1\]", "</H1>")
	t = replacetext(t, "\[h2\]", "<H2>")
	t = replacetext(t, "\[/h2\]", "</H2>")
	t = replacetext(t, "\[h3\]", "<H3>")
	t = replacetext(t, "\[/h3\]", "</H3>")
	t = replacetext(t, "\[*\]", "<li>")
	t = replacetext(t, "\[hr\]", "<HR>")
	t = replacetext(t, "\[small\]", "<font size = \"1\">")
	t = replacetext(t, "\[/small\]", "</font>")
	t = replacetext(t, "\[list\]", "<ul>")
	t = replacetext(t, "\[/list\]", "</ul>")
	t = replacetext(t, "\[table\]", "<table border=1 cellspacing=0 cellpadding=3 style='border: 1px solid black;'>")
	t = replacetext(t, "\[/table\]", "</td></tr></table>")
	t = replacetext(t, "\[grid\]", "<table>")
	t = replacetext(t, "\[/grid\]", "</td></tr></table>")
	t = replacetext(t, "\[row\]", "</td><tr>")
	t = replacetext(t, "\[cell\]", "<td>")
	t = replacetext(t, "\[editorbr\]", "")
	return t

//pencode translation to html for tags exclusive to digital files (currently email, nanoword, report editor fields,
//modular scanner data and txt file printing) and prints from them
/proc/digitalPencode2html(var/text)
	text = replacetext(text, "\[pre\]", "<pre>")
	text = replacetext(text, "\[/pre\]", "</pre>")
	text = replacetext(text, "\[fontred\]", "<font color=\"red\">") //</font> to pass html tag unit test
	text = replacetext(text, "\[fontblue\]", "<font color=\"blue\">")//</font> to pass html tag unit test
	text = replacetext(text, "\[fontgreen\]", "<font color=\"green\">")
	text = replacetext(text, "\[/font\]", "</font>")
	text = replacetext(text, "\[redacted\]", "<span class=\"redacted\">R E D A C T E D</span>")
	return pencode2html(text)

//Will kill most formatting; not recommended.
/proc/html2pencode(t)
	t = replacetext(t, "<pre>", "\[pre\]")
	t = replacetext(t, "</pre>", "\[/pre\]")
	t = replacetext(t, "<font color=\"red\">", "\[fontred\]")//</font> to pass html tag unit test
	t = replacetext(t, "<font color=\"blue\">", "\[fontblue\]")//</font> to pass html tag unit test
	t = replacetext(t, "<font color=\"green\">", "\[fontgreen\]")
	t = replacetext(t, "</font>", "\[/font\]")
	t = replacetext(t, "<BR>", "\[br\]")
	t = replacetext(t, "<br>", "\[br\]")
	t = replacetext(t, "<B>", "\[b\]")
	t = replacetext(t, "</B>", "\[/b\]")
	t = replacetext(t, "<I>", "\[i\]")
	t = replacetext(t, "</I>", "\[/i\]")
	t = replacetext(t, "<U>", "\[u\]")
	t = replacetext(t, "</U>", "\[/u\]")
	t = replacetext(t, "<center>", "\[center\]")
	t = replacetext(t, "</center>", "\[/center\]")
	t = replacetext(t, "<H1>", "\[h1\]")
	t = replacetext(t, "</H1>", "\[/h1\]")
	t = replacetext(t, "<H2>", "\[h2\]")
	t = replacetext(t, "</H2>", "\[/h2\]")
	t = replacetext(t, "<H3>", "\[h3\]")
	t = replacetext(t, "</H3>", "\[/h3\]")
	t = replacetext(t, "<li>", "\[*\]")
	t = replacetext(t, "<HR>", "\[hr\]")
	t = replacetext(t, "<ul>", "\[list\]")
	t = replacetext(t, "</ul>", "\[/list\]")
	t = replacetext(t, "<table>", "\[grid\]")
	t = replacetext(t, "</table>", "\[/grid\]")
	t = replacetext(t, "<tr>", "\[row\]")
	t = replacetext(t, "<td>", "\[cell\]")
	t = replacetext(t, "<span class=\"paper_field\"></span>", "\[field\]")
	t = replacetext(t, "<span class=\"redacted\">R E D A C T E D</span>", "\[redacted\]")
	t = strip_html_properly(t)
	return t

// Random password generator
/proc/GenerateKey()
	//Feel free to move to Helpers.
	var/newKey
	newKey += pick("the", "if", "of", "as", "in", "a", "you", "from", "to", "an", "too", "little", "snow", "dead", "drunk", "rosebud", "duck", "al", "le")
	newKey += pick("diamond", "beer", "mushroom", "assistant", "clown", "captain", "twinkie", "security", "nuke", "small", "big", "escape", "yellow", "gloves", "monkey", "engine", "nuclear", "ai")
	newKey += pick("1", "2", "3", "4", "5", "6", "7", "8", "9", "0")
	return newKey

//Used for applying byonds text macros to strings that are loaded at runtime
/proc/apply_text_macros(string)
	var/next_backslash = findtext(string, "\\")
	if(!next_backslash)
		return string

	var/leng = length(string)

	var/next_space = findtext(string, " ", next_backslash + 1)
	if(!next_space)
		next_space = leng - next_backslash

	if(!next_space)	//trailing bs
		return string

	var/base = next_backslash == 1 ? "" : copytext(string, 1, next_backslash)
	var/macro = lowertext(copytext(string, next_backslash + 1, next_space))
	var/rest = next_backslash > leng ? "" : copytext(string, next_space + 1)

	//See http://www.byond.com/docs/ref/info.html#/DM/text/macros
	switch(macro)
		//prefixes/agnostic
		if("the")
			rest = text("\the []", rest)
		if("a")
			rest = text("\a []", rest)
		if("an")
			rest = text("\an []", rest)
		if("proper")
			rest = text("\proper []", rest)
		if("improper")
			rest = text("\improper []", rest)
		if("roman")
			rest = text("\roman []", rest)
		//postfixes
		if("th")
			base = text("[]\th", rest)
		if("s")
			base = text("[]\s", rest)
		if("he")
			base = text("[]\he", rest)
		if("she")
			base = text("[]\she", rest)
		if("his")
			base = text("[]\his", rest)
		if("himself")
			base = text("[]\himself", rest)
		if("herself")
			base = text("[]\herself", rest)
		if("hers")
			base = text("[]\hers", rest)

	. = base
	if(rest)
		. += .(rest)

/proc/deep_string_equals(var/A, var/B)
	if (length(A) != length(B))
		return FALSE
	for (var/i = 1 to length(A))
		if (text2ascii(A, i) != text2ascii(B, i))
			return FALSE
	return TRUE

// If char isn't part of the text the entire text is returned
/proc/copytext_after_last(var/text, var/char)
	var/regex/R = regex("(\[^[char]\]*)$")
	R.Find(text)
	return R.group[1]

/proc/sql_sanitize_text(var/text)
	text = replacetext(text, "'", "''")
	text = replacetext(text, ";", "")
	text = replacetext(text, "&", "")
	return text

var/global/list/fullstop_alternatives = list(".", "!", "?")
#define APPEND_FULLSTOP_IF_NEEDED(TXT) ((copytext_char(TXT, -1, 0) in global.fullstop_alternatives) ? TXT : "[TXT].")

/proc/make_rainbow(var/msg)
	var/static/list/rainbow_classes = list(
		"font_red",
		"font_orange",
		"font_yellow",
		"font_green",
		"font_blue",
		"font_violet",
		"font_purple"
	)
	for(var/i = 1 to length(msg))
		. += "<span class='[pick(rainbow_classes)]'>[copytext(msg, i, i+1)]</span>"

// Returns direction-string, rounded to multiples of 22.5, from the first parameter to the second
// N, NNE, NE, ENE, E, ESE, SE, SSE, S, SSW, SW, WSW, W, WNW, NW, NNW
/proc/get_compass_direction_string(var/turf/A, var/turf/B)
	var/degree = Get_Angle(A, B)
	switch(round(degree, 22.5) % 360) // % appears to round down floats, hence below values all being integers
		if(0)
			return "North"
		if(22)
			return "North-Northeast"
		if(45)
			return "Northeast"
		if(67)
			return "East-Northeast"
		if(90)
			return "East"
		if(112)
			return "East-Southeast"
		if(135)
			return "Southeast"
		if(157)
			return "South-Southeast"
		if(180)
			return "South"
		if(202)
			return "South-Southwest"
		if(225)
			return "Southwest"
		if(247)
			return "West-Southwest"
		if(270)
			return "West"
		if(292)
			return "West-Northwest"
		if(315)
			return "Northwest"
		if(337)
			return "North-Northwest"

///Returns true if the text starts with the given sequence of characters.
/proc/text_starts_with(var/text, var/start)
	return copytext(text, 1, length(start) + 1) == start

///Returns true if the text ends with the given sequence of characters.
/proc/text_ends_with(var/text, var/end)
	var/tlen = length(text)
	return copytext(text, ((tlen - length(end)) + 1), tlen + 1) == end

///Returns true if the text ends with ANY of the given sequences of characters.
/proc/text_ends_with_any_of(var/text, var/list/endings)
	for(var/ending in endings)
		if(text_ends_with(text, ending))
			return ending
	return

///Siblants that should end with es
var/global/list/plural_siblants = list("ss", "x", "sh", "ch")
///Vocalized y sounds that needs to end in -ies when made plural
var/global/list/plural_vocalized_y = list("quy", "by", "dy", "fy", "gy", "hy", "jy", "ky", "ly", "my", "ny", "py", "ry", "sy", "ty", "vy", "xy", "zy")
///Plurals endings in -ves
var/global/list/plural_endings_in_ves = list("fe", "af")
///Plurals endings in -sses or -zzes
var/global/list/plural_endings_with_doubled_letter = list("as", "ez")
///Words that have a different plural form, and their plural form
var/global/list/apophonic_plurals = list(
	"foot"     = "feet",
	"goose"    = "geese",
	"louse"    = "lice",
	"man"      = "men",
	"woman"    = "women",
	"mouse"    = "mice",
	"tooth"    = "teeth",
	"ox"       = "oxen",
	//#TODO: Add more of those
)
///Used to tell how to make it a plural word and etc.
var/global/list/english_loanwords = list(
	"fungus",
	"cactus",
	//#TODO: Add more of those
)
///Words that stay the same in plural
var/global/list/plural_words_unchanged = list(
	"series",
	"means",
	"species"
	//#TODO: Add more of those
)

///Properly changes the given word (or the last word of the string) into a plural word. Applies a bunch of exceptions from the english language.
/proc/text_make_plural(var/word)
	if(!length(word))
		return
	var/initial_word = word
	//If someone passed us several words, just keep the last one.
	var/list/splited = splittext_char(word, " ", 1, length(word)+1, FALSE)
	//log_debug("splitted '[initial_word]' to [log_info_line(splited)].")
	if(length(splited) > 1)
		word = splited[splited.len]
	else
		splited = null

	//Words that don't change when pluralized
	if(global.plural_words_unchanged[word])
		return initial_word

	//Apophonic plurals
	if(global.apophonic_plurals[word])
		word = global.apophonic_plurals[word]

	//Siblants + plurals of nouns in -o preceded by a consonant. Loanwords ending in o just ends with an s
	else if(text_ends_with_any_of(word, global.plural_siblants) || (text_ends_with(word, "o") && !(word in global.english_loanwords)))
		word = "[word]es"

	//Plurals of nouns in -y
	else if(text_ends_with_any_of(word, global.plural_vocalized_y))
		word = "[copytext(word, 1, length(word))]ies"

	// -f and -fe endings
	else if(text_ends_with_any_of(word, global.plural_endings_in_ves))
		word = "[copytext(word, 1, length(word) - 1)]ves" //EX: calf -> calves, leaf -> leaves, knife -> knives

	//some ‘-s’ and ‘-z’ endings
	else if(text_ends_with_any_of(word, global.plural_endings_with_doubled_letter))
		word = "[word][copytext(word, length(word), length(word) + 1)]es" //Ex: gas -> gas'ses', fez -> fez'zes'

	//Plurals of nouns in -us
	else if(text_ends_with(word, "us"))
		if(!(word in global.english_loanwords))
			word = "[word]es"
		else
			word = "[copytext(word, 1, length(word) - 1)]i" //EX: Cactus -> Cacti, Fungus -> Fungi

	//Finally just go with the basic rules
	else
		if(text_ends_with(word, "s"))
			word = "[word]es"
		else
			word = "[word]s"

	//Put the sentence back together, if applicable
	if(splited)
		word = "[jointext(splited, " ", 1, length(splited))] [word]"
	return word
