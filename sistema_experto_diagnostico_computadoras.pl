% Hechos base: Preguntas del árbol de decisión
pregunta(problemas_rendimiento, '¿Tiene problemas de rendimiento?').
pregunta(lenta, '¿Está lenta?').
pregunta(congelamiento, '¿Se congela?').
pregunta(apagados, '¿Se apaga?').

% Problzemas de hardware
pregunta(hardware, '¿El problema parece estar en el hardware?').
pregunta(hdd_ssd, '¿El HDD/SSD está en buen estado?').
pregunta(ram, '¿Es posible ampliar la RAM?').
pregunta(cpu, '¿Es posible actualizar el CPU?').

% Problemas de Software
pregunta(software, '¿El problema parece estar en el software?').
pregunta(actualizar_so, '¿Está el sistema operativo actualizado?').
pregunta(malware, '¿Hay malware en el sistema?').
pregunta(programas_innecesarios, '¿Hay programas innecesarios que puedas eliminar?').
pregunta(optimizar_inicio, '¿Se pueden optimizar los programas que inician con el sistema?').
pregunta(procesos_segundo_plano, '¿Se pueden reducir los procesos en segundo plano?').

% Problemas de arranque
pregunta(arranque, '¿El problema es durante el arranque?').
pregunta(energia, '¿Hay energía en el sistema?').
pregunta(video, '¿El sistema muestra video?').
pregunta(codigo_error, '¿El sistema emite códigos de error sonoros o luminosos?').

% Problemas de red
pregunta(red, '¿El problema está relacionado con la red?').
pregunta(conexion_wifi, '¿Estás conectado a una red Wi-Fi?').
pregunta(conexion_cable, '¿Estás usando una conexión por cable?').
pregunta(velocidad_internet, '¿La velocidad de internet es lenta?').
pregunta(ip_configurada, '¿Está correctamente configurada la dirección IP?').
pregunta(dns, '¿Se resolvieron correctamente las direcciones DNS?').



% Problemas de pantalla
pregunta(pantalla, '¿El problema está relacionado con la pantalla?').
pregunta(sin_imagen, '¿No aparece ninguna imagen en la pantalla?').
pregunta(parpadeo, '¿La pantalla parpadea?').
pregunta(resolucion_baja, '¿La resolución de la pantalla es baja?').
pregunta(mancha_colores, '¿Aparecen manchas o líneas de colores en la pantalla?').

% Problemas de almacenamiento
pregunta(almacenamiento, '¿El problema está relacionado con el almacenamiento?').
pregunta(espacio_insuficiente, '¿El disco tiene poco espacio disponible?').
pregunta(archivos_corruptos, '¿Existen archivos corruptos en el sistema?').
pregunta(particiones, '¿Hay errores en las particiones del disco?').

% Diagnóstico RAM
pregunta(tipos_ram, '¿Qué tipo de RAM tiene? (DIMM/SODIMM)').  
pregunta(slots_disponibles, '¿Hay slots disponibles para RAM?').  
pregunta(generacion_ram, '¿Qué generación de RAM es? (DDR/DDR2/DDR3/DDR4/DDR5)').  

% Diagnóstico CPU
pregunta(modular_cpu, '¿El CPU es modular?').  
pregunta(marca_cpu, '¿Qué marca de CPU es? (Intel/AMD)').  
pregunta(socket_cpu, '¿Qué socket tiene el CPU?').  

% Diagnóstico GPU
pregunta(tipo_gpu, '¿Qué tipo de GPU tiene? (On Board/APU/PCI/PCI Express)').  

% Diagnóstico de Códigos de Error
pregunta(codigos_error_pitidos, '¿Cuántos pitidos escuchaste? (ejemplo: "1 largo, 2 cortos")').  
pregunta(codigos_error_luces, '¿Cuántos parpadeos observaste? (ejemplo: "2 rojos, 2 blancos")').  
pregunta(post_error, '¿El sistema muestra errores POST?').  
pregunta(bateria_cmos, '¿Has revisado o reemplazado la batería CMOS?').  

% Diagnóstico de Almacenamiento
pregunta(bus_almacenamiento, '¿Qué bus de datos tiene disponible para el almacenamiento? (SATA/mSATA/M.2 SATA/M.2 NVMe)').  



% Predicado principal para iniciar el sistema experto
inicio :-
    writeln('Responde las siguientes preguntas con "si" o "no".'),
    diagnosticar.

% Preguntar al usuario
preguntar(Pregunta) :-
    pregunta(Pregunta, Texto),
    format('~w (si/no): ', [Texto]),
    read_line_to_string(user_input, Respuesta),
    process_respuesta(Respuesta, Procesada),
    assert(respuesta_actual(Pregunta, Procesada)).

