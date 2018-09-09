#include <hmg.ch>

procedure muestroDocumentoCliente(nDocumento)
local cTipoDoc := tipoDocumento(nDocumento)


do case
	case cTipoDoc == 'F'
		if !IsWindowActive(documento)
			load window documento
			cargoFacturaCreditoCliente(nDocumento)
			documento.center
			documento.activate
		else
			msgInfo("La ventana ya está en uso")
		endif
	case cTipoDoc == 'R'
		if !IsWindowActive(recibo)
				cargoDocumentoGen(nDocumento, "MOSTRAR")
		else
			msgInfo("La ventana ya está en uso")
		endif
	case cTipoDoc == 'N'
		if !IsWindowActive(recibo)
			cargoDocumentoGen(nDocumento, "MOSTRAR")
		else
			msgInfo("La ventana ya está en uso")
		endif
			case cTipoDoc == 'D'
		if !IsWindowActive(recibo)
				cargoDocumentoGen(nDocumento, "MOSTRAR")
		else
			msgInfo("La ventana ya está en uso")
		endif
		case cTipoDoc == 'P'
		if !IsWindowActive(recibo)
				cargoDocumentoGen(nDocumento, "MOSTRAR")
		else
			msgInfo("La ventana ya está en uso")
		endif
end case


procedure muestroDocumentoProveedor(nDocumento)
local cTipoDoc := tipoDocumentoProveedor(nDocumento)
do case
	case cTipoDoc == 'F'
		if !IsWindowActive(documento)
			load window documento
			cargoFacturaCreditoProveedor(nDocumento)
			documento.center
			documento.activate
		else
			msgInfo("La ventana ya está en uso")
		endif
	case cTipoDoc == 'R'
		if !IsWindowActive(recibo)
			load window recibo
			cargoReciboProveedor(nDocumento)
			recibo.center
			recibo.activate
		else
			msgInfo("La ventana ya está en uso")
		endif
	case cTipoDoc == 'N'
		if !IsWindowActive(recibo)
			load window recibo
			cargoNotaCreditoProveedor(nDocumento)
			recibo.center
			recibo.activate
		else
			msgInfo("La ventana ya está en uso")
		endif
end case
//cargoDatosDocumentoCliente(cTipoDoc, nDocumento)



procedure cargoDatosDocumentoCliente(cTipoDoc,nDocumento)


do case

	case cTipoDoc == 'F'
		cargoFacturaCreditoCliente(nDocumento)
	case cTipoDoc == 'R'
		cargoReciboCliente(nDocumento)
	case cTipoDoc == 'N'
		cargoNotaCreditoCliente(nDocumento)

end case 

procedure cargoFacturaCreditoCliente(nDocumento)
local oDetalleFactura := detalleFacturaCliente(nDocumento)
local oRecibos := recibosFacturaCliente(nDocumento)
local oNotasCredito := notasCreditoFacturaCliente(nDocumento)
local oDevolucion := notasDevolucionFacturaCliente(nDocumento)
local nTotFactura := 0

documento.label_1.value := str(nDocumento)+" - "+alltrim(nombreCliente(clienteFactura(nDocumento)))+" - "+dtoc(fechaFacturaCliente(nDocumento))+"- - - - Observacion: "+descripcionFacturaCliente(nDocumento)

for i = 1 to oDetalleFactura:lastrec()
	oRow := oDetalleFactura:getRow(i)
	documento.grid_1.additem({ oRow:fieldGet(7),oRow:fieldGet(1),oRow:fieldGet(2),oRow:fieldGet(3),oRow:fieldGet(4),oRow:fieldGet(5),oRow:fieldGet(6)  })
	nTotFactura += round(oRow:fieldGet(6) * (1 + oRow:fieldGet(4)/100),0)
next
	documento.text_1.value := nTotFactura
for i = 1 to oRecibos:lastrec()
	oRow := oRecibos:getRow(i)
	documento.grid_2.additem({ oRow:fieldGet(1),oRow:fieldGet(2),oRow:fieldGet(3),oRow:fieldGet(4) })
next

for i = 1 to oNotasCredito:lastrec()
	oRow := oNotasCredito:getRow(i)
	documento.grid_3.additem({ oRow:fieldGet(1),oRow:fieldGet(2),oRow:fieldGet(3),oRow:fieldGet(4) })
next

