#include <hmg.ch>

procedure estadoCuentaClientes()

load window estadoCuenta
DEFINE CONTROL CONTEXTMENU grid_1 of estadoCuenta
		MENUITEM "Ver Documento-Imprimir"  ONCLICK verFacturaEstado()
		MENUITEM "Ver Documento"  ONCLICK muestroDocumentoEstado()
		MENUITEM "Anula Seg�n Documento"  ONCLICK notaCreditoDebitoEstado()
	END MENU
estadoCuenta.datePicker_1.value := date() - 30
estadoCuenta.center
estadoCuenta.activate

function verFacturaEstado()

cTipoDocumento := tipoDocumento(estadocuenta.grid_1.cell(estadocuenta.grid_1.value,1))

if cTipoDocumento != 81 .and. cTipoDocumento != 91 .and. cTipoDocumento != 98
	verFacturaPDF(estadocuenta.grid_1.cell(estadocuenta.grid_1.value,1))
else
	imprimoMovimiento(estadocuenta.grid_1.cell(estadocuenta.grid_1.value,1),1,'','','') //mando imprimir ese movimiento con el idMov
endif
	


//verFacturaPDF(estadocuenta.grid_1.cell(estadocuenta.grid_1.value,1)) 
rellenoGridCliente()
return

function muestroDocumentoEstado()
muestroDocumentoCliente(estadocuenta.grid_1.cell(estadocuenta.grid_1.value,1))
rellenoGridCliente()
return
function notaCreditoDebitoEstado()
anuloMovimientos(estadocuenta.grid_1.cell(estadocuenta.grid_1.value,1))
rellenoGridCliente()
return


procedure buscoClienteEstadoCuenta()
local nCliente := estadoCuenta.text_1.value
vacioDatosEstadoCuentaCliente()

	
	  if existeCliente(nCliente)
		    estadoCuenta.text_1.value := nCliente
		    estadoCuenta.text_2.value := nombreCliente(nCliente)
		    estadoCuenta.text_6.value := dirParticularCliente(nCliente)+' - '+alltrim(telefonoCliente(nCliente))
		    nSocioGlobal := 0
		    rellenoGridCliente()
	  else
	    
	      busquedaGeneral('cc','','Clientes',1)
	    
	       
		      if nSocioGlobal != 0
		        	estadoCuenta.text_1.value := nSocioGlobal
		    			estadoCuenta.text_2.value := nombreCliente(nSocioGlobal)
		    			estadoCuenta.text_6.value := dirParticularCliente(nSocioGlobal)
		        	nSocioGlobal := 0
		        	rellenoGridcliente()
		      endIf
	  endif
	
return



procedure vacioDatosEstadoCuentaCliente()
estadoCuenta.text_3.value := ''
estadoCuenta.text_4.value := ''
estadoCuenta.grid_1.deleteAllItems


/* Tengo que hacer cambios para que sirva para clientes y proveedores 
Agregar un saldo en cada l�nea y el saldo de la Factura.
*/
procedure rellenoGridCliente()
local oDocumentos, nSaldoAnterior, nSaldoActual
local dFechaHasta := estadoCuenta.datePicker_1.value - 1
local nHaber:= 0,nDebe := 0
//local cOpcion := estadoCuenta.text_5.value
local aGrid:= {}
estadoCuenta.text_5.value := 0
WAIT WINDOW "Procesando Informaci�n - AGUARDE" NOWAIT 
	oDocumentos := documentosCliente(estadoCuenta.text_1.value,estadoCuenta.datePicker_1.value,estadoCuenta.datePicker_2.value )
	nSaldoActual := saldoEntreFechasCliente(estadoCuenta.text_1.value,ctod("01/01/1980"),estadoCuenta.datePicker_2.value)
	nSaldoAnterior := saldoEntreFechasCliente(estadoCuenta.text_1.value,ctod("01/01/1980"),dFechaHasta)


vacioDatosEstadoCuentaCliente()

estadoCuenta.text_4.value := "Saldo al "+dtoc(dFechaHasta)+" $ "+str(nSaldoAnterior)
estadoCuenta.text_3.value := "Saldo al "+dtoc(estadoCuenta.datePicker_2.value)+" $ "+str(nSaldoActual)


for i = 1 to oDocumentos:lastrec()
	if (oDocumentos:getrow(i):fieldget(5) != 98 .and. oDocumentos:getrow(i):fieldget(4) != 0) .or. (oDocumentos:getrow(i):fieldget(5) = 98 .and. oDocumentos:getrow(i):fieldget(4) != 0)
		nDebe :=  iif(oDocumentos:getrow(i):fieldget(5) = 101 .or. oDocumentos:getrow(i):fieldget(5) = 111 .or. oDocumentos:getrow(i):fieldget(5) = 113 .or. oDocumentos:getrow(i):fieldget(5) = 103  ,oDocumentos:getrow(i):fieldget(4),0 )
		nHaber := iif(oDocumentos:getrow(i):fieldget(5) = 102 .or. oDocumentos:getrow(i):fieldget(5) = 112 .or. oDocumentos:getrow(i):fieldget(5) = 98 ,oDocumentos:getrow(i):fieldget(4),0 )
		nSaldoAnterior := nSaldoAnterior + nDebe - nHaber
		cDescripcion := alltrim(oDocumentos:getrow(i):fieldget(3))+" "+alltrim(oDocumentos:getrow(i):fieldget(7))+"-"+str(oDocumentos:getrow(i):fieldget(8))
		if oDocumentos:getrow(i):fieldget(6) != 0
			cDescripcion := cDescripcion +" - $ " + str(oDocumentos:getrow(i):fieldget(6))
		// else
			
		endIf
		
		estadoCuenta.text_5.value := estadoCuenta.text_5.value + oDocumentos:getrow(i):fieldget(6)
		
		
		aadd(aGrid,{	oDocumentos:getrow(i):fieldget(1), ;
									dtoc(oDocumentos:getrow(i):fieldget(2)), ; 
									cDescripcion, ;
									nDebe, ;
									nHaber, ;
									nSaldoAnterior })
	endif
next

nLargoArray := len(aGrid)
for i= nLargoArray to 1 step -1

	estadoCuenta.grid_1.additem(agrid[i])

next
WAIT CLEAR

procedure imprimeEstadoCuentaCliente(nCliente,dFechaDesde,dFechaHasta,nPrevio, nControla,nSaldoMenor)
local oDocumentos, nSaldoAnterior
local dFechaSaldoAnt := dFechaDesde - 1
local nSaldoActual := saldoEntreFechasCliente(nCliente,ctod("01/01/1980"),dFechaHasta)
if nControla == 0 .and. nSaldoActual <= 0
	return .f.
endif
if nSaldoActual >= nSaldoMenor
	oDocumentos := documentosCliente(nCliente,dFechaDesde,dFechaHasta )
	nSaldoAnterior := saldoEntreFechasCliente(nCliente,ctod("01/01/1980"),dFechaSaldoAnt)
	imprimoEstadoCuenta(nCliente,oDocumentos,nSaldoAnterior,dFechaSaldoAnt,nSaldoActual,dFechaHasta,nPrevio)
endif




*************************************************
*************************************************
******Implementaciones del modelo ***************
*************************************************
*************************************************




