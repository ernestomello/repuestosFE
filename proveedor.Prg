#include <hmg.ch>
procedure mantenimientoProveedor(nProveedor)
  Load Window proveedor
  rellenoComboMonedaProveedor()
  if nProveedor != 0
		rellenoDatosProveedor(nProveedor)
	endIf

  proveedor.Center
  proveedor.Activate
 
return

procedure buscoProveedor(nProveedor)

vacioDatosProveedor()
  
if existeProveedor(nProveedor) .and. nProveedor != 0
  rellenoDatosProveedor(nProveedor)
  nSocioGlobal := 0
else

  busquedaGeneral('p','','Proveedores',1)
  
  if nSocioGlobal != 0
    rellenoDatosProveedor(nsocioGlobal)      
    nSocioGlobal := 0
  endIf
  
endif

return
procedure rellenoDatosProveedor(nProveedor)
local cMoneda := signoMOneda(monedaProveedor(nProveedor))

Proveedor.text_13.value :=  nProveedor
Proveedor.text_9.value :=  rutProveedor(nProveedor) 
Proveedor.text_2.value :=  nombreProveedor(nProveedor)
Proveedor.text_4.value :=  telefonoProveedor(nProveedor)
Proveedor.text_5.value :=  faxProveedor(nProveedor)
Proveedor.text_6.value :=  correoProveedor(nProveedor)
Proveedor.text_7.value :=  dirParticularProveedor(nProveedor)

for i = 1 to proveedor.combo_1.itemCount
	if alltrim(proveedor.combo_1.item(i)) = alltrim(cMoneda)
		proveedor.combo_1.Value  := i
	endIf
next

return

procedure rellenoComboMonedaProveedor()
local oMonedas := oMoneda()

for i = 1 to oMonedas:lastrec()
	Proveedor.combo_1.addItem(alltrim(oMonedas:getRow(i):fieldGet(1)))
next

procedure guardarProveedor()
local nMoneda := idMoneda(proveedor.combo_1.displayValue)

if controloIngresoProveeor()
  if !existeProveedor(proveedor.text_13.value)
			if ! nuevoProveedor(proveedor.text_9.value,	proveedor.text_2.value, ;
											proveedor.text_4.value, proveedor.text_5.value, ;
											proveedor.text_6.value, proveedor.text_7.value,nMoneda )
											
	      msgInfo('No se pudieron guardar los cambios. AVISE AL ADMINISTRADOR')
	      
	    else
	      msgInfo('Proveedor '+str(idProveedor(proveedor.text_2.value))+' dado de Alta')
	      vacioDatosproveedor()
	      proveedor.release
	    endif
  else
  
		if ! modificoProveedor(proveedor.text_13.value,proveedor.text_9.value,;
											 proveedor.text_2.value, ;
											 proveedor.text_4.value, proveedor.text_5.value, ;
											 proveedor.text_6.value, proveedor.text_7.value,nMoneda )
      msgInfo('No se pudieron actualizar los cambios. AVISE AL ADMINISTRADOR')
    else
      msginfo('Datos de Proveedor actualizados')
      vacioDatosproveedor()
      proveedor.release
    endif  
  
  endif  

endif
  
return
procedure vacioDatosProveedor()

Proveedor.text_13.value := 0
Proveedor.text_9.value := ""
Proveedor.text_2.value := ""
Proveedor.text_4.value := ""
Proveedor.text_5.value := ""
Proveedor.text_6.value := ""
Proveedor.text_7.value := ""





procedure controloIngresoProveeor()

if len(proveedor.text_2.value) = 0
	msgInfo("Nombre no puede estar vacío ")
	return .f.
endif
return .t.

*************************************************
*************************************************
******Implementaciones del modelo ***************
*************************************************
*************************************************
function nombreProveedor(nProveedor)
local cQuery
local oQuery

cQuery := "select nombre from proveedor where  id_proveedor = "+str(nProveedor)+"  "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf

function idProveedor(cNombre)
local cQuery
local oQuery

cQuery := "select id_proveedor from proveedor where nombre = '"+cNombre+"' "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  if oQuery:LastRec() > 0
    return oQuery:GetRow(1):fieldGet(1)
  else
    return 0
	endif
endif
function existeProveedor(nProveedor)
local cQuery
local oQuery

cQuery := "select id_proveedor from proveedor where id_proveedor = "+str(nProveedor)+""

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  if oQuery:LastRec() > 0
    return .t.
  else
    return .f.
  endif
endIf

return

function rutProveedor(nProveedor)
local cQuery
local oQuery

cQuery := "select rut from proveedor where  id_proveedor = "+str(nProveedor)+""

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf


function  telefonoProveedor(nProveedor)
local cQuery
local oQuery

cQuery := "select telefono from proveedor where  id_proveedor = "+str(nProveedor)+""

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf

function  faxProveedor(nProveedor)
local cQuery
local oQuery

cQuery := "select fax from proveedor where  id_proveedor = "+str(nProveedor)+""

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf



function  dirParticularProveedor(nProveedor)
local cQuery
local oQuery

cQuery := "select direccion from proveedor where  id_proveedor = "+str(nProveedor)+""

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf

function  correoProveedor(nProveedor)
local cQuery
local oQuery

cQuery := "select correo_electronico from proveedor where  id_proveedor = "+str(nProveedor)+""

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf

function monedaProveedor(nProveedor)
local cQuery
local oQuery

cQuery := "select moneda_cuenta from proveedor where  id_proveedor = "+str(nProveedor)+""

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf

function  proveedores()
local cQuery
local oQuery

cQuery := "select id_proveedor from proveedor "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery
endIf

function nuevoProveedor(cRut, cNombre, cTelefono, cCelular, cCorreo, cDireccion,nMoneda)
local cQuery := ''
local oQuery

cQuery := cQuery + " insert into proveedor values (null,   '"+cNombre+"','"+cDireccion+"','"+cRut+"', "
cQuery := cQuery + " '"+cTelefono+"', '"+cCelular+"', "
cQuery := cQuery + " '"+cCorreo+"', "+str(nMoneda)+" ) "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
  return .f.
else
 
	oQuery:= oServer:Query( 'select LAST_INSERT_ID()')
	    If oQuery:NetErr() 
        MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
        return .f.
      endif
	nProveedor := oQuery:GetRow(1):fieldGet(1)
	oQuery:Destroy()
  return .t.
endif


function modificoProveedor(nIdProveedor,cRut, cNombre,  cTelefono, cCelular, cCorreo, cDireccion,nMoneda)
local cQuery := ''
local oQuery

cQuery := cQuery + " update proveedor set  rut = '"+cRut+"', "
cQuery := cQuery + " nombre = '"+cNombre+"',  telefono = '"+cTelefono+"', "
cQuery := cQuery + " fax = '"+cCelular+"', correo_electronico = '"+cCorreo+"', "
cQuery := cQuery + " direccion = '"+cDireccion+"', "
cQuery := cQuery + " moneda_cuenta = "+str(nMoneda)+" "
cQuery := cQuery + " where  id_Proveedor = "+str(nIdProveedor)+" "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
  return .f.
else
  return .t.
endif

