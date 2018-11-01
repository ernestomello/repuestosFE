#include <hmg.ch>
#include "hbcurl.ch"
#include "common.ch"
#include "fileio.ch"
#include "hbmxml.ch"
#include "simpleio.ch"




function facturaElectronica(nIdMov,bImprime,esCorreccion)
local oIdMov := oDocumentoCFE(nIdMov)
local aCliente := iif(len(alltrim(oIdMov:getRow(1):fieldget(11)))=0, datoCliente(oIdMov:getRow(1):fieldGet(7)),oIdMov:getRow(1):fieldget(11))
local cDirMov := substr(dtos(oIdMov:getRow(1):fieldGet(6)),1,4)+"\"+substr(dtos(oIdMov:getRow(1):fieldGet(6)),5,2)+"\"
local cArchivo := "envioCFE.txt"
local nTipoCFE := oIdMov:getRow(1):fieldGet(4)
local pArchivo 
local  cExeFile := "C:\Archivos de programa\SumatraPDF\SumatraPDF.exe"
local aLineasL := {}
// if !creaDirectorio(cDirFE,cDirMov)
	// return .f.
	// msginfo(str(makedir(cDirFE+cDirMov)))
// endif

pArchivo := fcreate(cArchivo,0)

if !linea1(pArchivo,oIdMov)
	return .f.
endif
if nTipoCFE = 101 .or. nTipoCFE = 102 
fwrite(parchivo,"<nsAd:eTck>"+chr(13)+chr(10))
else
fwrite(parchivo,"<nsAd:eFact>"+chr(13)+chr(10))
endIf
fwrite(parchivo," <nsAd:Encabezado>"+chr(13)+chr(10))


if !linea2(pArchivo,oIdMov)
	return .f.
endif

if !linea3(pArchivo,oIdMov)
	return .f.
endif
// msgInfo (alltrim(aCliente)+ str(oIdMov:getRow(1):fieldget(7)))
if len(alltrim(aCliente)) != 0 //.or. oIdMov:getRow(1):fieldget(7) != 0
	if !linea4(pArchivo,aCliente)
		return .f.
	endif
endIf

if !linea5(pArchivo,nIdMov,nTipoCFE)
	return .f.
endif
fwrite(parchivo," </nsAd:Encabezado>"+chr(13)+chr(10))
fwrite(parchivo,"<nsAd:Detalle>"+chr(13)+chr(10))

if !linea6(pArchivo,nIdMov,nTipoCFE)
	return .f.
endif
fwrite(parchivo,"</nsAd:Detalle>"+chr(13)+chr(10))
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
// fwrite(parchivo,"<nsAd:DscRcgGlobal>"+chr(13))
// fwrite(parchivo,"</nsAd:DscRcgGlobal>"+chr(13))
fwrite(parchivo,"<nsAd:CAEData>"+chr(13)+chr(10))
fwrite(parchivo,"<nsAd:CAE_ID>1</nsAd:CAE_ID>"+chr(13)+chr(10))
fwrite(parchivo,"<nsAd:DNro>1</nsAd:DNro>"+chr(13)+chr(10))
fwrite(parchivo,"<nsAd:HNro>1</nsAd:HNro>"+chr(13)+chr(10))
fwrite(parchivo,"<nsAd:FecVenc></nsAd:FecVenc>"+chr(13)+chr(10))
fwrite(parchivo,"</nsAd:CAEData>"+chr(13)+chr(10))

if nTipoCFE = 101 .or. nTipoCFE = 102 
	fwrite(parchivo,"</nsAd:eTck>"+chr(13)+chr(10))
else
	fwrite(parchivo,"</nsAd:eFact>"+chr(13)+chr(10))
endIf
	fwrite(parchivo,"</nsAd:CFE>"+chr(13)+chr(10))
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
fwrite(parchivo,"</nsAdenda:CFE_Adenda>"+chr(13)+chr(10))
fclose(parchivo)

if file(cArchivo)
xArchivo := hb_memoRead(cArchivo)

