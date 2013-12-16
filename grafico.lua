local widget = require("widget")
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
-------------------------------------------
-- General event handler for fields
-------------------------------------------

local function FazerGrafico(inicio, fim)
local grupo = display.newGroup()
local i = inicio or 1
local j = fim or 12
local mes = {"J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D"}
local mesinicial = mes[i]
local mesfinal = mes[j]
local posinicial = 60 + i*20
local posfinal = 60 + j*20
--[[
local valor = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
local maximo, minimo = 0, 0
local xizes = bd:ExibirElementos ("SELECT SUM(elm_Valor) AS elm_Valor, elm_Data FROM Elemento WHERE elm_Tipo = 1 GROUP BY date(elm_Data,\"%m\");")
local z = 0
for _,x in pairs(xizes) do
    z = string.byte(x.data.mes) - 40
    valor[z] = valor[z] + string.gsub(x.valor, ",", ".")
    if (maximo < valor[z]) then maximo = valor[z] end
    if (minimo > valor[z]) then minimo = valor[z] end
end
local xizes = bd:ExibirElementos ("SELECT SUM(elm_Valor) AS elm_Valor, elm_Data FROM Elemento WHERE elm_Tipo = 0 GROUP BY date(elm_Data,\"%m\");")
if (#xizes > 0) then maximo, minimo = 0, 0 end
for _,x in pairs(xizes) do
    z = string.byte(x.data.mes) - 40
    valor[z] = valor[z] - string.gsub(x.valor, ",", ".")
    print(valor[z])
    if (maximo < valor[z]) then maximo = valor[z] end
    if (minimo > valor[z]) then minimo = valor[z] end
end
]]

local x0 = math.random(-20000, 20000)
local x1 = math.random(-20000, 20000)
local x2 = math.random(-20000, 20000)
local x3 = math.random(-20000, 20000)
local x4 = math.random(-20000, 20000)
local x5 = math.random(-20000, 20000)
local x6 = math.random(-20000, 20000)
local x7 = math.random(-20000, 20000)
local x8 = math.random(-20000, 20000)
local x9 = math.random(-20000, 20000)
local x10 = math.random(-20000, 20000)
local x11 = math.random(-20000, 20000)
local valor = {x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11}
local maximo = math.max(x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11)
local minimo = math.min(x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11)

local posicaomes = {}
local tamanho  --tamanho vai desde o maior valor ate o menor valor
local tamanho2
local proporcao
--tamanho = maximo   --tamanho2 eh apenas para a parte negativa
if maximo==0 and minimo == 0 then
	proporcao = 0
	
	elseif maximo>=0 and minimo>=0 then
		tamanho = maximo
			minimo = 0
		proporcao = 340/tamanho
    
		else if  maximo>=0 and minimo<=0 then
			tamanho = maximo - minimo
			tamanho2 = -minimo
			proporcao = 340/(tamanho)
			else if maximo<=0 and minimo<=0 then
				tamanho = -minimo
				maximo = 0
					proporcao = 340/tamanho
				
			end
		end
	end
--end
local linhahorizontal = display.newLine(40, (400-(proporcao*(-minimo))), 300, (400-(proporcao*(-minimo))))
local linhavertical = display.newLine(41, 400, 41, 40)
grupo:insert(linhahorizontal)
grupo:insert(linhavertical)
local marcacao = {}
local retangulo = {}
local reta = {}
for k=i, j, 1 do 
    local nomemesinicial = display.newText(mes[k], 60 + k*20 - 5-20, (400-(proporcao*(-minimo)))+10, native.systemFontBold, 15)
	grupo:insert(nomemesinicial)
    --if k~=1 then
       local traco1 = display.newLine(60 + k*20-20, (400-(proporcao*(-minimo)))-5, 60 + k*20-20, (400-(proporcao*(-minimo)))+5) 
    grupo:insert(traco1)
	--end
    posicaomes[k] = (valor[k-i+1]-minimo)*proporcao
    posicaomes[k] = 400 - posicaomes[k]
    retangulo[k] = display.newRect(60 + k*20-20-3, posicaomes[k]-3, 6, 6)
	local cor1
    local cor2
    local cor3
    cor3 = 0
    if valor[k]>0 then
        cor1 = 0
        cor2 = 255
        else if valor[k]<0 then
            cor1 = 255
            cor2 = 0
            else if valor[k]==0 then
                cor1 = 255
                cor2 = 255
                cor3 = 0
            end
        end
    end
    
    retangulo[k]:setFillColor(cor1, cor2, cor3)
	grupo:insert(retangulo[k])
    if k>i and k<=j then
        local m = k-1
        local n = 60 + m*20
        local p = 60 + k*20
        reta[k] = display.newLine(n-20, posicaomes[m], p-20, posicaomes[k])
		grupo:insert(reta[k])
    end
    local texto = display.newText(valor[k-i+1], 1, posicaomes[k]-6, native.systemFontBold, 10)
	grupo:insert(texto)
    local tracodovalor = display.newLine(38, posicaomes[k], 44, posicaomes[k])
	grupo:insert(tracodovalor)
end
return grupo
end

-- You could also assign different handlers for each textfield
function scene:createScene( event )
                
        local group = self.view
		local aaa = FazerGrafico()
		group:insert(aaa)

end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
		storyboard.purgeScene("screen1")
		storyboard.purgeScene("screen2")
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
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