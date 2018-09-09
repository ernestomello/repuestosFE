#include <hmg.ch>
*************************************************
*************************************************
******Implementaciones del modelo ***************
*************************************************
*************************************************
function descripcionModelo(nModelo)
local cQuery
local oQuery

cQuery := "select descripcion from modelo where  id_modelo = "+str(nModelo)+" "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf

function idMarcaModelo(nModelo)
local cQuery
local oQuery

cQuery := "select id_marca from modelo where  id_modelo = "+str(nModelo)+" "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf

function modelosMarca(nMarca)
local cQuery
local oQuery

cQuery := "select * from marca where  id_marca = "+str(nMarca)+" "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf