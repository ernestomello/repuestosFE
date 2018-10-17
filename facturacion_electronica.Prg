#include <hmg.ch>
// #include "hbcurl.ch"
// #include "common.ch"
// #include "fileio.ch"



function facturaElectronica(nIdMov,bImprime,esCorreccion)
local oIdMov := oDocumentoCFE(nIdMov)
//local aSocio := iif(len(alltrim(oIdMov:getRow(1):fieldget(11)))=0, datoSocio(oIdMov:getRow(1):fieldGet(7)),oIdMov:getRow(1):fieldget(11))
local cDirMov := substr(dtos(oIdMov:getRow(1):fieldGet(6)),1,4)+"\"+substr(dtos(oIdMov:getRow(1):fieldGet(6)),5,2)+"\"
local cArchivo := cDirFE+cDirMov+str(nIdMov)
local pArchivo 
local cArchivoRespuesta := cArchivo+".txt"
local  cExeFile := "C:\Archivos de programa\SumatraPDF\SumatraPDF.exe"
local aLineasL := {}
//msginfo(aSocio)
if !creaDirectorio(cDirFE,cDirMov)
	return .f.
//	msginfo(str(makedir(cDirFE+cDirMov)))
endif

pArchivo := fcreate(cArchivo+"ida.txt",0)

if !linea1(pArchivo,oIdMov)
	return .f.
endif
fwrite(parchivo," <nsAd:Encabezado>"+chr(13))
if !linea2(pArchivo,oIdMov)

	return .f.
endif
if !linea3(pArchivo,oIdMov)
	return .f.
endif

if !linea4(pArchivo,aSocio)
	return .f.
endif
if !linea5(pArchivo,oIdMov)
	return .f.
endif
fwrite(parchivo," </nsAd:Encabezado>"+chr(13))
fwrite(parchivo,"<nsAd:Detalle>"+chr(13))
if !linea6(pArchivo,nIdMov)
	return .f.
endif
fwrite(parchivo,"</nsAd:Detalle>"+chr(13))
/*
if !linea7(pArchivo)
	return .f.
endif
*/
if esCorreccion
if !linea8(pArchivo,nIdMov)
	return .f.
endif
endif
if !linea10(pArchivo,oIdMov)
	return .f.
endif
/*
if !linea11(pArchivo)
	return .f.
endif
*/
/*
if !linea12(pArchivo)
	return .f.
endif
*/

fclose(parchivo)
cArchivoEnv := strtran(cArchivo," ","~")
//llamo a efacturacion con el archivo como parámetro
//msgInfo(cArchivo+".txt - "+cArchivoEnv+".txt")
EXECUTE FILE '"' + exeFELocal + '"' PARAMETERS  '' + cArchivoEnv+"ida.txt "+cArchivoEnv+".txt" 
//__run(exeFELocal+"  "+cArchivoEnv+"ida.txt "+cArchivoEnv+".txt")
WaitPeriod( 5000 )             // Espera 2 segundos

do while  WaitPeriod()
	if !file(cArchivo+".txt") 
			//msgInfo("no esta")
	else		
		exit//msginfo("esta")
	endif
	//tiempo de espera para volver a chequear que llegó el archivo
enddo

if file(cArchivo+".txt")

	cContenido := memotran(hb_memoRead(cArchivo+".txt"))
	//msginfo(cContenido)
	aLineasL := hb_atokens(cContenido,";")
	
	if hb_atokens(aLineasL[1],"|")[2] == "AE"
		actualizaFE(nIdMov, aLineasL[2])
	else
		msgInfo(" Devolucion de Errores"+chr(13)+hb_atokens(aLineasL[2],"|")[4])
		return .f.
	endif
else
	return .f.
//run(cExeFile+" -print-to-default -exit-on-print "+cArchivo+".pdf")

endif

return .t.

function actualizaFE(nIdMov, clinea2)
local oQuery, cQuery

cQuery := " update cfe_comprobante_cab "
cQuery += " set serieCFE = '"+hb_atokens(clinea2,"|")[2]+"', "
cQuery += " numeroCFE = "+hb_atokens(clinea2,"|")[3]+", "
cQuery += " cfe_codigo_seguridad = '"+hb_atokens(clinea2,"|")[4]+"' "
cQuery += " where id_factura = "+str(nIdMov)+" " 

oQuery:= oServer:Query(  cQuery )
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  oQuery:=oServer:Query('ROLLBACK') //si no puede guardar el cabezal anulo todo(incluido el número de factua)
  return .f.
endif

return .t.

function actualizaFEContingencia(nIdMov,cSerie,nNumero)
local oQuery, cQuery


cQuery := " update cfe_comprobante_cab "
cQuery += " set tipoCFE = tipoCFE + 100, "
cQuery += " serieCFE = '"+cSerie+"', "
cQuery += " numeroCFE = "+str(nNumero)+" "
cQuery += " where id_factura = "+str(nIdMov)+" " 

