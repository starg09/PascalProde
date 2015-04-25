Program prode;
uses strutils,sysutils,crt,cargarFixture;
const
    MAX_USUARIOS = 20;
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
    C_AMARILLOCLARO = 14;
    C_BLANCO = 15;
    //Ancho de la pantalla. Usado para centrar textos, o hacer barras de titulo o coloreadas
    //(Maximo default en consola de Windows: 80)
    ANCHO_PANTALLA = 80
type
    rGoles = record
        gol_l: integer;
        gol_v: integer;
        end;
    rUsuarios = record
        nombre: string;
        prode: array[1..MAX_PARTIDOS] of rGoles;
        end;
    tUsuarios = array[1..MAX_USUARIOS] of rUsuarios;
    tProde = array[1..MAX_PARTIDOS] of rGoles;
    tPuntos = array[1..MAX_USUARIOS] of byte;
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
procedure barraTitulo(linea: string);//Muestra una barra de titulo con fondo gris
    var
        i: byte;
    begin
        TextBackground(LightGray);
        TextColor(Black);
        write('  ');
        write(linea);
        for i:=1 to (78-length(linea)) do write(' ');
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
        for i:=1 to (77-length(linea)) do write(' ');
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
function puntajePartido(id,n:integer): integer;
    var
        usuarios: tUsuarios;
        fusuarios: file of tUsuarios;
        res: tProde;
        fres: file of tProde;
        i,p1,p2,r1,r2: integer;
    begin
        assign(fusuarios, ARCHIVO_USUARIOS);
        reset(fusuarios);
        read(fusuarios,usuarios);
        Close(fusuarios);
        assign(fres, ARCHIVO_RESULTADOS);
        reset(fres);
        read(fres,res);
        Close(fres);
        i:= 0;
        if (res[n].gol_l < res[n].gol_v) then p1:=0 else if(res[n].gol_l > res[n].gol_v) then p1:=2 else p1:=1;
        if (usuarios[id].prode[n].gol_l < usuarios[id].prode[n].gol_v) then p2:=0 else if(usuarios[id].prode[n].gol_l > usuarios[id].prode[n].gol_v) then p2:=2 else p2:=1;
        if (p1=p2) then i:=i+2;
        if (usuarios[id].prode[n].gol_l = res[n].gol_l) then i:= i+1;
        if (usuarios[id].prode[n].gol_v = res[n].gol_v) then i:= i+1;
        r1:= usuarios[id].prode[n].gol_l - usuarios[id].prode[n].gol_v;
        r2:= res[n].gol_l - res[n].gol_v;
        if (r1=r2) then i:= i+1;
        puntajePartido:= i;
    end;
procedure democolores();//A remover antes de mandar final
    var
        k:char;
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
        k:=readkey;
    end;
