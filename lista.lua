-----------------------------------------------------------------------------------------
--
-- view2.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local widget = require("widget")

local function CriarScroll (lista)
    local function SelecionarItem (event)
        local switch = event.target
        print( switch.id, "is on?:", switch.isOn )
        if (switch.isOn) then bd:AddIndice(switch.id) else bd:RemoveIndice(switch.id) end
    end
    local scrollView = widget.newScrollView
    {
        top = 30,
        left = 10,
        width = 300,
        height = 300,
        scrollWidth = 300,
        scrollHeight = #lista*39,
        horizontalScrollDisabled = true
    }
    local mask = graphics.newMask("imagens/mask.gif")
    scrollView:setMask(mask)
    scrollView.maskX = 150
    scrollView.maskY = 150
    local y = 39
    local linha = display.newLine(0,0,300,0)
    linha:setColor(0)
    scrollView:insert(linha)
    local item = nil
    for e,v in pairs(lista) do
        item = widget.newSwitch
        {
            left = 20,
            top = y-35,
            style = "checkbox",
            id = v.id,
            onPress = SelecionarItem,
        }
        scrollView:insert(item)
        item = display.newText("R$ "..v.valor, 55, y-25, native.systemFont, 18 )
        if v.tipo == 1 then
            item:setTextColor(0, 255, 0)
        else
            item:setTextColor(255, 0, 0)
        end
        scrollView:insert(item)
        local x = #item.text * 18
        item = display.newText(v.nome, x + 5, y-25, native.systemFont, 18 )
        item:setTextColor(0, 0, 0)
        scrollView:insert(item)
        linha = display.newLine(0,y,300,y)
        linha:setColor(0)
        scrollView:insert(linha)
        y = y + 39
        print(y)
    end
    local linha = display.newLine(0,0,0,#lista*39+0)
    linha:setColor(0)
    scrollView:insert(linha)
    local linha = display.newLine(300,0,300,#lista*39)
    linha:setColor(0)
    scrollView:insert(linha)
    --scrollView.maskScaleX, scrollView.maskScaleY = 2,2
    return scrollView
end

-------------------------------------------

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

local s = nil

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
        
    
    
	-- create a white background to fill screen
	local bg = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
	bg:setFillColor( 100, 0, 0 )	-- white
    
    local scroll
    local lista = bd:ExibirElementos()
    scroll = CriarScroll (lista)
        
---------------------------------------------------------------------------
	-- all objects must be added to group (e.g. self.view)
	group:insert( bg )
    s = group:insert(scroll)
    --b = group:insert(bal)
    	
	
	-------------------------
	-- *** BOTÃO EXCLUIR ***
	-------------------------
	
local function eventoBotaoExcluir( event )
    local phase = event.phase 
    
    if "ended" == phase then
		for e,v in pairs(bd.indices) do
		
			if v then
				bd:ExcluirElemento(e)
			end
		
		end
		system.vibrate()
		--print (os.date("%Y-%m-%d %H:%M:%S"))
        --print( "Inserido com Sucesso" )
		
    end
    AtualizarBalanco()
end

-- Create the button
local botaoExcluir = widget.newButton
{
    left = 10,
    top = display.contentCenterY+120,
    width = 50,
    height = 50,
    defaultFile = "imagens/tabIcon.png",
    overFile = "imagens/aperture.png",
    id = "botaoExcluir",
    label = "Excluir",
    labelColor = {  default = {255, 255, 255 },
                    over = { 150, 150, 150 },},
    size = 25, 
    onEvent = eventoBotaoExcluir,
}


--local botaoExcluirTexto = display.newEmbossedText("Excluir", 9, display.contentCenterY+190, native.systemFont, 20, { 0, 0, 255})
group:insert(botaoExcluir)
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
    --b = group:insert(bal)
    group:remove(s)
    local scroll
    local lista = bd:ExibirElementos()
    scroll = CriarScroll (lista)
    s = group:insert(scroll)
	-- do nothing
	storyboard.purgeScene("screen1")
	storyboard.purgeScene("grafico")
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
    group:remove(b)
	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
	-- INSERT code here (e.g. remove listeners, remove widgets, save state variables, etc.)
	
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene
