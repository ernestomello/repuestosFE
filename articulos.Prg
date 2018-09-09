#include <hmg.ch>

procedure mantenimientoArticulo(cArticulo)
load window articulo
rellenoComboUnidad()
rellenoComboLocacion()
rellenoComboMoneda()
if len(alltrim(cArticulo)) != 0
	rellenoDatosArticulo(cArticulo)
endIf

articulo.center
articulo.activate


procedure rellenoComboUnidad()
local oUnidades := oUnidad()

for i = 1 to oUnidades:lastrec()
	articulo.combo_1.addItem(alltrim(oUnidades:getRow(i):fieldGet(2)))
next

procedure rellenoComboLocacion()
local oLocacion := oLocacion()

for i = 1 to oLocacion:lastrec()
	articulo.combo_3.addItem(alltrim(oLocacion:getRow(i):fieldGet(2)))
next

procedure rellenoComboMoneda()
local oMonedas := oMoneda()

for i = 1 to oMonedas:lastrec()
	articulo.combo_2.addItem(alltrim(oMonedas:getRow(i):fieldGet(1)))
next

procedure rellenoDatosArticulo(cArticulo)

local oArticulos := oArticulo(cArticulo)
local oArticulosCompra := oArticuloCompra(cArticulo)
local cUnidad := nombreUnidad(oArticulos:getRow(1):fieldGet(11))
local cMoneda := signoMOneda(oArticulos:getRow(1):fieldGet(12))
local cLocacion := descripcionLocacion(oArticulos:getRow(1):fieldGet(14))

borraArticulo()

articulo.text_1.value := oArticulos:getRow(1):fieldGet(1)
articulo.text_2.value := oArticulos:getRow(1):fieldGet(2)
articulo.marca.value := oArticulos:getRow(1):fieldGet(3)
articulo.text_3.value := descripcionMarca(oArticulos:getRow(1):fieldGet(3))
articulo.modelo.value := oArticulos:getRow(1):fieldGet(4)
articulo.text_4.value := descripcionModelo(oArticulos:getRow(1):fieldGet(4))
articulo.spinner_1.value := iif(oArticulos:getRow(1):fieldGet(6)!= 0,oArticulos:getRow(1):fieldGet(6),year(date()))
articulo.text_5.value := oArticulos:getRow(1):fieldGet(5)
articulo.text_9.value := nombreProveedor(oArticulos:getRow(1):fieldGet(5))

articulo.text_6.value := oArticulos:getRow(1):fieldGet(8)
articulo.text_7.value := oArticulos:getRow(1):fieldGet(9)
articulo.text_8.value := oArticulos:getRow(1):fieldGet(10)
articulo.text_10.value := oArticulos:getRow(1):fieldGet(13)
articulo.text_11.value := oArticulosCompra:getRow(1):fieldGet(2)
articulo.text_12.value := oArticulosCompra:getRow(1):fieldGet(3)
articulo.datepicker_1.value := oArticulos:getRow(1):fieldGet(7)

for i = 1 to articulo.combo_1.itemCount
	if alltrim(articulo.combo_1.item(i)) = alltrim(cUnidad)
		articulo.combo_1.Value  := i
	endIf
next
for i = 1 to articulo.combo_3.itemCount
	if alltrim(articulo.combo_3.item(i)) = alltrim(cLocacion)
		articulo.combo_3.Value  := i
	endIf
next
for i = 1 to articulo.combo_2.itemCount
	if alltrim(articulo.combo_2.item(i)) = alltrim(cMoneda)
		articulo.combo_2.Value  := i
	endIf
next

