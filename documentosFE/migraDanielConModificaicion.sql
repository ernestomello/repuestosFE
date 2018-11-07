# pasaje de cabezal factura_cliente
insert into comercio_fe.cfe_comprobante_cab 
select numero_factura, "",0,
if(tipo_documento = 'F',111,if(tipo_documento = 'C',101,if(tipo_documento = 'D', 112,if(tipo_documento = 'P', 81,if(tipo_documento = 'Q',91,0))))),
id_caja,fecha,id_cliente,id_usuario,importe,saldo,descripcion,fecha_realizado,
if(tipo_documento = 'F',2,if(tipo_documento = 'C',1, 0)),"","" 
from comercio_fe.factura_cliente_cab 
where anulado ='N'

## pasaje detalle factura_cliente
insert into comercio_fe.cfe_comprobante_det 
select d.numero_factura, d.item,d.codigo_barra,d.cantidad,d.precio_unitario,0,d.importe,3,d.descuento
from comercio_fe.factura_cliente_det d, comercio_fe.factura_cliente_cab c
where c.numero_factura = d.numero_factura
and c.anulado ='N'

##pasaje de las referencias que hay en factura_cliente
insert into comercio_fe.cfe_referencias_det 
select fn.numero_notacredito,1,"1",c.tipoCFE,c.serieCFE,c.numeroCFE, c.fecha,"",fn.numero_factura,ca.importe
from comercio_fe.factura_notacredito fn, comercio_fe.cfe_comprobante_cab c, comercio_fe.cfe_comprobante_cab ca
where c.id_factura = fn.numero_factura
and ca.id_factura = fn.numero_notacredito

# pasaje de cabezal recibo_cliente
insert into comercio_fe.cfe_comprobante_cab 
select id_recibo, "",0,
if(tipo_documento = 'R',98,112),
id_caja,fecha,id_cliente,1,importe,0,"",fecha_realizado,
if(tipo_documento = 'R',1,2),"","" 
from comercio_fe.recibo_cliente_cab 
where anulado ='N'



##pasaje de las referencias que hay en recibo_cliente_det
insert into comercio_fe.cfe_referencias_det 
select rd.id_recibo,1,"1",c.tipoCFE,c.serieCFE,c.numeroCFE, c.fecha,"",rd.numero_factura,rd.importe
from comercio_fe.recibo_cliente_det rd ,comercio_fe.recibo_cliente_cab rc,comercio_fe.cfe_comprobante_cab c
where c.id_factura = rd.numero_factura
and rc.id_recibo = rd.id_recibo
#and ca.id_factura = rd.id_recibo
and rc.anulado = 'N'