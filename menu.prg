#include "minigui.ch"
#include <hmg.ch>
        
Function main() 
	Public	cNroVersionAplicacion	:=	"2." + __DATE__ +"."+SUBST(__TIME__,1,2)+SUBST(__TIME__,4,2)
	Public	cNombreTerminal		:=	GetEnv( "COMPUTERNAME" ) 
	Public	cDirInicioAplicacion	:=	"C:\dm\nuevo" //PARAMETROini("DIR_APLICACION","C") //
	Public	cDirDatos		:=	PARAMETROini("DIR_DBFs","C")
  Public  cNombreEmpresa := PARAMETROini("EMPRESA","C")
	Public 	oServer			:= 	Nil 
	Public	cServidorSQL_nombre	:=	PARAMETROini("MYSQL_Servidor","C")
	Public	cServidorSQL_usuario	:=lower(GetEnv( "USERNAME" ))
	Public	cServidorSQL_Estado	:=	'S/D'
	Public  cSucursal 		:= 	PARAMETROini("Sucursal","C")
	Public nSocioGlobal := 0
	Public cArticuloGlobal := ""
	
	SeteoAmbiente() 
      
    	DEFINE WINDOW Principal ;
    		AT 15,15 ;
    		WIDTH 680 ;
    		HEIGHT 110 ;
    		SIZABLE .F.;
    		MINBUTTON .T.;
    		MAXBUTTON .F.;
    		titlebar .T.;
    		TITLE "Gesti¢n de Ventas de "+cNombreEmpresa+" - Version " + cNroVersionAplicacion + ' - Terminal ' + cNombreTerminal ;
    		ICON	"MAINICON"			;
    		MAIN; 
    		ON RELEASE MySQL_Disconnect()
    		DEFINE MAIN MENU 
    				POPUP 'Contado'
    					ITEM 'Ventas Contado'  	ACTION factCliente('C',0)
    					
    					SEPARATOR
    					
    					ITEM 'Inicio de Caja'       ACTION inicioCaja()
        			ITEM 'Salidas de Caja'      ACTION salidaCaja()
        			ITEM 'Cierre de Caja'       ACTION cerrarCaja()
        			SEPARATOR

              ITEM 'Reimprimir Movimientos '	ACTION reImprimoMOvimientos()

              SEPARATOR

              ITEM 'Anulaci¢n Movimientos'    ACTION anuloMovimientos()
              
              SEPARATOR
              
              ITEM 'Buscar documentos' ACTION buscaDocumentos()
              
    				END POPUP 
      
      			POPUP 'Proveedores' 
                
               ITEM 'Compras Cr‚dito'  ACTION factProveedor()
               ITEM 'Recibos '         ACTION reciboProveedor('R')
               ITEM 'Bonificaciones '  ACTION reciboProveedor('N')
               ITEM 'Devoluciones '    ACTION reciboProveedor('D')
               SEPARATOR

               ITEM 'Estado de Cuenta' ACTION estadoCuentaProveedores()
					 				 
      				  
      			END POPUP
      			
      			POPUP 'Presupuestos'
      				ITEM 'Registro' 			ACTION factCliente('P',0)
      				
      				SEPARATOR
      				
      				ITEM 'Estado de Cuenta' ACTION presupuestos()
      				
      			END POPUP
      			
      			
     				
     				POPUP 'Mantenimientos'	name Mantenimientos
              
              
              SEPARATOR
            	ITEM 'Repuestos'    ACTION mantenimientoArticulo('')//mantenimientoEmpresas(0) 
      				ITEM 'Clientes'		  ACTION mantenimientoclientes(0)  
      				ITEM 'Proveedores' 	ACTION mantenimientoProveedor(0)
      				SEPARATOR
      				ITEM 'Marcas ' 			ACTION mantenimientoMarca(0)
      				ITEM 'Locaci¢n ' 		ACTION mantenimientoLocacion(0)
      				SEPARATOR
      				ITEM 'Usuario '			ACTION mantenimientoUsuario(0)
      			
      				
      			END POPUP
      			
      			POPUP 'Reportes'	name Listados
      				ITEM 'Resumen de Caja' ACTION imprimoCierre(cajaId())
      				ITEM 'Ventas Por Repuesto' ACTION ventasPorCodigo()
      				ITEM 'Resumen de Ventas' ACTION resumenventa()
      				ITEM 'Resumen de Compras' ACTION resumencompra()

      				SEPARATOR
      				ITEM 'Envio de Estados de Cuenta' ACTION envioEstados()
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
                
               	ITEM 'Ventas Credito'  	ACTION factCliente('F',0)

                SEPARATOR
                
                ITEM 'Recibos'       		ACTION reciboCliente()
                
                SEPARATOR

								ITEM 'Estado de Cuenta' ACTION estadoCuentaClientes()
                
      												
      			END POPUP
      			POPUP "Cotizacion Moneda"
      				ITEM 'Cotizaci¢n Moneda' ACTION cotizacion_moneda()
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
		
		MsgStop("No se pudo conectar con Servidor:"+chr(13)+cServidor+chr(13)+oServer:Error())
		Release Window ALL

	Else

		cServidorSQL_Estado	:=	'<Conectado>'
		oServer:SelectDB( cBase )
		
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