for i = 1 to oDevolucion:lastrec()
	oRow := oDevolucion:getRow(i)
	documento.grid_3.additem({ oRow:fieldGet(1),oRow:fieldGet(2),oRow:fieldGet(3),oRow:fieldGet(4) })
next

Procedure cargoReciboCliente(nDocumento)
local oFacturas := facturasReciboCliente(nDocumento)

recibo.frame_1.caption := "Recibo"
recibo.label_1.value := str(nDocumento)+" - "+nombreCliente(clienteRecibo(nDocumento))+" - "+dtoc(fechaReciboCliente(nDocumento))

for i = 1 to oFacturas:lastrec()
	oRow := oFacturas:getRow(i)
	recibo.grid_1.additem({ oRow:fieldGet(1),oRow:fieldGet(2)  })
next


procedure cargoNotaCreditoCliente(nDocumento)
local oFacturas := facturasNotaCreditoCliente(nDocumento)

recibo.frame_1.caption := "Notas de Credito"
recibo.label_1.value := str(nDocumento)+" - "+nombreCliente(clienteRecibo(nDocumento))+" - "+dtoc(fechaReciboCliente(nDocumento))

for i = 1 to oFacturas:lastrec()
	oRow := oFacturas:getRow(i)
	recibo.grid_1.additem({ oRow:fieldGet(1),oRow:fieldGet(2)  })
next


**************************************************
**** Para mostrar los documentos de Proveedores
**************************************************
procedure cargoFacturaCreditoProveedor(nDocumento)
local oDetalleFactura := detalleFacturaProveedor(nDocumento)
local oRecibos := recibosFacturaProveedor(nDocumento)
local oNotasCredito := notasCreditoFacturaProveedor(nDocumento)
local oDevolucion := notaDevolucionFacturaProveedor(nDocumento)
local nTotFactura := 0
msginfo("paso por facturaProveedor")
documento.label_1.value := str(nDocumento)+" - "+nombreCliente(clienteFactura(nDocumento))+" - "+dtoc(fechaFacturaCliente(nDocumento))

for i = 1 to oDetalleFactura:lastrec()
	oRow := oDetalleFactura:getRow(i)
	documento.grid_1.additem({ oRow:fieldGet(7),oRow:fieldGet(1),oRow:fieldGet(2),oRow:fieldGet(3),oRow:fieldGet(4),oRow:fieldGet(5),oRow:fieldGet(6)  })
	nTotFactura += round(oRow:fieldGet(6) * (1 + oRow:fieldGet(4)/100),0)
next
	documento.text_1.value := nTotFactura
for i = 1 to oRecibos:lastrec()
	oRow := oRecibos:getRow(i)
	documento.grid_2.additem({ oRow:fieldGet(1),oRow:fieldGet(2),oRow:fieldGet(3),oRow:fieldGet(4) })
next

for i = 1 to oRecibos:lastrec()
	oRow := oNotasCredito:getRow(i)
	documento.grid_3.additem({ oRow:fieldGet(1),oRow:fieldGet(2),oRow:fieldGet(3),oRow:fieldGet(4) })
next

//procedure detalleFacturaProveedor
//procedure recibosFacturaProveedor
//procedure notasCreditoFacturaProveedor


procedure cargoReciboProveedor(nDocumento)
local oFacturas := facturasReciboCliente(nDocumento)
msginfo("paso por reciboProveedor")
recibo.frame_1.caption := "Recibo"
recibo.label_1.value := str(nDocumento)+" - "+nombreCliente(clienteRecibo(nDocumento))+" - "+dtoc(fechaReciboCliente(nDocumento))

for i = 1 to oFacturas:lastrec()
	oRow := oFacturas:getRow(i)
	recibo.grid_1.additem({ oRow:fieldGet(1),oRow:fieldGet(2)  })
next


procedure cargoNotaCreditoProveedor(nDocumento)
local oFacturas := facturasNotaCreditoCliente(nDocumento)
msginfo("paso por notacreditoProveedor")
recibo.frame_1.caption := "Notas de Credito"
recibo.label_1.value := str(nDocumento)+" - "+nombreCliente(clienteRecibo(nDocumento))+" - "+dtoc(fechaReciboCliente(nDocumento))

for i = 1 to oFacturas:lastrec()
	oRow := oFacturas:getRow(i)
	recibo.grid_1.additem({ oRow:fieldGet(1),oRow:fieldGet(2)  })
next


procedure reImprimoMovimientos()

