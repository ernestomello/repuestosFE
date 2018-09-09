#include <hmg.ch>

procedure estadoCuentaClientes()

load window estadoCuenta
//do case
//case cOpcion == 'clientes'
//	estadoCuenta.frame_1.caption := 'Cliente: '
//case cOpcion == 'proveedores'
//	estadoCuenta.frame_1.caption := 'Proveedor: '
//	estadoCuenta.button_2.visible := .f.
//end do

estadoCuenta.datePicker_1.value := date() - 30
estadoCuenta.center
estadoCuenta.activate



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
Agregar un saldo en cada línea y el saldo de la Factura.
*/
procedure rellenoGridCliente()
local oDocumentos, nSaldoAnterior, nSaldoActual
local dFechaHasta := estadoCuenta.datePicker_1.value - 1
//local cOpcion := estadoCuenta.text_5.value
local aGrid:= {}
estadoCuenta.text_5.value := 0

	oDocumentos := documentosCliente(estadoCuenta.text_1.value,estadoCuenta.datePicker_1.value,estadoCuenta.datePicker_2.value )
	nSaldoActual := saldoEntreFechasCliente(estadoCuenta.text_1.value,ctod("01/01/1980"),estadoCuenta.datePicker_2.value)
	nSaldoAnterior := saldoEntreFechasCliente(estadoCuenta.text_1.value,ctod("01/01/1980"),dFechaHasta)


vacioDatosEstadoCuentaCliente()

estadoCuenta.text_4.value := "Saldo al "+dtoc(dFechaHasta)+" $ "+str(nSaldoAnterior)
estadoCuenta.text_3.value := "Saldo al "+dtoc(estadoCuenta.datePicker_2.value)+" $ "+str(nSaldoActual)


for i = 1 to oDocumentos:lastrec()
	nSaldoAnterior := nSaldoAnterior + oDocumentos:getrow(i):fieldget(4) -oDocumentos:getrow(i):fieldget(5)
	if oDocumentos:getrow(i):fieldget(6) != 0
		cDescripcion := oDocumentos:getrow(i):fieldget(3)+" - $ " + str(oDocumentos:getrow(i):fieldget(6))
	else
		cDescripcion := oDocumentos:getrow(i):fieldget(3)
	endIf
	estadoCuenta.text_5.value := estadoCuenta.text_5.value + oDocumentos:getrow(i):fieldget(6)
	aadd(aGrid,{	oDocumentos:getrow(i):fieldget(1), ;
								dtoc(oDocumentos:getrow(i):fieldget(2)), ; 
								cDescripcion, ;
								oDocumentos:getrow(i):fieldget(4), ;
								oDocumentos:getrow(i):fieldget(5), ;
								nSaldoAnterior })
next

nLargoArray := len(aGrid)
for i= nLargoArray to 1 step -1

	estadoCuenta.grid_1.additem(agrid[i])

next

procedure imprimeEstadoCuentaCliente(nCliente,dFechaDesde,dFechaHasta,nPrevio)
local oDocumentos, nSaldoAnterior, nSaldoActual
local dFechaSaldoAnt := dFechaDesde - 1

oDocumentos := documentosCliente(nCliente,dFechaDesde,dFechaHasta )

if oDocumentos:lastRec() >	0 
	
	nSaldoActual := saldoEntreFechasCliente(nCliente,ctod("01/01/1980"),dFechaHasta)
	
		nSaldoAnterior := saldoEntreFechasCliente(nCliente,ctod("01/01/1980"),dFechaSaldoAnt)
		imprimoEstadoCuenta(nCliente,oDocumentos,nSaldoAnterior,dFechaSaldoAnt,nSaldoActual,dFechaHasta,nPrevio)
	
endif




*************************************************
*************************************************
******Implementaciones del modelo ***************
*************************************************
*************************************************