% Procesar la respuesta del usuario
process_respuesta(Respuesta, Procesada) :-
    string_lower(Respuesta, RespuestaLower),
    (RespuestaLower = "si" -> Procesada = si;
     RespuestaLower = "no" -> Procesada = no;
     Procesada = no). % Asume "no" si no es "si"

% Obtener la respuesta del usuario
obtener_respuesta(Pregunta, Respuesta) :-
    retract(respuesta_actual(Pregunta, Respuesta)).

diagnosticar :- 
    preguntar(problemas_rendimiento),
    obtener_respuesta(problemas_rendimiento, RespuestaPR),
    (RespuestaPR = si -> diagnostico_rendimiento;
    preguntar(arranque),
    obtener_respuesta(arranque, RespuestaArranque),
    (RespuestaArranque = si -> diagnostico_arranque;
    preguntar(red),
    obtener_respuesta(red, RespuestaRed),
    (RespuestaRed = si -> diagnostico_red;
    preguntar(pantalla),
    obtener_respuesta(pantalla, RespuestaPantalla),
    (RespuestaPantalla = si -> diagnostico_pantalla;
    preguntar(almacenamiento),
    obtener_respuesta(almacenamiento, RespuestaAlmacenamiento),
    (RespuestaAlmacenamiento = si -> diagnostico_almacenamiento_detallado; % Diagnóstico detallado de almacenamiento
    preguntar(ram),
    obtener_respuesta(ram, RespuestaRAM),
    (RespuestaRAM = si -> diagnostico_ram; % Diagnóstico de RAM
    preguntar(cpu),
    obtener_respuesta(cpu, RespuestaCPU),
    (RespuestaCPU = si -> diagnostico_cpu; % Diagnóstico de CPU
    preguntar(tipo_gpu),
    obtener_respuesta(tipo_gpu, RespuestaGPU),
    (RespuestaGPU \= "" -> diagnostico_gpu; % Diagnóstico de GPU
    preguntar(codigo_error),
    obtener_respuesta(codigo_error, RespuestaCE),
    (RespuestaCE = si -> diagnostico_codigos_error; % Diagnóstico por códigos de error
    writeln('No se detectaron problemas en las categorías definidas.')))))))))).

% Diagnóstico de problemas de red
diagnostico_red :- 
    preguntar(conexion_wifi),
    obtener_respuesta(conexion_wifi, RespuestaWifi),
    (RespuestaWifi = si ->
        preguntar(velocidad_internet),
        obtener_respuesta(velocidad_internet, RespuestaVelocidad),
        (RespuestaVelocidad = si -> writeln('Optimizar Wi-Fi: cambiar canal, acercarse al router o reiniciarlo.');
        preguntar(dns),
        obtener_respuesta(dns, RespuestaDNS),
        (RespuestaDNS = no -> writeln('Configurar manualmente los servidores DNS, como los de Google.');
        writeln('La red Wi-Fi parece estar en buen estado.')));
    preguntar(conexion_cable),
    obtener_respuesta(conexion_cable, RespuestaCable),
    (RespuestaCable = si -> writeln('Verificar el cable Ethernet y probar otro puerto.');
    writeln('No se detectaron problemas de red evidentes.'))).

% Diagnóstico de problemas de pantalla
diagnostico_pantalla :- 
    preguntar(sin_imagen),
    obtener_respuesta(sin_imagen, RespuestaSinImagen),
    (RespuestaSinImagen = si -> writeln('Revisar conexiones del monitor y probar con otro cable.');
    preguntar(parpadeo),
    obtener_respuesta(parpadeo, RespuestaParpadeo),
    (RespuestaParpadeo = si -> writeln('Actualizar controladores gráficos y revisar la frecuencia de refresco.');
    preguntar(resolucion_baja),
    obtener_respuesta(resolucion_baja, RespuestaResolucion),
    (RespuestaResolucion = si -> writeln('Configurar resolución correcta desde la configuración de pantalla.');
    preguntar(mancha_colores),
    obtener_respuesta(mancha_colores, RespuestaManchas),
    (RespuestaManchas = si -> writeln('El problema podría ser hardware: revisar la pantalla o tarjeta gráfica.');
    writeln('No se detectaron problemas con la pantalla.'))))).