oQuery:= oServer:Query(  cQuery )
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  oQuery:=oServer:Query('ROLLBACK') //si no puede guardar el cabezal anulo todo(incluido el número de factua)
  return .f.
endif

return .t.


function facturaContingencia(nIdMov)
local aResultado


aResultado := inputWindow('Datos Factura Contingencia',{'Serie','Numero'},{'',0},{2,'9999999'})
do while !numeroEsContingencia(aResultado[2])
	messageBoxTimeout("El numero ingresado no Corresponde"+chr(13)+"Ingrese nuevamente","Alerta",,3000)
	aResultado := inputWindow('Datos Factura Contingencia',{'Serie','Numero'},{'',0},{2,'9999999'})
enddo

actualizaFEContingencia(nIdMov,aResultado[1],aResultado[2])

return .t.

function numeroEsContingencia(nNumero)
local oQuery
local cQuery

cQuery := "select serie from numeradores where tabla='contingencia' and numero<="+str(nNumero)+" or numeroHasta >= "+str(nNumero)+" "
oQuery := oServer:Query(cQuery )
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
  return .f.
Endif

if oQuery:lastrec() = 0
	return .f.
endif

return .t.


function linea1(pArchivo,oIdMov)
local cRut := alltrim(PARAMETROini("FERUTEMISOR","C"))
local cIdMov := str(oIdMov:getRow(1):fieldGet(1))
local cfecha := dtos(date())
cfecha := substr(cfecha,1,4)+"-"+substr(cfecha,5,2)+"-"+substr(cfecha,7,2)

cLinea :="1|"+cRut+"|"+cIdMov+"|"+cfecha+chr(13)+chr(10)
//msginfo(cLinea)
fwrite(parchivo,clinea)
return .t.


function linea2(pArchivo,oIdMov)
local cFechaEmision := dtos(oIdMov:getRow(1):fieldGet(6))
local cTipoCFE := oIdMov:getRow(1):fieldGet(4)
local cFormaPago := oIdMov:getRow(1):fieldGet(13)
local cFechaVenc := dtos(oIdMov:getRow(1):fieldGet(6))
local cSerie :=	oIdMov:getRow(1):fieldGet(2)
local cNumero :=  oIdMov:getRow(1):fieldGet(3)
//set( _SET_DATEFORMAT, "yyyy-mm-dd" ) 
local cLinea := "<nsAd:IdDoc>"+chr(13)
cLinea += "<nsAd:TipoCFE>"+str(cTipoCFE)+"</nsAd:TipoCFE>"+chr(13)
cLinea += "<nsAd:Serie>"+cSerie+"</nsAd:Serie>"+chr(13)
cLinea += "<nsAd:Nro>"+str(cNumero)+"</nsAd:Nro>"+chr(13)
cLinea += "<nsAd:FchEmis>"+substr(cFechaEmision,1,4)+"-"+substr(cFechaEmision,5,2)+"-"+substr(cFechaEmision,7,2)+"</nsAd:FchEmis>"+chr(13)
cLinea += "<nsAd:MntBruto>1</nsAd:MntBruto>"+chr(13)
cLinea += "<nsAd:FmaPago>"+str(cFormaPago)+"</nsAd:FmaPago>"+chr(13)
cLinea += "</nsAd:IdDoc>"+chr(13)
// if cTipoCFE != 182+chr(13)
// cLinea := "2|"+str(cTipoCFE)+"|"+cSerie+"|"+str(cNumero)+"|"+substr(cFechaEmision,1,4)+"-"+substr(cFechaEmision,5,2)+"-"+substr(cFechaEmision,7,2)+"|1|"+str(cFormaPago)+"|"+substr(cFechaVenc,1,4)+"-"+substr(cFechaVenc,5,2)+"-"+substr(cFechaVenc,7,2)+chr(13)+chr(10)
// else
// cLinea := "2|"+str(cTipoCFE)+"|"+cSerie+"|"+str(cNumero)+"|"+substr(cFechaEmision,1,4)+"-"+substr(cFechaEmision,5,2)+"-"+substr(cFechaEmision,7,2)+"| |"+str(cFormaPago)+"|"+chr(13)+chr(10)
// endif
//msginfo(cLinea)

fwrite(parchivo,clinea)
return .t.

