SetMillisecondsPerGameMinute(60000)
RegisterNetEvent("realtime:event")
AddEventHandler(
	"realtime:event",
	function(h, m, s)
		NetworkOverrideClockTime(h, m, s)
	end
)
