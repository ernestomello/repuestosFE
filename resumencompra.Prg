#include <hmg.ch>

procedure resumencompra()

        Load Window resumencompra
        //resumencompra.buton_1.onclick := traeInformacionCompras()
        resumencompra.Center
        resumencompra.Activate

Return

procedure traeInformacionCompras()
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
local oCompras 
local dfechaAnt 

if resumencompra.RadioGroup_1.value = 1
	oCompras := ComprasProveedorDesdeHasta(resumencompra.datePicker_1.value,resumencompra.datePicker_2.value )
	dfechaAnt := oCompras:getRow(1):fieldget(1)
else
	oCompras := ComprasDesdeHasta(resumencompra.datePicker_1.value,resumencompra.datePicker_2.value )
	dfechaAnt := oCompras:getRow(1):fieldget(1)
endif
resumencompra.grid_1.deleteAllItems

for i= 1 to oCompras:lastRec()
	if dfechaAnt == oCompras:getRow(i):fieldget(1)
		//msginfo(str(oCompras:getRow(i):fieldget(3)))
		do case 
			case oCompras:getRow(i):fieldget(2) = 'C' 
				contado :=oCompras:getRow(i):fieldget(3)
				totalListadoContado += oCompras:getRow(i):fieldget(3)
				
			case oCompras:getRow(i):fieldget(2) = 'F'
				factura :=oCompras:getRow(i):fieldget(3)
				totalListadoFactura += oCompras:getRow(i):fieldget(3)

			case oCompras:getRow(i):fieldget(2) = 'R'
				recibo :=oCompras:getRow(i):fieldget(3)
				totalListadoRecibo += oCompras:getRow(i):fieldget(3)

			case oCompras:getRow(i):fieldget(2) = 'N'
				notacredito :=oCompras:getRow(i):fieldget(3)
				totalListadoNotasCredito += oCompras:getRow(i):fieldget(3)

			case oCompras:getRow(i):fieldget(2) = 'D'
			  devolucion :=oCompras:getRow(i):fieldget(3)
				totalListadoDevolucion += oCompras:getRow(i):fieldget(3)

		end case
	else
		totLinea := factura + contado -recibo -notacredito - devolucion
		resumencompra.grid_1.addItem({dfechaAnt,factura,recibo,notacredito,devolucion,contado,totLinea})
		contado := 0
		factura := 0
		recibo := 0
		notacredito := 0
		devolucion := 0
		do case 
			case oCompras:getRow(i):fieldget(2) = 'C' 
				contado :=oCompras:getRow(i):fieldget(3)
				totalListadoContado += oCompras:getRow(i):fieldget(3)
				
			case oCompras:getRow(i):fieldget(2) = 'F'
				factura :=oCompras:getRow(i):fieldget(3)
				totalListadoFactura += oCompras:getRow(i):fieldget(3)

			case oCompras:getRow(i):fieldget(2) = 'R'
				recibo :=oCompras:getRow(i):fieldget(3)
				totalListadoRecibo += oCompras:getRow(i):fieldget(3)

			case oCompras:getRow(i):fieldget(2) = 'N'
				notacredito :=oCompras:getRow(i):fieldget(3)
				totalListadoNotasCredito += oCompras:getRow(i):fieldget(3)

			case oCompras:getRow(i):fieldget(2) = 'D'
			  devolucion :=oCompras:getRow(i):fieldget(3)
				totalListadoDevolucion += oCompras:getRow(i):fieldget(3)

		end case
	endif
	dFechaAnt :=  oCompras:getRow(i):fieldget(1)
next 
		totLinea := factura + contado -recibo -notacredito - devolucion

resumencompra.grid_1.addItem({dfechaAnt,factura,recibo,notacredito,devolucion,contado,totLinea})
totalListado := totalListadoContado + totalListadoFactura - totalListadoDevolucion -totalListadoNotasCredito - totalListadoRecibo
resumencompra.grid_1.addItem({'Totales',totalListadoFactura,totalListadoRecibo,totalListadoNotasCredito, totalListadoDevolucion,totalListadoContado, totalListado})
Close Database


procedure traeInformacionComprasUsuarios()
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
local oCompras := ComprasUsuarioDesdeHasta(resumencompra.datePicker_1.value,resumencompra.datePicker_2.value )
local nUsuarioAnt := oCompras:getRow(1):fieldget(1)

if resumencompra.RadioGrup_1.value = 1
	oCompras := ComprasProveedorDesdeHasta(resumencompra.datePicker_1.value,resumencompra.datePicker_2.value )
	nUsuarioAnt := oCompras:getRow(1):fieldget(1)
else
	oCompras := ComprasUsuarioDesdeHasta(resumencompra.datePicker_1.value,resumencompra.datePicker_2.value )
	nUsuarioAnt := oCompras:getRow(1):fieldget(1)
endif

resumencompra.grid_1.deleteAllItems