procedure listarPartidos();
    var
        partidos: tFixture;
        f: file of tFixture;
        res: tProde;
        fres: file of tProde;
        i,j,max,jmax: integer;
        maxalcanzado,cambio,np: boolean;
        instancia: string;
        s: ansistring;
    begin
        ClrScr;
        printLogoMenu();
        if NOT(FileExists(ARCHIVO_FIXTURE)) then begin
            barraTitulo('Listar Partidos');
            writeln();
            writeln();
            TextColor(Red);
            writeln('              Error: todav°a no hay un fixture cargado que mostrar.');
            writeln();
            writeln();
        end else begin
            if NOT(FileExists(ARCHIVO_RESULTADOS)) then begin
                barraTitulo('Listar Partidos');
                writeln();
                writeln();
                TextColor(Red);
                writeln('            Error: resultados corruptos. (POR FAVOR, REPORTAR EL BUG)');
                writeln();
                writeln();
            end else begin
                assign(f, ARCHIVO_FIXTURE);
                reset(f);
                read(f,partidos);
                assign(fres, ARCHIVO_RESULTADOS);
                reset(fres);
                read(fres,res);
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
                while (i <= MAX_PARTIDOS) do begin
                    if ((j mod 9 = 1) OR (np)) then begin
                        np:= false;
                        ClrScr;
                        printLogoMenu();
                        TextBackground(LightGray);
                        TextColor(Black);
                        s:='Listar Usuarios (';
                        appendstr(s,inttostr((j div 9)+1));
                        appendstr(s,'/');
                        appendstr(s,inttostr(jmax div 9));
                        appendstr(s,')');
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
                        TextColor(6);
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
            Close(f);
            Close(fres);
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
        f: file of tFixture;
        res: tProde;
        fres: file of tProde;
        n,i,j: integer;
        k: char;
        repetir,pv,conf,salir: boolean;
        input: string;
    begin
        ClrScr;
        printLogoMenu();
        barraTitulo('Carga de resultado');
        writeln();
        writeln();
        if NOT(FileExists(ARCHIVO_FIXTURE)) then begin
            TextColor(Red);
            writeln('           No puede subirse un resultado si no hay un fixture cargado.');
            writeln();
            writeln();
            writeln();
            TextColor(LightGray);
            write('  Presione cualquier tecla para volver al men£ anterior...');
            readkey;
        end
        else begin
            repeat
                repetir:= false;
                write('  Ingrese el n£mero de partido a cargar: ');
                readln(input);
                n:= StrToIntDef(input,-1);
                if (length(input) = 0) then n:=-2;
                if n=-2 then begin
                    TextColor(12);
                    writeln();
                    writeln();
                    writeln('  Uno o ambos valores fueron env°ados en blanco. Operaci¢n cancelada.');
                    writeln();
                    TextColor(LightGray);
                    writeln();
                    barraCualquiera(1,'®Desea volver a ingresar un resultado? [S/N]');
                    k:= readkey;
                    while NOT(k in ['s','n','S','N']) do begin
                        GotoXY(1,WhereY);
                        clreol;
                        barraCualquiera(15,'®Desea volver a ingresar un resultado? [S/N]');
                        delay(50);
                        GotoXY(1,WhereY);
                        clreol;
                        barraCualquiera(1,'®Desea volver a ingresar un resultado? [S/N]');
                        k:= readkey;
                    end;
                    if k in ['s','S'] then begin
                        repetir:= true;
                        ClrScr;
                        printLogoMenu();
                        barraTitulo('Carga de resultado');
                        writeln();
                        writeln();
                    end;
                end else if (n<1) OR (n>MAX_PARTIDOS) then begin
                    repeat
                        GotoXY(1,WhereY);
                        clreol;
                        barraCualquiera(15,'N£mero de partido fuera de rango, ®desea ingresar uno nuevamente? [S/N]');
                        delay(50);
                        GotoXY(1,WhereY);
                        clreol;
                        barraCualquiera(4,'N£mero de partido fuera de rango, ®desea ingresar uno nuevamente? [S/N]');
                        k:=readkey;
                    until k in ['s','n','S','N'];
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
                        assign(f, ARCHIVO_FIXTURE);
                        reset(f);
                        read(f,partidos);
                        assign(fres, ARCHIVO_RESULTADOS);
                        reset(fres);
                        while not eof(fres) do read(fres,res);
                        close(fres);
                        writeln();
                        TextColor(Yellow);
                        write('    Partido ',n,': ',partidos[n].local,' - ',partidos[n].visitante);
                        TextColor(8);
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
                            barraCualquiera(3,'®Es esto correcto? [S/N]');
                            k:= readkey;
                            while NOT(k in ['s','n','S','N']) do begin
                                GotoXY(1,WhereY);
                                clreol;
                                barraCualquiera(15,'®Es esto correcto? [S/N]');
                                delay(50);
                                GotoXY(1,WhereY);
                                clreol;
                                barraCualquiera(3,'®Es esto correcto? [S/N]');
                                k:= readkey;
                            end;
                            if k in ['s','S'] then begin
                                conf:= true;
                                assign(fres, ARCHIVO_RESULTADOS);
                                reset(fres);
                                while not eof(fres) do read(fres,res);
                                close(fres);
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
                                barraCualquiera(1,'®Desea volver a ingresar el resultado? [S/N]');
                                k:= readkey;
                                while NOT(k in ['s','n','S','N']) do begin
                                    GotoXY(1,WhereY);
                                    clreol;
                                    barraCualquiera(15,'®Desea volver a ingresar el resultado? [S/N]');
                                    delay(50);
                                    GotoXY(1,WhereY);
                                    clreol;
                                    barraCualquiera(1,'®Desea volver a ingresar el resultado? [S/N]');
                                    k:= readkey;
                                end;
                                if k in ['n','N'] then salir:= true;
                            end;
                        end else begin
                            conf:= true;
                            TextColor(12);
                            writeln('  Uno o ambos valores fueron env°ados en blanco. Operaci¢n cancelada.');
                            writeln();
                            TextColor(LightGray);
                        end;
                        close(f);
                    until (conf = true);
                    if NOT(salir) then begin
                        repetir:= false;
                        barraCualquiera(1,'®Desea agregar otro resultado? [S/N]');
                        k:= readkey;
                        while NOT(k in ['s','n','S','N']) do begin
                            GotoXY(1,WhereY);
                            clreol;
                            barraCualquiera(15,'®Desea agregar otro resultado? [S/N]');
                            delay(50);
                            GotoXY(1,WhereY);
                            clreol;
                            barraCualquiera(1,'®Desea agregar otro resultado? [S/N]');
                            k:= readkey;
                        end;
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
            {assign(f, ARCHIVO_FIXTURE);
            Rewrite(f);
            cargar_fixture(fixture);
            Write(f,fixture);
            Close(f);
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
            TextColor(LightGreen);
            writeln('                           ≠Fixture cargado con Çxito!');
            writeln();
            writeln();}
        end;
    end;
