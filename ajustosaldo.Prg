#include <hmg.ch>
procedure ajustoSaldo()


load window ajustoSaldo
ajustoSaldo.center
ajustoSaldo.activate


procedure buscoClienteAjustoSaldo(nCliente)
vacioDatosajustoSaldo()

	
	  if existeCliente(nCliente)
		    rellenoDatosajustoSaldo(nCliente)
		    nSocioGlobal := 0
	  else
	    
	      busquedaGeneral('c')
	    
	       
		      if nSocioGlobal != 0
		        	rellenoDatosajustoSaldo(nsocioGlobal)      
		        	nSocioGlobal := 0
		      endIf
	  endif
	
return

procedure vacioDatosajustoSaldo()
ajustoSaldo.text_1.value := 0
ajustoSaldo.text_2.value := ''
ajustoSaldo.grid_1.deleteAllItems

ajustoSaldo.text_6.value := 0




procedure rellenoDatosajustoSaldo(nCliente)
local oFacturas := facturasCeroCliente(nCliente)

ajustoSaldo.text_1.value := nCliente
ajustoSaldo.text_2.value := nombreCliente(nCliente)

for i = 1 to oFacturas:lastRec()
	ajustoSaldo.grid_1.additem({oFacturas:getrow(i):fieldGet(1),dtoc(oFacturas:getrow(i):fieldGet(2)),oFacturas:getrow(i):fieldGet(3),oFacturas:getrow(i):fieldGet(4),0.00,0.00,0.00,'NO'})
next

ajustoSaldo.text_6.setfocus

function guardaSaldoCliente()
local i
if !msgyesno("Aplica los Saldos a las facturas?")
	return .f.
endif
if !comienzoTransaccion()
		msginfo("No se pudo guardar. REINTENTE! ! !")
		return .f.
	endIf
for i = 1 to ajustoSaldo.grid_1.itemCount
	if ajustoSaldo.grid_1.cell(i,5) != 0
		if !modificoSaldoFacturaCliente(ajustoSaldo.grid_1.cell(i,1),ajustoSaldo.grid_1.cell(i,5)* -1)
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
ajustoSaldo.text_6.value := 0
ajustoSaldo.text_1.setfocus
ajustoSaldo.grid_1.deleteAllItems
return .t.

procedure aplicoSaldo()
local nSaldo := ajustoSaldo.text_6.value
local i
for i= 1 to ajustoSaldo.grid_1.itemCount
	if nSaldo < ajustoSaldo.grid_1.cell(i,3)
		ajustoSaldo.grid_1.cell(i,5):= nSaldo
		exit
	else
		ajustoSaldo.grid_1.cell(i,5):= ajustoSaldo.grid_1.cell(i,3)
		nSaldo := nSaldo - ajustoSaldo.grid_1.cell(i,3)
	endif
next

ajustoSaldo.button_1.setfocus

function facturasCeroCliente(nCliente)
local cQuery
local oQuery

cQuery := " select numero_factura, fecha,importe, saldo "
cQuery += " from factura_cliente_cab "
cQuery += " where id_cliente = "+str(nCliente)+" "
cQuery += " and saldo = 0 "
cQuery += " and tipo_documento = 'F' "
cQuery += " order by fecha desc "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery
endIf