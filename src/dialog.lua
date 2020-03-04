Dialog = {
	dialogLines = {},
	currentSpeaker = nil,
	currentDialog = nil,
	isOpen = false
}

-- openDialog: Reads a dialog file based on id, and sets the speaker and line
function Dialog.openDialog(id)
	if (not Dialog.isOpen) then
		-- Load the speech file and split it
		local rawDialog = love.filesystem.read("dialog/template.txt")
		Dialog.dialogLines = split(rawDialog, "\n")

		-- Loop through dialog lines and load speaker
		for i=1,#Dialog.dialogLines do
			-- Check for all the speakers
			if (Dialog.dialogLines[i] == "[Hammer]") then
				Dialog.currentSpeaker = "Hammer"
			elseif (Dialog.dialogLines[i] == "[MC]") then
				Dialog.currentSpeaker = "MC"
			-- Strip blank lines
			elseif (Dialog.dialogLines ~= "") then
				Dialog.currentDialog = Dialog.dialogLines[i]
				print(Dialog.currentSpeaker)
				print(Dialog.currentDialog)
			end
		end
	else
		Dialog.isOpen = true
	end
end