function linea3(pArchivo,oIdMov)
local cRut := alltrim(PARAMETROini("FERUTEMISOR","C"))
local cRazonE := alltrim(PARAMETROini("FERAZONEMISOR","C"))
local cCodDGISuc := alltrim(PARAMETROini("FEDGIEMISOR","C"))
local cDirE := alltrim(PARAMETROini("FEDIREMISOR","C"))
local cCiuE := alltrim(PARAMETROini("FECIUEMISOR","C"))
local cDepE := alltrim(PARAMETROini("FEDEPEMISOR","C"))
local cLinea := "<nsAd:Emisor>"+chr(13)
cLinea += "<nsAd:RUCEmisor>"+cRut+"</nsAd:RUCEmisor>"+chr(13)
cLinea +="<nsAd:RznSoc>"+cRazonE+"</nsAd:RznSoc>"+chr(13)
cLinea +="<nsAd:NomComercial>eBorne</nsAd:NomComercial>"+chr(13)
cLinea +="<nsAd:EmiSucursal>Sucursal principal</nsAd:EmiSucursal>"+chr(13)
cLinea +="<nsAd:CdgDGISucur>"+cCodDGISuc+"</nsAd:CdgDGISucur>"+chr(13)
cLinea +="<nsAd:DomFiscal>"+cDirE+"</nsAd:DomFiscal>"+chr(13)
cLinea +="<nsAd:Ciudad>"+cCiuE+"</nsAd:Ciudad>"+chr(13)
cLinea +="<nsAd:Departamento>"+cDepE+"</nsAd:Departamento>"+chr(13)
cLinea +="</nsAd:Emisor>"+chr(13)
        
// local cLinea := "3|"+cRut+"|"+cRazonE+"|"+cCodDGISuc+"|"+cDirE+"|"+cCiuE+"|"+cDepE+chr(13)+chr(10)

//msginfo(cLinea)

fwrite(parchivo,clinea)
return .t.

function linea4(pArchivo,aSocio)
local cTipoDocR := iif(alltrim(hb_atokens(aSocio,"|")[2]) == '0','3',alltrim(hb_atokens(aSocio,"|")[1]))
local cCodPaisR := "UY" //modificar la base de Empresa o Persona
local cDocR :=  hb_atokens(aSocio,"|")[2]
local cRazonR := hb_atokens(aSocio,"|")[3]
local cDirR := alltrim(hb_atokens(aSocio,"|")[4])
local cCiuR := hb_atokens(aSocio,"|")[5]//"PAYSANDU"//oIdMov:getRow(1):fieldGet(1)
local cDepR := "PAYSANDU"//oIdMov:getRow(1):fieldGet(1)
local cCompraId := ""//oIdMov:getRow(1):fieldGet(1)
local cPaisR := "URUGUAY"//oIdMov:getRow(1):fieldGet(1)
local cLinea :=""

if alltrim(cTipoDocR) == '3'
	// if formatoCedula(hb_atokens(aSocio,"|")[2])
		// cDocR := hb_atokens(aSocio,"|")[2]
	// else
		// cDocR := '0'
	// endif
endif
cLinea +="<nsAd:Receptor>"+chr(13)
cLinea +="<nsAd:TipoDocRecep>"+cTipoDocR+"</nsAd:TipoDocRecep>"+chr(13)
cLinea +="<nsAd:CodPaisRecep>"+cCodPaisR+"</nsAd:CodPaisRecep>"+chr(13)
cLinea +="<nsAd:DocRecep>"+cDocR+"</nsAd:DocRecep>"+chr(13)
cLinea +="<nsAd:RznSocRecep>"+cRazonR+"</nsAd:RznSocRecep>"+chr(13)
cLinea +="<nsAd:DirRecep>"+cDirR+"</nsAd:DirRecep>"+chr(13)
cLinea +="<nsAd:CiudadRecep>"+cCiuR+"</nsAd:CiudadRecep>"+chr(13)
cLinea +="<nsAd:DeptoRecep>"+cDepR+"</nsAd:DeptoRecep>"+chr(13)
cLinea +="<nsAd:PaisRecep>"+cPaisR+"</nsAd:PaisRecep>"+chr(13)
cLinea +="</nsAd:Receptor>"+chr(13)

// cLinea := "4|"+cTipoDocR+"|"+cCodPaisR+"|"+cDocR+"|"+cRazonR+"|"+cDirR+"|"+cCiuR+"|"+cDepR+"|"+cCompraId+"|"+cPaisR+chr(13)+chr(10)

//msginfo(cLinea)
fwrite(parchivo,clinea)
return .t.

function linea5(pArchivo,oIdMov)
local cMoneda := "UYU"//(oIdMov:getRow(1):fieldGet(1)
local cIvaBas :=alltrim(PARAMETROini("FEIVABASE","C"))
local cIvaMin := alltrim(PARAMETROini("FEIVAMIN","C"))
local cLinea := "<nsAd:Totales>"+chr(13)
cLinea +="<nsAd:TpoMoneda>UYU</nsAd:TpoMoneda>"+chr(13)
cLinea +="<nsAd:MntNoGrv></nsAd:MntNoGrv>"+chr(13)
cLinea +="<nsAd:MntNetoIvaTasaMin></nsAd:MntNetoIvaTasaMin>"+chr(13)
cLinea +="<nsAd:MntNetoIVATasaBasica></nsAd:MntNetoIVATasaBasica>"+chr(13)
cLinea +="<nsAd:IVATasaMin>"+cIvaMin+"</nsAd:IVATasaMin>"+chr(13)
cLinea +="<nsAd:IVATasaBasica>"+cIvaBas+"</nsAd:IVATasaBasica>"+chr(13)
cLinea +="<nsAd:MntIVATasaMin></nsAd:MntIVATasaMin>"+chr(13)
cLinea +="<nsAd:MntIVATasaBasica></nsAd:MntIVATasaBasica>"+chr(13)
cLinea +="<nsAd:MntTotal></nsAd:MntTotal>"+chr(13)
cLinea +="<nsAd:CantLinDet></nsAd:CantLinDet>"+chr(13)
cLinea +="<nsAd:MontoNF></nsAd:MontoNF>"+chr(13)
cLinea +="<nsAd:MntPagar></nsAd:MntPagar>"+chr(13)
cLinea +="</nsAd:Totales>"+chr(13)


