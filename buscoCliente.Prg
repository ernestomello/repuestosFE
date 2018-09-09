#include <hmg.ch>

*************************************************
*************************************************
******Implementaciones de la vista***************
*************************************************
*************************************************

function buscoClienteM(vpc,filtro,titulo,nOrden)
local cQuery := '' 
local oQuery

 
  if !IsWindowActive(buscoCliente)
  				
		Load Window buscoCliente
		buscoCliente.title := "Clientes"
		buscoCliente.frame_1.caption := 'Clientes'
		do case 
        case vpc == 'cc'
          cQuery := " select id_cliente,nombre,direccion_particular,telefono,celular,correo_electronico,rut "
          cQuery += " from cliente "
          cQuery += " order by "+str(nOrden)+" LIMIT 600"
				case vpc == 'cf'
       		cQuery := " select id_cliente,nombre,direccion_particular,telefono,celular,correo_electronico,rut "
          cQuery += " from cliente "
          cQuery += " where cta_cte = 1 order by 2 "
		
//		cQuery := " select id_cliente,nombre,direccion_particular,telefono,celular,correo_electronico,rut "
//		cQuery += " from cliente "
//		cQuery += " order by 2 limit 300"   
//		
		endcase
		       
		oQuery := oServer:Query(cQuery )
		If oQuery:NetErr()												
			MsgInfo("SQL SELECT error: " + oQuery:Error())
			RELEASE WINDOW ALL
			Quit
		Endif
		
		For i := 1 To oQuery:LastRec()
			oRow := oQuery:GetRow(i)
			buscoCliente.grid_1.addItem({oRow:fieldGet(1),alltrim(oRow:fieldGet(2)) , ;
																	alltrim(oRow:fieldGet(3)),oRow:fieldGet(4), oRow:fieldGet(5),;
																	oRow:fieldGet(6),oRow:fieldGet(7)})
		Next
		
		oQuery:Destroy()
		center window buscoCliente
		activate window buscoCliente
  endIf

return

procedure buscoConFiltroCliente()
local cQuery,oQuery
//local cArticulo  := ''
//local cDescripcion:= ''
//local cProveedor := ''
if len(buscoCliente.text_2.value) > 2
buscoCliente.grid_1.deleteAllItems

//cArticulo := iif(buscoCliente.text_1.value = nil, '"%"',' "'+AllTrim(str(buscoCliente.text_1.value))+'%"' )
cDescripcion :=iif(buscoCliente.text_2.value = nil, '"%"','"%'+AllTrim(buscoCliente.text_2.value)+'%"' )
//cProveedor :=iif(buscoCliente.text_3.value = nil, '"%"',' "'+AllTrim(buscoCliente.text_3.value)+'%"' )

      
      
    			cQuery := " select id_cliente,nombre,direccion_particular,telefono,celular,correo_electronico,rut "
					cQuery += " from cliente "      
  				cQuery += " where  nombre LIKE "+cDescripcion+"  order by 2 limit 300"
  				//cQuery += " and  LIKE "+cProveedor+" "
  				//cQuery += " and id_cliente LIKE "+str(cArticulo)+"  order by 2 limit 300"
          
  oQuery := oServer:Query(cQuery )
    If oQuery:NetErr()												
      MsgInfo("SQL SELECT error: " + oQuery:Error())
      RELEASE WINDOW ALL
      Quit
    Endif

    For i := 1 To oQuery:LastRec()
    	oRow := oQuery:GetRow(i)
      buscoCliente.grid_1.addItem({oRow:fieldGet(1),alltrim(oRow:fieldGet(2)) , ;
																	alltrim(oRow:fieldGet(3)),oRow:fieldGet(4), oRow:fieldGet(5),;
																	oRow:fieldGet(6),oRow:fieldGet(7)})
    Next

    oQuery:Destroy()

endIf

procedure devbuscoCliente()


nSocioGlobal := buscoCliente.grid_1.item(buscoCliente.grid_1.value)[1]

release window buscoCliente

return