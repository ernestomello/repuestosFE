#include <hmg.ch>
*************************************************
*************************************************
******Implementaciones de la vista***************
*************************************************
*************************************************

procedure mantenimientoclientes(nCliente)
//public socioNuevo

  Load Window clientes
  if nCliente != 0
		rellenoDatosClientes(nCliente)
	endIf

  clientes.Center
  clientes.Activate
 
return

procedure buscoCliente(nCliente)

vacioDatosClientes()
  
if existeCliente(nCliente) .and. nCliente != 0
  rellenoDatosClientes(nCliente)
  nSocioGlobal := 0
else

  busquedaGeneral('cc','','Clientes',1)
  
  if nSocioGlobal != 0
    rellenoDatosClientes(nsocioGlobal)      
    nSocioGlobal := 0
  endIf
  
endif

return

procedure rellenoDatosClientes(nCliente)

clientes.text_13.value :=  nCliente
clientes.text_9.value :=  rutCliente(nCliente) 
clientes.text_1.value :=  razonSocialCliente(nCliente)
clientes.text_2.value :=  nombreCliente(nCliente)
clientes.radioGroup_1.value := consumoFinalCliente(nCliente)
clientes.text_4.value :=  telefonoCliente(nCliente)
clientes.text_5.value :=  celularCliente(nCliente)
clientes.text_6.value :=  correoCliente(nCliente)
clientes.text_7.value :=  dirParticularCliente(nCliente)
clientes.check_1.value := iif(ctacteCliente(nCliente) = 1,.t.,.f.)

return

procedure vacioDatosClientes()

clientes.text_9.value := ''
clientes.text_1.value :=  ''
clientes.text_2.value :=  ''
clientes.text_4.value :=  ''
clientes.text_5.value :=  ''
clientes.text_6.value :=  ''
clientes.text_7.value :=  ''
clientes.text_13.value := 0
clientes.check_1.value := .t.
return


procedure guardarCliente()
local nConsumoFinal := iif(clientes.radioGroup_1.value = 1, 0, 1)
local nCtaCte := iif(clientes.check_1.value = .t.,1,0)

if controloIngresoCliente()
  if !existeCliente(clientes.text_13.value)
  	if !mismosDatosCliente(clientes.text_2.value, clientes.text_9.value)
			if ! nuevoCliente(clientes.text_9.value, clientes.text_1.value, ;
											clientes.text_2.value, nConsumoFinal, ;
											clientes.text_4.value, clientes.text_5.value, ;
											clientes.text_6.value, clientes.text_7.value, nCtaCte  )
											
	      msgInfo('No se pudieron guardar los cambios. AVISE AL ADMINISTRADOR')
	      
	    else
	      msgInfo('Cliente dada de Alta')
	      vacioDatosClientes()
	    endif
	  endIf
  else
  
		if ! modificoCliente(clientes.text_13.value,clientes.text_9.value,;
											 clientes.text_1.value,clientes.text_2.value, nConsumoFinal, ;
											 clientes.text_4.value, clientes.text_5.value, ;
											 clientes.text_6.value, clientes.text_7.value, nCtaCte )
      msgInfo('No se pudieron actualizar los cambios. AVISE AL ADMINISTRADOR')
    else
      msginfo('Datos de Cliente actualizados')
      vacioDatosClientes()
    endif  
  
  endif  

endif
  
return

function mismosDatosCliente(cNombre,cRut)

if existeNombreCliente(cNombre)
	msginfo("Ya existe un Cliente con ese Nombre")
	return .t.
endIf

if clientes.radioGroup_1.value = 2
	if existeRutCliente(cRut)
		msginfo("Ya existe un Cliente con ese RUT")
		return .t.
	endIf
endif

return .f.


function controloIngresoCliente()

if clientes.radioGroup_1.value = 2
	If len(clientes.text_1.value) = 0
  	msgInfo('Falta ingresar Razón Social')
  	return .f.
	endIf
	If len(clientes.text_9.value) = 0
  	msgInfo('Falta ingresar RUT')
  	return .f.
	endIf
endIf

if clientes.radioGroup_1.value = 1
	If len(clientes.text_2.value) = 0
	  msgInfo('Falta ingresar Nombre')
	  return .f.
	endIf
endif

If len(clientes.text_4.value) = 0
  msgInfo('Falta ingresar Teléfono')
  return .f.
endIf

If len(clientes.text_7.value) = 0
  msgInfo('Falta ingresar Dirección Particular')
  return .f.
endIf

return .t.

function clienteCancelado(nCliente)

if rat('#',nombreCliente(nCliente)) = 0
	return .f.
else
	return .t.
endIf

function clienteHabilitado(nCliente)

if ctaCteCliente(nCliente) = 0
	return .f.
else
	return .t.
endIf

*************************************************
*************************************************
******Implementaciones del modelo ***************
*************************************************
*************************************************

