#include <hmg.ch>

//cTipoDocumento es para definir que documento será guardado.
//puede ser R=Recibo, N=Bonificaciones, D=Devolución.
procedure reciboProveedor(cTipoDocumento)

load window reciboProveedor
reciboProveedor.text_6.value := cTipoDocumento
reciboProveedor.title := descripcionDocumento(cTipoDocumento)
reciboProveedor.label_1.value := ""
reciboProveedor.frame_6.caption := "Nro."+alltrim(reciboProveedor.title)
reciboProveedor.frame_5.caption := "Importe "+alltrim(reciboProveedor.title)
reciboProveedor.datePicker_2.value := date() - 60
if cTipoDocumento != 'R'
	reciboProveedor.text_9.visible := .f.
	reciboProveedor.text_10.visible := .f.
	reciboProveedor.text_11.visible := .f.
	reciboProveedor.frame_9.visible := .f.
	reciboProveedor.frame_10.visible := .f.
	reciboProveedor.frame_12.visible := .f.
endif
reciboProveedor.center
reciboProveedor.activate


procedure vacioCalculoProveedor()

for i = 1 to reciboProveedor.grid_1.itemcount           
		reciboProveedor.grid_1.cell(i,8) :='NO'
next
reciboProveedor.text_8.value := 0


procedure cuentaTotalesProveedor()
local nCantidad := len(reciboProveedor.grid_1.value)
local nTotImporte := 0

vacioCalculoProveedor()
for i= 1 to nCantidad
		do case
			case reciboProveedor.text_6.value == 'R'
				if alltrim(reciboProveedor.grid_1.item(reciboProveedor.grid_1.value[i])[5]) = 'No Tiene' 
					nTotImporte := nTotImporte+ reciboProveedor.grid_1.item(reciboProveedor.grid_1.value[i])[4]    
    			reciboProveedor.grid_1.cell(reciboProveedor.grid_1.value[i],8) := 'SI'
    		else
    			msgInfo('Esta factura ya tiene un ' +alltrim(reciboProveedor.title))
    		endif
			case reciboProveedor.text_6.value == 'N'
			  if alltrim(reciboProveedor.grid_1.item(reciboProveedor.grid_1.value[i])[6])  = 'No Tiene' 
					nTotImporte := nTotImporte+ reciboProveedor.grid_1.item(reciboProveedor.grid_1.value[i])[4]    
    			reciboProveedor.grid_1.cell(reciboProveedor.grid_1.value[i],8) := 'SI'
    		else
    			msgInfo('Esta factura ya tiene un '+alltrim(reciboProveedor.title))
    		endif
    	case reciboProveedor.text_6.value == 'D'
					nTotImporte := nTotImporte+ reciboProveedor.grid_1.item(reciboProveedor.grid_1.value[i])[4]    
    			reciboProveedor.grid_1.cell(reciboProveedor.grid_1.value[i],8) := 'SI'
    end do
next
reciboProveedor.text_8.value := nTotImporte

procedure cuentaTotalesRangoProveedor()
local nTotImporte := 0

//vacioCalculoProveedor()
for i= 1 to reciboProveedor.grid_1.itemcount
//msgInfo(str(i))
    nTotImporte := nTotImporte+ reciboProveedor.grid_1.item(reciboProveedor.grid_1.value[i])[4]    
next
reciboProveedor.text_3.value := nTotImporte

procedure muestraFacturaProveedor()

procedure buscoProveedorRecibo(nProveedor)
vacioDatosReciboProveedor()

	
	  if existeProveedor(nProveedor)
		    rellenoDatosReciboProveedor(nProveedor)
		    nSocioGlobal := 0
	  else
	    
	      busquedaGeneral('p','','Proveedores',1)
	    
	       
		      if nSocioGlobal != 0
		        	rellenoDatosReciboProveedor(nSocioGlobal)
		        	nSocioGlobal := 0
		      endIf
	  endif
//cuentaTotalesRangoProveedor()	
return

procedure rellenoDatosReciboProveedor(nProveedor)
local oFacturas := facturasProveedor(nProveedor,reciboProveedor.datePicker_2.value, reciboProveedor.datePicker_3.value)

reciboProveedor.text_1.value := nProveedor
reciboProveedor.text_2.value := nombreProveedor(nProveedor)
reciboProveedor.text_3.value := 0
reciboProveedor.grid_1.deleteallitems

for i = 1 to oFacturas:lastRec()
	cRecibo := reciboFacturaProveedor(oFacturas:getrow(i):fieldGet(4))
	cNotaCredito := notaFacturaProveedor(oFacturas:getrow(i):fieldGet(4))
	cDevolucion := devolucionFacturaProveedor(oFacturas:getrow(i):fieldGet(4))
	reciboProveedor.grid_1.additem({oFacturas:getrow(i):fieldGet(4), oFacturas:getrow(i):fieldGet(1),dtoc(oFacturas:getrow(i):fieldGet(2)),oFacturas:getrow(i):fieldGet(3),cRecibo,cNotaCredito,cDevolucion,'NO'})
	reciboProveedor.text_3.value := reciboProveedor.text_3.value +  oFacturas:getrow(i):fieldGet(3)
