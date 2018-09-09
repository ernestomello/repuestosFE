#include <hmg.ch>
#include <hmg.ch>

procedure ajustoSaldoProv()


load window ajustoSaldoProv
ajustoSaldoProv.center
ajustoSaldoprov.activate


procedure buscoClienteAjustoProv(nCliente)
vacioDatosajustoProv()

	
	  if existeProveedor(nCliente)
		    rellenoDatosajustoProv(nCliente)
		    nSocioGlobal := 0
	  else
	    
	      busquedaGeneral('p')
	    
	       
		      if nSocioGlobal != 0
		        	rellenoDatosajustoProv(nsocioGlobal)      
		        	nSocioGlobal := 0
		      endIf
	  endif
	
return

procedure vacioDatosajustoProv()
ajustoSaldoProv.text_1.value := 0
ajustoSaldoProv.text_2.value := ''
ajustoSaldoProv.grid_1.deleteAllItems

ajustoSaldoProv.text_6.value := 0




procedure rellenoDatosajustoProv(nCliente)
local oFacturas := facturasCeroProv(nCliente)

ajustoSaldoProv.text_1.value := nCliente
ajustoSaldoProv.text_2.value := nombreCliente(nCliente)

for i = 1 to oFacturas:lastRec()
	ajustoSaldoProv.grid_1.additem({oFacturas:getrow(i):fieldGet(1),dtoc(oFacturas:getrow(i):fieldGet(2)),oFacturas:getrow(i):fieldGet(3),oFacturas:getrow(i):fieldGet(4),0.00,0.00,0.00,'NO'})
next

function guardaSaldoProv()
local i
if msgyesno("Aplica los Saldos a las facturas?")
	return .f.
endif
if !comienzoTransaccion()
		msginfo("No se pudo guardar. REINTENTE! ! !")
		return .f.
	endIf
for i = 1 to ajustoSaldoProv.grid_1.itemCount
	if ajustoSaldoProv.grid_1.cell(i,5) != 0
		if !modificoSaldoFacturaProveedor(ajustoSaldoProv.grid_1.cell(i,1),ajustoSaldoProv.grid_1.cell(i,5)* -1)
				msgInfo("No se pudo Modificar la Factura. Reintente!!!")
				return .f.
		endIf
	else
		exit
	endif
next

if !finTransaccion()
	msginfo("No se pudo guardar. REINTENTE! ! !")
	return .f.
endif
msginfo("Proceso Terminado")
ajustoSaldoProv.grid_1.deleteAllItems
return .t.

procedure aplicoSaldoProv()
local nSaldo := ajustoSaldoProv.text_6.value
local i
for i= 1 to ajustoSaldoProv.grid_1.itemCount
	if nSaldo < ajustoSaldoProv.grid_1.cell(i,3)
		ajustoSaldoProv.grid_1.cell(i,5):= nSaldo
		exit
	else
		ajustoSaldoProv.grid_1.cell(i,5):= ajustoSaldoProv.grid_1.cell(i,3)
		nSaldo := nSaldo - ajustoSaldoProv.grid_1.cell(i,3)
	endif
next



function facturasCeroProv(nCliente)
local cQuery
local oQuery

cQuery := " select numero_factura, fecha,importe, saldo "
cQuery += " from factura_pproveedor_cab "
cQuery += " where id_proveedor = "+str(nCliente)+" "
cQuery += " and saldo = 0 "
cQuery += " and tipo_documento = 'F' "
cQuery += " order by fecha desc "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery
endIf

function reciboAutomaticoProveedor()
local oproveedor := proveedores()
local nSaldo2012 := 0

if !comienzoTransaccion()
	msginfo("No se pudo guardar. REINTENTE! ! !")
	return .f.
endIf
for i= 1 to oProveedor:LastRec()
	nSaldo2012 := saldoEntreFechasProveedor(i,ctod("01/01/1980"),ctod("31/12/2012"))
	if nSaldo2012 > 0
		guardoCabezalreciboProveedor(i,ctod('01/01/2013'),99999999,nSaldo2012)
	endif
	
	
next

finTransaccion()