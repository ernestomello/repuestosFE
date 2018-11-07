#include <hmg.ch>



procedure envioEstados()

load window envioEstados
envioEstados.datePicker_1.value := date() - 30
info_("Buscando Informacion de Clientes...")
muestroSaldosClientes()
envioEstados.center
envioEstados.activate

return


procedure muestroSaldosClientes()
local oClientes := clientes(1)
local nSaldoActual
local aGrid := {}

for i = 1 to oClientes:lastrec()
	nSaldoActual := saldoEntreFechasCliente(oClientes:getrow(i):fieldget(1),ctod("01/01/1980"),envioEstados.datePicker_2.value)
	if nSaldoActual > 0
		envioEstados.text_1.value := envioEstados.text_1.value + 1
			aadd(aGrid,{	oClientes:getrow(i):fieldget(1),oClientes:getrow(i):fieldget(2),nSaldoActual,'NO',dtos(fechaUltimoMovimientoCliente(oClientes:getrow(i):fieldget(1)))})
		// envioEstados.grid_1.additem({oClientes:getrow(i):fieldget(1),oClientes:getrow(i):fieldget(2),nSaldoActual,'NO',dtoc(fechaUltimoMovimientoCliente(i))})
	endif
next
waitwindow()
asort(aGrid,,,{|x,y|x[5] > y[5]})

nLargoArray := len(aGrid)
for i= 1 to nLargoArray 

	envioEstados.grid_1.additem({agrid[i][1],agrid[i][2],agrid[i][3],agrid[i][4],stod(agrid[i][5])})

next


procedure emiteListados()
local nCantidad := len(envioEstados.grid_1.value)


for i= 1 to nCantidad
	if envioEstados.grid_1.cell( envioEstados.grid_1.value[i],4) =='SI'
		//msginfo(str(envioEstados.grid_1.cell(envioEstados.grid_1.value [i] ,1)))
		imprimeEstadoCuentaCliente(envioEstados.grid_1.cell(envioEstados.grid_1.value [i] ,1),envioEstados.datePicker_1.value,envioEstados.datePicker_2.value,2) 
	endif
	WAIT CLEAR
next

procedure marcoEmitido()
local nCantidad := len(envioEstados.grid_1.value)

for i = 1 to envioEstados.grid_1.itemcount           
	envioEstados.grid_1.cell(i,4) :='NO'
next

for i = 1 to nCantidad

	envioEstados.grid_1.cell(envioEstados.grid_1.value[i],4):= 'SI'
next