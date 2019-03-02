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
	cambiarControl()
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

function cambiarControl()

if clientes.radioGroup_1.value = 2
	clientes.label_10.value := "R.U.T: "
else
	clientes.label_10.value := "C.I: "
endif


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
	else
		if !formatoRut(clientes.text_9.value)
			msgInfo("Número RUT Incorrecto!!!")
			return .f.
		endif		
	endIf
endIf

if clientes.radioGroup_1.value = 1
	If len(clientes.text_2.value) = 0
	  msgInfo("Falta ingresar Nombre")
	  return .f.
	endIf
	If len(clientes.text_9.value) = 0
		if msgYesNO("Falta ingresar Cédula...Continúa? ",,.t.)
			return .t.
		else
			return .f.
		endIf
	else
		if !formatoCedula(clientes.text_9.value)
			msgInfo("Número Cédula Incorrecto!!!")
			return .f.
		endif		
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

function formatoCedula(nCedula)
local cControl := '2987634'
local cCedula := alltrim(nCedula)
local nCuenta := 0
local nModulo, cCompara

if at("AR",nCedula) != 0
	return .t.
endif

if len(cCedula) == 7
	cCedula := "0"+cCedula
endif
for i= 1 to len(cCedula)-1
	nCuenta += val(substr(cCedula,i,1))* val(substr(cControl,i,1))
next
nModulo :=(nCuenta % 10)
//msgInfo(str(10 - (nCuenta%10),1,0)+'--'+substr(cCedula,len(cCedula),1))

if  nModulo != 0
	cCompara := str(10 - nModulo,1,0)
else
	cCompara := str(0,1,0)
endIf

if  cCompara== substr(cCedula,len(cCedula),1)
	return .t.
else
	return .f.
endIf

function formatoRut(nRut)
local cControl := '43298765432'
local cRut := alltrim(nRut)
local nCuenta := 0
local nModulo, cCompara
local dosPrim := val(substr(cRut,1,2))
local terOctava := val(substr(cRut,3,6))
local nueveDiez := val(substr(cRut,9,2))
//msgInfo(cRut)
//msgInfo (str(dosPrim)+"-"+str(terOctava)+"-"+str(nueveDiez))
// if cRut == "0"
	// return .t.
// endif
if len(cRut) < 10
	return .f.
endif

if dosPrim < 1 .and. dosPrim > 21
	return .f.
endif

if terOctava = 0
	return .f.
endif

if nueveDiez != 0
	return .f.
endif

for i= 1 to len(cRut)-1
	nCuenta += val(substr(cRut,i,1))* val(substr(cControl,i,1))
next
nModulo :=(nCuenta % 11)
//msgInfo(str(10 - (nCuenta%10),1,0)+'--'+substr(cCedula,len(cCedula),1))
//msgInfo( str(nModulo))
do case
	case  nModulo > 1
		cCompara := str(11 - nModulo,1,0)
	case nModulo = 0
		cCompara := str(0,1,0)	
	case nModulo = 1
		return .f.
endcase

if  cCompara== substr(cRut,len(cRut),1)
	return .t.
else
	return .f.
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

function fechaUltMovCliente(nOrden)
local cQuery, oQuery

cQuery := " select t.* from (select c.id_cliente,c.nombre, ca.fecha "
cQuery += "  from cliente c, cfe_comprobante_cab ca"
cQuery += " where ca.id_cliente = c.id_cliente order by ca.fecha desc, c.id_cliente) as t group by 1 "
oQuery := oServer:Query(cQuery)
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: "+cQuery+":" + oQuery:Error())
else
  return oQuery
endIf

function datoCliente(nIdCliente)
local cQuery
local oQuery


cQuery := " select concat(if(c.consumo_final = 1,2,3),'|',c.rut,'|',c.razon_social,'|',c.direccion_particular,'|','PAYSANDU','|',c.id_cliente) "
cQuery += " from cliente c  "
cQuery += " where c.id_cliente = "+str(nIdCliente)+" "
// cQuery += " and c.consumo_final = 1 "

oQuery := oServer:Query(cQuery)
if oQuery:NetErr()												
  MsgInfo("Error executing Query "+cQuery+": "+ oQuery:Error())
endif
if oQuery:lastRec() > 0
	return oQuery:GetRow(1):fieldget(1)
else
	return ""
endif