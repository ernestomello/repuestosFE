#include <hmg.ch>

procedure mantenimientolocacion(nlocacion)

load window locacion
rellenoGridlocacion()
if nlocacion != 0
	//rellenoDatoslocacion(clocacion)
endIf

locacion.center
locacion.activate

procedure rellenoGridlocacion()
local olocacions := olocacion()
locacion.grid_1.deleteAllItems

for i = 1 to olocacions:lastrec()
	locacion.grid_1.addItem({olocacions:getRow(i):fieldGet(1),alltrim(olocacions:getRow(i):fieldGet(2))})
next

procedure modificoDescripcionlocacion()
locacion.text_1.value := locacion.grid_1.cell(locacion.grid_1.value,2)
locacion.text_2.value := locacion.grid_1.cell(locacion.grid_1.value,1)

procedure guardaCambioslocacion()

if locacion.text_2.value = 0
	if insertarlocacion(locacion.text_1.value)
		msgInfo("locacion Ingresada")
		rellenoGridlocacion()
	endIf
else
	if modificarDescripcionlocacion(locacion.text_2.value, locacion.text_1.value)
		msgInfo("Descripción Modificada")
		rellenoGridlocacion()
	endIf
endIf

locacion.text_1.value:=''
locacion.text_2.value:= 0

procedure borralocacion()

if msgyesno("Desea Borrar la locacion")
	if borrarlocacion(locacion.text_2.value)
		locacion.grid_1.deleteItem(locacion.grid_1.value)
	else
		msginfo("No se pudo Borrar, Consulte Administrador")
	endIf
endIf
*************************************************
*************************************************
******Implementaciones del modelo ***************
*************************************************
*************************************************
function descripcionlocacion(nlocacion)
local cQuery
local oQuery

cQuery := "select descripcion from locacion where  id_locacion = "+str(nlocacion)+" "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf
function idLocacion(cDescripcion)
local cQuery
local oQuery

cQuery := "select id_locacion from locacion where  descripcion = '"+cDescripcion+"' "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf
function olocacion()
local cQuery
local oQuery

cQuery := "select * from locacion order by descripcion "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery
endIf

function borrarlocacion(nlocacion)
local cQuery
local oQuery

cQuery := "delete from locacion where id_locacion = "+str(nlocacion)+" "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
  return .f.
else
  return .t.
endIf

function insertarlocacion(cDescripcion)
local cQuery
local oQuery

cQuery := "insert into locacion values(null, '"+cDescripcion+"') "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
  return .f.
else
  return .t.
endIf

function modificarDescripcionlocacion(nlocacion,cDescripcion)
local cQuery
local oQuery

cQuery := "update locacion set descripcion = '"+cDescripcion+"' where id_locacion ="+str(nlocacion)+" "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
  return .f.
else
  return .t.
endIf