function cambioMoneda()
local nMoneda := monedaArticulo(articulo.text_1.value)
local cMoneda := articulo.combo_2.value 
iif (nMoneda = 2,articulo.text_7.fontcolor := {0,128,0},articulo.text_7.fontcolor := {0,0,0})
iif (nMoneda = 2,articulo.text_8.fontcolor := {0,128,0},articulo.text_8.fontcolor := {0,0,0})
iif (cMoneda = 3,articulo.text_7.fontcolor := {0,128,0},articulo.text_7.fontcolor := {0,0,0})
iif (cMoneda = 3,articulo.text_8.fontcolor := {0,128,0},articulo.text_8.fontcolor := {0,0,0})

procedure borraArticulo()

articulo.text_1.value := ""
articulo.text_2.value := ""
articulo.text_3.value := ""
articulo.text_4.value := ""
articulo.text_10.value := ""
articulo.text_9.value := ""
articulo.text_11.value := ctod("00/00/0000")
articulo.text_12.value := ""
articulo.text_5.value := 0
articulo.text_6.value := 22
articulo.text_7.value := 0
articulo.text_8.value := 0
articulo.marca.value := 0
articulo.modelo.value := 0
articulo.spinner_1.value := year(date())
articulo.combo_1.value := 0
articulo.combo_2.value := 0
articulo.combo_3.value := 0



procedure buscarArticulo()
local nArticulo := articulo.text_1.value
if existeArticulo(nArticulo)
		    rellenoDatosArticulo(nArticulo)
		    cArticuloGlobal := ""
	  else
	    
	      busquedaGeneral('a')
	    
	       
		      if len(cArticuloGlobal) != 0
		        	rellenoDatosArticulo(cArticuloGlobal)      
		        	cArticuloGlobal := ""
		      endIf
	  endif
	
return

procedure buscaMarca()

busquedaGeneral('m')
if nsocioGlobal != 0
	articulo.text_3.value := alltrim(descripcionMarca(nSocioGlobal))
	articulo.marca.value := nSocioGlobal
	nSocioGlobal := 0
endIf

procedure buscaModelo()

busquedaGeneral('o',articulo.marca.value)
if nSocioGlobal != 0
		articulo.text_4.value := alltrim(descripcionModelo(nSocioGlobal))
		articulo.modelo.value := nSocioGlobal
		nSocioGlobal := 0
endIf

procedure buscarProveedor()
local nProveedor := articulo.text_5.value

if existeProveedor(nProveedor)
	articulo.text_9.value := nombreProveedor(nProveedor)
	articulo.text_5.value := nProveedor
else

	busquedaGeneral('p')
	if nSocioGlobal != 0
			articulo.text_9.value := nombreProveedor(nSocioGlobal)
			articulo.text_5.value := nSocioGlobal
			nSocioGlobal := 0
	endIf
endif


procedure guardarArticulo()
local nUnidad := idUnidad(articulo.combo_1.displayValue)
local nMoneda := idMoneda(articulo.combo_2.displayValue)
local nlocacion := idLocacion(articulo.combo_3.displayValue)

if !controloArticulo()
	return .f.
endif
if existeArticulo(articulo.text_1.value) 
	if modificoArticulo(articulo.text_1.value,substr(articulo.text_2.value,1,50), ;
	articulo.marca.value, articulo.modelo.value,articulo.spinner_1.value, ;
	articulo.text_5.value, articulo.datepicker_1.value, ;
	articulo.text_6.value, articulo.text_7.value,articulo.text_8.value,nUnidad,nMoneda,articulo.text_10.value,nlocacion)
		if existeArticuloCompra(articulo.text_1.value)
			if modificoArticuloCompra(articulo.text_1.value,articulo.text_11.value, articulo.text_12.value)
				msgInfo("Artículo Modificado")
				borraArticulo()	
			else
				msgInfo("No se pudieron guardar los cambios.CONSULTE")
			endif
		else
			if altaArticuloCompra(articulo.text_1.value,articulo.text_11.value, articulo.text_12.value)
				msgInfo("Artículo Modificado")
				borraArticulo()	
			else
				msgInfo("No se pudieron guardar los cambios.CONSULTE")
			endif
		endif		
	else
		msgInfo("No se pudieron guardar los cambios.CONSULTE")
	endIf
