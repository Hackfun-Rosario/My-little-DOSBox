program test;
const
   VGA = $a000;

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


Procedure MEMPutpixel (X,Y : Integer; Col : Byte);
BEGIN
  Mem [VGA:X+(Y*320)]:=Col;
END;

begin
   { Cambia a modo MCGA }
   SetMCGA;

   { Pinta toda la pantalla de un color }
   FillChar (Mem [$a000:0],64000,0);

   { Dibuja unos pixeles locos }
   for i:= 50 to 269 do
      for j:= 50 to 149 do
         begin
         { INTPutpixel(i,j,i); }
            MEMPutpixel(i,j,i);
         end;

   { Pausa final }
   readln;

   { Vuelve a modo texto }
   SetText;
end.