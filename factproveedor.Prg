#include <hmg.ch>
procedure factProveedor()

 Load Window factProveedor
 vacioDatosfactProveedor()
 //factProveedor.text_15.value := cajaId()
 factProveedor.Center
 factProveedor.Activate

Return

procedure buscoProveedores(nProveedor)
vacioDatosfactProveedor()

	
	  if existeProveedor(nProveedor)
			    rellenoDatosfactProveedor(nProveedor)
			    factProveedor.text_2.SetFocus
			    nSocioGlobal := 0
	  else
	    
	      busquedaGeneral('p','','Proveedores',1)
	    
	       
		      if nSocioGlobal != 0
	        	rellenoDatosfactProveedor(nsocioGlobal)      
	        	factProveedor.text_2.SetFocus
	        	nSocioGlobal := 0
		      endIf
	  endif
	
return

procedure rellenoDatosfactProveedor(nProveedor)

factProveedor.text_1.value := nProveedor

factProveedor.label_1.value := signoMOneda(monedaProveedor(nProveedor))
factProveedor.text_3.value := nombreProveedor(nProveedor)


return

procedure vacioDatosfactProveedor()

factProveedor.text_1.value := 0

factProveedor.text_3.value := ""

factProveedor.text_5.value := 0
factProveedor.text_6.value := 0
factProveedor.label_1.value := ""
factProveedor.text_2.value := ctod("00/00/0000")

procedure grabaFacturaProveedor()
local nProveedor, cTipoDocumento

nProveedor:= factProveedor.text_1.value
cTipoDocumento := 'F'

nNumero:= numeroDesde('PROVEEDOR')  	

if !agregoNumeroDesde('PROVEEDOR')
	msginfo("No se pudo actualizar el Número de la Factura")
	return .f.
endIf  	

if controloFactProveedor()
	if msgyesNo("Graba la Factura?","ATENCIÓN",.T.)
	  if !graboFactProveedor(nNumero,nProveedor, cTipoDocumento,factProveedor.text_6.value, factProveedor.text_5.value,factProveedor.text_2.value)
	    msgInfo('No se pudieron grabar los datos, REINTENTE!!!')
	  else
	  	vacioDatosfactProveedor()
	  endIf
	endIf
endIf
factProveedor.text_1.SetFocus

return nil

function controloFactProveedor()

if factProveedor.text_5.value = 0
	msgInfo("El importe no puede ser CERO")
	return .f.
endIf

if factProveedor.text_6.value = 0
	msgInfo("Debe Ingresar un Número de factura")
	return .f.
endIf

if factProveedor.text_1.value = 0
	msgInfo("Indique un Proveedor")
	return .f.
endIf

return .t.

*************************************************
*************************************************
******Implementaciones del modelo ***************
*************************************************
*************************************************
function graboFactProveedor(nNumeroF,nProveedor, cTipoDocumento,nNumero,nImporte,dFechaFactura)
// hay que modificar esta función porque está muy entreverada hay dominios cruzados :(
local idMov,nCajero,nLinea, cSerie, nCaja

nCaja := cajaId()
nNumero:= nNumero

//comienzo la transacción
oQuery:= oServer:Query( 'BEGIN' ) 
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  //si no puede hacer el comienzo de la transaccion cancelo
  oQuery:=oServer:Query('ROLLBACK') 
  return .f.
endIf

//cabezal movimiento
	  
cQuery := "Insert into factura_proveedor_cab values "
cQuery += " ( "+str(nNumeroF)+","+str(nCaja)+" ,"+str(nNumero)+", '"+dtos(dFechaFactura)+"', " 
cQuery += " "+str(nProveedor)+",'"+cTipoDocumento+"', "+str(nImporte)+", "
iif(cTipoDocumento = 'F', cQuery += " "+str(nImporte)+",  ", cQuery += " 0, ")
cQuery += " null, current_timestamp ) "
oQuery:= oServer:Query(  cQuery )
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  //si no puede guardar el cabezal anulo todo(incluido el número de factua)
  oQuery:=oServer:Query('ROLLBACK') 
  return .f.    
