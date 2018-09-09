#include <hmg.ch>
procedure reporteEntreFechas(cTitulo)
		Load Window reporteEntreFechas
		reporteEntreFechas.frame_1.caption := cTitulo
	  reporteEntreFechas.Center
	  reporteEntreFechas.Activate

return

function recibosCobradosDeCobradores(dfechaDesde,dFechaHasta)

local Ypos      := PARAMETROini("RYpos","N")
local Xpos      := PARAMETROini("RXpos","N")
local fuente    := PARAMETROini("FuenteInforme","N")
local esp       := PARAMETROini("Espacio","N")
local nCobrador
local nCobradorAnt
local cCobrador 

cQuery :=  "SELECT c.id_cuota, c.id_socio, c.anio_mes,c.id_cobrador " 
cQuery := cQuery + " FROM cuota_cab c, mov_cabezal mc, mov_detalle md "
cQuery := cQuery + " where c.id_cobrador = 2 "
cQuery := cQuery + " and mc.id_mov = md.id_mov "
cQuery := cQuery + " and md.id_cuota = c.id_cuota"
cQuery := cQuery + " and mc.id_cajero != 16 "
cQuery := cQuery + " and mc.anulado ='N' "
cQuery := cQuery + " and c.pago = 'S' "
cQuery := cQuery + " and mc.fecha between '"+dtos(dfechaDesde)+"' and '"+dtos(dFechaHasta)+"' "
cQuery := cQuery + " union all "
cQuery := cQuery + "SELECT c.id_cuota, c.id_socio, c.anio_mes ,c.id_cobrador" 
cQuery := cQuery + " FROM cuota_cab c, mov_cabezal mc, mov_detalle md "
cQuery := cQuery + " where c.id_cobrador = 3 "
cQuery := cQuery + " and mc.id_mov = md.id_mov "
cQuery := cQuery + " and md.id_cuota = c.id_cuota"
cQuery := cQuery + " and mc.id_cajero != 17 "
cQuery := cQuery + " and mc.anulado ='N' "
cQuery := cQuery + " and c.pago = 'S' "
cQuery := cQuery + " and mc.fecha between '"+dtos(dfechaDesde)+"' and '"+dtos(dFechaHasta)+"'  "
cQuery := cQuery + " union all "
cQuery := cQuery + "SELECT c.id_cuota, c.id_socio, c.anio_mes,c.id_cobrador" 
cQuery := cQuery + " FROM cuota_cab c, mov_cabezal mc, mov_detalle md "
cQuery := cQuery + " where c.id_cobrador = 1 "
cQuery := cQuery + " and mc.id_mov = md.id_mov "
cQuery := cQuery + " and md.id_cuota = c.id_cuota"
cQuery := cQuery + " and mc.id_cajero != 18 "
cQuery := cQuery + " and mc.anulado ='N' "
cQuery := cQuery + " and c.pago = 'S' "
cQuery := cQuery + " and mc.fecha between '"+dtos(dfechaDesde)+"' and '"+dtos(dFechaHasta)+"' "

oQuery := oServer:Query(cQuery)

If oQuery:NetErr()
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  return .f.
endIf	

if oQuery:LastRec() > 0
  SELECT PRINTER  'Informes' PAPERSIZE PRINTER_PAPER_FANFOLD_STD_GERMAN preview
	start PRINTDOC
	START PRINTPAGE
	nPag := 1
	nCobradorAnt := oQuery:GetRow(1):fieldGet(4)

	cCobrador := nombreCobrador(oQuery:GetRow(1):fieldGet(4))
	@ xPos , yPos          PRINT RECTANGLE TO (xPos + 10) , (yPos + 170) PENWIDTH 0.5 
