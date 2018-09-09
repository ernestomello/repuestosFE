#include <hmg.ch>

procedure factCliente(cTipoDocumento,nNumero)
if cajaAbierta()
if !IsWindowActive(factCliente)
	Load Window factCliente
	
	if nNumero != 0
		rellenoFacturaCliente(nNumero)
	endif
	factCliente.label_14.fontcolor := {0,128,0}
	factCliente.text_8.value:= 1
	factCliente.text_14.value := cTipoDocumento
	factCliente.label_14.value := descripcionDocumento(cTipoDocumento)
	factCliente.text_15.value := cajaId()
	factCliente.text_11.value := iif(alltrim(factCliente.text_14.value) == 'C', 50, 0)
	iif(alltrim(factCliente.text_14.value) != 'F',factCliente.text_17.visible := .f.,)
	iif(alltrim(factCliente.text_14.value) != 'F',factCliente.frame_2.visible := .f.,)
	factCliente.Center
	factCliente.Activate	
else
	msginfo("No se puede tener 2 Ventanas Activas")
endif
else
	msgInfo("Caja Cerrada !!!")
endIf       

Return

procedure calculoPrecioFinal()
nPrecioSinDescuento := factCliente.text_8.value * (factCliente.text_9.value * ((100+factCliente.text_16.value)/100))
factCliente.text_12.value := round(nPrecioSinDescuento - (nPrecioSinDescuento * factCliente.text_11.value / 100 ),0)

factCliente.text_12.setfocus

procedure agregoLinea()
local nLinea := 	PARAMETROini("LineasDetalle","N")
local nPrecioSinDescuento := 0

  if (factCliente.text_9.value = 0 .or. factCliente.text_8.value =0)
  	msginfo('La cantidad no puede ser CERO',"ATENCIÓN")
    factCliente.text_8.SetFocus
		Return
  endif
  if factCliente.grid_1.itemCount >= nLinea
  	msginfo('Supera las '+str(nLinea)+' líneas '+chr(13)+'Guarde el Documento')
  	Return
  endif
	if msgYesNo("Ingresa la Línea?","ATENCIÓN",.t.)
    factCliente.grid_1.addItem({factCliente.text_6.value,factCliente.text_7.value,factCliente.text_8.value,factCliente.text_9.value,factCliente.text_10.value,factCliente.text_16.value,factCliente.text_11.value,round(factCliente.text_12.value / (1+(factCliente.text_16.value / 100)),0) })
    factCliente.text_6.value:= ""
    factCliente.text_7.value:=""
    factCliente.text_8.value:= 1
    factCliente.text_9.value:= 0
    factCliente.text_9.fontcolor := {0,0,0}
    factCliente.text_10.value:= ctod("  /  /    ")
    factCliente.text_16.value := 0
    factCliente.text_11.value := iif(alltrim(factCliente.text_14.value) == 'C', 50, 0)
    factCliente.text_12.value := 0
    factCliente.text_20.value := ""
    sumoLineas()
    factCliente.text_6.SetFocus
  endif

 

return


procedure borroLinea()

factCliente.grid_1.deleteItem(factCliente.grid_1.value)
sumoLineas()
factCliente.text_6.SetFocus
  
return


procedure sumoLineas()
private cantItem
private i
  
  cantItem:= factCliente.grid_1.itemcount
  factCliente.text_5.value:=0
  for i=1 to cantItem
	 
   factCliente.text_5.value:= factCliente.text_5.value + round((factCliente.grid_1.item(i)[8]) * (1 + factCliente.grid_1.item(i)[6]/100),0)
  
  next

return

procedure cereoFormulario()

factCliente.text_1.value:= 0
factCliente.text_2.value:= ''
factCliente.text_3.value:=''
factCliente.text_4.value:=''
factCliente.text_5.value:=0
factCliente.text_8.value:= 1
factCliente.text_9.value:= 0
factCliente.text_9.fontcolor := {0,128,0}

factCliente.text_10.value:= ctod("  /  /    ")
factCliente.text_11.value := iif(alltrim(factCliente.text_14.value) == 'C', 50, 0)
factCliente.text_12.value := 0
factCliente.text_13.value:=''
factCliente.text_16.value := 0
factCliente.text_17.value := 0
factCliente.text_18.value := 0
factCliente.text_19.value := ''
factCliente.text_20.value := ''


