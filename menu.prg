#include "minigui.ch"
#include <hmg.ch>
        
		
Function main() 
	Local aDoc := {}
	Public	cNroVersionAplicacion	:=	"3." + __DATE__ +"."+SUBST(__TIME__,1,2)+SUBST(__TIME__,4,2)
	Public	cNombreTerminal		:=	GetEnv( "COMPUTERNAME" ) 
	Public	cDirInicioAplicacion	:=	"C:\dm\nuevo" //PARAMETROini("DIR_APLICACION","C") //
	Public 	oServer			:= 	Nil 
	Public	cServidorSQL_nombre	:=	PARAMETROini("MYSQL_Servidor","C")
	Public	cServidorSQL_usuario :=lower(GetEnv( "USERNAME" ))
	Public	cServidorSQL_Estado	:=	'S/D'
	Public  cSucursal:= 	PARAMETROini("Sucursal","C")
	Public  nDtoContado:= 	PARAMETROini("DTOCTADO","N")
	Public  nSocioGlobal := 0
	Public  cArticuloGlobal := ""
	//para FE
	Public  esFacturaElectronica := PARAMETROini("FACTURAE","L")
	Public  nTopeUI := PARAMETROini("FEUITOPE","N") * PARAMETROini("FEVALORUI","N")
	Public  cNombreEmpresa := PARAMETROini("EMPRESA","C")
	Public  cDirFE		:=	PARAMETROini("DIR_FE","C")
	Public  exePDF := PARAMETROini("EXEPDF","C")
	Public  cRutEmisior := PARAMETROini("FERUTEMISOR","C")
	Public  cRazonEmisior := PARAMETROini("FERAZONEMISOR","C")
	Public  cDGIEmisior := PARAMETROini("FEDGIEMISOR","C")
	Public  cDirEmisior := PARAMETROini("FEDIREMISOR","C")
	Public  cCiuEmisior := PARAMETROini("FECIUEMISOR","C")
	Public  cDepEmisior := PARAMETROini("FEDEPEMISOR","C")
	Public  cHojaWSFE := PARAMETROini("FEHOJAWS","C")
	Public  cSOAPSw := PARAMETROini("FESOAPWS","C")
	Public  cSOAPuser := PARAMETROini("FESOAPUSER","C")
	Public  cSOAPClave := PARAMETROini("FESOAPCLAVE","C")
	Public  cSOAPtenant := PARAMETROini("FESOAPTENANT","C")
	public cPuntoVenta := PARAMETROini("PUNTOVENTA","C")
	public cPorcentajeNC := PARAMETROini("PORCENTAJENOTACREDITO","N")
	
	
	SeteoAmbiente() 
	  
    	DEFINE WINDOW Principal ;
    		AT 15,15 ;
    		WIDTH 680 ;
    		HEIGHT 110 ;
    		SIZABLE .F.;
    		MINBUTTON .T.;
    		MAXBUTTON .F.;
    		titlebar .T.;
    		TITLE "Gestion de Ventas de "+cNombreEmpresa+" - Version " + cNroVersionAplicacion + ' - Terminal ' + cNombreTerminal ;
    		ICON	"MAINICON"			;
    		MAIN; 
    		ON RELEASE MySQL_Disconnect()
    		DEFINE MAIN MENU 
    				POPUP 'Contado'
    					ITEM 'Ventas Contado'  	ACTION factCliente(101,aDoc,1)
    					
    					SEPARATOR
    					
    					ITEM 'Inicio de Caja'       ACTION inicioCaja()
        			ITEM 'Salidas de Caja'      ACTION salidaCaja()
        			ITEM 'Cierre de Caja'       ACTION cerrarCaja()
        			SEPARATOR

              ITEM 'Reimprimir Movimientos '	ACTION reImprimoMOvimientos()

				SEPARATOR

              ITEM 'Anulacion Movimientos'    ACTION anuloMovimientos(0)
				SEPARATOR
              ITEM 'Pendientes de Facturacion Electronica'    ACTION emiteFacturaElectronica()
				SEPARATOR
              ITEM 'Buscar documentos' ACTION buscaDocumentos()
              
    				END POPUP 
      
      			POPUP 'Proveedores' 
                
               ITEM 'Compras Credito'  ACTION factProveedor()
               ITEM 'Recibos '         ACTION reciboProveedor(98)
               ITEM 'Bonificaciones '  ACTION reciboProveedor(112)
               ITEM 'Devoluciones '    ACTION reciboProveedor(112)
               SEPARATOR

               ITEM 'Estado de Cuenta' ACTION estadoCuentaProveedores()
					 				 
      				  
      			END POPUP
      			
      			POPUP 'Presupuestos'
      				ITEM 'Registro Contado'	ACTION factCliente(91,aDoc,1)
      				ITEM 'Busqueda Contados' ACTION presupuestos("Contado")//busquedaGeneral("pc","","Presupuestos Contado",1)  
      				SEPARATOR
      				ITEM 'Registro Credito' ACTION factCliente(81,aDoc,2)
      				ITEM 'Estado de Cuenta' ACTION presupuestos("Credito")
      				
      			END POPUP
      			
      			
     				
     				POPUP 'Mantenimientos'	name Mantenimientos
              
              
              SEPARATOR
            	ITEM 'Repuestos'    ACTION mantenimientoArticulo('')//mantenimientoEmpresas(0) 
      				ITEM 'Clientes'		  ACTION mantenimientoclientes(0)  
      				ITEM 'Proveedores' 	ACTION mantenimientoProveedor(0)
      				SEPARATOR
      				ITEM 'Marcas ' 			ACTION mantenimientoMarca(0)
      				ITEM 'Locacion ' 		ACTION mantenimientoLocacion(0)
      				SEPARATOR
      				ITEM 'Usuario '			ACTION mantenimientoUsuario(0)
      			
      				
      			END POPUP
      			
      			POPUP 'Reportes'	name Listados
      				ITEM 'Resumen de Caja' ACTION imprimoCierre(cajaId())
      				ITEM 'Ventas Por Repuesto' ACTION ventasPorCodigo()
      				ITEM 'Resumen de Ventas' ACTION resumenventa()
      				ITEM 'Resumen de Compras' ACTION resumencompra()

      				SEPARATOR
      				//ITEM 'Envio de Estados de Cuenta' ACTION envioEstados()
      				ITEM 'Estados de Cuenta' ACTION imprimeEstadosCuenta()
      				ITEM 'Saldos Anteriores' ACTION listoSaldosAnteriores()
      			END POPUP
      			
      			POPUP 'Listas' 
      				ITEM 'Repuestos' ACTION buscoPrecio()
      		//		item 'chequeo' action reciboAutomaticoProveedor()
      			END POPUP