@ xpos + 2, ypos + 2   PRINT data "Fecha: "+dtoc(Date())+" "
@ xpos + 2, ypos + 155 PRINT data "Página"
@ xpos + 5, ypos + 2   PRINT data "Hora:  "+Time()+" "
@ xpos + 5, ypos + 155 PRINT data " "+str(nPag)+" " BOLD                                
@ xpos + 10, ypos + 2  PRINT data "Recibos Emitidos para el Cobrador: "+cCobrador+"  " size fuente 
@ xPos + 15, yPos      PRINT LINE TO xPos + 15 , (yPos + 170) PENWIDTH 0.6
	xPos := xPos + 18
	va := 1
	
	for i:=1 to oQuery:LastRec()
	      va := va + 1
	      oRow:= oQuery:GetRow(i)
	      nCobrador := oQuery:GetRow(i):fieldGet(4)
	      xposd     :=  xpos +(va * esp)
	      if xposd > 230
	       
	        END PRINTPAGE
	        nPag := nPag + 1
	        Ypos      := PARAMETROini("RYpos","N")
	        Xpos      := PARAMETROini("RXpos","N")
	        va := 1
	        START PRINTPAGE
	        @ xPos , yPos          PRINT RECTANGLE TO (xPos + 10) , (yPos + 170) PENWIDTH 0.5 
					@ xpos + 2, ypos + 2   PRINT data "Fecha: "+dtoc(Date())+" "
					@ xpos + 2, ypos + 155 PRINT data "Página"
					@ xpos + 5, ypos + 2   PRINT data "Hora:  "+Time()+" "
					@ xpos + 5, ypos + 155 PRINT data " "+str(nPag)+" " BOLD                                
					@ xpos + 10, ypos + 2  PRINT data "Recibos Emitidos para el Cobrador: "+cCobrador+"  " size fuente 
					@ xPos + 15, yPos      PRINT LINE TO xPos + 15 , (yPos + 170) PENWIDTH 0.6
					xPos := xPos + 18
	        xposd :=  xpos +( va * esp)
	        
	    	endif
	    	if nCobrador != nCobradorAnt
		    	nCobradorAnt := oQuery:GetRow(i):fieldGet(4)
					cCobrador := nombreCobrador(oQuery:GetRow(i):fieldGet(4))
				  if i = 1
	  				xposd := xpos + 18
					endIf 
			    
			    END PRINTPAGE
		        nPag := nPag + 1
		        Ypos      := PARAMETROini("RYpos","N")
		        Xpos      := PARAMETROini("RXpos","N")
		        va := 1
		        start PRINTPAGE
		        @ xPos , yPos          PRINT RECTANGLE TO (xPos + 10) , (yPos + 170) PENWIDTH 0.5 
						@ xpos + 2, ypos + 2   PRINT data "Fecha: "+dtoc(Date())+" "
						@ xpos + 2, ypos + 155 PRINT data "Página"
						@ xpos + 5, ypos + 2   PRINT data "Hora:  "+Time()+" "
						@ xpos + 5, ypos + 155 PRINT data " "+str(nPag)+" " BOLD                                
						@ xpos + 10, ypos + 2  PRINT data "Recibos Emitidos para el Cobrador: "+cCobrador+"  " size fuente 
						@ xPos + 15, yPos      PRINT LINE TO xPos + 15 , (yPos + 170) PENWIDTH 0.6
						xPos := xPos + 18
		        xposd :=  xpos +( va * esp)
			    endIf
	      @ xposd , ypos + 2   PRINT data oRow:fieldGet(1) size fuente
	      @ xposd , ypos + 32  PRINT data oRow:fieldGet(2) size fuente
	      @ xposd , ypos + 110 PRINT data oRow:fieldGet(3) right size fuente
	      @ xposd , ypos + 140 PRINT data oRow:fieldGet(4) right size fuente
	      //@ xposd , ypos + 170 PRINT data nDiferencia  		 right size fuente
	      xposd := xposd + esp
	 next      
	
	end PRINTPAGE
	end PRINTDOC
endIf

