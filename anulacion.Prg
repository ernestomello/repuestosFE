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





procedure anuloMovimientos(nIdFactura)

if nIdFactura = 0

busquedaGeneral("l","","Documentos para Anular",1)   
nIdFactura := nSocioGlobal
nSocioGlobal := 0
endif

if nIdFactura != 0
	nTipoDoc := tipoDocumento(nIdFactura)
	do case 
		case  nTipoDoc = 98 
			nCajero := anulacion()
			if nCajero = 0
				msginfo("Usuario no autorizado")
				return .f.
			endIf
			if !anuloRecibo(nIdFactura,nCajero)  
				MsGInfo('No se pudo anular el Movimiento, Consulte al ADMINISTRADOR')
			else
				msgInfo('Documento No.'+str(nIdFactura)+' Anulado')
			endIf
		case nTipoDoc =101 .or. nTipoDoc = 111 
			notaCreditoCliente(nIdFactura)  			
		
		case nTipoDoc =102 .or.nTipoDoc = 112
			notaCreditoCliente(nIdFactura)  	

		case nTipoDoc =91 .or.nTipoDoc = 81
			notaCreditoCliente(nIdFactura) 
		otherwise
			msgInfo("No es posible Hacer la Anulación")
			return .f.
	end case
endIf                                                                                                    
