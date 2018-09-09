#include <hmg.ch>
procedure mantenimientoMarca(nMarca)

load window marca
rellenoGridMarca()
if nMarca != 0
	//rellenoDatosMarca(cmarca)
endIf

marca.center
marca.activate

procedure rellenoGridMarca()
local oMarcas := oMarca()
marca.grid_1.deleteAllItems

for i = 1 to oMarcas:lastrec()
	marca.grid_1.addItem({oMarcas:getRow(i):fieldGet(1),alltrim(oMarcas:getRow(i):fieldGet(2))})
next

procedure modificoDescripcionMarca()
marca.text_1.value := marca.grid_1.cell(marca.grid_1.value,2)
marca.text_2.value := marca.grid_1.cell(marca.grid_1.value,1)

procedure guardaCambiosMarca()

if marca.text_2.value = 0
	if insertarMarca(marca.text_1.value)
		msgInfo("Marca Ingresada")
		rellenoGridMarca()
	endIf
else
	if modificarDescripcionMarca(marca.text_2.value, marca.text_1.value)
		msgInfo("Descripción Modificada")
		rellenoGridMarca()
	endIf
endIf

marca.text_1.value:=''
marca.text_2.value:= 0

procedure borraMarca()

if msgyesno("Desea Borrar la Marca")
	if borrarMarca(marca.text_2.value)
		marca.grid_1.deleteItem(marca.grid_1.value)
	else
		msginfo("No se pudo Borrar, Consulte Administrador")
	endIf
endIf
*************************************************
*************************************************
******Implementaciones del modelo ***************
*************************************************
*************************************************
function descripcionMarca(nMarca)
local cQuery
local oQuery

cQuery := "select descripcion from marca where  id_marca = "+str(nMarca)+" "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf

function oMarca()
local cQuery
local oQuery

cQuery := "select * from marca order by descripcion "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery
endIf

function borrarMarca(nMarca)
local cQuery
local oQuery

cQuery := "delete from marca where id_marca = "+str(nMarca)+" "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
  return .f.
else
  return .t.
endIf

function insertarMarca(cDescripcion)
local cQuery
local oQuery

cQuery := "insert into marca values(null, '"+cDescripcion+"') "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
  return .f.
else
  return .t.
endIf

function modificarDescripcionMarca(nMarca,cDescripcion)
local cQuery
local oQuery

cQuery := "update marca set descripcion = '"+cDescripcion+"' where id_marca ="+str(nMarca)+" "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
  return .f.
else
  return .t.
endIf