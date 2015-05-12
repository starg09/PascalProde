Program prode;
uses strutils,sysutils,crt,CargarFixture;
const
    MAX_USUARIOS = 20;
    //Nombre de los archivos usados para almacenar los datos: El fixture, los resultados ingresados por el admin y los prodes y nombres de los usuarios.
    ARCHIVO_FIXTURE = 'fixture.dat';
    ARCHIVO_RESULTADOS = 'resultados.dat';
    ARCHIVO_USUARIOS = 'usuarios.dat';
    //Demora entre cada linea impresa en la animacion inicial
    FREC_ANIMACION_INTRO = 50;
    //Cuanto pasa entre la animacion inicial y el "Presione cualquier..."
    DELAY_POST_INTRO = 2000;
    //Codigos de Colores, los originales no estan bien definidos
    C_NEGRO = 0;
    C_AZUL = 1;
    C_VERDE = 2;
    C_CYAN = 3;
    C_ROJO = 4;
    C_VIOLETA = 5;
    C_DORADO = 6;
    C_GRISCLARO = 7;
    C_GRIS = 8;
    C_AZULCLARO = 9;
    C_VERDECLARO = 10;
    C_CYANCLARO = 11;
    C_ROJOCLARO = 12;
    C_VIOLETACLARO = 13;
    C_AMARILLO = 14;
    C_BLANCO = 15;
    //Ancho de la pantalla. Usado para centrar textos, o hacer barras de titulo o coloreadas
    //(Maximo default en consola de Windows: 80)
    ANCHO_PANTALLA = 80;
    //Puestos a mostrar por hoja en el ranking de usuarios.
    PUESTOS_POR_HOJA_RANKING = 4;
type
    rGoles = record
        gol_l: integer;
        gol_v: integer;
        end;
    rUsuarios = record
        nombre: string;
        prode: array[1..MAX_PARTIDOS] of rGoles;
        puntos: integer;
        end;
    tUsuarios = array[1..MAX_USUARIOS] of rUsuarios;
    tProde = array[1..MAX_PARTIDOS] of rGoles;
    tPuntos = array[1..MAX_USUARIOS] of byte;
(*Procedimientos Decorativos y minimos*)
procedure printLogoIntro();
    begin
        TextColor(Green);
        writeln('                                                ');
        delay(FREC_ANIMACION_INTRO);
        writeln('                                                ');
        delay(FREC_ANIMACION_INTRO);
        writeln('================================================================================');
        delay(FREC_ANIMACION_INTRO);
        writeln('                                                ');
        delay(FREC_ANIMACION_INTRO);
        writeln('                                                ');
        delay(FREC_ANIMACION_INTRO);
        writeln('  €€€€€€ª  €€€€€ª €€€€€€€ª €€€€€€ª €€€€€ª €€ª     ');
        delay(FREC_ANIMACION_INTRO);
        writeln('  €€…ÕÕ€€ª€€…ÕÕ€€ª€€…ÕÕÕÕº€€…ÕÕÕÕº€€…ÕÕ€€ª€€∫     ');
        delay(FREC_ANIMACION_INTRO);
        writeln('  €€€€€€…º€€€€€€€∫€€€€€€€ª€€∫     €€€€€€€∫€€∫     ');
        delay(FREC_ANIMACION_INTRO);
        writeln('  €€…ÕÕÕº €€…ÕÕ€€∫»ÕÕÕÕ€€∫€€∫     €€…ÕÕ€€∫€€∫     ');
        delay(FREC_ANIMACION_INTRO);
        writeln('  €€∫     €€∫  €€∫€€€€€€€∫»€€€€€€ª€€∫  €€∫€€€€€€€ª');
        delay(FREC_ANIMACION_INTRO);
        writeln('  »Õº     »Õº  »Õº»ÕÕÕÕÕÕº »ÕÕÕÕÕº»Õº  »Õº»ÕÕÕÕÕÕº');
        delay(FREC_ANIMACION_INTRO);
        writeln('                                                  ');
        delay(FREC_ANIMACION_INTRO);
        writeln('  €€€€€€ª €€€€€€ª  €€€€€€ª €€€€€€ª €€€€€€€ª       ');
        delay(FREC_ANIMACION_INTRO);
        writeln('  €€…ÕÕ€€ª€€…ÕÕ€€ª€€…ÕÕÕ€€ª€€…ÕÕ€€ª€€…ÕÕÕÕº       ');
        delay(FREC_ANIMACION_INTRO);
        writeln('  €€€€€€…º€€€€€€…º€€∫   €€∫€€∫  €€∫€€€€€ª         ');
        delay(FREC_ANIMACION_INTRO);
        writeln('  €€…ÕÕÕº €€…ÕÕ€€ª€€∫   €€∫€€∫  €€∫€€…ÕÕº         ');
        delay(FREC_ANIMACION_INTRO);
        writeln('  €€∫     €€∫  €€∫»€€€€€€…º€€€€€€…º€€€€€€€ª       ');
        delay(FREC_ANIMACION_INTRO);
        writeln('  »Õº     »Õº  »Õº »ÕÕÕÕÕº »ÕÕÕÕÕº »ÕÕÕÕÕÕº       ');
        delay(FREC_ANIMACION_INTRO);
        writeln('                                                ');
        delay(FREC_ANIMACION_INTRO);
        writeln('                                                ');
        delay(FREC_ANIMACION_INTRO);
        writeln('                                                ');
        delay(FREC_ANIMACION_INTRO);
        writeln('================================================================================');
        delay(FREC_ANIMACION_INTRO);
    end;
procedure printLogoMenu();
    begin
        TextColor(Green);
        writeln('                                                       ');
        writeln('================================================================================');
        writeln(' …Õª⁄ƒø⁄ƒø⁄ƒø⁄ƒø¬  …Õª¬ƒø⁄ƒø⁄¬ø⁄ƒø');
        writeln(' ÃÕº√ƒ¥¿ƒø≥  √ƒ¥≥  ÃÕº√¬Ÿ≥ ≥ ≥≥√¥ ');
        writeln('    ¡ ¡¿ƒŸ¿ƒŸ¡ ¡¡ƒŸ   ¡¿ƒ¿ƒŸƒ¡Ÿ¿ƒŸ');
        writeln('                                                       ');
        writeln('================================================================================');
        TextColor(LightGray);
    end;
procedure writelnCentrado(linea: string);
    Var
        i: byte;
        long: integer;
    begin
        long:= (ANCHO_PANTALLA-length(linea)) div 2;
        if (ANCHO_PANTALLA-length(linea)) mod 2 = 1 then write(' ');
        for i:=1 to long do write(' ');
        write(linea);
        writeln();
    end;
