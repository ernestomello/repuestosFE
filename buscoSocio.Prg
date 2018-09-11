#include <hmg.ch>
*************************************************
*************************************************
******Implementaciones de la vista***************
*************************************************
*************************************************

function busquedaGeneral(vpc,filtro,titulo,nOrden)
local cQuery := '' 
local oQuery
local orden := nOrden
local cFechaAnular:= 	PARAMETROini("FECHANULAR","C")
 
  if !IsWindowActive(busqueda)
  		if vpc == 'a'
  			aBusca:= { {'TEXTBOX','CHARACTER'}, {'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'}}
  		else
  			aBusca := {{'TEXTBOX','NUMERIC','9999999999'}, {'TEXTBOX','CHARACTER'}, {'TEXTBOX','CHARACTER'}}
  		endif
  		
      Load Window conveniopagocobrador
      conveniopagocobrador.title := titulo
      conveniopagocobrador.text_2.value := vpc
      
      do case 
        case vpc == 'cc'
          conveniopagocobrador.frame_1.caption := 'Clientes'
          cQuery := "select id_cliente, nombre,direccion_particular "
          cQuery += " from cliente "
          cQuery += " order by "+str(orden)+" LIMIT 200"
		case vpc == 'cf'
          conveniopagocobrador.frame_1.caption := 'Clientes'
          cQuery := "select id_cliente, nombre,direccion_particular "
          cQuery += " from cliente "
          cQuery += " where cta_cte = 1 order by 2 "
          
        case vpc == 'a'
          conveniopagocobrador.frame_1.caption := 'Repuestos'
          cQuery := "select codigo_barra, descripcion,concat('$',precio_venta) from articulo order by 2 limit 200"          
  
        case vpc == 'l'
          conveniopagocobrador.frame_1.caption := 'Facturas'
          cQuery := " select f.numero_factura,d.descripcion,date_format(f.fecha,'%d/%m/%Y') "
          cQuery += " from factura_cliente_cab f,documento d"
          cQuery += " where d.id_documento = f.tipo_documento "
          cQuery += " and f.anulado = 'N' "
          cQuery += " and date(f.fecha) = "+cFechaAnular+" "
          cQuery += " union all " 
          cQuery += " select r.id_recibo, d.descripcion, date_format(r.fecha,'%d/%m/%Y') "
          cQuery += " from recibo_cliente_cab r, documento d "
          cQuery += " where d.id_documento = r.tipo_documento "
          cQuery += " and r.anulado ='N' "
          cQuery += " and date(r.fecha) = "+cFechaAnular+" "
          cQuery += " order by 3 desc ,1 desc  "
        case vpc == 'n'
          conveniopagocobrador.frame_1.caption := 'Documentos Por Número'
          cQuery := " select f.numero_factura,d.descripcion,date_format(f.fecha,'%d/%m/%Y %H:%i') "
          cQuery += " from factura_cliente_cab f,documento d"
          cQuery += " where d.id_documento = f.tipo_documento "
          //cQuery += " and f.anulado = 'N' "
          cQuery += " union all " 
          cQuery += " select r.id_recibo, d.descripcion, date_format(r.fecha,'%d/%m/%Y') "
          cQuery += " from recibo_cliente_cab r, documento d "
          cQuery += " where d.id_documento = r.tipo_documento "
          //cQuery += " and r.anulado ='N' "
          cQuery += " order by  1  limit 200"
        case vpc == 'm'
          conveniopagocobrador.frame_1.caption := 'Marcas'
          cQuery := "select id_marca, descripcion,'1' from marca order by 2"
        case vpc == 'p'
          conveniopagocobrador.frame_1.caption := 'Proveedor'
          cQuery := "select id_proveedor, nombre,'1' from proveedor order by 2"
        case vpc = 'u'
          conveniopagocobrador.frame_1.caption := 'Vendedor'
          cQuery := "select id_cajero, nombre,'1' from cajero order by 2"
        case vpc == 'o'
          conveniopagocobrador.frame_1.caption := 'Modelos'
          cQuery := "select id_modelo, descripcion,'1' from modelo "
          cQuery := cQuery+ " where id_marca = "+str(filtro)+" order by 2"
		
		case vpc =='pc'
		  conveniopagocobrador.frame_1.caption := titulo
		  cQuery := " select f.numero_factura,f.descripcion,date_format(f.fecha,'%d/%m/%Y') "
		  cQuery += " from factura_cliente_cab f,documento d"
		  cQuery += " where d.id_documento = f.tipo_documento "
		  cQuery += " and f.anulado = 'N' "
		  // cQuery += " and date(f.fecha) = "+cFechaAnular+" "
		  cQuery += " and f.tipo_documento = 'Q' "
	end case
  
  
  oQuery := oServer:Query(cQuery )
    If oQuery:NetErr()												
      MsgInfo("SQL SELECT error: " + oQuery:Error())
      RELEASE WINDOW ALL
      Quit
    Endif

    For i := 1 To oQuery:LastRec()
      oRow := oQuery:GetRow(i)
    	conveniopagocobrador.grid_1.addItem({oRow:fieldGet(1),oRow:fieldGet(2) ,iif(oRow:fieldGet(3)='1','',oRow:fieldGet(3))})
    Next

    oQuery:Destroy()
  center window conveniopagocobrador
  activate window conveniopagocobrador
  endIf