else 

if len(alltrim(articulo.text_1.value)) != 0 
	
	if ingresoArticulo(articulo.text_1.value,substr(articulo.text_2.value,1,50), ;
		articulo.marca.value, articulo.modelo.value,articulo.spinner_1.value, ;
		articulo.text_5.value, articulo.datepicker_1.value, ;
		articulo.text_6.value, articulo.text_7.value,articulo.text_8.value,nUnidad,nMoneda,articulo.text_10.value, nlocacion)
		if existeArticuloCompra(articulo.text_1.value)
			if modificoArticuloCompra(articulo.text_1.value,articulo.text_11.value, articulo.text_12.value)
				msgInfo("Artículo Modificado")
				borraArticulo()	
			else
				msgInfo("No se pudieron guardar los cambios.CONSULTE")
			endif
		else
			if altaArticuloCompra(articulo.text_1.value,articulo.text_11.value, articulo.text_12.value)
				msgInfo("Artículo Modificado")
				borraArticulo()	
			else
				msgInfo("No se pudieron guardar los cambios.CONSULTE")
			endif
		endif		
	else
		msgInfo("No se pudieron guardar los cambios.CONSULTE")
	endIf
else
	msginfo("Debe Ingresar un codigo")
endIf

endIf

function controloArticulo()

if len(articulo.text_1.value) = 0
	msginfo("El Código de Barras NO Puede estar Vacío")
	articulo.text_1.setfocus
	return .f.
endif

if len(articulo.text_2.value) = 0
	msginfo("La Descripción NO Puede estar Vacío")
	articulo.text_2.setfocus
	return .f.
endif

if articulo.text_5.value = 0
	msginfo("Debe Indicar un Proveedor")
	articulo.text_5.setfocus
	return .f.
endif

if articulo.combo_2.value = 0
	msginfo("Debe Indicar una MOneda")
	articulo.combo_2.setfocus
	return .f.
endif
if articulo.text_7.value = 0
	msginfo("Debe Indicar un Precio de costo")
	articulo.text_7.setfocus
	return .f.
endif

if articulo.text_8.value = 0
	msginfo("Debe Indicar un Precio de Venta")
	articulo.text_8.setfocus
	return .f.
endif


return .t.
*************************************************
*************************************************
******Implementaciones del modelo ***************
*************************************************
*************************************************
function ingresoArticulo(cCodBarra,cDescripcion,nMarca,nModelo,nAnio,nProveedor,dFecha,niva,nCosto,nVenta,nUnidad,nMoneda,cDatosInternos,nLocacion)
local cQuery, oQuery

cQuery := " insert into articulo values( '"+cCodBarra+"' , '"+cDescripcion+"',  "
cQuery += " "+str(nMarca)+", "
cQuery += " "+str(nModelo)+", "
cQuery += " "+str(nProveedor)+", "
cQuery += " "+str(nAnio)+", "
cQuery += " '"+dtos(dFecha)+"', "
cQuery += " "+str(niva)+", "
cQuery += " "+str(nCosto)+", "
cQuery += " "+str(nVenta)+", "
cQuery += " "+str(nUnidad)+", "
cQuery += " "+str(nMoneda)+", "
cQuery += " '"+cDatosInternos+"',"
cQuery += " "+str(nLocacion)+" )"
oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
  return .f.
else
  return .t.
endIf

function modificoArticulo(cCodBarra,cDescripcion,nMarca,nModelo,nAnio,nProveedor,dFecha,niva,nCosto,nVenta,nUnidad,nMoneda,cDatosInternos,nLocacion)
local cQuery, oQuery

