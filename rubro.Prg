#include <hmg.ch>

function idRubro(cDescripcion)
local cQuery, oQuery

cQuery := "select id_rubro from rubro "
cQuery += " where descripcion = '"+cDescripcion+"' "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:getRow(1):fieldGet(1)
endIf

function descripcionRubro(nIdRubro)
local cQuery, oQuery

cQuery := "select descripcion from rubro "
cQuery += " where id_rubro = "+str(nIdRubro)+" "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:getRow(1):fieldGet(1)
endIf

function oRubros()
local cQuery, oQuery

cQuery := "select * from rubro order by 2"

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery
endIf