function strCentrado(linea: string; i: integer): string;
    Var
        j: byte;
        long: integer;
        retorno: string;
    begin
        long:= (i-length(linea)) div 2;
        retorno:= '';
        if (i-length(linea)) mod 2 = 1 then retorno:= retorno+' ';
        for j:=1 to long do retorno:= retorno+' ';
        retorno:= retorno+linea;
        for j:=1 to long do retorno:= retorno+' ';
        strCentrado:= retorno;
    end;
procedure barraTitulo(linea: string);//Muestra una barra de titulo con fondo gris
    var
        i: byte;
    begin
        TextBackground(LightGray);
        TextColor(Black);
        write('  ');
        write(linea);
        for i:=1 to (ANCHO_PANTALLA-2-length(linea)) do write(' ');//Resto al largo de la pantalla 2 espacios al comienzo, y el texto ingresado.
        TextColor(LightGray);
        TextBackground(Black);
    end;
procedure barraCualquiera(color:byte; linea: string);//Variacion de barraTitulo, para solucionar un peque§o bug cuando se usa junto con readkey...
    var
        i: byte;
    begin
        TextBackground(color);
        TextColor(White);
        write('  ');
        write(linea);
        for i:=1 to (ANCHO_PANTALLA-3-length(linea)) do write(' ');//Dejo un espacio menos que en barraTitulo, para que no baje de linea al poner el readkey.
        TextColor(LightGray);
        TextBackground(Black);
    end;
procedure barraError();
    begin
        TextBackground(Red);
        TextColor(White);
        writeln('  ≠Opci¢n inv†lida!                                                             ');
        TextBackground(Black);
        TextColor(LightGray);
    end;
procedure barraProximamente();
    begin
        TextBackground(Cyan);
        TextColor(White);
        writeln('  Opci¢n no implementada...                                                     ');
        TextBackground(Black);
        TextColor(LightGray);
    end;
function teclaConsulta(color: byte; s: string):char;
    var
        k: char;
    begin
        barraCualquiera(color,s+' [S/N]');
        k:= readkey;
        while NOT(k in ['s','n','S','N']) do begin
            GotoXY(1,WhereY);
            clreol;
            barraCualquiera(C_BLANCO,s+' [S/N]');
            delay(50);
            GotoXY(1,WhereY);
            clreol;
            barraCualquiera(color,s+' [S/N]');
            k:= readkey;
        end;
        teclaConsulta:= k;
    end;
(*Carga de archivos*)
procedure cargarTablaUsuarios(var t: tUsuarios);
    var
        f: file of tUsuarios;
    begin
        assign(f, ARCHIVO_USUARIOS);
        reset(f);
        read(f,t);
        close(f);
    end;
procedure cargarTablaProde(var t: tProde);
    var
        f: file of tProde;
    begin
        assign(f, ARCHIVO_RESULTADOS);
        reset(f);
        read(f,t);
        close(f);
    end;
procedure cargarTablaFixture(var t: tFixture);
    var
        f: file of tFixture;
    begin
        assign(f, ARCHIVO_FIXTURE);
        reset(f);
        read(f,t);
        close(f);
    end;
(*Procedimientos de calculo*)
procedure ordenarUsuarios(var u: tUsuarios); 
    var cambio:boolean; 
        i,j:integer; 
        temp:rUsuarios; 
    begin
        cambio:=True; 
        i:= High(u);//valor mas alto del array
        while (cambio) do begin 
            cambio:= false; 
            j:= 1;//Valor mas bajo del array
            while j < i do begin 
                if ((u[j].nombre>u[j+1].nombre) and (u[j+1].nombre <> 'NULLUSER')) or (u[j].nombre = 'NULLUSER') then begin 
                    temp:= u[j]; 
                    u[j]:= u[j+1]; 
                    u[j+1]:= temp; 
                    cambio:= true; 
                end;
                j:= j+1; 
            end;
        i:=i-1; 
        end;
    end;
function puntajePartido(id,n:integer; usuarios: tUsuarios; res: tProde): integer;
    var
        i,p1,p2,r1,r2: integer;
    begin
        i:= 0;
        //Comprobaci¢n de goles locales
        if (usuarios[id].prode[n].gol_l = res[n].gol_l) then i:= i+1;
        //Comprobaci¢n de goles visitantes
        if (usuarios[id].prode[n].gol_v = res[n].gol_v) then i:= i+1;
        //Comprobaci¢n de diferencia de gol
        r1:= usuarios[id].prode[n].gol_l - usuarios[id].prode[n].gol_v;
        r2:= res[n].gol_l - res[n].gol_v;
        if (r1=r2) then i:= i+1;
        //Comprobaci¢n de resultado b†sico
        if (res[n].gol_l < res[n].gol_v) then p1:=0 else if(res[n].gol_l > res[n].gol_v) then p1:=2 else p1:=1;
        if (usuarios[id].prode[n].gol_l < usuarios[id].prode[n].gol_v) then p2:=0 else if(usuarios[id].prode[n].gol_l > usuarios[id].prode[n].gol_v) then p2:=2 else p2:=1;
        if (p1=p2) then i:=i+2;
        //Devoluci¢n de Puntaje
        puntajePartido:= i;
    end;
procedure resetearResultados();
    var
        res: tProde;
        fres: file of tProde;
        i: integer;
    begin
        assign(fres, ARCHIVO_RESULTADOS);
        Rewrite(fres);
        i:= 1;
        while i<=MAX_PARTIDOS do begin
            res[i].gol_l:= -1;
            res[i].gol_v:= -1;
            i:= i+1;
        end;
        Write(fres,res);
        Close(fres);
    end;
procedure resetearFixture();
    var
        fixture: tFixture;
        f: file of tFixture;
    begin
        assign(f, ARCHIVO_FIXTURE);
        Rewrite(f);
        cargar_fixture(fixture);
        Write(f,fixture);
        Close(f);
    end;
function calcularPuntos(var usuarios: tUsuarios; var res: tProde; id: integer): integer;
    var
        j,puntos: integer;
    begin
        puntos:= 0;
        for j:= 1 to MAX_PARTIDOS do if NOT((res[j].gol_l<0) OR (res[j].gol_v<0)) then puntos:= puntos + puntajePartido(id,j,usuarios,res);
        calcularPuntos:= puntos;
    end;
