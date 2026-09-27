# Black Ops Paintball

## Uso local

`start.bat` es un acceso directo opcional en Windows. También puedes ejecutar `npm start` desde esta carpeta. En los dos casos se inicia el servidor local en `http://127.0.0.1:4173`. La aplicación necesita Node.js 22 o superior y el servidor activo para guardar cambios.

## Publicar con un dominio

Para que los clientes entren desde Internet, hay que desplegar este servidor Node.js en un proveedor de alojamiento que mantenga almacenamiento persistente para SQLite y configurar allí las variables `PORT`, `NODE_ENV=production`, `DATA_DIR` y `EXPORT_DIR`. Después se conecta el dominio comprado al alojamiento mediante sus instrucciones DNS y se habilita HTTPS. Una vez publicado, los clientes abren el dominio; no necesitan `start.bat` ni instalar nada. Comprar el dominio por sí solo no publica ni ejecuta la aplicación.

## Cuentas y rangos

La cuenta inicial del negocio usa `mateoferraro90@gmail.com`. Las cuentas creadas en la página de registro comienzan como **Cliente**. El dueño asigna los rangos **Cliente**, **Empleado** y **Dueño** desde Usuarios. El correo `juanselh.jje@gmail.com` se asigna como **Programador** al registrarse. Programador administra las cuentas, reservas e inventario; Empleado consulta reportes resumidos y valida códigos. El dueño o el empleado receptor registra el pago; el sistema guarda quién lo recibió.

## Reservas, pago y código de entrada

El cliente escoge fecha, hora de inicio, duración, jugadores, bolas y forma de pago (efectivo o transferencia/Nequi). Al apartar, la aplicación genera inmediatamente un código de pedido antes del pago y bloquea los periodos que se crucen con la duración. El cliente comparte ese código con el dueño o el empleado que recibe el pago; esa persona introduce el código y pulsa **Confirmar pago recibido y activar código**. El sistema guarda quién recibió el pago. El cliente usa ese mismo código al llegar.

El empleado consulta el código en **Validar código**. Ve una vista previa con duración, jugadores, forma y estado del pago, bolas y observaciones. Tras recibir el pago, el dueño o empleado receptor lo activa. Cuando el cliente llega, el empleado vuelve a consultar el código y pulsa **Aceptar entrada y desactivar código**. La aplicación lo consume en una operación atómica; otro empleado no podrá reutilizarlo.

## Datos

SQLite conserva cuentas, reservas, roles, inventario y entradas validadas en `data/blackops.sqlite`. `exports/BlackOps.xlsx` se actualiza automáticamente con cuentas, reservas, horas, pago, bolas, códigos e inventario. No exporta contraseñas. Las migraciones agregan columnas sin borrar las cuentas ni reservas existentes.

La interfaz está organizada en `public/index.html`, `public/css/`, `public/js/` y `public/assets/`.

## Correos y mensajes de texto

Al activar el pago, el cliente recibe un correo y, si registró un celular colombiano válido, un SMS con la confirmación y su código de reserva. El sistema también programa un recordatorio por correo y SMS para la fecha y hora de inicio en la zona horaria de Colombia. La entrega del campo sigue siendo independiente: el empleado consume el código cuando acepta la entrada.

Para habilitar los avisos, copia `.env.example` como `.env` en Windows (`Copy-Item .env.example .env`) y completa las variables en ese archivo; nunca compartas estas claves por chat ni las subas al repositorio:

- Gmail: `GMAIL_USER` y una contraseña de aplicación en `GMAIL_APP_PASSWORD` (la cuenta debe tener la verificación en dos pasos habilitada).
- Twilio: `TWILIO_ACCOUNT_SID`, `TWILIO_AUTH_TOKEN` y `TWILIO_FROM_NUMBER`. Usa un remitente con capacidad SMS. En cuentas de prueba, Twilio limita los destinatarios a números verificados.

Después reinicia el servidor. Los envíos pendientes se conservan en SQLite y se reintentan; si el servidor estaba apagado cuando debía salir un recordatorio y pasan más de 15 minutos, ese recordatorio se omite. El alojamiento debe mantener el proceso activo, almacenamiento persistente y las mismas variables configuradas. El archivo Excel incluye una hoja `Avisos` con el estado de cada envío. Los proveedores pueden cobrar por mensajes.
