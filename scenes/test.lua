local composer=require "composer"
local scene=composer.newScene()

local display=display
local native=native
local data=require "data"

setfenv(1, scene)

function scene:create()
	local stopButton=display.newRoundedRect(self.view, 20,display.contentHeight-220, display.contentWidth-40, display.contentHeight*3/4-200, 60)
	stopButton:setFillColor(17/255,112/255,240/255)
	stopButton.anchorX=0
	stopButton.anchorY=1
	display.newText({
		parent=self.view,
		text="Tap to end trial",
		x=stopButton.x+stopButton.width/2,
		y=stopButton.y-stopButton.height/2,
		font="BebasNeue Bold.otf",
		fontSize=140,
		align="center",
		width=stopButton.width-40
	})
	self.stopButton=stopButton

	display.newText({
		parent=self.view,
		text="Collecting Data",
		x=display.contentCenterX,
		y=stopButton.y+100,
		font="BebasNeue Bold.otf",
		fontSize=80,
		align="center"
	})
end
scene:addEventListener("create")

function scene:show(event)
	if event.phase=="will" then
		return
	end

	local stopCollection=data.startCollectingTrial(composer.getVariable("id"),composer.getVariable("reference point"))
	local tapListener
	local called=false
	tapListener=function()
		if called then
			return
		end
		
		native.showAlert(
			"Stop Data Collection",
			"Do you want to stop data collection?",
			{"Cancel", "OK"},
			function(event)
				if event.action ~= "clicked" then
					return
				end

		        local i = event.index
		        if i == 1 then
		            -- Do nothing; dialog will simply dismiss
		        elseif i == 2 then
		        	called=true
		    		self.stopButton:removeEventListener("tap", tapListener)
					stopCollection()
					composer.setVariable("rotation",1)
					local total=composer.getVariable("total tests")
					local test=composer.getVariable("test number") or 1
					composer.gotoScene("scenes.testcomplete",{
						params={testNumber=test,totalTests=total}
					})
					test=test+1
					composer.setVariable("test number",test)
		        end
		    end)
	end
	self.stopButton:addEventListener("tap", tapListener)
end
scene:addEventListener("show")

return scene