unit EC_Str;

interface

uses Windows,SysUtils;

function GetCountParEC(str:WideString; raz:WideString):integer;
function GetSmeParEC(str:WideString; np:integer; raz:WideString):integer;
function GetLenParEC(str:WideString; smepar:integer; raz:WideString):integer;
function GetStrParEC(str:WideString; np:integer; raz:WideString):WideString; overload;
function GetStrParEC(str:WideString; nps,npe:integer; raz:WideString):WideString; overload;

function GetComEC(s:WideString):WideString;
function GetStrNoComEC(s:WideString):WideString;

function IsIntEC(str:WideString):boolean;
function StrToIntEC(str:WideString):integer;
function StrToIntFullEC(str:WideString):integer;
function StrToFloatEC(str:WideString):single;
function FloatToStrEC(zn:double):WideString;
function StringReplaceEC(str:WideString; sold:WideString; snew:WideString):WideString;

function FindSubstringEC(tstr:WideString; fstr:WideString; tsme:integer=0):integer; // -1 = not found
function FindEndTagEC(tstr:WideString; tsme:integer):integer;
procedure StringDeleteEC(var tstr:WideString; tsme:integer; tlen:integer);
procedure StringInsertEC(var tstr:WideString; tsme:integer; istr:WideString);

function AddStrPar(str,par:WideString):WideString;

function BooleanToStr(zn:boolean):WideString;

function TrimEx(tstr:WideString):WideString;

function FindSubstring(tstr,substr:WideString; tsme:integer=0):integer;

function TagSkipEC(tstr:PWideChar; tstrlen:integer):integer;

function GetColorEC(tstr:WideString):Cardinal;

function File_Name(path:WideString):WideString;
function File_Ext(path:WideString):WideString;
function File_Path(path:WideString):WideString;

function ComparerStrEC(s1,s2:PWideChar):integer; cdecl;

implementation

uses EC_Mem;


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
function GetCountParEC(str:WideString; raz:WideString):integer;
var
    len,lenraz:Cardinal;
    i,u,count:integer;
begin
    count:=1;
    len:=Length(str);
    lenraz:=Length(raz);
    if len<1 then begin
        Result:=0;
        Exit;
    end;
    for i:=1 to len do begin
        for u:=1 to lenraz do begin
           if str[i]=raz[u] then begin
               Inc(count);
               break;
           end;
        end;
    end;
    Result:=count;
end;

function GetSmeParEC(str:WideString; np:integer; raz:WideString):integer;
var
    len,lenraz:Cardinal;
    i,u:integer;
begin
    if np>0 then begin
        len:=Length(str);
        lenraz:=Length(raz);
        for i:=1 to len do begin
            for u:=1 to lenraz do begin
               if str[i]=raz[u] then begin
                   Dec(np);
                   if np=0 then begin
                       Result:=i+1;
                       Exit;
                   end;
                   break;
               end;
            end;
        end;
        raise Exception.Create('GetSmeParEC. Str=' + str + ' np=' + IntToStr(np) + ' raz=' + raz);
    end;
    Result:=1;
end;

function GetLenParEC(str:WideString; smepar:integer; raz:WideString):integer;
var
    len,lenraz:Cardinal;
    i,u:integer;
begin
    len:=Length(str);
    lenraz:=Length(raz);
    for i:=smepar to len do begin
        for u:=1 to lenraz do begin
            if str[i]=raz[u] then begin
                Result:=i-smepar;
                Exit;
            end;
        end;
    end;
    Result:=integer(len)-smepar+1;
end;

function GetStrParEC(str:WideString; np:integer; raz:WideString):WideString;
var
    sme:integer;
begin
    sme:=GetSmeParEC(str,np,raz);
    Result:=Copy(str,sme,GetLenParEC(str,sme,raz));
end;

function GetStrParEC(str:WideString; nps,npe:integer; raz:WideString):WideString;
var
    sme1,sme2:integer;
