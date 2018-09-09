#include <hmg.ch>




*************************************************
*************************************************
******Implementaciones del modelo ***************
*************************************************
*************************************************


function numeroDesde(cTipo)
local cQuery
local oQuery

cQuery := "select numero_desde from numerador "
cQuery += " where habilitado = 0 "
cQuery += " and tipo = '"+cTipo+"'"
oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
  return 0
else
  return oQuery:GetRow(1):fieldGet(1)
endIf

function agregoNumeroDesde(cTipo)
local cQuery, oQuery

cQuery := "update numerador set numero_desde= numero_desde + 1  "
cQuery += " where  habilitado = 0"
cQuery += " and tipo = '"+cTipo+"'"

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
  oQuery:=oServer:Query('ROLLBACK') 
	return .f.
else
	return .t.
endIf



function serie()
local cQuery
local oQuery

cQuery := "select serie from numerador where "
cQuery := cQuery + " habilitado = 0"

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf
