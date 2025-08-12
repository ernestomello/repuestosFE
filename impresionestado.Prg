#include <hmg.ch>

procedure imprimeEstadosCuenta()

	load window impresionEstado
	rellenoDatosImpresion()
	impresionEstado.center
	impresionEstado.activate

return

procedure rellenoDatosImpresion()

impresionEstado.text_1.value := numeroPrimerCliente()
impresionEstado.text_2.value := numeroUltimocliente()
impresionEstado.datePicker_1.value := date() - 30
impresionEstado.datePicker_3.value := date() - 365

return

procedure listaEstados()
//local oClientes := clientes(impresionEstado.spinner_1.value, impresionEstado.spinner_2.value)
local oDocumentos, nSaldoAnterior, nSaldoActual
local dFechaDesde := impresionEstado.datePicker_1.value - 1
local dFechaHasta := impresionEstado.datePicker_2.value
local nPrevio := impresionEstado.radioGroup_1.value
local nSaldoMenor := impresionEstado.text_3.value

if nPrevio = 3
	info_("Esta funcion no esta implementada, Consulte al Desarrollador",.t.)
	WAIT CLEAR
	return .f.
endif

	for i= impresionEstado.text_1.value to impresionEstado.text_2.value
		 
		if fechaUltimoMovimientoCliente(i) > impresionEstado.datePicker_3.value 
			if nPrevio != 3
				imprimeEstadoCuentaCliente(i,dFechaDesde,dFechaHasta,nPrevio,0,nSaldoMenor)
			endif 
		endif
	next
	
return .t.

procedure imprimoEstadoCuenta(nCliente,oDocumentos,nSaldoAnterior,dFechaDesde,nSaldoActual,dFechaHasta, nPrevio,cTituloPrincipal)
local cCliente := nombreCliente(nCliente)
local c,nTotDocumentoSaldo := 0
local aGrid:= {}
local nSaldoAnteriorFijo := nSaldoAnterior
local i := 0
local l := 3
local nInicioLinea := 0

Ypos      := PARAMETROini("RYpos","N")
Xpos      := PARAMETROini("RXpos","N")
fuente    := PARAMETROini("FuenteInforme","N")
esp       := PARAMETROini("Espacio","N")

for i = 1 to oDocumentos:lastrec()
	nDebe :=  iif(oDocumentos:getrow(i):fieldget(5) = 101 .or. oDocumentos:getrow(i):fieldget(5) = 111 ,oDocumentos:getrow(i):fieldget(4),0 )
	nHaber := iif(oDocumentos:getrow(i):fieldget(5) = 102 .or. oDocumentos:getrow(i):fieldget(5) = 112 .or. oDocumentos:getrow(i):fieldget(5) = 98,oDocumentos:getrow(i):fieldget(4),0 )
	nSaldoAnterior := nSaldoAnterior + nDebe - nHaber
	
	// nSaldoAnterior := nSaldoAnterior + oDocumentos:getrow(i):fieldget(4) -oDocumentos:getrow(i):fieldget(5)
	cDescripcion := alltrim(oDocumentos:getrow(i):fieldget(3))+" "+alltrim(oDocumentos:getrow(i):fieldget(7))+"-"+str(oDocumentos:getrow(i):fieldget(8))
	
	if oDocumentos:getrow(i):fieldget(6) != 0
		cDescripcion :=cDescripcion +" - $ " + alltrim(str(oDocumentos:getrow(i):fieldget(6)))
	// else
		// cDescripcion := alltrim(oDocumentos:getrow(i):fieldget(3))
	endIf
	
	aadd(aGrid,{	oDocumentos:getrow(i):fieldget(1), ;
								dtoc(oDocumentos:getrow(i):fieldget(2)), ; 
								cDescripcion, ;
								nDebe, ;
								nHaber, ;								
								nSaldoAnterior })
								// oDocumentos:getrow(i):fieldget(4), ;
								// oDocumentos:getrow(i):fieldget(5), ;
	nTotDocumentoSaldo += oDocumentos:getrow(i):fieldget(6)
next

nLargoArray := len(aGrid)
nPag := 1

do case
case nPrevio = 1
	SELECT PRINTER  DEFAULT  PAPERSIZE PRINTER_PAPER_A4 ORIENTATION PRINTER_ORIENT_PORTRAIT 
case nPrevio = 2
	SELECT PRINTER  dialog  preview  
// case nPrevio = 3
	// SELECT PRINTER  DEFAULT SAVEAS 'C:\estadoCuenta.PDF'
endcase


start printdoc
START PRINTPAGE

@ xpos + 2, ypos + 2   PRINT data "Fecha: "+dtoc(Date())+" " size fuente
@ xpos + 2, ypos + 80  PRINT data cTituloPrincipal SIZE fuente bold
@ xpos + 2, ypos + 190 PRINT data "Pagina" right size fuente
@ xpos + 5, ypos + 2   PRINT data "Hora:  "+Time() size fuente
@ xpos + 5, ypos + 190 PRINT data str(nPag) right size fuente
@ xPos + 10, yPos      PRINT LINE TO xPos + 10 , (yPos + 190) PENWIDTH 0.5                               

@ xPos + 15 , yPos + 50 PRINT RECTANGLE TO (xPos + 24) , (yPos + 140) PENWIDTH 0.7 
@ xpos + 16 , ypos + 60 PRINT data cTituloPrincipal SIZE 18 bold 
@ xpos + 28 , ypos + 60 PRINT data " Cliente: "+alltrim(str(ncliente))+' - '+alltrim(nombreCliente(nCliente)) SIZE fuente
@ xpos + 33 , ypos + 60 PRINT data " Direcc.: "+alltrim(dirParticularCliente(nCliente))+" Tel :"+alltrim(telefonoCliente(nCliente)) SIZE fuente
@ xpos + 38 , ypos + 60 PRINT data " R.U.T  : "+alltrim(rutCliente(nCliente)) SIZE fuente

if cTituloPrincipal = "ESTADO CUENTA"
@ xpos + 48 , ypos + 2   PRINT data "Saldo al  : "+dtoc(dFechaHasta);
	+" $ "+str(nSaldoActual) size fuente BOLD
endif
nInicioLinea := 58
@ xpos + nInicioLinea , ypos + 2   PRINT data "Nro.Doc" size fuente
@ xpos + nInicioLinea , ypos + 20  PRINT data "Fecha" size fuente
@ xpos + nInicioLinea , ypos + 47  PRINT data "Tipo Documento " size fuente
if cTituloPrincipal = "ESTADO CUENTA"
	@ xpos + nInicioLinea , ypos + 150 PRINT data "Debe "  right size fuente
	@ xpos + nInicioLinea , ypos + 170 PRINT data "Haber " right size fuente
	@ xpos + nInicioLinea , ypos + 190 PRINT data "Saldo " right size fuente
endif

nInicioLinea := 65
for i= nLargoArray to 1 step -1
	
	if xpos + nInicioLinea + l > 250
		END PRINTPAGE
		start PRINTPAGE
		nPag ++
		@ xpos + 2, ypos + 2   PRINT data "Fecha: "+dtoc(Date())+" " size fuente
		@ xpos + 2, ypos + 80  PRINT data " Morales Repuestos " SIZE fuente bold
		@ xpos + 2, ypos + 190 PRINT data "Pagina" right size fuente
		@ xpos + 5, ypos + 2   PRINT data "Hora:  "+Time() size fuente
		@ xpos + 5, ypos + 190 PRINT data str(nPag) right size fuente
		@ xPos + 10, yPos      PRINT LINE TO xPos + 10 , (yPos + 190) PENWIDTH 0.5       
		nInicioLinea := 15
		@ xpos + nInicioLinea , ypos + 2   PRINT data "Nro.Doc" size fuente
		@ xpos + nInicioLinea , ypos + 20  PRINT data "Fecha" size fuente
		@ xpos + nInicioLinea , ypos + 47  PRINT data "Tipo Documento " size fuente
		if cTituloPrincipal = "ESTADO CUENTA"
			@ xpos + nInicioLinea , ypos + 150 PRINT data "Debe "  right size fuente
			@ xpos + nInicioLinea , ypos + 170 PRINT data "Haber " right size fuente
			@ xpos + nInicioLinea , ypos + 190 PRINT data "Saldo " right size fuente     
		endif
		l := 7
	endIf
	@ xpos + nInicioLinea + l , ypos + 2   PRINT data aGrid[i,1] size fuente
	@ xpos + nInicioLinea + l , ypos + 20  PRINT data aGrid[i,2] size fuente
	@ xpos + nInicioLinea + l , ypos + 47  PRINT data aGrid[i,3] size fuente
	if cTituloPrincipal = "ESTADO CUENTA"
		@ xpos + nInicioLinea + l , ypos + 150 PRINT data iif( aGrid[i,4] != 0, aGrid[i,4],'') right size fuente
		@ xpos + nInicioLinea + l , ypos + 170 PRINT data iif( aGrid[i,5] != 0, aGrid[i,5],'') right size fuente
		@ xpos + nInicioLinea + l , ypos + 190 PRINT data  aGrid[i,6]  right size fuente
	endif
	l+= esp
	
next
nInicioLinea := nInicioLinea + 5
if cTituloPrincipal = "ESTADO CUENTA"
	@ xpos + nInicioLinea + l , ypos + 2   PRINT data "Saldo al : "+dtoc(dFechaDesde)+" $ "+;
	 str(nSaldoAnteriorFijo) size fuente BOLD
