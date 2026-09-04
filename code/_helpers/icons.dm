/*
IconProcs README

A BYOND library for manipulating icons and colors

by Lummox JR

version 1.0

The IconProcs library was made to make a lot of common icon operations much easier. BYOND's icon manipulation
routines are very capable but some of the advanced capabilities like using alpha transparency can be unintuitive to beginners.

CHANGING ICONS

Several new procs have been added to the /icon datum to simplify working with icons. To use them,
remember you first need to setup an /icon var like so:

var/global/icon/my_icon = new('iconfile.dmi')

icon/ChangeOpacity(amount = 1)
	A very common operation in DM is to try to make an icon more or less transparent. Making an icon more
	transparent is usually much easier than making it less so, however. This proc basically is a frontend
	for MapColors() which can change opacity any way you like, in much the same way that SetIntensity()
	can make an icon lighter or darker. If amount is 0.5, the opacity of the icon will be cut in half.
	If amount is 2, opacity is doubled and anything more than half-opaque will become fully opaque.
icon/GrayScale()
	Converts the icon to grayscale instead of a fully colored icon. Alpha values are left intact.
icon/ColorTone(tone)
	Similar to GrayScale(), this proc converts the icon to a range of black -> tone -> white, where tone is an
	RGB color (its alpha is ignored). This can be used to create a sepia tone or similar effect.
	See also the global ColorTone() proc.
icon/MinColors(icon)
	The icon is blended with a second icon where the minimum of each RGB pixel is the result.
	Transparency may increase, as if the icons were blended with ICON_ADD. You may supply a color in place of an icon.
icon/MaxColors(icon)
	The icon is blended with a second icon where the maximum of each RGB pixel is the result.
	Opacity may increase, as if the icons were blended with ICON_OR. You may supply a color in place of an icon.
icon/Opaque(background = "#000000")
	All alpha values are set to 255 throughout the icon. Transparent pixels become black, or whatever background color you specify.
icon/BecomeAlphaMask()
	You can convert a simple grayscale icon into an alpha mask to use with other icons very easily with this proc.
	The black parts become transparent, the white parts stay white, and anything in between becomes a translucent shade of white.
icon/AddAlphaMask(mask)
	The alpha values of the mask icon will be blended with the current icon. Anywhere the mask is opaque,
	the current icon is untouched. Anywhere the mask is transparent, the current icon becomes transparent.
	Where the mask is translucent, the current icon becomes more transparent.
icon/UseAlphaMask(mask, mode)
	Sometimes you may want to take the alpha values from one icon and use them on a different icon.
	This proc will do that. Just supply the icon whose alpha mask you want to use, and src will change
	so it has the same colors as before but uses the mask for opacity.

COLOR MANAGEMENT AND HSV

RGB isn't the only way to represent color. Sometimes it's more useful to work with a model called HSV, which stands for hue, saturation, and value.

	* The hue of a color describes where it is along the color wheel. It goes from red to yellow to green to
	cyan to blue to magenta and back to red.
	* The saturation of a color is how much color is in it. A color with low saturation will be more gray,
	and with no saturation at all it is a shade of gray.
	* The value of a color determines how bright it is. A high-value color is vivid, moderate value is dark,
	and no value at all is black.

Just as BYOND uses "#rrggbb" to represent RGB values, a similar format is used for HSV: "#hhhssvv". The hue is three
hex digits because it ranges from 0 to 0x5FF.

	* 0 to 0xFF - red to yellow
	* 0x100 to 0x1FF - yellow to green
	* 0x200 to 0x2FF - green to cyan
	* 0x300 to 0x3FF - cyan to blue
	* 0x400 to 0x4FF - blue to magenta
	* 0x500 to 0x5FF - magenta to red

Knowing this, you can figure out that red is "#000ffff" in HSV format, which is hue 0 (red), saturation 255 (as colorful as possible),
value 255 (as bright as possible). Green is "#200ffff" and blue is "#400ffff".

More than one HSV color can match the same RGB color.

Here are some procs you can use for color management:

hsv(hue, sat, val)
	Counterpart to rgb(), this takes the values you input and converts them to a string in "#hhhssvv" or "#hhhssvvaa"
	format. Alpha is not included in the result if null.
BlendRGB(rgb1, rgb2, amount)
	Blends between two RGB or RGBA colors using regular RGB blending. If amount is 0, the first color is the result;
	if 1, the second color is the result. 0.5 produces an average of the two. Values outside the 0 to 1 range are allowed as well.
	The returned value is an RGB or RGBA color.
BlendHSV(hsv1, hsv2, amount)
	Blends between two RGB or RGBA colors using HSV blending, which tends to produce nicer results than regular RGB
	blending because the brightness of the color is left intact. If amount is 0, the first color is the result; if 1,
	the second color is the result. 0.5 produces an average of the two. Values outside the 0 to 1 range are allowed as well.
	The returned value is an RGB or RGBA color.
RotateHue(hsv, angle)
	Takes an HSV or HSVA value and rotates the hue forward through red, green, and blue by an angle from 0 to 360.
	(Rotating red by 60 degrees produces yellow.) The result is another HSV or HSVA color with the same saturation and value
	as the original, but a different hue.
GrayScale(rgb)
	Takes an RGB or RGBA color and converts it to grayscale, preserving perceptual lightness. Returns an RGB or RGBA string.
ColorTone(rgb, tone)
	Similar to GrayScale(), this proc converts an RGB or RGBA color to a range of black -> tone -> white instead of
	using strict shades of gray. The tone value is an RGB color; any alpha value is ignored.
*/