cQuery := " update articulo set "
cQuery += " descripcion = '"+cDescripcion+"',  "
cQuery += " id_marca = "+str(nMarca)+", "
cQuery += " id_modelo = "+str(nModelo)+", "
cQuery += " anio = "+str(nAnio)+", "
cQuery += " id_proveedor = "+str(nProveedor)+", "
cQuery += " fecha_precio ='"+dtos(dFecha)+"', "
cQuery += " iva = "+str(niva)+", "
cQuery += " precio_costo = "+str(nCosto)+", "
cQuery += " precio_venta = "+str(nVenta)+", "
cQuery += " unidad = "+str(nUnidad)+", "
cQuery += " moneda = "+str(nMoneda)+", "
cQuery += " dato_interno = '"+cDatosInternos+"', "
cQuery += " id_locacion = "+str(nLocacion)+" "
cQuery += " where codigo_barra = '"+cCodBarra+"' "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
  return .f.
else
  return .t.
endIf

function oArticulo(nArticulo)
local cQuery
local oQuery

cQuery := "select * from articulo where  codigo_barra = '"+nArticulo+"' "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery
endIf


function codigoBarraArticulo(nArticulo)
local cQuery
local oQuery

cQuery := "select codigo_barra from articulo where  codigo_barra = '"+nArticulo+"' "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf

function descripcionArticulo(nArticulo)
local cQuery
local oQuery

cQuery := "select descripcion from articulo where  codigo_barra = '"+nArticulo+"'"

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return alltrim(oQuery:GetRow(1):fieldGet(1))
endIf

function locacionArticulo(nArticulo)
local cQuery
local oQuery

cQuery := " select l.descripcion "
cQuery += " from articulo a, locacion l "
cQuery += " where  a.id_locacion = l.id_locacion and a.codigo_barra = '"+nArticulo+"'"

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return alltrim(oQuery:GetRow(1):fieldGet(1))
endIf


function precioVenta(nArticulo)
local cQuery
local oQuery

cQuery := "select precio_venta from articulo where  codigo_barra = '"+nArticulo+"'"

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf

function precioCosto(nArticulo)
local cQuery
local oQuery

cQuery := "select precio_costo from articulo where  codigo_barra = '"+nArticulo+"'"

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf

function fechaPrecio(nArticulo)
local cQuery
local oQuery

cQuery := "select fecha_precio from articulo where  codigo_barra = '"+nArticulo+"'"

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf

function id_marca(nArticulo)
local cQuery
local oQuery

cQuery := "select id_marca from articulo where  codigo_barra = '"+nArticulo+"'"

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf

function monedaArticulo(nArticulo)
local cQuery
local oQuery

cQuery := "select moneda from articulo where  codigo_barra = '"+nArticulo+"'"

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf

function id_modelo(nArticulo)
local cQuery
local oQuery

cQuery := "select id_modelo from articulo where  codigo_barra = '"+nArticulo+"'"

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf

function anio(nArticulo)
local cQuery
local oQuery

cQuery := "select anio from articulo where  codigo_barra = '"+nArticulo+"'"

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf
function id_proveedor(nArticulo)
local cQuery
local oQuery

cQuery := "select id_proveedor from articulo where  codigo_barra = '"+nArticulo+"'"

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf

function iva(nArticulo)
local cQuery
local oQuery

cQuery := "select iva from articulo where  codigo_barra = '"+nArticulo+"'"

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf

function unidad(nArticulo)
local cQuery
local oQuery

cQuery := "select unidad from articulo where  codigo_barra = '"+nArticulo+"'"

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf

function existeArticulo(nArticulo)
local cQuery
local oQuery

cQuery := "select * from articulo where  codigo_barra = '"+nArticulo+"' "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
endIf

if oQuery:LastRec() > 0
    return .t.
  else
    return .f.
  endif

function modificoPrecioVenta(nArticulo,nImporte)  
local cQuery
local oQuery

cQuery := "update articulo set precio_venta= "+str(nImporte)+", fecha_precio = current_date where  codigo_barra = '"+nArticulo+"' "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
endIf

if oQuery:LastRec() > 0
    return .t.
  else
    return .f.
  endif

