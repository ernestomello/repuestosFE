#include <hmg.ch>

procedure reciboCliente()

if cajaAbierta() 
load window reciboCliente
reciboCliente.center
reciboCliente.activate
else
	msgInfo("Caja Cerrada !!!")
endIf       
procedure buscoClienteRecibo(nCliente)
vacioDatosReciboCliente()

	
	  if existeCliente(nCliente)
		    rellenoDatosReciboCliente(nCliente)
		    nSocioGlobal := 0
			reciboCliente.text_1.readOnly := .t.
	  else
	    
	      busquedaGeneral('cc','','Clientes',1)
	    
	       
		      if nSocioGlobal != 0
		        	rellenoDatosReciboCliente(nsocioGlobal)      
		        	nSocioGlobal := 0
					reciboCliente.text_1.readOnly := .t.
		      endIf
	  endif
	
return

procedure vacioDatosReciboCliente()
reciboCliente.text_1.value := 0
reciboCliente.text_2.value := ''
reciboCliente.grid_1.deleteAllItems
reciboCliente.text_3.value := 0
reciboCliente.text_4.value := 0
reciboCliente.text_5.value := 0
reciboCliente.text_6.value := 0
reciboCliente.text_8.value := 0
reciboCliente.text_1.readOnly := .f.

procedure vacioCalculo()
for i = 1 to reciboCliente.grid_1.itemcount           
	reciboCliente.grid_1.cell(i,5) :=0.00
	reciboCliente.grid_1.cell(i,6) :=0.00
	reciboCliente.grid_1.cell(i,7) :=0.00
	reciboCliente.grid_1.cell(i,8) :='NO'
next

reciboCliente.text_5.value := 0.00
reciboCliente.text_6.value := 0.00
reciboCliente.text_9.value := 0


procedure rellenoDatosReciboCliente(nCliente)
local oFacturas := facturasCliente(nCliente)

reciboCliente.text_1.value := nCliente
reciboCliente.text_2.value := nombreCliente(nCliente)
reciboCliente.text_8.value := 0

for i = 1 to oFacturas:lastRec()
	reciboCliente.grid_1.additem({oFacturas:getrow(i):fieldGet(1),dtoc(oFacturas:getrow(i):fieldGet(2)),oFacturas:getrow(i):fieldGet(3),oFacturas:getrow(i):fieldGet(4),0.00,0.00,0.00,'NO'})
	reciboCliente.text_8.value := reciboCliente.text_8.value + oFacturas:getrow(i):fieldGet(4)
next



procedure cuentaTotales()
local nCantidad  := len(reciboCliente.grid_1.value)
local nLinea := 	PARAMETROini("LineasDetalle","N")
local nTotImporte := 0


if nCantidad > nLinea
  	msginfo('Supera las '+str(nLinea)+' l�neas '+chr(13)+'Guarde el Documento')
  	return
endif

vacioCalculo()
nCantidad := len(reciboCliente.grid_1.value)

for i= 1 to nCantidad
		reciboCliente.grid_1.cell(reciboCliente.grid_1.value[i],8) := 'SI'
		nTotImporte := nTotImporte+ reciboCliente.grid_1.item(reciboCliente.grid_1.value[i])[4]    
		reciboCliente.text_9.value := i
next

reciboCliente.text_3.value := nTotImporte


procedure calculoDescuento()
local nCantidad := len(reciboCliente.grid_1.value)
local nLinea := 	PARAMETROini("LineasDetalle","N")
local nDiasMora := PARAMETROini("DIASMORA","N")
local nSaldoEntrega, nImporteEntrega


vacioCalculo()
iif (reciboCliente.radioGroup_1.value = 1, nImporteEntrega := reciboCliente.text_3.value, nImporteEntrega := reciboCliente.text_7.value)
nSaldoEntrega := nImporteEntrega