procedure listarUsuarios();
    var
        usuarios: tUsuarios;
        f: file of tUsuarios;
        i,j,l,lmax,max: integer;
        maxalcanzado,mayor,nickenuso,agregado: boolean;
        s: ansistring;
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
            writeln('      Base de datos de usuarios no encontrada. Se ha creado una en blanco.');
        end else begin
            assign(f, ARCHIVO_USUARIOS);
            reset(f);
            read(f,usuarios);
            i:=1;
            maxalcanzado:=false;
            while (i <= MAX_USUARIOS) AND (NOT maxalcanzado) do if usuarios[i].nombre='NULLUSER' then maxalcanzado:=true else i:=i+1;
            max:= i;
            if max=1 then begin
                barraTitulo('Listar Usuarios');
                writeln();
                writeln();
                TextColor(Red);
                writeln('                   No hay usuarios registrados en el sistema.');
            end else begin
                s:='Listar Usuarios (1/';
                appendstr(s,inttostr((max div 10)+1));
                appendstr(s,')');
                barraTitulo(s);
                writeln();
                ordenarUsuarios(usuarios);
                i:= 1;
                while (i <= max) and (usuarios[i].nombre<>'NULLUSER') do begin
                    writeln('  * ',usuarios[i].nombre);
                    i:= i+1;
                    if (i mod 10 = 1) AND (i < max) then begin
                        writeln();
                        writeln();
                        TextColor(6);
                        write('  Presione cualquier tecla para mostrar la siguiente p†gina...');
                        TextColor(LightGray);
                        readkey;
                        ClrScr;
                        printLogoMenu();
                        s:='Listar Usuarios (';
                        appendstr(s,inttostr((i div 10)+1));
                        appendstr(s,'/');
                        appendstr(s,inttostr((max div 10)+1));
                        appendstr(s,')');
                        barraTitulo(s);
                        writeln();
                    end;
                end;
            end;
        end;
        Close(f);
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
            writeln('           No se pueden crear usuarios hasta que se cargue el fixture.');
            writeln();
            writeln();
        end else begin
            assign(f, ARCHIVO_USUARIOS);
            if NOT(FileExists(ARCHIVO_USUARIOS)) then begin
                Rewrite(f);
                for i:=1 to MAX_USUARIOS do usuarios[i].nombre:='NULLUSER';
                Write(f, usuarios);
                TextColor(LightGreen);
                writeln('      Base de datos de usuarios no encontrada. Se ha creado una en blanco.');
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
            if maxalcanzado then begin
                TextColor(Red);
                writeln('           Ya se alcanz¢ el l°mite m†ximo de usuarios para el sistema.');
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
                    writeln('  ERROR: No se puede usar el nombre "NULLUSER", esta reservado por el sistema.');
                    writeln();
                    writeln();
                end else begin
                    usuarioIng:= UpperCase(usuarioIng);
                    nickenuso:=false;{Ac† se revisa que no exista el nombre de usuario en la DB}
                    for i:=1 to MAX_USUARIOS do if (usuarios[i].nombre)=(usuarioIng) then nickenuso:=true;
                    if nickenuso then begin
                        TextColor(Red);
                        writeln('                El nombre de usuario ya se encuentra en el sistema.');
                        writeln();
                        writeln();
                    end else begin
                        charvalidos:= true;
                        for i:=1 to length(usuarioIng) do IF NOT(usuarioIng[i] in ['a'..'z','A'..'Z','0'..'9']) then charvalidos:=false;
                        if Length(usuarioIng)>10 then begin {Revisar largo del nombre ingresado}
                            TextColor(Red);
                            writeln('            El nombre de usuario no puede superar los 10 caracteres.');
                            writeln();
                            writeln();
                        end else if Length(usuarioIng)=0 then begin {Revisar largo del nombre ingresado}
                            TextColor(Red);
                            writeln('                    Error: No ha ingresado un usuario valido.');
                            writeln();
                            writeln();
                        end else if NOT(charvalidos) then begin {Revisar largo del nombre ingresado}
                            TextColor(Red);
                            writeln('                     Error: Ha ingresado caracteres no validos');
                            writeln('              Solo pueden usarse caracteres alfanumÇricos [a-Z,0-9]');
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
                                writeln('              Error inesperado. No hay mas lugar, o algo raro pas¢.');
                                writeln('                     Por favor, contacte a un administrador.');
                                writeln();
                            end;
                            {...}
                        end;
                    end;
                end;
            end;
            Close(f);
            {assign(f, ARCHIVO_USUARIOS);
            reset(f);
            read(f,usuarios);
            writeln();
            i:= 1;
            while i<=MAX_USUARIOS do 
            begin
                write(' User ',i,': ',usuarios[i]);
                i:= i+1;
            end;
            close(f);}
        end;

        writeln();
        TextColor(LightGray);
        write('  Presione cualquier tecla para volver al men£ anterior...');
        readkey;
    end;