else
	@ xpos + nInicioLinea + l , ypos + 2   PRINT data "Total Documentos con Saldo :$ "+str(nTotDocumentoSaldo)  size fuente BOLD
endif

END PRINTPAGE
END PRINTDOC






procedure listoSaldosAnteriores()
local nUltimoCliente:= numeroUltimocliente()
local oClienteNumero := clientes(2)
local dMesUno := dUltimoDiaMes(date()- 30 )
local dMesDos := dUltimoDiaMes(date() - 60)
local dMesTres := dUltimoDiaMes(date() - 90)
local dMesCuatro := dUltimoDiaMes(date() -120)
local nPag := 1
local l := 3

Ypos      := PARAMETROini("RYpos","N")
Xpos      := PARAMETROini("RXpos","N")
fuente    := PARAMETROini("FuenteInforme","N")
esp       := PARAMETROini("Espacio","N")

SELECT PRINTER  dialog  preview
info_("Buscando en la Base de Datos ...")
start printdoc
START PRINTPAGE

@ xpos + 2, ypos + 2   PRINT data "Fecha: "+dtoc(Date())+" "
@ xpos + 2, ypos + 80  PRINT data " Morales Repuestos " SIZE fuente bold
@ xpos + 2, ypos + 190 PRINT data "P�gina" right size fuente
@ xpos + 5, ypos + 2   PRINT data "Hora:  "+Time()
@ xpos + 5, ypos + 190 PRINT data str(nPag) right size fuente
@ xPos + 10, yPos      PRINT LINE TO xPos + 10 , (yPos + 190) PENWIDTH 0.5        

@ xpos + 15 , ypos + 2   PRINT data "Nro." size fuente
@ xpos + 15 , ypos + 20  PRINT data "Nombre "
@ xpos + 15 , ypos + 124 PRINT data dMesCuatro right size fuente
@ xpos + 15 , ypos + 146 PRINT data dMesTres  right size fuente
@ xpos + 15 , ypos + 168 PRINT data dMesDos right size fuente
@ xpos + 15 , ypos + 190 PRINT data dMesUno right size fuente

for i= 1 to oClienteNumero:lastRec()
	ultimoMes := saldoFacturas(oClienteNumero:getrow(i):fieldget(1),dMesUno)
if 	ultimoMes != 0
	info_("Cliente Nro: "+str(oClienteNumero:getrow(i):fieldget(1))+" ...")
	@ xpos + 20 + l , ypos + 2   PRINT data oClienteNumero:getrow(i):fieldget(1) size fuente
	@ xpos + 20 + l , ypos + 20  PRINT data oClienteNumero:getrow(i):fieldget(2) size fuente
	@ xpos + 20 + l , ypos + 124  PRINT data saldoFacturas(oClienteNumero:getrow(i):fieldget(1),dMesCuatro) right size fuente
	@ xpos + 20 + l , ypos + 146 PRINT data saldoFacturas(oClienteNumero:getrow(i):fieldget(1),dMesTres) right size fuente
	@ xpos + 20 + l , ypos + 168 PRINT data saldoFacturas(oClienteNumero:getrow(i):fieldget(1),dMesDos) right size fuente
	@ xpos + 20 + l , ypos + 190 PRINT data ultimoMes right size fuente
	l+= esp
	if xPos + 20 + l > 250
		END PRINTPAGE
		start PRINTPAGE
		nPag ++
		@ xpos + 2, ypos + 2   PRINT data "Fecha: "+dtoc(Date())+" "
		@ xpos + 2, ypos + 80  PRINT data " Morales Repuestos " SIZE fuente bold
		@ xpos + 2, ypos + 190 PRINT data "P�gina" right size fuente
		@ xpos + 5, ypos + 2   PRINT data "Hora:  "+Time()
		@ xpos + 5, ypos + 190 PRINT data str(nPag) right size fuente
		@ xPos + 10, yPos      PRINT LINE TO xPos + 10 , (yPos + 190) PENWIDTH 0.5        
		
		@ xpos + 15 , ypos + 2   PRINT data "Nro." size fuente
		@ xpos + 15 , ypos + 20  PRINT data "Nombre "
		@ xpos + 15 , ypos + 124  PRINT data dMesCuatro right size fuente
		@ xpos + 15 , ypos + 146 PRINT data dMesTres  right size fuente
		@ xpos + 15 , ypos + 168 PRINT data dMesDos right size fuente
		@ xpos + 15 , ypos + 190 PRINT data dMesUno right size fuente
		l := 3
		
	endIf

endif

next

WAIT CLEAR


END PRINTPAGE
END PRINTDOC

***************************************
* Para determinar el �ltimo d�a del mes pasando una fecha de referencia
*
***************************************
function dUltimoDiaMes(dFecha)

oQuery := oServer:Query(" select last_day('"+dtos(dFecha)+"') ")
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf