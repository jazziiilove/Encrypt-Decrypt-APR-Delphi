{
 Baran Topal
 23-Oct-2009
 Arp Enc Program
}


program DArpEnc;
{$APPTYPE CONSOLE}

uses
  Windows,
  SysUtils,
  ShellApi;

const
  c1 = 52845;
  c2 = 22719;

function Encrypt (const s: string; Key: Word) : string;
var
 i : byte;
begin
 Result:=s;
 for i:=1 to length(s) do
  begin
   Result[i] := Char (byte (s[i]) xor (Key shr 8));
   Key := (byte (Result[i]) + Key) * c1 + c2;
  end;
end;

function Decrypt (const s: string; Key: Word) : string;
var
 i : byte;
begin
 Result:=s;
 for i:=1 to length(s) do
  begin
   Result[i] := Char (byte (s[i]) xor (Key shr 8));
   Key := (byte (s[i]) + Key) * c1 + c2;
  end;
end;

var
  F: Text;
  F2:File Of Byte;
  B,i:Byte;
  Str: String;
begin
 if ParamCount<2 Then Halt(1); // Quit if not called with 2 parameters
 AssignFile(F, ParamStr(1));  // 1st cmd line parameter
 Reset(F);
 AssignFile(F2, ParamStr(2));  // 2st cmd line parameter
 Rewrite(F2);
 While Not Eof(F) do
  begin
   ReadLn(f,Str);
   Str:=Trim(Str); // Remove leading/trailing spaces
   if Str='' then continue;
   WriteLn('Encrypting :'+Str);

   B:=Length(Str);
   Str:=Encrypt(Str,$98E1);
   Write(F2,B);
   for i:=1 to B do Write(F2,Byte(Str[i]));
  end;
 CloseFile(F);
 CloseFile(F2);
// uncomment this, and strike Enter to exit prog 
// readln;
end.