/*
Get Flat Icon DEMO by DarkCampainger

This is a test for the get flat icon proc, modified approprietly for icons and their states.
Probably not a good idea to run this unless you want to see how the proc works in detail.
mob
	icon = 'old_or_unused.dmi'
	icon_state = "green"

	Login()
		// Testing image underlays
		underlays += image(icon='old_or_unused.dmi',icon_state="red")
		underlays += image(icon='old_or_unused.dmi',icon_state="red", pixel_x = 32)
		underlays += image(icon='old_or_unused.dmi',icon_state="red", pixel_x = -32)

		// Testing image overlays
		overlays += image(icon='old_or_unused.dmi',icon_state="green", pixel_x = 32, pixel_y = -32)
		overlays += image(icon='old_or_unused.dmi',icon_state="green", pixel_x = 32, pixel_y = 32)
		overlays += image(icon='old_or_unused.dmi',icon_state="green", pixel_x = -32, pixel_y = -32)

		// Testing icon file overlays (defaults to mob's state)
		overlays += '_flat_demoIcons2.dmi'

		// Testing icon_state overlays (defaults to mob's icon)
		overlays += "white"

		// Testing dynamic icon overlays
		var/icon/I = icon('old_or_unused.dmi', icon_state="aqua")
		I.Shift(NORTH,16,1)
		overlays+=I

		// Testing dynamic image overlays
		I=image(icon=I,pixel_x = -32, pixel_y = 32)
		overlays+=I

		// Testing object types (and layers)
		overlays+=/obj/effect/overlayTest

		forceMove(locate(10,10,1))
	verb
		Browse_Icon()
			set name = "1. Browse Icon"
			// Give it a name for the cache
			var/iconName = "[ckey(src.name)]_flattened.dmi"
			// Send the icon to src's local cache
			send_rsc(src, getFlatIcon(src), iconName)
			// Display the icon in their browser
			show_browser(src, "<body bgcolor='#000000'><p><img src='[iconName]'></p></body>")

		Output_Icon()
			set name = "2. Output Icon"
			to_chat(src, "Icon is: [html_icon(getFlatIcon(src))]")

		Label_Icon()
			set name = "3. Label Icon"
			// Give it a name for the cache
			var/iconName = "[ckey(src.name)]_flattened.dmi"
			// Copy the file to the rsc manually
			var/icon/I = fcopy_rsc(getFlatIcon(src))
			// Send the icon to src's local cache
			send_rsc(src, I, iconName)
			// Update the label to show it
			winset(src,"imageLabel","image='\ref[I]'");

		Add_Overlay()
			set name = "4. Add Overlay"
			overlays += image(icon='old_or_unused.dmi',icon_state="yellow",pixel_x = rand(-64,32), pixel_y = rand(-64,32))

		Stress_Test()
			set name = "5. Stress Test"
			for(var/i = 0 to 1000)
				// The third parameter forces it to generate a new one, even if it's already cached
				getFlatIcon(src,0,2)
				if(prob(5))
					Add_Overlay()
			Browse_Icon()

		Cache_Test()
			set name = "6. Cache Test"
			for(var/i = 0 to 1000)
				getFlatIcon(src)
			Browse_Icon()

obj/effect/overlayTest
	icon = 'old_or_unused.dmi'
	icon_state = "blue"
	pixel_x = -24
	pixel_y = 24
	plane = ABOVE_TURF_PLANE
	layer = HOLOMAP_LAYER

world
	view = "7x7"
	maxx = 20
	maxy = 20
	maxz = 1
*/

