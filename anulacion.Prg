#include <hmg.ch>


function anulacion()
private resultado := 0
load window anulacion
anulacion.center
anulacion.activate

return resultado

procedure anulaDocumento()
resultado := contraseniaValida(anulacion.text_1.value)

if  resultado!= 0
	if !msgYesNo("El usuario "+nombreUsuario(resultado)+chr(13)+"Autorizó la Anulación")
		resultado := 0
	endif
	anulacion.release
else
	msginfo("La contraseña no es Válida")	
endif





procedure anuloMovimientos()

busquedaGeneral("l","","Documentos para Anular",1)   

if nSocioGlobal != 0
	if msgYesNo("Esta operación anulará el documento, CONTINÚA?")
			/*nCajero := anulacion()
			if nCajero != 0
				if tipoDocumento(nSocioGlobal) == 'R' .or. tipoDocumento(nSocioGlobal)== 'N'
					if !anuloRecibo(nSocioGlobal,nCajero)  
						MsGInfo('No se pudo anular el Movimiento, Consulte al ADMINISTRADOR')
					else
						msgInfo('Documento No.'+str(nSocioGlobal)+' Anulado')
					endIf*/
					cargoDocumentoGen(nSocioGlobal, "ANULAR")
				/*else
					if !anuloFactura(nSocioGlobal,nCajero)  
						MsGInfo('No se pudo anular el Movimiento, Consulte al ADMINISTRADOR')
					else
						msgInfo('Documento No.'+str(nSocioGlobal)+' Anulado')
					endIf
					muestroDocumentoCliente(nSocioGlobal)

				endif
				
			else
				msginfo("Usuario no autorizado")
			endIf*/
	EndIf
  nSocioGlobal := 0
endIf                                                                                                    