next
//reciboProveedor.grid_1.value := {len(reciboProveedor.grid_1.itemcount),reciboProveedor.grid_1.itemcount}
reciboProveedor.label_1.value := signoMOneda(monedaProveedor(nProveedor))


procedure vacioDatosReciboProveedor()

reciboProveedor.grid_1.deleteAllItems
reciboProveedor.text_1.value := 0
reciboProveedor.text_2.value := ""
reciboProveedor.text_3.value := 0
reciboProveedor.text_4.value := 0
reciboProveedor.text_5.value := ""
reciboProveedor.label_1.value := ""
reciboProveedor.text_8.value := 0
reciboProveedor.text_11.value := 0
reciboProveedor.text_10.value := ""
reciboProveedor.text_7.value := ctod("00/00/0000")
reciboProveedor.text_9.value := ctod("00/00/0000")


procedure guardaReciboProveedor()

if !comienzoTransaccion()
	msginfo("No se pudo guardar. REINTENTE! ! !")
	return .f.
endIf

if reciboProveedor.text_6.value = 'R'
	guardarReciboProveedor(reciboProveedor.text_7.value,reciboProveedor.text_5.value,reciboProveedor.text_4.value,'R')
	if reciboProveedor.text_11.value != 0
		guardarReciboProveedor(reciboProveedor.text_9.value,reciboProveedor.text_10.value,reciboProveedor.text_11.value,'N')
	endif
else
	guardarReciboProveedor(reciboProveedor.text_7.value,reciboProveedor.text_5.value,reciboProveedor.text_4.value,reciboProveedor.text_6.value)
endif
finTransaccion()

vacioDatosReciboProveedor()


function guardarReciboProveedor(fRecibo,nRecibo,iRecibo,cTipoDocumento)
local nNumero
local Id_Recibo
local nCantidad := len(reciboProveedor.grid_1.value)


if !msgYesNo("Graba "+alltrim(reciboProveedor.title),"ATENCIÓN",.T.)
	return .f.
endif

if !controloReciboProveedor(cTipoDocumento)
	return .f.
endIf

	//guardo el recibo si el importe es distinto de cero
nNumero:= numeroDesde('PROVEEDOR')  	

if !agregoNumeroDesde('PROVEEDOR')
	msginfo("No se pudo actualizar el Número de la Factura")
	return .f.
endIf	
if !guardoCabezalreciboProveedor(nNumero, reciboProveedor.text_1.value,fRecibo,nRecibo,iRecibo,cTipoDocumento)
	msgInfo("No se pudo Guardar "+alltrim(reciboProveedor.title)+" Reintente!!!")
	return .f.
endIf	

Id_Recibo := nNumero
if Id_Recibo = 0
	msgInfo("No se pudo Guardar el id. Reintente!!!")
	return .f.
endIf

for i = 1 to reciboProveedor.grid_1.itemcount
	if reciboProveedor.grid_1.cell(i,8) = 'SI'
		if !guardoDetallereciboProveedor(nRecibo, reciboProveedor.grid_1.cell(i,1),0)
			msgInfo("No se pudieron Guardar el detalle de "+alltrim(reciboProveedor.title)+". Reintente!!!")
			return .f.
		endIf		
	endif			
//		if !modificoSaldoFacturaProveedor(reciboProveedor.grid_1.cell(reciboProveedor.grid_1.value[i],1),reciboProveedor.grid_1.cell(reciboProveedor.grid_1.value[i],5))
//				msgInfo("No se pudo Modificar la Factura. Reintente!!!")
//				return .f.
//		endIf
		
next
reciboProveedor.text_1.setfocus

procedure aplicarImporteProveedor()
local nCantidad := len(reciboProveedor.grid_1.value)
local nSaldoEntrega, nImporteEntrega := reciboProveedor.text_4.value

for i= 1 to nCantidad

	if nImporteEntrega >= reciboProveedor.grid_1.cell(reciboProveedor.grid_1.value[i],4)
		reciboProveedor.grid_1.cell(reciboProveedor.grid_1.value[i],5) := reciboProveedor.grid_1.cell(reciboProveedor.grid_1.value[i],4)
    reciboProveedor.grid_1.cell(reciboProveedor.grid_1.value[i],6) := reciboProveedor.grid_1.cell(reciboProveedor.grid_1.value[i],4)-reciboProveedor.grid_1.cell(reciboProveedor.grid_1.value[i],5)
    nImporteEntrega -= reciboProveedor.grid_1.cell(reciboProveedor.grid_1.value[i],5)
  else
  	reciboProveedor.grid_1.cell(reciboProveedor.grid_1.value[i],5) := nImporteEntrega
    reciboProveedor.grid_1.cell(reciboProveedor.grid_1.value[i],6) := reciboProveedor.grid_1.cell(reciboProveedor.grid_1.value[i],4) - nImporteEntrega 
  	exit
  endIf
