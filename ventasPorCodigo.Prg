#include <hmg.ch>


procedure ventasPorCodigo()

load window ventasPorCodigo
ventasPorCodigo.center
ventasPorCodigo.activate

procedure  buscarArticuloVenta()
local nArticulo := ventasPorCodigo.text_1.value
if existeArticulo(nArticulo)
		  	ventasPorCodigo.text_2.value := descripcionArticulo(nArticulo)
		    cArticuloGlobal := ""
	  else
	    
	      busquedaGeneral('a',"","Repuestos",1)
	    
	       
		      if len(cArticuloGlobal) != 0
		      	ventasPorCodigo.text_1.value := cArticuloGlobal
		        ventasPorCodigo.text_2.value := descripcionArticulo(cArticuloGlobal)      
		        cArticuloGlobal := ""
		      endIf
	  endif
	
return

procedure traerVentasPorCodigo(cArticulo)
local oDocumentos := documentosPorArticulo(ventasPorCodigo.text_1.value)

ventasPorCodigo.grid_1.deleteAllItems
for i=1 to oDocumentos:lastrec()
	ventasPorCodigo.grid_1.additem({dtoc(oDocumentos:getrow(i):fieldget(1)),;
		oDocumentos:getrow(i):fieldget(2),;
		oDocumentos:getrow(i):fieldget(3),;
		oDocumentos:getrow(i):fieldget(4),;
		oDocumentos:getrow(i):fieldget(5),;
		oDocumentos:getrow(i):fieldget(6)})
next
