//this is just a doc comment but currently the max interior size is 9x9 so 11x11 if you include the corral walls
/datum/corral_data
	///list of all managed slimes
	var/list/managed_slimes = list()

	///the turfs inside the corral
	var/list/corral_turfs = list()
	///the installed corral upgrades
	var/list/corral_upgrades = list()
	///our corral corners
	var/list/corral_corners = list()
	///the corral connecter effects
	var/list/corral_connectors = list()
