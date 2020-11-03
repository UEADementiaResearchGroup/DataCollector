local composer=require "composer"
local scene=composer.newScene()

local data=require "data"
local emailzip=require "emailzip"
local jsonreader=require "jsonreader"
local display=display
local system=system
local table=table

setfenv(1, scene)

local function formatRotationsArray(rotations)
  local niceRotations={}
  for i=1,#rotations do
    niceRotations[i]=("%d°"):format(rotations[i])
  end
  return table.concat(niceRotations,", ")
end

function scene:show(event)
  if event.phase=="did" then
    return
  end
  data.writeToFile(composer.getVariable("id"))

  local emailButton=display.newRoundedRect(self.view,
    display.contentCenterX,
    display.contentHeight-100,
    display.contentWidth-40,
    160,
    60)
  emailButton.isVisible=false
  local zipFile
  zipFile=data.zipData(composer.getVariable("id"),function(event)
    if event.isError then
      native.showAlert("Warning", "Unable to compress data, it will not be possible to e-mail it. Please check space available on device",{"Ok"})
      return
    end

    emailButton.isVisible=true
    emailButton:setFillColor(17/255,112/255,240/255)
    local label=display.newText({
      parent=self.view,
      text="E-mail Data",
      x=emailButton.x,
      y=emailButton.y,
      font="BebasNeue Bold.otf",
      fontSize=100
    })

    local emailListener
    emailListener=function()
      label.text="New Test"
      emailButton:removeEventListener("tap",emailListener)
      emailButton:addEventListener("tap",function()
        data.reset()
        composer.gotoScene("scenes.setup")
      end)

      emailzip.send(composer.getVariable("id"),zipFile)
    end
    emailButton:addEventListener("tap",emailListener)
  end)

  local title=display.newText({
    parent=self.view,
    text="E-mail Data",
    font="BebasNeue Bold.otf",
    x=display.contentCenterX,
    y=20,
    fontSize=80
  })
  title.anchorY=0
end
scene:addEventListener("show")

function scene:hide(event)
  if not self.view or event.phase=="will" then
    return
  end
  for i=self.view.numChildren,1,-1 do
    self.view[i]:removeSelf()
  end
end
scene:addEventListener("hide")

return scene