procedure rankingJugadores(var usuarios: tUsuarios; var res: tProde);
    var
        cambio:boolean; 
        n,i,j:integer; 
        temp:rUsuarios; 
    begin
        n:= 1;
        while (n <= MAX_USUARIOS) and (usuarios[n].nombre<>'NULLUSER') do begin
            usuarios[n].puntos:= calcularPuntos(usuarios,res,n);
            n:= n+1;
        end;
        cambio:=True; 
        i:= High(usuarios);//valor mas alto del array
        while (cambio) do begin 
            cambio:= false; 
            j:= 1;//Valor mas bajo del array
            while j < i do begin 
                if ((usuarios[j].puntos<usuarios[j+1].puntos) and (usuarios[j+1].nombre <> 'NULLUSER'))
                or ((usuarios[j].puntos=usuarios[j+1].puntos) and (usuarios[j].nombre>usuarios[j+1].nombre) and (usuarios[j+1].nombre <> 'NULLUSER'))
                or (usuarios[j].nombre = 'NULLUSER') then begin 
                    temp:= usuarios[j]; 
                    usuarios[j]:= usuarios[j+1]; 
                    usuarios[j+1]:= temp; 
                    cambio:= true; 
                end;
                j:= j+1; 
            end;
        i:=i-1; 
        end;
    end;
procedure lineaTabla(var usuarios: tUsuarios; var res: tProde; i: integer; var completo: boolean; nombre: string);//var en tablas para optimizar, en completo por modificarlo
    var
        puntos: integer;
    begin
        puntos:= calcularPuntos(usuarios,res,i);
        if (nombre = usuarios[i].nombre) then TextColor(Yellow);
        writeln('  ≥ ',strCentrado(IntToStr(i),9),' ≥ ',strCentrado(usuarios[i].nombre,10),' ≥ ',strCentrado(IntToStr(puntos),9),' ≥');
        TextColor(LightGray);
        if (i>=MAX_USUARIOS) OR (usuarios[i+1].nombre = 'NULLUSER') then completo:= true;
    end;
procedure democolores();//Remover antes de mandar final
    var
        i: integer;
    begin
        Clrscr;
        for i:=0 to 15 do begin
            TextBackground(i);
            write(' &',i,' ');
        end;
        TextBackground(Black);
        writeln();
        for i:=0 to 15 do begin
            TextColor(i);
            write(' &',i,' ');
        end;
        writeln();
        for i:=0 to 15 do begin
            TextColor(i);
            HighVideo;
            write(' &',i,' ');
        end;
        writeln();
        for i:=0 to 15 do begin
            TextColor(i);
            LowVideo;
            write(' &',i,' ');
        end;
        readkey;
    end;
(*Procedimientos basicos (Menus) *)
procedure listarPartidos();
    var
        partidos: tFixture;
        res: tProde;
        i,j,jmax: integer;
        cambio,np: boolean;
        instancia: string;
        s: string;
    begin
        ClrScr;
        printLogoMenu();
        if NOT(FileExists(ARCHIVO_FIXTURE)) then begin
            barraTitulo('Listar Partidos');
            writeln();
            writeln();
            TextColor(Red);
            writelnCentrado('Error: todav°a no hay un fixture cargado que mostrar.');
            writeln();
            writeln();
        end else if NOT(FileExists(ARCHIVO_RESULTADOS)) then begin
            barraTitulo('Listar Partidos');
            writeln();
            writeln();
            TextColor(Red);
            writelnCentrado('ERROR: No se pudo encontrar la grilla central.');
            writelnCentrado('Esta puede regenerarse con la opci¢n 1 del men£ de Administrador.');
            writeln();
        end else begin
            cargarTablaFixture(partidos);
            cargarTablaProde(res);
            i:= 1;
            jmax:= 1;
            instancia:= 'Nada';
            while (i <= MAX_PARTIDOS) do begin
                jmax:= jmax+1;
                if (instancia<>partidos[i].instancia) then begin
                    jmax:= jmax+3;
                    instancia:= partidos[i].instancia;
                end;
                i:= i+1;
            end;
            i:= 1;
            j:= 1;
            np:= false;
            while (i <= MAX_PARTIDOS) do begin
                if ((j mod 9 = 1) OR (np)) then begin
                    np:= false;
                    ClrScr;
                    printLogoMenu();
                    TextBackground(LightGray);
                    TextColor(Black);
                    s:='Listar Usuarios ('+inttostr((j div 9)+1)+'/'+inttostr(jmax div 9)+')';
                    barraTitulo(s);
                    writeln();
                    TextColor(LightGray);
                    TextBackground(Black);
                    instancia:= partidos[i].instancia;
                    writeln('  ',instancia);
                    writeln();
                end;
                cambio:= false;
                if (instancia<>partidos[i].instancia) then begin
                    instancia:= partidos[i].instancia;
                    writeln();
                    writeln('  ',instancia);
                    writeln();
                    j:= j+3;
                end;
                if (i < MAX_PARTIDOS) AND (instancia<>partidos[i+1].instancia) then cambio:= true;
                write('    ',i,') ',partidos[i].local,' - ',partidos[i].visitante);
                if (res[i].gol_l<0) OR (res[i].gol_v<0) then begin
                    writeln();
                end else begin
                    writeln(' (',res[i].gol_l,'-',res[i].gol_v,')');
                end;
                if (i < MAX_PARTIDOS) AND ((j mod 9 = 0) OR (cambio AND (j mod 9 >5))) then begin
                    writeln();
                    TextColor(C_AMARILLO);
                    write('  Presione cualquier tecla para mostrar la siguiente pagina...');
                    TextColor(LightGray);
                    np:= true;
                    if j mod 9 <> 0 then j:= j+(9-(j mod 9));
                    readkey;
                end;
                i:= i+1;
                j:= j+1;
                if (i > MAX_PARTIDOS) then begin
                    writeln();
                    writeln();
                    writeln();
                    writeln();
                end;
            end;
        end;
        writeln();
        TextColor(LightGray);
        write('  Presione cualquier tecla para volver al men£ anterior...');
        readkey;
    end;
