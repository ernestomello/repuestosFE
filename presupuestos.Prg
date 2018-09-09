#include <hmg.ch>
*************************************************
*************************************************
******Implementaciones de la vista***************
*************************************************
*************************************************

procedure presupuestos()

  Load Window presupuestos
  presupuestos.datePicker_1.value := date() - 30
  presupuestos.Center
  presupuestos.Activate
 
return

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

procedure rellenoGridPresupuesto()
local oDocumentos, nSaldoAnterior, nSaldoActual
local dFechaHasta := presupuestos.datePicker_1.value - 1
local aGrid:= {}

oDocumentos := presupuestosCliente(presupuestos.text_1.value,presupuestos.datePicker_1.value,presupuestos.datePicker_2.value )
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

procedure facturodocumento(nFactura,nImporte,cTipo)

if presupuestos.grid_1.cell(presupuestos.grid_1.value,5) != 0
	if msgYesNo("Quiere Facturar el Presupuesto","ATENCIÓN",.t.)
		if ctipo == 'C'
			factCliente('C',nFactura)
		else
			factCliente('F',nFactura)
		endif
		if msgYesNo("Marca como Cancelado el Presupuesto","ATENCIÓN",.T.)
			modificoSaldoFacturaCliente(nFactura,nImporte)
		endIf
	endIf
else
	msgInfo("Presupuesto ya Facturado")
endIf

Function cancelarPresupuesto(nFactura,nImporte)

if msgYesNo("Marca como Cancelado el Presupuesto","ATENCIÓN",.T.)
	modificoSaldoFacturaCliente(nFactura,nImporte)
endIf

procedure imprimeEstadoCuentaPresupuestosCliente()
local oDocumentos, nSaldoAnterior, nSaldoActual
local dFechaHasta := presupuestos.datePicker_1.value - 1


oDocumentos := presupuestosCliente(presupuestos.text_1.value,presupuestos.datePicker_1.value,presupuestos.datePicker_2.value )


if oDocumentos:lastRec() >	0 
	nSaldoActual := saldoPresupuestoCliente(presupuestos.text_1.value,ctod("01/01/1980"),presupuestos.datePicker_2.value)

		nSaldoAnterior := saldoPresupuestoCliente(presupuestos.text_1.value,ctod("01/01/1980"),dFechaHasta)

		imprimoEstadoCuenta(presupuestos.text_1.value,oDocumentos,nSaldoAnterior,dFechaHasta,nSaldoActual,presupuestos.datePicker_2.value,2)
endif
