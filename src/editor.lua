Editor = {
	currentTile = 1
}

Editor.commandMode = false
Editor.commandModeLine = ""
editorMode = true

-- executeCommand: Executes a command, current commands include :w (write), :o (open), :set (change height/width of level)
function Editor.executeCommand()
	-- :w <levelname> (writes level to file)
	if (Editor.commandModeLine:sub(1, 1) == "w") then
		if (currentLevel == "" and Editor.commandModeLine:len() < 2) then
			print("Error: No level name defined.\n Usage: :w <filename>")
		else
			local args = split(Editor.commandModeLine, " ")
			Level.save(args[2])
		end
	-- :o <filename> (reads level from file)
	elseif (Editor.commandModeLine:sub(1, 1) == "o") then
		if (Editor.commandModeLine:len() > 2) then
			Level.clear()
			local args = split(Editor.commandModeLine, " ")
			Level.read(args[2])
		end
	-- :set <height/width> (sets level height/width)
	elseif (Editor.commandModeLine:sub(1, 3) == "set") then
		local args = split(Editor.commandModeLine, " ")
		if (args[2] == "height") then
			Level.height = args[3]
			print("Level height set to " .. args[3])
		elseif (args[2] == "width") then
			Level.width = args[3]
			print("Level width set to " .. args[3])
		else
			print("Error: Invalid arguments.\nUsage: set <variable> <value>")
		end
	-- :clear (clears level)
	elseif (Editor.commandModeLine:sub(1, 5) == "clear") then
		Level.clear()
	else
		print("Error. Command not found.")
	end
end