// "5|"+cMoneda+"||||"+cIvaMin+"|"+cIvaBas+"||||||"+chr(13)+chr(10)
//msginfo(cLinea)
fwrite(parchivo,clinea)
return .t.


function linea6(pArchivo,nIdMov)
Local oDetalle := oDetalleFactura(nIdMov)//los detalles de cada factura Electronica
local cLinea := "",cCuota := "", cCant := "", cUnidad := "", cPrecUnit := ""
local cIndica := "", cDescPor :="",cDescMon := "",cRecPor := "", cRecMon := ""
local cMontoItem := "0",cDescExt := "",cDescArt:= ""


for i = 1 to oDetalle:lastRec()
	if oDetalle:getRow(i):fieldGet(10) != 182
		if alltrim(oDetalle:getRow(i):fieldGet(2)) = "1"
			cDescArt := alltrim(oDetalle:getRow(i):fieldGet(8))+" No.Socio "+str(oDetalle:getRow(i):fieldGet(6))+;
								"-Cuota "+alltrim(oDetalle:getRow(i):fieldGet(7))
		else
			if alltrim(oDetalle:getRow(i):fieldGet(9))== alltrim(oDetalle:getRow(i):fieldGet(8))
				cDescArt :=alltrim(oDetalle:getRow(i):fieldGet(8))
			else
				cDescArt :=alltrim(oDetalle:getRow(i):fieldGet(8))+ alltrim(oDetalle:getRow(i):fieldGet(9))
			endif
		endif
		
								
		cCant := oDetalle:getRow(i):fieldGet(3)
		cUnidad := "UN"
		cPrecUnit := oDetalle:getRow(i):fieldGet(4)
		cIndica := oDetalle:getRow(i):fieldGet(5)
		cLinea += "<nsAd:Item>"+chr(13)
        cLinea += "<nsAd:NroLinDet>"+alltrim(str(i))+"</nsAd:NroLinDet>"+chr(13)
        cLinea += "<nsAd:IndFact>"+str(cIndica)+"</nsAd:IndFact>"+chr(13)
        cLinea += "<nsAd:NomItem>"+cDescArt+"</nsAd:NomItem>"+chr(13)
        cLinea += "<nsAd:Cantidad>"+str(cCant)+"</nsAd:Cantidad>"+chr(13)
        cLinea += "<nsAd:UniMed>"+cUnidad+"</nsAd:UniMed>"+chr(13)
        cLinea += "<nsAd:PrecioUnitario>"+str(cPrecUnit)+"</nsAd:PrecioUnitario>"+chr(13)
        cLinea += "<nsAd:MontoItem>"+cMontoItem+"</nsAd:MontoItem>"+chr(13)
        cLinea += "</nsAd:Item>"+chr(13)
		
		// cLinea := "6|"+alltrim(str(i))+"|"+str(cIndica)+"|"+cDescArt+"|"+str(cCant)+"|"+cUnidad+"|"+str(cPrecUnit)+"|"+;
							// cDescPor+"|"+cDescMon+"|"+cRecPor+"|"+cRecMon+"|"+cMontoItem+"|"+cDescExt+chr(13)+chr(10)
		fwrite(parchivo,clinea)
	else
		cCodRet := oDetalle:getRow(i):fieldGet(2)
		cTasa := round(oDetalle:getRow(i):fieldGet(3),0)
		cMontSujetoRet := oDetalle:getRow(i):fieldGet(4)
		cMontoRet := round( cMontSujetoRet * (cTasa /100),2)
		
		cLinea := "6|"+alltrim(str(i))+"|"+cIndica+"|"+cDescArt+"|"+cCant+"|"+cUnidad+"|"+cPrecUnit+"|"+;
							cDescPor+"|"+cDescMon+"|"+cRecPor+"|"+cRecMon+"|"+cMontoItem+"|"+cDescExt+chr(13)+chr(10)
		fwrite(parchivo,clinea)
		cLinea := "6B|"+alltrim(str(i))+"|"+alltrim(cCodRet)+"|"+str(cTasa)+"|"+str(cMontSujetoRet)+"|"+str(cMontoRet)+chr(13)+chr(10)
		fwrite(parchivo,clinea)
	endif
next

return .t.

function linea7(pArchivo)
local cLinea := "7|||||"+chr(13)+chr(10)

fwrite(parchivo,clinea)
return .t.