for i= 1 to nCantidad
	if nCantidad > nLinea
		msginfo('Supera las '+str(nLinea)+' l�neas '+chr(13)+'Desmarque L�neas para Calcular')
  	exit
	endif
	
	reciboCliente.grid_1.cell(reciboCliente.grid_1.value[i],8) := 'SI'
	if (nImporteEntrega >= reciboCliente.grid_1.cell(reciboCliente.grid_1.value[i],4)) .or. (i != nCantidad)
		if nImporteEntrega < round(reciboCliente.grid_1.cell(reciboCliente.grid_1.value[i],4) * ((100-reciboCliente.text_4.value) /100),0)
			reciboCliente.grid_1.cell(reciboCliente.grid_1.value[i],5) := nImporteEntrega
			reciboCliente.grid_1.cell(reciboCliente.grid_1.value[i],6) := round(nImporteEntrega * reciboCliente.text_4.value /(100-reciboCliente.text_4.value),0)
		else
		  reciboCliente.grid_1.cell(reciboCliente.grid_1.value[i],5) := round(reciboCliente.grid_1.cell(reciboCliente.grid_1.value[i],4) * ((100-reciboCliente.text_4.value) /100),0)
		  reciboCliente.grid_1.cell(reciboCliente.grid_1.value[i],6) := reciboCliente.grid_1.cell(reciboCliente.grid_1.value[i],4)-reciboCliente.grid_1.cell(reciboCliente.grid_1.value[i],5)
    endIf
    
    reciboCliente.grid_1.cell(reciboCliente.grid_1.value[i],7) := reciboCliente.grid_1.cell(reciboCliente.grid_1.value[i],4)-reciboCliente.grid_1.cell(reciboCliente.grid_1.value[i],5)-reciboCliente.grid_1.cell(reciboCliente.grid_1.value[i],6)
    nImporteEntrega -= reciboCliente.grid_1.cell(reciboCliente.grid_1.value[i],5)
  else
  	if nImporteEntrega >= 0
	  	reciboCliente.grid_1.cell(reciboCliente.grid_1.value[i],5) := nImporteEntrega
	    reciboCliente.grid_1.cell(reciboCliente.grid_1.value[i],6) := round(nImporteEntrega * (reciboCliente.text_4.value / (100 -reciboCliente.text_4.value )),0)
	    reciboCliente.grid_1.cell(reciboCliente.grid_1.value[i],7) := reciboCliente.grid_1.cell(reciboCliente.grid_1.value[i],4)-reciboCliente.grid_1.cell(reciboCliente.grid_1.value[i],5)-reciboCliente.grid_1.cell(reciboCliente.grid_1.value[i],6)
  	else
  		//exit
  	endIf
  endIf
  reciboCliente.text_9.value := i
next
sumoReciboClienteNota()

if reciboCliente.text_7.value  != 0
	if reciboCliente.text_7.value > reciboCliente.text_6.value
		msginfo('El importe de Entrega es MAYOR que el recibo generado')
		reciboCliente.text_7.value := reciboCliente.text_6.value
	endif  
endif 

procedure sumoReciboClienteNota()

for i = 1 to reciboCliente.grid_1.itemcount
	reciboCliente.text_5.value := reciboCliente.text_5.value + reciboCliente.grid_1.cell(i,6)
	reciboCliente.text_6.value := reciboCliente.text_6.value + reciboCliente.grid_1.cell(i,5)
next

procedure muestraFactura()

msginfo("aca muestra la factura "+str(reciboCliente.grid_1.cell(reciboCliente.grid_1.value[1],1)))

function guardaReciboCliente()
local nCantidad := len(reciboCliente.grid_1.value)
local nImportePagoreciboCliente :=  reciboCliente.text_6.value
local nImporteNotaCredito := reciboCliente.text_5.value
local nImporte, nNumeroR := 0 , nNumeroN := 0
local cAdenda := ""
local nTipoDocumento:=111
local nGlobal, aAdenda, cDescripcion := ""


//aAdenda := inputWindow('Descripcion del Pago',{'Descripcion'},{''}, {})
aAdenda := inputBox("Descripcion del Pago","Descripcion",,,,.t.,255)
if len(aAdenda) = 0
	msgInfo("Debe Ingresar Una descripcion del pago")
	return .f.
endif

if !msgYesNo("Graba el Recibo y la Bonificacion?","ATENCION",.T.)
	return .f.
endif

