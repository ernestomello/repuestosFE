#include <hmg.ch>

procedure mantenimientoUsuario(nUsuario)

load window usuario
cargoGridUsuario()
usuario.center
usuario.activate

procedure cargoGridUsuario()
local oUsuario := oUsuarios()

for i = 1 to oUsuario:lastrec()
usuario.grid_1.additem({oUsuario:getrow(i):fieldget(1),oUsuario:getrow(i):fieldget(2),oUsuario:getrow(i):fieldget(3)})
next 


procedure cargoDatosUsuario(nUsuario)

if existeUsuario(nUsuario)
	usuario.text_2.value := nombreUsuario(nUsuario)
	usuario.text_1.value := nUsuario
else
	busquedaGeneral('u','','Usuarios',1)
  if nSocioGlobal != 0
	 	usuario.text_2.value := nombreUsuario(nSocioGlobal)
		usuario.text_1.value := nSocioGlobal
		nSocioGlobal := 0
  endIf
endif

procedure modificaLinea()

usuario.text_1.value := usuario.grid_1.cell(usuario.grid_1.value,1)
usuario.text_2.value := usuario.grid_1.cell(usuario.grid_1.value,2)
usuario.text_3.value := ''


procedure nuevoVendedor()
usuario.text_1.value :=0
usuario.text_2.value :=''
usuario.text_3.value :=''
usuario.text_2.setfocus

procedure guardaUsuario()
local nNumero := usuario.text_1.value
local cNombre := usuario.text_2.value
local cPasswd := usuario.text_3.value

if controloUsuario()
	if existeUsuario(nNumero)
		modificoUsuario(nNumero,cNombre,cPasswd)
	else
		altaUsuario(cNombre,cPasswd)
	endif
endif
usuario.grid_1.deleteallitems
usuario.text_1.value :=0
usuario.text_2.value :=''
usuario.text_3.value :=''
cargoGridUsuario()

function controloUsuario()

if len(usuario.text_2.value) = 0
	msginfo("Falta ingresar Nombre")
	return .f.
endif

if len(usuario.text_3.value) = 0
	msginfo("Falta ingresar Contraseña")
	return .f.
endif
return .t.

//procedure cambiarPasswd()
//local cPasswd := usuario.text_4.value
//local nNumero := usuario.text_1.value
//
//if existeUsuario(nNumero)
//	if cPasswd = 0
//		msginfo("Debe ingresar una contraseña nueva")
//		usuario.text_4.setfocus
//	else
//		setPasswd(nNumero, cPasswd)
//	endif
//else
//	msginfo("El usuario no Existe!!")
//endif



*************************************************
*************************************************
******Implementaciones del modelo ***************
*************************************************
*************************************************
function oUsuarios()
local cQuery, oQuery

cQuery := " select * from  cajero  "

oQuery:= oServer:Query(  cQuery )
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  return     
else
	return oQuery
endIf


function altaUsuario(cNombre,cPasswd)
local cQuery, oQuery

cQuery := " insert into cajero values( "
cQuery += " null, '"+cNombre+"',md5('"+cPasswd+"') ) "

oQuery:= oServer:Query(  cQuery )
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  return .f.    
else
	return .t.
endIf

function modificoUsuario(nNumero,cNombre,cPasswd)
local cQuery, oQuery

cQuery := " update cajero set "
cQuery += " nombre = '"+cNombre+"', "
cQuery += " passwd = md5('"+cPasswd+"') "
cQuery += " where id_cajero = "+str(nNumero)+" "

oQuery:= oServer:Query(  cQuery )
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  return .f.    
else
	return .t.
endIf


function existeUsuario(nUsuario)
local cQuery, oQuery

cQuery := " select * from cajero "
cQuery += " where id_cajero = "+str(nUsuario)+" "

oQuery:= oServer:Query(  cQuery )
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  return .f.    
else
	if oQuery:LastRec() > 0
		return .t.
	else
		return .f.
	endif
endIf

function setPasswd(nNumero,cPasswd)
local cQuery,oQuery

cQuery := " update cajero set  passwd = md5("+cPasswd+") "
cQuery += " where id_cajero = "+str(nNumero)+"" 

oQuery:= oServer:Query(  cQuery )
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  return .f.    
else
	return .t.
endIf

function nombreUsuario(nNumero)
local cQuery,oQuery

cQuery := " select nombre from cajero "
cQuery += " where id_cajero = "+str(nNumero)+"" 

oQuery:= oServer:Query(  cQuery )
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  return .f.    
endif

if oQuery:lastRec() >0
	return oQuery:getRow(1):fieldGet(1)	
else
	return "sin nombre"
endIf

function contraseniaValida(cPasswd)
local cQuery, oQuery

cQuery := " select ifnull(id_cajero,0 ) "
cQuery += " from cajero "
cQuery += " where passwd = md5('"+cPasswd+"') " 

oQuery:= oServer:Query(  cQuery )
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  return 0
else
	return oQuery:getRow(1):fieldGet(1)
endIf