busquedaGeneral("l","","Documentos para Imprimir",1)   

if nSocioGlobal != 0
	cargoDocumentoGen(nSocioGlobal,"IMPRIMIR")
  //imprimoMovimiento(nSocioGlobal,1,'','','') //mando imprimir ese movimiento con el idMov
	nSocioGlobal := 0
endIf                                                                                                    

*************************************************
* función para imprimir un documento emitido
* se le debe pasar el Nro de documento 
* si es copia o no(1 o 0)
* ***********************************************
function imprimoMovimiento(nFactura,copia,cRut,cNombre,cDireccion)
local cTipoDocumento := tipoDocumento(nFactura)

if cTipoDocumento = 'P'
	imprimoEnLaser(nFactura,copia,cRut,cNombre,cDireccion)
else
	imprimoEnMatriz(nFactura,copia,cRut,cNombre,cDireccion)
endif


function imprimoEnMatriz(nFactura,copia,cRut,cNombre,cDireccion)
local fila, col, lin,l,n
local nTotalFactura,nIva,nTotalSIva, puerto
local oCabezal,oDetalle
local cNombreImpreso, cRutImpreso,cDescripcion
local nLineaComienzoDetalle := PARAMETROini("LineaInicioDetalle","N")
local nIvaBasico := PARAMETROini("IVA","N")
local cTipoDocumento :=tipoDocumento(nFactura)
local nCantidaCopias := cantidadCopias(cTipoDocumento)
local nVendedor := vendedorFacturaCliente(nFactura)

if cTipoDocumento == 'R' .or. cTipoDocumento== 'N'
	oCabezal :=reciboClienteCabezal(nFactura)
	oDetalle :=reciboClienteDetalle(nFactura)

else
	oCabezal :=facturaClienteCabezal(nFactura)
	oDetalle :=facturaClienteDetalle(nFactura)

endif

if len(alltrim(cRut)) != 0
	cRutImpreso := cRut
else
	cRutImpreso := rutCliente(oCabezal:GetRow(1):fieldGet(3))
endif
if len(alltrim(cNombre)) != 0
	cNombreImpreso := cNombre
else
	cNombreImpreso:= nombreCliente(oCabezal:GetRow(1):fieldGet(3))
endif

if len(alltrim(cDireccion)) != 0
	cDireccionImpresa := cDireccion
else
	cDireccionImpresa := dirParticularCliente(oCabezal:GetRow(1):fieldGet(3))
endif

if cTipoDocumento = "D"
	cDescripcion := "Afecta Factura Nro. "+alltrim(oCabezal:GetRow(1):fieldGet(5))
else
	cDescripcion := alltrim(oCabezal:GetRow(1):fieldGet(5))
endif
puerto := alltrim(puertoDocumento(oCabezal:GetRow(1):fieldGet(4)))



	set printer to &puerto
	set device to print
	setprc(0,0) 
	@ 00,00 say chr(015)



