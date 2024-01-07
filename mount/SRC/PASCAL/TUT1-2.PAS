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

(*
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
*)

Procedure MEMPutpixel (X,Y : Integer; Col : Byte);
BEGIN
  Mem [VGA:X+(Y*320)]:=Col;
END;

begin
   { Cambia a modo CGA }
   SetMCGA;

   { Pinta toda la pantalla de un color }
   FillChar (Mem [$a000:0],64000,0);

   { Dibuja unos pixeles locos }
   for i:= 0 to 319 do
      for j:= 0 to 199 do
         { INTPutpixel(i,j,i); }
         MEMPutpixel(i,j,i);

   { Pausa final }
   readln;

   { Vuelve a modo texto }
   SetText;
end.