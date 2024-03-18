//This is really just a storage cell for mood messages, also handles some basic responding to emotional events for mobs
/datum/component/emotion_buffer
	var/mob/living/host

	///our current emotion
	var/current_emotion = EMOTION_HAPPY

	///the buffer of emotional things with there emotion stored like EMOTION_HAPPY = List("Was fed by x")
	var/emotional_buffer = list(
		EMOTION_HAPPY = list(),
		EMOTION_SAD = list(),
		EMOTION_ANGER = list(),
		EMOTION_FUNNY = list(),
		EMOTION_SCARED = list(),
		EMOTION_SUPRISED = list(),
		EMOTION_HUNGRY = list(),
	)

	var/emotional_responses = list(
		EMOTION_HAPPY = list(),
		EMOTION_SAD = list(),
		EMOTION_ANGER = list(),
		EMOTION_FUNNY = list(),
		EMOTION_SCARED = list(),
		EMOTION_SUPRISED = list(),
		EMOTION_HUNGRY = list(),
	)

	var/emotional_heard = list(
		EMOTION_HAPPY = list(),
		EMOTION_SAD = list(),
		EMOTION_ANGER = list(),
		EMOTION_FUNNY = list(),
		EMOTION_SCARED = list(),
		EMOTION_SUPRISED = list(),
		EMOTION_HUNGRY = list(),
	)

	///these are sent as emotion = icon_state, where the icon is stored inside the sources icon file
	var/list/emotional_overlays = list()

/datum/component/emotion_buffer/Initialize(list/emotional_overlay_states)
	. = ..()
	host = parent
	if(!length(emotional_overlay_states))
		emotional_overlays = list()
	emotional_overlays = emotional_overlay_states

/datum/component/emotion_buffer/RegisterWithParent()
	. = ..()
	if(length(emotional_overlays))
		RegisterSignal(parent, COMSIG_ATOM_UPDATE_OVERLAYS, PROC_REF(emotion_overlay))

	RegisterSignal(parent, COMSIG_EMOTION_STORE, PROC_REF(register_emotional_data))


/datum/component/emotion_buffer/Destroy(force, silent)
	. = ..()
	host = null

/datum/component/emotion_buffer/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, COMSIG_EMOTION_STORE)
	UnregisterSignal(parent, COMSIG_ATOM_UPDATE_OVERLAYS)


/datum/component/emotion_buffer/proc/register_emotional_data(datum/source, atom/from, emotion, emotional_text)
	if(!emotional_buffer[emotion])
		return
	if(from)
		emotional_buffer[emotion] += "[from] [emotional_text]"
	else
		emotional_buffer[emotion] += "[emotional_text]"

	current_emotion = emotion

/datum/component/emotion_buffer/proc/emotion_overlay(obj/item/source, list/overlays)
	if(!emotional_overlays[current_emotion])
		return
	overlays += mutable_appearance(source.icon, emotional_overlays[current_emotion], source.layer, source)
