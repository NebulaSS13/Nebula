#!/usr/bin/env bash
set -eo pipefail

FAILED=0
shopt -s globstar

exactly() { # exactly N name search [mode] [filter]
	count="$1"
	name="$2"
	search="$3"
	mode="${4:--E}"
	filter="${5:-**/*.dm}"

	num="$(grep "$mode" "$search" $filter | wc -l || true)"

	if [ $num -eq $count ]; then
		echo "$num $name"
	else
		echo "$(tput setaf 9)$num $name (expecting exactly $count)$(tput sgr0)"
		FAILED=1
	fi
}

# With the potential exception of << if you increase any of these numbers you're probably doing it wrong
# Additional exception August 2020: \b is a regex symbol as well as a BYOND macro.
exactly 1 "escapes" '\\\\(red|blue|green|black|b|i[^mc])'
exactly 4 "Del()s" '\WDel\('
exactly 2 "/atom text paths" '"/atom'
exactly 2 "/area text paths" '"/area'
exactly 2 "/datum text paths" '"/datum'
exactly 2 "/mob text paths" '"/mob'
exactly 6 "/obj text paths" '"/obj'
exactly 8 "/turf text paths" '"/turf'
exactly 1 "world<< uses" 'world<<|world[[:space:]]<<'
exactly 1 "world.log<< uses" 'world.log<<|world.log[[:space:]]<<'
exactly 118 "<< uses" '(?<!<)<<(?!<)' -P
exactly 0 "incorrect indentations" '^( {4,})' -P
exactly 19 "text2path uses" 'text2path'
exactly 4 "update_icon() override" '/update_icon\((.*)\)'  -P
exactly 1 "goto uses" 'goto '
exactly 6 "atom/New uses" '^/(obj|atom|area|mob|turf).*/New\('
exactly 0 "tag uses" '\stag = ' -P '**/*.dmm'
exactly 3 "unmarked globally scoped variables" -P '^(/|)var/(?!global)'
exactly 0 "global-marked member variables" -P '\t(/|)var.*/global/.+'
exactly 0 "static-marked globally scoped variables" -P '^(/|)var.*/static/.+'

# With the potential exception of << if you increase any of these numbers you're probably doing it wrong

num=`find ./html/changelogs -not -name "*.yml" | wc -l`
echo "$num non-yml files (expecting exactly 2)"
[ $num -eq 2 ] || FAILED=1

num=`find . -perm /111 -name "*.dm*" | wc -l`
echo "$num executable *.dm? files (expecting exactly 0)"
[ $num -eq 0 ] || FAILED=1

exit $FAILED
