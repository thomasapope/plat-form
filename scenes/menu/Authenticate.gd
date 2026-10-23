extends Control

func _ready():
	# Authenticate with LootLocker
	var playerIdentifier = await PlayerTracker.get_system_username()
	var guestLoginResponse = await LL_Authentication.GuestSession.new(playerIdentifier).send()
	if(!guestLoginResponse.success) :
		printerr("Guest login failed with reason: " + guestLoginResponse.error_data.to_string())
		return
