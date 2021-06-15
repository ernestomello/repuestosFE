#include <hmg.ch>
*************************************************
*************************************************
******Implementaciones de la vista***************
*************************************************
*************************************************

procedure presupuestos(cFormaPago)

  Load Window presupuestos
  presupuestos.datePicker_1.value := date() - 30
  menuContextual(cFormaPago)
  presupuestos.Center
  presupuestos.Activate
 
return

function menuContextual(cFormaPago)
	if cFormaPago == "Contado"
		DEFINE CONTROL CONTEXTMENU grid_1 of presupuestos
			MENUITEM "Anular" ONCLICK cancelarPresupuesto(presupuestos.grid_1.cell(presupuestos.grid_1.value[1],1),presupuestos.grid_1.cell(presupuestos.grid_1.value[1],4))
			MENUITEM "Ver Documento" ONCLICK muestroDocumentoCliente(presupuestos.grid_1.cell(presupuestos.grid_1.value[1],1))
			// MENUITEM "Cr�dito" ONCLICK facturoDocumento(presupuestos.grid_1.cell(presupuestos.grid_1.value,1),presupuestos.grid_1.cell(presupuestos.grid_1.value,4), 111)
			MENUITEM "Contado" ONCLICK facturoDocumento(presupuestos.grid_1.value, 1)
			MENUITEM "Credito" ONCLICK facturoDocumento(presupuestos.grid_1.value, 2)
		END MENU
		formularioContado()

	else
		DEFINE CONTROL CONTEXTMENU grid_1 of presupuestos
			MENUITEM "Cancelar" ONCLICK cancelarPresupuesto(presupuestos.grid_1.cell(presupuestos.grid_1.value[1],1),presupuestos.grid_1.cell(presupuestos.grid_1.value[1],4))
			MENUITEM "Ver Documento" ONCLICK muestroDocumentoCliente(presupuestos.grid_1.cell(presupuestos.grid_1.value[1],1))
			// MENUITEM "Cr�dito" ONCLICK facturoDocumento(presupuestos.grid_1.cell(presupuestos.grid_1.value,1),presupuestos.grid_1.cell(presupuestos.grid_1.value,4), 111)
			MENUITEM "Credito" ONCLICK facturoDocumento(presupuestos.grid_1.value, 2)
			// MENUITEM "Contado" ONCLICK facturoDocumento(presupuestos.grid_1.cell(presupuestos.grid_1.value,1),presupuestos.grid_1.cell(presupuestos.grid_1.value,4), 101)
			MENUITEM "Contado" ONCLICK facturoDocumento(presupuestos.grid_1.value, 1)
		END MENU
	endIf
return

function formularioContado()
	presupuestos.text_1.value := 0
	presupuestos.text_1.visible := .f.
	presupuestos.text_2.visible := .f.
	presupuestos.text_4.visible := .f.
	presupuestos.frame_1.visible := .f.
	presupuestos.frame_2.visible := .f.
	presupuestos.button_2.visible := .f.

	rellenoGridContado()

	procedure buscoPresupuestos()
	local nCliente := presupuestos.text_1.value
	vacioDatosPresupuestos()
	if existeCliente(nCliente)
		presupuestos.text_1.value := nCliente
		presupuestos.text_2.value := nombreCliente(nCliente)
		rellenoGridPresupuesto()
		nSocioGlobal := 0
	else
		busquedaGeneral('cc','','Clientes',1)
		if nSocioGlobal != 0
			presupuestos.text_1.value := nSocioGlobal
			presupuestos.text_2.value := nombreCliente(nSocioGlobal)
			rellenoGridPresupuesto()
			nSocioGlobal := 0
		endIf
	endif
	
return

procedure vacioDatosPresupuestos()
	presupuestos.text_3.value := ''
	presupuestos.text_4.value := ''
	presupuestos.grid_1.deleteAllItems

	function activoGridPresupuesto()

	if presupuestos.text_1.value	 = 0
		rellenoGridContado()
	else
		rellenoGridPresupuesto()
	endif
return