procedure cargarResultado();
    var
        partidos: tFixture;
        res: tProde;
        fres: file of tProde;
        n,i,j: integer;
        k: char;
        repetir,conf,salir: boolean;
        input: string;
    begin
        ClrScr;
        printLogoMenu();
        barraTitulo('Carga de resultado');
        writeln();
        writeln();
        if NOT(FileExists(ARCHIVO_FIXTURE)) then begin
            TextColor(Red);
            writelnCentrado('No puede subirse un resultado si no hay un fixture cargado.');
            writeln();
            writeln();
            writeln();
            TextColor(LightGray);
            write('  Presione cualquier tecla para volver al men£ anterior...');
            readkey;
        end else if NOT(FileExists(ARCHIVO_RESULTADOS)) then begin
            TextColor(Red);
            writelnCentrado('ERROR: No se pudo encontrar la grilla central.');
            writelnCentrado('Esta puede regenerarse con la opci¢n 1 del men£ de Administrador.');
            writeln();
            writeln();
            TextColor(LightGray);
            write('  Presione cualquier tecla para volver al men£ anterior...');
            readkey;
        end else begin
            repeat
                repetir:= false;
                write('  Ingrese el n£mero de partido a cargar: ');
                readln(input);
                n:= StrToIntDef(input,-1);
                if (length(input) = 0) then n:=-2;
                if n=-2 then begin
                    TextColor(C_ROJOCLARO);
                    writeln();
                    writeln();
                    writelnCentrado('Uno o ambos valores fueron env°ados en blanco. Operaci¢n cancelada.');
                    writeln();
                    TextColor(LightGray);
                    writeln();
                    k:= teclaConsulta(C_AZUL,'®Desea volver a ingresar un resultado?');
                    if k in ['s','S'] then begin
                        repetir:= true;
                        ClrScr;
                        printLogoMenu();
                        barraTitulo('Carga de resultado');
                        writeln();
                        writeln();
                    end;
                end else if (n<1) OR (n>MAX_PARTIDOS) then begin
                    k:= teclaConsulta(C_ROJO,'N£mero de partido fuera de rango, ®desea ingresar uno nuevamente?');
                    if k in ['s','S'] then begin
                        repetir:=true;
                        ClrScr;
                        printLogoMenu();
                        barraTitulo('Carga de resultado');
                        writeln();
                        writeln();
                    end;
                end else begin
                    salir:= false;
                    repeat
                        cargarTablaFixture(partidos);
                        cargarTablaProde(res);
                        writeln();
                        TextColor(Yellow);
                        write('    Partido ',n,': ',partidos[n].local,' - ',partidos[n].visitante);
                        TextColor(C_GRIS);
                        if (res[n].gol_l < 0) or (res[n].gol_v < 0) then writeln() else writeln(' (Resultado actual: ',res[n].gol_l,' - ',res[n].gol_v,')');
                        TextColor(LightGray);
                        writeln();
                        TextColor(Green);
                        repeat    
                            write('  ',partidos[n].local,': ');
                            readln(input);
                            AnsiReplaceText(input,'.','z');
                            i:= StrToIntDef(input,-1);
                            if (length(input)=0) then i:= -99;//Si el usuario manda entre sin ingresar nada, es que quiere cancelar.
                        until (i>=0) or (i=-99);
                        repeat    
                            write('  ',partidos[n].visitante,': ');
                            readln(input);
                            AnsiReplaceText(input,'.','z');
                            j:= StrToIntDef(input,-1);
                            if (length(input)=0) then j:= -99;
                        until (j>=0) or (j=-99);
                        TextColor(LightGray);
                        writeln();
                        if NOT((i = -99) or (j = -99)) then begin
                            writeln('  Usted ingres¢ el siguiente resultado: ',partidos[n].local,' ',i,' - ',partidos[n].visitante,' ',j);
                            conf:= false;
                            k:= teclaConsulta(C_CYAN,'®Es esto correcto?');
                            if k in ['s','S'] then begin
                                conf:= true;
                                cargarTablaProde(res);
                                assign(fres, ARCHIVO_RESULTADOS);
                                Rewrite(fres);
                                res[n].gol_l:= i;
                                res[n].gol_v:= j;
                                Write(fres,res);
                                close(fres);
                                writeln();
                                writeln();
                                TextColor(LightGreen);
                                writeln('    Resultado guardado con Çxito.');
                                TextColor(LightGray);
                                writeln();
                            end else begin
                                conf:= true;
                                writeln();
                                writeln();
                                k:= teclaConsulta(C_AZUL,'®Desea volver a ingresar el resultado?');
                                if k in ['n','N'] then salir:= true;
                            end;
                        end else begin
                            conf:= true;
                            TextColor(12);
                            writelnCentrado('Uno o ambos valores fueron env°ados en blanco. Operaci¢n cancelada.');
                            writeln();
                            TextColor(LightGray);
                        end;
                    until (conf = true);
                    if NOT(salir) then begin
                        repetir:= false;
                        k:= teclaConsulta(C_AZUL,'®Desea agregar otro resultado?');
                        if k in ['s','S'] then begin
                            repetir:= true;
                            ClrScr;
                            printLogoMenu();
                            barraTitulo('Carga de resultado');
                            writeln();
                            writeln();
                        end;
                    end;
                end;
            until NOT (repetir);
        end;
    end;
procedure listarUsuarios();
    var
        usuarios: tUsuarios;
        f: file of tUsuarios;
        i,max: integer;
        maxalcanzado: boolean;
        s: string;
    begin
        ClrScr;
        printLogoMenu();
        if NOT(FileExists(ARCHIVO_USUARIOS)) then begin
            assign(f, ARCHIVO_USUARIOS);
            Rewrite(f);
            for i:=1 to MAX_USUARIOS do usuarios[i].nombre:='NULLUSER';
            Write(f, usuarios);
            barraTitulo('Listar Usuarios');
            writeln();
            writeln();
            TextColor(LightGreen);
            writelnCentrado('Base de datos de usuarios no encontrada. Se ha creado una en blanco.');
        end else begin
            cargarTablaUsuarios(usuarios);
            i:=1;
            maxalcanzado:=false;
            while (i < MAX_USUARIOS) AND (NOT maxalcanzado) do if usuarios[i].nombre='NULLUSER' then maxalcanzado:=true else i:=i+1;
            max:= i;
            if max=1 then begin
                barraTitulo('Listar Usuarios');
                writeln();
                writeln();
                TextColor(Red);
                writelnCentrado('No hay usuarios registrados en el sistema.');
            end else begin
                if (max mod 10 = 0) then
                    s:='Listar Usuarios (1/'+inttostr(max div 10)+')'
                else
                    s:='Listar Usuarios (1/'+inttostr((max div 10)+1)+')';
                barraTitulo(s);
                writeln();
                ordenarUsuarios(usuarios);
                i:= 1;
                while (i <= max) and (usuarios[i].nombre<>'NULLUSER') do begin
                    writeln('  * ',usuarios[i].nombre);
                    i:= i+1;
                    if (i < max) AND (i mod 10 = 1) then begin
                        writeln();
                        writeln();
                        TextColor(C_AMARILLO);
                        write('  Presione cualquier tecla para mostrar la siguiente p†gina...');
                        TextColor(LightGray);
                        readkey;
                        ClrScr;
                        printLogoMenu();
                        if (max mod 10 = 0) then
                            s:='Listar Usuarios ('+inttostr((i div 10)+1)+'/'+inttostr(max div 10)+')'
                        else
                            s:='Listar Usuarios ('+inttostr((i div 10)+1)+'/'+inttostr((max div 10)+1)+')';
                        barraTitulo(s);
                        writeln();
                    end;
                end;
            end;
        end;
        writeln();
        writeln();
        TextColor(LightGray);
        write('  Presione cualquier tecla para volver al men£ anterior...');
        readkey;
    end;