if !controloReciboCliente()
	return .f.
endIf
	if !comienzoTransaccion()
		msginfo("No se pudo guardar. REINTENTE! ! !")
		return .f.
	endIf
	info_("Guardando en la Base de Datos...")
	//guardo el recibo si el importe es distinto de cero
	if reciboCliente.text_6.value != 0
		nNumeroR:= numeroDesde('CLIENTE')  
		if !agregoNumeroDesde('CLIENTE')
			noTran()
			WAIT CLEAR
			msginfo("No se pudo actualizar el Numero del Recibo")
			return .f.
		endIf
		cDescripcion :=  Upper(RTrim(aAdenda))
		// if !guardoCabezalreciboCliente(nNumeroR,cajaId(),reciboCliente.text_1.value,98,reciboCliente.text_6.value,reciboCliente.datePicker_1.value,"",0,1)
		if !graboFactClienteCabezal(nNumeroR,cajaId(),reciboCliente.text_1.value,98,reciboCliente.text_6.value,reciboCliente.datePicker_1.value,cDescripcion,0,1,cAdenda)
				// (nNumero,nCaja,nCliente, nTipoDocumento,nImporte,dFechaFactura,cDescripcion,nVendedor,nFormaPago,cAdenda)
			noTran()
			WAIT CLEAR
			msgInfo("No se pudo Guardar el Recibo. Reintente!!!")
			return .f.
		endIf	
//		nRecibo := ultimoId()
//		if nRecibo = 0
//			msgInfo("No se pudo Guardar el id. Reintente!!!")
//			return .f.
//		endIf
		//guarda los detalles del recibo, controlando que la l�nea sea != 0
		for i = 1 to reciboCliente.grid_1.itemcount
			if reciboCliente.grid_1.cell(i,8) = 'SI' .and. reciboCliente.grid_1.cell(i,5)!= 0
				nDocumento := reciboCliente.grid_1.cell(i,1)
				nGlobal := refGlobal(nDocumento)
				// if !guardoDetallereciboCliente(nNumeroR, reciboCliente.grid_1.cell(i,1),reciboCliente.grid_1.cell(i,5))
				if !guardoRelacion( reciboCliente.grid_1.cell(i,1),nNumeroR,reciboCliente.grid_1.cell(i,5),nGlobal)
					// guardoRelacion(nFactura, nNumero)
					noTran()
					WAIT CLEAR
					msgInfo("No se pudieron Guardar el detalle del Recibo. Reintente!!!")
					return .f.
				endIf					
				if !modificoSaldoFacturaCliente(reciboCliente.grid_1.cell(i,1),reciboCliente.grid_1.cell(i,5))
					noTran()
					WAIT CLEAR
					msgInfo("No se pudo Modificar la Factura. Reintente!!!")
					return .f.
				endIf
			endIf
		next
	endIf
	
	//guardo la nota de credito si el importe es distinto de cero
	if reciboCliente.text_5.value != 0
		nNumeroN:= numeroDesde('CLIENTE')
		if !agregoNumeroDesde('CLIENTE')
			noTran()
			WAIT CLEAR
			msginfo("No se pudo actualizar el N�mero de la Nota de Cr�dito")
			return .f.
		endIf
		cAdenda := ""
		nTipoDocumento := iif(tipoDocumento(reciboCliente.grid_1.cell(1,1))= 101 , 102 , 112)//que pasa si el tipoDocumento de las lineas es distinto????
		if !graboFactClienteCabezal(nNumeroN,cajaId(),reciboCliente.text_1.value,nTipoDocumento,reciboCliente.text_5.value,reciboCliente.datePicker_1.value,"",0,2,cAdenda)
		// if !guardoCabezalNotaCredito(nNumeroN, cajaId(),reciboCliente.text_1.value,'N',reciboCliente.datePicker_1.value,reciboCliente.text_5.value)
			noTran()
			WAIT CLEAR
			msgInfo("No se pudo Guardar la Nota de Cr�dito. Reintente!!!")
			return .f.
		endIf	
