local composer=require "composer"
local scene=composer.newScene()

local display=display
local native=native
local data=require "data"

setfenv(1, scene)

function scene:create()
	local start=display.newRoundedRect(self.view, 20,20, display.contentWidth-40, display.contentHeight/4, 60)
	start:setFillColor(17/255,112/255,240/255)
	start.anchorX=0
	start.anchorY=0
	display.newText({
		parent=self.view,
		text="Start Data Collection",
		x=start.x+start.width/2,
		y=start.y+start.height/2,
		font="BebasNeue Bold.otf",
		fontSize=100,
		align="center",
		width=start.width-40
	})
	self.start=start

end
scene:addEventListener("create")

function scene:show(event)
	if event.phase=="will" then
		return
	end
	local tapListener
	local called=false
	tapListener=function()
		if called then
			return
		end
		
		called=true
		self.start:removeEventListener("tap", tapListener)
		composer.gotoScene("scenes.test")
	end
	self.start:addEventListener("tap", tapListener)
end
scene:addEventListener("show")

return scene