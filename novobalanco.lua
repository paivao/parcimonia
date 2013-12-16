------------------------------------------------------------------------------
--
--  Tela 1
-- 
-- Arquivo usado ao clicar no Botão Inserir
------------------------------------------------------------------------------
local widget = require( "widget" )




local tHeight

local storyboard = require ( "storyboard" )

--Create a storyboard scene for this module
local scene = storyboard.newScene()
-------------------------------------------
-- General event handler for fields
-------------------------------------------

-- You could also assign different handlers for each textfield
function scene:createScene( event )
                
        local group = self.view
    
        local bg = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
	bg:setFillColor( 30, 30, 30 )
        
        group:insert(bg)
                
        RevMob.showFullscreen()
	
        local function fieldHandler( textField )
	return function( event )
		if ( "began" == event.phase ) then
			-- This is the "keyboard has appeared" event
			-- In some cases you may want to adjust the interface when the keyboard appears.
		
		elseif ( "ended" == event.phase ) then
			-- This event is called when the user stops editing a field: for example, when they touch a different field
			
                elseif ( "editing" == event.phase ) then
		
                elseif ( "submitted" == event.phase ) then
                        -- This event occurs when the user presses the "return" key (if available) on the onscreen keyboard
                        print( textField().text )
			
                        -- Hide keyboard
                        native.setKeyboardFocus( nil )
                end
            end
        end

    local campoTipo, campoNome, campoValor, campoDesc
    
---------------------------------------
-- ***Exibe o Balanço total***
---------------------------------------
--[[
local bal = display.newText("Balanço total: R$"..balanco.."", display.contentWidth*0.5-10, 
                            display.contentHeight*0.8, native.systemFont, 20)
if balanco == 0 then
    bal:setTextColor(255, 255, 255)
elseif balanco > 0 then
    bal:setTextColor(0, 255, 0)
else
    bal:setTextColor(255, 0, 0)
end
----]]  


       
-------------------------------------------
-- *** Create native input textfields ***
-------------------------------------------

-- Note: currently this feature works in device builds or Xcode simulator builds only (also works on Corona Mac Simulator)
local isAndroid = "Android" == system.getInfo("platformName")
local inputFontSize = 18
local inputFontHeight = 30
tHeight = 30

if isAndroid then
	-- Android text fields have more chrome. It's either make them bigger, or make the font smaller.
	-- We'll do both
	inputFontSize = 14
	inputFontHeight = 42
	tHeight = 40
end

--campoTipo = native.newTextField( 100, 60, 180, tHeight )
--campoTipo.font = native.newFont( native.systemFontBold, inputFontSize )
--campoTipo:addEventListener( "userInput", fieldHandler( function() return campoTipo end ) ) 

local varCampoNome = nil

--[[
local function listenerCampoNome()
	if event.phase == "editing" then
        varCampoNome = event.text
	elseif event.phase == "submitted" or event.phase == "ended" then
		varCampoNome = event.target.text
	end
end
]]

campoNome = native.newTextField( 100, 100, 180, tHeight )
campoNome.font = native.newFont( native.systemFontBold, inputFontSize )
campoNome.inputType = "text"
--campoNome:addEventListener( "userInput", listenerCampoNome )

--[[
local varCampoValor = nil
local function listenerCampoValor()
	if event.phase == "editing" then
        varCampoValor = event.text
	elseif event.phase == "submitted" or event.phase == "ended" then
		varCampoValor = event.target.text
	end
end
]]


campoValor = native.newTextField( 125, 140, 155, tHeight )
campoValor.font = native.newFont( native.systemFontBold, inputFontSize )
campoValor.inputType = "decimal"
--campoValor:addEventListener( "userInput", listenerCampoValor) 


--[[
local function listenerCampoDesc()
    if event.phase == "editing" then
        varCampoDesc = event.text
	elseif event.phase == "submitted" or event.phase == "ended" then
		varCampoDesc = event.target.text
	end
end
]]

campoDesc = native.newTextBox( 100, 180, 180, 120 )
campoDesc.font = native.newFont( native.systemFontBold, inputFontSize )
campoDesc.isEditable = true
--campoDesc.inputType = "text"
--campoDesc:addEventListener( "userInput", listenerCampoDesc ) 

--group:insert(campoTipo)
group:insert(campoNome)
group:insert(campoValor)
group:insert(campoDesc)


-------------------------------------------
-- *** Add field labels ***
-------------------------------------------

--local defaultLabel = display.newText( "Tipo", 10, 35, native.systemFont, 18 )
--defaultLabel:setTextColor( 170, 170, 255, 255 )