return

procedure busConFiltro(vpc,filtro,nOrden)
local cQuery,oQuery
local orden := nOrden 
local cFechaAnular:= PARAMETROini("FECHANULAR","C")

//MsgInfo(str(nOrden))

If len(conveniopagocobrador.text_1.value) > 2
conveniopagocobrador.grid_1.deleteAllItems
cNombre := iif(conveniopagocobrador.text_1.value = nil, '"%"',' "%'+AllTrim(conveniopagocobrador.text_1.value)+'%"' )
 do case 
        case vpc == 'cc'
          conveniopagocobrador.frame_1.caption := 'Clientes'
          cQuery := " select id_cliente, nombre,direccion_particular from cliente "
          cQuery += " where nombre LIKE "+cNombre+"  order by "+str(orden)+" limit 100 "
		case vpc == 'cf'
          conveniopagocobrador.frame_1.caption := 'Clientes'
          cQuery := "select id_cliente, nombre,direccion_particular "
          cQuery += " from cliente "
          cQuery += " where cta_cte = 1 and nombre LIKE "+cNombre+"  order by "+str(orden)+" limit 100 "
          
        case vpc == 'a'
			conveniopagocobrador.frame_1.caption := 'Repuestos'
			cQuery := "select codigo_barra, descripcion,concat('$',precio_venta) from articulo "          
			cQuery += " where descripcion LIKE "+cNombre+"  order by "+str(orden)+" limit 100"
        case vpc == 'l'
          conveniopagocobrador.frame_1.caption := 'Facturas'
          cQuery := " select f.numero_factura,d.descripcion,date_format(f.fecha,'%d/%m/%Y %H:%i') "
          cQuery += " from factura_cliente_cab f,documento d"
          cQuery += " where d.id_documento = f.tipo_documento "
          cQuery += " and f.anulado = 'N' "
          cQuery += " and date(f.fecha) = "+cFechaAnular+" "
          cQuery += " and  d.descripcion LIKE "+cNombre+" "
          cQuery += " union all " 
          cQuery += " select r.id_recibo, d.descripcion, date_format(r.fecha,'%d/%m/%Y') "
          cQuery += " from recibo_cliente_cab r, documento d "
          cQuery += " where d.id_documento = r.tipo_documento "
          cQuery += " and r.anulado ='N' "
          cQuery += " and date(r.fecha) = "+cFechaAnular+" "
          cQuery += " and  d.descripcion LIKE "+cNombre+" "
          cQuery += " order by "+str(orden)+" desc, 1 desc"
				case vpc == 'n'
          conveniopagocobrador.frame_1.caption := 'Documentos Por Número'
          cQuery := " select f.numero_factura,d.descripcion,date_format(f.fecha,'%d/%m/%Y %H:%i') "
          cQuery += " from factura_cliente_cab f,documento d"
          cQuery += " where d.id_documento = f.tipo_documento "
        //  cQuery += " and f.anulado = 'N' "
          cQuery += " and  f.numero_factura LIKE "+cNombre+" "
          cQuery += " union all " 
          cQuery += " select r.id_recibo, d.descripcion, date_format(r.fecha,'%d/%m/%Y') "
          cQuery += " from recibo_cliente_cab r, documento d "
          cQuery += " where d.id_documento = r.tipo_documento "
         // cQuery += " and r.anulado ='N' "
          cQuery += " and  r.id_recibo LIKE "+cNombre+" "
          cQuery += " order by "+str(orden)+" limit 100"
        case vpc == 'm'
          conveniopagocobrador.frame_1.caption := 'Marcas'
          cQuery := "select id_marca, descripcion,'1' from marca "
          cQuery += " where descripcion LIKE "+cNombre+"  order by "+str(orden)+" limit 100"
        case vpc == 'p'
	        conveniopagocobrador.frame_1.caption := 'Proveedor'
	        cQuery := "select id_proveedor, nombre,'1' from proveedor "
	        cQuery += " where nombre LIKE "+cNombre+"  order by "+str(orden)+" limit 100"
        case vpc = 'u'
	        conveniopagocobrador.frame_1.caption := 'Usuarios'
	        cQuery := "select id_cajero, nombre,'1' from cajero "
	        cQuery += " where nombre LIKE "+cNombre+"  order by "+str(orden)+" "
         case vpc == 'o'
          conveniopagocobrador.frame_1.caption := 'Modelos'
          cQuery := "select id_modelo, descripcion,'1' from modelo "
          cQuery += " where id_marca = "+str(filtro)+" and descripcion LIKE "+cNombre+" "
          cQuery += " order by "+str(orden)+" limit 100"
		 case vpc =='pc'
		  conveniopagocobrador.frame_1.caption := "Presupuestos Contado"
		  cQuery := " select f.numero_factura,f.descripcion,date_format(f.fecha,'%d/%m/%Y') "
		  cQuery += " from factura_cliente_cab f,documento d"
		  cQuery += " where d.id_documento = f.tipo_documento "
		  cQuery += " and f.anulado = 'N' "
		  cQuery += " and  f.descripcion LIKE "+cNombre+" "
		  // cQuery += " and date(f.fecha) = "+cFechaAnular+" "
		  cQuery += " and f.tipo_documento = 'Q' "
		  cQuery += " order by "+str(orden)+" desc limit 100"
		  end case
          
  oQuery := oServer:Query(cQuery )
    If oQuery:NetErr()												
      MsgInfo("SQL SELECT error: " + oQuery:Error())
      RELEASE WINDOW ALL
      Quit
    Endif

    For i := 1 To oQuery:LastRec()
    	oRow := oQuery:GetRow(i)
      conveniopagocobrador.grid_1.addItem({oRow:fieldGet(1),oRow:fieldGet(2),iif(oRow:fieldGet(3)='1','',oRow:fieldGet(3)) })
    Next

    oQuery:Destroy()
endIf

procedure devconpagcob()

if conveniopagocobrador.text_2.value == 'a'
	cArticuloGlobal := conveniopagocobrador.grid_1.item(conveniopagocobrador.grid_1.value)[1]
else
	nSocioGlobal := conveniopagocobrador.grid_1.item(conveniopagocobrador.grid_1.value)[1]
endIf 
release window conveniopagocobrador

return