For n=1 to nCantidaCopias
nTotalFactura := 0
nIva := 0
nTotalSIva := 0
fila := 0
col := 0
if n != 1
setprc(0,0) 
endif
	@ fila+03,col+053 say +str(nVendedor)
	@ fila+06,col+053 say cNombreImpreso//nombreCliente
	@ fila+06,col+117 say "A -"
	@ fila+06,col+120 say oCabezal:GetRow(1):fieldGet(1) pict '99999999' //NRODOC->NRODOC 
	@ fila+07,col+053 say cDireccionImpresa  //direccion
	@ fila+07,col+118 say alltrim(descripcionDocumento(oCabezal:GetRow(1):fieldGet(4)))
	@ fila+08,col+001 say cRutImpreso pict '999999999999' //rut
	if len(alltrim(cRutImpreso)) = 0
	  @ fila+08,col+037 say 'X' //consumo final
	endif
	@ fila+08,col+118 say oCabezal:GetRow(1):fieldGet(2) //fecha
	
	@ fila+09,col+053 say cDescripcion //nota
	@ fila+09,col+118 say oCabezal:GetRow(1):fieldGet(3) pict '99999999' //codigocliente
	
	lin := nLineaComienzoDetalle
	for i= 1 to oDetalle:lastRec()
	  
	  @ fila+lin,col+001 say alltrim(oDetalle:GetRow(i):fieldGet(3)) //CODREPF
	  if cTipoDocumento = "N" .or. cTipoDocumento = "R"
	  	@ fila+lin,col+022 say "Afecta Fac. Nro: "+ str(oDetalle:GetRow(i):fieldGet(4))+"-"+dtoc(fechaFacturaCliente(oDetalle:GetRow(i):fieldGet(4))) //NOMREPF
	  else
	  	@ fila+lin,col+022 say alltrim(oDetalle:GetRow(i):fieldGet(4))+"-"+locacionArticulo(oDetalle:GetRow(i):fieldGet(3)) //NOMREPF
	  endif
	  @ fila+lin,col+075 say oDetalle:GetRow(i):fieldGet(5)  pict '999999.99' //CANTF
	  @ fila+lin,col+098 say oDetalle:GetRow(i):fieldGet(6)  pict '99999.99' //PRVENTAF
	  @ fila+lin,col+114 say oDetalle:GetRow(i):fieldGet(9)  pict '99.9' //PCTDESCF
	  if cTipoDocumento = "N"
	  	@ fila+lin,col+119 say round(oDetalle:GetRow(i):fieldGet(10),2)/(1 + nIvaBasico/100) pict '99999999999.99' //IMPORTEF
	  else
	  @ fila+lin,col+119 say round(oDetalle:GetRow(i):fieldGet(10),2) pict '99999999999.99' //IMPORTEF
	  endif
	  if cTipoDocumento = "N"
	  	nLineaSinIva :=  round(oDetalle:GetRow(i):fieldGet(10),2) /(1 + nIvaBasico/100)
	  	nTotalSIva := nTotalSIva + nLineaSinIva
			nIva := nIva +  round(nLineaSinIva * nIvaBasico/100,2)
	  else
		  nTotalSIva := nTotalSIva + round(oDetalle:GetRow(i):fieldGet(10),2) 
			nIva := nIva +  round(oDetalle:GetRow(i):fieldGet(10) * (oDetalle:GetRow(i):fieldGet(8)/100),0)
	 	endif
	 	lin += 1
	next
	
	nTotalFactura := nTotalSIva + nIva
	
	
	@ fila+26,col+119 say nTotalSIva 		pict '99999999999.99'
	@ fila+27,col+119 say nIva  					pict '99999999999.99'
	@ fila+28,col+034 say alltrim(mensaje1Documento(oCabezal:GetRow(1):fieldGet(4)))
	@ fila+29,col+034 say alltrim(mensaje2Documento(oCabezal:GetRow(1):fieldGet(4)))
	@ fila+29,col+119 say nTotalFactura 	pict '99999999999.99'
	@ fila+30,col+034 say alltrim(mensaje3Documento(oCabezal:GetRow(1):fieldGet(4)))
	if n==1
	  @ fila+31,col+097 say '* ORIGINAL CLIENTE *'
	endif
	if n==2 .and. nCantidaCopias == 2
		@ fila+31,col+097 say '* ARCHIVO * '
	endif
	if n== 2 .and. nCantidaCopias == 3
	  @ fila+31,col+097 say '* COPIA * '
	endif
	if n==3 .and. nCantidaCopias == 3
	  @ fila+31,col+097 say '* ARCHIVO *'
	endif
	
	@ fila+32,col+000 say ' '
	@ fila+33,col+000 say ' '
	@ fila+34,col+000 say ' '
	@ fila+35,col+000 say ' '
	@ fila+36,col+000 say ' '

next

set device to screen
set printer off
set printer to 

return .t.

function imprimoEnLaser(nFactura,copia,cRut,cNombre,cDireccion)
local fila, col, lin,l,n
local nTotalFactura,nIva,nTotalSIva, puerto
local oCabezal,oDetalle
local cNombreImpreso, cRutImpreso,cDescripcion
local nLineaComienzoDetalle := PARAMETROini("LineaInicioDetalle","N")
local nIvaBasico := PARAMETROini("IVA","N")
local cTipoDocumento :=tipoDocumento(nFactura)
local nCantidaCopias := cantidadCopias(cTipoDocumento)

if cTipoDocumento == 'R' .or. cTipoDocumento== 'N'
	oCabezal :=reciboClienteCabezal(nFactura)
	oDetalle :=reciboClienteDetalle(nFactura)

else
	oCabezal :=facturaClienteCabezal(nFactura)
	oDetalle :=facturaClienteDetalle(nFactura)

endif

if len(alltrim(cRut)) != 0
	cRutImpreso := cRut
