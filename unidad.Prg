#include <hmg.ch>
function oUnidad()
local cQuery
local oQuery

cQuery := "select * from unidad "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery
endIf

function nombreUnidad(nUnidad)
local cQuery
local oQuery

cQuery := "select nombre from unidad  where id_unidad = "+str(nUnidad)+" "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:getRow(1):fieldGet(1)
endIf

function idUnidad(cNombreUnidad)
local cQuery
local oQuery

cQuery := "select id_unidad from unidad  where nombre = '"+cNombreUnidad+"' "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:getRow(1):fieldGet(1)
endIf