procedure rellenoGridPresupuesto()
	local oDocumentos, nSaldoAnterior, nSaldoActual
	local dFechaHasta := presupuestos.datePicker_1.value - 1
	local aGrid:= {}

	oDocumentos := presupuestosCliente(presupuestos.text_1.value,presupuestos.datePicker_1.value,presupuestos.datePicker_2.value, 81 )
	nSaldoActual := saldoPresupuestoCliente(presupuestos.text_1.value,ctod("01/01/1980"),presupuestos.datePicker_2.value)
	nSaldoAnterior := saldoPresupuestoCliente(presupuestos.text_1.value,ctod("01/01/1980"),dFechaHasta)

	vacioDatosPresupuestos()

	presupuestos.text_4.value := "Saldo al "+dtoc(dFechaHasta)+" $ "+str(nSaldoAnterior)
	presupuestos.text_3.value := "Saldo al "+dtoc(presupuestos.datePicker_2.value)+" $ "+str(nSaldoActual)


	for i = 1 to oDocumentos:lastrec()
		nSaldoAnterior := nSaldoAnterior + oDocumentos:getrow(i):fieldget(6)
		cDescripcion := oDocumentos:getrow(i):fieldget(3)+" - " + iif( oDocumentos:getrow(i):fieldget(6) != 0,"$ "+str(oDocumentos:getrow(i):fieldget(6)),"Cancelado")
		if presupuestos.radioGRoup_1.value = 2 .and.  oDocumentos:getrow(i):fieldget(6) = 0
		
		else
			aadd(aGrid,{	oDocumentos:getrow(i):fieldget(1), ;
										dtoc(oDocumentos:getrow(i):fieldget(2)), ;
										cDescripcion, ;
										oDocumentos:getrow(i):fieldget(4), ;
										nSaldoAnterior })
		endIf
	next

	nLargoArray := len(aGrid)
	for i= nLargoArray to 1 step -1
		presupuestos.grid_1.additem(agrid[i])
	next
return

function rellenoGridContado()
	local oDocumentos, nSaldoAnterior, nSaldoActual
	local dFechaHasta := presupuestos.datePicker_1.value - 1
	local aGrid:= {}

	oDocumentos := presupuestosCliente(0,presupuestos.datePicker_1.value,presupuestos.datePicker_2.value, 91 )
	nSaldoAnterior := 0 

	vacioDatosPresupuestos()

	for i = 1 to oDocumentos:lastrec()
		nSaldoAnterior := nSaldoAnterior + oDocumentos:getrow(i):fieldget(6)
		cDescripcion := oDocumentos:getrow(i):fieldget(3)+" - " + iif( oDocumentos:getrow(i):fieldget(6) != 0,"$ "+str(oDocumentos:getrow(i):fieldget(6)),"Cancelado")
		if presupuestos.radioGRoup_1.value = 2 .and.  oDocumentos:getrow(i):fieldget(6) = 0
		
		else
			aadd(aGrid,{	oDocumentos:getrow(i):fieldget(1), ;
						dtoc(oDocumentos:getrow(i):fieldget(2)), ;
						cDescripcion, ;
						oDocumentos:getrow(i):fieldget(4), ;
						nSaldoAnterior })
		endIf
	next

	nLargoArray := len(aGrid)
	for i= nLargoArray to 1 step -1
		presupuestos.grid_1.additem(agrid[i])
	next
return 

procedure facturodocumento(xFactura,cTipo)
	local aImporte := {}
	local aFactura := {}

	for i = 1 to len(xFactura)
		aadd(aFactura,presupuestos.grid_1.cell(xFactura[i],1))
		aadd(aImporte,presupuestos.grid_1.cell(xFactura[i],4))
	next

	if msgYesNo("Quiere Facturar el Presupuesto","ATENCION",.t.)
		factCliente(101 ,aFactura, ctipo)
		if msgYesNo("Marca como Cancelado el Presupuesto","ATENCION",.T.)
			for i = 1 to len(aFactura)
				modificoSaldoFacturaCliente(aFactura[i],aImporte[i])
			next
		endIf
	endIf
return 

Function cancelarPresupuesto(nFactura,nImporte)

	if msgYesNo("Marca como Cancelado el Presupuesto","ATENCION",.T.)
		modificoSaldoFacturaCliente(nFactura,nImporte)
	endIf
	activoGridPresupuesto()

return

procedure imprimeEstadoCuentaPresupuestosCliente()
	local oDocumentos, nSaldoAnterior, nSaldoActual
	local dFechaHasta := presupuestos.datePicker_1.value - 1
	oDocumentos := presupuestosCliente(presupuestos.text_1.value,presupuestos.datePicker_1.value,presupuestos.datePicker_2.value, 81 )

	if oDocumentos:lastRec() >	0 
		nSaldoActual := saldoPresupuestoCliente(presupuestos.text_1.value,ctod("01/01/1980"),presupuestos.datePicker_2.value)
		nSaldoAnterior := saldoPresupuestoCliente(presupuestos.text_1.value,ctod("01/01/1980"),dFechaHasta)
		imprimoEstadoCuenta(presupuestos.text_1.value,oDocumentos,nSaldoAnterior,dFechaHasta,nSaldoActual,presupuestos.datePicker_2.value,2)
	endif
return