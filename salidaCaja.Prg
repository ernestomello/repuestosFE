#include <hmg.ch>

procedure salidaCaja()

if cajaAbierta()
  Load Window salidaCaja   
  cargoRubros()   
  salidaCaja.Center
  salidaCaja.Activate
else
	msgInfo("Caja Cerrada !!!")
endIf            
return


procedure cargoRubros()
local oRubros := oRubros()
salidaCaja.combo_1.deleteAllItems

for i= 1 to oRubros:lastRec()
	salidaCaja.combo_1.additem(oRubros:getRow(i):fieldGet(2))
next


procedure guardaSalida()
local nImporte,nCaja, dFecha,cDescripcion,nRubro

if len(alltrim(salidaCaja.text_1.value)) != 0 .and. salidaCaja.text_2.value != 0
  nCaja:= cajaId()
  cDescripcion:= salidaCaja.text_1.value
  dFecha := salidaCaja.datePicker_1.value
  nImporte:= salidaCaja.text_2.value
  nRubro := idRubro(salidaCaja.combo_1.displayValue)
  if !guardarSalida(ncaja,dFecha,cDescripcion,nImporte,nRubro)
			msgInfo("No se pudieron guardar los Cambios")
	else
		salidaCaja.text_2.value := 0
		salidaCaja.text_1.value := ""
		msgInfo("Cambios guardados")
	endIf  
else
  msginfo('Debe completar con Datos')
endIf


*************************************************
*************************************************
******Implementaciones del modelo ***************
*************************************************
*************************************************
function guardarSalida(nIdCaja,dFecha,cDescripcion,nImporte,nRubro)
local cQuery, oQuery

cQuery := " insert into salida_caja values( "
cQuery += " null, "+str(nIdCaja)+", '"+dtos(dFecha)+"','"+cDescripcion+"', "
cQuery += " "+str(nImporte)+", "+str(nRubro)+"  )"

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
  return .f.
else
  return .t.
endIf

function totalSalidaCaja(nCaja)

local cQuery, oQuery

cQuery := " select id_caja, sum(importe) "
cQuery += " from salida_caja "
cQuery += " where id_caja = "+str(nCaja)+" "
cQuery += " group by 1  "

oQuery:= oServer:Query(cQuery)
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
endif
return oQuery:getRow(1):fieldGet(2)

