#include <hmg.ch>

function altaArticuloCompra(cCodigo,dFecha,cDescripcion)
local cQuery, oQuery

cQuery := " insert into articulo_compra values( '"+cCodigo+"' ,"
cQuery += " '"+dtos(dFecha)+"', "
cQuery += " '"+cDescripcion+"')"

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
  return .f.
else
  return .t.
endIf

function existeArticuloCompra(nCodigo)
local cQuery, oQuery

cQuery := "select * from articulo_compra where  codigo_barra = '"+nCodigo+"' "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
endIf

if oQuery:LastRec() > 0
	return .t.
else
	return .f.
endif


function modificoArticuloCompra(cCodigo,dFecha,cDescripcion)
local cQuery, oQuery

cQuery := " update articulo_compra set "
cQuery += " fecha = '"+dtos(dFecha)+"',"
cQuery += " descripcion = '"+cDescripcion+"' "
cQuery += " where codigo_barra = '"+cCodigo+"' "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
  return .f.
else
  return .t.
endIf

function oArticuloCompra(nArticulo)
local cQuery
local oQuery

cQuery := "select * from articulo_compra where  codigo_barra = '"+nArticulo+"' "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery
endIf