#define TO_HEX_DIGIT(n) ascii2text((n&15) + ((n&15)<10 ? 48 : 87))

/icon/proc/BecomeLying()
	Turn(90)
	Shift(SOUTH,6)
	Shift(EAST,1)

// Multiply all alpha values by this float
/icon/proc/ChangeOpacity(opacity = TRUE)
	MapColors(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,opacity, 0,0,0,0)

// Convert to grayscale
/icon/proc/GrayScale()
	MapColors(0.3,0.3,0.3, 0.59,0.59,0.59, 0.11,0.11,0.11, 0,0,0)

/icon/proc/ColorTone(tone)
	GrayScale()

	var/list/TONE = rgb2num(tone)
	var/gray = round(TONE[1]*0.3 + TONE[2]*0.59 + TONE[3]*0.11, 1)

	var/icon/upper = (255-gray) ? new(src) : null

	if(gray)
		MapColors(255/gray,0,0, 0,255/gray,0, 0,0,255/gray, 0,0,0)
		Blend(tone, ICON_MULTIPLY)
	else SetIntensity(0)
	if(255-gray)
		upper.Blend(rgb(gray,gray,gray), ICON_SUBTRACT)
		upper.MapColors((255-TONE[1])/(255-gray),0,0,0, 0,(255-TONE[2])/(255-gray),0,0, 0,0,(255-TONE[3])/(255-gray),0, 0,0,0,0, 0,0,0,1)
		Blend(upper, ICON_ADD)

// Take the minimum color of two icons; combine transparency as if blending with ICON_ADD
/icon/proc/MinColors(icon)
	var/icon/I = new(src)
	I.Opaque()
	I.Blend(icon, ICON_SUBTRACT)
	Blend(I, ICON_SUBTRACT)

// Take the maximum color of two icons; combine opacity as if blending with ICON_OR
/icon/proc/MaxColors(icon)
	var/icon/I
	if(isicon(icon))
		I = new(icon)
	else
		// solid color
		I = new(src)
		I.Blend("#000000", ICON_OVERLAY)
		I.SwapColor("#000000", null)
		I.Blend(icon, ICON_OVERLAY)
	var/icon/J = new(src)
	J.Opaque()
	I.Blend(J, ICON_SUBTRACT)
	Blend(I, ICON_OR)

// make this icon fully opaque--transparent pixels become black
/icon/proc/Opaque(background = "#000000")
	SwapColor(null, background)
	MapColors(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,0, 0,0,0,1)

// Change a grayscale icon into a white icon where the original color becomes the alpha
// I.e., black -> transparent, gray -> translucent white, white -> solid white
/icon/proc/BecomeAlphaMask()
	SwapColor(null, "#000000ff")	// don't let transparent become gray
	MapColors(0,0,0,0.3, 0,0,0,0.59, 0,0,0,0.11, 0,0,0,0, 1,1,1,0)

/icon/proc/UseAlphaMask(mask)
	Opaque()
	AddAlphaMask(mask)

/icon/proc/AddAlphaMask(mask)
	var/icon/M = new(mask)
	M.Blend("#ffffff", ICON_SUBTRACT)
	// apply mask
	Blend(M, ICON_ADD)

/*
	HSV format is represented as "#hhhssvv" or "#hhhssvvaa"

	Hue ranges from 0 to 0x5ff (1535)

		0x000 = red
		0x100 = yellow
		0x200 = green
		0x300 = cyan
		0x400 = blue
		0x500 = magenta

	Saturation is from 0 to 0xff (255)

		More saturation = more color
		Less saturation = more gray

	Value ranges from 0 to 0xff (255)

		Higher value means brighter color
 */