else
	cRutImpreso := rutCliente(oCabezal:GetRow(1):fieldGet(3))
endif
if len(alltrim(cNombre)) != 0
	cNombreImpreso := cNombre
else
	cNombreImpreso:= nombreCliente(oCabezal:GetRow(1):fieldGet(3))
endif

if len(alltrim(cDireccion)) != 0
	cDireccionImpresa := cDireccion
else
	cDireccionImpresa := dirParticularCliente(oCabezal:GetRow(1):fieldGet(3))
endif

if cTipoDocumento = "D"
	cDescripcion := "Afecta Factura Nro. "+alltrim(oCabezal:GetRow(1):fieldGet(5))
else
	cDescripcion := alltrim(oCabezal:GetRow(1):fieldGet(5))
endif
puerto := alltrim(puertoDocumento(oCabezal:GetRow(1):fieldGet(4)))

SELECT PRINTER  'Informes' 
start printdoc
START PRINTPAGE
fila := PARAMETROini("Rxpos","N")
col := PARAMETROini("Rypos","N")


For n=1 to nCantidaCopias
nTotalFactura := 0
nIva := 0.00
nTotalSIva := 0

//if n != 1
//setprc(0,0) 
//endif
	
	@ fila+06,col+080 print data cNombreImpreso//nombreCliente
	@ fila+06,col+140 print data oCabezal:GetRow(1):fieldGet(1) //pict '99999999' //NRODOC->NRODOC 
	@ fila+11,col+080 print data cDireccionImpresa  //direccion
	@ fila+11,col+140 print data alltrim(descripcionDocumento(oCabezal:GetRow(1):fieldGet(4)))
	@ fila+16,col+001 print data cRutImpreso //pict '999999999999' //rut
	if len(alltrim(cRutImpreso)) = 0
	  @ fila+17,col+037 print data 'X' //consumo final
	endif
	@ fila+17,col+140 print data oCabezal:GetRow(1):fieldGet(2) //fecha
	
	@ fila+22,col+080 print data cDescripcion //nota
	@ fila+22,col+140 print data oCabezal:GetRow(1):fieldGet(3) //pict '99999999' //codigocliente
	
	lin := 32
	for i= 1 to oDetalle:lastRec()
	  
	  @ fila+lin,col+001 print data alltrim(oDetalle:GetRow(i):fieldGet(3)) //CODREPF
	  @ fila+lin,col+022 print data alltrim(oDetalle:GetRow(i):fieldGet(4))+"-"+locacionArticulo(oDetalle:GetRow(i):fieldGet(3)) //NOMREPF
	  @ fila+lin,col+075 print data oDetalle:GetRow(i):fieldGet(5)  right//pict '999999.99' //CANTF
	  @ fila+lin,col+098 print data oDetalle:GetRow(i):fieldGet(6)  right//pict '99999.99' //PRVENTAF
	  @ fila+lin,col+114 print data oDetalle:GetRow(i):fieldGet(9)  right//pict '99.9' //PCTDESCF
	  if cTipoDocumento = "N"
	  	@ fila+lin,col+140 print data round(oDetalle:GetRow(i):fieldGet(10),2)/(1 + nIvaBasico/100) right//pict '99999999999.99' //IMPORTEF
	  else
	  @ fila+lin,col+140 print data round(oDetalle:GetRow(i):fieldGet(10),2) right//pict '99999999999.99' //IMPORTEF
	  endif
	  if cTipoDocumento = "N"
	  	nLineaSinIva :=  round(oDetalle:GetRow(i):fieldGet(10),2) /(1 + nIvaBasico/100)
	  	nTotalSIva := nTotalSIva + nLineaSinIva
			nIva := nIva +  round(nLineaSinIva * nIvaBasico/100,2)
	  else
		  nTotalSIva := nTotalSIva + round(oDetalle:GetRow(i):fieldGet(10),2) 
			nIva := nIva +  round(oDetalle:GetRow(i):fieldGet(10) * (oDetalle:GetRow(i):fieldGet(8)/100),0)
	 	endif
	 	lin += 5
	next
	
	nTotalFactura := nTotalSIva + nIva
	
	
	@ fila+95,col+140 print data nTotalSIva 		right//pict '99999999999.99'
	@ fila+100,col+140 print data nIva  				right	//pict '99999999999.99'
	@ fila+105,col+034 print data alltrim(mensaje1Documento(oCabezal:GetRow(1):fieldGet(4)))
	@ fila+110,col+034 print data alltrim(mensaje2Documento(oCabezal:GetRow(1):fieldGet(4)))
	@ fila+110,col+140 print data nTotalFactura right	//pict '99999999999.99'
	@ fila+115,col+034 print data alltrim(mensaje3Documento(oCabezal:GetRow(1):fieldGet(4)))
	if n=1
	  @ fila+120,col+120 print data '* ORIGINAL CLIENTE *'
	endif
	if n=2 .and. nCantidaCopias == 2
		@ fila+120,col+120 print data '* ARCHIVO *'
	else
	  @ fila+120,col+120 print data '* COPIA *'
	endif
	if n=3 .and. nCantidaCopias == 3
	  @ fila+120,col+120 print data '* ARCHIVO *'
	endif