begin
	sme1:=GetSmeParEC(str,nps,raz);
	sme2:=GetSmeParEC(str,npe,raz);
	sme2:=sme2+GetLenParEC(str,sme2,raz);
    Result:=Copy(str,sme1,sme2-sme1);
end;

function GetComEC(s:WideString):WideString;
var
    compos,i:integer;
begin
    compos:=Pos(widestring('//'),s);
    if compos<1 then begin
        Result:='';
        Exit;
    end;
    i:=compos-1;
    while i>=1 do begin
        if (s[i]<>WideChar(32)) and (s[i]<>WideChar(9)) and (s[i]<>WideChar($0d)) and (s[i]<>WideChar($0a)) then break;
        Dec(i);
    end;
    Result:=Copy(s,i,Length(s)-(i));
end;

function GetStrNoComEC(s:WideString):WideString;
var
    compos:integer;
begin
    compos:=Pos(widestring('//'),s);
    if compos<1 then begin
        Result:=s;
        Exit;
    end else if compos=1 then begin
        Result:='';
        Exit;
    end;
    Result:=TrimRight(Copy(s,1,compos-1));
end;

function IsIntEC(str:WideString):boolean;
var
    len,i:integer;
begin
    len:=Length(str);
    if len<1 then begin
        Result:=false;
        Exit;
    end;
    for i:=1 to len do begin
        if ((str[i]<'0') or (str[i]>'9')) and (str[i]<>'-') then begin
            Result:=false;
            Exit;
        end;
    end;
    Result:=true;
end;

function StrToIntEC(str:WideString):integer;
var
    len,i:integer;
begin
    Result:=0;
    len:=Length(str);
    for i:=1 to len do begin
        if (integer(str[i])>=integer('0')) and (integer(str[i])<=integer('9')) then begin
            Result:=Result*10+StrToInt(str[i]);
        end;
    end;
end;

function StrToIntFullEC(str:WideString):integer;
var
    len,i:integer;
    fm:boolean;
begin
    Result:=0;
    len:=Length(str);
    fm:=false;
    for i:=1 to len do
    begin
      if (integer(str[i])>=integer('0')) and (integer(str[i])<=integer('9')) then Result:=Result*10+StrToInt(str[i])
      else if (integer(str[i])=integer('-')) and (Result=0) then fm:=true;
    end;
    if fm then Result:=-Result;
end;

function StrToFloatEC(str:WideString):single;
var
    i,len:integer;
    zn,tra:single;
    ch:integer;
begin
	len:=Length(str);
	if(len<1) then begin Result:=0; Exit; End;

	zn:=0.0;

    for i:=0 to len-1 do begin
		ch:=integer(str[i+1]);
		if (ch>=integer('0')) and (ch<=integer('9')) then zn:=zn*10.0+(ch-integer('0'))
		else if (ch=integer('.')) then break;
	end;
	inc(i);
	tra:=10.0;
    while i<len do begin
		ch:=integer(str[i+1]);
		if (ch>=integer('0')) and (ch<=integer('9')) then begin
			zn:=zn+((ch-integer('0')))/tra;
			tra:=tra*10.0;
		end;
        inc(i);
	end;
    for i:=0 to len-1 do if integer(str[i+1])=integer('-') then begin zn:=-zn; break; end;

    Result:=zn;
end;

function FloatToStrEC(zn:double):WideString;
var
    oldch:char;
begin
    oldch:=DecimalSeparator;
    DecimalSeparator:='.';
    Result:=FloatToStr(zn);
    DecimalSeparator:=oldch;
end;

function StringReplaceEC(str:WideString; sold:WideString; snew:WideString):WideString;
var
    strlen,soldlen,i,u:integer;
