#include <hmg.ch>
*************************************************
*************************************************
******Implementaciones de la vista***************
*************************************************
*************************************************

function buscoPrecio()
local cQuery := '' 
local oQuery

 
  if !IsWindowActive(buscoPrecio)
  				
		Load Window buscoPrecio
		buscoPrecio.title := "Precios Articulos"
		buscoPrecio.frame_1.caption := 'Repuestos'
		cQuery := " select a.codigo_barra, a.descripcion,a.dato_interno, date_format(a.fecha_precio,'%d/%m/%Y'),concat('$ ',a.precio_venta), p.nombre "
		cQuery += " from articulo a , proveedor p"
		cQuery += " where a.id_proveedor = p.id_proveedor "
		cQuery += " order by 2 limit 200"          
		oQuery := oServer:Query(cQuery )
		If oQuery:NetErr()												
			MsgInfo("SQL SELECT error: " + oQuery:Error())
			RELEASE WINDOW ALL
			Quit
		Endif
		
		For i := 1 To oQuery:LastRec()
			oRow := oQuery:GetRow(i)
			buscoPrecio.grid_1.addItem({alltrim(oRow:fieldGet(1)),alltrim(oRow:fieldGet(2)) , ;
																	alltrim(oRow:fieldGet(3)),oRow:fieldGet(4), oRow:fieldGet(5),;
																	oRow:fieldGet(6)})
		Next
		
		oQuery:Destroy()
		center window buscoPrecio
		activate window buscoPrecio
  endIf

return

procedure buscoConFiltro()
local cQuery,oQuery
//local cArticulo  := ''
//local cDescripcion:= ''
//local cProveedor := ''
if len(buscoPrecio.text_1.value) > 2 .or. len(buscoPrecio.text_2.value) > 2 .or. len(buscoPrecio.text_3.value) > 2
buscoPrecio.grid_1.deleteAllItems

cArticulo := iif(buscoPrecio.text_1.value = nil, '"%"',' "'+AllTrim(buscoPrecio.text_1.value)+'%"' )
cDescripcion :=iif(buscoPrecio.text_2.value = nil, '"%"',' "'+AllTrim(buscoPrecio.text_2.value)+'%"' )
cProveedor :=iif(buscoPrecio.text_3.value = nil, '"%"',' "'+AllTrim(buscoPrecio.text_3.value)+'%"' )

      
      
          cQuery := " select a.codigo_barra, a.descripcion,a.dato_interno ,date_format(a.fecha_precio,'%d/%m/%Y'),concat('$ ',a.precio_venta), p.nombre "
          cQuery += " from articulo a, proveedor p "          
  				cQuery += " where a.id_proveedor = p.id_proveedor "
  				cQuery += " and  a.descripcion LIKE "+cDescripcion+"  "
  				cQuery += " and a.dato_interno LIKE "+cProveedor+" "
  				cQuery += " and a.codigo_barra LIKE "+cArticulo+"  order by 2 limit 100"
          
  oQuery := oServer:Query(cQuery )
    If oQuery:NetErr()												
      MsgInfo("SQL SELECT error: " + oQuery:Error())
      RELEASE WINDOW ALL
      Quit
    Endif

    For i := 1 To oQuery:LastRec()
    	oRow := oQuery:GetRow(i)
      buscoPrecio.grid_1.addItem({alltrim(oRow:fieldGet(1)),alltrim(oRow:fieldGet(2)) , ;
																	alltrim(oRow:fieldGet(3)),oRow:fieldGet(4), oRow:fieldGet(5),;
																	oRow:fieldGet(6)})
    Next

    oQuery:Destroy()
endIf

procedure devBuscoPrecio()


cArticuloGlobal := buscoPrecio.grid_1.item(buscoPrecio.grid_1.value)[1]

release window buscoPrecio

return