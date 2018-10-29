#include <hmg.ch>

procedure notaCreditoCliente(nFactura)
if cajaAbierta()
if !IsWindowActive(notaCredito)
	if (tipoDocumento(nFactura) = 101 .or. tipoDocumento(nFactura) = 111) 
		if !facturaSinDevolucion(nFactura)
			msginfo("Factura con Devolucion")
			return
		endif
		if !facturaSinRecibos(nFactura)
			msginfo("Factura Con Recibos")
			return
		endif
		load window notaCredito
		notaCredito.text_6.value := nFactura
		rellenoFacturaDevolucion(nFactura)
		notaCredito.center
		notaCredito.activate
	else
		msgInfo("No es una Factura")
	endif
endif
else
	msgInfo("Caja Cerrada !!!")
endIf       

procedure rellenoFacturaDevolucion(nFactura)
local oDetalleFactura := detalleFacturaCliente(nFactura)
local nTotalFactura := 0

notaCredito.text_1.value := clienteFactura(nFactura)
notaCredito.text_2.value := str(nFactura)+" - "+nombreCliente(clienteFactura(nFactura))+" - "+dtoc(fechaFacturaCliente(nFactura))
notaCredito.text_4.value := ""//str(nFactura)
notaCredito.text_7.value := vendedorFacturaCliente(nFactura)

for i = 1 to oDetalleFactura:lastrec()
	oRow := oDetalleFactura:getRow(i)
	notaCredito.grid_1.additem({ oRow:fieldGet(7), oRow:fieldGet(1),oRow:fieldGet(2),oRow:fieldGet(3),oRow:fieldGet(4),oRow:fieldGet(5),oRow:fieldGet(6)  })
	nTotalFactura += round(oRow:fieldGet(6) * (1 + oRow:fieldGet(4)/100),0)
next
notaCredito.text_5.value := nTotalFactura
notaCredito.text_3.value := saldoFactura(nFactura)

procedure cuentaMarcadosDevolucion()
local nCantidad := len(notaCredito.grid_1.value)
local nTotImporte := 0

notaCredito.text_3.value := 0
for i= 1 to nCantidad
    nTotImporte := nTotImporte+ notaCredito.grid_1.item(notaCredito.grid_1.value[i])[7]    
next
notaCredito.text_3.value := nTotImporte

procedure guardarDevolucion()
local nCliente, cTipoDocumento,dFechaFactura,nTotalFactura,cDescripcion
local nCantidad := len(notaCredito.grid_1.value)

nformaPago := formaPago(notaCredito.text_6.value)
nCliente:= notaCredito.text_1.value  
cTipoDocumento := iif( tipoDocumento(notaCredito.text_6.value) = 101 , 102 , iif( tipoDocumento(notaCredito.text_6.value) = 111 , 112 , 0 ))
dFechaFactura := notaCredito.datePicker_1.value
nTotalFactura:= notaCredito.text_3.value
cDescripcion :=notaCredito.text_4.value
nVendedor := notacredito.text_7.value
nCaja := cajaId()
cAdenda := ""
if !controloDevolucion()
	return .f.
endif	
	
if !msgYesNo("Graba la N/C ?","ATENCION",.t.)
	return .f.
endif
if !comienzoTransaccion()
	msginfo("No se pudo guardar. REINTENTE! ! !")
	return .f.
endIf
nNumero:= numeroDesde('CLIENTE')    	

if nNumero == 0
	msgInfo("No se pudo Guardar el Numero. Reintente!!!")
	return .f.
endif

if !agregoNumeroDesde('CLIENTE')
	msginfo("No se pudo actualizar el Numero de la Factura")
	return .f.
endIf


if !graboFactClienteCabezal(nNumero,nCaja,nCliente, cTipoDocumento,nTotalFactura,dFechaFactura,cDescripcion,nVendedor,nformaPago,cAdenda)
  msgInfo('No se pudieron grabar los datos, REINTENTE!!!')
	return .f.
endIf
if !guardoRelacion(notaCredito.text_6.value,nNumero,notaCredito.text_5.value,0)
	return .f.
endIf


//if facturaClienteConDetalle()
	for i=1 to notaCredito.grid_1.itemCount
			cCodigo := notaCredito.grid_1.cell(i,1)
			nCantidad := notaCredito.grid_1.cell(i,3)
			nPrecioUnitario := notaCredito.grid_1.cell(i,4)
			nIva := notaCredito.grid_1.cell(i,5)
			nDto := notaCredito.grid_1.cell(i,6)
			nImporte := notaCredito.grid_1.cell(i,7)
			if !graboFactClienteDetalle(nNumero,i,cCodigo,nCantidad,nPrecioUnitario,nIva,nDto,nImporte)
				msgInfo("No se pudieron Guardar el detalle de la NOta de Cr�dito. Reintente!!!")
				return .f.
			endIf
	next

// endIf
if !modificoSaldoFacturaCliente(notaCredito.text_6.value,nTotalFactura)
	msgInfo("No se pudo Modificar la Factura. Reintente!!!")
	return .f.
endIf
finTransaccion()
if esFacturaElectronica
	info_("Registrando Documento en DGI...")

	if ! facturaElectronica(nNumero,.f.,.t.)
		WAIT CLEAR
		msgInfo("No se pudo guardar el documento en DGI, Reintente!!!")	
		return .f.
	endif
endif