function nuevoCliente(cRut, cRazonSocial, cNombre,nConsumoFinal, cTelefono, cCelular, cCorreo, cDireccion,nCtaCte)
local cQuery := ''
local oQuery

cQuery += " insert into cliente values (null, '"+cRut+"',  '"+cNombre+"','"+cRazonSocial+"', "
cQuery += " '"+cTelefono+"', '"+cCelular+"', "
cQuery += " '"+cCorreo+"', '"+cDireccion+"', "+str(nConsumoFinal)+", "+str(nCtaCte)+" ) "

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
	nCliente := oQuery:GetRow(1):fieldGet(1)
	oQuery:Destroy()
  return .t.
endif



function modificoCliente(nIdCliente,cRut, cRazonSocial, cNombre,nConsumoFinal, cTelefono, cCelular, cCorreo, cDireccion,nCtaCte)
local cQuery := ''
local oQuery

cQuery += " update cliente set  rut = '"+cRut+"' , "
cQuery += " razon_social = '"+cRazonSocial+"', nombre = '"+cNombre+"',  "
cQuery += " telefono = '"+cTelefono+"', celular = '"+cCelular+"', correo_electronico = '"+cCorreo+"', "
cQuery += " direccion_particular = '"+cDireccion+"', "
cQuery += " consumo_final = "+str(nConsumoFinal)+", "
cQuery += " cta_cte = "+str(nCtaCte)+" "
cQuery += " where  id_cliente = "+str(nIdCliente)+" "


oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
  return .f.
else
  return .t.
endif


function existeCliente(nCliente)
local cQuery
local oQuery

cQuery := "select id_cliente from cliente where id_cliente = "+str(nCliente)+""

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


function consumoFinalCliente(nCliente)
local cQuery
local oQuery

cQuery := "select consumo_final from cliente where  id_cliente = "+str(nCliente)+""

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
	if  oQuery:GetRow(1):fieldGet(1) = 0
		return 1
	else
		return 2
	endIf
endIf

function rutCliente(nCliente)
local cQuery
local oQuery

cQuery := "select rut from cliente where  id_cliente = "+str(nCliente)+""

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf

function nombreCliente(nCliente)
local cQuery
local oQuery

cQuery := "select nombre from cliente where  id_cliente = "+str(nCliente)+""

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf


function razonSocialCliente(nCliente)
local cQuery
local oQuery

cQuery := "select razon_social from cliente where  id_cliente = "+str(nCliente)+""

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf


function  telefonoCliente(nCliente)
local cQuery
local oQuery

cQuery := "select telefono from cliente where  id_cliente = "+str(nCliente)+""

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf

function  celularCliente(nCliente)
local cQuery
local oQuery

cQuery := "select celular from cliente where  id_cliente = "+str(nCliente)+""

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf

function  correoCliente(nCliente)
local cQuery
local oQuery

cQuery := "select correo_electronico from cliente where  id_cliente = "+str(nCliente)+""

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf

function  ctaCteCliente(nCliente)
local cQuery
local oQuery

cQuery := "select cta_cte from cliente where  id_cliente = "+str(nCliente)+""

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf

function  existeNombreCliente(cNombre)
local cQuery
local oQuery

cQuery := "select * from cliente where  nombre like '%"+cNombre+"%' "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
  return .f.
endIf
if oQuery:LastRec() > 0
	return .t.
else
	return .f.
endIf

function  existeRutCliente(cRut)
local cQuery
local oQuery

cQuery := "select * from cliente where  rut like '%"+cRut+"%' "

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
  return .f.
endIf
if oQuery:LastRec() > 0
	return .t.
else
	return .f.
endIf

function  dirParticularCliente(nCliente)
local cQuery
local oQuery

cQuery := "select direccion_particular from cliente where  id_cliente = "+str(nCliente)+""

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf




function idCliente(nCliente)
local cQuery
local oQuery
local retorno

cQuery := "select id_cliente from cliente where  rut = "+str(nCliente)+""

oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: "+cQuery+":" + oQuery:Error())
else
	restorno := oQuery:GetRow(1):fieldGet(1)
	oQuery:Destroy()
  return retorno
endIf
function numeroPrimerCliente()
local cQuery, oQuery

cQuery := " select id_cliente from cliente order by 1 limit 1"
oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: "+cQuery+":" + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf

function numeroUltimoCliente()
local cQuery, oQuery
cQuery := " select id_cliente from cliente order by 1 desc limit 1"
oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: "+cQuery+":" + oQuery:Error())
else
  return oQuery:GetRow(1):fieldGet(1)
endIf

function clientes(nOrden)
local cQuery, oQuery

cQuery := " select id_cliente,nombre from cliente order by "+str(nOrden)+" "
oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: "+cQuery+":" + oQuery:Error())
else
  return oQuery
endIf
