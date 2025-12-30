#!/usr/bin/env bash
set -eo pipefail

FAILED=0
shopt -s globstar

exactly() { # exactly N name search [mode] [filter]
	count="$1"
	name="$2"
	search="$3"
	mode="${4:--E}"
	filter="${5:-*.dm}"

	num="$(git grep "$mode" "$search" $filter | wc -l || true)"

	if [ $num -eq $count ]; then
		echo "$num $name"
	else
		echo "$(tput setaf 9)$num $name (expecting exactly $count)$(tput sgr0)"
		FAILED=1
	fi
}

# With the potential exception of << if you increase any of these numbers you're probably doing it wrong
# Additional exception August 2020: \b is a regex symbol as well as a BYOND macro.
exactly 3 "escapes" '\\(red|blue|green|black|b|i[^mc])'
exactly 3 "Del()s" '(?<!world/)\bDel\('  -P
exactly 2 "/atom text paths" '"/atom'
exactly 2 "/area text paths" '"/area'
exactly 2 "/datum text paths" '"/datum'
exactly 2 "/mob text paths" '"/mob'
exactly 6 "/obj text paths" '"/obj'
exactly 10 "/turf text paths" '"/turf'
exactly 1 "world<< uses" 'world\s*<<'
exactly 75 "'in world' uses" '\s+\bin world\b(?=\s*$|\s*//|\s*\))' -P
exactly 1 "world.log<< uses" 'world.log\s*<<'
exactly 23 "<< uses" '(?<![<\\])<<(?!<)' -P
exactly 1 "direct_output uses" '\bdirect_output\('
exactly 3 ">> uses" '(?<![>\\])>>(?!>)' -P
exactly 0 "incorrect indentations" '^( {4,})' -P
exactly 22 "text2path uses" 'text2path'
exactly 4 "update_icon() overrides" '\/update_icon\(' -P
exactly 0 "goto uses" '\bgoto\b'
exactly 10 "atom/New uses" '^/(obj|atom|area|mob|turf).*/New\('
exactly 1 "decl/New uses" '^/decl.*/New\('
exactly 3 "tag uses" '(?<!/)\btag\s*=(?!=)' -P '*.dm *.dmm'
exactly 3 "unmarked globally scoped variables" '^/?var/(?!global)' -P
exactly 0 "global-marked member variables" '\t+/?var.*/global/' -P
exactly 0 "static-marked globally scoped variables" '^/?var.*/static/.+' -P
exactly 1 "direct usage of decls_repository.get_decl()" 'decls_repository\.get_decl\(' -P
exactly 19 "direct loc set" '[^ ,(/]\bloc\s*=(?!=)' -P
exactly 6  "pronoun macro use" '\\(he|she|him|her|his|hers|himself|herself|He|She|Him|Her|His|Hers|Himself|Herself)\b' -P
exactly 0 "magic number mouse opacity set" 'mouse_opacity\s*=\s*[0-2]' -P
exactly 0 "magic number density set" '\bdensity\s*=\s*[01]\b' -P
exactly 0 "magic number anchored set" '\banchored\s*=\s*[01]\b' -P
exactly 0 "magic number opacity set" '\bopacity\s*=\s*[01]\b(?!\.)' -P

# With the potential exception of << if you increase any of these numbers you're probably doing it wrong

num=`find ./html/changelogs -not -name "*.yml" | wc -l`
echo "$num non-yml files (expecting exactly 2)"
[ $num -eq 2 ] || FAILED=1

num=`find . -perm /111 -name "*.dm*" | wc -l`
echo "$num executable *.dm? files (expecting exactly 0)"
[ $num -eq 0 ] || FAILED=1

exit $FAILED
