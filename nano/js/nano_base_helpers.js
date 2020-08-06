// NanoBaseHelpers is where the base template helpers (common to all templates) are stored
NanoBaseHelpers = function ()
{
	var _baseHelpers = {
            // change ui styling to "syndicate mode"
			syndicateMode: function() {
				$('body').css("background-color","#330404");
				$('body').css("background-image","url('uiBackground-Syndicate.png')");
				$('body').css("background-position","50% 0");
				$('body').css("background-repeat","repeat");
				$('body').css("color", "#ff0000");

				$('hr').css("background-color", "#551414");
				$('a').css("background", "#551414");
				$('a:link').css("background", "#551414");
				$('a:visited').css("background", "#551414");
				$('a:active').css("background", "#551414");
				$('linkOn').css("background", "#551414");
				$('linkOff').css("background", "#551414");
				$('input').css("background", "#551414");
				$('a:hover').css("color", "#551414");
				$('a.white').css("color", "#551414"); 
				$('a.white:link').css("color", "#551414"); 
				$('a.white:visited').css("color", "#551414"); 
				$('a.white:active').css("color", "#551414"); 
				$('a.white:hover').css("background", "#551414");
				$('linkOn').css("background", "#771414");
				$('a.linkOn:link').css("background", "#771414");
				$('a.linkOn:visited').css("background", "#771414");
				$('a.linkOn:active').css("background", "#771414");
				$('a.linkOn:hover').css("background", "#771414");
				$('statusDisplay').css("border", "1px solid #551414");
				$('block').css("border", "1px solid #551414");
				$('progressFill').css("background", "#551414");
				$('statusDisplay').css("border", "1px solid #551414");

				$('itemLabelNarrow').css("color", "#ff0000");
				$('itemLabel').css("color", "#ff0000");
				$('itemLabelWide').css("color", "#ff0000");
				$('itemLabelWider').css("color", "#ff0000");
				$('itemLabelWidest').css("color", "#ff0000");
				
				$('link').css("border", "1px solid #ff0000");
				$('linkOn').css("border", "1px solid #ff0000");
				$('linkOff').css("border", "1px solid #ff0000");
				$('selected').css("border", "1px solid #ff0000");
				$('disabled').css("border", "1px solid #ff0000");
				$('yellowButton').css("border", "1px solid #ff0000");
				$('redButton').css("border", "1px solid #ff0000");

				$('link').css("background", "#330000");
				$('linkOn').css("background", "#330000");
				$('linkOff').css("background", "#330000");
				$('selected').css("background", "#330000");
				$('disabled').css("background", "#330000");
				$('yellowButton').css("background", "#330000");
				$('redButton').css("background", "#330000");

				$('.average').css("color", "#ff0000");

				$('#uiTitleFluff').css("background-image","url('uiTitleFluff-Syndicate.png')");
				$('#uiTitleFluff').css("background-position","50% 50%");
				$('#uiTitleFluff').css("background-repeat", "no-repeat");

				return '';
			},
			// Generate a Byond link
			link: function( text, icon, parameters, status, elementClass, elementId) {

				var iconHtml = '';
				var iconClass = 'noIcon';
				if (typeof icon != 'undefined' && icon)
				{
					iconHtml = '<div class="uiLinkPendingIcon"></div><div class="uiIcon16 icon-' + icon + '"></div>';
					iconClass = text ? 'hasIcon' : 'onlyIcon';
				}

				if (typeof elementClass == 'undefined' || !elementClass)
				{
					elementClass = 'link';
				}

				var elementIdHtml = '';
				if (typeof elementId != 'undefined' && elementId)
				{
					elementIdHtml = 'id="' + elementId + '"';
				}

				if (typeof status != 'undefined' && status)
				{
					return '<div unselectable="on" class="link ' + iconClass + ' ' + elementClass + ' ' + status + '" ' + elementIdHtml + '>' + iconHtml + text + '</div>';
				}

				return '<div unselectable="on" class="linkActive ' + iconClass + ' ' + elementClass + '" data-href="' + NanoUtility.generateHref(parameters) + '" ' + elementIdHtml + '>' + iconHtml + text + '</div>';
			},
			// Round a number to the nearest integer
			round: function(number) {
				return Math.round(number);
			},
			// Returns the number fixed to 1 decimal
			fixed: function(number) {
				return Math.round(number * 10) / 10;
			},
			// Round a number down to integer
			floor: function(number) {
				return Math.floor(number);
			},
			// Round a number up to integer
			ceil: function(number) {
				return Math.ceil(number);
			},
			// Format a string (~string("Hello {0}, how are {1}?", 'Martin', 'you') becomes "Hello Martin, how are you?")
			string: function() {
				if (arguments.length == 0)
				{
					return '';
				}
				else if (arguments.length == 1)
				{
					return arguments[0];
				}
				else if (arguments.length > 1)
				{
					stringArgs = [];
					for (var i = 1; i < arguments.length; i++)
					{
						stringArgs.push(arguments[i]);
					}
					return arguments[0].format(stringArgs);
				}
				return '';
			},
			formatNumber: function(x) {
				// From http://stackoverflow.com/questions/2901102/how-to-print-a-number-with-commas-as-thousands-separators-in-javascript
				var parts = x.toString().split(".");
				parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
				return parts.join(".");
			},
			// Capitalize the first letter of a string. From http://stackoverflow.com/questions/1026069/capitalize-the-first-letter-of-string-in-javascript
			capitalizeFirstLetter: function(string) {
				return string.charAt(0).toUpperCase() + string.slice(1);
			},
			// Display a bar. Used to show health, capacity, etc. Use difClass if the entire display bar class should be different
			displayBar: function(value, rangeMin, rangeMax, styleClass, showText, difClass, direction) {

				if (rangeMin < rangeMax)
                {
                    if (value < rangeMin)
                    {
                        value = rangeMin;
                    }
                    else if (value > rangeMax)
                    {
                        value = rangeMax;
                    }
                }
                else
                {
                    if (value > rangeMin)
                    {
                        value = rangeMin;
                    }
                    else if (value < rangeMax)
                    {
                        value = rangeMax;
                    }
                }

				if (typeof styleClass == 'undefined' || !styleClass)
				{
					styleClass = '';
				}

				if (typeof showText == 'undefined' || !showText)
				{
					showText = '';
				}
				
				if (typeof difClass == 'undefined' || !difClass)
				{
					difClass = ''
				}
				
				if(typeof direction == 'undefined' || !direction)
				{
					direction = 'width'
				}
				else
				{
					direction = 'height'
				}
				
				var percentage = Math.round((value - rangeMin) / (rangeMax - rangeMin) * 100);
				
				return '<div class="displayBar' + difClass + ' ' + styleClass + '"><div class="displayBar' + difClass + 'Fill ' + styleClass + '" style="' + direction + ': ' + percentage + '%;"></div><div class="displayBar' + difClass + 'Text ' + styleClass + '">' + showText + '</div></div>';
			},
			// Display DNA Blocks (for the DNA Modifier UI)
			displayDNABlocks: function(dnaString, selectedBlock, selectedSubblock, blockSize, paramKey) {
			    if (!dnaString)
				{
					return '<div class="notice">Please place a valid subject into the DNA modifier.</div>';
				}

				var characters = dnaString.split('');

                var html = '<div class="dnaBlock"><div class="link dnaBlockNumber">1</div>';
                var block = 1;
                var subblock = 1;
                for (index in characters)
                {
					if (!characters.hasOwnProperty(index) || typeof characters[index] === 'object')
					{
						continue;
					}

					var parameters;
					if (paramKey.toUpperCase() == 'UI')
					{
						parameters = { 'selectUIBlock' : block, 'selectUISubblock' : subblock };
					}
					else
					{
						parameters = { 'selectSEBlock' : block, 'selectSESubblock' : subblock };
					}

                    var status = 'linkActive';
                    if (block == selectedBlock && subblock == selectedSubblock)
                    {
                        status = 'selected';
                    }

                    html += '<div class="link ' + status + ' dnaSubBlock" data-href="' + NanoUtility.generateHref(parameters) + '" id="dnaBlock' + index + '">' + characters[index] + '</div>'

                    index++;
                    if (index % blockSize == 0 && index < characters.length)
                    {
						block++;
                        subblock = 1;
                        html += '</div><div class="dnaBlock"><div class="link dnaBlockNumber">' + block + '</div>';
                    }
                    else
                    {
                        subblock++;
                    }
                }

                html += '</div>';

				return html;
			}
		};
		
	return {
        addHelpers: function ()
		{
            NanoTemplate.addHelpers(_baseHelpers);
        },
		removeHelpers: function ()
		{
			for (var helperKey in _baseHelpers)
			{
				if (_baseHelpers.hasOwnProperty(helperKey))
				{
					NanoTemplate.removeHelper(helperKey);
				}
			}            
        }
	};
} ();
 






