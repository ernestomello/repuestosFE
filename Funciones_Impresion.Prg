#include <minigui.ch>
/************************************************************************
*
* ImprimoReciboSocio, imprime el recibo que tenga el numero que se le pasa (N8). 
*		devuelve .T. si fue posible imprimirlo
*
************************************************************************/
Function ImprimoReciboSocio( nNumRecibo )
	Local nImpDirecto	:=	PARAMETROINI( 'Imp_Rec_Directo'		,'N' )
	Local nLineaIni		:=	PARAMETROINI( 'Imp_Rec_LinIni'		,'N' )
	Local nCol		:=	PARAMETROINI( 'Imp_Rec_ColIni'		,'N' )
	Local cFuenteImp	:=	PARAMETROINI( 'Imp_Rec_Fuente'		,'C' )
	Local nTamanoFuente	:=	PARAMETROINI( 'Imp_Rec_TamFuente'	,'N' )
	Local cBaseAb		:=	Alias()
	Local nRegAct		:=	Recno()
	Local lRetorno		:=	.F.
				
	If nImpDirecto # 1

	        SELECT PRINTER DIALOG TO lSuccess PREVIEW

        Else

                SELECT PRINTER DEFAULT TO lSuccess 

        Endif
	
	Select RECIBO		// debe tener seleccionado el ntx rec_nro
	
	DBSeek(nNumRecibo)
	
	IF !Found()
	
		MsgStop('No existe el recibo Nº +' + Str( nNumRecibo ,8 ) , 'Error de Inconsistencia')
		
		if !empty(baseab)

			Select &baseab
			go regact

		endif
		
		Return(.F.)
	
	Endif
	

/******************************************************************************
	IF !(Cargadatos.Check_Plancha.Value)
	
		nLineaIni := nLineaIni - nTirilla
	 		
	Endif

*******************************************************************************/

	IF lSuccess
		
		START PRINTDOC

			START PRINTPAGE

				nLin :=	nLineaIni + 0
				
				@ nLin + 020 , nCol + 115 	PRINT CARCEDU		 ;
								FONT cFuenteImp		 ;
								SIZE 10 

				@ nLin + 027 , nCol + 108 	PRINT Alltrim(NOMBRE) + ' ' + Alltrim(APELLIDO)		 ;
								FONT cFuenteImp		 ;
								SIZE 10 

				@ nLin + 036 , nCol + 115 	PRINT NACIONALID 	 ;
								FONT cFuenteImp		 ;
								SIZE 10 


				@ nLin + 045 , nCol + 115 	PRINT NACIMIENTO 	 ;
								FONT cFuenteImp		 ;
								SIZE 10 


				@ nLin + 053 , nCol + 115 	PRINT FECHA 	 	;
								FONT cFuenteImp		 ;
								SIZE 10 
								

				@ nLin + 054 , nCol + 015 	PRINT GLICEMIA 	 	;
								FONT cFuenteImp		 ;
								SIZE 10 
					

				@ nLin + 062 , nCol + 015 	PRINT COLESTEROL 	;
								FONT cFuenteImp		 ;
								SIZE 10 


				@ nLin + 055 , nCol + 053 	PRINT VALIDEZ	 	;
								FONT cFuenteImp		 ;
								SIZE 10 

				__GeneralGrabaLog('ImprimeRecibos','','Imprimio Recibo ' + STR( nNumRecibo , 8 ) )
					
														
			END PRINTPAGE

		END PRINTDOC		
		
		MsgInfo('Impresion Terminada')
	
		lRetorno	:=	.T.
	Else
	
	        MsgStop('No se pudo Seleccionar la impresora','Error de impresion')
	        
	        lRetorno	:=	.F.
	        
	EndIf

	if !empty(baseab)

		Select &baseab
		go regact

	endif
	
Return( lRetorno )
*-----------------------------------------------------------------------*
/************************************************************************
*
* ImprimoReciboSocio, imprime el recibo que tenga el numero que se le pasa (N8). 
*		devuelve .T. si fue posible imprimirlo
*
************************************************************************/
Function Imp_Comprobante( nId_Comprobante )
	Local nImpDirecto	:=	PARAMETROINI( 'Imp_Rec_Directo'		,'N' )
	Local nLineaIni		:=	PARAMETROINI( 'Imp_Rec_LinIni'		,'N' )
	Local nCol		:=	PARAMETROINI( 'Imp_Rec_ColIni'		,'N' )
	Local cFuenteImp	:=	PARAMETROINI( 'Imp_Rec_Fuente'		,'C' )
	Local nTamanoFuente	:=	PARAMETROINI( 'Imp_Rec_TamFuente'	,'N' )
	Local cBaseAb		:=	Alias()
	Local nRegAct		:=	Recno()
	Local lRetorno		:=	.F.
	
	USE		(cDirInicioAplicacin+'\DicCompr.DBF')	;
		INDEX	(cDirInicioAplicacin+'\DC_IDPOS.NTX')	;
		Alias 	DISENIO 				;
		New Readonly Shared
	
	DBSeek( Str( nId_Comprobante ,5 ) )
	
	If nImpDirecto # 1

	        SELECT PRINTER DIALOG TO lSuccess PREVIEW

        Else

                SELECT PRINTER DEFAULT TO lSuccess 

        Endif

	IF lSuccess
		
		START PRINTDOC

			START PRINTPAGE

				nLin :=	nLineaIni + 0
				
				Do While !Eof() .and. ID_DOCUMEN = nId_Comprobante
				
							
					IF (VARIABLE)
					
						@ nLin + YPOS , nCol + XPOS 	;
							PRINT &VALOR    	 ;
							FONT FUENTE		 ;
							SIZE TAMANO
					
					Else
					
						@ nLin + YPOS , nCol + XPOS 	;
							PRINT VALOR    	 	;
							FONT FUENTE		 ;
							SIZE TAMANO
					
					Endif
					
					Skip
			
				Enddo
					
														
			END PRINTPAGE

		END PRINTDOC		
		
		MsgInfo('Impresion Terminada')
	
		lRetorno	:=	.T.
	
	Else
	
	        MsgStop('No se pudo Seleccionar la impresora','Error de impresion')
	        
	        lRetorno	:=	.F.
	        
	EndIf
	
	SELECT DISENIO
	Dbclosearea()
	
	if !empty(cBaseAb)

		Select &cBaseAb
		go nRegAct

	endif
	