procedure agregarUsuario();
    var
        usuarios: tUsuarios;
        f: file of tUsuarios;
        i,j: integer;
        maxalcanzado,nickenuso,charvalidos,agregado: boolean;
        usuarioIng,s: string;
    begin
        ClrScr;
        printLogoMenu();
        barraTitulo('Agregar Usuario');
        writeln();
        writeln();
        if NOT(FileExists(ARCHIVO_FIXTURE)) then begin
            TextColor(Red);
            writelnCentrado('No se pueden crear usuarios hasta que se cargue el fixture.');
            writeln();
            writeln();
        end else begin
            assign(f, ARCHIVO_USUARIOS);
            if NOT(FileExists(ARCHIVO_USUARIOS)) then begin
                Rewrite(f);
                for i:=1 to MAX_USUARIOS do usuarios[i].nombre:='NULLUSER';
                Write(f, usuarios);
                TextColor(LightGreen);
                writelnCentrado('Base de datos de usuarios no encontrada. Se ha creado una en blanco.');
                writeln();
                writeln();
                writeln();
                TextColor(LightGray);
                write('  Presione cualquier tecla para continuar...');
                readkey;
                ClrScr;
                printLogoMenu();
                barraTitulo('Agregar Usuario');
                writeln();
                writeln();
            end;
            reset(f);
            read(f,usuarios);
            i:=1;
            maxalcanzado:=true;
            while (i <= MAX_USUARIOS) AND (maxalcanzado) do begin
                if usuarios[i].nombre='NULLUSER' then maxalcanzado:=false;
                i:=i+1;
            end;
            if (maxalcanzado) then begin
                TextColor(Red);
                writelnCentrado('Ya se alcanz¢ el l°mite m†ximo de usuarios para el sistema.');
                writeln();
                writeln();
            end else begin
                TextColor(White);
                write('  Por favor, ingrese un nuevo nombre de usuario: ');
                TextColor(LightGray);
                readln(usuarioIng);
                ClrScr;
                printLogoMenu();
                barraTitulo('Agregar Usuario');
                writeln();
                writeln();
                if UpperCase(usuarioIng)='NULLUSER' then begin
                    TextColor(Red);
                    writelnCentrado('ERROR: No se puede usar el nombre "NULLUSER", esta reservado por el sistema.');
                    writeln();
                    writeln();
                end else begin
                    usuarioIng:= UpperCase(usuarioIng);
                    nickenuso:=false;{Ac† se revisa que no exista el nombre de usuario en la DB}
                    for i:=1 to MAX_USUARIOS do if (usuarios[i].nombre)=(usuarioIng) then nickenuso:=true;
                    if nickenuso then begin
                        TextColor(Red);
                        writelnCentrado('El nombre de usuario ya se encuentra en el sistema.');
                        writeln();
                        writeln();
                    end else begin
                        charvalidos:= true;
                        for i:=1 to length(usuarioIng) do IF NOT(usuarioIng[i] in ['a'..'z','A'..'Z','0'..'9']) then charvalidos:=false;
                        if Length(usuarioIng)>10 then begin {Revisar largo del nombre ingresado}
                            TextColor(Red);
                            writelnCentrado('El nombre de usuario no puede superar los 10 caracteres.');
                            writeln();
                            writeln();
                        end else if Length(usuarioIng)=0 then begin {Revisar largo del nombre ingresado}
                            TextColor(Red);
                            writelnCentrado('Error: No ha ingresado un usuario valido.');
                            writeln();
                            writeln();
                        end else if NOT(charvalidos) then begin {Revisar largo del nombre ingresado}
                            TextColor(Red);
                            writelnCentrado('Error: Ha ingresado caracteres no validos');
                            writelnCentrado('Solo pueden usarse caracteres alfanumÇricos [a-Z,0-9]');
                            writeln();
                        end else begin {Agregar el usuario al archivo}
                            i:= 1;
                            agregado:= false;
                            while (NOT agregado) AND (i<=length(usuarios)) do begin
                                if (usuarios[i].nombre = 'NULLUSER') then begin
                                    usuarios[i].nombre:= usuarioIng;
                                    for j:=1 to MAX_PARTIDOS do begin
                                        usuarios[i].prode[j].gol_l:= -1;
                                        usuarios[i].prode[j].gol_v:= -1;
                                    end;
                                    agregado:= true;
                                end else i:= i+1;
                            end;
                            if agregado then begin
                                Rewrite(f);
                                Write(f, usuarios);
                                s:= 'Usuario '+usuarioIng+' creado con Çxito.';
                                TextColor(LightGreen);
                                for i:=1 to ((80-length(s)) div 2) do write(' ');
                                writeln(s);
                                writeln();
                                writeln();
                            end else begin
                                TextColor(Red);
                                writelnCentrado('Error inesperado. No hay mas lugar, o algo raro pas¢.');
                                writelnCentrado('Por favor, contacte a un administrador.');
                                writeln();
                            end;
                            {...}
                        end;
                    end;
                end;
            end;
            Close(f);
        end;

        writeln();
        TextColor(LightGray);
        write('  Presione cualquier tecla para volver al men£ anterior...');
        readkey;
    end;