next


function controloReciboProveedor(cTipoDocumento)
local cDescripcionDocumento :=descripcionDocumento(cTipoDocumento)

if reciboProveedor.text_1.value = 0
	msgInfo("Debe Indicar un Proveedor")
	return .f.
endIf

if reciboProveedor.text_4.value = 0
	msgInfo("Debe Ingresar un Importe Para el "+cDescripcionDocumento)
	return .f.
endIf

if len(reciboProveedor.text_5.value) = 0
	msgInfo("Debe Indicar un Nro de "+cDescripcionDocumento)
	return .f.
endIf

if reciboProveedor.text_11.value != 0
	if len(reciboProveedor.text_10.value) = 0
		msgInfo("Debe Indicar un Nro de "+cDescripcionDocumento)
		return .f.	
	endIf
endIf


if len(reciboProveedor.text_10.value) != 0
	if reciboProveedor.text_11.value = 0
		msgInfo("Debe Ingresar un Importe Para el "+cDescripcionDocumento)
		return .f.
	endif
endIf

//if reciboProveedor.text_8.value = 0
//	msgInfo("Debe Seleccionar una Factura")
//	return .f.
//endIf

return .t.
*************************************************
*************************************************
******Implementaciones del modelo ***************
*************************************************
*************************************************
function guardoCabezalreciboProveedor(nNumero,nProveedor,dFecha,nDocumento,nImporte,cTipoDocumento)
local cQuery, oQuery


cQuery := "insert into recibo_proveedor_cab values("+str(nNumero)+",'"+nDocumento+"',"+str(nProveedor)+", "
cQuery += " '"+dtos(dFecha)+"','"+cTipoDocumento+"',"+str(nImporte)+" , current_timestamp )"

oQuery:= oServer:Query(cQuery) 
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  //si o puedo obtener el id del cabezal anulo todo para atrás
  oQuery:=oServer:Query('ROLLBACK') 
  return .f.
else

	return .t.
endif

function guardoDetallereciboProveedor(nIdRecibo,nFactura,nImporte)
local cQuery, oQuery

cQuery := "insert into recibo_proveedor_det values("+str(nIdRecibo)+","+str(nFactura)+", "
cQuery += " "+str(nImporte)+" )"

oQuery:= oServer:Query(cQuery)
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  //si o puedo obtener el id del cabezal anulo todo para atrás
  oQuery:=oServer:Query('ROLLBACK') 
  return .f.
else
	return .t.
endif

function recibosFacturaProveedor(nFactura)
local cQuery, oQuery

cQuery := "select c.id_recibo, c.fecha,d.descripcion,r.importe "
cQuery := cQuery + " from recibo_proveedor_cab c, documento d, recibo_proveedor_det r"
cQuery := cQuery + " where c.id_recibo = r.id_recibo "
cQuery := cQuery + " and d.id_documento = c.tipo_documento "
cQuery := cQuery + " and r.numero_factura = "+str(nFactura)+" "
cQuery := cQuery + " and c.tipo_documento = 'R' "


oQuery:= oServer:Query(cQuery)
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
endif
return oQuery

function notasCreditoFacturaProveedor(nFactura)
local cQuery, oQuery

cQuery := "select c.id_recibo, c.fecha,d.descripcion,r.importe "
cQuery := cQuery + " from recibo_proveedor_cab c, documento d, recibo_proveedor_det r"
cQuery := cQuery + " where c.id_recibo = r.id_recibo "
cQuery := cQuery + " and d.id_documento = c.tipo_documento "
cQuery := cQuery + " and r.numero_factura = "+str(nFactura)+" "
cQuery := cQuery + " and c.tipo_documento = 'N' "
oQuery:= oServer:Query(cQuery)
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
endif
return oQuery

function notaDevolucionFacturaProveedor(nFactura)
local cQuery, oQuery

cQuery := "select c.id_recibo, c.fecha,d.descripcion,r.importe "
cQuery := cQuery + " from recibo_proveedor_cab c, documento d, recibo_proveedor_det r"
cQuery := cQuery + " where c.id_recibo = r.id_recibo "
cQuery := cQuery + " and d.id_documento = c.tipo_documento "
cQuery := cQuery + " and r.numero_factura = "+str(nFactura)+" "
cQuery := cQuery + " and c.tipo_documento = 'D' "
oQuery:= oServer:Query(cQuery)
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
endif
return oQuery