begin
    Result:='';
    strlen:=Length(str);
    soldlen:=Length(sold);
    if (strlen<soldlen) or (strlen<1) or (soldlen<1) then begin Result:=str; Exit; end;

    i:=0;
    while i<=strlen-soldlen do begin
        u:=0;
        while u<soldlen do begin
            if str[i+u+1]<>sold[u+1] then break;
            inc(u);
        end;

        if u>=soldlen then begin
            Result:=Result+snew;
            i:=i+soldlen;
        end else begin
            Result:=Result+str[i+1];
            inc(i);
        end;
    end;

    if i<strlen then begin
        Result:=Result+Copy(str,i+1,strlen-i);
    end;
end;

function FindSubstringEC(tstr:WideString; fstr:WideString; tsme:integer=0):integer;
var
    i,u,tstrlen,fstrlen:integer;
begin
    tstrlen:=Length(tstr);
    fstrlen:=Length(fstr);

    if (tsme+fstrlen)>tstrlen then begin Result:=-1; Exit; end;
    for i:=tsme to tstrlen-fstrlen do begin
        u:=0;
        while u<fstrlen do begin
            if tstr[i+u+1]<>fstr[u+1] then break;
            inc(u);
        end;
        if u>=fstrlen then begin Result:=i; Exit; end;
    end;

    Result:=-1;
end;

function FindEndTagEC(tstr:WideString; tsme:integer):integer;
var
    i,tstrlen:integer;
begin
    tstrlen:=Length(tstr);

    if (tsme+1)>tstrlen then begin Result:=-1; Exit; end;

    for i:=tsme to tstrlen-1 do begin
        if tstr[i+1]=WideChar($3e) then begin
            Result:=i;
            Exit;
        end;
    end;

    Result:=-1;
end;

procedure StringDeleteEC(var tstr:WideString; tsme:integer; tlen:integer);
var
    i,tstrlen:integer;
begin
    tstrlen:=Length(tstr);

    if (tsme<0) or (tsme+tlen>tstrlen) then raise Exception.Create('StringDeleteEC');

    if tstrlen=tlen then begin tstr:=''; Exit; end;

    for i:=tsme to tstrlen-tlen do begin
        tstr[i+1]:=tstr[i+tlen+1];
    end;

    SetLength(tstr,tstrlen-tlen);
end;

procedure StringInsertEC(var tstr:WideString; tsme:integer; istr:WideString);
var
    i,tstrlen,istrlen:integer;
begin
    tstrlen:=Length(tstr);
    istrlen:=Length(istr);

    if (tsme<0) or (tsme>tstrlen) then raise Exception.Create('StringDeleteEC');

    SetLength(tstr,tstrlen+istrlen);

    for i:=tstrlen-1 downto tsme do begin
        tstr[i+istrlen+1]:=tstr[i+1];
    end;

    for i:=0 to istrlen-1 do begin
        tstr[tsme+i+1]:=istr[i+1];
    end;
end;

function AddStrPar(str,par:WideString):WideString;
begin
    if GetCountParEC(str,'?')<2 then begin
        Result:=str + '?' + par;
    end else begin
        Result:=str + '&' + par;
    end;
end;

function BooleanToStr(zn:boolean):WideString;
begin
    if zn=false then Result:='False' else Result:='True';
end;

function TrimEx(tstr:WideString):WideString;
var
    zn,lensou,tstart,tend:integer;
begin
    lensou:=Length(tstr);

    tstart:=0;
    while tstart<lensou do begin
        zn:=Ord(tstr[tstart+1]);
        if (zn<>$20) and (zn<>$09) and (zn<>$0d) and (zn<>$0a) and (zn<>$0) then break;
        inc(tstart);
    end;
    if tstart>=lensou then Result:='';

    tend:=lensou-1;
    while tend>=0 do begin
        zn:=Ord(tstr[tend+1]);
        if (zn<>$20) and (zn<>$09) and (zn<>$0d) and (zn<>$0a) and (zn<>$0) then break;
        dec(tend);
    end;
    if tend<tstart then Result:='';

    SetLength(Result,tend-tstart+1);
    CopyMemory(PWideChar(Result),PAdd(PWideChar(tstr),tstart*2),(tend-tstart+1)*2);