cxml :='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:cxml="http://tempuri.org/">'+chr(13)+chr(10)
cxml +="<soapenv:Header/>"+chr(13)+chr(10)
cxml +="<soapenv:Body>"+chr(13)+chr(10)
cxml +="<cxml:EnvioCFE>"+chr(13)+chr(10)
cxml +="<cxml:nomusuario>erp2</cxml:nomusuario>"+chr(13)+chr(10)
cxml +="<cxml:clave>erp2</cxml:clave>"+chr(13)+chr(10)
cxml +="<cxml:tenant>morale</cxml:tenant>"+chr(13)+chr(10)
cxml +="<cxml:cliente></cxml:cliente>"+chr(13)+chr(10)
cxml +="<cxml:cfexml><![CDATA["+xArchivo+"]]></cxml:cfexml>"+chr(13)+chr(10)
cxml +="<cxml:referenciaERP>"+str(nIdMov)+"</cxml:referenciaERP>"+chr(13)+chr(10)
//cxml +="<cxml:referenciaERP2></cxml:referenciaERP2>"+chr(13)+chr(10)
cxml +="<cxml:devolverQR>0</cxml:devolverQR>"+chr(13)+chr(10)
cxml +="<cxml:sizeQR>10</cxml:sizeQR>"+chr(13)+chr(10)
cxml +="<cxml:impprime>0</cxml:impprime>"+chr(13)+chr(10)
cxml +="<cxml:template>Uso General</cxml:template>"+chr(13)+chr(10)
cxml +="<cxml:devolverXML>0</cxml:devolverXML>"+chr(13)+chr(10)
// cxml +="<cxml:erpPideValicacion>valor2</cxml:erpPideValicacion>"+chr(13)+chr(10)
cxml +="<cxml:version>1.34.7</cxml:version>"+chr(13)+chr(10)
cxml +="</cxml:EnvioCFE>"+chr(13)+chr(10)
cxml +="</soapenv:Body>"+chr(13)+chr(10)
cxml +="</soapenv:Envelope>"+chr(13)+chr(10)


hb_memowrit("aalgo.txt",cxml)
 cRespuesta := fHttpExecute(nSOAPSW,'SOAPAction:"http://tempuri.org/ISICFEEmisor/EnvioCFE"',cxml,.f.)

 // msgInfo (cValTag(cRespuesta,"a:Codigo"))
 hb_memowrit("soapanswer.xml",cRespuesta)

  // msgInfo(cRespuesta)
 
	aLineasL:= cValTag(cRespuesta,"a:Descripcion")+"|"+cValTag(cRespuesta,"a:Serie")+"|"+cValTag(cRespuesta,"a:Numero")+"|"+cValTag(cRespuesta,"a:Hash")
	cCodigoRespuesta := val(cValTag(cRespuesta,"a:Codigo"))
	//codigo = 0 sin errore, codigo 100009 que ya fue emitido, así que igual sirve para grabar los datos faltantes.
	if cCodigoRespuesta = 0 .or. cCodigoRespuesta = 100009
		
		if !actualizaFE(nIdMov, aLineasL)
			return .f.
		endif
	else
		msgInfo(" Devolucion de Errores"+chr(13)+hb_atokens(aLineasL,"|")[1])
		return .f.
	endif
else
	return .f.
//run(cExeFile+" -print-to-default -exit-on-print "+cArchivo+".pdf")

endif

return .t.

function cValTag(cXml,cTag)
local cValue:=''

posicion:= hb_ati(cTag,cxml)+ len(cTag+">")
posicionF:= hb_ati("</"+cTag,cxml)
cValue:= substr(cxml,posicion,posicionF-posicion)
return cValue

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
local cfecha := dtos(date())
cfecha := substr(cfecha,1,4)+"-"+substr(cfecha,5,2)+"-"+substr(cfecha,7,2)

