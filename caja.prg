#include <hmg.ch>

procedure inicioCaja()

if !cajaAbierta()
	load window caja
	caja.center
	caja.activate
else
	msgInfo("La caja ya está Abierta")
endif

procedure iniciarCaja()

if caja.text_1.value != 0
	if msgYesNo("Inicia la Caja ?","ATENCIÓN",.f.)
			if !iniciaCaja(caja.datePicker_1.value, caja.text_1.value)
				msgInfo("No se pudo iniciar la Caja")
			else
				msgInfo("Caja Abierta, Puede empezar a trabajar")
				caja.release
			endif
	endif
else
	msginfo("Debe Ingresar un Valor")
	caja.text_1.setfocus
endif

procedure cerrarCaja()
local nCaja := cajaId()
if cajaAbierta()
	if msgYesNo("Cierra la caja"+chr(13)+"No. "+str(cajaId()),"ATENCIÓN",.f.)
		if cierraCaja(nCaja)
			imprimoCierre(nCaja)
		else
			msgInfo("No se pudo cerrar la Caja")
		endif
	endif
	
else
	msgInfo("Caja Cerrada !!!")
endif

procedure imprimoCierre(nCaja)
Ypos      := PARAMETROini("RYpos","N")
Xpos      := PARAMETROini("RXpos","N")
fuente    := PARAMETROini("FuenteInforme","N")
esp       := PARAMETROini("Espacio","N")



nPag := 1


	SELECT PRINTER  dialog  preview


start printdoc
START PRINTPAGE
@ xPos , yPos          PRINT RECTANGLE TO (xPos + 10) , (yPos + 190) PENWIDTH 0.5 
@ xpos + 2, ypos + 2   PRINT data "Fecha: "+dtoc(Date())+" "
@ xpos + 2, ypos + 155 PRINT data "Página"
@ xpos + 5, ypos + 2   PRINT data "Hora:  "+Time()
//@ xpos + 5, ypos + 47  PRINT data "  Cliente Nro. "+alltrim(str(nCliente))+" - "+alltrim(cCliente) bold
@ xpos + 5, ypos + 155 PRINT data " "+str(nPag)+" " BOLD                                
@ xpos + 10, ypos + 2  PRINT data "Resumen de Caja : "+str(nCaja);
	+" de Fecha "+dtoc(fechacaja(nCaja)) size fuente BOLD
@ xPos + 15, yPos      PRINT LINE TO xPos + 15 , (yPos + 190) PENWIDTH 0.6	

@ xpos + 16 , ypos + 42   PRINT data "Importe Inicial: $ "  size fuente 
@ xpos + 16 , ypos + 92   PRINT data importeInicial(nCaja) size fuente right BOLD
@ xpos + 19 , ypos + 42   PRINT data "Importe Contado: $ "  size fuente 
@ xpos + 19 , ypos + 92   PRINT data totalFacturaCaja('C',nCaja) size fuente right BOLD
@ xpos + 22 , ypos + 42   PRINT data "Importe Recibos: $ "  size fuente 
@ xpos + 22 , ypos + 92   PRINT data totalReciboCaja('R',nCaja) size fuente right BOLD
@ xpos + 25 , ypos + 42   PRINT data "Importe Salidas: $ " size fuente
@ xpos + 25 , ypos + 92   PRINT data str(totalSalidaCaja(nCaja)) size fuente right BOLD
@ xPos + 29 , yPos + 40   PRINT RECTANGLE TO (xPos + 37) , (yPos + 97) PENWIDTH 0.5 
@ xpos + 31 , ypos + 42   PRINT data "Saldo en Caja : $ "
@ xpos + 31 , ypos + 92   PRINT data str(importeInicial(nCaja)+totalFacturaCaja('C',nCaja)+totalReciboCaja('R',nCaja)-totalSalidaCaja(nCaja)) size fuente right BOLD

//@ xpos + 19 , ypos + 2   PRINT data "Nro.Doc" size fuente
//@ xpos + 19 , ypos + 20  PRINT data "Fecha"
//@ xpos + 19 , ypos + 47  PRINT data "Tipo Documento " size fuente
//@ xpos + 19 , ypos + 150 PRINT data "Debe "  right size fuente
//@ xpos + 19 , ypos + 170 PRINT data "Haber " right size fuente
//@ xpos + 19 , ypos + 190 PRINT data "Saldo " right size fuente

//for i= nLargoArray to 1 step -1
//	@ xpos + 23 + l , ypos + 2   PRINT data aGrid[i,1] size fuente
//	@ xpos + 23 + l , ypos + 20  PRINT data aGrid[i,2]
//	@ xpos + 23 + l , ypos + 47  PRINT data aGrid[i,3] size fuente
//	@ xpos + 23 + l , ypos + 150 PRINT data aGrid[i,4] right size fuente
//	@ xpos + 23 + l , ypos + 170 PRINT data aGrid[i,5] right size fuente
//	@ xpos + 23 + l , ypos + 190 PRINT data aGrid[i,6] right size fuente
//	l+= 3
//next

END PRINTPAGE
END PRINTDOC






*************************************************
*************************************************
******Implementaciones del modelo ***************
*************************************************
*************************************************
function iniciaCaja(dFecha,nImporte)
local oQuery, cQuery

cQuery := "insert into caja "
cQuery += " values ( null, '"+dtos(dFecha)+"', "+str(nImporte)+", 0,null) "

oQuery := oServer:Query( cQuery )
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
  return .f.
else
	return .t.
endIf

function importeInicial(nCaja)
local cQuery,oQuery

cQuery := "Select importe_incial from  caja  where id_caja="+str(nCaja)+" "

oQuery:= oServer:Query(  cQuery )
If oQuery:NetErr() 
    MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
else
	return oQuery:GetRow(1):fieldGet(1)
endIf



function cierraCaja(nIdCaja)
local oQuery, cQuery

cQuery := " update caja set fecha_hora_cierre = current_timestamp, "
cQuery += " abierta = 1 "
cQuery += " where id_caja = "+str(nIdCaja)+""


oQuery := oServer:Query( cQuery )
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
  return .f.
else
	return .t.
endIf

function cajaId()

local oQuery
local oRow

oQuery := oServer:Query( "Select id_caja From caja where  abierta=0" )
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
  quit
endIf

return oQuery:GetRow(1):fieldGet(1)

function cajaAbierta()
local cCajero
local oQuery
local oRow

cQuery := "Select id_caja From caja "
cQuery := cQuery +"where abierta=0"
oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
endIf

if oQuery:LastRec() >0
  return .t.
else
  return .f.
endif


function fechaCaja(cajaId)
local oQuery , cQuery

cQuery := "Select fecha_hora from  caja  where id_caja="+str(cajaId)+" "
oQuery:= oServer:Query(  cQuery )
  If oQuery:NetErr() 
    MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
    quit
  Endif

return oQuery:GetRow(1):fieldGet(1)


