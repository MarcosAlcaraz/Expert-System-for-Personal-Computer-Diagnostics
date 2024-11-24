% Hechos base: Preguntas del árbol de decisión
pregunta(problemas_rendimiento, '¿Tiene problemas de rendimiento?').
pregunta(lenta, '¿Está lenta?').
pregunta(congelamiento, '¿Se congela?').
pregunta(apagados, '¿Se apaga?').

% Preguntas de problemas de hardware
pregunta(hardware, '¿El problema parece estar en el hardware?').
pregunta(hdd_ssd, '¿El HDD/SSD está en buen estado?').
pregunta(ram, '¿Es posible ampliar la RAM?').
pregunta(cpu, '¿Es posible actualizar el CPU?').

% Preguntas de problemas de software
pregunta(software, '¿El problema parece estar en el software?').
pregunta(actualizar_so, '¿Está el sistema operativo actualizado?').
pregunta(malware, '¿Hay malware en el sistema?').
pregunta(programas_innecesarios, '¿Hay programas innecesarios que puedas eliminar?').
pregunta(optimizar_inicio, '¿Se pueden optimizar los programas que inician con el sistema?').
pregunta(procesos_segundo_plano, '¿Se pueden reducir los procesos en segundo plano?').

% Diagnóstico inicial
diagnosticar :-
    pregunta(problemas_rendimiento, PR),
    writeln(PR), read(RespuestaPR),
    (RespuestaPR = si -> diagnostico_rendimiento
    ; pregunta(arranque, PA),
      writeln(PA), read(RespuestaPA),
      (RespuestaPA = si -> diagnostico_arranque
      ; writeln('No se detectaron problemas relacionados con rendimiento ni arranque.'))).

% Diagnóstico de problemas de rendimiento
diagnostico_rendimiento :-
    pregunta(lenta, PL),
    writeln(PL), read(RespuestaPL),
    (RespuestaPL = si -> diagnostico_lenta
    ; pregunta(congelamiento, PC),
      writeln(PC), read(RespuestaPC),
      (RespuestaPC = si -> diagnostico_congelamiento
      ; pregunta(apagados, PA),
        writeln(PA), read(RespuestaPA),
        (RespuestaPA = si -> diagnostico_apagado
        ; writeln('El problema no parece estar relacionado con el rendimiento.')))).

% Diagnóstico de problemas cuando el sistema está lento
diagnostico_lenta :-
    pregunta(hardware, PH),
    writeln(PH), read(RespuestaPH),
    (RespuestaPH = si -> diagnostico_hardware
    ; pregunta(software, PS),
      writeln(PS), read(RespuestaPS),
      (RespuestaPS = si -> diagnostico_software
      ; writeln('No se detectaron problemas de hardware ni software.'))).

diagnostico_hardware :-
    pregunta(hdd_ssd, HDD),
    writeln(HDD), read(RespuestaHDD),
    (RespuestaHDD = no -> writeln('Revisar HDD/SSD: usar herramientas como CrystalDiskInfo y reemplazar si está dañado.')
    ; pregunta(ram, RAM),
      writeln(RAM), read(RespuestaRAM),
      (RespuestaRAM = si -> writeln('Ampliar memoria RAM según generación.')
      ; pregunta(cpu, CPU),
        writeln(CPU), read(RespuestaCPU),
        (RespuestaCPU = si -> writeln('Actualizar el CPU según su tipo y socket.')
        ; writeln('El problema de hardware no parece resolverse.')))).

% Diagnóstico de problemas de software
diagnostico_software :-
    pregunta(actualizar_so, ASO),
    writeln(ASO), read(RespuestaASO),
    (RespuestaASO = no -> writeln('Actualizar el sistema operativo.')
    ; pregunta(malware, MW),
      writeln(MW), read(RespuestaMW),
      (RespuestaMW = si -> writeln('Eliminar malware usando herramientas como Malwarebytes.')
      ; pregunta(programas_innecesarios, PI),
        writeln(PI), read(RespuestaPI),
        (RespuestaPI = si -> writeln('Eliminar programas innecesarios.')
        ; pregunta(optimizar_inicio, OI),
          writeln(OI), read(RespuestaOI),
          (RespuestaOI = si -> writeln('Optimizar el inicio deshabilitando programas.')
          ; pregunta(procesos_segundo_plano, PSP),
            writeln(PSP), read(RespuestaPSP),
            (RespuestaPSP = si -> writeln('Reducir procesos en segundo plano.')
            ; writeln('El problema de software no parece resolverse.')))))).

% Diagnóstico de problemas de congelamiento
diagnostico_congelamiento :-
    writeln('Revisar controladores, sistema operativo y hardware físico.').

% Diagnóstico de problemas de apagado
diagnostico_apagado :-
    writeln('Verificar temperaturas, ventiladores, y sistema de refrigeración.').

% Diagnóstico de problemas de arranque
diagnostico_arranque :-
    pregunta(energia, PE),
    writeln(PE), read(RespuestaPE),
    (RespuestaPE = no -> writeln('Revisar el PSU/Cargador o reemplazar batería.')
    ; pregunta(video, PV),
      writeln(PV), read(RespuestaPV),
      (RespuestaPV = no -> writeln('Revisar problemas con la RAM, pantalla o BIOS.')
      ; pregunta(codigo_error, CE),
        writeln(CE), read(RespuestaCE),
        (RespuestaCE = si -> writeln('Identificar los códigos de error y actuar según la guía.')
        ; writeln('El problema de arranque no parece resolverse.')))).

% Inicio del sistema
inicio :-
    writeln('Bienvenido al sistema experto para diagnóstico de problemas de computadora.'),
    diagnosticar.