endIf

/*
Falta modificar el detalle de la factura para los proveedores

if facturaProveedorConDetalle()	 
	oQuery:= oServer:Query( 'select LAST_INSERT_ID()')
	If oQuery:NetErr() 
	  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
	  //si o puedo obtener el id del cabezal anulo todo para atrás
	  oQuery:=oServer:Query('ROLLBACK') 
	  return .f.
	endif

	//detalle movimiento   
	idMov := oQuery:GetRow(1):fieldGet(1)
	
	for i:= 1 to factCliente.grid_1.itemCount
	
	  fechaPago := date()
	  cQuery:= "insert into factura_proveedor_det values( " 
	  cQuery:= cQuery +" "+str(idMov)+", "+str(i)+", '"+factCliente.grid_1.item(i)[1]+"' , "
	  cQuery:= cQuery + " "+str(factCliente.grid_1.item(i)[3])+","+str(factCliente.grid_1.item(i)[4])+" , "
	  cQuery:= cQuery + " "+str(factCliente.grid_1.item(i)[6])+","+str(factCliente.grid_1.item(i)[7])+" , "
	  cQuery:= cQuery + " "+str(factCliente.grid_1.item(i)[8])+" )"
	  
	  oQuery := oServer:Query(cQuery)
	  If oQuery:NetErr() 
	    MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
	    //si no puedo guardar alguna de las lìneas anulo todo para atrás
	    oQuery:=oServer:Query('ROLLBACK') 
	    return .f.
	  endIf
	 
	next

endIf
*/

//si llega acà es porque pudo hacer todos los insert comiteo las transacciones
//agregoNumeroDesde()
oQuery:= oServer:Query('COMMIT')
return .t.

function facturaProveedorConDetalle()

return .f.

function facturasProveedor(nProveedor,dFechaDesde,dFechaHasta)
local cQuery
local oQuery

cQuery := "select numero_factura, fecha,importe,id_mov "
cQuery += " from factura_proveedor_cab "
cQuery += " where id_proveedor = "+str(nProveedor)+" "
//cQuery += " and saldo != 0 "
cQuery += " and  fecha between '"+dtos(dFechaDesde)+"' and '"+dtos(dFechaHasta)+"'"
cQuery += " order by fecha"




oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery
endIf


function notaFacturaProveedor(nFactura)
local cQuery,oQuery

cQuery := " select numero_recibo "
cQuery += " from recibo_proveedor_cab c, recibo_proveedor_det d "
cQuery += " where c.id_recibo = d.id_recibo "
cquery += "and tipo_documento = 'N'  "
cQuery += " and d.numero_factura = "+str(nFactura)+""

oQuery:= oServer:Query(cQuery)
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  return "Error"
endif
if oQuery:lastrec() > 0
	return str(oQuery:getRow(1):fieldGet(1))
else
	return "No Tiene"
endif

function devolucionFacturaProveedor(nFactura)
local cQuery,oQuery

cQuery := " select numero_recibo "
cQuery += " from recibo_proveedor_cab c, recibo_proveedor_det d "
cQuery += " where c.id_recibo = d.id_recibo "
cquery += " and tipo_documento = 'D'  "
cQuery += " and d.numero_factura = "+str(nFactura)+""

oQuery:= oServer:Query(cQuery)
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  return "Error"
endif
if oQuery:lastrec() > 0
	return str(oQuery:getRow(1):fieldGet(1))
else
	return "No Tiene"
endif


function modificoSaldoFacturaProveedor(nFactura,nImporte)
local cQuery, oQuery

cQuery := "update factura_proveedor_cab set saldo = saldo - "+str(nImporte)+" "
cQuery := cQuery + "  where numero_factura = "+str(nFactura)+" "

oQuery:= oServer:Query(cQuery)
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  //si o puedo obtener el id del cabezal anulo todo para atrás
  oQuery:=oServer:Query('ROLLBACK') 
  return .f.
else
	return .t.
endif

function saldoEntreFechasProveedor(nProveedor,dFechaDesde,dFechaHasta)
local cQuery,oQuery