procedure cargadorFixture();
    var
        fixture: tFixture;
        f: file of tFixture;
        res: tProde;
        fres: file of tProde;
        i: integer;
    begin
        ClrScr;
        printLogoMenu();
        barraTitulo('Carga de Fixture');
        writeln();
        writeln();
        if FileExists(ARCHIVO_FIXTURE) then begin
            TextColor(Yellow);
            writeln('             Ya se ha cargado el fixture, no puede hacerse de nuevo.');
            writeln();
            writeln();
        end
        else begin
            assign(f, ARCHIVO_FIXTURE);
            Rewrite(f);
            cargar_fixture(fixture);
            Write(f,fixture);
            Close(f);
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
            TextColor(LightGreen);
            writeln('                           ≠Fixture cargado con Çxito!');
            writeln();
            writeln();
        end;
        TextColor(LightGray);
        write('  Presione cualquier tecla para continuar...');
        readkey;
    end;
procedure menuAdmin();//Menu presentado al administrador
    var
        k:char;
    begin
        k:='0';
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
            if NOT(k in ['0'..'5']) then begin
                TextBackground(Red);
                TextColor(White);
                writeln('  ≠Opci¢n inv†lida!                                                             ');
                TextBackground(Black);
                TextColor(LightGray);
            end {else if (k in ['4']) then begin
                TextBackground(Cyan);
                TextColor(White);
                writeln('  Opci¢n no implementada...                                                     ');
                TextBackground(Black);
                TextColor(LightGray);
            end }else begin
                writeln();
                writeln();
            end;
            write('  Ingrese su opci¢n: ');
            k:=readkey;
            case k of
                '1': cargadorFixture;
                '2': agregarUsuario;
                '3': listarUsuarios;
                '4': cargarResultado;
                '5': listarPartidos;
            end;
        until (k='0');
    end;