for i= 1 to oCompras:lastRec()
	if nUsuarioAnt == oCompras:getRow(i):fieldget(1)
		//msginfo(str(oCompras:getRow(i):fieldget(3)))
		do case 
			case oCompras:getRow(i):fieldget(2) = 'C' 
				contado :=oCompras:getRow(i):fieldget(3)
				totalListadoContado += oCompras:getRow(i):fieldget(3)
				
			case oCompras:getRow(i):fieldget(2) = 'F'
				factura :=oCompras:getRow(i):fieldget(3)
				totalListadoFactura += oCompras:getRow(i):fieldget(3)

			case oCompras:getRow(i):fieldget(2) = 'D'
			  devolucion :=oCompras:getRow(i):fieldget(3)
				totalListadoDevolucion += oCompras:getRow(i):fieldget(3)

		end case
	else
		resumencompra.grid_1.addItem({nombreUsuario(nUsuarioAnt),factura,recibo,notacredito,devolucion,contado})
		contado := 0
		factura := 0
		devolucion := 0
		do case 
			case oCompras:getRow(i):fieldget(2) = 'C' 
				contado :=oCompras:getRow(i):fieldget(3)
				totalListadoContado += oCompras:getRow(i):fieldget(3)
				
			case oCompras:getRow(i):fieldget(2) = 'F'
				factura :=oCompras:getRow(i):fieldget(3)
				totalListadoFactura += oCompras:getRow(i):fieldget(3)

			case oCompras:getRow(i):fieldget(2) = 'D'
			  devolucion :=oCompras:getRow(i):fieldget(3)
				totalListadoDevolucion += oCompras:getRow(i):fieldget(3)

		end case
	endif
	nUsuarioAnt :=  oCompras:getRow(i):fieldget(1)
next 
resumencompra.grid_1.addItem({nombreUsuario(nUsuarioAnt),factura,recibo,notacredito,devolucion,contado})

resumencompra.grid_1.addItem({'Totales',totalListadoFactura,totalListadoRecibo,totalListadoNotasCredito, totalListadoDevolucion,totalListadoContado})



procedure exportarPlanillaCompras()
local cDescripcion 
local pArchivo
local dFechaDesde:= dtos(resumencompra.datePicker_1.value)
local dFechaHasta:= dtos(resumencompra.datePicker_2.value)
cDescripcion := "\Compras"+dFechaDesde+"-"+dFechaHasta+".csv"

pArchivo := fcreate(GetDesktopFolder()+cDescripcion,0)

clinea :='Proveedor,Facturas,Recibos,Notas Credito,Devolucion,Contado,Tot x Proveedor'
fwrite(parchivo,clinea  + chr(10))
for i= 1 to resumencompra.grid_1.itemCount
	clinea := alltrim(resumencompra.grid_1.item(i)[1]) ;
		+','+alltrim(str(resumencompra.grid_1.item(i)[2])) ;
		+','+alltrim(str(resumencompra.grid_1.item(i)[3])) ;
		+','+alltrim(str(resumencompra.grid_1.item(i)[4])) ;
		+','+alltrim(str(resumencompra.grid_1.item(i)[5])) ;
		+','+alltrim(str(resumencompra.grid_1.item(i)[6])) ;
		+','+alltrim(str(resumencompra.grid_1.item(i)[7]))
	fwrite(parchivo,clinea  + chr(10))
Next
fclose(parchivo)

*-----------------------------------------------------------------------*
*************************************************
*************************************************
******Implementaciones del modelo ***************
*************************************************
*************************************************
function ComprasDesdeHasta(dFechaDesde, dFechaHasta)
local cQuery, oQuery

cQuery := " select  fecha,tipo_documento, sum(importe) "
cQuery += " FROM factura_proveedor_cab "
cQuery += " where fecha between '"+dtos(dFechaDesde)+"' and '"+dtos(dFechaHasta)+"' "
cQuery += " group by 1,2 "
cQuery += " union all "
cQuery += " select fecha, tipo_documento, sum(importe) "
cQuery += " from recibo_proveedor_cab "
cQuery += " where fecha between '"+dtos(dFechaDesde)+"' and '"+dtos(dFechaHasta)+"' "
cQuery += " group by 1,2 "
cQuery += " order by 1,2 " 

oQuery := oServer:Query( cQuery )
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
  return .f.
else
	return oQuery
endIf

function ComprasProveedorDesdeHasta(dFechaDesde, dFechaHasta)
local cQuery, oQuery

cQuery := " select  p.nombre,f.tipo_documento, sum(f.importe) "
cQuery += " FROM factura_proveedor_cab f, proveedor p"
cQuery += " where f.fecha between '"+dtos(dFechaDesde)+"' and '"+dtos(dFechaHasta)+"' "
cQuery += " and p.id_proveedor = f.id_proveedor "
cQuery += " group by 1,2 "
cQuery += " union all "
cQuery += " select p.nombre, f.tipo_documento, sum(f.importe) "
cQuery += " from recibo_proveedor_cab f, proveedor p"
cQuery += " where f.fecha between '"+dtos(dFechaDesde)+"' and '"+dtos(dFechaHasta)+"' "
cQuery += " and p.id_proveedor = f.id_proveedor "
cQuery += " group by 1,2 "
cQuery += " order by 1,2 " 

oQuery := oServer:Query( cQuery )
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
  return .f.
else
	return oQuery
endIf

function ComprasUsuarioDesdeHasta(dFechaDesde, dFechaHasta)
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