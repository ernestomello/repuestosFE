#include <hmg.ch>

function estadoCuentaClientes()
	load window estadoCuenta
	DEFINE CONTROL CONTEXTMENU grid_1 of estadoCuenta
		MENUITEM "Ver Documento-Imprimir"  ONCLICK verFacturaEstado()
		MENUITEM "Ver Documento"  ONCLICK muestroDocumentoEstado()
		MENUITEM "Anula Segun Documento"  ONCLICK notaCreditoDebitoEstado()
		MENUITEM "Genera Contado"  ONCLICK facturodocumentoCtaCte(1)
	END MENU
	estadoCuenta.datePicker_1.value := date() - 30
	estadoCuenta.nro_linea.value := 0
	estadoCuenta.center
	estadoCuenta.activate
return 


procedure facturodocumentoCtaCte(cTipo)
	local aImporte := {}
	local aFactura := {}
	local cConCabezal := 0
	local id_factura := estadoCuenta.grid_1.cell(estadocuenta.grid_1.value,1)

	if estadoCuenta.grid_1.cell(estadocuenta.grid_1.value,4) = 0
		msgInfo("Solo documentos de Contado o Crédito")
		return 
	endIf	

	if facturaSinTocar(id_factura) = 0
		aadd(aFactura,id_factura)
		aadd(aImporte,estadoCuenta.grid_1.cell(estadocuenta.grid_1.value,4))
	else
		msgInfo("Documento tiene otros asociados")
		return
	endIf

	factCliente(101 ,aFactura, cTipo,cConCabezal)
	// Ver como hacer la NC una vez que se haya hecho el documento contado
	// if msgYesNo("Genera NC del documento","ATENCION",.T.)

	// endIf
return 

function verFacturaEstado()
	cTipoDocumento := tipoDocumento(estadocuenta.grid_1.cell(estadocuenta.grid_1.value,1))

	if cTipoDocumento != 81 .and. cTipoDocumento != 91 .and. cTipoDocumento != 98
		verFacturaPDF(estadocuenta.grid_1.cell(estadocuenta.grid_1.value,1))
	else
		imprimoMovimiento(estadocuenta.grid_1.cell(estadocuenta.grid_1.value,1),1,'','','') //mando imprimir ese movimiento con el idMov
	endif

	estadoCuenta.nro_linea.value := estadocuenta.grid_1.value
	rellenoGridCliente()
return

function muestroDocumentoEstado()
	muestroDocumentoCliente(estadocuenta.grid_1.cell(estadocuenta.grid_1.value,1))
	estadoCuenta.nro_linea.value := estadocuenta.grid_1.value
	rellenoGridCliente()
return

function notaCreditoDebitoEstado()
	anuloMovimientos(estadocuenta.grid_1.cell(estadocuenta.grid_1.value,1))
	estadoCuenta.nro_linea.value := estadocuenta.grid_1.value
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



function vacioDatosEstadoCuentaCliente()
	estadoCuenta.text_3.value := ''
	estadoCuenta.text_4.value := ''
	estadoCuenta.grid_1.deleteAllItems
return


/* Tengo que hacer cambios para que sirva para clientes y proveedores 
Agregar un saldo en cada l�nea y el saldo de la Factura.
*/
function rellenoGridCliente()
	local oDocumentos, nSaldoAnterior, nSaldoActual
	local dFechaHasta := estadoCuenta.datePicker_1.value - 1
	local nHaber:= 0,nDebe := 0, cNumero:= ""
	//local cOpcion := estadoCuenta.text_5.value
	local aGrid:= {}
	estadoCuenta.text_5.value := 0

	WAIT WINDOW "Procesando Informacion - AGUARDE" NOWAIT 
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
			cNumero := iif(oDocumentos:getrow(i):fieldget(8) = 0,"",str(oDocumentos:getrow(i):fieldget(8)))
			cDescripcion := alltrim(oDocumentos:getrow(i):fieldget(3))+" "+alltrim(oDocumentos:getrow(i):fieldget(7))+" "+cNumero
			if oDocumentos:getrow(i):fieldget(6) != 0
				cDescripcion := cDescripcion +"  $ " + str(oDocumentos:getrow(i):fieldget(6))
			endIf			
			estadoCuenta.text_5.value := estadoCuenta.text_5.value + oDocumentos:getrow(i):fieldget(6)			
			aadd(aGrid,{oDocumentos:getrow(i):fieldget(1), ;
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
	//estadoCuenta.grid_1.value := estadoCuenta.nro_linea.value 
	WAIT CLEAR
return 

//imprimeEstadoCuentaCliente(estadoCuenta.text_1.value,estadoCuenta.datePicker_1.value,estadoCuenta.datePicker_2.value,2,1,0)
procedure imprimeEstadoCuentaCliente(nCliente,dFechaDesde,dFechaHasta,nPrevio, nControla,nSaldoMenor)
	local oDocumentos, nSaldoAnterior,oDocumentoSaldo
	local dFechaSaldoAnt := dFechaDesde - 1
	local nSaldoActual := saldoEntreFechasCliente(nCliente,ctod("01/01/1980"),dFechaHasta)
	if nControla == 0 .and. nSaldoActual <= 0
		return .f.
	endif
	if nSaldoActual >= nSaldoMenor
		oDocumentos := documentosCliente(nCliente,dFechaDesde,dFechaHasta )
		oDocumentoSaldo := documentosClienteSaldo(nCliente,dFechaDesde,dFechaHasta )
		nSaldoAnterior := saldoEntreFechasCliente(nCliente,ctod("01/01/1980"),dFechaSaldoAnt)
		imprimoEstadoCuenta(nCliente,oDocumentos,nSaldoAnterior,dFechaSaldoAnt,nSaldoActual,dFechaHasta,nPrevio,"ESTADO CUENTA")
		if len(oDocumentoSaldo) != 0
			imprimoEstadoCuenta(nCliente,oDocumentoSaldo,nSaldoAnterior,dFechaSaldoAnt,nSaldoActual,dFechaHasta,nPrevio,"DOCUMENTOS IMPAGOS")
		endIf
	endif
return 



*************************************************
*************************************************
******Implementaciones del modelo ***************
*************************************************
*************************************************




