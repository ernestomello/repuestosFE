#include <hmg.ch>

procedure resumencompra()

        Load Window resumencompra
        //resumencompra.buton_1.onclick := traeInformacioncompras()
        resumencompra.Center
        resumencompra.Activate

Return
procedure detallecompra()

        Load Window resumencompra
        //resumencompra.buton_1.onclick := traeInformacioncomprasUsuarios()
        resumencompra.Center
        resumencompra.Activate

Return
//procedure traeInformacion()
//
//if resumencompra.text_1.value = "V"
//	
//else
//
//endif

return 
procedure traeInformacioncompras()
local contado := 0
local factura := 0
local recibo := 0 
local notacredito := 0
local devolucion := 0
local totalListadoFactura :=0
local totalListadoRecibo :=0
local totalListadoNotasCredito :=0
local totalListadoContado :=0
local totalListadoDevolucion := 0
local ocompras := comprasDesdeHasta(resumencompra.datePicker_1.value,resumencompra.datePicker_2.value )
local dfechaAnt := ocompras:getRow(1):fieldget(1)

resumencompra.grid_1.deleteAllItems

for i= 1 to ocompras:lastRec()
	if dfechaAnt == ocompras:getRow(i):fieldget(1)
		//msginfo(str(ocompras:getRow(i):fieldget(3)))
		do case 
			case ocompras:getRow(i):fieldget(2) = 'C' 
				contado :=ocompras:getRow(i):fieldget(3)
				totalListadoContado += ocompras:getRow(i):fieldget(3)
				
			case ocompras:getRow(i):fieldget(2) = 'F'
				factura :=ocompras:getRow(i):fieldget(3)
				totalListadoFactura += ocompras:getRow(i):fieldget(3)

			case ocompras:getRow(i):fieldget(2) = 'R'
				recibo :=ocompras:getRow(i):fieldget(3)
				totalListadoRecibo += ocompras:getRow(i):fieldget(3)

			case ocompras:getRow(i):fieldget(2) = 'N'
				notacredito :=ocompras:getRow(i):fieldget(3)
				totalListadoNotasCredito += ocompras:getRow(i):fieldget(3)

			case ocompras:getRow(i):fieldget(2) = 'D'
			  devolucion :=ocompras:getRow(i):fieldget(3)
				totalListadoDevolucion += ocompras:getRow(i):fieldget(3)

		end case
	else
		resumencompra.grid_1.addItem({dtoc(dfechaAnt),factura,recibo,notacredito,devolucion,contado})
		contado := 0
		factura := 0
		recibo := 0
		notacredito := 0
		devolucion := 0
		do case 
			case ocompras:getRow(i):fieldget(2) = 'C' 
				contado :=ocompras:getRow(i):fieldget(3)
				totalListadoContado += ocompras:getRow(i):fieldget(3)
				
			case ocompras:getRow(i):fieldget(2) = 'F'
				factura :=ocompras:getRow(i):fieldget(3)
				totalListadoFactura += ocompras:getRow(i):fieldget(3)

			case ocompras:getRow(i):fieldget(2) = 'R'
				recibo :=ocompras:getRow(i):fieldget(3)
				totalListadoRecibo += ocompras:getRow(i):fieldget(3)

			case ocompras:getRow(i):fieldget(2) = 'N'
				notacredito :=ocompras:getRow(i):fieldget(3)
				totalListadoNotasCredito += ocompras:getRow(i):fieldget(3)

			case ocompras:getRow(i):fieldget(2) = 'D'
			  devolucion :=ocompras:getRow(i):fieldget(3)
				totalListadoDevolucion += ocompras:getRow(i):fieldget(3)

		end case
	endif
	dFechaAnt :=  ocompras:getRow(i):fieldget(1)
next 
resumencompra.grid_1.addItem({dtoc(dfechaAnt),factura,recibo,notacredito,devolucion,contado})

resumencompra.grid_1.addItem({'Totales',totalListadoFactura,totalListadoRecibo,totalListadoNotasCredito, totalListadoDevolucion,totalListadoContado})
Close Database


procedure traeInformacioncomprasUsuarios()
local contado := 0
local factura := 0
local recibo := 0 
local notacredito := 0
local devolucion := 0
local totalListadoFactura :=0
local totalListadoRecibo :=0
local totalListadoNotasCredito :=0
local totalListadoContado :=0
local totalListadoDevolucion := 0
local ocompras := comprasUsuarioDesdeHasta(resumencompra.datePicker_1.value,resumencompra.datePicker_2.value )
local nUsuarioAnt := ocompras:getRow(1):fieldget(1)

resumencompra.grid_1.deleteAllItems