function linea8(pArchivo,nIdMov)
local cLinea := "8||||||||"+chr(13)+chr(10)
local oNotaCredDeb:= oNotaCreditoDebito(nIdMov)
local i 

	for i := 1 to oNotaCredDeb:lastRec()
		cTipoCFE := oNotaCredDeb:getRow(i):fieldGet(4)
		cSerie := oNotaCredDeb:getRow(i):fieldGet(5)
		cNumero := oNotaCredDeb:getRow(i):fieldGet(6)
		cRazon := oNotaCredDeb:getRow(i):fieldGet(8)
		cFecha := dtos(oNotaCredDeb:getRow(i):fieldGet(7))
		cLinea := "8|"+str(i)+"||"+str(cTipoCFE)+"|"+cSerie+"|"+str(cNumero)+"|"+alltrim(cRazon)+"|"+substr(cFecha,1,4)+"-"+substr(cFecha,5,2)+"-"+substr(cFecha,7,2)+chr(13)+chr(10)
		fwrite(parchivo,clinea)
	next
return .t.


function linea10(pArchivo,oIdMov)
local cAdenda := strtran(oIdMov:getRow(1):fieldGet(15),chr(13)," ")
local cLinea := "<nsAdenda:Adenda>"+cAdenda+"</nsAdenda:Adenda>"+chr(13)
// "10|"+cAdenda//+chr(13)+chr(10)

fwrite(parchivo,clinea)
return .t.

function linea11(pArchivo)
local cLinea := "11|1"+chr(13)+chr(10)
fwrite(parchivo,clinea)
return .t.

function linea12(pArchivo)
local cLinea := "12|||||"+chr(13)+chr(10)
fwrite(parchivo,clinea)
return .t.

function oDetalleFactura(nIdMov)
local oQuery
local cQuery

cQuery := " select d.item,d.codigo_barra, d.cantidad,d.precio_unitario,d.cfe_ind_fact,c.id_socio,c.anio_mes, s.descripcion,d.descripcion,ca.tipoCFE "
cQuery += " from servicio s , cfe_comprobante_cab ca ,"
cQuery += " cfe_comprobante_det d left join cuota_cab c on d.id_cuota = c.id_cuota "
cQuery += " where d.codigo_barra= s.id_servicio and d.id_factura = "+str(nIdMov)+" and d.id_factura = ca.id_factura "
oQuery := oServer:Query(cQuery )
    If oQuery:NetErr()												
      MsgInfo("SQL SELECT error: " + oQuery:Error())
    Endif
return oQuery

function oDetFactura(nIdMov,fDoble )//Solo para devoluciones
local oQuery
local cQuery
local cDobleDet:= iif(fDoble,"ext","det")

cQuery := " select * from cfe_comprobante_"+cDobleDet+" d"
cQuery += " where  d.id_factura = "+str(nIdMov)+""
oQuery := oServer:Query(cQuery )
    If oQuery:NetErr()												
      MsgInfo("SQL SELECT error: " + oQuery:Error())
    Endif
return oQuery



function oNotaCreditoDebito(nIdMov)
local oQuery
local cQuery

cQuery := "select * from cfe_referencias_det where id_factura = "+str(nIdMov)+""
oQuery := oServer:Query(cQuery )
    If oQuery:NetErr()												
      MsgInfo("SQL SELECT error: " + oQuery:Error())
    Endif
return oQuery

function anuladoDocumentoCFE(nIdMov)
local oQuery
local cQuery

cQuery := "select * from cfe_referencias_det where id_factura_ref = "+str(nIdMov)+""
oQuery := oServer:Query(cQuery )
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
endif
if oQuery:lastrec() <= 0
	return .f.
else
	return .t.
endif

function reciboDocumentoCFE(nIdMov)
local oQuery
local cQuery

cQuery := "select c.tipoCFE from cfe_comprobante_cab c, cfe_referencias_det d "
cQuery += " where id_factura_ref = "+str(nIdMov)+" "
cQuery += " and c.id_factura = d.id_factura"
oQuery := oServer:Query(cQuery )
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
endif
if oQuery:getRow(1):fieldget(1) != 99
	return .f.
else
	return .t.
endif

function oDocumentoCFE(nIdMov)
local oQuery
local cQuery

cQuery := "select * from cfe_comprobante_cab where id_factura = "+str(nIdMov)+""
oQuery := oServer:Query(cQuery )
    If oQuery:NetErr()												
      MsgInfo("SQL SELECT error: " + oQuery:Error())
    Endif
return oQuery



function guardaFactura(aCabezal, aLineas,fDoble,aNotas)
local oQuery
local cQuery
local nCuota
local nCuotas
local i, idMov,fechaPago,anioMes,nIndFac,nSocioL
local nTotLineas:= 0
local cDobleDet:= iif(fDoble,"ext","det")

                               //cabezal movimiento	  
  
