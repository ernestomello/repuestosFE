#include <hmg.ch>

function cambioRollo()

local nCaja
if cajaAbierta()

  Load Window cambioRollo      
  nCaja:= cajaId()
  cambioRollo.text_1.value := rollo(nCaja)
  cambioRollo.title:= cambioRollo.title +" - Id Caja:"+str(nCaja)
  rellenoCombo()
  cambioRollo.Center
  cambioRollo.Activate
  
endIf            
return

function rellenoCombo()
  
oQuery := oServer:Query( "Select * From rollo r where r.id_sucursal= (select id from sucursal where nombre='"+cSucursal+"')  and r.fecha_vencimiento > current_date and r.utilizado = 0 " )
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
endif
                                                                       

cambioRollo.combo_1.deleteAllItems

For i := 1 To oQuery:LastRec()
  oRow := oQuery:GetRow(i)
  cambioRollo.combo_1.addItem(str(oRow:fieldGet(1)))
  oQuery:Skip(1)
Next
      
oQuery:Destroy()

return

function graboCambioRollo()
local nCaja

nCaja       := cajaId()
cRolloAnt   :=  str(cambioRollo.text_1.value)
cRolloNuevo := val(cambioRollo.combo_1.displayValue)

if (cRolloNuevo !=0)
  if (msgYesNo("Cambia el rollo: "+cRolloAnt+" por: "+str(cRolloNuevo)+" de la Caja:"+str(nCaja)+" ") )
  
    oQuery := oServer:Query("update rollo set utilizado = 1 where numero = "+cRolloAnt+" ")
    If oQuery:NetErr()												
      MsgInfo("SQL SELECT error: " + oQuery:Error())
    endif
    
    oQuery := oServer:Query("update caja set rollo = "+str(cRolloNuevo)+" where id_caja = "+str(nCaja)+" ")
    If oQuery:NetErr()												
      MsgInfo("SQL SELECT error: " + oQuery:Error())
    endif
    
    cambioRollo.Release
  endIf
else
  msgInfo("Debe indicar un número de Rollo")
endIf




return 