cLinea :='<?xml version="1.0" encoding="UTF-8" ?>'+chr(13)+chr(10)
cLinea +='<nsAdenda:CFE_Adenda xmlns:nsAdenda="http://cfe.dgi.gub.uy">'+chr(13)+chr(10)
cLinea +='<nsAd:CFE version="1.0" xmlns:nsAd="http://cfe.dgi.gub.uy">'+chr(13)+chr(10)

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
local cLinea := "<nsAd:IdDoc>"+chr(13)+chr(10)
cLinea += "<nsAd:TipoCFE>"+str(cTipoCFE)+"</nsAd:TipoCFE>"+chr(13)+chr(10)
// cLinea += "<nsAd:TipoCFE>111</nsAd:TipoCFE>"+chr(13)
cLinea += "<nsAd:Serie></nsAd:Serie>"+chr(13)+chr(10)
cLinea += "<nsAd:Nro></nsAd:Nro>"+chr(13)+chr(10)
cLinea += "<nsAd:FchEmis>"+substr(cFechaEmision,1,4)+"-"+substr(cFechaEmision,5,2)+"-"+substr(cFechaEmision,7,2)+"</nsAd:FchEmis>"+chr(13)+chr(10)
cLinea += "<nsAd:MntBruto>1</nsAd:MntBruto>"+chr(13)+chr(10)
cLinea += "<nsAd:FmaPago>"+str(cFormaPago)+"</nsAd:FmaPago>"+chr(13)+chr(10)
cLinea += "</nsAd:IdDoc>"+chr(13)+chr(10)
// if cTipoCFE != 182+chr(13)
// cLinea := "2|"+str(cTipoCFE)+"|"+cSerie+"|"+str(cNumero)+"|"+substr(cFechaEmision,1,4)+"-"+substr(cFechaEmision,5,2)+"-"+substr(cFechaEmision,7,2)+"|1|"+str(cFormaPago)+"|"+substr(cFechaVenc,1,4)+"-"+substr(cFechaVenc,5,2)+"-"+substr(cFechaVenc,7,2)+chr(13)+chr(10)
// else
// cLinea := "2|"+str(cTipoCFE)+"|"+cSerie+"|"+str(cNumero)+"|"+substr(cFechaEmision,1,4)+"-"+substr(cFechaEmision,5,2)+"-"+substr(cFechaEmision,7,2)+"| |"+str(cFormaPago)+"|"+chr(13)+chr(10)
// endif
//msginfo(cLinea)

fwrite(parchivo,clinea)
return .t.

function linea3(pArchivo,oIdMov)
local cLinea := "<nsAd:Emisor>"+chr(13)+chr(10)

cLinea += "<nsAd:RUCEmisor>"+cRutEmisior+"</nsAd:RUCEmisor>"+chr(13)+chr(10)
cLinea +="<nsAd:RznSoc>"+cEspeciales(cRazonEmisior)+"</nsAd:RznSoc>"+chr(13)+chr(10)
cLinea +="<nsAd:NomComercial>"+cEspeciales(cNombreEmpresa)+"</nsAd:NomComercial>"+chr(13)+chr(10)
cLinea +="<nsAd:EmiSucursal>Sucursal principal</nsAd:EmiSucursal>"+chr(13)+chr(10)
cLinea +="<nsAd:CdgDGISucur>"+cDGIEmisior+"</nsAd:CdgDGISucur>"+chr(13)+chr(10)
cLinea +="<nsAd:DomFiscal>"+cDirEmisior+"</nsAd:DomFiscal>"+chr(13)+chr(10)
cLinea +="<nsAd:Ciudad>"+cCiuEmisior+"</nsAd:Ciudad>"+chr(13)+chr(10)
cLinea +="<nsAd:Departamento>"+cDepEmisior+"</nsAd:Departamento>"+chr(13)+chr(10)
cLinea +="</nsAd:Emisor>"+chr(13)+chr(10)
        

fwrite(parchivo,clinea)
return .t.

function linea4(pArchivo,aSocio)
local cTipoDocR := hb_atokens(aSocio,"|")[1]
local cCodPaisR := "UY" //modificar la base de Empresa o Persona
local cDocR :=  hb_atokens(aSocio,"|")[2]
local cRazonR := hb_atokens(aSocio,"|")[3]
local cDirR := alltrim(hb_atokens(aSocio,"|")[4])
local cCiuR := alltrim(hb_atokens(aSocio,"|")[5])//"PAYSANDU"//oIdMov:getRow(1):fieldGet(1)
local cDepR := "PAYSANDU"//oIdMov:getRow(1):fieldGet(1)
local cCompraId := ""//oIdMov:getRow(1):fieldGet(1)
local cPaisR := "URUGUAY"//oIdMov:getRow(1):fieldGet(1)
local cCliente :=alltrim(hb_atokens(aSocio,"|")[6])
local cLinea :=""
// msgInfo(aSocio)
if alltrim(cTipoDocR) == '3'
	// if formatoCedula(hb_atokens(aSocio,"|")[2])
		// cDocR := hb_atokens(aSocio,"|")[2]
	// else
		// cDocR := '0'
	// endif
