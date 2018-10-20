#Dumpert open dumpert with some features
#options:
#bdm		Opens all dumpert boob drops monday's
#friday		Opens VrijMiBO.
#schedule	Set the schedule time for every friday at 5.00 AM
#search		Search on the dumpert website.
#top		Opens the top of dumpert.
#tag		Opens an certain tag.
#help		Show all the options.

dumpert() {

	local url=https://www.dumpert.nl
	local tag="$url/tag"

	case $1 in
		"") 
			open_command $url
		;;
		bdm)
			echo "Jeroen kijk nou uit....."
			open_command "$tag/bdm"
		;;
		friday)
			echo "Jeroen kijk nou uit....."
			open_command "$tag/vrijmibo"
		;;
		schedule)
			(crontab -l ; echo "0 15 * * 1 zsh -i -c dumpert bdm \n0 17 * * 7 zsh -i -c dumpert friday") 2>&1 | grep -v "no crontab" | sort | uniq | crontab -
			echo "Dikke billen, 5 reeten."
		;;
		search)
			if [[ -z "$2" ]]; then
				echo "Argument 2 is empty."
				return 1
			fi
			
			open_command "$url/search/ALL/$2/"
		;;
		top)
			local top=$2

			if [[ -z "$top" ]]; then
				local top=0
			fi

			local json=$(curl -s "$url/mobile_api/json/top5/dag/" | jq ".items[$top]")
			local id=$(jq -r '.id' <<< $json)
			local title=$(jq -r '.title' <<< $json)

			open_command "$url/mediabase/${id//_//}/${title// /_/}.html"
		;;
		tag)
			if [[ -z "$2" ]]; then
				echo "Argument 2 is empty."
				return 1
			fi

			open_command "$tag/$2"
		;;
		-h|help)
			echo "Usage of dumpert <option>"
			echo "option:"
			echo "\tbdm\t\tOpens all dumpert boob drops monday's."
			echo "\tfriday\t\tOpens VrijMiBO."
			echo "\tschedule\tSet the schedule time for every friday at 3.00 AM. And monday at 8.00 AM"
			echo "\tsearch\t\tSearch on the dumpert website."
			echo "\ttop\t\tOpens a top of dumpert <number>."
			echo "\ttag\t\tOpens an certain tag."
			return 0
		;;
		*)
			print "Unknown option: $1"
			return 1
		;;
	esac
}