procedure cargadorFixture();
    var
        i,j: byte;
    begin
        ClrScr;
        printLogoMenu();
        barraTitulo('Carga de Fixture');
        writeln();
        writeln();
        if NOT(FileExists(ARCHIVO_FIXTURE)) or NOT(FileExists(ARCHIVO_RESULTADOS)) then begin
            TextColor(LightGreen);
            j:= 0;
            if NOT(FileExists(ARCHIVO_FIXTURE)) then begin
                resetearFixture();
                writelnCentrado('≠Fixture cargado con Çxito!');
                j:= j+1;
            end;
            if NOT(FileExists(ARCHIVO_RESULTADOS)) then begin
                resetearResultados();
                writelnCentrado('≠Grilla Central creada con Çxito!');
                j:= j+1;
            end;
            for i:=1 to j do writeln();
        end else begin
            TextColor(Yellow);
            writelnCentrado('Ya se ha preparado el fixture y');
            writelnCentrado('la grilla central, no puede hacerse de nuevo.');
            writeln();
        end;
        TextColor(LightGray);
        write('  Presione cualquier tecla para continuar...');
        readkey;
    end;
procedure menuAdmin();//Menu presentado al administrador
    var
        opcion:char;
    begin
        opcion:='0';
        repeat
            ClrScr;
            printLogoMenu();
            barraTitulo('Menu de Administrador');
            writeln();
            writeln();
            writeln('    1: Cargar fixture del torneo');
            writeln('    2: Agregar usuarios');
            writeln('    3: Listar usuarios');
            writeln('    4: Cargar resultado de un partido');
            writeln('    5: Listar partidos');
            writeln('    0: Volver al men£ principal');
            writeln();
            if NOT(opcion in ['0'..'5']) then barraError()
            {else if (opcion in ['4']) then barraProximamente()}
            else begin
                writeln();
                writeln();
            end;
            write('  Ingrese su opci¢n: ');
            opcion:=readkey;
            case opcion of
                '1': cargadorFixture;
                '2': agregarUsuario;
                '3': listarUsuarios;
                '4': cargarResultado;
                '5': listarPartidos;
            end;
        until (opcion='0');
    end;
procedure listarProde(id: integer);
    var
        partidos: tFixture;
        usuarios: tUsuarios;
        res: tProde;
        i,j,jmax: integer;
        cambio,np: boolean;
        s,instancia: string;
    begin
        ClrScr;
        printLogoMenu();
        cargarTablaUsuarios(usuarios);//No reviso que exista el arhivo primero, total solo se puede acceder bajo esa condicion.
        s:= 'Listar Prode - ';
        s:= s+usuarios[id].nombre;
        if NOT(FileExists(ARCHIVO_FIXTURE)) then begin
            barraTitulo(s);
            writeln();
            writeln();
            TextColor(Red);
            writelnCentrado('Error: todav°a no hay un fixture cargado que mostrar.');
            writeln();
            writeln();
        end else if NOT(FileExists(ARCHIVO_RESULTADOS)) then begin
            barraTitulo(s);
            writeln();
            writeln();
            TextColor(Red);
            writelnCentrado('ERROR: No se pudo encontrar la grilla central.');
            writelnCentrado('Por favor, reporte este error a su administrador.');
            writeln();
        end else begin
            cargarTablaFixture(partidos);
            cargarTablaProde(res);
            i:= 1;
            jmax:= 1;
            instancia:= 'Nada';
            while (i <= MAX_PARTIDOS) do begin
                jmax:= jmax+1;
                if (instancia<>partidos[i].instancia) then begin
                    jmax:= jmax+3;
                    instancia:= partidos[i].instancia;
                end;
                i:= i+1;
            end;
            i:= 1;
            j:= 1;
            np:= false;
            while (i <= MAX_PARTIDOS) do begin
                if ((j mod 9 = 1) OR (np)) then begin
                    np:= false;
                    ClrScr;
                    printLogoMenu();
                    TextBackground(LightGray);
                    TextColor(Black);
                    s:=s+' ('+inttostr((j div 9)+1)+'/'+inttostr(jmax div 9)+')';
                    barraTitulo(s);
                    writeln();
                    TextColor(LightGray);
                    TextBackground(Black);
                    instancia:= partidos[i].instancia;
                    writeln('  ',instancia);
                    writeln();
                end;
                cambio:= false;
                if (instancia<>partidos[i].instancia) then begin
                    instancia:= partidos[i].instancia;
                    writeln();
                    writeln('  ',instancia);
                    writeln();
                    j:= j+3;
                end;
                if (i < MAX_PARTIDOS) AND (instancia<>partidos[i+1].instancia) then cambio:= true;
                write('    ',i,': ',partidos[i].local,' - ',partidos[i].visitante);
                TextColor(C_GRIS);
                if NOT((usuarios[id].prode[i].gol_l<0) OR (usuarios[id].prode[i].gol_v<0)) then write(' (',usuarios[id].prode[i].gol_l,'-',usuarios[id].prode[i].gol_v,')');
                if NOT((res[i].gol_l<0) OR (res[i].gol_v<0)) then write(' [',res[i].gol_l,'-',res[i].gol_v,']');
                if NOT((usuarios[id].prode[i].gol_l<0) OR (usuarios[id].prode[i].gol_v<0)) AND NOT((res[i].gol_l<0) OR (res[i].gol_v<0)) then write(' (',puntajePartido(id,i,usuarios,res),')');
                writeln();
                TextColor(LightGray);
                if (i < MAX_PARTIDOS) AND ((j mod 9 = 0) OR (cambio AND (j mod 9 >5))) then begin
                    writeln();
                    TextColor(C_AMARILLO);
                    write('  Presione cualquier tecla para mostrar la siguiente pagina...');
                    TextColor(LightGray);
                    np:= true;
                    if j mod 9 <> 0 then j:= j+(9-(j mod 9));
                    readkey;
                end;
                i:= i+1;
                j:= j+1;
                if (i > MAX_PARTIDOS) then begin
                    writeln();
                    writeln();
                    writeln();
                    writeln();
                end;
            end;
        end;
        writeln();
        TextColor(LightGray);
        write('  Presione cualquier tecla para volver al men£ anterior...');
        readkey;
    end;