/proc/ReadHSV(hsv)
	if(!hsv) return

	// interpret the HSV or HSVA value
	var/i=1,start=1
	if(text2ascii(hsv) == 35) ++start // skip opening #
	var/ch,which=0,hue=0,sat=0,val=0,alpha=0,usealpha
	var/digits=0
	for(i=start, i<=length(hsv), ++i)
		ch = text2ascii(hsv, i)
		if(ch < 48 || (ch > 57 && ch < 65) || (ch > 70 && ch < 97) || ch > 102) break
		++digits
		if(digits == 9) break
	if(digits > 7) usealpha = 1
	if(digits <= 4) ++which
	if(digits <= 2) ++which
	for(i=start, digits>0, ++i)
		ch = text2ascii(hsv, i)
		if(ch >= 48 && ch <= 57) ch -= 48
		else if(ch >= 65 && ch <= 70) ch -= 55
		else if(ch >= 97 && ch <= 102) ch -= 87
		else break
		--digits
		switch(which)
			if(0)
				hue = BITSHIFT_LEFT(hue, 4) | ch
				if(digits == (usealpha ? 6 : 4)) ++which
			if(1)
				sat = BITSHIFT_LEFT(sat, 4) | ch
				if(digits == (usealpha ? 4 : 2)) ++which
			if(2)
				val = BITSHIFT_LEFT(val, 4) | ch
				if(digits == (usealpha ? 2 : 0)) ++which
			if(3)
				alpha = BITSHIFT_LEFT(alpha, 4) | ch

	. = list(hue, sat, val)
	if(usealpha) . += alpha

/*
	Blend two RGB colors in RGB color space

	amount=0 is the first color
	amount=1 is the second color
	amount=0.5 is directly between the two colors
 */
/proc/BlendRGB(rgb1, rgb2, amount)
	return gradient(rgb1, rgb2, index = amount)

/// Blend two RGB colors in HSV space
/proc/BlendHSV(rgb1, rgb2, amount)
	return gradient(rgb1, rgb2, index = amount, space = COLORSPACE_HSV)

// positive angle rotates forward through red->green->blue
/proc/RotateHue(rgb, angle)
	. = rgb2num(rgb, COLORSPACE_HSV)
	.[1] = (.[1] + angle) % 360

// Convert an rgb color to grayscale, preserving luminance
/proc/GrayScale(rgb)
	var/list/HCY = rgb2num(rgb, COLORSPACE_HCY)
	return rgb(hue = HCY[1], chroma = 0, y = HCY[3])

// Change grayscale color to black->tone->white range
/proc/ColorTone(rgb, tone)
	var/list/RGB = rgb2num(rgb)
	var/list/TONE = rgb2num(tone)

	var/gray = RGB[1]*0.3 + RGB[2]*0.59 + RGB[3]*0.11
	var/tone_gray = TONE[1]*0.3 + TONE[2]*0.59 + TONE[3]*0.11

	if(gray <= tone_gray) return BlendRGB("#000000", tone, gray/(tone_gray || 1))
	else return BlendRGB(tone, "#ffffff", (gray-tone_gray)/((255-tone_gray) || 1))


/*
Get flat icon by DarkCampainger. As it says on the tin, will return an icon with all the overlays
as a single icon. Useful for when you want to manipulate an icon via the above as overlays are not normally included.
The _flatIcons list is a cache for generated icon files.
*/

