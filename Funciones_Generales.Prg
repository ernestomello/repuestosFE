#include <hmg.ch>
/************************************************************************
*
* Carga El parametro pedido desde el archivo .ini en el directorio donde se ejecuto la aplicacion
*
************************************************************************/
Function PARAMETROINI( ID , TipoDeDato )
	Local 	Retorno	
	local	cValor		:=	''
	local	cArchivoINI	:=	cDirInicioAplicacion+"\GRepuestos.ini"

	BEGIN INI FILE cArchivoINI

	    	GET cValor 	SECTION "Parametros" ENTRY ID default	'sin datos'

	END INI

	Do Case
	
		Case	TipoDeDato="N"
		
			Retorno		:=	Val(cValor)

		Case	TipoDeDato="C"
		
			Retorno		:=	Rtrim(cValor)

		Case	TipoDeDato="D"
		
			Retorno		:=	STOD( cValor ) 

		Case	TipoDeDato="L" .and. cValor="T"
			
			Retorno		:=	.T.

		Case	TipoDeDato="L" .and. cValor="F"
			
			Retorno		:=	.F.

	Endcase

Return(retorno)
*-----------------------------------------------------------------------*
Function __GrabaLog( cOpcion,cComentario )

Local cAplicacion := 'SGAdministracion Ver.' + cNroVersionAplicacion
local cOperador   := GetEnv('USERNAME')
local cTerminal   := GetEnv('COMPUTERNAME')
local cQuery   

cQuery := "insert into caja_log values (current_timestamp , '"+cAplicacion+"', '"+cComentario+"', '"+cOpcion+"', '"+cOperador+"', '"+cTerminal+"')" 
oQuery:= oServer:Query(cQuery)
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oServer:Error() )
endIf

Return

*********************************************