endif
cLinea +="<nsAd:Receptor>"+chr(13)+chr(10)
cLinea +="<nsAd:TipoDocRecep>"+cTipoDocR+"</nsAd:TipoDocRecep>"+chr(13)+chr(10)
// cLinea +="<nsAd:TipoDocRecep>2</nsAd:TipoDocRecep>"+chr(13)
cLinea +="<nsAd:CodPaisRecep>"+cCodPaisR+"</nsAd:CodPaisRecep>"+chr(13)+chr(10)
cLinea +="<nsAd:DocRecep>"+cDocR+"</nsAd:DocRecep>"+chr(13)+chr(10)
// cLinea +="<nsAd:DocRecep>120130820017</nsAd:DocRecep>"+chr(13)
cLinea +="<nsAd:RznSocRecep>"+cCliente+" - "+cEspeciales(cRazonR)+"</nsAd:RznSocRecep>"+chr(13)+chr(10)
cLinea +="<nsAd:DirRecep>"+cEspeciales(cDirR)+"</nsAd:DirRecep>"+chr(13)+chr(10)
cLinea +="<nsAd:CiudadRecep>"+cCiuR+"</nsAd:CiudadRecep>"+chr(13)+chr(10)
cLinea +="<nsAd:DeptoRecep>"+cDepR+"</nsAd:DeptoRecep>"+chr(13)+chr(10)
cLinea +="<nsAd:PaisRecep>"+cPaisR+"</nsAd:PaisRecep>"+chr(13)+chr(10)
cLinea +="</nsAd:Receptor>"+chr(13)+chr(10)

// cLinea := "4|"+cTipoDocR+"|"+cCodPaisR+"|"+cDocR+"|"+cRazonR+"|"+cDirR+"|"+cCiuR+"|"+cDepR+"|"+cCompraId+"|"+cPaisR+chr(13)+chr(10)

//msginfo(cLinea)
fwrite(parchivo,clinea)
return .t.

function linea5(pArchivo,nIdMov,nTipoCFE)
Local oDetalle //:= oDetalleFactura(nIdMov)//los detalles de cada factura Electronica**CAmbiar por otro que traiga los totales por tipo ind de facturacion
local cMoneda := "UYU"//(oIdMov:getRow(1):fieldGet(1)
local nIvaBas :=PARAMETROini("FEIVABASE","N")
local nIvaMin :=PARAMETROini("FEIVAMIN","N")
local cLinea := "<nsAd:Totales>"+chr(13)+chr(10)
local nMntNoGrv:=0.00
local nMntIvaBasico:=0.00
local nMntIvaMinimo:=0.00
local nIvaBasico:=0.00
local nIvaMinimo:=0.00
local nMntTotalMinimo:= 0.00
local nMntTotalBasico:= 0.00
local nMntTotalNoGrv:= 0.00
local nMntTotal:= 0.00
local nLineas := 0
local nGlobal := refGlobal(nIdMov)
// msgInfo("Referencia Global: "+nGlobal)

if nTipoCFE = 102 .or. nTipoCFE = 112
if nGlobal == "1" 
		oDetalle := oDetalleGlobalDevolucion(nIdMov)
	else
		oDetalle := oDetalleFacturaDevolucion(nIdMov)
	endif
else
	oDetalle := oDetalleFactura(nIdMov)