cQuery := " Insert into cfe_comprobante_cab values( null,'',0,"+str(aCabezal[1,1])+ "  "
cQuery += " ,"+str(aCabezal[1,2])+",'"+dtos(aCabezal[1,3])+"' "
cQuery += " ,"+str(aCabezal[1,4])+ " "
cQuery += " ,"+str(aCabezal[1,5])+",0.00,0.00 ,'"+aCabezal[1,6]+"',current_timestamp,"+str(aCabezal[1,7])+",'','"+aCabezal[1,8]+"' ) "
oQuery:= oServer:Query(  cQuery )
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  oQuery:=oServer:Query('ROLLBACK') //si no puede guardar el cabezal anulo todo(incluido el número de factua)
  return 0    
endif
	 
oQuery:= oServer:Query( 'select LAST_INSERT_ID()')
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  oQuery:=oServer:Query('ROLLBACK') //si o puedo obtener el id del cabezal anulo todo para atrás
  return 0
endif
                                       //detalle movimiento   
idMov := oQuery:GetRow(1):fieldGet(1)
      
for i:= 1 to len(alineas)

  nCuota := alineas[i,4]
  fechaPago := date()
 // anioMes := anioMes(nCuota)
  nIndFact := iif(alineas[i,5] = 0, 5, alineas[i,6])
  nTotLineas += alineas[i,5]
  cQuery := " insert into cfe_comprobante_"+cDobleDet+" values( " 
  cQuery += " "+str(idMov)+", "+str(i)+", "+str(alineas[i,1])+","
  cQuery += " "+str(alineas[i,2])+","+str(alineas[i,3])+","+str(aLineas[i,4])+", "
  cQuery += " "+str(alineas[i,5])+","+str(nIndFact)+", '"+alineas[i,7]+"' )"
  oQuery := oServer:Query(cQuery)
  If oQuery:NetErr() 
    MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
    oQuery:=oServer:Query('ROLLBACK') //si no puedo guardar alguna de las lìneas anulo todo para atrás
    return 0
  endif
  
  
  if nCuota != 0
	  // if !pagoCuota(nCuota,aCabezal[1,1],aCabezal[1,7])
	    // oQuery:=oServer:Query('ROLLBACK') //si no puedo dejar como paga la cuota anulo todo
	    // return 0
	  // endif 
	  // nSocioL := socioCuota(nCuota)
	  // cambioEstado(nSocioL)
	  if nSocioL < 10000
	  	base := 0
	  else
	  	base := 1
	  endif   
		// modificaSocioArea(nSocioL,base,anioMes,fechaPago)
	endif 
next

if fDoble //cuando no se registran las líneas y se pone una genérica
	
	// cDetalleGenerico := nombreCobradorConvenio(aCabezal[1,4])
	nIndFact := iif(nTotLineas = 0, 5, cfeIndFacturacion(0))
 	cQuery := " insert into cfe_comprobante_det values( " 
  cQuery += " "+str(idMov)+",1,'0',1,"+str(nTotLineas)+",0, "
  cQuery += " "+str(nTotLineas)+","+str(nIndFact)+",'"+cDetalleGenerico+"' )"
  oQuery := oServer:Query(cQuery)
  If oQuery:NetErr() 
    MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
    oQuery:=oServer:Query('ROLLBACK') //si no puedo guardar alguna de las lìneas anulo todo para atrás
    return 0
  endif
endif

//aca se procesan las NC en caso de que sean
if len(aNotas) != 0
	for h := 1 to len(aNotas)
	//msginfo(aNotas[h,4])
	 cQuery := " insert into cfe_referencias_det values( " 
	  cQuery += " "+str(idMov)+", "+str(h)+", '',"
	  cQuery += " "+str(aNotas[h,1])+",'"+aNotas[h,2]+"',"+str(aNotas[h,3])+", "
	  cQuery += " '"+dtos(aNotas[h,4])+"','', "+str(aNotas[h,5])+" )"
	  oQuery := oServer:Query(cQuery)
	  If oQuery:NetErr() 
	    MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
	    oQuery:=oServer:Query('ROLLBACK') //si no puedo guardar alguna de las lìneas anulo todo para atrás
	    return 0
	  endif
/*		
	nCuotas := traeCuotasFacturaE(aNotas[h,5])
	for j:= 1 to nCuotas:lastrec()
		if !pagoCuota(nCuotas:GetRow(j):fieldget(1),aCabezal[1,1],aCabezal[1,7])
	    oQuery:=oServer:Query('ROLLBACK') //si no puedo dejar como paga la cuota anulo todo
	    return 0
	  endif 
	  nSocioL := socioCuota(nCuota)
	  cambioEstado(nSocioL)
	  if nSocioL < 10000
	  	base := 0
	  else
	  	base := 1
	  endif   
		modificaSocioArea(nSocioL,base,anioMes,fechaPago)
	next
*/
next
endif
return idMov

function guardaRecibo(aCabezal, aLineas,nIdMov)
local oQuery
local cQuery
local nCuota
local nCuotas
local i, idMov,fechaPago,anioMes,nIndFac,nSocioL
local nTotLineas:= 0

                               //cabezal movimiento	  
  
