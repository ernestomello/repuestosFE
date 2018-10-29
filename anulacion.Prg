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
	if !msgYesNo("El usuario "+nombreUsuario(resultado)+chr(13)+"Autoriz� la Anulaci�n")
		resultado := 0
	endif
	anulacion.release
else
	msginfo("La contrase�a no es V�lida")	
endif





procedure anuloMovimientos()

busquedaGeneral("l","","Documentos para Anular",1)   

if nSocioGlobal != 0
	// if msgYesNo("Esta operaci�n anular� el documento, CONTIN�A?")
			
		// cargoDocumentoGen(nSocioGlobal, "ANULAR")
				
	// EndIf
	nTipoDoc := tipoDocumento(nSocioGlobal)
		nCajero := anulacion()
		if nCajero != 0
			do case 
				case  nTipoDoc = 98 				
					if !anuloRecibo(nSocioGlobal,nCajero)  
						MsGInfo('No se pudo anular el Movimiento, Consulte al ADMINISTRADOR')
					else
						msgInfo('Documento No.'+str(nSocioGlobal)+' Anulado')
					endIf
				case nTipoDoc =101 .or.nTipoDoc = 111 
					notaCreditoCliente(nSocioGlobal,nCajero)  
				// else
					// anularDevolucion(documentogen.text_6.value,nCajero)
				// endIf
			end case
		else
					msginfo("Usuario no autorizado")
		endIf
  nSocioGlobal := 0
endIf                                                                                                    