endif
nLineas := oDetalle:lastRec()
for i = 1 to oDetalle:lastRec()
	do case
		case oDetalle:getRow(i):fieldGet(5) = 0
			nMntNoGrv += round(oDetalle:getRow(i):fieldGet(4),0) * oDetalle:getRow(i):fieldGet(3)
			nMntTotalNoGrv += round(oDetalle:getRow(i):fieldGet(4),0) * oDetalle:getRow(i):fieldGet(3)
		case oDetalle:getRow(i):fieldGet(5) = 10
			// nMntIvaMinimo += round(oDetalle:getRow(i):fieldGet(4),0) * oDetalle:getRow(i):fieldGet(3)
			// nIvaMinimo += round(oDetalle:getRow(i):fieldGet(4) * (oDetalle:getRow(i):fieldGet(5) / 100),0) * oDetalle:getRow(i):fieldGet(3)
			nMntTotalMinimo += round(oDetalle:getRow(i):fieldGet(4) * iif( nGlobal == "1",1, (1+(oDetalle:getRow(i):fieldGet(5) / 100))),0) * oDetalle:getRow(i):fieldGet(3)
		case oDetalle:getRow(i):fieldGet(5) = 22
			// nMntIvaBasico += round(oDetalle:getRow(i):fieldGet(4) * oDetalle:getRow(i):fieldGet(3),2)
			// nIvaBasico +=  round(oDetalle:getRow(i):fieldGet(4)* (oDetalle:getRow(i):fieldGet(5) / 100),2) * oDetalle:getRow(i):fieldGet(3)
			nMntTotalBasico += round(oDetalle:getRow(i):fieldGet(4) *  iif( nGlobal == "1",1, (1+(oDetalle:getRow(i):fieldGet(5) / 100))) * oDetalle:getRow(i):fieldGet(3),0)
	endcase
	
next
nMntTotal := round(nMntTotalBasico,0) + round(nMntTotalMinimo,0)+ round(nMntTotalNoGrv,0)
nMntIvaBasico := round(round(nMntTotalBasico,0)/ (1+(nIvaBas/100)),2)
nIvaBasico := round(nMntIvaBasico * (nIvaBas /100),2)
nMntIvaMinimo := round(round(nMntTotalMinimo,0)/(1+(nIvaMin/100)),2)
nIvaMinimo := round(nMntIvaMinimo * (nIvaMin /100),2)
cLinea +="<nsAd:TpoMoneda>UYU</nsAd:TpoMoneda>"+chr(13)
cLinea +="<nsAd:MntNoGrv>"+alltrim(str(nMntNoGrv))+"</nsAd:MntNoGrv>"+chr(13)+chr(10)
cLinea +="<nsAd:MntNetoIvaTasaMin>"+alltrim(str(nMntIvaMinimo))+"</nsAd:MntNetoIvaTasaMin>"+chr(13)+chr(10)
cLinea +="<nsAd:MntNetoIVATasaBasica>"+alltrim(str(nMntIvaBasico))+"</nsAd:MntNetoIVATasaBasica>"+chr(13)+chr(10)
cLinea +="<nsAd:IVATasaMin>"+alltrim(str(nIvaMin))+"</nsAd:IVATasaMin>"+chr(13)+chr(10)
cLinea +="<nsAd:IVATasaBasica>"+alltrim(str(nIvaBas))+"</nsAd:IVATasaBasica>"+chr(13)+chr(10)
cLinea +="<nsAd:MntIVATasaMin>"+alltrim(str(nIvaMinimo))+"</nsAd:MntIVATasaMin>"+chr(13)+chr(10)
cLinea +="<nsAd:MntIVATasaBasica>"+alltrim(str(nIvaBasico))+"</nsAd:MntIVATasaBasica>"+chr(13)+chr(10)
cLinea +="<nsAd:MntTotal>"+alltrim(str(nMntTotal))+"</nsAd:MntTotal>"+chr(13)+chr(10)
cLinea +="<nsAd:CantLinDet>"+alltrim(str(nLineas))+"</nsAd:CantLinDet>"+chr(13)+chr(10)
cLinea +="<nsAd:MontoNF>0.0</nsAd:MontoNF>"+chr(13)+chr(10)
cLinea +="<nsAd:MntPagar>"+alltrim(str(nMntTotal))+"</nsAd:MntPagar>"+chr(13)+chr(10)
cLinea +="</nsAd:Totales>"+chr(13)+chr(10)