// Creates a single icon from a given /atom or /image.  Only the first argument is required.
/proc/getFlatIcon(image/A, defdir = SOUTH, deficon = null, defstate = "", defblend = BLEND_DEFAULT, always_use_defdir = FALSE)
	// We start with a blank canvas, otherwise some icon procs crash silently
	var/icon/flat = icon('icons/effects/effects.dmi', "icon_state"="nothing") // Final flattened icon
	if(!A || A.alpha <= 0)
		return flat

	var/curicon =  A.icon || deficon
	var/curstate = A.icon_state || defstate
	var/curdir =   (A.dir != defdir && !always_use_defdir) ? A.dir : defdir
	var/curblend = (A.blend_mode == BLEND_DEFAULT) ? defblend : A.blend_mode

	if(curicon && !check_state_in_icon(curstate, curicon))
		if(check_state_in_icon("", curicon))
			curstate = ""
		else
			curicon = null // Do not render this object.

	// Layers will be a sorted list of icons/overlays, based on the order in which they are displayed
	var/list/layers = list()
	var/image/copy
	// Add the atom's icon itself, without pixel_x/y offsets.
	if(curicon)
		copy = image(icon = curicon, icon_state = curstate, layer = A.layer, dir = curdir)
		copy.color = A.color
		copy.alpha = A.alpha
		copy.blend_mode = curblend
		layers[copy] = A.layer

	// Loop through the underlays, then overlays, sorting them into the layers list
	var/list/process = A.underlays // Current list being processed
	var/pSet=0 // Which list is being processed: 0 = underlays, 1 = overlays
	var/curIndex=1 // index of 'current' in list being processed
	var/current // Current overlay being sorted
	var/currentLayer // Calculated layer that overlay appears on (special case for FLOAT_LAYER)
	var/compare // The overlay 'add' is being compared against
	var/cmpIndex // The index in the layers list of 'compare'
	while(TRUE)
		if(curIndex<=process.len)
			current = process[curIndex]
			if(current)
				currentLayer = current:layer
				if(currentLayer<0) // Special case for FLY_LAYER
					if(currentLayer <= -1000) return flat
					if(pSet == 0) // Underlay
						currentLayer = A.layer+currentLayer/1000
					else // Overlay
						currentLayer = A.layer+(1000+currentLayer)/1000

				// Sort add into layers list
				for(cmpIndex=1,cmpIndex<=layers.len,cmpIndex++)
					compare = layers[cmpIndex]
					if(currentLayer < layers[compare]) // Associated value is the calculated layer
						layers.Insert(cmpIndex,current)
						layers[current] = currentLayer
						break
				if(cmpIndex>layers.len) // Reached end of list without inserting
					layers[current]=currentLayer // Place at end

			curIndex++
		else if(pSet == 0) // Switch to overlays
			curIndex = 1
			pSet = 1
			process = A.overlays
		else // All done
			break

	// Current dimensions of flattened icon
	var/flatX1= 1
	var/flatX2= flat.Width()
	var/flatY1= 1
	var/flatY2= flat.Height()

	// Dimensions of overlay being added
	var/addX1
	var/addX2
	var/addY1
	var/addY2

	var/icon/add // Icon of overlay being added
	for(var/image/I as anything in layers)

		if(I.alpha == 0)
			continue

		if(I == copy) // 'I' is an /image based on the object being flattened.
			curblend = BLEND_OVERLAY
			add = icon(I.icon, I.icon_state, I.dir)
			// This checks for a silent failure mode of the icon routine. If the requested dir
			// doesn't exist in this icon state it returns a 32x32 icon with 0 alpha.
			if (I.dir != defdir && add.Width() == 32 && add.Height() == 32)
				// Check every pixel for blank (computationally expensive, but the process is limited
				// by the amount of film on the station, only happens when we hit something that's
				// turned, and bails at the very first pixel it sees.
				var/blankpixel;
				for(var/y;y<=32;y++)
					for(var/x;x<32;x++)
						blankpixel = isnull(add.GetPixel(x,y))
						if(!blankpixel)
							break
					if(!blankpixel)
						break
				// If we ALWAYS returned a null (which happens when GetPixel encounters something with alpha 0)
				if (blankpixel)
					// Pull the default direction.
					add = icon(I.icon, I.icon_state)
		// 'I' is an appearance object.
		else if(istype(A,/obj/machinery/atmospherics) && (I in A.underlays))
			add = getFlatIcon(new /image(I), I.dir, curicon, null, curblend, 1)
		else
			/*
			The state var is null so that it uses the appearance's state, not ours or the default
			Falling back to our state if state is null would be incorrect overlay logic (overlay with null state does not inherit it from parent to which it is attached)

			If icon is null on an overlay it will inherit the icon from the attached parent, so we _do_ pass curicon ...
			but it does not do so if its icon_state is ""/null, so we check beforehand to exclude this
			*/
			add = getFlatIcon(new/image(I), curdir, (!I.icon_state && !I.icon) ? null : curicon, null, curblend, always_use_defdir)

		// Find the new dimensions of the flat icon to fit the added overlay
		addX1 = min(flatX1, I.pixel_x + 1)
		addX2 = max(flatX2, I.pixel_x + add.Width())
		addY1 = min(flatY1, I.pixel_y + 1)
		addY2 = max(flatY2, I.pixel_y + add.Height())

		if(addX1 != flatX1 || addX2 != flatX2 || addY1 != flatY1 || addY2 != flatY2)
			// Resize the flattened icon so the new icon fits
			flat.Crop(addX1-flatX1+1, addY1-flatY1+1, addX2-flatX1+1, addY2-flatY1+1)
			flatX1 = addX1
			flatX2 = addX2
			flatY1 = addY1
			flatY2 = addY2

		var/iconmode
		if(I in A.overlays)
			iconmode = ICON_OVERLAY
		else if(I in A.underlays)
			iconmode = ICON_UNDERLAY
		else
			iconmode = blendMode2iconMode(curblend)
		// Blend the overlay into the flattened icon
		flat.Blend(add, iconmode, I.pixel_x + 2 - flatX1, I.pixel_y + 2 - flatY1)

	if(A.color)

		// Probably a colour matrix, could also check length(A.color) == 20 if color normalization becomes more complex in the future.
		if(islist(A.color))
			flat.MapColors(arglist(A.color))

		// Probably a valid color, could check length_char(A.color) == 7 if color normalization becomes etc etc etc.
		else if(istext(A.color))
			flat.Blend(A.color, ICON_MULTIPLY)

	// Colour matrices track/apply alpha changes in MapColors() above, so only apply if color isn't a matrix.
	if(A.alpha < 255 && !islist(A.color))
		flat.Blend(rgb(255, 255, 255, A.alpha), ICON_MULTIPLY)

	return icon(flat, "", SOUTH)

