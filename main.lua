--[[

main.lua
Toalha Voadora Ltda.

Toalheiros:
    Eduardo Octavio Guimarães
    Leonardo dos Santos Teixeira de Souza
    Rafael de Paula Paiva
]]

-- show default status bar (iOS)
display.setStatusBar( display.DefaultStatusBar )


-- include Corona's "widget" library
local widget = require "widget"
local storyboard = require "storyboard"

-- Inicializar o BD
bd = require "bd"

--[[local lista = bd:ExibirElementos()

print(type(lista))

for _,elemento in ipairs(lista) do
    local Data = ExtrairData(elemento.data)
    if Data then Data = Data.dia.."\\"..Data.mes.."\\"..Data.ano else Data = "Sem Data" end
    print("Movimentação nº: " .. elemento.id)
    print("Nome: " .. elemento.nome)
    print("Valor: " .. elemento.valor)
    print("Tipo: " .. (elemento.tipo == 1 and "Receita" or "Despesa"))
    print("Data: " .. Data)
    print("Descrição: " .. (elemento.desc or "Sem descrição."))
    print()
	if (#elemento.cat) then
        print("  O elemento possui "..#elemento.cat.." categorias.")
        for i,incat in ipairs(elemento.cat) do
            print("    Categoria "..i..": "..incat)
        end
    else
        print("  O elemento não possui categorias.")
    end
    print()
end]]

--[[
    YEAR: [0,x1-1]
    MONTH: [x1+1,x2-1]
    DAY: [x2+1, x3-1]
    HOUR: [x3+1,x4-1]
    MINUTE: [x4+1,x5-1]
    SECOND: [x5+1,END]
]]
--[[
function ExtrairData (datastr)
    local structure = nil
    if (datastr ~= "NULL") then
        structure = {}
    
        structure.ano = string.sub(datastr, 1, 4)
        structure.mes = string.sub(datastr, 6, 7)
        structure.dia = string.sub(datastr, 9, 10)
        structure.hora = string.sub(datastr, 12, 13)
        structure.hora = string.sub(datastr, 15, 16)
        structure.hora = string.sub(datastr, 18, 19)
    end

    return structure
end
]]

local balanco = bd:ObterBalanco()
b = 0
bal  = display.newText("Balanço total: R$ "..balanco, 15, 
                            2, native.systemFont, 20)
if balanco == 0 then
    bal:setTextColor(255, 255, 255)
elseif balanco > 0 then
    bal:setTextColor(0, 255, 0)
else
     bal:setTextColor(255, 0, 0)
end

function AtualizarBalanco(x) 
    local balanco = bd:ObterBalanco(x)
    bal.text="Balanço total: R$ "..balanco
    if balanco == 0 then
        bal:setTextColor(255, 255, 255)
    elseif balanco > 0 then
        bal:setTextColor(0, 255, 0)
    else
        bal:setTextColor(255, 0, 0)
    end
    storyboard.reloadScene()
end



-- event listeners for tab buttons:
local function novoBalanco( event )
	storyboard.gotoScene( "novobalanco" )
end

local function verBalanco( event )
	storyboard.gotoScene( "lista" )
end

local function verGrafico( event )
	storyboard.gotoScene( "grafico" )
end

-- create a tabBar widget with two buttons at the bottom of the screen

-- table to setup buttons
local tabButtons = {
	{ label="Inserir", size=30, labelYOffset = -10, defaultFile = "imagens/tabIcon.png", overFile = "imagens/tabIcon-down.png", width = 1, height = 1, onPress=novoBalanco, selected=true },
 	{ label="Analise", size=30, labelYOffset = -10, defaultFile = "imagens/tabIcon.png", overFile = "imagens/tabIcon-down.png", width = 1, height = 1, onPress=verBalanco },
	{ label="Grafico", size=30, labelYOffset = -10, defaultFile = "imagens/tabIcon.png", overFile = "imagens/tabIcon-down.png", width = 1, height = 1, onPress=verGrafico },
 	
}

-- create the actual tabBar widget
local tabBar = widget.newTabBar{
	top = display.contentHeight - 50,	-- 50 is default height for tabBar widget
	buttons = tabButtons
}


onFirstView()	-- invoke first tab button's onPress event manually