// "5|"+cMoneda+"||||"+cIvaMin+"|"+cIvaBas+"||||||"+chr(13)+chr(10)
//msginfo(cLinea)
fwrite(parchivo,clinea)
return .t.


function linea6(pArchivo,nIdMov,nTipoCFE)
Local oDetalle//:= oDetalleFactura(nIdMov)//los detalles de cada factura Electronica
local cLinea := "",cCuota := "", cCant := "", cUnidad := "", cPrecUnit := 0.00
local cIndica := "", cDescPor :="",cDescMon := "",cRecPor := "", cRecMon := ""
local cMontoItem := "0",cDescExt := "",cDescArt:= ""
local nTotalLineas := 0
local nGlobal := refGlobal(nIdMov)
local j
// msgInfo("Referencia Global: "+nGlobal)
	// " select d.item,d.codigo_barra, d.cantidad,d.precio_unitario,d.cfe_ind_fact,d.descripcion,ca.tipoCFE "
if nTipoCFE = 102 .or. nTipoCFE = 112
	if nGlobal == "1" 
		oDetalle := oDetalleGlobalDevolucion(nIdMov)
	else
		oDetalle := oDetalleFacturaDevolucion(nIdMov)
	endif
else
	oDetalle := oDetalleFactura(nIdMov)
endif

for j := 1 to oDetalle:lastRec()
		cDescArt:= cEspeciales(alltrim(oDetalle:getRow(j):fieldGet(2))+"-"+alltrim(oDetalle:getRow(j):fieldGet(6)))
		
		
		
		cCant := oDetalle:getRow(j):fieldGet(3)
		cUnidad := "UN"
		cIndica := cfeIndFacturacion(oDetalle:getRow(j):fieldGet(5))
		if nGlobal == "1" 
			cPrecUnit := oDetalle:getRow(j):fieldGet(4)
			nTotItem := oDetalle:getRow(j):fieldGet(4)
			
		else
			cPrecUnit :=  round(oDetalle:getRow(j):fieldGet(4) * (1+(oDetalle:getRow(j):fieldGet(5) / 100)),2)
			nTotItem :=round(cPrecUnit * cCant,0)
			cPrecUnit := nTotItem / cCant
		endif
		cLinea := "<nsAd:Item>"+chr(13)+chr(10)
        cLinea += "<nsAd:NroLinDet>"+alltrim(str(j))+"</nsAd:NroLinDet>"+chr(13)+chr(10)
        cLinea += "<nsAd:IndFact>"+str(cIndica)+"</nsAd:IndFact>"+chr(13)+chr(10)
        cLinea += "<nsAd:NomItem>"+cDescArt+"</nsAd:NomItem>"+chr(13)+chr(10)
        cLinea += "<nsAd:Cantidad>"+str(cCant)+"</nsAd:Cantidad>"+chr(13)+chr(10)
        cLinea += "<nsAd:UniMed>"+cUnidad+"</nsAd:UniMed>"+chr(13)+chr(10)
        cLinea += "<nsAd:PrecioUnitario>"+alltrim(str(cPrecUnit))+"</nsAd:PrecioUnitario>"+chr(13)+chr(10)
        cLinea += "<nsAd:MontoItem>"+alltrim(str(nTotItem))+"</nsAd:MontoItem>"+chr(13)+chr(10)
        cLinea += "</nsAd:Item>"+chr(13)+chr(10)
		
		fwrite(parchivo,cLinea)
		
next

return .t.

function linea7(pArchivo)
local cLinea := "7|||||"+chr(13)+chr(10)

fwrite(parchivo,clinea)
return .t.