/proc/getIconMask(atom/A)//By yours truly. Creates a dynamic mask for a mob/whatever. /N
	var/icon/alpha_mask = new(A.icon,A.icon_state)//So we want the default icon and icon state of A.
	for(var/I in A.overlays)//For every image in overlays. var/image/I will not work, don't try it.
		if(I:layer>A.layer)	continue//If layer is greater than what we need, skip it.
		var/icon/image_overlay = new(I:icon,I:icon_state)//Blend only works with icon objects.
		//Also, icons cannot directly set icon_state. Slower than changing variables but whatever.
		alpha_mask.Blend(image_overlay,ICON_OR)//OR so they are lumped together in a nice overlay.
	return alpha_mask//And now return the mask.

#define HOLOPAD_SHORT_RANGE 1 //For determining the color of holopads based on whether they're short or long range.
#define HOLOPAD_LONG_RANGE 2

/proc/getHologramIcon(icon/A, safety=1, noDecolor=FALSE, var/hologram_color=HOLOPAD_SHORT_RANGE, var/custom_tone)//If safety is on, a new icon is not created.
	var/icon/flat_icon = safety ? A : new(A)//Has to be a new icon to not constantly change the same icon.
	if (noDecolor == FALSE)
		if(hologram_color == HOLOPAD_LONG_RANGE)
			flat_icon.ColorTone(rgb(225,223,125)) //Light yellow if it's a call to a long-range holopad.
		else if(!custom_tone)
			flat_icon.ColorTone(rgb(125,180,225))//Let's make it bluish.
		else
			flat_icon.ColorTone(rgb(HEX_RED(custom_tone), HEX_GREEN(custom_tone), HEX_BLUE(custom_tone)))
	flat_icon.ChangeOpacity(0.5)//Make it half transparent.
	var/icon/alpha_mask = new('icons/effects/effects.dmi', "scanline-[hologram_color]")//Scanline effect.
	flat_icon.AddAlphaMask(alpha_mask)//Finally, let's mix in a distortion effect.
	return flat_icon