Return( lRetorno )
*-----------------------------------------------------------------------*
/************************************************************************
*
* Imp_VariosRecibos, imprime los recibos que tengan el numero que se le pasa a(N8). 
*		devuelve .T. si fue posible imprimirlo
*
************************************************************************/
Function Imp_VariosRecibos( aRecibos )
	Local nImpDirecto	:=	PARAMETROINI( 'Imp_Rec_Directo'		,'N' )
	Local nLineaIni		:=	PARAMETROINI( 'Imp_Rec_LinIni'		,'N' )
	Local nCol		:=	PARAMETROINI( 'Imp_Rec_ColIni'		,'N' )
	Local cFuenteImp	:=	PARAMETROINI( 'Imp_Rec_Fuente'		,'C' )
	Local nTamanoFuente	:=	PARAMETROINI( 'Imp_Rec_TamFuente'	,'N' )
	Local nRecibosXHoja	:=	PARAMETROINI( 'Imp_Rec_RecXHoja'	,'N' )
	Local cBaseAb		:=	Alias()
	Local nRegAct		:=	Recno()
	Local lRetorno		:=	.F.
	Local nId_Comprobante	:=	1001
	Local i			:=	1
	Local cSocioSel		:=	''
	Local cEmisionSel	:=	''
	
	USE		(cDirInicioAplicacin+'\DicCompr.DBF')	;
		INDEX	(cDirInicioAplicacin+'\DC_IDPOS.NTX')	;
		Alias 	DISENIO 				;
		New Readonly Shared
	

	If nImpDirecto # 1

	        SELECT PRINTER DIALOG TO lSuccess PREVIEW

        Else

                SELECT PRINTER DEFAULT TO lSuccess 

        Endif


	IF lSuccess
		
		START PRINTDOC

//			Do While i <= len( aRecibos )
			
			For nPaginas = 0 to (len(aRecibos)/nRecibosXHoja)
			
//				MsgInfo( str(npaginas) + ' de ' + str((len(aRecibos)/nRecibosXHoja)), 'Paginas a Imprimir')
	
				START PRINTPAGE

					nLin :=	nLineaIni + 0
					
					nRecXPagina	:=	1
					
					Do While nRecXPagina <= nRecibosXHoja .and. i <= len( aRecibos )
										
						Select RECIBO		
						go aRecibos[i]
	
						cSocioSel	:=	Str( NUMREC , 5 )
						cEmisionSel	:=	Str( ANOREC , 4 ) + Str( MESREC , 2 )
	
						Select SOCIOS
						DBSeek( Val( cSocioSel ) )
				
						Select RECIBO	
							
						DBSeek( cSocioSel + ;
							cEmisionSel )
							
						IF Found()	
					
							Select DISENIO							
							
							DBSeek( Str( nId_Comprobante ,5 ) )	
							
							Do While !Eof() .and. ID_DOCUMEN = nId_Comprobante
															
								Do Case 
									
									Case (VARIABLE) .AND. Rtrim(FUENTE) = 'Courier New'
													
										@ nLin + DISENIO->YPOS , nCol + DISENIO->XPOS 	;
											PRINT &(DISENIO->VALOR)    	 	;
											FONT cFuenteImp			 	;	
											SIZE DISENIO->TAMANO
	
									Case (VARIABLE) .AND. Rtrim(FUENTE)='PF Barcode 39'
													
										@ nLin + DISENIO->YPOS , nCol + DISENIO->XPOS 	;
											PRINT &(DISENIO->VALOR)    	 	;
											FONT 'PF Barcode 39'			;	
											SIZE DISENIO->TAMANO
								
									OtherWise
									
										@ nLin + DISENIO->YPOS , nCol + DISENIO->XPOS 	;
											PRINT DISENIO->VALOR    	 	;
											FONT (DISENIO->FUENTE)		 	;
											SIZE DISENIO->TAMANO
								
								EndCase 
								
								Skip
					
							Enddo
	
							nLin	+=	76

						Endif		

						i++
						
						nRecXPagina++
						
					Enddo
										
				END PRINTPAGE
			
			Next 

		END PRINTDOC		
		
		MsgInfo('Impresion Terminada')
	
		lRetorno	:=	.T.
	
	Else
	
	        MsgStop('No se pudo Seleccionar la impresora','Error de impresion')
	        
	        lRetorno	:=	.F.
	        
	EndIf
	
	SELECT DISENIO
	Dbclosearea()
	
	if !empty(cBaseAb)

		Select &cBaseAb
		go nRegAct

	endif
	
Return( lRetorno )
*-----------------------------------------------------------------------*
