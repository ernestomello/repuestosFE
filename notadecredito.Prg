#include <hmg.ch>

procedure notaCreditoCliente(nFactura,nCajero)
local nTipoDoc:= tipoDocumento(nFactura)
local cTipoDocumento := descripcionDocumento(nTipoDoc)
if !cajaAbierta()
	msgInfo("Caja Cerrada !!!")
	return .f.
endIf   

if IsWindowActive(notaCredito)
	msgInfo("No es posible Hacer la Devolucion")
	return .f.
endif
	
	do case
	case  ( nTipoDoc = 101 .or. nTipoDoc = 111) 
		if !facturaSinDevolucion(nFactura)
			msginfo(cTipoDocumento+" con Nota de Crédito")
			// notaCredito.release
			return .f.
		endif
		if !facturaSinRecibos(nFactura)
			msginfo(cTipoDocumento+" Con Recibos")
			// notaCredito.release
			return .f.
		endif
		aColumCont := {{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','NUMERIC','999.99'},{'TEXTBOX','NUMERIC','999,999.99'},{'TEXTBOX','NUMERIC','99'},{'TEXTBOX','NUMERIC','999'},{'TEXTBOX','NUMERIC','999,999,999.99'},{'TEXTBOX','NUMERIC'},{'TEXTBOX','CHARACTER'}}
		aColumTit :=	{'Codigo','Articulo','Cant.','Precio Unit.','Iva','Dto.','PrecioFinal','Nro fact',''}
		aColumWidth := {120,200,45,80,30,40,80,0,0 }
		
		load window notaCredito
		rellenoFacturaDevolucion(nFactura,nTipoDoc)
		notaCredito.button_1.caption := "Guardar Nota Credito"
		
	case ( nTipoDoc = 102 .or. nTipoDoc = 112)
		if !nCreditoSinDevolucion(nFactura)
			msginfo(cTipoDocumento+" con Nota de Debito")
			// notaCredito.release
			return .f.
		endif
		aColumCont := {{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','NUMERIC','999.99'},{'TEXTBOX','NUMERIC','999,999.99'},{'TEXTBOX','NUMERIC','99'},{'TEXTBOX','NUMERIC','999'},{'TEXTBOX','NUMERIC','999,999,999.99'},{'TEXTBOX','NUMERIC'},{'TEXTBOX','CHARACTER'}}
		aColumTit :=	{'','Doc.Referencia','Cant.','Precio Unit.','Iva','Dto.','Imp. Aplicado','Referencia',''}
		aColumWidth := {0,300,0,0,0,0,100,80,0 }
		load window notaCredito
		
		rellenoFacturaGlobalDevolucion(nFactura,nTipoDoc)

		notaCredito.button_1.caption := "Guardar Nota Debito"

	otherwise
		msgInfo("No es posible Hacer la Devolución")
		// notaCredito.release
		return .f.
	end case
	
	
	notaCredito.text_6.value := nFactura

	notaCredito.center
	notaCredito.activate

return    

 //si es con detalle de factura 
procedure rellenoFacturaDevolucion(nFactura,nTipoDoc)
local oCabezalFactura := facturaClienteCabezal(nFactura)
local oDetalleFactura //:= detalleFacturaCliente(nFactura)
local nTotalFactura := 0
local nGlobal := refGlobal(nFactura)
oDetalleFactura := facturaClienteDetalle(nFactura)

notaCredito.text_1.value := oCabezalFactura:getRow(1):fieldGet(3)
notaCredito.text_2.value := str(nFactura)+" - "+nombreCliente(clienteFactura(nFactura))+" - "+dtoc(fechaFacturaCliente(nFactura))
notaCredito.text_4.value := oCabezalFactura:getRow(1):fieldGet(5)
notaCredito.text_7.value := oCabezalFactura:getRow(1):fieldGet(10)
notaCredito.text_8.value := oCabezalFactura:getRow(1):fieldGet(8)

for i = 1 to oDetalleFactura:lastrec()
	oRow := oDetalleFactura:getRow(i)
	notaCredito.grid_1.additem({ oRow:fieldGet(3), oRow:fieldGet(4),oRow:fieldGet(5),oRow:fieldGet(6),oRow:fieldGet(8)," ",oRow:fieldGet(5)*oRow:fieldGet(6), oRow:fieldGet(1),oRow:fieldGet(11)  })
	nTotalFactura += round(oRow:fieldGet(5)*oRow:fieldGet(6) * (1 + oRow:fieldGet(8)/100),0)
next
notaCredito.text_5.value := nTotalFactura


procedure rellenoFacturaGlobalDevolucion(nFactura,nTipoDoc)
local oCabezalFactura := facturaClienteCabezal(nFactura)
local oDetalleFactura //:= detalleFacturaCliente(nFactura)
local nTotalFactura := 0

oDetalleFactura  := oDetalleGlobalDevolucion(nFactura,nTipoDoc)
	

notaCredito.text_1.value := oCabezalFactura:getRow(1):fieldGet(3)
notaCredito.text_2.value := str(nFactura)+" - "+nombreCliente(clienteFactura(nFactura))+" - "+dtoc(fechaFacturaCliente(nFactura))
notaCredito.text_4.value := oCabezalFactura:getRow(1):fieldGet(5)
notaCredito.text_7.value := oCabezalFactura:getRow(1):fieldGet(10)
notaCredito.text_8.value := oCabezalFactura:getRow(1):fieldGet(8)

for i = 1 to oDetalleFactura:lastrec()
	oRow := oDetalleFactura:getRow(i)
	notaCredito.grid_1.additem({ oRow:fieldGet(2), oRow:fieldGet(6),oRow:fieldGet(3),oRow:fieldGet(4),oRow:fieldGet(5)," ",oRow:fieldGet(4), oRow:fieldGet(1),""  })
	nTotalFactura += oRow:fieldGet(4)
next
notaCredito.text_5.value := nTotalFactura






procedure cuentaMarcadosDevolucion()
local nCantidad := len(notaCredito.grid_1.value)
local nTotImporte := 0

notaCredito.text_3.value := 0
for i= 1 to nCantidad
    nTotImporte := nTotImporte+ notaCredito.grid_1.item(notaCredito.grid_1.value[i])[7]    
next
notaCredito.text_3.value := nTotImporte

procedure guardarDevolucion()
local nCliente:= notaCredito.text_1.value 
local nTipoDoc := tipoDocumento(notaCredito.text_6.value)
local dFechaFactura:= notaCredito.datePicker_1.value
local nTotalFactura:= notaCredito.text_5.value
local cDescripcion:= notaCredito.text_4.value
// local nCantidad := len(notaCredito.grid_1.value)
local nformaPago := notaCredito.text_8.value
local nVendedor := notacredito.text_7.value
local nCaja := cajaId()
local cAdenda := ""
local nGlobal := refGlobal(notaCredito.text_6.value)

do case 
case nTipoDoc = 101
	cTipoDocumento := 102
case nTipoDoc = 111
	cTipoDocumento := 112
case nTipoDoc = 102
	cTipoDocumento := 103
case nTipoDoc = 112
	cTipoDocumento := 113
end case 

if !controloDevolucion()
	return .f.
endif	
	
if !msgYesNo("Graba la N/C ?","ATENCION",.t.)
	return .f.
endif

info_("Guardando en la Base de Datos ...")
if !comienzoTransaccion()
	msginfo("No se pudo guardar. REINTENTE! ! !")
	return .f.
endIf
nNumero:= numeroDesde('CLIENTE')    	

if nNumero == 0
	noTran()
	WAIT CLEAR
	msgInfo("No se pudo Guardar el Numero. Reintente!!!")
	return .f.
endif

if !agregoNumeroDesde('CLIENTE')
	noTran()
	WAIT CLEAR
	msginfo("No se pudo actualizar el Numero de la Factura")
	return .f.
endIf
// cAdenda += "Ref:"+str(nNumero)

if !graboFactClienteCabezal(nNumero,nCaja,nCliente, cTipoDocumento,nTotalFactura,dFechaFactura,cDescripcion,nVendedor,nformaPago,cAdenda)
	noTran()
	WAIT CLEAR
	msgInfo('No se pudieron grabar los datos, REINTENTE!!!')
	return .f.
endIf
if !guardoRelacion(notaCredito.text_6.value,nNumero,notaCredito.text_5.value,nGlobal)
	noTran()
	WAIT CLEAR
	return .f.
endIf


//if facturaClienteConDetalle()
// if nGlobal == "1"
	// for i=1 to notaCredito.grid_1.itemCount		
		// nNumeroFact := notaCredito.grid_1.cell(i,8)
		// nImpFactura := notaCredito.grid_1.cell(i,3) * notaCredito.grid_1.cell(i,4) 
		// if !modificoSaldoNCCliente(nNumeroFact,nImpFactura)
			// noTran()
			// WAIT CLEAR
			// msgInfo("No se pudo Modificar la Factura. Reintente!!!")
			// return .f.
		// endIf
			
	// next
// else
	do case
	case  nTipoDoc = 101 .or. nTipoDoc = 111
		if !modificoSaldoNDCliente(notaCredito.text_6.value)
			noTran()
			WAIT CLEAR
			msgInfo("No se pudo Modificar la Factura. Reintente!!!")
			return .f.
		endIf
		for i=1 to notaCredito.grid_1.itemCount
			cCodigo := notaCredito.grid_1.cell(i,9)
			nCantidad := notaCredito.grid_1.cell(i,3)
			nPrecioUnitario := notaCredito.grid_1.cell(i,4)
			nIva := notaCredito.grid_1.cell(i,5)
			nDto := notaCredito.grid_1.cell(i,6)
			nImporte := notaCredito.grid_1.cell(i,7)
			cDetDescripcion := notaCredito.grid_1.cell(i,2)
			if !graboFactClienteDetalle(nNumero,i,cCodigo,nCantidad,nPrecioUnitario,nIva,nDto,nImporte,cDetDescripcion)
				noTran()
				WAIT CLEAR
				msgInfo("No se pudieron Guardar el detalle de la Nota de Crédito. Reintente!!!")
				return .f.
			endIf
		next
	
	case  nTipoDoc = 102 .or. nTipoDoc = 112
		if !modificoSaldoNCCliente(notaCredito.text_6.value)
			noTran()
			WAIT CLEAR
			msgInfo("No se pudo Modificar la Factura. Reintente!!!")
			return .f.
		endIf
	end case
// endif

finTransaccion()

if esFacturaElectronica
	info_("Registrando Documento en DGI...")
	comienzoTransaccion()
	if ! facturaElectronica(nNumero,.f.,.t.)
		noTran()
		WAIT CLEAR
		msgInfo("No se pudo guardar el documento en DGI, Reintente!!!")	
		return .f.
	endif
endif
finTransaccion()
info_("Imprimiendo Documento ...")
if !imprimoMovimiento(nNumero,0,'','','')
	WAIT CLEAR
	msgInfo("No se pudo imprimir el Documento, Reimprima Desde el Menú")
	return .f.
endif
WAIT CLEAR

notaCredito.release
return .t.

function controloDevolucion()
//if len(notaCredito.grid_1.value) = 0
//	msgInfo("Debe marcar una lï¿½nea")
//	return .f.
//endIf

return .t.
// function anularDevolucion(nFactura,nCajero)
// if anuloDevolucion(nFactura,nCajero)
	// msgInfo('Documento No.'+str(nFactura)+' Anulado')
// else
	// msgBox("No se puede anular")
// endif

*************************************************
*************************************************
******Implementaciones del modelo ***************
*************************************************
*************************************************
// function guardoCabezalNotaCredito(nDocumento, nCaja,nCliente,cTipo,dFecha,nImporte)
// local cQuery, oQuery

// cQuery := "insert into recibo_cliente_cab values("+str(nDocumento)+","+str(nCaja)+","+str(nCliente)+", "
// cQuery += " '"+dtos(dFecha)+"','"+cTipo+"',"+str(nImporte)+", current_timestamp ,"
// cQuery += " 'N',null,null) "
// oQuery:= oServer:Query(cQuery)
// If oQuery:NetErr() 
  // MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  // si o puedo obtener el id del cabezal anulo todo para atrï¿½s
  // oQuery:=oServer:Query('ROLLBACK') 
  // return .f.
// else
	// return .t.
// endif

// function guardoDetalleNotaCredito(nNota,nFactura,nImporte)
// local cQuery, oQuery

// cQuery := "insert into recibo_cliente_det values("+str(nNota)+","+str(nFactura)+", "
// cQuery := cQuery + " "+str(nImporte)+" )"

// oQuery:= oServer:Query(cQuery)
// If oQuery:NetErr() 
  // MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  // si o puedo obtener el id del cabezal anulo todo para atrï¿½s
  // oQuery:=oServer:Query('ROLLBACK') 
  // return .f.
// else
	// return .t.
// endif

function notasCreditoFacturaCliente(nFactura)
local cQuery, oQuery

cQuery := "select c.id_factura, c.fecha,d.descripcion,c.importe,c.tipoCFE "
cQuery += " from cfe_comprobante_cab c, cfe_tipos d, cfe_referencias_det r"
cQuery += " where r.id_factura = c.id_factura "
cQuery += " and d.id_cfe = c.tipoCFE "
cQuery += " and r.id_factura_ref = "+str(nFactura)+" "
cQuery += " and c.tipoCFE in (102,112,103,113) "
cQuery += " union all "
cQuery += " select c.id_factura, c.fecha,d.descripcion,c.importe,c.tipoCFE "
cQuery += " from cfe_comprobante_cab c, cfe_tipos d, cfe_referencias_det r, cfe_referencias_det rd "
cQuery += " where rd.id_factura = c.id_factura "
cQuery += " and d.id_cfe = c.tipoCFE "
cQuery += " and r.id_factura_ref = "+str(nFactura)+"  "
cQuery += " and rd.id_factura_ref = r.id_factura "
cQuery += " and c.tipoCFE in (103,113)"

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
cQuery += " "+str(nNumero)+",1,'"+nGlobal+"',"+str(oFactura:getRow(1):fieldGet(4))+", "
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