factCliente.grid_1.deleteAllItems
return

procedure vacioDatosSociofactCliente()
factCliente.text_1.value := 0
factCliente.text_2.value := ''
factCliente.text_3.value := ''
factCliente.text_4.value := ''
factCliente.text_13.value := ''
factCliente.text_5.value := 0
factCliente.text_17.value := 0

procedure verificoPrecio()

factCliente.text_9.fontcolor := {0,0,0}
if monedaArticulo(factCliente.text_6.value)!= 2
	if precioVenta(factCliente.text_6.value) != factCliente.text_9.value
		modificoPrecioVenta(factCliente.text_6.value, factCliente.text_9.value)
		factCliente.text_10.value := fechaPrecio(factCliente.text_6.value)
	endif
else
	
endif

factCliente.text_16.SetFocus

function cambio_Moneda()


factCliente.text_9.value := busco_cotizacion(monedaArticulo(factCliente.text_6.value)) * precioVenta(factCliente.text_6.value)
 
factcliente.text_9.setfocus

function grabaFactura()
local nCliente, cTipoDocumento,dFechaFactura,nTotalFactura,cDescripcion,nCaja,nNumero
local nCantidad := factCliente.grid_1.itemcount

nCliente:= factCliente.text_1.value  
cTipoDocumento := factCliente.text_14.value
dFechaFactura := factCliente.datePicker_1.value
nTotalFactura:= factCliente.text_5.value
cDescripcion :=factCliente.text_13.value
nCaja := cajaId()
nVendedor := factCliente.text_18.value

	


if !controloFactCliente()
	return .f.
endif	

if !msgYesNo("Graba la Factura?","ATENCIÓN",.t.)
	return .f.
endif

if !comienzoTransaccion()
	msginfo("No se pudo guardar. REINTENTE! ! !")
	return .f.
endIf

nNumero:= numeroDesde('CLIENTE')  	

if !agregoNumeroDesde('CLIENTE')
	msginfo("No se pudo actualizar el Número de la Factura")
	return .f.
endIf


if nNumero == 0
	msgInfo("No se pudo Guardar el Número. Reintente!!!")
	return .f.
endif




if !graboFactClienteCabezal(nNumero ,nCaja,nCliente, cTipoDocumento,;
														nTotalFactura,dFechaFactura,cDescripcion,nVendedor)
  msgInfo('No se pudieron grabar los datos, REINTENTE!!!')
	return .f.
endIf
//nFactura := ultimoId()
//if nFactura = 0
//	msgInfo("No se pudo Guardar el id. Reintente!!!")
//	return .f.
//endIf
if facturaClienteConDetalle()
	
	for i=1 to nCantidad
			cCodigo := factCliente.grid_1.cell(i,1)
			nCantidadArt := factCliente.grid_1.cell(i,3)
			nPrecioUnitario := factCliente.grid_1.cell(i,4)
			nIva := factCliente.grid_1.cell(i,6)
			nDto := factCliente.grid_1.cell(i,7)
			nImporte := factCliente.grid_1.cell(i,8)
			if !graboFactClienteDetalle(nNumero ,i,cCodigo,nCantidadArt,nPrecioUnitario,;
																	nIva,nDto,nImporte)
				msgInfo("No se pudieron Guardar el detalle de la Factura. Reintente!!!")
				return .f.
			endIf
	next

endIf


finTransaccion()
if alltrim(factCliente.text_14.value) = 'C'
	if factCliente.text_1.value = 0
		imprimoMovimiento(nNumero,0,factCliente.text_2.value,factCliente.text_3.value,factCliente.text_4.value)
	else
		imprimoMovimiento(nNumero,0,'','','')
	endif

else
	imprimoMovimiento(nNumero,0,'','','')
endif

//factCliente.grid_1.deleteAllItems
cereoFormulario()
//vacioDatosSociofactCliente()
factCliente.text_1.SetFocus
return .t.



function controloFactCliente()

if alltrim(factCliente.text_14.value) == 'F'
	if factCliente.text_1.value = 0
		msgBox("Falta Ingresar un Cliente")
		factCliente.text_1.SetFocus
		return .f.
	endIf
endIf

if factCliente.grid_1.itemcount = 0
	msgBox("Ingrese Lineas con Codigos")
	factCliente.text_6.SetFocus
	return .f.