local defaultLabel2 = display.newText( "Nome", 10, 105, native.systemFont, 18 )
--defaultLabel:setTextColor( 255, 150, 180, 255 )

local defaultLabel3 = display.newText( "Valor         R$", 10, 145, native.systemFont, 18 )
--defaultLabel:setTextColor( 255, 220, 120, 255 )

local defaultLabel4 = display.newText( "Descrição", 10, 185, native.systemFont, 18 )
--defaultLabel:setTextColor( 170, 255, 170, 255 )

--group:insert(defaultLabel)
group:insert(defaultLabel2)
group:insert(defaultLabel3)
group:insert(defaultLabel4)

		----------------------------------------------
        -- ** Data
        ----------------------------------------------
--[[		
		
		-- Create two tables to hold our days & years      
local days = {}
local years = {}

-- Populate the days table
for i = 1, 31 do
    days[i] = i
end

-- Populate the years table
for i = 1, 44 do
    years[i] = 1969 + i
end

-- Set up the Picker Wheel's columns
local columnData = 
{ 
    { 
        align = "right",
        width = 150,
        startIndex = 5,
        labels = 
        {
            "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" 
        },
    },

    {
        align = "left",
        width = 60,
        startIndex = 18,
        labels = days,
    },

    {
        align = "center",
        width = 80,
        startIndex = 10,
        labels = years,
    },
}

-- Create a new Picker Wheel
local pickerWheel = widget.newPickerWheel
{
    top = display.contentHeight - 222,
    font = native.systemFontBold,
    columns = columnData,
}
		
		group:insert(pickerWheel)
		
		----------------------------------------------
        -- ** Data Fim
        ----------------------------------------------

--]]
    
        ----------------------------------------------
        -- ** BotÃµes
        ----------------------------------------------

		
local receitaTexto = display.newText("Receita", 5, 35, native.systemFont, 20)
--receitaTexto:setColor(255, 255, 255)
local despesaTexto = display.newText("Despesa", 230, 35, native.systemFont, 20)
--despesaTexto:setColor(255, 255, 255)
group:insert(receitaTexto)
group:insert(despesaTexto)
		
-- Handle press events for the switches
local ehReceita = true

local function eventoReceita( event )
    local switch = event.target
	
	ehReceita = true
    print( switch.id, "is on?:", switch.isOn )
end

local function eventoDespesa( event )
    local switch = event.target

	ehReceita = false
    print( switch.id, "is on?:", switch.isOn )
end




-- Create a default radio button (using widget.setTheme)
local receitaSwitch = widget.newSwitch
{
    left = 90,
    top = 30,
    style = "radio",
    id = "receitaId",
    initialSwitchState = true,
    onPress = eventoReceita,
}


local despesaSwitch = widget.newSwitch
{
    left = 190,
    top = 30,
    style = "radio",
    id = "despesaId",
    initialSwitchState = false,
    onPress = eventoDespesa,
}


group:insert(receitaSwitch)
group:insert(despesaSwitch)

-- *** BotÃ£o inserir ***

local function eventoBotaoInserir( event )
    local phase = event.phase 
    local nome, valor, desc
    if ("simulator" == system.getInfo("environment")) then
        nome = "ToalhaVoadora"
        valor = 3.14
        desc = "Liberdade é correr pelo céu!"
    else
        nome = campoNome.text
        valor = campoValor.text
        desc = campoDesc.text
    end
    if "ended" == phase and (nome and valor and desc) then
	
		bd:CriarElemento { 	nome = nome,
							valor = valor,
							data = os.date("%Y-%m-%d"),
							tipo = ehReceita,
							desc = desc,
						}
		system.vibrate()
		print (os.date("%Y-%m-%d"))
        --print( "Inserido com Sucesso" )
		AtualizarBalanco()
    end
end

-- Create the button
local botaoInserir = widget.newButton
{
    left = display.contentCenterX - 130,
    top = display.contentCenterY + 100,
    width = 50,
    height = 50,
    defaultFile = "imagens/tabIcon.png",
    overFile = "imagens/aperture.png",
    id = "botaoReceita",
    label = "Inserir",
    labelColor = {  default = {255, 255, 255 },
                    over = { 150, 150, 150 },},
    size = 25, 
    onEvent = eventoBotaoInserir,
}

group:insert(botaoInserir)


        ----------------------------------------------
        -- ** Fim Botões
        ----------------------------------------------
--group:insert(bal) -- tirei o 'b='

end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
    --b = group:insert(bal)
    storyboard.purgeScene("screen2")
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



--Add the createScene listener
scene:addEventListener( "createScene", scene )
scene:addEventListener( "destroyScene", scene )

scene:addEventListener( "exitScene", scene )
scene:addEventListener( "enterScene", scene )

return scene
