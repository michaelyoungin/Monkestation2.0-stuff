/datum/slime_color
	///the name of the slime color
	var/name = "Generic Color"
	///this is appended to the icon_states of the slime
	var/icon_prefix = "grey"
	///secretion path
	var/secretion_path = /datum/reagent/slime_ooze/grey
	///our slimes true color
	var/slime_color = "#FFFFFF"
	///list of possible mutations from this color
	var/list/possible_mutations = list()