//      			POPUP 'Migracion'	name Listados
//      				ITEM 'Migrar Presupuestos' ACTION  migraPresupuesto()
					POPUP 'Cta. Cte' 
                
               	ITEM 'Ventas Credito'  	ACTION factCliente(101,aDoc,2)

                SEPARATOR
                
                ITEM 'Recibos'       		ACTION reciboCliente()
                
                SEPARATOR

								ITEM 'Estado de Cuenta' ACTION estadoCuentaClientes()
                
      												
      			END POPUP
      			POPUP "Cotizacion Moneda"
      				ITEM 'Cotizacion Moneda' ACTION cotizacion_moneda()
      			END POPUP
//      				ITEM 'Migrar Detalle FAC-REC' ACTION migraDetalle()
//							ITEM 'Migrar Repuestos' ACTION migraArticulo()
//							ITEM 'Migrar Clientes' ACTION migraCliente()
							//ITEM 'Ajustar Saldos Clientes' ACTION ajustoSaldo()     				
//  						ITEM 'Migrar Proveedores' ACTION migraProveedor()  
//							ITEM 'Migrar Cabezal Proveedores' ACTION migraFacProveedor() 							   											
//      				ITEM 'Ajustar Saldos Proveedores' ACTION ajustoSaldoProv()    
   				//ITEM 'comparativa de Saldos' ACTION comparoSaldo()				
     			//END POPUP
		 END MENU
		
    DEFINE STATUSBAR 
			STATUSITEM cServidorSQL_nombre  	WIDTH 50
			STATUSITEM PARAMETROini("MYSQL_Base","C")	WIDTH 60
			STATUSITEM cServidorSQL_Estado  	WIDTH 90
			STATUSITEM chequeoRespaldo() WIDTH 140
			STATUSITEM cServidorSQL_usuario	WIDTH 100 
			DATE 
		END STATUSBAR
		DEFINE LABEL Dolar
		
		        ROW    8
		        COL    5
		        WIDTH  230
		        HEIGHT 20
		        VALUE 'Dolar: '
		        FONTNAME "Arial"
		        FONTSIZE 14
		        FONTBOLD .T.
		        FONTCOLOR {0,128,0}
    		
    END LABEL
    nMoneda := idMoneda('U$S')
     DEFINE LABEL  cotizacion
		
		        ROW    8
		        COL    90
		        WIDTH  230
		        HEIGHT 20
		        VALUE STR(busco_cotizacion(nMoneda))
		        FONTNAME "Arial"
		        FONTSIZE 14
		        FONTBOLD .T.
		        FONTCOLOR if( fechaMoneda(nMoneda) = date() ,{0,128,0},{255,0,0})
    		
    END LABEL
