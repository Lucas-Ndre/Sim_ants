-- User Interface stuff using SUIT lib > 
local suit = require('libs.suit')
local cfg = require('code.simconfig')
local apiG = love.graphics

local ui = {}
local cmul = cfg.colorMul
suit.theme.color = {
	normal   = {bg = { 66*cmul, 66*cmul, 66*cmul}, fg = {188*cmul,188*cmul,188*cmul}},
	hovered  = {bg = { 50*cmul,153*cmul,187*cmul}, fg = {255*cmul,255*cmul,255*cmul}},
	active   = {bg = {255*cmul,153*cmul,  0}, fg = {225*cmul,225*cmul,225*cmul}}
}


ui.cnormal = suit.theme.color.normal
ui.selectedColor =  { bg={55*cmul, 113*cmul, 140*cmul}, fg={255*cmul,255*cmul,255*cmul} } 
ui.cc = ui.cnormal
ui.consumedClick = false

ui.labelStyle =  { normal = { fg={155*cmul,200*cmul,125*cmul} }   }

ui.leftPanelWidth = 110
ui.leftPanelColor = { 82*cmul, 82*cmul, 82*cmul}
ui.pauseButtonColor = { hovered  = {bg = {200*cmul,80*cmul,80*cmul}, fg = {255*cmul,255*cmul,255*cmul}},
                        active   = {bg = {200*cmul,30*cmul,30*cmul}, fg = {225*cmul,225*cmul,225*cmul}}  }
ui.unPauseButtonColor = { hovered  = {bg = {80*cmul,200*cmul,80*cmul}, fg = {255*cmul,255*cmul,255*cmul}},
                          active   = {bg = {30*cmul,200*cmul,30*cmul}, fg = {225*cmul,225*cmul,225*cmul}}  }
ui.addAntsButtonColor = { hovered  = {bg = {150*cmul,60*cmul,150*cmul}, fg = {255*cmul,255*cmul,255*cmul}},
                          active   = {bg = {150*cmul,10*cmul,150*cmul}, fg = {225*cmul,225*cmul,225*cmul}}  }
  
ui.numAnts = 0 -- set this on main.lua to update


local btnDims = {w = 85, h = 40}

function ui.onRadioCellsChanged( NewIdx )
  print ( ui.radioBtns_cells.selectedCaption )
end

ui.radioBtns_cells = {
  {caption = 'block'},
  {caption = 'grass'},
  {caption = 'tunnel'},
  {caption = 'cave'},
  {caption = 'food'},
  {caption = 'portal'},
  {caption = 'remove'},  
  bWidth = btnDims.w,
  bHeight = btnDims.h,
  selectedIdx = 0,
  onChanged = ui.onRadioCellsChanged
}

ui.showPheromones = { checked = false, text = 'phrms'}
  

function ui.suitRadio( rbtns )
  local grow
  --ui.consumedClick = false
    
  for i=1,#rbtns do 
    if rbtns.selectedIdx  then
      if rbtns.selectedIdx == i then
        ui.cc = ui.selectedColor
        grow = 25
      else
        ui.cc = ui.cnormal
        grow = 0
      end
    end
    rbtns[i].ret = suit.Button(rbtns[i].caption, { color = { normal = ui.cc }} , suit.layout:row( rbtns.bWidth + grow, rbtns.bHeight) )  
    if rbtns[i].ret.hit then  
      --ui.consumedClick = true
      rbtns.selectedIdx = i
      if rbtns.onChanged then
        rbtns.selectedCaption = rbtns[i].caption
        rbtns.onChanged(i)
      end
    end
  end 
end

function ui.onZoomInOut( inc ) end --event called onZoomInOut; overrided on main.lua


function ui.mainUpdate()
  suit.layout:reset(10,10) 
  suit.layout:padding(10,5)   
  
  suit.Label(love.timer.getFPS()..' FPS', { color =  ui.labelStyle }, suit.layout:row(btnDims.w, 20 )   )
  suit.Label(ui.numAnts..' ants', { color =  ui.labelStyle }, suit.layout:row(btnDims.w, 20 )  )
  
  if suit.Button('Pause',{color =  ui.pauseButtonColor },suit.layout:row(btnDims.w, 50)).hit then pauseSim(-10) end
  if suit.Button('Resume',{color =  ui.unPauseButtonColor },suit.layout:row()).hit then unPauseSim(-10) end
  if suit.Button('+100 ants',{color =  ui.addAntsButtonColor },suit.layout:row(btnDims.w, 40)).hit then changeNumAnts(100) end
  
  ui.suitRadio(ui.radioBtns_cells)     
  
  if suit.Checkbox( ui.showPheromones, suit.layout:row() ).hit then cfg.debugPheromones = ui.showPheromones.checked end
  
  if suit.Button('zoom +',suit.layout:row(btnDims.w, 20)).hit then ui.onZoomInOut(0.5) end 
  if suit.Button('zoom -',suit.layout:row(btnDims.w, 20)).hit then ui.onZoomInOut(-0.5) end 
end

function ui.draw()
  apiG.setColor( ui.leftPanelColor )
  apiG.rectangle("fill", 0,0, ui.leftPanelWidth, apiG.getHeight() )
 -- apiG.setColor(120,180,100)
 -- apiG.print(tostring(love.timer.getFPS( ))..' FPS', 10, 10)  
 -- apiG.print('F# '..cfg.simFrameNumber, 10, 25)     
  --apiG.print("DebugCounter 1 = "..cfg.debugCounters[1], 10, 25)
  --apiG.print("DebugCounter 2 = "..cfg.debugCounters[2], 10, 40)
  suit.draw()
end

function ui.setContentScale( x, y)
  suit.setContentScale( x, y )
end

return ui