procedure modifPartido(id: integer);//WIP
    var
        partidos: tFixture;
        usuarios: tUsuarios;
        f: file of tUsuarios;
        res: tProde;
        n,i,j: integer;
        k: char;
        repetir,conf,salir: boolean;
        input: string;
    begin
        ClrScr;
        printLogoMenu();
        cargarTablaUsuarios(usuarios);
        barraTitulo('Modificar Partido - '+usuarios[id].nombre);
        writeln();
        writeln();
        if NOT(FileExists(ARCHIVO_FIXTURE)) then begin
            TextColor(Red);
            writelnCentrado('No puede subirse un resultado si no hay un fixture cargado.');
            writeln();
            writeln();
            writeln();
            TextColor(LightGray);
            write('  Presione cualquier tecla para volver al men£ anterior...');
            readkey;
        end else if NOT(FileExists(ARCHIVO_RESULTADOS)) then begin
            TextColor(Red);
            writelnCentrado('ERROR: No se pudo encontrar la grilla central.');
            writelnCentrado('Por favor, reporte este error a su administrador.');
            writeln();
            writeln();
            TextColor(LightGray);
            write('  Presione cualquier tecla para volver al men£ anterior...');
            readkey;
        end else begin
            cargarTablaProde(res);
            cargarTablaFixture(partidos);
            repeat
                repetir:= false;
                write('  Ingrese el n£mero de partido a modificar: ');
                readln(input);
                n:= StrToIntDef(input,-1);
                if (length(input) = 0) then n:=-2;
                writeln();
                if n=-2 then begin
                    k:= teclaConsulta(C_ROJO,'No se ingres¢ ning£n n£mero de partido. ®Desea ingresar uno nuevamente?');
                    if k in ['s','S'] then begin
                        repetir:= true;
                        ClrScr;
                        printLogoMenu();
                        barraTitulo('Modificar Partido - '+usuarios[id].nombre);
                        writeln();
                        writeln();
                    end;
                end else if (n<1) OR (n>MAX_PARTIDOS) then begin
                    k:= teclaConsulta(C_ROJO,'N£mero de partido fuera de rango. ®Desea ingresar uno nuevamente?');
                    if k in ['s','S'] then begin
                        repetir:=true;
                        ClrScr;
                        printLogoMenu();
                        barraTitulo('Modificar Partido - '+usuarios[id].nombre);
                        writeln();
                        writeln();
                    end;
                end else if NOT((res[n].gol_l < 0) or (res[n].gol_v < 0)) then begin
                    k:= teclaConsulta(C_ROJO,'Ya no se puede modificar ese partido. ®Desea ingresar uno nuevamente?');
                    if k in ['s','S'] then begin
                        repetir:=true;
                        ClrScr;
                        printLogoMenu();
                        barraTitulo('Modificar Partido - '+usuarios[id].nombre);
                        writeln();
                        writeln();
                    end;
                end else begin
                    salir:= false;
                    repeat
                        TextColor(Yellow);
                        write('    Partido ',n,': ',partidos[n].local,' - ',partidos[n].visitante);
                        TextColor(C_GRIS);
                        if (usuarios[id].prode[n].gol_l < 0) or (usuarios[id].prode[n].gol_v < 0) then writeln() else writeln(' (Predicci¢n actual: ',usuarios[id].prode[n].gol_l,' - ',usuarios[id].prode[n].gol_v,')');
                        TextColor(LightGray);
                        writeln();
                        TextColor(Green);
                        repeat    
                            write('  ',partidos[n].local,': ');
                            readln(input);
                            AnsiReplaceText(input,'.','z');
                            i:= StrToIntDef(input,-1);
                            if (length(input)=0) then i:= -99;//Si el usuario manda entre sin ingresar nada, es que quiere cancelar.
                        until (i>=0) or (i=-99);
                        repeat    
                            write('  ',partidos[n].visitante,': ');
                            readln(input);
                            AnsiReplaceText(input,'.','z');
                            j:= StrToIntDef(input,-1);
                            if (length(input)=0) then j:= -99;
                        until (j>=0) or (j=-99);
                        TextColor(LightGray);
                        writeln();
                        if NOT((i = -99) or (j = -99)) then begin
                            writeln('  Usted ingres¢ la siguiente predicci¢n: ',partidos[n].local,' ',i,' - ',partidos[n].visitante,' ',j);
                            conf:= false;
                            k:= teclaConsulta(C_CYAN,'®Es esto correcto?');
                            if k in ['s','S'] then begin
                                conf:= true;
                                assign(f, ARCHIVO_USUARIOS);
                                Rewrite(f);
                                usuarios[id].prode[n].gol_l:= i;
                                usuarios[id].prode[n].gol_v:= j;
                                Write(f,usuarios);
                                close(f);
                                writeln();
                                writeln();
                                TextColor(LightGreen);
                                writeln('    Predicci¢n guardada con Çxito.');
                                TextColor(LightGray);
                                writeln();
                            end else begin
                                conf:= true;
                                writeln();
                                writeln();
                                k:= teclaConsulta(C_AZUL,'®Desea volver a ingresar la predicci¢n?');
                                if k in ['n','N'] then salir:= true;
                            end;
                        end else begin
                            conf:= true;
                            TextColor(12);
                            writelnCentrado('Uno o ambos valores fueron env°ados en blanco. Operaci¢n cancelada.');
                            writeln();
                            TextColor(LightGray);
                        end;
                        writeln();
                    until (conf = true);
                    if NOT(salir) then begin
                        repetir:= false;
                        k:= teclaConsulta(C_AZUL,'®Desea agregar otra predicci¢n?');
                        if k in ['s','S'] then begin
                            repetir:= true;
                            ClrScr;
                            printLogoMenu();
                            barraTitulo('Modificar Partido - '+usuarios[id].nombre);
                            writeln();
                            writeln();
                        end;
                    end;
                end;
            until NOT (repetir);
        end;
    end;
