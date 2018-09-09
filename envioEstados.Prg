#include <hmg.ch>



procedure envioEstados()

load window envioEstados
envioEstados.datePicker_1.value := date() - 30
waitwindow('Buscando información',.t.)
muestroSaldosClientes()
envioEstados.center
envioEstados.activate

return


procedure muestroSaldosClientes()
local oClientes := clientes(1)
local nSaldoActual
for i = 1 to oClientes:lastrec()
	nSaldoActual := saldoEntreFechasCliente(oClientes:getrow(i):fieldget(1),ctod("01/01/1980"),envioEstados.datePicker_2.value)
	envioEstados.grid_1.additem({oClientes:getrow(i):fieldget(1),oClientes:getrow(i):fieldget(2),nSaldoActual,'NO'})
next
waitwindow()


procedure emiteListados()
local nCantidad := len(envioEstados.grid_1.value)


for i= 1 to nCantidad
	if envioEstados.grid_1.cell( envioEstados.grid_1.value[i],4) =='SI'
		//msginfo(str(envioEstados.grid_1.cell(envioEstados.grid_1.value [i] ,1)))
		imprimeEstadoCuentaCliente(envioEstados.grid_1.cell(envioEstados.grid_1.value [i] ,1),envioEstados.datePicker_1.value,envioEstados.datePicker_2.value,3)
	endif

next

procedure marcoEmitido()
local nCantidad := len(envioEstados.grid_1.value)

for i = 1 to envioEstados.grid_1.itemcount           
	envioEstados.grid_1.cell(i,4) :='NO'
next

for i = 1 to nCantidad

	envioEstados.grid_1.cell(envioEstados.grid_1.value[i],4):= 'SI'
next