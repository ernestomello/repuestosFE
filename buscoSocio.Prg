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
 
  if !IsWindowActive(conveniopagocobrador)
  		if vpc == 'a'
  			aBusca:= { {'TEXTBOX','CHARACTER'}, {'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'}}
  		else
  			aBusca := {{'TEXTBOX','NUMERIC','9999999999'}, {'TEXTBOX','CHARACTER'}, {'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'}}
  		endif
  		
      Load Window conveniopagocobrador
      conveniopagocobrador.title := titulo
      conveniopagocobrador.text_2.value := vpc
      do case 
        case vpc == 'cc'
          conveniopagocobrador.frame_1.caption := 'Clientes'
          cQuery := "select id_cliente, nombre,direccion_particular,'.' "
          cQuery += " from cliente "
          cQuery += " order by "+str(orden)+"  "
		case vpc == 'cf'
          conveniopagocobrador.frame_1.caption := 'Clientes'
          cQuery := "select id_cliente, nombre,direccion_particular,'.' "
          cQuery += " from cliente "
          cQuery += " where cta_cte = 1 order by 2 "
          
        case vpc == 'a'
          conveniopagocobrador.frame_1.caption := 'Repuestos'
          cQuery := "select codigo_barra, descripcion,concat('$',precio_venta),'.' from articulo order by 2 limit 200"          
  
        case vpc == 'l'
          conveniopagocobrador.frame_1.caption := 'Facturas'
          cQuery := " select f.id_factura,concat(d.descripcion,' ',f.serieCFE,'-',f.numeroCFE),concat(f.importe),date_format(f.fecha,'%d/%m/%Y') "
          cQuery += " from cfe_comprobante_cab f,cfe_tipos d"
          cQuery += " where f.tipoCFE = d.id_cfe "         
          cQuery += " and f.tipoCFE in (101,102,103,111,112,113,98)"         
          cQuery += " and date(f.fecha) = "+cFechaAnular+" "        
          cQuery += " order by 1 desc  "
		  
		case vpc == 'fe'
          conveniopagocobrador.frame_1.caption := 'Documentos sin FE'
          cQuery := " select f.id_factura,concat(d.descripcion,' ',f.serieCFE,'-',f.numeroCFE),concat(f.importe),date_format(f.fecha,'%d/%m/%Y') "
          cQuery += " from cfe_comprobante_cab f,cfe_tipos d"
          cQuery += " where f.tipoCFE = d.id_cfe  and f.tipoCFE in (101,102,111,112,103,113) "         
          cQuery += " and date(f.fecha) >= '20181101'  and isnull(cfe_codigo_seguridad)"        
          cQuery += " order by 1 desc  "
		 case vpc == 'n'
          conveniopagocobrador.frame_1.caption := 'Facturas'
          cQuery := " select f.id_factura,concat(d.descripcion,' ',f.serieCFE,'-',f.numeroCFE),concat(f.importe),date_format(f.fecha,'%d/%m/%Y') "
          cQuery += " from cfe_comprobante_cab f,cfe_tipos d"
          cQuery += " where f.tipoCFE = d.id_cfe "         
          cQuery += " order by 1 desc  limit 50" 
		 
        case vpc == 'm'
          conveniopagocobrador.frame_1.caption := 'Marcas'
          cQuery := "select id_marca, descripcion,'.','.' from marca order by 2"
        case vpc == 'p'
          conveniopagocobrador.frame_1.caption := 'Proveedor'
          cQuery := "select id_proveedor, nombre,'.','.' from proveedor order by 2"
        case vpc = 'u'
          conveniopagocobrador.frame_1.caption := 'Vendedor'
          cQuery := "select id_cajero, nombre,'.','.' from cajero order by 2"
        case vpc == 'o'
          conveniopagocobrador.frame_1.caption := 'Modelos'
          cQuery := "select id_modelo, descripcion,'.','.' from modelo "
          cQuery := cQuery+ " where id_marca = "+str(filtro)+" order by 2"
		
		case vpc =='pc'
		  conveniopagocobrador.frame_1.caption := titulo
		  cQuery := " select f.id_factura,concat(d.descripcion,' ',f.serieCFE,'-',f.numeroCFE),date_format(f.fecha,'%d/%m/%Y'),'.' "
		  cQuery += " from cfe_comprobante_cab f,cfe_tipos d "
		  cQuery += " where f.tipoCFE = d.id_cfe "
		  cQuery += " and f.tipoCFE = 91 "
	end case
  
  oQuery := oServer:Query(cQuery )
    If oQuery:NetErr()												
      MsgInfo("SQL SELECT error: " + oQuery:Error())
      RELEASE WINDOW ALL
      Quit
    Endif

    For i := 1 To oQuery:LastRec()
      oRow := oQuery:GetRow(i)
    	conveniopagocobrador.grid_1.addItem({oRow:fieldGet(1),oRow:fieldGet(2) ,oRow:fieldGet(3),oRow:fieldGet(4) })
    Next

    oQuery:Destroy()
  center window conveniopagocobrador
  activate window conveniopagocobrador
  endIf