% Diagnóstico de problemas de almacenamiento
diagnostico_almacenamiento :- 
    preguntar(espacio_insuficiente),
    obtener_respuesta(espacio_insuficiente, RespuestaEspacio),
    (RespuestaEspacio = si -> writeln('Eliminar archivos innecesarios o migrar datos a otro disco.');
    preguntar(archivos_corruptos),
    obtener_respuesta(archivos_corruptos, RespuestaArchivos),
    (RespuestaArchivos = si -> writeln('Ejecutar herramientas como CHKDSK en Windows o fsck en Linux.');
    preguntar(particiones),
    obtener_respuesta(particiones, RespuestaParticiones),
    (RespuestaParticiones = si -> writeln('Revisar particiones con herramientas como GParted o Disk Management.');
    writeln('No se detectaron problemas de almacenamiento.')))).

% Diagnóstico de problemas de rendimiento
diagnostico_rendimiento :-
    preguntar(lenta),
    obtener_respuesta(lenta, RespuestaPL),
    (RespuestaPL = si ->
        diagnostico_lenta;
        preguntar(congelamiento),
        obtener_respuesta(congelamiento, RespuestaPC),
        (RespuestaPC = si -> diagnostico_congelamiento;
        preguntar(apagados),
        obtener_respuesta(apagados, RespuestaPA),
        (RespuestaPA = si -> diagnostico_apagado;
        writeln('El problema no parece estar relacionado con el rendimiento.')))).

% Diagnóstico de problemas cuando el sistema está lento
diagnostico_lenta :-
    preguntar(hardware),
    obtener_respuesta(hardware, RespuestaPH),
    (RespuestaPH = si ->
        diagnostico_hardware;
        preguntar(software),
        obtener_respuesta(software, RespuestaPS),
        (RespuestaPS = si -> diagnostico_software;
        writeln('No se detectaron problemas de hardware ni software.'))).

%Diagnostico de hardware
diagnostico_hardware :-
    preguntar(hdd_ssd),
    obtener_respuesta(hdd_ssd, RespuestaHDD),
    (RespuestaHDD = no ->
        writeln('Revisar HDD/SSD: usar herramientas como CrystalDiskInfo y reemplazar si está dañado.');
        preguntar(ram),
        obtener_respuesta(ram, RespuestaRAM),
        (RespuestaRAM = si ->
            writeln('Ampliar memoria RAM según generación.');
            preguntar(cpu),
            obtener_respuesta(cpu, RespuestaCPU),
            (RespuestaCPU = si ->
                writeln('Actualizar el CPU según su tipo y socket.');
                writeln('El problema de hardware no parece resolverse.')))).

% Diagnostico de Software
diagnostico_software :-
    preguntar(actualizar_so),
    obtener_respuesta(actualizar_so, RespuestaASO),
    (RespuestaASO = no ->
        writeln('Actualizar el sistema operativo.');
        preguntar(malware),
        obtener_respuesta(malware, RespuestaMW),
        (RespuestaMW = si ->
            writeln('Eliminar malware usando herramientas como Malwarebytes.');
            preguntar(programas_innecesarios),
            obtener_respuesta(programas_innecesarios, RespuestaPI),
            (RespuestaPI = si ->
                writeln('Eliminar programas innecesarios.');
                preguntar(optimizar_inicio),
                obtener_respuesta(optimizar_inicio, RespuestaOI),
                (RespuestaOI = si ->
                    writeln('Optimizar el inicio deshabilitando programas.');
                    preguntar(procesos_segundo_plano),
                    obtener_respuesta(procesos_segundo_plano, RespuestaPSP),
                    (RespuestaPSP = si ->
                        writeln('Reducir procesos en segundo plano.');
                        writeln('El problema de software no parece resolverse.')))))).

% Diagnóstico de problemas de congelamiento
diagnostico_congelamiento :-
    writeln('Revisar controladores, sistema operativo y hardware físico.').

% Diagnóstico de problemas de apagado
diagnostico_apagado :-
    writeln('Verificar temperaturas, ventiladores, y sistema de refrigeración.').

% Diagnóstico de problemas de arranque
diagnostico_arranque :-
    preguntar(energia),
    obtener_respuesta(energia, RespuestaPE),
    (RespuestaPE = no ->
        writeln('Revisar el PSU/Cargador o reemplazar batería.');
        preguntar(video),
        obtener_respuesta(video, RespuestaPV),
        (RespuestaPV = no ->
            writeln('Revisar problemas con la RAM, pantalla o BIOS.');
            preguntar(codigo_error),
            obtener_respuesta(codigo_error, RespuestaCE),
            (RespuestaCE = si ->
                writeln('Identificar los códigos de error y actuar según la guía.');
                writeln('El problema de arranque no parece resolverse.')))).