//		nNota := ultimoId()
//		if nNota = 0
//			msgInfo("No se pudo Guardar el id_nota_credito. Reintente!!!")
//			return .f.
//		endIf
		//guarda los detalles de la Nota de Cr�dito, controlando que la l�nea sea != 0
		for i = 1 to reciboCliente.grid_1.itemcount
			if reciboCliente.grid_1.cell(i,8) = 'SI' .and. reciboCliente.grid_1.cell(i,6)!= 0
				// if !guardoDetalleNotaCredito(nNumeroN,reciboCliente.grid_1.cell(i,1),reciboCliente.grid_1.cell(i,6))
				nDocumento := reciboCliente.grid_1.cell(i,1)
				nGlobal := refGlobal(nDocumento)
				if !guardoRelacion( reciboCliente.grid_1.cell(i,1),nNumeroN,reciboCliente.grid_1.cell(i,6),nGlobal)	
					noTran()
					WAIT CLEAR
					msgInfo("No se pudo Guardar el detalle de NC. Reintente!!!")
					return .f.
				endIf					
				if !modificoSaldoFacturaCliente(reciboCliente.grid_1.cell(i,1),reciboCliente.grid_1.cell(i,6))
					noTran()
					WAIT CLEAR
					msgInfo("No se pudo Modificar la Factura. Reintente!!!")
					return .f.
				endIf
			endIf	
		next
	endIf
finTransaccion()	

vacioDatosReciboCliente()
reciboCliente.text_1.setfocus

if  nNumeroN != 0
	if esFacturaElectronica 
		info_("Registrando Documeto en DGI...")
		comienzoTransaccion()
		if ! facturaElectronica(nNumeroN,.f.,.t.)
			noTran()
			WAIT CLEAR
			msgInfo("No se pudo guardar el documento en DGI, Reintente desde el Men� !!!")	
			return .f.
		endif
	endIf
	finTransaccion()	

	info_("Imprimiendo Documento ...")
	if !imprimoMovimiento(nNumeroN,0,'','','')
		WAIT CLEAR
		msgInfo("No se pudo imprimir el Documento, Reimprima Desde el Men�")
		return .f.
	endif
endif

iif(nNumeroR != 0,imprimoMovimiento(nNumeroR,0,'','',''),)
//iif(nNumeroN != 0, imprimoMovimiento(nNumeroN,0,'','',''),)

WAIT CLEAR


return .t.

function verificaPorcentaje()

if reciboCliente.text_4.value > cPorcentajeNC .and. reciboCliente.text_4.value != 99.99
	for i = 1 to reciboCliente.grid_1.itemcount      
		//msgInfo(reciboCliente.grid_1.cell(i,2))
		if ctod(reciboCliente.grid_1.cell(i,2)) >= ctod("01/11/2018") .and. reciboCliente.grid_1.cell(i,8) = 'SI'
			msgInfo("El descuento es mayor al Autorizado")
			reciboCliente.text_4.value := 0
			reciboCliente.text_4.setfocus 
		endIf
	next
endif


function controloReciboCliente()

if reciboCliente.text_1.value = 0
	msgInfo("Numero de Cliente no puede ser cero")
	reciboCliente.text_1.setfocus
	return .f.
endif

for i = 1 to reciboCliente.grid_1.itemcount           
	if reciboCliente.grid_1.cell(i,8) == "SI"
		return .t.
	endIf
next
msgInfo("Se debe marcar una l�nea al menos")
return .f.



procedure cambiaEntrega()
iif(reciboCliente.radioGroup_1.value = 1, reciboCliente.text_7.enabled := .f., reciboCliente.text_7.enabled:= .t.)
reciboCliente.text_7.value := 0
vacioCalculo()


*************************************************
*************************************************
******Implementaciones del modelo ***************
*************************************************
*************************************************
function ultimoId()
local oQuery

oQuery:= oServer:Query( 'select LAST_INSERT_ID()')
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  //si o puedo obtener el id del cabezal anulo todo para atr�s
  oQuery:=oServer:Query('ROLLBACK') 
  return 0
else
	return oQuery:getrow(1):fieldGet(1)
endif

function  pasadoDeFecha(nFactura,nDiasMora)
local cQuery, oQuery

