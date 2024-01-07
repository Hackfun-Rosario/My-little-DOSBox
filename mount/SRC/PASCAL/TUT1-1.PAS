program test;
var
   { color: Byte; }
   i,j: Integer;

Procedure SetMCGA;
BEGIN
  asm
        mov     ax,0013h
        int     10h
  end;
END;

Procedure SetText;
BEGIN
  asm
        mov     ax,0003h
        int     10h
  end;
END;

Procedure INTPutpixel (X,Y : Integer; Col : Byte);
BEGIN
  asm
     mov        ah,0Ch
     mov        al,[col]
     mov        cx,[x]
     mov        dx,[y]
     mov        bx,[1]
     int        10h
  end;
END;

begin
   { Cambia a modo MCGA }
   SetMCGA;

   { Pinta toda la pantalla de un color }
   FillChar (Mem [$a000:0],64000,0);

   { Dibuja unos pixeles locos }
   for i:= 1 to 320 do
      for j:= 1 to 200 do
         INTPutpixel(i,j,i);

   { Pausa final }
   readln;

   { Vuelve a modo texto }
   SetText;
end.