return

procedure busConFiltro(vpc,filtro,nOrden)
local cQuery,oQuery
local orden := filtro 
local cFechaAnular:= PARAMETROini("FECHANULAR","C")

//MsgInfo(str(nOrden))
do case
	case filtro = 1
		If len(conveniopagocobrador.text_1.value) < 2
			return .f.
		endif		
	case filtro = 2
		If len(conveniopagocobrador.text_1.value) < 1
			return .f.
		endif
	case filtro = 3
		If len(conveniopagocobrador.text_1.value) < 5
			return .f.
		endif
end case

conveniopagocobrador.grid_1.deleteAllItems
cNombre := iif(len(alltrim(conveniopagocobrador.text_1.value)) = 0, '"%"','"'+AllTrim(conveniopagocobrador.text_1.value)+'%"' )
 do case 
        case vpc == 'cc'
          conveniopagocobrador.frame_1.caption := 'Clientes'
          cQuery := " select id_cliente, nombre,direccion_particular,'.' from cliente "
          cQuery += " where nombre LIKE "+cNombre+"  order by "+str(orden)+" limit 100 "
		case vpc == 'cf'
          conveniopagocobrador.frame_1.caption := 'Clientes'
          cQuery := "select id_cliente, nombre,direccion_particular ,'.'"
          cQuery += " from cliente "
          cQuery += " where cta_cte = 1 and nombre LIKE "+cNombre+"  order by "+str(orden)+" limit 100 "
          
        case vpc == 'a'
			conveniopagocobrador.frame_1.caption := 'Repuestos'
			cQuery := "select codigo_barra, descripcion,concat('$',precio_venta),'.' from articulo "          
			cQuery += " where descripcion LIKE "+cNombre+"  order by "+str(orden)+" limit 100"
        case vpc == 'l'
          conveniopagocobrador.frame_1.caption := 'Facturas'
		  cQuery := " select f.id_factura,concat(d.descripcion,' ',f.serieCFE,'-',f.numeroCFE),concat(f.importe),date_format(f.fecha,'%d/%m/%Y') "
          cQuery += " from cfe_comprobante_cab f,cfe_tipos d"
          cQuery += " where f.tipoCFE = d.id_cfe "         
          // cQuery += " and date(f.fecha) = "+cFechaAnular+" "        
		do case 
			case filtro = 1
			cQuery += " and  f.id_factura LIKE "+cNombre+" "
			cQuery += " order by "+str(orden)+" desc  limit 30"
			case filtro = 2
			cQuery += " and  f.numeroCFE LIKE "+cNombre+" "
			cQuery += " order by "+str(orden)+" desc  limit 30"
			case filtro = 3
			cQuery += " and date_format(f.fecha,'%d/%m/%Y')LIKE "+cNombre+" "
			cQuery += " order by "+str(orden)+" desc  limit 200"
		end case
          		  
		  case vpc == 'fe'
          conveniopagocobrador.frame_1.caption := 'Documentos sin FE'
          cQuery := " select f.id_factura,concat(d.descripcion,' ',f.serieCFE,'-',f.numeroCFE),concat(f.importe),date_format(f.fecha,'%d/%m/%Y') "
          cQuery += " from cfe_comprobante_cab f,cfe_tipos d"
          cQuery += " where f.tipoCFE = d.id_cfe  and f.tipoCFE in (101,102,111,112,103,113)"         
          cQuery += " and date(f.fecha) >= '20181101' and isnull(cfe_codigo_seguridad) "        
          cQuery += " order by 1 desc  "
		  case vpc == 'n'
          conveniopagocobrador.frame_1.caption := 'Facturas'
		  cQuery := " select f.id_factura,concat(d.descripcion,' ',f.serieCFE,'-',f.numeroCFE),concat(f.importe),date_format(f.fecha,'%d/%m/%Y') "
          cQuery += " from cfe_comprobante_cab f,cfe_tipos d"
          cQuery += " where f.tipoCFE = d.id_cfe "         
             
			do case 
				case filtro = 1
				cQuery += " and  f.id_factura LIKE "+cNombre+" "
				cQuery += " order by "+str(orden)+" desc  limit 30"
				case filtro = 2
				cQuery += " and  f.numeroCFE LIKE "+cNombre+" "
				cQuery += " order by "+str(orden)+" desc  limit 30"
				case filtro = 3
				cQuery += " and date_format(f.fecha,'%d/%m/%Y')LIKE "+cNombre+" "
				cQuery += " order by "+str(orden)+" desc  limit 200"
			end case
		
        case vpc == 'm'
          conveniopagocobrador.frame_1.caption := 'Marcas'
          cQuery := "select id_marca, descripcion,'.','.' from marca "
          cQuery += " where descripcion LIKE "+cNombre+"  order by "+str(orden)+" limit 100"
        case vpc == 'p'
	        conveniopagocobrador.frame_1.caption := 'Proveedor'
	        cQuery := "select id_proveedor, nombre,'.','.' from proveedor "
	        cQuery += " where nombre LIKE "+cNombre+"  order by "+str(orden)+" limit 100"
        case vpc = 'u'
	        conveniopagocobrador.frame_1.caption := 'Usuarios'
	        cQuery := "select id_cajero, nombre,'.','.' from cajero "
	        cQuery += " where nombre LIKE "+cNombre+"  order by "+str(orden)+" "
         case vpc == 'o'
          conveniopagocobrador.frame_1.caption := 'Modelos'
          cQuery := "select id_modelo, descripcion,'1','.' from modelo "
          cQuery += " where id_marca = "+str(filtro)+" and descripcion LIKE "+cNombre+" "
          cQuery += " order by "+str(orden)+" limit 100"
		 case vpc =='pc'
		  conveniopagocobrador.frame_1.caption := "Presupuestos Contado"
		  cQuery := " select f.id_factura,concat(d.descripcion,' ',f.serieCFE,'-',f.numeroCFE),date_format(f.fecha,'%d/%m/%Y') ,'.'"
		    cQuery += " from cfe_comprobante_cab f,cfe_tipos d"
          cQuery += " where f.tipoCFE = d.id_cfe "         
		  cQuery += " and  f.descripcion LIKE "+cNombre+" "
		  cQuery += " and f.tipoCFE = 91 "
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
      conveniopagocobrador.grid_1.addItem({oRow:fieldGet(1),oRow:fieldGet(2),oRow:fieldGet(3),oRow:fieldGet(4)  })
    Next

    oQuery:Destroy()


procedure devconpagcob()

if conveniopagocobrador.text_2.value == 'a'
	cArticuloGlobal := conveniopagocobrador.grid_1.item(conveniopagocobrador.grid_1.value)[1]
else
	nSocioGlobal := conveniopagocobrador.grid_1.item(conveniopagocobrador.grid_1.value)[1]
endIf 

if nSocioGlobal != 0 .and. conveniopagocobrador.text_2.value == 'n'
	cargoDocumentoGen(nSocioGlobal, "MOSTRAR")
else
  release window conveniopagocobrador
endif

return