procedure listarProde(id: integer);
    var
        partidos: tFixture;
        f: file of tFixture;
        usuarios: tUsuarios;
        fusuarios: file of tUsuarios;
        res: tProde;
        fres: file of tProde;
        i,j,max,jmax: integer;
        maxalcanzado,cambio,np: boolean;
        instancia: string;
        s,s2: ansistring;
    begin
        ClrScr;
        printLogoMenu();
        assign(fusuarios, ARCHIVO_USUARIOS);
        reset(fusuarios);
        read(fusuarios,usuarios);
        Close(fusuarios);
        s:= 'Listar Prode - ';
        appendstr(s,usuarios[id].nombre);
        if NOT(FileExists(ARCHIVO_FIXTURE)) then begin
            barraTitulo(s);
            writeln();
            writeln();
            TextColor(Red);
            writeln('              Error: todav°a no hay un fixture cargado que mostrar.');
            writeln();
            writeln();
        end else begin
            if NOT(FileExists(ARCHIVO_RESULTADOS)) then begin
                barraTitulo(s);
                writeln();
                writeln();
                TextColor(Red);
                writeln('            Error: resultados corruptos. (POR FAVOR, REPORTAR EL BUG)');
                writeln();
                writeln();
            end else begin
                assign(f, ARCHIVO_FIXTURE);
                reset(f);
                read(f,partidos);
                assign(fres, ARCHIVO_RESULTADOS);
                reset(fres);
                read(fres,res);
                assign(fusuarios, ARCHIVO_USUARIOS);
                reset(fusuarios);
                read(fusuarios,usuarios);
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
                while (i <= MAX_PARTIDOS) do begin
                    if ((j mod 9 = 1) OR (np)) then begin
                        np:= false;
                        ClrScr;
                        printLogoMenu();
                        TextBackground(LightGray);
                        TextColor(Black);
                        s2:=s;
                        appendstr(s2,' (');
                        appendstr(s2,inttostr((j div 9)+1));
                        appendstr(s2,'/');
                        appendstr(s2,inttostr(jmax div 9));
                        appendstr(s2,')');
                        barraTitulo(s2);
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
                    TextColor(8);
                    if NOT((usuarios[id].prode[i].gol_l<0) OR (usuarios[id].prode[i].gol_v<0)) then write(' (',res[i].gol_l,'-',res[i].gol_v,')');
                    if NOT((res[i].gol_l<0) OR (res[i].gol_v<0)) then write(' [',res[i].gol_l,'-',res[i].gol_v,']');
                    if NOT((usuarios[id].prode[i].gol_l<0) OR (usuarios[id].prode[i].gol_v<0)) AND NOT((res[i].gol_l<0) OR (res[i].gol_v<0)) then write(' (',puntajePartido(id,i),')');
                    writeln();
                    TextColor(LightGray);
                    if (i < MAX_PARTIDOS) AND ((j mod 9 = 0) OR (cambio AND (j mod 9 >5))) then begin
                        writeln();
                        TextColor(6);
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
            Close(f);
            Close(fres);
            Close(fusuarios);
        end;
        writeln();
        TextColor(LightGray);
        write('  Presione cualquier tecla para volver al men£ anterior...');
        readkey;
    end;