function linea8(pArchivo,nIdMov)
local cLinea := "<nsAd:Referencia>"+chr(13)+chr(10)
local oNotaCredDeb:= oNotaCreditoDebito(nIdMov)
local i 

	for i := 1 to oNotaCredDeb:lastRec()
	
		cTipoCFE := oNotaCredDeb:getRow(i):fieldGet(4)
		cSerie := oNotaCredDeb:getRow(i):fieldGet(5)
		cNumero := oNotaCredDeb:getRow(i):fieldGet(6)
		cRazon := oNotaCredDeb:getRow(i):fieldGet(8)
		cFecha := dtos(oNotaCredDeb:getRow(i):fieldGet(7))
		cIndGlobal := oNotaCredDeb:getRow(i):fieldGet(3)
		cLinea += "<nsAd:Referencia>"+chr(13)+chr(10)
		cLinea += "<nsAd:NroLinRef>"+str(i)+"</nsAd:NroLinRef>"+chr(13)+chr(10)
		iif(cIndGlobal == "1",cLinea += "<nsAd:IndGlobal>"+cIndGlobal+"</nsAd:IndGlobal>"+chr(13)+chr(10),)
		cLinea += "<nsAd:TpoDocRef>"+str(cTipoCFE)+"</nsAd:TpoDocRef>"+chr(13)+chr(10)
		cLinea += "<nsAd:Serie>"+cSerie+"</nsAd:Serie>"+chr(13)+chr(10)
		cLinea += "<nsAd:NroCFERef>"+str(cNumero)+"</nsAd:NroCFERef>"+chr(13)+chr(10)
		iif(cIndGlobal == "1",cLinea += "<nsAd:RazonRef>Dto Global</nsAd:RazonRef>"+chr(13)+chr(10),)
		cLinea += "<nsAd:FechaCFEref>"+substr(cFecha,1,4)+"-"+substr(cFecha,5,2)+"-"+substr(cFecha,7,2)+"</nsAd:FechaCFEref>"+chr(13)+chr(10)
		cLinea += "</nsAd:Referencia>"+chr(13)+chr(10)
	next
	 cLinea += "</nsAd:Referencia>"+chr(13)+chr(10)
	 fwrite(parchivo,clinea)
return .t.


function linea10(pArchivo,oIdMov)
local cAdenda := cEspeciales(oIdMov:getRow(1):fieldGet(15))
local nFormaPago := oIdMov:getRow(1):fieldGet(13)
local nTipoDocumento := oIdMov:getRow(1):fieldGet(4)
local cLinea := ""
if nFormaPago = 2 .and. (nTipoDocumento = 111 .or. nTipoDocumento = 101)
cAdenda +="&lt;br&gt;"+cEspeciales(mensaje1Documento(nTipoDocumento))+"&lt;br&gt;"+cEspeciales(mensaje2Documento(nTipoDocumento))+"&lt;br&gt;"+cEspeciales(mensaje3Documento(nTipoDocumento))
endif
cAdenda += "&lt;br&gt;"+"Ref: "+str(oIdMov:getRow(1):fieldGet(1))
cAdenda += "&lt;br&gt;"+"Cliente: "+str(oIdMov:getRow(1):fieldGet(7))
cLinea := "<nsAdenda:Adenda>"+cAdenda+"</nsAdenda:Adenda>"+chr(13)
// "10|"+cAdenda//+chr(13)+chr(10)

fwrite(parchivo,cLinea)
return .t.

function linea11(pArchivo)
local cLinea := "11|1"+chr(13)+chr(10)
fwrite(parchivo,clinea)
return .t.

function linea12(pArchivo)
local cLinea := "12|||||"+chr(13)+chr(10)
fwrite(parchivo,clinea)
return .t.

function cEspeciales(cCadena)


		cCadena := strtran(cCadena,"&","&amp;")
		cCadena := strtran(cCadena,"Ñ","Ã‘")
		cCadena := strtran(cCadena,">","&gt;")
		cCadena := strtran(cCadena,"<","&lt;")		
		cCadena := strtran(cCadena,'"',"&quot;")
		cCadena := strtran(cCadena,"'","&apos;")
		 //"
return cCadena

function oDetalleFactura(nIdMov)
local oQuery
local cQuery

cQuery := " select d.item,d.codigo_barra, d.cantidad,d.precio_unitario,d.cfe_ind_fact,a.descripcion,ca.tipoCFE "
cQuery += " from  cfe_comprobante_cab ca, cfe_comprobante_det d , articulo a"
cQuery += " where  ca.id_factura = "+str(nIdMov)+" and d.id_factura = ca.id_factura and a.codigo_barra = d.codigo_barra"
oQuery := oServer:Query(cQuery )
    If oQuery:NetErr()												
      MsgInfo("SQL SELECT error: "+cQuery+"=" + oQuery:Error())
    Endif
