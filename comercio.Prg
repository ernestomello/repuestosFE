#include <hmg.ch>



function nombreComercio(nComercio)
local cQuery
local oQuery

cQuery := "select nombre from comercio where  id_comercio = "+str(nComercio)+""

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf

function direccionComercio(nComercio)
local cQuery
local oQuery

cQuery := "select direccion from comercio where  id_comercio = "+str(nComercio)+""

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf
