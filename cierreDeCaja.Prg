#include <hmg.ch>

function cierreDeCaja(cierra)
local nCaja
nCaja:= cajaId()

if !cajaCerrada() 
  
  
  if cierra = 1 
	if (msgYesNo("Cierra la caja:"+str(nCaja)+"", "Cajero:"+nombreCajeroActivo(nCaja)+""   ))
      if cierroCaja(nCaja)
        //if imprimoReporteCierre(nCaja,0)
          msgInfo("Caja cerrada")
          //actualizoEstado()
        //else
          //msgInfo("Caja no se pudo cerrar. Reintente!!!")
        //endif
      else
        msgInfo("Caja no se pudo cerrar. Reintente!!!")
      endif
    endif
  else
    if imprimoReporteCierre(nCaja,1)
          msgInfo("Solo Reporte")
        else
          msgInfo("Caja no se pudo cerrar. Reintente!!!")
        endIf
  endIf
else
  msgInfo('La caja ya está CERRADA ' )
endif

Close Database
Return

function cierroCaja(nCaja)
cQuery := "select * from traspaso where aceptado is NULL and caja_origen="+str(nCaja)+" "
oQuery := oServer:Query(cQuery)

If oQuery:NetErr()
  MsGInfo("Error executing Query "+cQuery+": "+oServer:Error() )
  return .f.
endIf


if date() = fechaTurno4(nCaja)
  msgInfo('El turno 4 no puede cerrar antes de la Hora 24')
  return .f.
elseIf oQuery:LastRec() <= 0

  cQuery := "update caja set abierta=1 , fecha_hora_cierre= current_timestamp where id_caja="+str(nCaja)+" "
  oQuery := oServer:Query(cQuery)
  
  If oQuery:NetErr()
    MsGInfo("Error executing Query "+cQuery+": "+oServer:Error() )
    return .f.
  endIf 
else
  msgInfo('Tiene Pendiente la Aceptación de Traspasos. Avise a Gerencia' )
  return .f.
endif

return .t.


//function imprimoReporteCierre(idCaja,copia)
//local nBaseCaja 
//local cCaja     
//local cCajero   
//local cSucursal 
//local cTurno    
//local nFecha    
//local nImporteInicial
//local Ypos      
//local Xpos      
//local fuente    
//local esp       
//local previo    
//local xposD     
//local yposD
//local npag     
//local nLinea 
//local nTotRec
//local cDesc  
//local nSocio 
//local nGastosAcum
//local nCantidad  
//local nTotExt
//local nTotDep
//local paso := 0  
//   
//
//cQuery := "select c.id_caja, j.nombre,s.nombre, t.descripcion,c.fecha_hora,c.importe_incial "
//cQuery := cQuery + "from caja c, cajero j, sucursal s, turno t "
//cQuery := cQuery + " where id_caja ="+str(idCaja)+" and j.id_cajero = c.id_cajero and t.id=c.id_turno and s.id=t.sucursal"         
//oQuery := oServer:Query(cQuery)
//
//
//If oQuery:NetErr()
//  MsGInfo("Error executing Query "+cQuery+": "+oServer:Error() )
//  return .f.
//endIf
//oRow:= oQuery:GetRow(1)
//
//cCaja     := str(idCaja)
//cCajero   := alltrim(oRow:fieldGet(2))
//cSucursal := alltrim(oRow:fieldGet(3))
//cTurno    := alltrim(oRow:fieldGet(4))
//nFecha    := dtoc(oRow:fieldGet(5))
//nImporteInicial:=oRow:fieldGet(6)
//Ypos      := PARAMETROini("RYpos","N")
//Xpos      := PARAMETROini("RXpos","N")
//fuente    := PARAMETROini("FuenteInforme","N")
//esp       := PARAMETROini("Espacio","N")
//previo    := PARAMETROini("PREVIOINF","N" )
//xposD     := 0
//yposD     := 0
//
//nBaseCaja := baseCaja(idSucursal(cSucursal))
//
// if previo = 1
//    SELECT PRINTER  'Informes' PAPERSIZE PRINTER_PAPER_FANFOLD_STD_GERMAN preview
//  else
//    SELECT PRINTER  'Informes' PAPERSIZE PRINTER_PAPER_FANFOLD_STD_GERMAN
//  endIf
//* PRINTER_PAPER_USER PAPERLENGTH 152 PAPERWIDTH 225
//
//START PRINTDOC
//
//nPag := 1
//cQuery := "select d.id_socio, d.descripcion, d.precio_unitario, d.cantidad,  s.id_convenio,d.id_servicio  "
//cQuery := cQuery + " from mov_cabezal c, mov_detalle d, servicio a, socio s "
//cQuery := cQuery + " where c.id_mov = d.id_mov   "
//cQuery := cQuery + " and c.id_caja = "+cCaja+" "
//cQuery := cQuery + " and d.id_servicio = a.id_servicio "
//cQuery := cQuery + " and a.facturable = 1 "
//cQuery := cQuery + " and s.id_socio = d.id_socio "
//cQuery := cQuery + " and c.anulado = 'N' "
//cQuery := cQuery + " and c.id_cajero in (select id_cajero from cajero where privilegios != 'COBRADOR') "
//cQuery := cQuery + " order by 1 "
//
//
//
//oQuery := oServer:Query(cQuery)
//
//If oQuery:NetErr()
//  MsGInfo("Error executing Query "+cQuery+": "+oServer:Error() )
//  return .f.
//endIf
//
//START PRINTPAGE
//@ xPos , yPos          PRINT RECTANGLE TO (xPos + 10) , (yPos + 170) PENWIDTH 0.5 
//@ xpos + 2, ypos + 2   PRINT data "Fecha: "+dtoc(Date())+" "
//if copia = 1
//@ xpos + 2, ypos + 50   PRINT data "**** COPIA DEL ORIGINAL ****"
//endIf
//
//@ xpos + 2, ypos + 155 PRINT data "Página"
//@ xpos + 5, ypos + 2   PRINT data "Hora:  "+Time()+" "
//@ xpos + 5, ypos + 155 PRINT data " "+str(nPag)+" " BOLD                                
//@ xpos + 10, ypos + 2  PRINT data "Caja Nro: "+cCaja+" Fecha: "+nFecha+" Cajero: "+cCajero+" Sucursal: "+cSucursal+" Turno: "+cTurno+"  " size fuente 
//@ xPos + 15, yPos      PRINT LINE TO xPos + 15 , (yPos + 170) PENWIDTH 0.6
//
//
//*xPos := xPos + 17
// @ xpos + 16 , ypos + 2   PRINT data "Nro." size fuente
// @ xpos + 16 , ypos + 16  PRINT data "Nombre Socio"
// @ xpos + 16 , ypos + 75  PRINT data "Convenio " size fuente
// @ xpos + 16 , ypos + 116 PRINT data "Mes " size fuente
// @ xpos + 16 , ypos + 180 PRINT data "Importe" right size fuente
//xPos := xPos + 18
//va := 1
//nTotRec := 0
// for i:=1 to oQuery:LastRec()
//      va := va + 1
//      xposd   :=  xpos +( va * esp)
//      oRow    :=  oQuery:GetRow(i)
//      nLinea  :=  oRow:fieldGet(3) * oRow:fieldGet(4)
//      nTotRec :=  nTotRec + nLinea
//      if oRow:fieldGet(8) = 1 
//        cDesc   :=  substr(oRow:fieldGet(2),18,len(oRow:fieldGet(2))- 18)
//      else
//        cDesc   :=  alltrim(oRow:fieldGet(2))
//      endIf
//      nSocio  :=  oRow:fieldGet(1)
//      cConvenio := nombreConvenio(oRow:fieldGet(5))
//      cNombreSocio := nombreSocio(nSocio,"c")
//      if xposd > 250
//        
//        END PRINTPAGE
//        nPag := nPag + 1
//        Ypos      := PARAMETROini("RYpos","N")
//        Xpos      := PARAMETROini("RXpos","N")
//        va := 1
//        START PRINTPAGE
//        @ xPos , yPos          PRINT RECTANGLE TO (xPos + 10) , (yPos + 170) PENWIDTH 0.5 
//        @ xpos + 2, ypos + 2   PRINT data "Fecha: "+dtoc(Date())+" "
//        if copia = 1
//        @ xpos + 2, ypos + 50   PRINT data "**** COPIA DEL ORIGINAL ****"
//        endIf
//        
//        @ xpos + 2, ypos + 155 PRINT data "Página"
//        @ xpos + 5, ypos + 2   PRINT data "Hora:  "+Time()+" "
//        @ xpos + 5, ypos + 155 PRINT data " "+str(nPag)+" " BOLD                                
//        @ xpos + 10, ypos + 2  PRINT data "Caja Nro: "+cCaja+" Fecha: "+nFecha+" Cajero: "+cCajero+" Sucursal: "+cSucursal+" Turno: "+cTurno+"  " size fuente 
//        @ xPos + 15, yPos      PRINT LINE TO xPos + 15 , (yPos + 170) PENWIDTH 0.6
//        @ xpos + 16 , ypos + 2   PRINT data "Nro." size fuente
//        @ xpos + 16 , ypos + 16  PRINT data "Nombre Socio"
//        @ xpos + 16 , ypos + 75  PRINT data "Convenio " size fuente
//        @ xpos + 16 , ypos + 116 PRINT data "Mes " size fuente
//        @ xpos + 16 , ypos + 180 PRINT data "Importe" right size fuente
//        xPos := xPos + 18
//        xposd   :=  xpos +( va * esp)
//      endif
//        
//      @ xposd , ypos + 2    PRINT data nSocio size fuente
//      @ xposd , ypos + 16   PRINT data cNombreSocio size fuente
//      @ xposd , ypos + 75   PRINT data cConvenio size fuente
//      @ xposd , ypos + 116  PRINT data cDesc size fuente
//      @ xposd , ypos + 190  PRINT data nLinea right size fuente
//      
//      xposd := xposd + esp
// next
//if i = 1
//  xposd := xpos + 18
//endIf      
//xpos := xposd + (esp * 2)
//@ xpos , ypos             PRINT RECTANGLE to (xpos + 10), (ypos +170)  penwidth 0.5
//@ xpos + esp, ypos + 2    PRINT data "Total de Recibos"          size fuente
//@ xpos + esp, ypos + 140  PRINT data nTotRec   right  size fuente 
//
//END PRINTPAGE
//
//
//Ypos:= PARAMETROini("RYpos","N")
//Xpos:= PARAMETROini("RXpos","N")
//
//nPag := nPag + 1
//
//*cQuery := "select e.id_caja,e.descripcion,e.fecha, e.importe, e.id_caja_actual  "
//*cQuery := cQuery + " from entrada_salida e, caja c, turno t "
//*cQuery := cQuery + " where  e.id_caja_actual = c.id_caja and t.id= c.id_turno and e.id_traspaso is NULL "
//*cQuery := cQuery + " and e.id_caja_actual = "+cCaja+"  "
//
//cQuery := "select e.id_caja,e.descripcion,e.fecha, e.importe " 
//cQuery := cQuery + " from  entrada_salida e "
//cQuery := cQuery + " where    e.fecha < (select c.fecha_hora_cierre from caja c where  c.id_caja = "+cCaja+")"
//cQuery := cQuery + " and e.id_caja in (select c.id_caja from caja c, turno t,sucursal s "
//  cQuery := cQuery + " where c.id_turno = t.id and t.sucursal = s.id "
//  cQuery := cQuery + " and s.nombre ='"+cSucursal+"' )"
//cQuery := cQuery + " and e.id_traspaso not in(select t.id_traspaso from traspaso t where t.caja_origen <= "+cCaja+")"
//cQuery := cQuery + " union all "
//cQuery := cQuery + " select e.id_caja,e.descripcion,e.fecha, e.importe  "
//cQuery := cQuery + " from entrada_salida e "
//if copia != 1
//  cQuery := cQuery + " where  e.id_traspaso is NULL and e.fecha <= (select fecha_hora_cierre from caja where id_caja= "+cCaja+" ) "
//  cQuery := cQuery + " and e.id_caja in (select c.id_caja from caja c, turno t,sucursal s "
//  cQuery := cQuery + " where c.id_turno = t.id and t.sucursal = s.id "
//  cQuery := cQuery + " and s.nombre ='"+cSucursal+"' )"
//else
//  cQuery := cQuery + " where  e.id_traspaso is NULL  "
//  cQuery := cQuery + " and e.id_caja in (select c.id_caja from caja c, turno t,sucursal s "
//  cQuery := cQuery + " where c.id_turno = t.id and t.sucursal = s.id "
//  cQuery := cQuery + " and s.nombre ='"+cSucursal+"' )"
//endif  
//cQuery := cQuery + " order by 1 "
//
//oQuery := oServer:Query(cQuery)
//
//If oQuery:NetErr()
//  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
//  return .f.
//endIf
//nGastosAcum := 0
//
//
//START PRINTPAGE
//@ xPos , yPos           PRINT RECTANGLE TO (xPos + 10) , (yPos + 170) PENWIDTH 0.5 
//@ xpos + 2 , ypos + 2   PRINT data "Fecha: "+dtoc(Date())+" "
//if copia = 1
//@ xpos + 2, ypos + 50  PRINT data "**** COPIA DEL ORIGINAL ****"
//endIf
//@ xpos + 2 , ypos + 155 PRINT data "Página"
//@ xpos + 5 , ypos + 2   PRINT data "Hora:  "+Time()+" "
//@ xpos + 5 , ypos + 155 PRINT data " "+str(nPag)+" "  BOLD 
//@ xpos + 10, ypos + 2   PRINT data "Caja Nro: "+cCaja+" Fecha: "+nFecha+" Cajero: "+cCajero+" Sucursal: "+cSucursal+" Turno: "+cTurno+"  " size fuente 
//@ xPos + 15, yPos       PRINT LINE TO xPos + 15 , (yPos + 170) PENWIDTH 0.6
//xPos := xPos + 17
//paso := 0
// for i:=1 to oQuery:LastRec()
//      oRow      :=  oQuery:GetRow(i)
//      nImporte  :=  oRow:fieldGet(4)
//      dFecha    :=  oRow:fieldGet(3)
//      cDesc     :=  oRow:fieldGet(2)
//      nIdCaja   :=  oRow:fieldGet(1)
//           
//      if  nIdCaja = idCaja 
//        if paso = 0
//        
//          xposd   :=  xpos
//          @ xposd , ypos + 40  PRINT data "Total de Gastos Cajas Anteriores3"    size fuente
//          @ xposd , ypos + 190 PRINT data nGastosAcum right  size fuente
//          paso  := 1      
//          xposd := xposd + esp
//        endif    
//        @ xposd , ypos + 2   PRINT data nIdCaja   size fuente
//        @ xposd , ypos + 10  PRINT data substr(dFecha,1,10)   size fuente
//        @ xposd , ypos + 40  PRINT data cDesc    size fuente
//        @ xposd , ypos + 190 PRINT data nImporte  right   size fuente
//        xposd   := xposd + esp
//        nGastosAcum :=  nGastosAcum + nImporte
//      endIf
//      
//      if nIdCaja != idCaja 
//          nGastosAcum :=  nGastosAcum + nImporte
//          if  i = oQuery:LastRec() .and. paso = 0
//            xposd   :=  xpos
//            @ xposd , ypos + 40  PRINT data "Total de Gastos Cajas Anteriores1"    size fuente
//            @ xposd , ypos + 190 PRINT data nGastosAcum right  size fuente
//            paso := 1
//          endIf
//             
//      endif 
//      
// next      
//xpos := xposd + (esp * 2)
//
//@ xPos + esp, yPos + 85        PRINT RECTANGLE TO (xPos +(esp * 4) ) , (yPos + 145) PENWIDTH 0.5
//@ xpos + (esp * 2), ypos + 2   PRINT data "Cobro de Recibos:"  size fuente  
//@ xpos + (esp * 2), ypos + 140 PRINT data nTotRec  right    size fuente     
//@ xpos + (esp * 6), ypos + 2   PRINT data "Efectivo en Caja:"   size fuente    
//@ xpos + (esp * 6), ypos + 140 PRINT data nBaseCaja - nGastosAcum  right  size fuente
//@ xpos + (esp * 8), ypos + 2   PRINT data "Gastos Acumulados:" size fuente
//@ xpos + (esp * 8), ypos + 140 PRINT data nGastosAcum  right   size fuente
//@ xPos + (esp * 10), yPos + 85 PRINT RECTANGLE TO (xPos +(esp * 13) ), (yPos + 145) PENWIDTH 0.5
//@ xpos + (esp * 11), ypos + 2  PRINT data "Importe Fondo Fijo:" size fuente 
//@ xpos + (esp * 11), ypos +140 PRINT data nBaseCaja right   size fuente
//
//cReferencia := strtran(dtos(date()),"/","")+ alltrim(strtran(str(seconds()),".",""))+" "
//@ xpos + (esp * 14), ypos + 2 PRINT data "NUMERO DE REFERENCIA:"+cReferencia+" "   size 12 bold
//@ xpos + (esp * 14), ypos + 105 PRINT data "Número de Operador:..... Firma Operador:.................."   size fuente
//
//                              
//END PRINTPAGE
//Ypos:= PARAMETROini("RYpos","N")
//Xpos:= PARAMETROini("RXpos","N")
//
//nPag := nPag + 1
//
//cQuery := "select c.socio, d.descripcion, d.precio_unitario, d.cantidad "
//cQuery := cQuery + " from mov_cabezal c, mov_detalle d , servicio a"
//cQuery := cQuery + " where c.id_mov = d.id_mov and c.id_caja = "+cCaja+" and d.id_servicio = a.id_servicio and a.facturable = 0 "
//oQuery := oServer:Query(cQuery)
//
//If oQuery:NetErr()
//  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
//  return .f.
//endIf
//
//
//START PRINTPAGE
//@ xPos , yPos          PRINT RECTANGLE TO (xPos + 10) , (yPos + 170) PENWIDTH 0.5 
//@ xpos + 2, ypos + 2   PRINT data "Fecha: "+dtoc(Date())+" "
//if copia = 1
//@ xpos + 2, ypos + 50   PRINT data "**** COPIA DEL ORIGINAL ****"
//endIf
//@ xpos + 2, ypos + 155 PRINT data "Página"
//@ xpos + 5, ypos + 2   PRINT data "Hora:  "+Time()+" "
//@ xpos + 5, ypos + 155 PRINT data " "+str(nPag)+" "  BOLD                               
//@ xpos + 10, ypos + 2  PRINT data "Caja Nro: "+cCaja+" Fecha: "+nFecha+" Cajero: "+cCajero+" Sucursal: "+cSucursal+" Turno: "+cTurno+"  " size fuente
//@ xPos + 15, yPos      PRINT LINE TO xPos + 15 , (yPos + 170) PENWIDTH 0.6
//
// @ xpos + 16 , ypos + 2   PRINT data "Socio"        size fuente
// @ xpos + 16 , ypos + 20  PRINT data "Descripción"  size fuente
// @ xpos + 16 , ypos + 120 PRINT data "Imp. Unit."   right   size fuente
// @ xpos + 16 , ypos + 140 PRINT data "Cant."        right   size fuente
// @ xpos + 16 , ypos + 170 PRINT data "Importe"      right   size fuente
//
//
//
//xPos := xPos + 18
//
//nTotExt := 0
// for i:=1 to oQuery:LastRec()
//      oRow:= oQuery:GetRow(i)
//      nSocio    :=  oRow:fieldGet(1)
//      cDesc     :=  oRow:fieldGet(2)
//      nLinea  :=  oRow:fieldGet(3)
//      nCantidad :=  oRow:fieldGet(4)
//      nTotExt   :=  nTotExt + (nLinea * nCantidad)
//      xposd     :=  xpos +(i * esp)
//      @ xposd , ypos + 2   PRINT data nSocio   size fuente
//      @ xposd , ypos + 20  PRINT data cDesc    size fuente
//      @ xposd , ypos + 120 PRINT data nLinea     right   size fuente
//      @ xposd , ypos + 140 PRINT data nCantidad  right   size fuente
//      @ xposd , ypos + 170 PRINT data (nLinea * nCantidad)  right   size fuente
//                                                             
//      xposd := xposd + esp
// next      
//xpos := xposd + (esp * 2)
//
//nTotDep := nTotExt + nTotRec
//
//@ xpos + (esp * 1), ypos       PRINT RECTANGLE to (xpos +(esp * 4)), (ypos +170)  penwidth 0.5
//@ xpos + (esp * 2), ypos + 2   PRINT data "Total de Ingresos Extra 2 :" size fuente
//@ xpos + (esp * 2), ypos + 140 PRINT data nTotExt   right  size fuente 
//*@ xpos + (esp * 4), ypos + 2   PRINT data "Cobro de Recibos:"  size fuente  
//*@ xpos + (esp * 4), ypos + 140 PRINT data nTotRec  right    size fuente 
//@ xpos + (esp * 6), ypos       PRINT RECTANGLE to (xpos +(esp * 9)), (ypos +170)  penwidth 0.5
//@ xpos + (esp * 7), ypos + 2   PRINT data "Total del Turno 1.2 :"  size fuente  
//@ xpos + (esp * 7), ypos + 140 PRINT data nTotDep  right    size fuente
//
//cReferencia := strtran(dtos(date()),"/","")+alltrim(strtran(str(seconds()+ 0.01),".",""))+" "
//*strtran(time(),":","")
//@ xpos + (esp * 10), ypos + 2 PRINT data "NUMERO DE REFERENCIA:"+cReferencia+" "   size 12 bold
//@ xpos + (esp * 10), ypos + 105 PRINT data "Número de Op.:..... Firma Op.:.................."   size fuente
//
//END PRINTPAGE
//
//Ypos:= PARAMETROini("RYpos","N")
//Xpos:= PARAMETROini("RXpos","N")
//
//
//
//cQuery := "select co.fecha_proceso,co.total_cobranza, co.deposito_cobrador, co.observaciones,ca.nombre "
//cQuery := cQuery + " from cobranza_cobradores co, caja c, mov_cabezal m, cajero ca "
//cQuery := cQuery + " where c.id_caja = m.id_caja and c.id_caja = "+cCaja+"  "
//cQuery := cQuery + " and m.id_mov = co.id_mov "
//cQuery := cQuery + " and ca.id_cajero = m.id_cajero "
//cQuery := cQuery + " order by 5 "
//oQuery := oServer:Query(cQuery)
//
//If oQuery:NetErr()
//  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
//  return .f.
//endIf
//
//if oQuery:LastRec() > 0
//	nPag := nPag + 1
//	START PRINTPAGE
//	@ xPos , yPos          PRINT RECTANGLE TO (xPos + 10) , (yPos + 170) PENWIDTH 0.5 
//	@ xpos + 2, ypos + 2   PRINT data "Fecha: "+dtoc(Date())+" "
//	if copia = 1
//	@ xpos + 2, ypos + 50   PRINT data "**** COPIA DEL ORIGINAL ****"
//	endIf
//	@ xpos + 2, ypos + 155 PRINT data "Página"
//	@ xpos + 5, ypos + 2   PRINT data "Hora:  "+Time()+" "
//	@ xpos + 5, ypos + 155 PRINT data " "+str(nPag)+" "  BOLD                               
//	@ xpos + 10, ypos + 2  PRINT data "Caja Nro: "+cCaja+" Fecha: "+nFecha+" Cajero: "+cCajero+" Sucursal: "+cSucursal+" Turno: "+cTurno+"  " size fuente
//	@ xPos + 15, yPos      PRINT LINE TO xPos + 15 , (yPos + 170) PENWIDTH 0.6
//	
//	 @ xpos + 16 , ypos + 2   PRINT data "Fec.Cobranza"        size fuente
//	 @ xpos + 16 , ypos + 32  PRINT data "Cobrador "  size fuente
//	 @ xpos + 16 , ypos + 110 PRINT data "Dep.Cobrador"   right   size fuente
//	 @ xpos + 16 , ypos + 140 PRINT data "Imp.Procesado"        right   size fuente
//	 @ xpos + 16 , ypos + 170 PRINT data "Diferencia"      right   size fuente
//	
//	
//	
//	xPos := xPos + 18
//	
//	nTotExt := 0
//	 for i:=1 to oQuery:LastRec()
//	      oRow:= oQuery:GetRow(i)
//	      nDiferencia :=  oRow:fieldGet(3) - oRow:fieldGet(2)
//	      xposd     :=  xpos +(i * esp)
//	      @ xposd , ypos + 2   PRINT data oRow:fieldGet(1) size fuente
//	      @ xposd , ypos + 32  PRINT data oRow:fieldGet(5) size fuente
//	      @ xposd , ypos + 110 PRINT data oRow:fieldGet(3) right size fuente
//	      @ xposd , ypos + 140 PRINT data oRow:fieldGet(2) right size fuente
//	      @ xposd , ypos + 170 PRINT data nDiferencia  		 right size fuente
//	                                                             
//	      xposd := xposd + esp
//	 next      
//	xpos := xposd + (esp * 2)
//	
//	nTotDep := nTotExt + nTotRec
//	
//	
//	cReferencia := strtran(dtos(date()),"/","")+alltrim(strtran(str(seconds()+ 0.01),".",""))+" "
//	*strtran(time(),":","")
//	@ xpos + (esp * 10), ypos + 2 PRINT data "NUMERO DE REFERENCIA:"+cReferencia+" "   size 12 bold
//	@ xpos + (esp * 10), ypos + 105 PRINT data "Número de Op.:..... Firma Op.:.................."   size fuente
//	
//	END PRINTPAGE
//endif
//
//
//
//	
//END PRINTDOC
//
//
//return .t.


function idSucursal(cSucursal)
local oQuery
local cQuery

cQuery := "select id  from sucursal where nombre = '"+cSucursal+"' "
oQuery := oServer:Query(cQuery)
If oQuery:NetErr()
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  return .f.
endIf
return oQuery:getRow(1):fieldGet(1)

function baseCaja(nSucursal)

local oQuery
local cQuery

cQuery := "select inicio_caja  from sucursal where id = "+str(nSucursal)+" "
oQuery := oServer:Query(cQuery)
If oQuery:NetErr()
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  return .f.
endIf
return oQuery:getRow(1):fieldGet(1)

