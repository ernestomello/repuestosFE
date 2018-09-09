#include <hmg.ch>

procedure resumenventa()

        Load Window resumenventa
        //resumenventa.buton_1.onclick := traeInformacionVentas()
        resumenventa.Center
        resumenventa.Activate

Return
procedure detalleventa()

        Load Window resumenventa
        //resumenventa.buton_1.onclick := traeInformacionVentasUsuarios()
        resumenventa.Center
        resumenventa.Activate

Return
procedure traeInformacion()

if resumenventa.text_1.value = "V"
	
else

endif

return 
procedure traeInformacionVentas()
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
local oVentas := ventasDesdeHasta(resumenventa.datePicker_1.value,resumenventa.datePicker_2.value )
local dfechaAnt := oVentas:getRow(1):fieldget(1)

resumenventa.grid_1.deleteAllItems

for i= 1 to oVentas:lastRec()
	if dfechaAnt == oVentas:getRow(i):fieldget(1)
		//msginfo(str(oVentas:getRow(i):fieldget(3)))
		do case 
			case oVentas:getRow(i):fieldget(2) = 'C' 
				contado :=oVentas:getRow(i):fieldget(3)
				totalListadoContado += oVentas:getRow(i):fieldget(3)
				
			case oVentas:getRow(i):fieldget(2) = 'F'
				factura :=oVentas:getRow(i):fieldget(3)
				totalListadoFactura += oVentas:getRow(i):fieldget(3)

			case oVentas:getRow(i):fieldget(2) = 'R'
				recibo :=oVentas:getRow(i):fieldget(3)
				totalListadoRecibo += oVentas:getRow(i):fieldget(3)

			case oVentas:getRow(i):fieldget(2) = 'N'
				notacredito :=oVentas:getRow(i):fieldget(3)
				totalListadoNotasCredito += oVentas:getRow(i):fieldget(3)

			case oVentas:getRow(i):fieldget(2) = 'D'
			  devolucion :=oVentas:getRow(i):fieldget(3)
				totalListadoDevolucion += oVentas:getRow(i):fieldget(3)

		end case
	else
		resumenventa.grid_1.addItem({dtoc(dfechaAnt),factura,recibo,notacredito,devolucion,contado})
		contado := 0
		factura := 0
		recibo := 0
		notacredito := 0
		devolucion := 0
		do case 
			case oVentas:getRow(i):fieldget(2) = 'C' 
				contado :=oVentas:getRow(i):fieldget(3)
				totalListadoContado += oVentas:getRow(i):fieldget(3)
				
			case oVentas:getRow(i):fieldget(2) = 'F'
				factura :=oVentas:getRow(i):fieldget(3)
				totalListadoFactura += oVentas:getRow(i):fieldget(3)

			case oVentas:getRow(i):fieldget(2) = 'R'
				recibo :=oVentas:getRow(i):fieldget(3)
				totalListadoRecibo += oVentas:getRow(i):fieldget(3)

			case oVentas:getRow(i):fieldget(2) = 'N'
				notacredito :=oVentas:getRow(i):fieldget(3)
				totalListadoNotasCredito += oVentas:getRow(i):fieldget(3)

			case oVentas:getRow(i):fieldget(2) = 'D'
			  devolucion :=oVentas:getRow(i):fieldget(3)
				totalListadoDevolucion += oVentas:getRow(i):fieldget(3)

		end case
	endif
	dFechaAnt :=  oVentas:getRow(i):fieldget(1)
next 
resumenventa.grid_1.addItem({dtoc(dfechaAnt),factura,recibo,notacredito,devolucion,contado})

resumenventa.grid_1.addItem({'Totales',totalListadoFactura,totalListadoRecibo,totalListadoNotasCredito, totalListadoDevolucion,totalListadoContado})
Close Database


procedure traeInformacionVentasUsuarios()
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
local oVentas := ventasUsuarioDesdeHasta(resumenventa.datePicker_1.value,resumenventa.datePicker_2.value )
local nUsuarioAnt := oVentas:getRow(1):fieldget(1)

resumenventa.grid_1.deleteAllItems

for i= 1 to oVentas:lastRec()
	if nUsuarioAnt == oVentas:getRow(i):fieldget(1)
		//msginfo(str(oVentas:getRow(i):fieldget(3)))
		do case 
			case oVentas:getRow(i):fieldget(2) = 'C' 
				contado :=oVentas:getRow(i):fieldget(3)
				totalListadoContado += oVentas:getRow(i):fieldget(3)
				
			case oVentas:getRow(i):fieldget(2) = 'F'
				factura :=oVentas:getRow(i):fieldget(3)
				totalListadoFactura += oVentas:getRow(i):fieldget(3)

			case oVentas:getRow(i):fieldget(2) = 'D'
			  devolucion :=oVentas:getRow(i):fieldget(3)
				totalListadoDevolucion += oVentas:getRow(i):fieldget(3)

		end case
	else
		resumenventa.grid_1.addItem({nombreUsuario(nUsuarioAnt),factura,recibo,notacredito,devolucion,contado})
		contado := 0
		factura := 0
		devolucion := 0
		do case 
			case oVentas:getRow(i):fieldget(2) = 'C' 
				contado :=oVentas:getRow(i):fieldget(3)
				totalListadoContado += oVentas:getRow(i):fieldget(3)
				
			case oVentas:getRow(i):fieldget(2) = 'F'
				factura :=oVentas:getRow(i):fieldget(3)
				totalListadoFactura += oVentas:getRow(i):fieldget(3)

			case oVentas:getRow(i):fieldget(2) = 'D'
			  devolucion :=oVentas:getRow(i):fieldget(3)
				totalListadoDevolucion += oVentas:getRow(i):fieldget(3)

		end case
	endif
	nUsuarioAnt :=  oVentas:getRow(i):fieldget(1)
next 
resumenventa.grid_1.addItem({nombreUsuario(nUsuarioAnt),factura,recibo,notacredito,devolucion,contado})

resumenventa.grid_1.addItem({'Totales',totalListadoFactura,totalListadoRecibo,totalListadoNotasCredito, totalListadoDevolucion,totalListadoContado})



procedure exportarPlanilla()
local cDescripcion 
local pArchivo

cDescripcion := "\TotalComprobantes.csv"

pArchivo := fcreate(GetDesktopFolder()+cDescripcion,0)

clinea :='Fecha,Facturas,Recibos,Notas Credito,Devolucion,Contado'
fwrite(parchivo,clinea  + chr(10))
for i= 1 to resumenventa.grid_1.itemCount
	clinea := alltrim(resumenventa.grid_1.item(i)[1]) ;
		+','+alltrim(str(resumenventa.grid_1.item(i)[2])) ;
		+','+alltrim(str(resumenventa.grid_1.item(i)[3])) ;
		+','+alltrim(str(resumenventa.grid_1.item(i)[4])) ;
		+','+alltrim(str(resumenventa.grid_1.item(i)[5])) ;
		+','+alltrim(str(resumenventa.grid_1.item(i)[6]))
	fwrite(parchivo,clinea  + chr(10))
Next
fclose(parchivo)

*-----------------------------------------------------------------------*
*************************************************
*************************************************
******Implementaciones del modelo ***************
*************************************************
*************************************************
function ventasDesdeHasta(dFechaDesde, dFechaHasta)
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

function ventasUsuarioDesdeHasta(dFechaDesde, dFechaHasta)
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