procedure modifPartido(id: integer);
    var
        partidos: tFixture;
        f: file of tFixture;
        usuarios: tUsuarios;
        fusuarios: file of tUsuarios;
        res: tProde;
        fres: file of tProde;
        n,i,j: integer;
        k: char;
        repetir,pv,conf,salir: boolean;
        input: string;
    begin
        ClrScr;
        printLogoMenu();
        barraTitulo('Carga de resultado');
        writeln();
        writeln();
        if NOT(FileExists(ARCHIVO_FIXTURE)) then begin
            TextColor(Red);
            writeln('           No puede subirse un resultado si no hay un fixture cargado.');
            writeln();
            writeln();
            writeln();
            TextColor(LightGray);
            write('  Presione cualquier tecla para volver al men£ anterior...');
            readkey;
        end
        else begin
            repeat
                repetir:= false;
                write('  Ingrese el n£mero de partido a modificar: ');
                readln(input);
                n:= StrToIntDef(input,-1);
                if (length(input) = 0) then n:=-2;
                if n=-2 then begin
                    TextColor(12);
                    writeln();
                    writeln();
                    writeln('  Uno o ambos valores fueron env°ados en blanco. Operaci¢n cancelada.');
                    writeln();
                    TextColor(LightGray);
                    writeln();
                    barraCualquiera(1,'®Desea volver a ingresar un resultado? [S/N]');
                    k:= readkey;
                    while NOT(k in ['s','n','S','N']) do begin
                        GotoXY(1,WhereY);
                        clreol;
                        barraCualquiera(15,'®Desea volver a ingresar un resultado? [S/N]');
                        delay(50);
                        GotoXY(1,WhereY);
                        clreol;
                        barraCualquiera(1,'®Desea volver a ingresar un resultado? [S/N]');
                        k:= readkey;
                    end;
                    if k in ['s','S'] then begin
                        repetir:= true;
                        ClrScr;
                        printLogoMenu();
                        barraTitulo('Carga de resultado');
                        writeln();
                        writeln();
                    end;
                end else if (n<1) OR (n>MAX_PARTIDOS) then begin
                    repeat
                        GotoXY(1,WhereY);
                        clreol;
                        barraCualquiera(15,'N£mero de partido fuera de rango, ®desea ingresar uno nuevamente? [S/N]');
                        delay(50);
                        GotoXY(1,WhereY);
                        clreol;
                        barraCualquiera(4,'N£mero de partido fuera de rango, ®desea ingresar uno nuevamente? [S/N]');
                        k:=readkey;
                    until k in ['s','n','S','N'];
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
                        assign(f, ARCHIVO_FIXTURE);
                        reset(f);
                        read(f,partidos);
                        assign(fres, ARCHIVO_RESULTADOS);
                        reset(fres);
                        read(fres,res)
                        close(fres);
                        writeln();
                        TextColor(Yellow);
                        write('    Partido ',n,': ',partidos[n].local,' - ',partidos[n].visitante);
                        TextColor(8);
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
                            barraCualquiera(3,'®Es esto correcto? [S/N]');
                            k:= readkey;
                            while NOT(k in ['s','n','S','N']) do begin
                                GotoXY(1,WhereY);
                                clreol;
                                barraCualquiera(15,'®Es esto correcto? [S/N]');
                                delay(50);
                                GotoXY(1,WhereY);
                                clreol;
                                barraCualquiera(3,'®Es esto correcto? [S/N]');
                                k:= readkey;
                            end;
                            if k in ['s','S'] then begin
                                conf:= true;
                                assign(fres, ARCHIVO_RESULTADOS);
                                reset(fres);
                                while not eof(fres) do read(fres,res);
                                close(fres);
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
                                barraCualquiera(1,'®Desea volver a ingresar el resultado? [S/N]');
                                k:= readkey;
                                while NOT(k in ['s','n','S','N']) do begin
                                    GotoXY(1,WhereY);
                                    clreol;
                                    barraCualquiera(15,'®Desea volver a ingresar el resultado? [S/N]');
                                    delay(50);
                                    GotoXY(1,WhereY);
                                    clreol;
                                    barraCualquiera(1,'®Desea volver a ingresar el resultado? [S/N]');
                                    k:= readkey;
                                end;
                                if k in ['n','N'] then salir:= true;
                            end;
                        end else begin
                            conf:= true;
                            TextColor(12);
                            writeln('  Uno o ambos valores fueron env°ados en blanco. Operaci¢n cancelada.');
                            writeln();
                            TextColor(LightGray);
                        end;
                        close(f);
                    until (conf = true);
                    if NOT(salir) then begin
                        repetir:= false;
                        barraCualquiera(1,'®Desea agregar otro resultado? [S/N]');
                        k:= readkey;
                        while NOT(k in ['s','n','S','N']) do begin
                            GotoXY(1,WhereY);
                            clreol;
                            barraCualquiera(15,'®Desea agregar otro resultado? [S/N]');
                            delay(50);
                            GotoXY(1,WhereY);
                            clreol;
                            barraCualquiera(1,'®Desea agregar otro resultado? [S/N]');
                            k:= readkey;
                        end;
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
            {assign(f, ARCHIVO_FIXTURE);
            Rewrite(f);
            cargar_fixture(fixture);
            Write(f,fixture);
            Close(f);
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
            TextColor(LightGreen);
            writeln('                           ≠Fixture cargado con Çxito!');
            writeln();
            writeln();}
        end;
    end;