info_("Imprimiendo Documento ...")
if !imprimoMovimiento(nNumero,0,'','','')
	WAIT CLEAR
	msgInfo("No se pudo imprimir el Documento, Reimprima Desde el Men�")
	return .f.
endif
WAIT CLEAR

notaCredito.release
return .t.

function controloDevolucion()
//if len(notaCredito.grid_1.value) = 0
//	msgInfo("Debe marcar una l�nea")
//	return .f.
//endIf

return .t.
function anularDevolucion(nFactura,nCajero)
if anuloDevolucion(nFactura,nCajero)
	msgInfo('Documento No.'+str(nFactura)+' Anulado')
else
	msgBox("No se puede anular")
endif

*************************************************
*************************************************
******Implementaciones del modelo ***************
*************************************************
*************************************************
function guardoCabezalNotaCredito(nDocumento, nCaja,nCliente,cTipo,dFecha,nImporte)
local cQuery, oQuery

cQuery := "insert into recibo_cliente_cab values("+str(nDocumento)+","+str(nCaja)+","+str(nCliente)+", "
cQuery += " '"+dtos(dFecha)+"','"+cTipo+"',"+str(nImporte)+", current_timestamp ,"
cQuery += " 'N',null,null) "
oQuery:= oServer:Query(cQuery)
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  //si o puedo obtener el id del cabezal anulo todo para atr�s
  oQuery:=oServer:Query('ROLLBACK') 
  return .f.
else
	return .t.
endif

function guardoDetalleNotaCredito(nNota,nFactura,nImporte)
local cQuery, oQuery

cQuery := "insert into recibo_cliente_det values("+str(nNota)+","+str(nFactura)+", "
cQuery := cQuery + " "+str(nImporte)+" )"

oQuery:= oServer:Query(cQuery)
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  //si o puedo obtener el id del cabezal anulo todo para atr�s
  oQuery:=oServer:Query('ROLLBACK') 
  return .f.
else
	return .t.
endif

function notasCreditoFacturaCliente(nFactura)
local cQuery, oQuery

cQuery := "select c.id_factura, c.fecha,d.descripcion,c.importe,c.tipoCFE "
cQuery += " from cfe_comprobante_cab c, cfe_tipos d, cfe_referencias_det r"
cQuery += " where r.id_factura = c.id_factura "
cQuery += " and d.id_cfe = c.tipoCFE "
cQuery += " and r.id_factura_ref = "+str(nFactura)+" "
cQuery += " and c.tipoCFE in (102,112) "

oQuery:= oServer:Query(cQuery)
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
endif
return oQuery

function notasDevolucionFacturaCliente(nFactura)
local cQuery, oQuery

cQuery := "select c.id_factura, c.fecha,d.descripcion,c.importe,c.tipoCFE "
cQuery += " from cfe_comprobante_cab c, cfe_tipos d, cfe_referencias_det r"
cQuery += " where r.id_factura = c.id_factura "
cQuery += " and d.id_cfe = c.tipoCFE "
cQuery += " and r.id_factura_ref = "+str(nFactura)+" "
cQuery += " and c.tipoCFE in (103,113) "
// cQuery += " and c.anulado = 'N' "

oQuery:= oServer:Query(cQuery)
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
endif
return oQuery




function guardoRelacion(nFactura, nNumero,nImporteAplica,nGlobal)
local cQuery, oQuery,oFactura:= facturaClienteCabezal(nFactura)


cQuery := " insert into cfe_referencias_det values( "
cQuery += " "+str(nNumero)+",1,"+str(nGlobal)+","+str(oFactura:getRow(1):fieldGet(4))+", "
cQuery += " '"+oFactura:getRow(1):fieldGet(6)+"',"+str(oFactura:getRow(1):fieldGet(7))+", "
cQuery += " '"+dtos(oFactura:getRow(1):fieldGet(2))+"', "
cQuery += " '',"+str(nFactura)+", "+str(nImporteAplica)+" ) " 

oQuery:= oServer:Query(cQuery)
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
 	oQuery:=oServer:Query('ROLLBACK') 
  return .f.
else
	return .t.
endif

function anuloDevolucion(nFactura,nCajero)
local cQuery
local oQuery

oQuery:= oServer:Query( 'BEGIN' ) //comienzo la transacci�n
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  oQuery:=oServer:Query('ROLLBACK') //si no puede hacer el comienzo de la transaccion cancelo
  return .f.
EndIf

cQuery := " update factura_cliente_cab "
cQuery += " set anulado = 'S', "
cQuery += " usuario_anula = "+str(nCajero)+", "
cQuery += " fecha_anula = current_timestamp "
cQuery +=	" where numero_factura = "+str(nFactura)+" "
oQuery:= oServer:Query( cQuery ) 
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  oQuery:=oServer:Query('ROLLBACK') 
  return .f.
EndIf

cQuery := " update factura_cliente_cab f,factura_notacredito r "
cQuery += " set saldo = f.importe "
cQuery += " where r.numero_factura = f.numero_factura "
cQuery += " and r.numero_notacredito = "+str(nFactura)+" "

oQuery:= oServer:Query( cQuery ) 
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  oQuery:=oServer:Query('ROLLBACK') 
  return .f.
EndIf

oQuery:= oServer:Query( 'COMMIT' ) 
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  oQuery:=oServer:Query('ROLLBACK') 
  return .f.
EndIf
return .t.