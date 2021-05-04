// Mostly exists as a demo for the FSM extension.
/*

*-----*
|\1|2/|
|8\|/3|
|7/|\4|
|/6|5\|
*-----*

*/
#define MAX_FORTUNES 8

/obj/item/paper_fortune_teller
	name = "paper fortune teller"
	desc = "Origami, for children."
	var/busy = FALSE
	var/list/fortunes = list(null, null, null, null, null, null, null, null) //why
	var/color_choices = list(
		"Red" = "#ff8888",
		"Green" = "#88ff88",
		"Blue" = "#8888ff",
		"Yellow" = "#ffff88"
	)

/obj/item/paper_fortune_teller/Initialize(ml, material_key)
	set_extension(src, /datum/extension/state_machine/paper_fortune)
	return ..()

/obj/item/paper_fortune_teller/pre_filled
	var/static/list/possible_fortunes = list(
		"You will fall down an elevator shaft.",
		"Today it's up to you to create the peacefulness you long for.",
		"If you refuse to accept anything but the best, you very often get it.",
		"A smile is your passport into the hearts of others.",
		"Hard work pays off in the future, laziness pays off now.",
		"Change can hurt, but it leads a path to something better.",
		"Hidden in a valley beside an open stream- This will be the type of place where you will find your dream.",
		"Never give up. You're not a failure if you don't give up.",
		"Love can last a lifetime, if you want it to.",
		"The love of your life is stepping into your planet this summer.",
		"Your ability for accomplishment will follow with success.",
		"Please help me, I'm trapped in a fortune cookie factory!",
		"Improve, don't remove.",
		"Run.",
		"Please wake up."
	)

/obj/item/paper_fortune_teller/pre_filled/Initialize(ml, material_key)
	var/list/fortune_options = possible_fortunes.Copy()
	for(var/i = 1 to MAX_FORTUNES)
		var/fortune = pick(fortune_options)
		fortune_options -= fortune
		fortunes[i] = fortune
	return ..()


/obj/item/paper_fortune_teller/proc/alternate(amount)
	busy = TRUE
	for(var/i = 1 to amount)
		advance()
		sleep(0.5 SECONDS)
	busy = FALSE

// Alternates between two states based on the length of the color chosen.
// E.g. 'Red' makes it switch three times. 'Yellow' does it six times, etc.
/obj/item/paper_fortune_teller/proc/alternate_by_color(color_word)
	alternate(length(color_word))

/obj/item/paper_fortune_teller/proc/alternate_by_number(number)
	alternate(number)

/obj/item/paper_fortune_teller/proc/advance()
	var/datum/extension/state_machine/fsm = get_extension(src, /datum/extension/state_machine/paper_fortune)
	fsm.evaluate()