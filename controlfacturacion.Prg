#include <hmg.ch>
procedure controlFacturacion()

load window controlFacturacion
rellenoComboServicioControlFacturacion()
controlFacturacion.Center
controlFacturacion.Activate

return


procedure buscarListadoEmision()

do case
   case controlfacturacion.radioGroup_1.value = 2
    if existeSocio(controlfacturacion.text_1.value)
    	controlfacturacion.text_2.value := nombreSocio(controlfacturacion.text_1.value)
    	nSocioGlobal := 0
    else
    
	    abroBusSocios('s')
	    if nSocioGlobal != 0
	    	controlfacturacion.text_1.value := nSocioGlobal
		  	controlfacturacion.text_2.value := nombreSocio(nSocioGlobal)
	      nSocioGlobal := 0
	    endIf
	    
    endIf
  case controlfacturacion.radioGroup_1.value = 3
  	
  	if existeConvenio(controlfacturacion.text_1.value)
			controlfacturacion.text_2.value := nombreConvenio(controlfacturacion.text_1.value)
			nSocioGlobal := 0
  	
  	else
  		
	    busConvenioPagoCobradorSocios('v')
	    controlfacturacion.text_1.value := nSocioGlobal
			controlfacturacion.text_2.value := nombreConvenio(nSocioGlobal)
			nSocioGlobal := 0
		
		endIf
endCase 

return


procedure traeDetalleCuota()
return




procedure cambioSocioConvenioControl()

do case
  case controlfacturacion.radioGroup_1.value = 1
    controlfacturacion.text_1.value := 0
    controlfacturacion.text_2.value := ''
    controlfacturacion.button_1.enabled := .f.
    
  case controlfacturacion.radioGroup_1.value = 2
    controlfacturacion.text_1.value := 0
    controlfacturacion.text_2.value := ''
    controlfacturacion.button_1.enabled := .t.
    
  case controlfacturacion.radioGroup_1.value = 3
    controlfacturacion.text_1.value := 0
    controlfacturacion.text_2.value := ''
    controlfacturacion.button_1.enabled := .t.
  
endCase 

return

procedure cambioServicoControlFacturacion()
do case
  case controlfacturacion.radioGroup_2.value = 1
    
    
  case controlfacturacion.radioGroup_2.value = 2

end case

procedure rellenoComboServicioControlFacturacion()
local oQuery

cQuery := "Select descripcion from servicio where mensual = 1 order by 1 "
oQuery:= oServer:Query(  cQuery )
If oQuery:NetErr() 
  MsGInfo("Error executing Query "+cQuery+": "+oServer:Error() )
endIf

controlFacturacion.combo_1.deleteAllItems

For i := 1 To oQuery:LastRec()
  
  oRow := oQuery:GetRow(i)
  controlFacturacion.combo_1.addItem(alltrim(oRow:fieldGet(1)))
  oQuery:Skip(1) 

Next

return
procedure ordena(nOrden)

listopreEmision(nOrden)
    
procedure listoPreEmision(nOrden)
local nId_cuota, nId_socio, cNombreSocio, cDescripcionServicio, cAnioMes, nImporte
local cQuery := '' 
local oQuery
local nDiferencia := 0
local cDiferencia



cQuery := cQuery + " SELECT c.id_cuota , c.id_socio, c.id_servicio, c.anio_mes, sum(d.importe), s.referencia "
cQuery := cQuery + " from aux_cuota_cab c, aux_cuota_det d ,socio s"
cQuery := cQuery + " where c.id_cuota = d.id_cuota "
cQuery := cQuery + " and s.id_socio = c.id_socio "
iif(controlFacturacion.radioGroup_2.value =2, cQuery := cQuery + " and c.id_servicio = "+str(idServicio(controlFacturacion.combo_1.displayValue))+" ", )
cQuery := cQuery + " group by "+str(nOrden)+" "
cQuery := cQuery + " order by 6 "

oQuery := oServer:Query(cQuery )
    If oQuery:NetErr()												
      MsgInfo("SQL SELECT error: " + oQuery:Error())
    else  
			controlFacturacion.grid_1.deleteAllItems
			controlFacturacion.text_4.value := 0
			controlFacturacion.text_3.value := 0
	    For i := 1 To oQuery:LastRec()
	    	controlFacturacion.text_4.value :=  i
	      oRow := oQuery:GetRow(i)
	      
	      nId_socio := oRow:fieldGet(2)
	      nId_cuota := val(oRow:fieldGet(6))
	      cNombreSocio := nombreSocio(nId_socio)
	      cNombreConvenio := convenioSocio(nId_socio)
	      cDescripcionServicio := descripcionServicio(oRow:fieldGet(3))
	      cAnioMes := oRow:fieldGet(4)
	      nImporte := oRow:fieldGet(5)
	      nImporteAnterior := importeCuota(ultimaCuotaSocio(nId_socio))
	      if nImporte != nImporteAnterior
	      	nDiferencia ++
	      	cDiferencia :='*'
	      else
	      	cDiferencia :=''
	      endIf
	      controlFacturacion.text_3.value := controlFacturacion.text_3.value + nImporte
	      controlFacturacion.grid_1.addItem({nId_cuota, nId_socio, cNombreSocio,cNombreConvenio, cDescripcionServicio,cAnioMes,nImporte,nImporteAnterior,cDiferencia })
	      oQuery:Skip(1)
	    Next
	
	    oQuery:Destroy()
		Endif
		
controlFacturacion.text_5.value := nDiferencia
return