endIf

if factCliente.text_5.value  = 0
	msgBox("Importe Total NO puede ser CERO")
	factCliente.text_6.SetFocus
	return .f.
endIf

if factCliente.text_18.value  = 0
	msgBox("Ingrese un Numero de Vendedor")
	factCliente.text_18.SetFocus
	return .f.
endIf

if len(factCliente.text_13.value)  < 4 .and. alltrim(factCliente.text_14.value) = 'F'
	msgBox("Ingrese un Comentario")
	factCliente.text_18.SetFocus
	return .f.
endIf

return .t.
procedure buscoClientes(nCliente)
vacioDatosSociofactCliente()

	
	  if existeCliente(nCliente)
	  		if !clienteCancelado(nCliente) 
	  		 if factcliente.text_14.value != 'C'
	  		 	if clienteHabilitado(nCliente)
				    rellenoDatosfactCliente(nCliente)
				    factCliente.text_18.SetFocus
				    nSocioGlobal := 0
				  else
				  	msginfo("No permite Facturar")
					endif
			  	else
			  		rellenoDatosfactCliente(nCliente)
				    factCliente.text_18.SetFocus
				    nSocioGlobal := 0
			  	endif
			  else
			  	MsGInfo(nombreCliente(nCliente))
			  endIf
	  else
	    
		  iif(factcliente.text_14.value = 'C', buscoClienteM('cc',"","Clientes",2),buscoClienteM('cf',"","Clientes",1))
	    
	       
		      if nSocioGlobal != 0
		        	if !clienteCancelado(nSocioGlobal)
		        		if clienteHabilitado(nSocioGlobal)
				        	rellenoDatosfactCliente(nsocioGlobal)      
				        	factCliente.text_18.SetFocus
				        	nSocioGlobal := 0
			        	else
				  				msginfo("No permite Facturar")
								endif
			        else
			        	msginfo(nombreCliente(nSocioGlobal))
			        endIf
		      endIf
	  endif
	
return

procedure buscarVendedor()
local nVendedor := factCliente.text_18.value

if existeUsuario(nVendedor)
	factCliente.text_19.value := nombreUsuario(nVendedor)
	factCliente.text_18.value := nVendedor
	factCliente.text_6.SetFocus
else

	busquedaGeneral('u',"","Usuarios",1)
	if nSocioGlobal != 0
			factCliente.text_19.value := nombreUsuario(nSocioGlobal)
			factCliente.text_18.value := nSocioGlobal
			factCliente.text_6.SetFocus
			nSocioGlobal := 0
	endIf
endif

procedure rellenoDatosfactCliente(nCliente)

factCliente.text_1.value := nCliente
factCliente.text_2.value := rutCliente(nCliente)
factCliente.text_3.value := nombreCliente(nCliente)
factCliente.text_4.value := dirParticularCliente(nCliente)
iif(alltrim(factCliente.text_14.value) == 'F',factCliente.text_17.value := saldoEntreFechasCliente(nCliente,ctod('01/01/1980'),factCliente.datePicker_1.value),)


return

procedure rellenoDatosLinea(nArticulo)

factCliente.text_6.value := codigoBarraArticulo(nArticulo)
factCliente.text_7.value := descripcionArticulo(nArticulo)+"-"+locacionArticulo(nArticulo)
factCliente.text_9.value := precioVenta(nArticulo)
iif (monedaArticulo(nArticulo)= 2,factCliente.text_9.fontcolor := {0,128,0},factCliente.text_9.fontcolor := {0,0,0})
factCliente.text_10.value := fechaPrecio(nArticulo)
factCliente.text_16.value := iva(nArticulo)
factCliente.text_20.value := str(id_proveedor(nArticulo))+" - "+alltrim(nombreProveedor(id_proveedor(nArticulo)))
factCliente.text_8.SetFocus





procedure buscoArticulos(nArticulo)
local i
local cCompu := 	PARAMETROini("Computadora","C")

if existeArticulo(nArticulo) .and. len(nArticulo) != 0
  rellenoDatosLinea(nArticulo)
  factCliente.text_8.setFocus
  cArticuloGlobal := ""
