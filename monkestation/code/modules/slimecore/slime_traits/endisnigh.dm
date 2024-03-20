/datum/slime_trait/endisnigh
	name = "Ash"
	desc = "This feels like a reference?"


/datum/slime_trait/endisnigh/on_add(mob/living/basic/slime/parent)
	. = ..()
	parent.slime_flags |= OVERWRITES_COLOR
	parent.icon_state_override = "ash"
	parent.overwrite_color = "#242234"

/datum/slime_trait/endisnigh/on_remove(mob/living/basic/slime/parent)
	. = ..()
	parent.slime_flags &= ~OVERWRITES_COLOR
	parent.icon_state_override = null
	parent.overwrite_color = null
