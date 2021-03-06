#include <hmg.ch>

procedure cargoDocumentoGen(nDocumento, cFuncion)
local cTipoDoc := tipoDocumento(nDocumento)
 
//cargo un documento(nDocumento) factura, recibo, nota de cr�dito, nota de devolucion 
//tambi�n defino si quiero imprimirlo o anularlo en el par�metro cFuncion
//
do case

	case cTipoDoc == 101 .or. cTipoDoc == 111 .or. cTipoDoc == 91 .or. cTipoDoc == 81 
		aLargos := {120,200,45,80,30,40,80 }
		aTitulos := {'Codigo','Articulo','Cant.','Precio Unit.','Iva','Dto.','PrecioFinal'}
		aControls := {{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','NUMERIC','999.99'},{'TEXTBOX','NUMERIC','999,999.99'},{'TEXTBOX','NUMERIC','99'},{'TEXTBOX','NUMERIC','999'},{'TEXTBOX','NUMERIC','999,999,999.99'}}
	case cTipoDoc == 98 .or. cTipoDoc == 102 .or. cTipoDoc == 112 .or. cTipoDoc == 103 .or. cTipoDoc == 113
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

	case cTipoDoc == 111 
		cargarFacturaCreditoCliente(nDocumento)
		documentogen.title := "eFactura"
	case cTipoDoc == 98
		documentogen.title := "Recibo"
		cargarReciboCliente(nDocumento)
	case cTipoDoc == 102 
		documentogen.title := "eTicket Nota de Cr�dito"
		cargarReciboCliente(nDocumento)
	case cTipoDoc == 112
		documentogen.title := "eFactura Nota de Cr�dito"
		cargarReciboCliente(nDocumento)
	case cTipoDoc == 103
		documentogen.title := "eTicket Nota de D�bito"
		cargarReciboCliente(nDocumento)
	case cTipoDoc == 113
		documentogen.title := "eFactura Nota de D�bito"
		cargarReciboCliente(nDocumento)
	case cTipoDoc == 101
		documentogen.title := "eTicket"
		cargarFacturaCreditoCliente(nDocumento)
	case cTipoDoc == 81
		documentogen.title := "Presupuesto Cr�dito"
		cargarFacturaCreditoCliente(nDocumento)
	case cTipoDoc == 91
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
documentogen.text_2.value := alltrim(nombreCliente(documentogen.text_1.value))
documentogen.datePicker_1.value := fechaFacturaCliente(nDocumento)
documentogen.label_1.value := ""

for i = 1 to oDetalleFactura:lastrec()
	oRow := oDetalleFactura:getRow(i)
	
	documentogen.grid_1.additem({ oRow:fieldGet(2),oRow:fieldGet(6),oRow:fieldGet(3),oRow:fieldGet(4),oRow:fieldGet(5),oRow:fieldGet(7),oRow:fieldGet(8)  })
	nTotFactura += round(oRow:fieldGet(8) * (1 + oRow:fieldGet(5)/100),0)
next
	documentogen.text_5.value := nTotFactura



procedure cargarReciboCliente(nDocumento)
local nTotFactura := 0
local oFacturas := facturasRecibosCliente(nDocumento)
documentogen.text_1.value := clienteFactura(nDocumento)
documentogen.text_2.value := alltrim(nombreCliente(documentogen.text_1.value))
documentogen.datePicker_1.value := fechaFacturaCliente(nDocumento)

for i = 1 to oFacturas:lastrec()
	oRow := oFacturas:getRow(i)
	documentogen.grid_1.additem({ oRow:fieldGet(1),oRow:fieldGet(2),dtoc(oRow:fieldGet(3)),oRow:fieldGet(4),oRow:fieldGet(5) })
	nTotFactura += round(oRow:fieldGet(4) ,0)
next
	documentogen.text_5.value := nTotFactura


procedure cargarNotaCreditoCliente(nDocumento)
// documentogen.title := "Nota de Cr�dito"

procedure realizarAccion()

do case 
	case  documentogen.text_4.value =="IMPRIMIR"
		// imprimoPDF(documentogen.text_6.value)
		info_("Imprimiendo Documento ...")
		if !imprimoMovimiento(documentogen.text_6.value,1,'','','')
			WAIT CLEAR
			msgInfo("No se pudo imprimir el Documento, Reimprima Desde el Men�")
			return .f.
		endif
		WAIT CLEAR
		
	
	case documentogen.text_4.value =="ANULAR"
		nTipoDoc := tipoDocumento(documentogen.text_6.value)
		nCajero := anulacion()
		if nCajero != 0
			do case 
				case  nTipoDoc == 98 				
					if !anuloRecibo(documentogen.text_6.value,nCajero)  
						MsGInfo('No se pudo anular el Movimiento, Consulte al ADMINISTRADOR')
					else
						msgInfo('Documento No.'+str(documentogen.text_6.value)+' Anulado')
					endIf
				case nTipoDoc == 101 .or. nTipoDoc == 111 
					notaCreditoCliente(documentogen.text_6.value,nCajero)  
				case nTipoDoc == 91 .or. nTipoDoc == 81 
					modificoSaldoFacturaCliente(documentogen.text_6.value, 0 ) 
			end case
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