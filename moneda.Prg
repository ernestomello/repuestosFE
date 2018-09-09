#include <hmg.ch>

function cotizacion_moneda()
load window moneda
rellenoComboMonedas()
moneda.center
moneda.activate

procedure rellenoComboMonedas()
local oMonedas := oMoneda()

for i = 1 to oMonedas:lastrec()
	moneda.combo_1.addItem(alltrim(oMonedas:getRow(i):fieldGet(1)))
next

moneda.combo_1.value := 3
moneda.text_1.value := busco_cotizacion(idMoneda(moneda.combo_1.displayvalue))

function guardoCotizacion()
local nMoneda:= idMoneda(moneda.combo_1.displayValue)
local nImporte := moneda.text_1.value


if guardo_cotizacion(nMoneda,nImporte)
	msginfo("Cotización Cambiada")
	refrescoCotizacion()
	moneda.release
else
	msginfo("Cotización NO se pudo cambiar")
endif

function guardo_cotizacion(nMoneda,nImporte)
local cQuery
local oQuery

cQuery := "update cotizacion_moneda "
cQuery += "set cotizacion = "+str(nImporte)+", "
cQuery += "fecha = current_date "
cQuery += "where id_moneda = "+str(nMoneda)+" "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
	return .f.
else
  return .t.
endIf

function busco_cotizacion(nMoneda)
local cQuery
local oQuery

cQuery := "select cotizacion from cotizacion_moneda where id_moneda = "+str(nMoneda)+" "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf



function idMoneda(cMoneda)
local cQuery
local oQuery

cQuery := "select id_moneda from moneda where signo = '"+cMoneda+"'"

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf

function signoMoneda(nMoneda)
local cQuery
local oQuery

cQuery := "select signo from moneda where id_moneda = "+str(nMoneda)+" "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf

function fechaMoneda(nMoneda)
local cQuery
local oQuery

cQuery := "select fecha from cotizacion_moneda where id_moneda = "+str(nMoneda)+" "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf

function oMoneda()
local cQuery
local oQuery

cQuery := "select signo from moneda "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery
endIf