for i= 1 to ocompras:lastRec()
	if nUsuarioAnt == ocompras:getRow(i):fieldget(1)
		//msginfo(str(ocompras:getRow(i):fieldget(3)))
		do case 
			case ocompras:getRow(i):fieldget(2) = 'C' 
				contado :=ocompras:getRow(i):fieldget(3)
				totalListadoContado += ocompras:getRow(i):fieldget(3)
				
			case ocompras:getRow(i):fieldget(2) = 'F'
				factura :=ocompras:getRow(i):fieldget(3)
				totalListadoFactura += ocompras:getRow(i):fieldget(3)

			case ocompras:getRow(i):fieldget(2) = 'D'
			  devolucion :=ocompras:getRow(i):fieldget(3)
				totalListadoDevolucion += ocompras:getRow(i):fieldget(3)

		end case
	else
		resumencompra.grid_1.addItem({nombreUsuario(nUsuarioAnt),factura,recibo,notacredito,devolucion,contado})
		contado := 0
		factura := 0
		devolucion := 0
		do case 
			case ocompras:getRow(i):fieldget(2) = 'C' 
				contado :=ocompras:getRow(i):fieldget(3)
				totalListadoContado += ocompras:getRow(i):fieldget(3)
				
			case ocompras:getRow(i):fieldget(2) = 'F'
				factura :=ocompras:getRow(i):fieldget(3)
				totalListadoFactura += ocompras:getRow(i):fieldget(3)

			case ocompras:getRow(i):fieldget(2) = 'D'
			  devolucion :=ocompras:getRow(i):fieldget(3)
				totalListadoDevolucion += ocompras:getRow(i):fieldget(3)

		end case
	endif
	nUsuarioAnt :=  ocompras:getRow(i):fieldget(1)
next 
resumencompra.grid_1.addItem({nombreUsuario(nUsuarioAnt),factura,recibo,notacredito,devolucion,contado})

resumencompra.grid_1.addItem({'Totales',totalListadoFactura,totalListadoRecibo,totalListadoNotasCredito, totalListadoDevolucion,totalListadoContado})



procedure exportarPlanillaCompras()
local cDescripcion 
local pArchivo

cDescripcion := "\TotalComprobantesCompras.csv"

pArchivo := fcreate(GetDesktopFolder()+cDescripcion,0)

clinea :='Fecha,Facturas,Recibos,Notas Credito,Devolucion,Contado'
fwrite(parchivo,clinea  + chr(10))
for i= 1 to resumencompra.grid_1.itemCount
	clinea := alltrim(resumencompra.grid_1.item(i)[1]) ;
		+','+alltrim(str(resumencompra.grid_1.item(i)[2])) ;
		+','+alltrim(str(resumencompra.grid_1.item(i)[3])) ;
		+','+alltrim(str(resumencompra.grid_1.item(i)[4])) ;
		+','+alltrim(str(resumencompra.grid_1.item(i)[5])) ;
		+','+alltrim(str(resumencompra.grid_1.item(i)[6]))
	fwrite(parchivo,clinea  + chr(10))
Next
fclose(parchivo)

*-----------------------------------------------------------------------*
*************************************************
*************************************************
******Implementaciones del modelo ***************
*************************************************
*************************************************
function comprasDesdeHasta(dFechaDesde, dFechaHasta)
local cQuery, oQuery

cQuery := " select  fecha,tipo_documento, sum(importe) "
cQuery += " FROM factura_cliente_cab "
cQuery += " where fecha between '"+dtos(dFechaDesde)+"' and '"+dtos(dFechaHasta)+"' "
cQuery += " and anulado = 'N' " 
cQuery += " group by 1,2 "
cQuery += " union all "
cQuery += " select fecha, tipo_documento, sum(importe) "
cQuery += " from recibo_cliente_cab "
cQuery += " where fecha between '"+dtos(dFechaDesde)+"' and '"+dtos(dFechaHasta)+"' "
cQuery += " and anulado = 'N' "
cQuery += " group by 1,2 "
cQuery += " order by 1,2 " 

oQuery := oServer:Query( cQuery )
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
  return .f.
else
	return oQuery
endIf

function comprasUsuarioDesdeHasta(dFechaDesde, dFechaHasta)
local cQuery, oQuery

cQuery := " select  id_usuario,tipo_documento, sum(importe) "
cQuery += " FROM factura_cliente_cab "
cQuery += " where fecha between '"+dtos(dFechaDesde)+"' and '"+dtos(dFechaHasta)+"' "
cQuery += " and anulado = 'N' " 
cQuery += " group by 1,2 "
cQuery += " order by 1,2 " 

oQuery := oServer:Query( cQuery )
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
  return .f.
else
	return oQuery
endIf