procedure tablaPosiciones(id: integer);
    var
        partidos: tFixture;
        usuarios: tUsuarios;
        res: tProde;
        i,imax,imod: integer;
        maxalcanzado,completo: boolean;
        s: string;
    begin
        ClrScr;
        printLogoMenu();
        cargarTablaUsuarios(usuarios);
        i:=1;
        maxalcanzado:=false;
        while (i < MAX_USUARIOS) AND (NOT maxalcanzado) do if usuarios[i].nombre='NULLUSER' then maxalcanzado:=true else i:=i+1;
        imax:= i;
        i:= 1;
        if (imax mod PUESTOS_POR_HOJA_RANKING = 0) then
            s:='Tabla de Posiciones (1/'+inttostr(imax div PUESTOS_POR_HOJA_RANKING)+')'
        else
            s:='Tabla de Posiciones (1/'+inttostr((imax div PUESTOS_POR_HOJA_RANKING)+1)+')';
        barraTitulo(s);
        writeln();
        if NOT(FileExists(ARCHIVO_FIXTURE)) then begin
            TextColor(Red);
            writelnCentrado('Error: todav°a no hay un fixture cargado que mostrar.');
            writeln();
            writeln();
        end else if NOT(FileExists(ARCHIVO_RESULTADOS)) then begin
            TextColor(Red);
            writelnCentrado('ERROR: No se pudo encontrar la grilla central.');
            writelnCentrado('Por favor, reporte este error a su administrador.');
            writeln();
        end else begin
            cargarTablaFixture(partidos);
            cargarTablaProde(res);
            rankingJugadores(usuarios,res);//Revisando
            completo:= false;
            writeln('  ⁄ƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒø');
            writeln('  ≥ Ubicaci¢n ≥   Nombre   ≥  Puntaje  ≥');
            writeln('  √ƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒ¥');
            while (i <= MAX_USUARIOS) and NOT(completo) do begin
                lineaTabla(usuarios,res,i,completo,usuarios[id].nombre);
                i:= i+1;
                if (completo) or (i mod PUESTOS_POR_HOJA_RANKING = 1) then writeln('  ¿ƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒŸ') else writeln('  √ƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒ¥');
                if (i mod PUESTOS_POR_HOJA_RANKING = 1) and (i<imax) then begin
                    writeln();
                    TextColor(C_AMARILLO);
                    write('  Presione cualquier tecla para mostrar la siguiente pagina...');
                    TextColor(LightGray);
                    readkey;
                    ClrScr;
                    printLogoMenu();
                    if (imax mod PUESTOS_POR_HOJA_RANKING = 0) then
                        s:='Tabla de Posiciones ('+inttostr((i div PUESTOS_POR_HOJA_RANKING)+1)+'/'+inttostr(imax div PUESTOS_POR_HOJA_RANKING)+')'
                    else
                        s:='Tabla de Posiciones ('+inttostr((i div PUESTOS_POR_HOJA_RANKING)+1)+'/'+inttostr((imax div PUESTOS_POR_HOJA_RANKING)+1)+')';
                        barraTitulo(s);
                    writeln();
                    writeln('  ⁄ƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒø');
                    writeln('  ≥ Ubicaci¢n ≥   Nombre   ≥  Puntaje  ≥');
                    writeln('  √ƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒ¥');
                end;
            end;
        end;
        writeln();
        TextColor(LightGray);
        write('  Presione cualquier tecla para volver al men£ anterior...');
        readkey;
    end;
procedure menuJugador(id: integer);//Menu presentado a cada jugador.
    var
        opcion:char;
        s:string;
        usuarios: tUsuarios;
    begin
        opcion:='0';
        repeat
            ClrScr;
            printLogoMenu();
            cargarTablaUsuarios(usuarios);
            s:= 'Menu de Jugador - ';
            s:= s+usuarios[id].nombre;//Insertar nombre ingresado al final
            barraTitulo(s);
            writeln();
            writeln();
            writeln('    1: Mi Prode');
            writeln('    2: Modificar Partido');
            writeln('    3: Ver tabla de posiciones');
            writeln('    0: Volver al men£ principal');
            writeln();
            if NOT(opcion in ['0'..'3']) then barraError()
            {else if (opcion in ['2'..'3']) then barraProximamente()}
            else begin
                writeln();
                writeln();
            end;
            write('  Ingrese su opci¢n: ');
            opcion:=readkey;
            case opcion of
                '1': listarProde(id);
                '2': modifPartido(id);
                '3': tablaPosiciones(id);
            end;
        until (opcion='0');
    end;
procedure loginJugador();
    var
        usuarios: tUsuarios;
        f: file of tUsuarios;
        nombreIng: string;
        i: integer;
        nombrevalido,repetir: boolean;
        k: char;
    begin
        repeat
            ClrScr;
            printLogoMenu();
            barraTitulo('Login de Jugador');
            writeln();
            writeln();
            repetir:= false;
            if NOT(FileExists(ARCHIVO_USUARIOS)) then begin
                assign(f, ARCHIVO_USUARIOS);
                Rewrite(f);
                for i:=1 to MAX_USUARIOS do usuarios[i].nombre:='NULLUSER';
                Write(f, usuarios);
                TextColor(LightGreen);
                writelnCentrado('Base de datos de usuarios no encontrada. Se ha creado una en blanco.');
                Close(f);
                writeln();
                writeln();
                TextColor(LightGray);
                write('  Presione cualquier tecla para volver al men£ anterior...');
                readkey;
            end else begin
                write('  Ingrese su nombre de usuario: ');
                readln(nombreIng);
                nombreIng:= UpperCase(nombreIng);
                cargarTablaUsuarios(usuarios);
                nombrevalido:= false;
                i:= 1;
                while (nombreIng <> 'NULLUSER') AND (i <= length(usuarios)) AND NOT(nombrevalido) do begin
                    if (usuarios[i].nombre = nombreIng) then nombrevalido:= true else i:= i+1;
                end;
                if (nombrevalido) then begin
                    menuJugador(i);
                end else begin
                    writeln();
                    TextColor(LightGray);
                    writeln();
                    k:= teclaConsulta(C_ROJO,'Nombre de usuario incorrecto. ®Desea intentarlo nuevamente?');
                    if k in ['s','S'] then begin
                        repetir:= true;
                        ClrScr;
                        printLogoMenu();
                        barraTitulo('Carga de resultado');
                        writeln();
                        writeln();
                    end;
                end;
            end;
        until NOT(repetir);
    end;
procedure menuInicial();//Menu inicial
    var
        opcion:char;
    begin
        opcion:='0';
        repeat
            repeat
                ClrScr;
                printLogoMenu();
                barraTitulo('≠Bienvenido a PascalProde!');
                barraTitulo('Por favor, ingrese el n£mero correspondiente a la opci¢n deseada.');
                writeln();
                writeln('    1: Ingresar como Administrador');
                writeln('    2: Ingresar como Jugador');
                writeln('    3: Demo de Colores');
                writeln('    0: Salir');
                writeln();
                if NOT(opcion in ['0'..'3']) then barraError()
                else begin
                    writeln();
                    writeln();
                end;
                write('  Ingrese su opci¢n: ');
                opcion:=readkey;
            until opcion in ['0'..'3'];
            case opcion of
                '1': menuAdmin();
                '2': loginJugador();
                '3': democolores();
            end;
        until opcion='0';
        writeln();
        writeln();
        TextBackground(Green);
        writeln('                                                                               ');
        TextColor(Black);
        writeln('                                     ≠Adios!                                   ');
        writeln('                                                                               ');
        delay(1000);
    end;

begin
    ClrScr;
    printLogoIntro();
    Delay(DELAY_POST_INTRO);
    barraCualquiera(C_VIOLETA,'Presione cualquier tecla para continuar...');
    readkey;
    menuInicial();
end.
