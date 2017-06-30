{
 Baran Topal
 23-Oct-2009
 Arp Main Program
}

program DArp;
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

procedure WriteAscii(Header,Data:String);
Var i:integer;
begin
 Write(Header);
 for i := 1 to Length(Data) do Write(Format(' %2.2x',[Byte(Data[i])]));
 WriteLn;
end;

var
  F: File Of Byte;
  Str: String;
  i,B,Bi : byte;

begin
 if ParamCount<1 Then Exit;
 AssignFile(F, ParamStr(1));
 Reset(F);
 While Not Eof(F) do
  begin
   Read(F,B);
   SetLength(Str,B);
   for i:=1 to B do
    begin
     Read(F,Bi);
     Str[i]:=Char(Bi);
    end;
   Str:=Decrypt(Str,$98E1);
   WriteAscii('Decripting :',Str);
   WriteLn(Str);

  // ARP is assumed to be a file that's found by the path...
   ShellExecute(0, 'open', 'arp.exe', PChar(' -s '+Str), nil, SW_SHOWNORMAL );
  end;
 CloseFile(F);
 //WriteLn('File '+ParamStr(1)+' treated. Strike Enter to exit');
// readln;
// SysUtils.Sleep(1000660);
end.
