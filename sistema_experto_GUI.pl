:- use_module(library(pce)).

% Hechos base: Preguntas del árbol de decisión
pregunta(problemas_rendimiento, '¿Tiene problemas de rendimiento?').
pregunta(lenta, '¿Está lenta?').
pregunta(congelamiento, '¿Se congela?').
pregunta(apagados, '¿Se apaga?').

pregunta(hardware, '¿El problema parece estar en el hardware?').
pregunta(hdd_ssd, '¿El HDD/SSD está en buen estado?').
pregunta(ram, '¿Es posible ampliar la RAM?').
pregunta(cpu, '¿Es posible actualizar el CPU?').

pregunta(software, '¿El problema parece estar en el software?').
pregunta(actualizar_so, '¿Está el sistema operativo actualizado?').
pregunta(malware, '¿Hay malware en el sistema?').
pregunta(programas_innecesarios, '¿Hay programas innecesarios que puedas eliminar?').
pregunta(optimizar_inicio, '¿Se pueden optimizar los programas que inician con el sistema?').
pregunta(procesos_segundo_plano, '¿Se pueden reducir los procesos en segundo plano?').

pregunta(arranque, '¿El problema es durante el arranque?').
pregunta(energia, '¿Hay energía en el sistema?').
pregunta(video, '¿El sistema muestra video?').
pregunta(codigo_error, '¿El sistema emite códigos de error sonoros o luminosos?').

% Predicado principal para iniciar el sistema experto
inicio :-
    new(D, dialog('Sistema Experto')),
    send(D, append, new(_, label(text, '¿Cuál es el problema?'))), % Pregunta actual
    send(D, append, button(si, message(@prolog, responder, si, D))),
    send(D, append, button(no, message(@prolog, responder, no, D))),
    send(D, open),
    assert(dialogo(D)), % Guardar referencia al diálogo
    diagnosticar. % Iniciar el diagnóstico

% Responder a una pregunta
responder(Respuesta, Dialogo) :-
    retract(dialogo(Dialogo)),
    assert(respuesta_actual(Respuesta)),
    send(Dialogo, destroy). % Cerrar el cuadro de diálogo

% Preguntar al usuario
preguntar(Pregunta) :-
    retractall(respuesta_actual(_)),
    dialogo(D),
    send(D, clear),
    send(D, display, new(_, label(texto, Pregunta)), point(10, 10)),
    send(D, layout),
    send(D, wait).

% Obtener la respuesta del usuario
obtener_respuesta(Respuesta) :-
    respuesta_actual(Respuesta).

% Diagnóstico inicial
diagnosticar :-
    pregunta(problemas_rendimiento, PR),
    preguntar(PR),
    obtener_respuesta(RespuestaPR),
    (RespuestaPR = si ->
        diagnostico_rendimiento;
        pregunta(arranque, PA),
        preguntar(PA),
        obtener_respuesta(RespuestaPA),
        (RespuestaPA = si -> diagnostico_arranque;
        writeln('No se detectaron problemas relacionados con rendimiento ni arranque.'))).

% Diagnóstico de problemas de rendimiento
diagnostico_rendimiento :-
    pregunta(lenta, PL),
    preguntar(PL),
    obtener_respuesta(RespuestaPL),
    (RespuestaPL = si ->
        diagnostico_lenta;
        pregunta(congelamiento, PC),
        preguntar(PC),
        obtener_respuesta(RespuestaPC),
        (RespuestaPC = si -> diagnostico_congelamiento;
        pregunta(apagados, PA),
        preguntar(PA),
        obtener_respuesta(RespuestaPA),
        (RespuestaPA = si -> diagnostico_apagado;
        writeln('El problema no parece estar relacionado con el rendimiento.')))).

% Diagnóstico de problemas cuando el sistema está lento
diagnostico_lenta :-
    pregunta(hardware, PH),
    preguntar(PH),
    obtener_respuesta(RespuestaPH),
    (RespuestaPH = si ->
        diagnostico_hardware;
        pregunta(software, PS),
        preguntar(PS),
        obtener_respuesta(RespuestaPS),
        (RespuestaPS = si -> diagnostico_software;
        writeln('No se detectaron problemas de hardware ni software.'))).

diagnostico_hardware :-
    pregunta(hdd_ssd, HDD),
    preguntar(HDD),
    obtener_respuesta(RespuestaHDD),
    (RespuestaHDD = no ->
        writeln('Revisar HDD/SSD: usar herramientas como CrystalDiskInfo y reemplazar si está dañado.');
        pregunta(ram, RAM),
        preguntar(RAM),
        obtener_respuesta(RespuestaRAM),
        (RespuestaRAM = si ->
            writeln('Ampliar memoria RAM según generación.');
            pregunta(cpu, CPU),
            preguntar(CPU),
            obtener_respuesta(RespuestaCPU),
            (RespuestaCPU = si ->
                writeln('Actualizar el CPU según su tipo y socket.');
                writeln('El problema de hardware no parece resolverse.')))).

diagnostico_software :-
    pregunta(actualizar_so, ASO),
    preguntar(ASO),
    obtener_respuesta(RespuestaASO),
    (RespuestaASO = no ->
        writeln('Actualizar el sistema operativo.');
        pregunta(malware, MW),
        preguntar(MW),
        obtener_respuesta(RespuestaMW),
        (RespuestaMW = si ->
            writeln('Eliminar malware usando herramientas como Malwarebytes.');
            pregunta(programas_innecesarios, PI),
            preguntar(PI),
            obtener_respuesta(RespuestaPI),
            (RespuestaPI = si ->
                writeln('Eliminar programas innecesarios.');
                pregunta(optimizar_inicio, OI),
                preguntar(OI),
                obtener_respuesta(RespuestaOI),
                (RespuestaOI = si ->
                    writeln('Optimizar el inicio deshabilitando programas.');
                    pregunta(procesos_segundo_plano, PSP),
                    preguntar(PSP),
                    obtener_respuesta(RespuestaPSP),
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
    pregunta(energia, PE),
    preguntar(PE),
    obtener_respuesta(RespuestaPE),
    (RespuestaPE = no ->
        writeln('Revisar el PSU/Cargador o reemplazar batería.');
        pregunta(video, PV),
        preguntar(PV),
        obtener_respuesta(RespuestaPV),
        (RespuestaPV = no ->
            writeln('Revisar problemas con la RAM, pantalla o BIOS.');
            pregunta(codigo_error, CE),
            preguntar(CE),
            obtener_respuesta(RespuestaCE),
            (RespuestaCE = si ->
                writeln('Identificar los códigos de error y actuar según la guía.');
                writeln('El problema de arranque no parece resolverse.')))).