/proc/adjust_brightness(var/color, var/value)
	if (!color) return "#ffffff"
	if (!value) return color

	var/list/RGB = rgb2num(color)
	RGB[1] = clamp(RGB[1]+value,0,255)
	RGB[2] = clamp(RGB[2]+value,0,255)
	RGB[3] = clamp(RGB[3]+value,0,255)
	return rgb(RGB[1],RGB[2],RGB[3])

/proc/sort_atoms_by_layer(var/list/atoms)
	// Comb sort icons based on levels
	var/list/result = atoms.Copy()
	var/gap = result.len
	var/swapped = 1
	while (gap > 1 || swapped)
		swapped = 0
		if(gap > 1)
			gap = round(gap / 1.3) // 1.3 is the emperic comb sort coefficient
		if(gap < 1)
			gap = 1
		for(var/i = 1; gap + i <= result.len; i++)
			var/atom/l = result[i]		//Fucking hate
			var/atom/r = result[gap+i]	//how lists work here
			if(l.plane > r.plane || (l.plane == r.plane && l.layer > r.layer))		//no "result[i].layer" for me
				result.Swap(i, gap + i)
				swapped = 1
	return result
/**
 * Generate_image function generates image of specified range and location:
 * * arguments `target_x`, `target_y`, `target_z` are target coordinates (requred).
 * * `range` defines render distance to opposite corner (requred).
 * * lighting determines lighting capturing (optional), suppress_errors suppreses errors and continues to capture (optional).
 * * `checker` is a person from which side will be perfored capture check, should be `/mob/living` target_ype.
*/
/proc/create_area_image(target_x, target_y, target_z, range, show_lighting = TRUE, mob/living/checker)
	// They're all should be set.
	ASSERT(target_x)
	ASSERT(target_y)
	ASSERT(target_z)
	ASSERT(range)

	// - Collecting list of turfs to render -

	var/list/render_turfs = list()
	for(var/x_offset = 0 to range)
		for(var/y_offset = 0 to range)
			var/turf/T = locate(target_x + x_offset, target_y + y_offset, target_z)
			if(checker && !checker?.can_capture_turf(T))
				continue
			else if(T)
				render_turfs.Add(T)

	// - Collecting list of atoms to render -

	var/list/render_atoms = list()
	// This is a workaround for the lighting planemaster not being factored in.
	// If it's ever removed, or if a better way is found, please replace this.
	var/list/render_lighting = list()
	for(var/turf/T as anything in render_turfs)
		render_atoms.Add(T)

		for(var/atom/A as anything in T)
			// We need to handle lighting separately if we're including it, and if not, skip it entirely.
			if(istype(A, /atom/movable/lighting_overlay))
				if(show_lighting)
					render_lighting.Add(A)
				continue

			if(!A.alpha || (A.invisibility > SEE_INVISIBLE_LIVING))
				continue

			render_atoms.Add(A)

	// - Performing rendering with collected atoms in list -

	render_atoms = sort_atoms_by_layer(render_atoms)
	var/icon/capture = icon('icons/effects/96x96.dmi', "")
	capture.Scale(range * world.icon_size, range * world.icon_size)
	capture.Blend(COLOR_BLACK, ICON_OVERLAY)
	for(var/atom/A as anything in render_atoms)
		var/icon/atom_icon = getFlatIcon(A)

		if(ismob(A))
			var/mob/M = A
			if(M.current_posture.prone)
				atom_icon.BecomeLying()

		var/x_offset = (A.x - target_x) * world.icon_size
		var/y_offset = (A.y - target_y) * world.icon_size
		capture.Blend(atom_icon, blendMode2iconMode(A.blend_mode), A.pixel_x + x_offset, A.pixel_y + y_offset)

	// TODO: for custom exposure/flash/etc simulation on the camera, you could set the alpha on the overlay copy icons here
	if(show_lighting)
		for(var/atom/movable/lighting_overlay/lighting_overlay as anything in render_lighting)
			var/icon/lighting_overlay_icon = getFlatIcon(lighting_overlay)
			var/x_offset = (lighting_overlay.x - target_x) * world.icon_size
			var/y_offset = (lighting_overlay.y - target_y) * world.icon_size
			capture.Blend(lighting_overlay_icon, ICON_MULTIPLY, lighting_overlay.pixel_x + x_offset, lighting_overlay.pixel_y + y_offset)

	return capture
