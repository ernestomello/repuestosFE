#include <hmg.ch>

procedure cargoDocumentoGen(nDocumento, cFuncion)
local cTipoDoc := tipoDocumento(nDocumento)
 
//cargo un documento(nDocumento) factura, recibo, nota de crédito, nota de devolucion 
//también defino si quiero imprimirlo o anularlo en el parámetro cFuncion
//
do case

	case cTipoDoc == 'F' .or. cTipoDoc == 'D' .or. cTipoDoc == 'C' .or. cTipoDoc == 'P' .or. cTipoDoc == 'Q'
		aLargos := {120,200,45,80,30,40,80 }
		aTitulos := {'Codigo','Articulo','Cant.','Precio Unit.','Iva','Dto.','PrecioFinal'}
		aControls := {{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','NUMERIC','999.99'},{'TEXTBOX','NUMERIC','999,999.99'},{'TEXTBOX','NUMERIC','99'},{'TEXTBOX','NUMERIC','999'},{'TEXTBOX','NUMERIC','999,999,999.99'}}
	case cTipoDoc == 'R' .or. cTipoDoc == 'N' 
		aLargos := {120,120,120,120,120 }
		aTitulos := {'Nro Factura','Imp.Factura','Fecha','Imp.Aplicado','Saldo Factura'}
	 	aControls :={{'TEXTBOX','NUMERIC','99999999'},{'TEXTBOX','NUMERIC','999,999.99'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','NUMERIC','999,999.99'},{'TEXTBOX','NUMERIC','999,999.99'}}
endcase

load window documentogen
documentogen.text_6.value := nDocumento
documentogen.text_4.value := cFuncion

do case
	case cFuncion == "IMPRIMIR"
		documentogen.button_1.caption := "Re Imprimir"
	
	case cFuncion == "ANULAR"
		documentogen.button_1.caption := "Anular"
		
	case cFuncion == "MOSTRAR"
		documentogen.button_1.visible := .f.
endcase

do case

	case cTipoDoc == 'F' 
		cargarFacturaCreditoCliente(nDocumento)
		documentogen.title := "Factura de Crédito"
	case cTipoDoc == 'R'
		documentogen.title := "Recibo"
		cargarReciboCliente(nDocumento)
	case cTipoDoc == 'N' 
		documentogen.title := "Nota de Crédito"
		cargarReciboCliente(nDocumento)
	case cTipoDoc == 'D'
		documentogen.title := "Nota de Devolución"
		cargarFacturaCreditoCliente(nDocumento)
	case cTipoDoc == 'C'
		documentogen.title := "Contado"
		cargarFacturaCreditoCliente(nDocumento)
	case cTipoDoc == 'P'
		documentogen.title := "Presupuesto Crédito"
		cargarFacturaCreditoCliente(nDocumento)
	case cTipoDoc == 'Q'
		documentogen.title := "Presupuesto Contado"
		cargarFacturaCreditoCliente(nDocumento)

end case 
documentogen.center
documentogen.activate

return

procedure cargarFacturaCreditoCliente(nDocumento)
local oDetalleFactura := detalleFacturaCliente(nDocumento)
local nTotFactura := 0
documentogen.text_1.value := clienteFactura(nDocumento)
documentogen.text_2.value := alltrim(nombreCliente(clienteFactura(nDocumento)))
documentogen.datePicker_1.value := fechaFacturaCliente(nDocumento)
documentogen.label_1.value := ""

for i = 1 to oDetalleFactura:lastrec()
	oRow := oDetalleFactura:getRow(i)
	documentogen.grid_1.additem({ oRow:fieldGet(7),oRow:fieldGet(1),oRow:fieldGet(2),oRow:fieldGet(3),oRow:fieldGet(4),oRow:fieldGet(5),oRow:fieldGet(6)  })
	nTotFactura += round(oRow:fieldGet(6) * (1 + oRow:fieldGet(4)/100),0)
next
	documentogen.text_5.value := nTotFactura



procedure cargarReciboCliente(nDocumento)
local nTotFactura := 0
local oFacturas := facturasRecibosCliente(nDocumento)
documentogen.text_1.value := clienteRecibo(nDocumento)
documentogen.text_2.value := alltrim(nombreCliente(clienteRecibo(nDocumento)))
documentogen.datePicker_1.value := fechaReciboCliente(nDocumento)

for i = 1 to oFacturas:lastrec()
	oRow := oFacturas:getRow(i)
	documentogen.grid_1.additem({ oRow:fieldGet(1),oRow:fieldGet(2),dtoc(oRow:fieldGet(3)),oRow:fieldGet(4),oRow:fieldGet(5) })
	nTotFactura += round(oRow:fieldGet(4) ,0)
next
	documentogen.text_5.value := nTotFactura


procedure cargarNotaCreditoCliente(nDocumento)
documentogen.title := "Nota de Crédito"


//procedure cargarNotaDevolucionCliente(nDocumento)
//
//local oDetalleFactura := detalleFacturaCliente(nDocumento)
//local nTotFactura := 0
//
//documentogen.text_2.value := alltrim(nombreCliente(clienteFactura(nDocumento)))
//documentogen.datePicker_1.value := fechaFacturaCliente(nDocumento)
//
//for i = 1 to oDetalleFactura:lastrec()
//	oRow := oDetalleFactura:getRow(i)
//	documentogen.grid_1.additem({ oRow:fieldGet(7),oRow:fieldGet(1),oRow:fieldGet(2),oRow:fieldGet(3),oRow:fieldGet(4),oRow:fieldGet(5),oRow:fieldGet(6)  })
//	nTotFactura += round(oRow:fieldGet(6) * (1 + oRow:fieldGet(4)/100),0)
//next
//	documentogen.text_5.value := nTotFactura
//
//procedure cargarContadoCliente(nDocumento)
//local oDetalleFactura := detalleFacturaCliente(nDocumento)
//local nTotFactura := 0
//
//
//documentogen.text_2.value := alltrim(nombreCliente(clienteFactura(nDocumento)))
//documentogen.datePicker_1.value := fechaFacturaCliente(nDocumento)
//
//for i = 1 to oDetalleFactura:lastrec()
//	oRow := oDetalleFactura:getRow(i)
//	documentogen.grid_1.additem({ oRow:fieldGet(7),oRow:fieldGet(1),oRow:fieldGet(2),oRow:fieldGet(3),oRow:fieldGet(4),oRow:fieldGet(5),oRow:fieldGet(6)  })
//	nTotFactura += round(oRow:fieldGet(6) * (1 + oRow:fieldGet(4)/100),0)
//next
//	documentogen.text_5.value := nTotFactura



procedure realizarAccion()

do case 
	case  documentogen.text_4.value =="IMPRIMIR"
	
		imprimoMovimiento(documentogen.text_6.value,1,'','','')
	
	case documentogen.text_4.value =="ANULAR"
		nCajero := anulacion()
		if nCajero != 0
			if tipoDocumento(documentogen.text_6.value) == 'R' .or. tipoDocumento(documentogen.text_6.value)== 'N'				
					if !anuloRecibo(documentogen.text_6.value,nCajero)  
						MsGInfo('No se pudo anular el Movimiento, Consulte al ADMINISTRADOR')
					else
						msgInfo('Documento No.'+str(documentogen.text_6.value)+' Anulado')
					endIf
			elseif tipoDocumento(documentogen.text_6.value) == 'F' .or. tipoDocumento(documentogen.text_6.value)== 'C'
					anularFactura(documentogen.text_6.value,nCajero)  
				else
					anularDevolucion(documentogen.text_6.value,nCajero)
				endIf
//			endif
		else
					msginfo("Usuario no autorizado")
		endIf
endcase

documentogen.release

procedure buscaDocumentos()

busquedaGeneral("n","","Busqueda De Documentos",1)   

if nSocioGlobal != 0
	cargoDocumentoGen(nSocioGlobal, "MOSTRAR")
endif