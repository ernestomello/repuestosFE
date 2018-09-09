#include <hmg.ch>

function cierresAnteriores()

  Load Window cierresAnteriores     
  cierresAnteriores.Center
  cierresAnteriores.Activate
              
return

procedure buscoCajasTraspasos()

if cierresAnteriores.RadioGroup_1.value = 1
  buscoCajasCerradas()
else
  buscoTraspasos()
Endif

return

procedure listoCajasTraspasos()

if cierresAnteriores.RadioGroup_1.value = 1
//  imprimoReporteCierre(cierresAnteriores.grid_1.item(cierresAnteriores.grid_1.value)[1],1)
else
  //imprimoReporteTraspaso(cierresAnteriores.grid_1.item(cierresAnteriores.grid_1.value)[1])
Endif

return


function  buscoCajasCerradas()
local oQuery
local oRow

if cierresAnteriores.text_1.value = 0
  cQuery := "Select c.id_caja, ca.nombre, c.fecha_hora from caja c, cajero ca "
  cQuery := cQuery +"where  ca.id_cajero=c.id_cajero and c.abierta=1 and c.fecha_hora between '"+dtos(cierresAnteriores.datepicker_1.value)+"' and '"+dtos(cierresAnteriores.datepicker_2.value)+"' order by 1 "
  oQuery := oServer:Query(cQuery)
  If oQuery:NetErr()												
    MsgInfo("SQL SELECT error: " + oQuery:Error())
  endIf
else
  cQuery := "Select c.id_caja, ca.nombre, c.fecha_hora from caja c, cajero ca "
  cQuery := cQuery +"where  ca.id_cajero=c.id_cajero and c.abierta=1 and c.id_caja = "+str(cierresAnteriores.text_1.value)+" order by 1 "
  oQuery := oServer:Query(cQuery)
  If oQuery:NetErr()												
    MsgInfo("SQL SELECT error: " + oQuery:Error())
  endIf 
endIf
cierresAnteriores.grid_1.deleteAllItems
For i := 1 To oQuery:LastRec()
  oRow := oQuery:GetRow(i)
  cierresAnteriores.grid_1.addItem({oRow:fieldGet(1),oRow:fieldGet(2) ,dtoc(oRow:fieldGet(3)),''})
  oQuery:Skip(1)
Next

oQuery:Destroy()

return


procedure buscoTraspasos()
local oQuery
local oRow

if cierresAnteriores.text_1.value = 0
  cQuery := "Select id_traspaso, importe, realizado, aceptado from traspaso "
  cQuery := cQuery +"where realizado between '"+dtos(cierresAnteriores.datepicker_1.value)+"' and '"+dtos(cierresAnteriores.datepicker_2.value)+"' order by 1 "
  oQuery := oServer:Query(cQuery)
  If oQuery:NetErr()												
    MsgInfo("SQL SELECT error: " + oQuery:Error())
  endIf
else
  cQuery := "Select id_traspaso, importe, realizado, aceptado from traspaso "
  cQuery := cQuery +"where  id_traspaso = "+str(cierresAnteriores.text_1.value)+" order by 1 "
  oQuery := oServer:Query(cQuery)
  If oQuery:NetErr()												
    MsgInfo("SQL SELECT error: " + oQuery:Error())
  endIf 
endIf
cierresAnteriores.grid_1.deleteAllItems
For i := 1 To oQuery:LastRec()
  oRow := oQuery:GetRow(i)
  cierresAnteriores.grid_1.addItem({oRow:fieldGet(1),str(oRow:fieldGet(2)) ,(oRow:fieldGet(3)),(oRow:fieldGet(4)) })
  oQuery:Skip(1)
Next

oQuery:Destroy()
return

