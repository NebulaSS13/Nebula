/datum/codex_entry/writing
	associated_strings = list("pencode")
	associated_paths = list(/obj/item/pen, /obj/item/paper, /obj/item/book)
	disambiguator = "writing"

	mechanics_text = {"Used for writing down your thoughts, on paper or elsewhere. The following special commands are available:<br><br>
\[br\] : Creates a linebreak.<br>
\[center\] - \[/center\] : Centers the text.<br>
\[h1\] - \[/h1\] : Makes the text a first level heading.<br>
\[h2\] - \[/h2\] : Makes the text a second level headin.<br>
\[h3\] - \[/h3\] : Makes the text a third level heading.<br>
\[b\] - \[/b\] : Makes the text bold.<br>
\[i\] - \[/i\] : Makes the text italic.<br>
\[u\] - \[/u\] : Makes the text underlined.<br>
\[small\] - \[/small\] : Decreases the size of the text.<br>
\[large\] - \[/large\] : Increases the size of the text.<br>
\[sign\] : Inserts a signature of your name in a foolproof way.<br>
\[field\] : Inserts an invisible field which lets you start type from there. Useful for forms.<br>
\[date\] : Inserts today's station date.<br>
\[time\] : Inserts the current station time.<br>
\[table\] - \[/table\] : Creates table using \[row\] and \[cell\] tags.<br>
\[grid\] - \[/grid\] : Table without visible borders, for layouts.<br>
\[row\] - New table row.<br>
\[cell\] - New table cell.<br>
\[hr\] : Adds a horizontal rule.<br>
\[list\] - \[/list\] : A list. (Does not work with crayons)<br>
\[*\] : A dot used for lists. (Does not work with crayons)<br>
<b>Digital exclusive commands (emails, reports, text files, etc):</b><br>
\[pre\] - \[/pre\] : Adds preformatted text, forcing the text to be fixed width.<br>
\[fontred\] - \[/font\] : Makes the text red.<br>
\[fontblue\] - \[/font\] : Makes the text blue.<br>
\[fontgreen\] - \[/font\] : Makes the text green.<br>
\[redacted\] : Adds R E D A C T E D in black font on a black background.<br><br>"}

/datum/codex_entry/textbook
	associated_paths = list(/obj/item/book/skill)
	associated_strings = list("skillbook","skill book")
	lore_text = "Education, written down and made overly expensive."
	mechanics_text = "Textbooks provide <span codexlink='Skills (category)'>skill</span> buffs, raising the relevant skill by one level. In order to use textbook, you must have the matching skill that the textbook teaches, at the level it can buff. To use a textbook, simply hold it in your active hand and click it. You must then wait for a short period of time, after which you will have the skill buff indefinitely. However, the skill buff will be removed the moment the textbook is closed (used again) or removed from your hand in any way (dropped, put in a container, destroyed, etc). This process can be repeated without consequence, though only one textbook can be used at any one time. <BR><BR> \
	<h4>Custom Skill Books</h4> \
	Those with Master level <span codexlink='Literacy (skill)'>Literacy</span> can create a textbook with the use of an autobinder and a suitable writing implement. This works much the same way as writing a normal book(use pen on book) but rather than manually writing the contents, the Skill option is selected from the menu. To imbue the book with any given skill, the writer must possess the relevant skill at the level they desire. After successfully selecting the skill and level, the writer must then repeatedly use the pen on the book until it is complete. Only once complete can it be used as a skill book. <b>Important note</b>: You may only write two skill books during a round. If a textbook you wrote gets destroyed, it does not enable you to write another to replace it."
	include_subtypes = TRUE
