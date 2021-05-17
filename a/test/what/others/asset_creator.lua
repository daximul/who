spawn(function()
	if isfolder and makefolder and isfile and writefile then
		if not isfolder("Dark Admin") then
			makefolder("Dark Admin")
			if not isfolder("Dark Admin/Plugins") then
				makefolder("Dark Admin/Plugins")
			end
			if not isfolder("Dark Admin/Logs") then
				makefolder("Dark Admin/Logs")
			end
		else
			if not isfolder("Dark Admin/Plugins") then
				makefolder("Dark Admin/Plugins")
			end
			if not isfolder("Dark Admin/Logs") then
				makefolder("Dark Admin/Logs")
			end
		end
	end
end)