procedure imprimoReporteTraspaso(id_traspaso)
local cCaja    
local cCajero  
local cSucursal
local cTurno   
local nFecha   
local Ypos      := PARAMETROini("RYpos","N")         
local Xpos      := PARAMETROini("RXpos","N")         
local fuente    := PARAMETROini("FuenteInforme","N") 
local esp       := PARAMETROini("Espacio","N")       
local previo    := PARAMETROini("PREVIOINF","N" )    
local xposD     := 0  
local yposD     := 0  
local nPag      := 1
local nGastosAcum := 0
cQuery := "select c.id_caja, j.nombre,s.nombre, t.descripcion,c.fecha_hora, tr.importe "
cQuery := cQuery + " from caja c, cajero j, sucursal s, turno t , traspaso tr"
cQuery := cQuery + " where tr.id_traspaso= "+str(id_traspaso)+" and c.id_caja = tr.caja_origen and j.id_cajero=c.id_cajero and t.id=c.id_turno and s.id=t.sucursal"         
oQuery := oServer:Query(cQuery)


If oQuery:NetErr()
  MsGInfo("Error executing Query "+cQuery+": "+oServer:Error() )
  return .f.
endIf
oRow:= oQuery:GetRow(1)


cCaja     := str(oRow:fieldGet(1))
cCajero   := alltrim(oRow:fieldGet(2))
cSucursal := alltrim(oRow:fieldGet(3))
cTurno    := alltrim(oRow:fieldGet(4))
nFecha    := dtoc(oRow:fieldGet(5))

SELECT PRINTER  'Informes' PAPERSIZE PRINTER_PAPER_FANFOLD_STD_GERMAN preview

START PRINTDOC



START PRINTPAGE
@ xPos , yPos          PRINT RECTANGLE TO (xPos + 10) , (yPos + 170) PENWIDTH 0.5 
@ xpos + 2, ypos + 2   PRINT data "Fecha: "+dtoc(Date())+" "
@ xpos + 2, ypos + 155 PRINT data "Página"
@ xpos + 5, ypos + 2   PRINT data "Hora:  "+Time()+" "
@ xpos + 5, ypos + 155 PRINT data " "+str(nPag)+" " BOLD                                
@ xpos + 10, ypos + 2  PRINT data "Caja Nro: "+cCaja+" Fecha: "+nFecha+" Cajero: "+cCajero+" Sucursal: "+cSucursal+" Turno: "+cTurno+"  " size fuente 
@ xPos + 15, yPos      PRINT LINE TO xPos + 15 , (yPos + 170) PENWIDTH 0.6

xPos := xPos + 18

cQuery := "select e.id_caja,e.descripcion,e.fecha, e.importe " 
cQuery := cQuery + " from  entrada_salida e "
cQuery := cQuery + " where e.id_traspaso= "+str(id_traspaso)+" "         
oQuery := oServer:Query(cQuery)


If oQuery:NetErr()
  MsGInfo("Error executing Query "+cQuery+": "+oServer:Error() )
  return .f.
endIf

 for i:=1 to oQuery:LastRec()
      xposd       :=  xpos +( i * esp)
      oRow        :=  oQuery:GetRow(i)
      nImporte    :=  oRow:fieldGet(4)
      dFecha      :=  oRow:fieldGet(3) 
      nGastosAcum :=  nGastosAcum + nImporte
      cDesc       :=  oRow:fieldGet(2)
      nSocio      :=  oRow:fieldGet(1)
      
      @ xposd , ypos + 2   PRINT data nSocio   size fuente
      @ xposd , ypos + 10  PRINT data substr(dFecha,1,10)   size fuente
      @ xposd , ypos + 40  PRINT data cDesc    size fuente
      @ xposd , ypos + 190 PRINT data nImporte  right   size fuente
      
      xposd := xposd + esp
 next      
if i = 1
  xposd := xpos + 18
endIf      
xpos := xposd + (esp * 2)
@ xpos , ypos             PRINT RECTANGLE to (xpos + 10), (ypos +170)  penwidth 0.5
@ xpos + esp, ypos + 2    PRINT data "Total de Traspaso"  size fuente
@ xpos + esp, ypos + 140  PRINT data nGastosAcum   right  size fuente 

END PRINTPAGE

END PRINTDOC
return