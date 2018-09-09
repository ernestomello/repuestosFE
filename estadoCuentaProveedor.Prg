#include <hmg.ch>

procedure estadoCuentaProveedores()

load window estadoCuentaProveedor
//estadoCuentaProveedor.text_5.value := cOpcion
//do case
//case cOpcion == 'clientes'
//	estadoCuenta.frame_1.caption := 'Cliente: '
//case cOpcion == 'proveedores'
//	estadoCuenta.frame_1.caption := 'Proveedor: '
//	estadoCuenta.button_2.visible := .f.
//end do

estadoCuentaProveedor.datePicker_1.value := date() - 30
estadoCuentaProveedor.center
estadoCuentaProveedor.activate


procedure buscoProveedorEstadoCuenta()
local nProveedor := estadoCuentaProveedor.text_1.value
vacioDatosEstadoCuentaProveedor()

	
	  if existeProveedor(nProveedor)
		    estadoCuentaProveedor.text_1.value := nProveedor
		    estadoCuentaProveedor.text_2.value := nombreProveedor(nProveedor)
		    nSocioGlobal := 0
		    rellenoGridProveedor()
	  else
	    
	      busquedaGeneral('p','','Proveedores',1)
	    
	       
		      if nSocioGlobal != 0
		        	estadoCuentaProveedor.text_1.value := nSocioGlobal
		    			estadoCuentaProveedor.text_2.value := nombreProveedor(nSocioGlobal)
		        	nSocioGlobal := 0
		      		rellenoGridProveedor()
		      endIf
	  endif
	
return
Procedure borraDocumentoProveedor(nDocumento)
local cTipoDocumento := tipoDocumentoProveedor(nDocumento)

//msginfo(cTipoDocumento)

if msgyesno("Borra el  Documento "+str(nDocumento))
	if cTipoDocumento = 'F'
		if borrafacturaProveedor(nDocumento)
			msginfo("Documento Borrado")
		else
			msginfo("Error reintente borrar")
		endif
	else
	  if borraReciboProveedor(nDocumento)
			msginfo("Documento Borrado")
		else
			msginfo("Error reintente borrar")
		endif
	endif

endif

rellenoGridProveedor()

procedure vacioDatosEstadoCuentaProveedor()
estadoCuentaProveedor.text_3.value := ''
estadoCuentaProveedor.text_4.value := ''
estadoCuentaProveedor.text_5.value := 0
estadoCuentaProveedor.grid_1.deleteAllItems

procedure rellenoGridProveedor()
local oDocumentos, nSaldoAnterior, nSaldoActual
local dFechaHasta := estadoCuentaProveedor.datePicker_1.value - 1
local cOpcion := estadoCuentaProveedor.text_5.value
local aGrid:= {}

	oDocumentos := documentosProveedor(estadoCuentaProveedor.text_1.value,estadoCuentaProveedor.datePicker_1.value,estadoCuentaProveedor.datePicker_2.value )
	nSaldoActual := saldoEntreFechasProveedor(estadoCuentaProveedor.text_1.value,ctod("01/01/1980"),estadoCuentaProveedor.datePicker_2.value)
	nSaldoAnterior := saldoEntreFechasProveedor(estadoCuentaProveedor.text_1.value,ctod("01/01/1980"),dFechaHasta)


vacioDatosEstadoCuentaProveedor()

estadoCuentaProveedor.text_4.value := "Saldo al "+dtoc(dFechaHasta)+" $ "+str(nSaldoAnterior)
estadoCuentaProveedor.text_3.value := "Saldo al "+dtoc(estadoCuentaProveedor.datePicker_2.value)+" $ "+str(nSaldoActual)


for i = 1 to oDocumentos:lastrec()
	nSaldoAnterior := nSaldoAnterior + oDocumentos:getrow(i):fieldget(5) -oDocumentos:getrow(i):fieldget(6)
	if oDocumentos:getrow(i):fieldget(7) != 0
		cDescripcion := oDocumentos:getrow(i):fieldget(4)+" - $ " + str(oDocumentos:getrow(i):fieldget(7))
	else
		cDescripcion := oDocumentos:getrow(i):fieldget(4)
	endIf
	estadoCuentaProveedor.text_5.value := estadoCuentaProveedor.text_5.value + oDocumentos:getrow(i):fieldget(7)
	aadd(aGrid,{	oDocumentos:getrow(i):fieldget(1), ;
								oDocumentos:getrow(i):fieldget(2), ;
								dtoc(oDocumentos:getrow(i):fieldget(3)), ; 
								cDescripcion, ;
								oDocumentos:getrow(i):fieldget(5), ;
								oDocumentos:getrow(i):fieldget(6), ;
								nSaldoAnterior })
next

nLargoArray := len(aGrid)
for i= nLargoArray to 1 step -1

	estadoCuentaProveedor.grid_1.additem(agrid[i])

next

procedure imprimeEstadoCuentaProveedor()
local oDocumentos, nSaldoAnterior, nSaldoActual
local dFechaHasta := estadoCuentaProveedor.datePicker_1.value - 1

oDocumentos := documentosProveedor(estadoCuentaProveedor.text_1.value,estadoCuentaProveedor.datePicker_1.value,estadoCuentaProveedor.datePicker_2.value )

if oDocumentos:lastRec() >	0
	
	nSaldoActual := saldoEntreFechasProveedor(estadoCuentaProveedor.text_1.value,ctod("01/01/1980"),estadoCuentaProveedor.datePicker_2.value)
	if nSaldoActual != 0
		nSaldoAnterior := saldoEntreFechasProveedor(estadoCuentaProveedor.text_1.value,ctod("01/01/1980"),dFechaHasta)
		imprimoEstadoCuenta(estadoCuentaProveedor.text_1.value,oDocumentos,nSaldoAnterior,dFechaHasta,nSaldoActual,estadoCuentaProveedor.datePicker_2.value,2)
	endif
endif