cQuery := " Insert into cfe_comprobante_cab values( null,'',0,"+str(aCabezal[1,1])+ "  "
cQuery += " ,"+str(aCabezal[1,2])+",'"+dtos(aCabezal[1,3])+"' "
cQuery += " ,"+str(aCabezal[1,4])+ " "
cQuery += " ,"+str(aCabezal[1,5])+",0.00,0.00 ,'"+aCabezal[1,6]+"',current_timestamp,"+str(aCabezal[1,7])+",'','"+aCabezal[1,8]+"' ) "
oQuery:= oServer:Query(  cQuery )
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  oQuery:=oServer:Query('ROLLBACK') //si no puede guardar el cabezal anulo todo(incluido el número de factua)
  return 0    
endif
	 
oQuery:= oServer:Query( 'select LAST_INSERT_ID()')
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  oQuery:=oServer:Query('ROLLBACK') //si o puedo obtener el id del cabezal anulo todo para atrás
  return 0
endif
                                       //detalle movimiento   
idMov := oQuery:GetRow(1):fieldGet(1)
      
for i:= 1 to len(alineas)

  nCuota := alineas[i,4]
  fechaPago := date()
  //anioMes := anioMes(nCuota)
  nIndFact := iif(alineas[i,5] = 0, 5, alineas[i,6])
  nTotLineas += alineas[i,5]
  cQuery := " insert into cfe_comprobante_det values( " 
  cQuery += " "+str(idMov)+", "+str(i)+", "+str(alineas[i,1])+","
  cQuery += " "+str(alineas[i,2])+","+str(alineas[i,3])+","+str(aLineas[i,4])+", "
  cQuery += " "+str(alineas[i,5])+","+str(nIndFact)+", '"+alineas[i,7]+"' )"
  oQuery := oServer:Query(cQuery)
  If oQuery:NetErr() 
    MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
    oQuery:=oServer:Query('ROLLBACK') //si no puedo guardar alguna de las lìneas anulo todo para atrás
    return 0
  endif
  
  
  if nCuota != 0
	  // if !pagoCuota(nCuota,aCabezal[1,1],aCabezal[1,7])
	    // oQuery:=oServer:Query('ROLLBACK') //si no puedo dejar como paga la cuota anulo todo
	    // return 0
	  // endif 
	  // nSocioL := socioCuota(nCuota)
	  // cambioEstado(nSocioL)
	  if nSocioL < 10000
	  	base := 0
	  else
	  	base := 1
	  endif   
		// modificaSocioArea(nSocioL,base,anioMes,fechaPago)
	endif 
next

oDocCFE := oDocumentoCFE(nIdMov)
//aca se agrega la referencia a la factura que se deja paga
	 cQuery := " insert into cfe_referencias_det values( " 
	  cQuery += " "+str(idMov)+",1, '',"
	  cQuery += " "+str(oDocCFE:GetRow(1):fieldget(4))+",'"+oDocCFE:GetRow(1):fieldget(2)+"',"+str(oDocCFE:GetRow(1):fieldget(3))+", "
	  cQuery += " '"+dtos(oDocCFE:GetRow(1):fieldget(6))+"','', "+str(oDocCFE:GetRow(1):fieldget(1))+" )"
	  oQuery := oServer:Query(cQuery)
	  If oQuery:NetErr() 
	    MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
	    oQuery:=oServer:Query('ROLLBACK') //si no puedo guardar alguna de las lìneas anulo todo para atrás
	    return 0
	  endif
return idMov



function oIndFacturacion()
local oQuery
local cQuery

cQuery := "select id_indicador, descripcion from cfe_ind_facturacion"
oQuery := oServer:Query(cQuery)
 If oQuery:NetErr() 
    MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
    return .f.
  endIf
return oQuery

function cfeIndFacturacion(nidIndice)
local oQuery
local cQuery

cQuery := "select cfe_ind_fact  from servicio where id_servicio = "+str(nidIndice)+"  "
oQuery := oServer:Query(cQuery)
 If oQuery:NetErr() 
    MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
    return 2 //tasa mínima
  endIf
return oQuery:getRow(1):fieldGet(1)

function iniTran()
local oQuery

oQuery:= oServer:Query( 'BEGIN' ) //comienzo la transacción
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  oQuery:=oServer:Query('ROLLBACK') //si no puede hacer el comienzo de la transaccion cancelo
  return .f.
endif

return .t.

function noTran()
local oQuery

oQuery:= oServer:Query( 'ROLLBACK' ) //comienzo la transacción
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  oQuery:=oServer:Query('ROLLBACK') //si no puede hacer el comienzo de la transaccion cancelo
  return .f.
endif

return .t.

function finTran()
local oQuery

oQuery:= oServer:Query( 'COMMIT' ) //comienzo la transacción
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oQuery:Error() )
  oQuery:=oServer:Query('ROLLBACK') //si no puede hacer el comienzo de la transaccion cancelo
  return .f.
endif

return .t.

function creaDirectorio(cDirFE,cDirMov)