cQuery := " select "
cQuery := cQuery + " (SELECT ifnull(sum(importe),0) FROM factura_proveedor_cab "
cQuery := cQuery + " where id_proveedor = "+str(nProveedor)+" "
cQuery := cQuery + " and fecha between '"+dtos(dFechaDesde)+"' and '"+dtos(dFechaHasta)+"' ) "
cQuery := cQuery + " - (select ifnull(sum(importe),0) from recibo_proveedor_cab "
cQuery := cQuery + " where id_proveedor = "+str(nProveedor)+" "
cQuery := cQuery + " and fecha between '"+dtos(dFechaDesde)+"' and '"+dtos(dFechaHasta)+"' ) "

oQuery:= oServer:Query(cQuery)
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
endif
return oQuery:getRow(1):fieldGet(1)

function documentosProveedor(nProveedor,dFechaDesde,dFechaHasta)
local cQuery, oQuery

cQuery := " select r.id_mov, r.numero_factura, r.fecha,d.descripcion,r.importe, 0,r.saldo "
cQuery += " from factura_proveedor_cab r,documento d"
cQuery += " where id_proveedor = "+str(nProveedor)+" "
cQuery += " and d.id_documento = r.tipo_documento "
cQuery += " and fecha between '"+dtos(dFechaDesde)+"' and '"+dtos(dFechaHasta)+"' "
cQuery += " and tipo_documento = 'F' "
cQuery += " union all "
cQuery += " select r.id_recibo, r.numero_recibo, r.fecha,d.descripcion,0,r.importe,0 "
cQuery += " from recibo_proveedor_cab r, documento d"
cQuery += " where id_proveedor = "+str(nProveedor)+" "    
cQuery += " and d.id_documento = r.tipo_documento "
cQuery += " and fecha between '"+dtos(dFechaDesde)+"' and '"+dtos(dFechaHasta)+"' "
cQuery += " and tipo_documento = 'R' "
cQuery += " union all "
cQuery += " select r.id_recibo, r.numero_recibo, r.fecha,d.descripcion,0,r.importe,0 "
cQuery += " from recibo_proveedor_cab r,documento d"
cQuery += " where id_proveedor = "+str(nProveedor)+" "
cQuery += " and d.id_documento = r.tipo_documento "
cQuery += " and fecha between '"+dtos(dFechaDesde)+"' and '"+dtos(dFechaHasta)+"' "
cQuery += " and tipo_documento = 'N' "
cQuery += " union all "
cQuery += " select r.id_recibo, r.numero_recibo, r.fecha,d.descripcion,0,r.importe,0 "
cQuery += " from recibo_proveedor_cab r,documento d "
cQuery += " where id_proveedor = "+str(nProveedor)+" "
cQuery += " and d.id_documento = r.tipo_documento "
cQuery += " and fecha between '"+dtos(dFechaDesde)+"' and '"+dtos(dFechaHasta)+"' "
cQuery += " and tipo_documento = 'D' "
cQuery += " order by 3 "
        
        
oQuery:= oServer:Query(cQuery)
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
endif
return oQuery


function reciboFacturaProveedor(nFactura)
local cQuery,oQuery

cQuery := " select numero_recibo "
cQuery += " from recibo_proveedor_cab c, recibo_proveedor_det d "
cQuery += " where c.id_recibo = d.id_recibo "
cquery += " and tipo_documento = 'R'  "
cQuery += " and d.numero_factura = "+str(nFactura)+""

oQuery:= oServer:Query(cQuery)
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  return "Error"
endif
if oQuery:lastrec() > 0
	return str(oQuery:getRow(1):fieldGet(1))
else
	return "No Tiene"
endif


function detalleFacturaProveedor(nFactura)
local cQuery
local oQuery

cQuery := "select  1,d.cantidad,d.precio_unitario,d.iva,d.descuento,d.importe,d.codigo_barra "
cQuery += " from factura_proveedor_cab c, factura_proveedor_det d "
cQuery += " where c.id_mov = d.id_mov"
cQuery += " and c.numero_factura = "+str(nFactura)+" "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery
endIf