else
	factCliente.text_6.setFocus
  if cCompu =='BAJA' 
  	busquedaGeneral('a',"","Repuestos",1)
  else
  	buscoPrecio()
  endif
  
  if len(alltrim(cArticuloGlobal)) != 0
    rellenoDatosLinea(cArticuloGlobal)
    factCliente.text_8.setFocus
    cArticuloGlobal := ""
  endIf
 // 099672077 julieta apratto
endif
return

procedure rellenoFacturaCliente(nFactura)
local oCabezal := facturaClienteCabezal(nFactura)
local oDetalle := facturaClienteDetalle(nFactura)
local nTotalFactura := 0

factCliente.text_1.value := oCabezal:getrow(1):fieldget(3)
factCliente.datePicker_1.value := date() //oCabezal:getrow(1):fieldget(2)
rellenoDatosfactCliente(factCliente.text_1.value)
factCliente.text_13.value := descripcionFacturaCliente(nFactura)

for i= 1 to oDetalle:lastRec()
	factCliente.grid_1.addItem({oDetalle:getrow(i):fieldGet(3), ;
															oDetalle:getrow(i):fieldGet(4), ; 
															oDetalle:getrow(i):fieldGet(5), ; 
															oDetalle:getrow(i):fieldGet(6), ; 
															oDetalle:getrow(i):fieldGet(7), ;
															oDetalle:getrow(i):fieldGet(8), ; 
															oDetalle:getrow(i):fieldGet(9), ; 
															oDetalle:getrow(i):fieldGet(10)})
	
	//nTotalFactura += oDetalle:getrow(i):fieldGet(10)														
									nTotalFactura += round(oDetalle:getrow(i):fieldGet(10) * (1 + oDetalle:getrow(i):fieldGet(8)/100),0)
next
factCliente.text_5.value := nTotalFactura

function facturaClienteConDetalle()
return .t.

function anularFactura(nFactura,nCajero)
if facturaSinRecibos(nFactura)
	anuloFactura(nFactura,nCajero)
	msgInfo('Documento No.'+str(nFactura)+' Anulado')
else
		msgBox("La factura tiene documentos Asociados, NO se puede anular")
endif





*************************************************
*************************************************
******Implementaciones del modelo ***************
*************************************************
*************************************************

function graboFactClienteCabezal(nNumero,nCaja,nCliente, cTipoDocumento,nImporte,dFechaFactura,cDescripcion,nVendedor)
local cQuery, oQuery

	  
cQuery := " Insert into factura_cliente_cab values "
cQuery += " ("+str(nNumero)+","+str(nCaja)+", '"+dtos(dFechaFactura)+"', " 
cQuery += " "+str(nCliente)+",'"+cTipoDocumento+"',"+str(nVendedor)+", "+str(nImporte)+" , "
iif(cTipoDocumento != 'C', cQuery += "  "+str(nImporte)+",  ", cQuery += " 0 ,")
cQuery += " '"+cDescripcion+"' , current_timestamp , 'N' ,null , null)"

oQuery:= oServer:Query(  cQuery )
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  oQuery:=oServer:Query('ROLLBACK') 
  return .f.    
else
	
	return .t.
endIf
	 
function graboFactClienteDetalle(nNumero,nItem,cCodigo,nCantidad,nPrecioUnitario,nIva,nDto,nImporte)
local cQuery,oQuery

cQuery := " insert into factura_cliente_det values( " 
cQuery += " "+str(nNumero)+", "+str(nItem)+", '"+cCodigo+"' , "
cQuery += " "+str(nCantidad)+","+str(nPrecioUnitario)+" , "
cQuery += " "+str(nIva)+","+str(nDto)+" , "
cQuery += " "+str(nImporte)+" )"

oQuery := oServer:Query(cQuery)
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  //si no puedo guardar alguna de las lìneas anulo todo para atrás
  oQuery:=oServer:Query('ROLLBACK') 
  return .f.
else
	return .t.
endIf
	 

function facturaClienteCabezal(nFactura)
local cQuery, oQuery

cQuery := " select numero_factura,fecha,id_cliente,tipo_documento,descripcion " 
cQuery += " from factura_cliente_cab "
cQuery += " where numero_factura = "+str(nFactura)+" "

oQuery:= oServer:Query(cQuery)

If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
endif
return oQuery

function facturaClienteDetalle(nFactura)
local cQuery, oQuery