//msginfo(cDirFE+substr(cDirMov,1,4))

if !file(cDirFE+substr(cDirMov,1,4)+"\*")
	makedir(cDirFE+substr(cDirMov,1,4))
endif

//msginfo(cDirFE+cDirMov)

if !file(cDirFE+cDirMov+"*.*")
	makedir(cDirFE+cDirMov)
endif
return .t.


function confirmadoSinFE(nIdMov)
local oQuery, cQuery

cQuery := " update cfe_comprobante_cab "
cQuery += " set cfe_codigo_seguridad = 'CONFIRMADO' "
cQuery += " where id_factura = "+str(nIdMov)+" " 

oQuery:= oServer:Query(  cQuery )
if oQuery:NetErr() 
  return .f.
endif

return .t.

function traeCuotasFacturaE(nIdFactura)
local oQuery
local cQuery

cQuery := " select e.id_cuota from cfe_comprobante_ext e, cfe_comprobante_cab c"
cQuery += " where e.id_factura = c.id_factura "
cQuery += " and c.id_factura= "+str(nIdFactura)+"  "
oQuery := oServer:Query(cQuery )
    If oQuery:NetErr()												
      MsgInfo("SQL SELECT error: " + oQuery:Error())
    Endif
return oQuery

function tieneDobleDetalle(nIdMov)
local oQuery, cQuery

cQuery := " select  * from cfe_comprobante_cab  c, cfe_comprobante_ext e"
cQuery += " where c.id_factura = e.id_factura "
cQuery += " and c.id_factura = "+str(nIdMov)+" " 

oQuery:= oServer:Query(  cQuery )
if oQuery:NetErr() 
  release all
endif

if oQuery:LastRec() > 0
  return .t.
endIf  
return .f.



*************************************************************
* Ejemplo:
*
* _url        := 'http://?url_del_ws/' && (endpoint)
* _ws         := '?nbre_ws'
* _url+=_ws
* _soapAction := 'SOAPAction: "http://?proveedor_efactura.com.uy/EFactura/?nbre_ws"'
*
*********************                                   && EJECUTA EL WS
FUNCTION fHttpExecute(_url,_soapaction,cxml,_ssl)
LOCAL _hcurl, curlErr
LOCAL aHeader, _cc:=""

// DEFAULT _ssl to .F.

aHeader := {}

AADD(aHeader,'Accept-Encoding: gzip,deflate')
AADD(aHeader,'Content-Type: text/xml;charset="UTF-8"')
AADD(aHeader,_soapaction)
AADD(aHeader,"Connection: Keep-Alive")
AADD(aHeader,"User-Agent: ERP")
AADD(aHeader,'Content-length: '+alltrim(str(len(cxml))))
AADD(aHeader,"Cache-Control: no-cache")
AADD(aHeader,"Pragma: no-cache")

_hcurl := curl_easy_init()

IF LOWER(RIGHT(_url,5)) == "https"
   _ssl = .T.
ENDIF

IF !EMPTY(_hcurl)

   curl_easy_setopt(_hcurl, HB_CURLOPT_HTTPHEADER,aHeader)
   curl_easy_setopt(_hcurl, HB_CURLOPT_URL, _url)
   curl_easy_setopt(_hcurl, HB_CURLOPT_DOWNLOAD )
   curl_easy_setopt(_hcurl, HB_CURLOPT_DL_BUFF_SETUP )
   curl_easy_setopt(_hcurl, HB_CURLOPT_POST, 1)
   curl_easy_setopt(_hcurl, HB_CURLOPT_POSTFIELDS, cxml)
   curl_easy_setopt(_hcurl, HB_CURLOPT_CONNECTTIMEOUT, 8)
   curl_easy_setopt(_hcurl, HB_CURLOPT_TIMEOUT,       60)
   curl_easy_setopt(_hcurl, HB_CURLOPT_SSL_VERIFYPEER, IIF(_ssl,1,0))
   curl_easy_setopt(_hcurl, HB_CURLOPT_SSL_VERIFYHOST, IIF(_ssl,1,0))


// VER PROGRESO PARA DEBUG
/*   CLS
   ?
   curl_easy_setopt(_hcurl, HB_CURLOPT_VERBOSE, .t. )
*/

	WHILE .T.
		curlErr := curl_easy_perform(_hcurl)
		IF curlErr=0
			_cc := curl_easy_dl_buff_get( _hcurl )
			EXIT
		ELSE
			IF ALERT("ERROR WS:; ;"+_url+"; ;"+curl_easy_strerror(curlErr)+"; ;No hay conexion...",{"Reintentar","Salir"},"R/W*+")#1
				EXIT
			ENDIF
		ENDIF
	ENDDO
ELSE
   ALERT("ERROR WS:; ;NO HAY handle")
ENDIF

curl_easy_cleanup(_hcurl)
IF !EMPTY(_hcurl)
   curl_global_cleanup( _hcurl )
ENDIF

?hb_gcAll()
RETURN _cc