procedure menuJugador(id: integer);//Menu presentado a cada jugador.
    var
        k:char;
        s:ansistring;//Esto es para que pueda usar "appendstr"
        usuarios: tUsuarios;
        f: file of tUsuarios;
    begin
        k:='0';
        repeat
            ClrScr;
            printLogoMenu();
            assign(f, ARCHIVO_USUARIOS);
            reset(f);
            read(f,usuarios);
            Close(f);
            s:= 'Menu de Jugador - ';
            appendstr( s, usuarios[id].nombre);//Insertar nombre ingresado al final
            barraTitulo(s);
            writeln();
            writeln();
            writeln('    1: Mi Prode');
            writeln('    2: Modificar Partido');
            writeln('    3: Ver tabla de posiciones');
            writeln('    0: Volver al men£ principal');
            writeln();
            if NOT(k in ['0'..'3']) then begin
                TextBackground(Red);
                TextColor(White);
                writeln('  ≠Opci¢n inv†lida!                                                             ');
                TextBackground(Black);
                TextColor(LightGray);
            end else if (k in ['2'..'3']) then begin
                TextBackground(Cyan);
                TextColor(White);
                writeln('  Opci¢n no implementada...                                                     ');
                TextBackground(Black);
                TextColor(LightGray);
            end else begin
                writeln();
                writeln();
            end;
            write('  Ingrese su opci¢n: ');
            k:=readkey;
            case k of
                '1': listarProde(id);
                '2': ;
                '3': ;
            end;
        until (k='0');
    end;
procedure loginJugador();//WIP
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
                barraTitulo('Listar Usuarios');
                writeln();
                writeln();
                TextColor(LightGreen);
                writeln('      Base de datos de usuarios no encontrada. Se ha creado una en blanco.');
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
                assign(f, ARCHIVO_USUARIOS);
                reset(f);
                read(f,usuarios);
                Close(f);
                nombrevalido:= false;
                i:= 1;
                while (i <= length(usuarios)) AND NOT(nombrevalido) do begin
                    if (usuarios[i].nombre = nombreIng) then nombrevalido:= true else i:= i+1;
                end;
                if (nombrevalido) then begin
                    menuJugador(i);
                end else begin
                    writeln();
                    TextColor(LightGray);
                    writeln();
                    barraCualquiera(4,'Nombre de usuario incorrecto. ®Desea intentarlo nuevamente? [S/N]');
                    k:= readkey;
                    while NOT(k in ['s','n','S','N']) do begin
                        GotoXY(1,WhereY);
                        clreol;
                        barraCualquiera(15,'Nombre de usuario incorrecto. ®Desea intentarlo nuevamente? [S/N]');
                        delay(50);
                        GotoXY(1,WhereY);
                        clreol;
                        barraCualquiera(4,'Nombre de usuario incorrecto. ®Desea intentarlo nuevamente? [S/N]');
                        k:= readkey;
                    end;
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
                if NOT(opcion in ['0'..'2']) then begin
                    TextBackground(Red);
                    TextColor(White);
                    writeln('  ≠Opci¢n inv†lida!                                                             ');
                    TextBackground(Black);
                    TextColor(LightGray);
                end else begin
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
    barraCualquiera(5,'Presione cualquier tecla para continuar...');
    readkey;
    menuInicial();
end.