cQuery := " select d.numero_factura,d.item, d.codigo_barra,a.descripcion, d.cantidad, "
cQuery += " d.precio_unitario,a.fecha_precio, d.iva, d.descuento, d.importe "
cQuery += " from factura_cliente_cab c, factura_cliente_det d, articulo a "
cQuery += " where c.numero_factura = d.numero_factura "
cQuery += " and c.numero_factura = "+str(nFactura)+" "
cQuery += " and a.codigo_barra = d.codigo_barra "
cQuery += " order by 2"
oQuery:= oServer:Query(cQuery)

If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
endif
return oQuery



*****************************************************
* Anula el movimiento 
* deja registrado que cajero hizo la transaccion
*****************************************************
function anuloFactura(nFactura,nCajero)
local cQuery
local oQuery

oQuery:= oServer:Query( 'BEGIN' ) //comienzo la transacción
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

oQuery:= oServer:Query( 'COMMIT' ) 
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  oQuery:=oServer:Query('ROLLBACK') 
  return .f.
EndIf
return .t.



function facturasCliente(nCliente)
local cQuery
local oQuery

cQuery := " select numero_factura, fecha,importe, saldo "
cQuery += " from factura_cliente_cab "
cQuery += " where id_cliente = "+str(nCliente)+" "
cQuery += " and saldo != 0 "
cQuery += " and anulado = 'N' "
cQuery += " and tipo_documento = 'F' "
oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery
endIf

function detalleFacturaCliente(nFactura)
local cQuery
local oQuery

cQuery := "select  a.descripcion,d.cantidad,d.precio_unitario,d.iva,d.descuento,d.importe,d.codigo_barra "
cQuery += " from factura_cliente_cab c, factura_cliente_det d, articulo a "
cQuery += " where c.numero_factura = d.numero_factura"
cQuery += " and a.codigo_barra = d.codigo_barra "
cQuery += " and c.numero_factura = "+str(nFactura)+" "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery
endIf

function modificoSaldoFacturaCliente(nFactura,nImporte)
local cQuery, oQuery

cQuery := " update factura_cliente_cab set saldo = saldo - "+str(nImporte)+" "
cQuery += " where numero_factura = "+str(nFactura)+" "

oQuery:= oServer:Query(cQuery)
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  oQuery:=oServer:Query('ROLLBACK') 
  return .f.
else
	return .t.
endif

function saldoFactura(nFactura)
local cQuery, oQuery

cQuery := " select saldo from factura_cliente_cab "
cQuery += "where numero_factura = "+str(nFactura)+"  "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:getRow(1):fieldGet(1)
endIf


function fechaUltimaFacturaCliente(nCliente)
local cQuery, oQuery

cQuery := " SELECT fecha FROM comercio.factura_cliente_cab "
cQuery += " where id_cliente = "+str(nCliente)+" "
cQuery += " order by fecha desc  limit 1 "
oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:getRow(1):fieldGet(1)
endIf

function fechaFacturaCliente(nFactura)
local cQuery
local oQuery

cQuery := " select fecha "
cQuery += " from factura_cliente_cab  "
cQuery += " where numero_factura = "+str(nFactura)+" "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:getRow(1):fieldGet(1)
endIf

function descripcionFacturaCliente(nFactura)
local cQuery
local oQuery

cQuery := " select descripcion "
cQuery += " from factura_cliente_cab  "
cQuery += " where numero_factura = "+str(nFactura)+" "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:getRow(1):fieldGet(1)
endIf

function clienteFactura(nFactura)
local cQuery
local oQuery

cQuery := "select id_cliente from factura_cliente_cab m "
cQuery += " where numero_factura = "+str(nFactura)+"  "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:getRow(1):fieldGet(1)
endIf

function idMovFActuraCliente(nFactura)
local cQuery
local oQuery

cQuery := "select id_mov from factura_cliente_cab m "
cQuery += " where numero_factura = "+str(nFactura)+"  "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:getRow(1):fieldGet(1)
endIf

function saldoEntreFechasCliente(nCliente,dFechaDesde,dFechaHasta)
local cQuery,oQuery