fila := 160
//	@ fila+63,col+000 print data ' '
//	@ fila+,col+000 print data ' '
//	@ fila+34,col+000 print data ' '
//	@ fila+35,col+000 print data ' '
//	@ fila+36,col+000 print data ' '

next

END PRINTPAGE
END PRINTDOC

return .t.


*************************************************
*************************************************
******Implementaciones del modelo ***************
*************************************************
*************************************************
function tipoDocumento(nDocumento)
local cQuery, oQuery

cQuery := " select tipo_documento "
cQuery += " from factura_cliente_cab "
cQuery += " where numero_factura = "+str(nDocumento)+""
cQuery += " union all "
cQuery += " select tipo_documento from recibo_cliente_cab "
cQuery += " where id_recibo = "+str(nDocumento)+""

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf

function tipoDocumentoProveedor(nDocumento)
local cQuery, oQuery

cQuery := " select tipo_documento "
cQuery += " from factura_proveedor_cab "
cQuery += " where id_mov = "+str(nDocumento)+""
cQuery += " union all "
cQuery += " select tipo_documento from recibo_proveedor_cab "
cQuery += " where id_recibo = "+str(nDocumento)+""

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf

function descripcionDocumento(cTipoDocumento)
local cQuery
local oQuery

cQuery := "select descripcion from documento where  id_documento = '"+cTipoDocumento+"' "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf


function puertoDocumento(cTipoDocumento)
local cQuery
local oQuery

cQuery := "select puerto_impresion from documento where  id_documento = '"+cTipoDocumento+"' "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf

function cantidadCopias(cTipoDocumento)
local cQuery
local oQuery

cQuery := "select cantidad_copias from documento where  id_documento = '"+cTipoDocumento+"' "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf

function mensaje1Documento(cTipoDocumento)
local cQuery
local oQuery

cQuery := "select mensaje1 from documento where  id_documento = '"+cTipoDocumento+"' "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf

function mensaje2Documento(cTipoDocumento)
local cQuery
local oQuery

cQuery := "select mensaje2 from documento where  id_documento = '"+cTipoDocumento+"' "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf

function mensaje3Documento(cTipoDocumento)
local cQuery
local oQuery

cQuery := "select mensaje3 from documento where  id_documento = '"+cTipoDocumento+"' "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf

function documentosCliente(nCliente,dFechaDesde,dFechaHasta)
local cQuery, oQuery

cQuery := " select c.numero_factura, c.fecha,d.descripcion,c.importe, 0, c.saldo "
cQuery += " from factura_cliente_cab c, documento d "
cQuery += " where id_cliente = "+str(nCliente)+" "
cQuery += " and d.id_documento = c.tipo_documento"
cQuery += " and fecha between '"+dtos(dFechaDesde)+"' and '"+dtos(dFechaHasta)+"' "
cQuery += " and tipo_documento = 'F' "
cQuery += " and anulado = 'N'  "
cQuery += " union all "
cQuery += " select id_recibo, fecha,d.descripcion,0,importe, 0 "
cQuery += " from recibo_cliente_cab c, documento d"