cQuery := " SELECT * FROM factura_cliente_cab "
cQuery += " where numero_factura = "+str(nFactura)+" "
cQuery += " and fecha < DATE_SUB(CURDATE(),INTERVAL "+str(nDiasMora)+" DAY)"

oQuery:= oServer:Query(cQuery)
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  return .f.
endif

	if oQuery:LastRec() > 0
    return .t.
  else
    return .f.
  endif

return

function guardoCabezalreciboCliente(nDocumento, nCaja,nCliente,dFecha,nImporte)
local cQuery, oQuery


cQuery := " insert into recibo_cliente_cab values("+str(nDocumento)+","+str(nCaja)+","+str(nCliente)+", "
cQuery += " '"+dtos(dFecha)+"','R',"+str(nImporte)+" , current_timestamp, "
cQuery += " 'N',null,null) "

oQuery:= oServer:Query(cQuery) 
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  //si no puedo obtener el id del cabezal anulo todo para atr�s
  oQuery:=oServer:Query('ROLLBACK') 
  return .f.
else
	return .t.
endif

function guardoDetallereciboCliente(nDocumento,nFactura,nImporte)
local cQuery, oQuery

cQuery := "insert into recibo_cliente_det values("+str(nDocumento)+","+str(nFactura)+", "
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

function recibosFacturaCliente(nFactura)
local cQuery, oQuery

cQuery := "select c.id_factura, c.fecha,d.descripcion,r.importe_aplicado "
cQuery += " from cfe_comprobante_cab c, cfe_tipos d, cfe_referencias_det r"
cQuery += " where c.id_factura = r.id_factura "
cQuery += " and d.id_cfe = c.tipoCFE "
cQuery += " and r.id_factura_ref = "+str(nFactura)+" "
cQuery += " and c.tipoCFE = 98 "
cQuery += " and c.importe != 0 "


oQuery:= oServer:Query(cQuery)
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
endif
return oQuery

function facturasReciboCliente(nRecibo)
local cQuery, oQuery

cQuery := " select d.numero_factura,d.importe "
cQuery += " from recibo_cliente_cab r, recibo_cliente_det d"
cQuery += " where r.id_recibo = d.id_recibo "
cQuery += " and r.id_recibo= "+str(nRecibo)+" "
cQuery += " and r.tipo_documento = 'R' "
cQuery += " and r.anulado = 'N' "


oQuery:= oServer:Query(cQuery)
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
endif
return oQuery

function facturasNotaCreditoCliente(nRecibo)
local cQuery, oQuery

cQuery := " select d.numero_factura,d.importe "
cQuery += " from recibo_cliente_cab r, recibo_cliente_det d"
cQuery += " where r.id_recibo = d.id_recibo "
cQuery += " and r.id_recibo= "+str(nRecibo)+" "
cQuery += " and r.tipo_documento = 'N' "


oQuery:= oServer:Query(cQuery)
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
endif
return oQuery

function facturasRecibosCliente(nRecibo)
local cQuery, oQuery

cQuery := " select c.id_factura,c.importe,c.fecha,d.importe_aplicado,c.saldo "
cQuery += " from cfe_comprobante_cab c, cfe_referencias_det d " 
cQuery += " where c.id_factura = d.id_factura_ref "
cQuery += " and d.id_factura= "+str(nRecibo)+" "
// cQuery += " and c.numero_factura = d.numero_factura "



oQuery:= oServer:Query(cQuery)
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
endif
return oQuery

function clienteRecibo(nRecibo)
local cQuery
local oQuery

cQuery := "select id_cliente from recibo_cliente_cab m "
cQuery += " where id_recibo = "+str(nRecibo)+"  "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:getRow(1):fieldGet(1)
endIf

function fechaReciboCliente(nRecibo)
local cQuery
local oQuery

cQuery := " select fecha "
cQuery += " from recibo_cliente_cab  "
cQuery += " where id_recibo = "+str(nRecibo)+" "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:getRow(1):fieldGet(1)
endIf

function reciboClienteCabezal(nRecibo)
local cQuery, oQuery

