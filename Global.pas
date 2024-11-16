unit Global;

interface

function RegUser_GetString(name:WideString):WideString;
procedure RegUser_SetString(name:WideString; zn:WideString);


implementation

uses Windows;

var
    RegUserPath:AnsiString='Software\NewGame Sofware\RangersScriptViewer';


function RegUser_GetString(name:WideString):WideString;
var
    kkey:HKEY;
    tip:DWORD;
    zn:Pointer;
    tsize:DWORD;
    buf:array[0..2048] of char;
begin
    Result:='';

    if RegOpenKeyExA(HKEY_CURRENT_USER,PAnsiChar(RegUserPath),0,KEY_READ,kkey)<>ERROR_SUCCESS then Exit;

    tsize:=2048;
    zn:=@buf[0];
    
    if (RegQueryValueExA(kkey,PAnsiChar(AnsiString(name)),nil,@tip,PByte(zn),@tsize)=ERROR_SUCCESS)
       and (tip=REG_SZ) then Result:=PAnsiChar(zn);

    RegCloseKey(kkey);
end;

procedure RegUser_SetString(name:WideString; zn:WideString);
var
    kkey:HKEY;
    dv:DWORD;
    tstr:AnsiString;
begin
    if RegCreateKeyExA(
             HKEY_CURRENT_USER,
             PAnsiChar(RegUserPath),
             0,
             nil,
             0,
             KEY_WRITE,
             nil,
             kkey,
             @dv) <> ERROR_SUCCESS then Exit;

    tstr:=zn;

    RegSetValueExA(kkey,PAnsiChar(AnsiString(name)),0,REG_SZ,PAnsiChar(tstr),Length(tstr)+1);

    RegCloseKey(kkey);
end;

end.