diagnostico_ram :- 
    preguntar(tipos_ram),
    obtener_respuesta(tipos_ram, TipoRAM),
    (TipoRAM = "DIMM" ; TipoRAM = "SODIMM") ->
        preguntar(slots_disponibles),
        obtener_respuesta(slots_disponibles, Slots),
        (Slots = si ->
            preguntar(generacion_ram),
            obtener_respuesta(generacion_ram, Generacion),
            (Generacion = "DDR" -> writeln('Adquirir y colocar una RAM DDR de 256MB recomendada.');
            Generacion = "DDR2" -> writeln('Adquirir y colocar una RAM DDR2 de 1GB recomendada.');
            Generacion = "DDR3" -> writeln('Adquirir y colocar una RAM DDR3 de 4GB recomendada.');
            Generacion = "DDR4" -> writeln('Adquirir y colocar una RAM DDR4 de 8GB recomendada.');
            Generacion = "DDR5" -> writeln('Adquirir y colocar una RAM DDR5 de 8GB recomendada.'));
        writeln('No hay slots disponibles o no es posible ampliar la RAM.')).

diagnostico_cpu :- 
    preguntar(modular_cpu),
    obtener_respuesta(modular_cpu, Modular),
    (Modular = si ->
        preguntar(marca_cpu),
        obtener_respuesta(marca_cpu, Marca),
        preguntar(socket_cpu),
        obtener_respuesta(socket_cpu, Socket),
        (Marca = "Intel" -> writeln('Reemplaza tu CPU con un modelo compatible con el socket: '), writeln(Socket);
        Marca = "AMD" -> writeln('Reemplaza tu CPU con un modelo compatible con el socket: '), writeln(Socket));
    writeln('El CPU no es modular y no puede ser reemplazado.')).

diagnostico_gpu :- 
    preguntar(tipo_gpu),
    obtener_respuesta(tipo_gpu, Tipo),
    (Tipo = "On Board" -> writeln('La GPU está integrada y no puede ser reemplazada.');
    Tipo = "APU" -> writeln('La APU no puede ser reemplazada.');
    Tipo = "PCI" -> writeln('Adquiere una GPU que no provoque cuello de botella con tu CPU.');
    Tipo = "PCI Express" -> writeln('Adquiere una GPU compatible con PCI Express que sea tan potente como tu CPU para evitar cuellos de botella.')).

diagnostico_codigos_error_pitidos :- 
    preguntar(codigos_error_pitidos),
    obtener_respuesta(codigos_error_pitidos, Pitidos),
    (Pitidos = "1 largo, 2 cortos" -> writeln('Fallo en la motherboard o GPU: verificar conexiones.');
    Pitidos = "3 largos, 2 cortos" -> writeln('RAM mal colocada: recolocar o limpiar puertos.');
    Pitidos = "4 cortos" -> writeln('Fallo en chip de seguridad: contactar soporte técnico.');
    writeln('Código no reconocido: buscar en el manual del fabricante.')).

diagnostico_codigos_error_luces :- 
    preguntar(codigos_error_luces),
    obtener_respuesta(codigos_error_luces, Luces),
    (Luces = "2 rojos, 2 blancos" -> writeln('BIOS corrupto: recuperar o restablecer desde una unidad USB.');
    Luces = "3 rojos, 2 blancos" -> writeln('Fallo de RAM: recolocar o cambiar la RAM.');
    Luces = "3 rojos, 3 blancos" -> writeln('Fallo en la GPU: revisar físicamente o reemplazar.');
    writeln('Código no reconocido: buscar en el manual del fabricante.')).

diagnostico_post :- 
    preguntar(post_error),
    obtener_respuesta(post_error, RespuestaPOST),
    (RespuestaPOST = si ->
        preguntar(bateria_cmos),
        obtener_respuesta(bateria_cmos, CMOS),
        (CMOS = si -> writeln('Revisar y reemplazar batería CMOS si es necesario.');
        writeln('Problema no identificado: contactar soporte técnico.'));
    writeln('No se detectaron errores POST.')).

diagnostico_almacenamiento_detallado :- 
    preguntar(bus_almacenamiento),
    obtener_respuesta(bus_almacenamiento, Bus),
    (Bus = "SATA" -> writeln('Adquirir un SSD con puerto SATA.');
    Bus = "mSATA" -> writeln('Adquirir un SSD que se conecte por mSATA.');
    Bus = "M.2 SATA" -> writeln('Adquirir un SSD que use el puerto M.2 SATA.');
    Bus = "M.2 NVMe" -> writeln('Adquirir un SSD que use el puerto M.2 NVMe.');
    writeln('Bus no reconocido: verificar especificaciones del sistema.')).