cQuery := " select id_recibo,fecha, id_cliente,tipo_documento, '-' "
cQuery += " from recibo_cliente_cab "
cQuery += " where id_recibo = "+str(nRecibo)+" "

oQuery:= oServer:Query(cQuery)
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
endif
return oQuery

function reciboClienteDetalle(nRecibo)
local cQuery, oQuery

cQuery := " select d.id_factura_ref,0, '-',d.id_factura_ref , 0, "
cQuery += " 0,c.serieCFE , c.numeroCFE, 0, d.importe_aplicado "
cQuery += " from cfe_comprobante_cab c, cfe_referencias_det d "
cQuery += " where c.id_factura = d.id_factura_ref"
cQuery += " and d.id_factura = "+str(nRecibo)+" "
cQuery += " order by 3 "


oQuery:= oServer:Query(cQuery)

If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
endif
return oQuery

function anuloRecibo(nRecibo,nCajero)
local cQuery
local oQuery

oQuery:= oServer:Query( 'BEGIN' ) //comienzo la transacci�n
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  oQuery:=oServer:Query('ROLLBACK') //si no puede hacer el comienzo de la transaccion cancelo
  return .f.
EndIf

cQuery := " update cfe_comprobante_cab "
cQuery += " set importe = 0, "
cQuery += " descripcion = concat('#CANCELADO#',current_timestamp(),'#Cajero: ',"+str(nCajero)+" ) ,"
cQuery += " saldo = 0 where id_factura = "+str(nRecibo)+" "
oQuery:= oServer:Query( cQuery ) 
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  oQuery:=oServer:Query('ROLLBACK') 
  return .f.
EndIf

cQuery := " update cfe_comprobante_cab f,cfe_referencias_det r "
cQuery += " set saldo = saldo + r.importe_aplicado"
cQuery += " where r.id_factura_ref = f.id_factura "
cQuery += " and r.id_factura = "+str(nRecibo)+" "

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

function totalReciboCaja(cDocumento, nCaja)
local cQuery, oQuery

cQuery := " select id_caja, sum(importe) "
cQuery += " from recibo_cliente_cab "
cQuery += " where tipo_documento = '"+cDocumento+"' "
cQuery += " and anulado = 'N' "
cQuery += " and id_caja = "+str(nCaja)+" "
cQuery += " group by 1  "

oQuery:= oServer:Query(cQuery)
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
endif
return oQuery:getRow(1):fieldGet(2)

function elimina_tildes(cFrase)
	local cFraseLimpia := ''
	local nlargo := len(cFrase)
	local j := 1
	
	for j := 1 to nlargo
		cChar := substr(cFrase,j,1)
		nChar := asc(cChar)
		if (nChar >= 65 .and. nChar <= 90) .or. (nChar >= 97 .and. nChar <= 122)
			cFraseLimpia += cChar
		else
			do case				
				case (nChar >= 192 .and. nChar <= 197)
					cFraseLimpia += 'A'
				case (nChar = 199 )
					cFraseLimpia += 'C'
				case (nChar >= 200 .and. nChar <= 203)
					cFraseLimpia += 'E'
				case (nChar >= 204 .and. nChar <= 207)
					cFraseLimpia += 'I'
				case (nChar = 209)
					cFraseLimpia += 'N'
				case (nChar >= 210 .and. nChar <= 214)
					cFraseLimpia += 'O'
				case (nChar >= 217 .and. nChar <= 220)
					cFraseLimpia += 'U'
				case (nChar >= 224 .and. nChar <= 229)
					cFraseLimpia += 'a'
				case (nChar = 231 )
					cFraseLimpia += 'c'
				case (nChar >= 232 .and. nChar <= 235)
					cFraseLimpia += 'e'
				case (nChar >= 236 .and. nChar <= 239)
					cFraseLimpia += 'i'
				case (nChar = 241)
					cFraseLimpia += 'n'
				case (nChar >= 243 .and. nChar <= 246)
					cFraseLimpia += 'o'
				case (nChar >= 249 .and. nChar <= 252)
					cFraseLimpia += 'u'
				otherwise
					cFraseLimpia += ' '
			endcase
		endIf		
	next
return cFraseLimpia