cQuery += " where id_cliente = "+str(nCliente)+" "
cQuery += " and d.id_documento = c.tipo_documento"
cQuery += " and fecha between '"+dtos(dFechaDesde)+"' and '"+dtos(dFechaHasta)+"' "
cQuery += " and tipo_documento = 'R' "
cQuery += " and anulado = 'N'  "
cQuery += " union all "
cQuery += " select id_recibo, fecha,d.descripcion,0,importe, 0 "
cQuery += " from recibo_cliente_cab c, documento d "
cQuery += " where id_cliente = "+str(nCliente)+" "
cQuery += " and d.id_documento = c.tipo_documento"
cQuery += " and fecha between '"+dtos(dFechaDesde)+"' and '"+dtos(dFechaHasta)+"' "
cQuery += " and tipo_documento = 'N' "
cQuery += " and anulado = 'N'  "
cQuery += " union all "
cQuery += " select numero_factura, fecha,d.descripcion,0,importe, 0 "
cQuery += " from factura_cliente_cab c, documento d "
cQuery += " where id_cliente = "+str(nCliente)+" "
cQuery += " and d.id_documento = c.tipo_documento"
cQuery += " and fecha between '"+dtos(dFechaDesde)+"' and '"+dtos(dFechaHasta)+"' "
cQuery += " and tipo_documento = 'D' "
cQuery += " and anulado = 'N'  "
cQuery += " order by 2,1  "

oQuery:= oServer:Query(cQuery)
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
endif
return oQuery




function fechaUltimoMovimientoCliente(nCliente)
local cQuery, oQuery

cQuery := " select fecha from factura_cliente_cab "
cQuery += " where id_cliente = "+str(nCliente)+" "
cQuery += " union all "
cQuery += " select fecha from recibo_cliente_cab "
cQuery += " where id_cliente = "+str(nCliente)+" "
cQuery += " order by 1 desc "

oQuery:= oServer:Query(cQuery)
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
endif
return oQuery:GetRow(1):fieldGet(1)

function borrafacturaProveedor(nDocumento)
local cQuery, oQuery

cQuery := " delete from factura_proveedor_cab "
cQuery += " where id_mov = "+str(nDocumento)+" "
oQuery:= oServer:Query(cQuery)
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
	return .f.
else
	return .t.
endif

function borraReciboProveedor(nDocumento)
local cQuery, oQuery

cQuery := " delete from recibo_proveedor_cab "
cQuery += " where id_recibo = "+str(nDocumento)+" "
oQuery:= oServer:Query(cQuery)
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
	return .f.
else
	return .t.
endif



function documentosPorArticulo(cArticulo,dFechaDesde,dFechaHasta)
local cQuery, oQuery

cQuery := " select c.fecha,c.numero_factura,d.descripcion, c.id_cliente, c.id_usuario,c.importe "
cQuery += " from factura_cliente_cab c, documento d, factura_cliente_det e "
cQuery += " where d.id_documento = c.tipo_documento"
cQuery += " and e.numero_factura = c.numero_factura"
//cQuery += " and fecha between '"+dtos(dFechaDesde)+"' and '"+dtos(dFechaHasta)+"' "
cQuery += " and tipo_documento = 'F' "
cQuery += " and e.codigo_barra = '"+cArticulo+"'"
cQuery += " and anulado = 'N'  "
cQuery += " union all "
cQuery += " select c.fecha,c.numero_factura,d.descripcion, c.id_cliente, c.id_usuario,c.importe "
cQuery += " from factura_cliente_cab c, documento d, factura_cliente_det e "
cQuery += " where d.id_documento = c.tipo_documento"
cQuery += " and e.numero_factura = c.numero_factura"
//cQuery += " and fecha between '"+dtos(dFechaDesde)+"' and '"+dtos(dFechaHasta)+"' "
cQuery += " and tipo_documento = 'D' "
cQuery += " and e.codigo_barra = '"+cArticulo+"'"
cQuery += " and anulado = 'N'  "
cQuery += " union all "
cQuery += " select c.fecha,c.numero_factura,d.descripcion, c.id_cliente, c.id_usuario,c.importe "
cQuery += " from factura_cliente_cab c, documento d, factura_cliente_det e "
cQuery += " where d.id_documento = c.tipo_documento"
cQuery += " and e.numero_factura = c.numero_factura"
//cQuery += " and fecha between '"+dtos(dFechaDesde)+"' and '"+dtos(dFechaHasta)+"' "
cQuery += " and tipo_documento = 'C' "
cQuery += " and e.codigo_barra = '"+cArticulo+"'"
cQuery += " and anulado = 'N'  "
cQuery += " order by 1 desc   "


oQuery:= oServer:Query(cQuery)
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
endif
return oQuery
//borraDocumentoProveedor(estadoCuentaProveedor.grid_1.cell(estadocuentaProveedor.grid_1.value,1))