cQuery := " select "
cQuery += " (SELECT ifnull(sum(importe),0) FROM factura_cliente_cab "
cQuery += " where id_cliente = "+str(nCliente)+" "
cQuery += " and tipo_documento not in ('P','C','D') "
cQuery += " and fecha between '"+dtos(dFechaDesde)+"' and '"+dtos(dFechaHasta)+"' "
cQuery += " and anulado = 'N' ) "
cQuery += " - (select ifnull(sum(importe),0) from recibo_cliente_cab "
cQuery += " where id_cliente = "+str(nCliente)+" "
cQuery += " and fecha between '"+dtos(dFechaDesde)+"' and '"+dtos(dFechaHasta)+"' "
cQuery += " and anulado = 'N' ) "
cQuery += " -(SELECT ifnull(sum(importe),0) FROM factura_cliente_cab "
cQuery += " where id_cliente = "+str(nCliente)+" "
cQuery += " and tipo_documento ='D' "
cQuery += " and fecha between '"+dtos(dFechaDesde)+"' and '"+dtos(dFechaHasta)+"'  "
cQuery += " and anulado = 'N' ) "
oQuery:= oServer:Query(cQuery)
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
endif
return oQuery:getRow(1):fieldGet(1)

function saldoFacturas(ncliente,dFecha)
local cQuery,oQuery

cQuery := " SELECT ifnull(sum(saldo),0) FROM factura_cliente_cab "
cQuery += " where id_cliente = "+str(nCliente)+" "
cQuery += " and tipo_documento = 'F' "
cQuery += " and anulado = 'N' "
cQuery += " and fecha <= '"+dtos(dFecha)+"' "

oQuery:= oServer:Query(cQuery)
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
endif
return oQuery:getRow(1):fieldGet(1)



function saldoPresupuestoCliente(nCliente,dFechaDesde,dFechaHasta)
local cQuery,oQuery

cQuery := " SELECT ifnull(sum(saldo),0) FROM factura_cliente_cab "
cQuery += " where id_cliente = "+str(nCliente)+" "
cQuery += " and tipo_documento = 'P' "
cQuery += " and fecha between '"+dtos(dFechaDesde)+"' and '"+dtos(dFechaHasta)+"' "

oQuery:= oServer:Query(cQuery)
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
endif
return oQuery:getRow(1):fieldGet(1)

function presupuestosCliente(nCliente,dFechaDesde,dFechaHasta)
local cQuery, oQuery

cQuery := " select numero_factura, fecha,'Presupuesto',importe,0,saldo "
cQuery += " from factura_cliente_cab "
cQuery += " where id_cliente = "+str(nCliente)+" "
cQuery += " and fecha between '"+dtos(dFechaDesde)+"' and '"+dtos(dFechaHasta)+"' "
cQuery += " and tipo_documento = 'P' "
cQuery += " order by 2  "

oQuery:= oServer:Query(cQuery)
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
endif
return oQuery

function totalFacturaCaja(cDocumento, nCaja)
local cQuery, oQuery

cQuery := " select id_caja, sum(importe) "
cQuery += " from factura_cliente_cab "
cQuery += " where tipo_documento = '"+cDocumento+"' "
cQuery += " and anulado = 'N' "
cQuery += " and id_caja = "+str(nCaja)+" "
cQuery += " group by 1  "

oQuery:= oServer:Query(cQuery)
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
endif
return oQuery:getRow(1):fieldGet(2)

function vendedorFacturaCliente(nFactura)
local cQuery,oQuery

cQuery := " select id_usuario "
cQuery += " from factura_cliente_cab "
cQuery += " where numero_factura = "+str(nFactura)+" "
oQuery:= oServer:Query(cQuery)
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
endif
return oQuery:getRow(1):fieldGet(1)

function facturaSinRecibos(nFactura)
local cQuery,oQuery

cQuery := " select c.id_recibo "
cQuery += " from recibo_cliente_det d, recibo_cliente_cab c "
cQuery += " where numero_factura = "+str(nFactura)+" "
cQuery += " and c.id_recibo = d.id_recibo "
cQuery += " and c.anulado != 'S' "

oQuery:= oServer:Query(cQuery)
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
endif

if oQuery:lastRec() > 0
	return .f.
else
	return .t.
endif

function facturaSinDevolucion(nFactura)
local oQuery, cQuery

cQuery := " select * from factura_notacredito "
cQuery += " where numero_factura = "+str(nFactura)+" "

oQuery:= oServer:Query(cQuery)
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
endif

if oQuery:lastrec() > 0
	return .f.
else
	return .t.
endIf