end;

function FindSubstring(tstr,substr:WideString; tsme:integer):integer;
var
    tstrlen,substrlen,i:integer;
begin
    tstrlen:=Length(tstr);
    substrlen:=Length(substr);

    if (tsme<0) or ((tsme+substrlen)>tstrlen) or (substrlen<1) then begin Result:=-1; Exit; End;

    while tsme<=(tstrlen-substrlen) do begin
        i:=0;
        while i<substrlen do begin
            if tstr[tsme+i+1]<>substr[i+1] then break;
            inc(i);
        end;
        if i>=substrlen then begin
            Result:=tsme;
            Exit;
        end;
        inc(tsme);
    end;
    Result:=-1;
end;

function TagSkipEC(tstr:PWideChar; tstrlen:integer):integer;
var
    i:integer;
begin
    Result:=0;
    if (tstrlen<2) or (tstr[0]<>'<') then Exit;
    if tstr[1]='<' then begin Result:=1; Exit; end;
    i:=1;
    while i<tstrlen do if tstr[i]='>' then break else inc(i);
    if i>=tstrlen then Exit;
    Result:=i+1;
end;

function GetColorEC(tstr:WideString):Cardinal;
begin
    if GetCountParEC(tstr,',')<3 then raise Exception.Create('GetColorGI. color=' + tstr);
    Result:=RGB(BYTE(StrToInt(GetStrParEC(tstr,0,','))),BYTE(StrToInt(GetStrParEC(tstr,1,','))),BYTE(StrToInt(GetStrParEC(tstr,2,','))));
end;

function File_Name(path:WideString):WideString;
var
    cnt:integer;
begin
    cnt:=GetCountParEC(path,'\/');
    Result:=GetStrParEC(path,cnt-1,'\/');
    cnt:=GetCountParEC(Result,'.');
    if cnt>1 then begin
        Result:=GetStrParEC(Result,0,cnt-2,'.');
    end;
end;

function File_Ext(path:WideString):WideString;
var
    cnt:integer;
begin
    cnt:=GetCountParEC(path,'\/');
    Result:=GetStrParEC(path,cnt-1,'\/');
    cnt:=GetCountParEC(Result,'.');
    if cnt>1 then begin
        Result:=GetStrParEC(Result,cnt-1,'.');
    end else Result:='';
end;

function File_Path(path:WideString):WideString;
var
    cnt:integer;
begin
    cnt:=GetCountParEC(path,'\/');
    if cnt<1 then begin Result:=''; Exit; End;
    Result:=GetStrParEC(path,0,cnt-2,'\/');
end;

function ComparerStrEC(s1,s2:PWideChar):integer;
asm
		push    esi
		push    edi
		push    ebx
		push    edx

		mov     esi,s1
		mov     edi,s2
		test    esi,esi
		jnz     @@l1
		mov     eax,-1
		test    edi,edi
		jnz     @@lend
		xor     eax,eax
		jmp     @@lend

@@l1:	test    edi,edi
		jnz     @@l2
		mov     eax,1
		jmp     @@lend

@@l2:	mov     bx,[esi]
		mov     dx,[edi]
		add     esi,2
		add     edi,2
		cmp     bx,dx
		jnz     @@l3
		xor     eax,eax
		test    dx,dx
		jnz     @@l2
		jmp     @@lend

@@l3:	mov     eax,1
		ja      @@l4
		mov     eax,-1
@@l4:
//    test    bx,bx
//    jz      lend
//    test    dx,dx
//    jz      lend
//    jmp     l2

@@lend:
		pop    edx
		pop    ebx
		pop    edi
		pop    esi
//		mov     Result,eax
end;

end.

