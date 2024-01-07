program test;
const
   VGA = $a000;

var
   color: Byte; 
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
   for i:= 0 to 319 do
   begin
      for j:= 0 to 199 do
         begin
            if (i mod 2 = 0) and (j mod 2 = 0) then color := color+1;
            if i < 2*j then 
               begin
                  MEMPutpixel(i,j,color);                  
                  MEMPutpixel(i+2,j,color);
                  MEMPutpixel(i,j+2,color);
                  MEMPutpixel(i+2,j+2,color);
               end;
            j:=j+3;
            if j > 198 then break;
         end;
         i:=i+3;
         if i > 318 then break;
   end;
   { Pausa final }
   readln;

   { Vuelve a modo texto }
   SetText;
end.