return oQuery

function refGlobal(nIdMov)
local oQuery
local cQuery

cQuery := " select r.ind_global "
cQuery += " from   cfe_referencias_det r"
cQuery += " where  r.id_factura = "+str(nIdMov)+"  "
oQuery := oServer:Query(cQuery )
    If oQuery:NetErr()												
      MsgInfo("SQL SELECT error: "+cQuery+"=" + oQuery:Error())
    Endif
return oQuery:getRow(1):fieldGet(1)

function oDetalleFacturaDevolucion(nIdMov)
local oQuery
local cQuery

cQuery := " select d.item,d.codigo_barra, d.cantidad,d.precio_unitario,d.cfe_ind_fact,a.descripcion,ca.tipoCFE "
cQuery += " from  cfe_comprobante_cab ca, cfe_comprobante_det d , articulo a, cfe_referencias_det r"
cQuery += " where  ca.id_factura = "+str(nIdMov)+" and r.id_factura = ca.id_factura "
cQuery += " and r.id_factura_ref = d.id_factura and a.codigo_barra = d.codigo_barra "
oQuery := oServer:Query(cQuery )
    If oQuery:NetErr()												
      MsgInfo("SQL SELECT error: "+cQuery+"=" + oQuery:Error())
    Endif
return oQuery

function oDetalleGlobalDevolucion(nIdMov)
local oQuery
local cQuery

cQuery := " select 1,'2', 1,r.importe_aplicado, 22,concat( 'Dto Global en ',t.descripcion, ' ', r.serieCFE, '-',r.numeroCFE) "
cQuery += " from  cfe_referencias_det r ,cfe_tipos t"
cQuery += " where  r.id_factura = "+str(nIdMov)+" and r.tipoCFE= t.id_cfe "
oQuery := oServer:Query(cQuery )
    If oQuery:NetErr()												
      MsgInfo("SQL SELECT error: "+cQuery+"=" + oQuery:Error())
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

cQuery := "select id_indicador  from cfe_ind_facturacion where valor= "+str(nidIndice)+"  "
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
LOCAL aHeader, cc1:=""

aHeader := {}

//AADD(aHeader,'Accept-Encoding: gzip,deflate')
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
	curl_easy_setopt(_hcurl, HB_CURLOPT_TIMEOUT,       40)
	curl_easy_setopt(_hcurl, HB_CURLOPT_SSL_VERIFYPEER, IIF(_ssl,1,0))
	curl_easy_setopt(_hcurl, HB_CURLOPT_SSL_VERIFYHOST, IIF(_ssl,1,0))

	curlErr := curl_easy_perform(_hcurl)
	if empty(curlErr)
	/* almacena la respuesta en la varaiable cc1 */
		cc1 := curl_easy_dl_buff_get( _hcurl )
	else
		msgInfo( curl_easy_strerror(curlErr))
	endif

else
	msgInfo("El servidor no responde...Reintente!!!")
endif

curl_easy_cleanup(_hcurl)

if !empty(_hcurl)
	/* Clean-up libcurl */
	curl_global_cleanup( _hcurl )
// else
	// msgInfo("Error vacio")
endif
// msginfo(str(len(cc1)))
// if empty(cc1)
	// msgInfo("Error no devolvio nada")
// endif

return cc1


*****************************************
Function info_(cMessage, lWait)
Local nTimeIni := hb_MilliSeconds()
Default lWait := .F.
 
Wait Window cMessage NoWait
IF lWait
	WHILE( ( hb_MilliSeconds() - nTimeIni ) < 3 * 1000 )
		DO EVENTS
		hb_releaseCPU()
	ENDDO
ENDIF
RETURN Nil

*********************************
FUNCTION isInternet( nTimeOut )
Local aAddr:=hb_socketResolveINetAddr( "www.google.com" , 80 )
Local socket:=hb_socketOpen()
Local lIsNet
Default nTimeOut := 2000
lIsNet := !EMPTY( aAddr ) .AND. hb_socketConnect( socket , aAddr, nTimeOut )
hb_socketClose( socket )
RETURN lIsNet