sqlite3 = require "sqlite3" --DUH!

local objetobd = {}
            
local arquivo = system.pathForFile("toalhaeconomica.bd", system.DocumentsDirectory)
arquivo = io.open(arquivo)


local function onSystemEvent( event )
    if event.type == "applicationExit" then
        if db and db:isopen() then
            db:close()
        end
    end
end
Runtime:addEventListener( "system", onSystemEvent )


if arquivo then
    io.close(arquivo)
    arquivo = system.pathForFile("toalhaeconomica.bd", system.DocumentsDirectory)
    objetobd.bd = sqlite3.open(arquivo)
    print(objetobd.bd:exec("PRAGMA foreign_keys = ON;"))
else
    arquivo = system.pathForFile("toalhaeconomica.bd", system.DocumentsDirectory)
    objetobd.bd = sqlite3.open(arquivo)
    print ("Novo Banco de Dados")
    --Criar as estruturas
    local tablesetup = [[CREATE TABLE Elemento (elm_Id INTEGER PRIMARY KEY ASC AUTOINCREMENT,
			    elm_Nome CHARACTER(16) NOT NULL, elm_Valor DECIMAL(9,2) NOT NULL,
			    elm_Data DATE NOT NULL, elm_Tipo BOOLEAN NOT NULL, descricao TEXT NOT NULL);]]
    print(tablesetup)
    objetobd.bd:exec(tablesetup)
    local tablesetup = [[CREATE TABLE Categoria (cat_Id INTEGER PRIMARY KEY ASC AUTOINCREMENT,
			    cat_Nome CHARACTER(16) NOT NULL);]]
    print(tablesetup)
    objetobd.bd:exec(tablesetup)
    local tablesetup = [[CREATE TABLE ElmCat (ec_Id INTEGER PRIMARY KEY ASC AUTOINCREMENT,
			    ec_Elm INTEGER NOT NULL REFERENCES Elemento(elm_Id) ON DELETE CASCADE,
                ec_Cat INTEGER NOT NULL REFERENCES Categoria(cat_Id) ON DELETE CASCADE);]]
    print(tablesetup)
    objetobd.bd:exec(tablesetup)
    local tablesetup = [[CREATE TABLE Orcamento (orc_Id INTEGER PRIMARY KEY ASC AUTOINCREMENT,
			    orc_Nome CHARACTER(16) NOT NULL, orc_Query CHARACTER(16) NOT NULL);]]
    print(tablesetup)
    objetobd.bd:exec(tablesetup)
    --Preenche as categorias padrão (POSSÍVEL MERDA! VDM 0,95)
    local tablesetup = [[INSERT INTO Categoria VALUES ("Alimentacao"),("Transporte"),("Vestiario"),("Eletronicos"),("Foo"),("Bar");]]
    print(tablesetup)
    objetobd.bd:exec(tablesetup)
end

--Insere as funcoes basicas de insercao
function objetobd:CriarElemento (novo)
    local query = 'INSERT INTO Elemento VALUES (NULL,"'..novo.nome..'",'..novo.valor..',"'..novo.data..'",'.. (novo.tipo and 1 or 0) .. ',"' .. novo.desc .. '");'
    print (query)
    return self.bd:exec(query)
end

function objetobd:ExcluirElemento (item)
    local query = 'DELETE FROM Elemento WHERE elm_Id='..item..';'
    print (query)
    return self.bd:exec(query)
end

--Query basica
function objetobd:ExibirElementos (query, opcao)
    local texto = query or "SELECT * FROM Elemento;"
    local saida = {}
    for row in self.bd:nrows(texto) do
        local ip, fp
        ip = math.floor(row.elm_Valor)
        fp = 100*(row.elm_Valor - ip)
        if (fp == 0) then
            fp = "00"
        elseif (fp < 10) then
            fp = "0"..fp
        end
    	saida[#saida+1] = {}
        if (string.find(texto,"elm_Id") or string.find(texto,"*")) then saida[#saida].id=row.elm_Id end
        if (string.find(texto,"elm_Nome") or string.find(texto,"*")) then saida[#saida].nome=row.elm_Nome end
        if (string.find(texto,"elm_Valor") or string.find(texto,"*")) then saida[#saida].valor=ip..","..fp end
        if (string.find(texto,"elm_Data") or string.find(texto,"*")) then saida[#saida].data={} end
        if (string.find(texto,"elm_Tipo") or string.find(texto,"*")) then saida[#saida].tipo=row.elm_Tipo end
        if (string.find(texto,"elm_Descricao") or string.find(texto,"*")) then saida[#saida].desc=row.elm_Descricao end
        if (opcao) then saida[#saida].cat={} end
        if ((string.find(texto,"elm_Data") or string.find(texto,"*")) and row.elm_Data ~= "NULL") then
            if ((string.find(texto,"elm_Data") or string.find(texto,"*")) < string.find(texto,"FROM")) then
                print(row.elm_Data)
                saida[#saida].data.ano = string.sub(row.elm_Data, 1, 4)
                saida[#saida].data.mes = string.sub(row.elm_Data, 6, 7)
                saida[#saida].data.dia = string.sub(row.elm_Data, 9, 10)
                print(saida[#saida].data.mes.."/"..saida[#saida].data.dia)
            end
        end
    end
    if (opcao) then
        for _,v in ipairs(saida) do
            local j = 1
            for row in self.bd:nrows("SELECT Categoria.cat_Nome FROM Categoria INNER JOIN ElmCat ON Categoria.cat_Id = ElmCat.ec_Cat WHERE ElmCat.ec_Elm="..v.id) do
                v.cat[j] = row.cat_Nome
                j = j + 1
            end
        end
    end
    return saida
end

function objetobd:CriarCategoria (nome)
    local query = 'INSERT INTO Categoria VALUES (NULL,"'..nome..'");'
    print (query)
    return self.bd:exec(query)
end

function objetobd:ListarCategorias ()
    local array = {}
    for row in self.bd:nrows("SELECT * FROM Categoria;") do
        array[#array+1] = {id=row.cat_Id, nome=row.cat_Nome}
    end
    return array
end

function objetobd:ExcluirCategoria (item)
    local query = 'DELETE FROM Categoria WHERE cat_Id='..item..';'
    print (query)
    return self.bd:exec(query)
end

function objetobd:AssociarCategoria (elm, cat)
    local query = 'INSERT INTO ElmCat (id_Elm, id_Cat) VALUES ('..elm..','..cat..');'
    print (query)
    return self.bd:exec(query)
end

function objetobd:ObterBalanco(lista)
    local elem = lista or "SELECT elm_Valor, elm_Tipo FROM Elemento WHERE elm_Data <= date('now');"
    local balanco = 0
    for row in self.bd:nrows(elem) do
        if row.elm_Tipo == 1 then
            balanco = balanco + row.elm_Valor
        else
            balanco = balanco - row.elm_Valor
        end
    end
    if (math.abs(balanco)<0.01) then balanco = 0 end
    return balanco
end

--Funções para indices
objetobd.indices = {}
function objetobd:AddIndice (aaa)
    self.indices[aaa] = true
end
function objetobd:RemoveIndice (aaa)
    self.indices[aaa] = false
end


return objetobd