// 		DEFINE LABEL Label_EstadoCaja
//		
//		        ROW   8
//		        COL    600
//		        WIDTH  200
//		        HEIGHT 20
//		        VALUE  alltrim(if( cajaAbierta(cajaID()), '	Caja Abierta	' ,' ** Caja Cerrada ** '))
//		        FONTNAME "Arial"
//		        FONTSIZE 14
//		        FONTBOLD .T.
//		        FONTCOLOR if( cajaAbierta(cajaID()) ,{0,128,0},{255,0,0})
//    		
//    END LABEL
    		 
	END WINDOW
	            
 ACTIVATE WINDOW Principal 
Return


//function actualizoEstado()
//
//  Principal.Label_Sucursal.Value 	:= 	'Sucursal: '+ cSucursal
//  Principal.Label_Cajero.Value		:=	'Cajero  : '+ nombreCajeroActivo( cajaId() )
//  Principal.Label_Turno.Value		:=		'Turno   : '+ alltrim(nombreTurno( cajaId()) ) 
//  
//  Principal.Label_EstadoCaja.Value	:=	alltrim(if( cajaCerrada(cajaID()) ,' ** Caja Cerrada ** ', '	Caja Abierta	'))
//  Principal.Label_EstadoCaja.FONTCOLOR := if( cajaCerrada(cajaID()) ,{255,0,0},{0,128,0})
//return

Function refrescoCotizacion()

Principal.cotizacion.refresh
Return

**********************************
//function actualizoEstado()
//
//    Principal.Label_EstadoCaja.Value	:=	alltrim(if( cajaCerrada(cajaID()) ,' ** Caja Cerrada ** ', '	Caja Abierta	'))
//  Principal.Label_EstadoCaja.FONTCOLOR := if( cajaCerrada(cajaID()) ,{255,0,0},{0,128,0})
//return

*********************************
Function SeteoAmbiente()
	SEt deleted on
	Set Century on
	Set Date French
	//Set CODEPAGE TO unicode
	set CODEPAGE to SPANISH 
  HB_LANGSELECT('ES')	
	SET LANGUAGE TO SPANISH
	SET NAVIGATION EXTENDED
	SET MULTIPLE OFF
	SET BROWSESYNC ON
//	SET AUTOADJUST ON
	SET TOOLTIPSTYLE BALLOON
	SET TOOLTIPBACKCOLOR { 255 , 255 , 255 }
	SET TOOLTIPFORECOLOR { 0 , 0 , 0 }
	chequeoRespaldo()
	
	MySQL_Connect();

Return

function chequeoRespaldo()
local oFile
local cNombreRespaldo := PARAMETROini("archivoRespaldo","N")
local cLinea
local nlinea := PARAMETROini("linea","N")
local nCaracteres := PARAMETROini("caracteres","N")

if (oFile := fopen(cDirInicioAplicacion+"\respMorales.sql"))>0
	fseek(oFile,nlinea,2)
	cLinea := freadstr(oFile,nCaracteres)
	//msginfo(cLinea)
//else
//	msgInfo("No se pudo abrir el archivo "+str(ferror()))
endif
fclose(oFile)
return cLinea
*------------------------------------------------------------------------------*
Procedure MySQL_Connect()
	Local cServidor	:=	PARAMETROini("MYSQL_Servidor","C")	
	Local cUsuario	:=	PARAMETROini("MYSQL_Usuario","C")	
	Local cClave	  :=	PARAMETROini("MYSQL_Clave","C")	
	Local cBase     :=  PARAMETROini("MYSQL_Base","C") 
	// Connect

	oServer := TMySQLServer():New(cServidor, cUsuario, cClave)

	// Check For Error

	If oServer:NetErr()
		
		cServidorSQL_Estado	:=	'<Desconectado>'
		MsgStop("No se pudo conectar con Servidor:"+chr(13)+cServidor+chr(13)+cUsuario+chr(13)+cClave+chr(13)+oServer:Error())
		// MsgStop("No se pudo conectar con Servidor:"+chr(13)+cServidor+chr(13)+oServer:Error())
		Release Window ALL

	Else

		cServidorSQL_Estado	:=	'<Conectado>'
		// if msgYesNO("Usa la base de FE")
			// oServer:SelectDB( "comercio_fe" )
		// else	
			oServer:SelectDB( cBase )
		// endif
		If oServer:NetErr()	
			MsgStop("No se pudo conectar con Servidor:"+chr(13)+cServidor+chr(13)+oServer:Error())
		endif
	EndIf

Return


*------------------------------------------------------------------------------*
Procedure MySQL_Disconnect()
/*..............................................................................

	Class TMySQLServer - Method Destroy():
	
		- Cierra la conexion con un servidor.

..............................................................................*/

	oServer:Destroy()

	cServidorSQL_Estado	:=	'<Desconectado>'

	Principal.StatusBar.Item(2) := cServidorSQL_Estado

Return