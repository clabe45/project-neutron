Dialog = {
	dialogLines = {},
	index = 1,
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
		Dialog.isOpen = true
	end
	Dialog.nextLine()
end

-- nextLine: Get the next line in the dialog
function Dialog.nextLine()
	-- Loop through dialog lines and load speaker
	for i=Dialog.index,#Dialog.dialogLines do
		-- Check for all the speakers
		if (Dialog.dialogLines[i] == "[Hammer]") then
			Dialog.currentSpeaker = "Hammer"
			print(Dialog.currentSpeaker)
		elseif (Dialog.dialogLines[i] == "[MC]") then
			Dialog.currentSpeaker = "MC"
			print(Dialog.currentSpeaker)
		-- Strip blank lines
		elseif (Dialog.dialogLines[i] ~= "") then
			Dialog.currentDialog = Dialog.dialogLines[i]
			print(Dialog.currentDialog)
			Dialog.index = i+1
			return
		else
			-- For blank lines
			Dialog.index = i+1
		end
	end
end

