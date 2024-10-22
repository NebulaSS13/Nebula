//--------------------------------------------
// Pipe colors
//
// Add them here and to the pipe_colors list
//  to automatically add them to all relevant
//  atmospherics devices.
//--------------------------------------------
var/global/list/pipe_colors = list(
	"grey" = PIPE_COLOR_GREY,
	"red" = PIPE_COLOR_RED,
	"blue" = PIPE_COLOR_BLUE,
	"cyan" = PIPE_COLOR_CYAN,
	"green" = PIPE_COLOR_GREEN,
	"yellow" = PIPE_COLOR_YELLOW,
	"black" = PIPE_COLOR_BLACK,
	"orange" = PIPE_COLOR_ORANGE,
	"white" = PIPE_COLOR_WHITE,
	"dark gray" = COLOR_DARK_GRAY)

/proc/pipe_color_check(var/color)
	if(!color)
		return 1
	for(var/C in pipe_colors)
		if(color == pipe_colors[C])
			return 1
	return 0
