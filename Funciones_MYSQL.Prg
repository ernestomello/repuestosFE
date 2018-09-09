#include <hmg.ch>

Function MySQL_Database_Connect( cDatabase )
*------------------------------------------------------------------------------*
/*..............................................................................

	Class TMySQLServer - Method ListDBs()

		- Returns an array with list of data bases available.

		- Retorna un array con la lista de bases de datos disponibles.

	Class TMySQLServer - ListTables()

		- Returns an array with list of available tables in current
		database.

		- Retorna un array con la lista de tablas disponibles en la
		base de datos actual.

..............................................................................*/

Local i:= 0
Local aDatabaseList:= {}                                           

	cDatabase:= Lower(cDatabase)
	If oServer == Nil 
		MsgInfo("No Conectado al servidor MYSQL")
		Return Nil
	EndIf

	aDatabaseList:= oServer:ListDBs()
	If oServer:NetErr() 
		MsGInfo("Error Verificando Listado de Bases: " + oServer:Error())
		Release Window ALL
	Endif 

	If AScan( aDatabaseList, Lower(cDatabase) ) == 0
		MsgINFO( "Base de Datos: "+cDatabase+" no Existe!")
		Return Nil
	EndIf 

	oServer:SelectDB( cDatabase )
	
	If oServer:NetErr() 
		MsgStop("Error conectando a: "+cDatabase+": "+oServer:Error() )
	Endif 

Return Nil


function comienzoTransaccion()
local oQuery

oQuery:= oServer:Query( 'BEGIN')
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  oQuery:=oServer:Query('ROLLBACK') 
  return .f.
else
	return .t.
endif

function finTransaccion()
local oQuery

oQuery:= oServer:Query( 'COMMIT')
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  oQuery:=oServer:Query('ROLLBACK') 
  return .f.
else
	return .t.
endif