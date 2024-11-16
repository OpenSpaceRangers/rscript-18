unit EC_BlockPar;

interface

uses Windows, Messages, Forms, MMSystem, SysUtils, EC_Str, EC_File, EC_Buf, EC_Expression;

type
TBlockParEC = class;

TBlockParElEC = class(TObject)
    public
        m_Prev:TBlockParElEC;
        m_Next:TBlockParElEC;
        m_Parent:TBlockParEC;

        m_Tip:DWORD; // 0-пусто 1-параметр 2-блок
        m_Name: WideString;
        m_Zn: WideString;
        m_Com: WideString;
        m_Block:TBlockParEC;

        m_FastFirst:integer;
        m_FastCnt:integer;
    public
        constructor Create;
        destructor Destroy; override;

        procedure Clear;
        procedure CreateBlock;

        procedure CopyFrom(bp:TBlockParElEC);
end;

TBlockParEC = class(TObject)
    protected
        m_First:TBlockParElEC;
        m_Last:TBlockParElEC;

        m_Cnt:integer;
        m_CntPar:integer;
        m_CntBlock:integer;

        m_Sort:boolean;
        m_Array:array of TBlockParElEC;
        m_ArrayCnt:integer;
    public
        constructor Create(sort:boolean=true);
        destructor Destroy; override;

        procedure Clear;

        procedure CopyFrom(bp:TBlockParEC);

    protected
        function El_Add:TBlockParElEC;
        procedure El_Del(el:TBlockParElEC);
        function El_Get(const path:WideString):TBlockParElEC;

		function Array_Find(const name:WideString):integer;
		function Array_FindInsertIndex(ael:TBlockParElEC):integer;
        procedure Array_Add(el:TBlockParElEC);
        procedure Array_Del(el:TBlockParElEC);
    public

        procedure ParPath_Add(const path,zn:WideString);
        procedure ParPath_Set(const path,zn:WideString);
        procedure ParPath_SetAdd(const path,zn:WideString);
        procedure ParPath_Delete(const path:WideString);
        function ParPath_Get(const path:WideString):WideString;
        function ParPath_Count(const path:WideString):integer;
        property ParPath[const path:WideString]:WideString read ParPath_Get write ParPath_SetAdd;

        function Par_Add(const name,zn:WideString):TBlockParElEC;
        procedure Par_Set(const name,zn:WideString); overload;
        procedure Par_SetAdd(const name,zn:WideString);
        procedure Par_Delete(const name:WideString);overload;
        procedure Par_Delete(no:integer);overload;
        function Par_Get(const name:WideString):WideString; overload;
        function Par_GetNE(const name:WideString):WideString;
        property Par[const name:WideString]:WideString read Par_Get write Par_SetAdd;
        property ParNE[const name:WideString]:WideString read Par_GetNE write Par_SetAdd;

        function Par_Count:integer; overload;
        function Par_Count(const name:WideString):integer; overload;
        function Par_Get(no:integer):WideString; overload;
        function Par_GetName(no:integer):WideString;
        procedure Par_Set(no:integer; zn:WideString); overload;
        procedure Par_SetName(no:integer; zn:WideString);

        function BlockPath_Add(const path:WideString):TBlockParEC;
        function BlockPath_Get(const path:WideString):TBlockParEC;
        function BlockPath_GetAdd(const path:WideString):TBlockParEC;
        property BlockPath[const path:WideString]:TBlockParEC read BlockPath_Get;

        function Block_Add(const name:WideString):TBlockParEC;
        function Block_Get(const name:WideString):TBlockParEC; overload;
        function Block_GetNE(const name:WideString):TBlockParEC; overload;
        function Block_GetAdd(const name:WideString):TBlockParEC;
        property Block[const name:WideString]:TBlockParEC read Block_Get;

        function Block_Count:integer; overload;
        function Block_Count(const name:WideString):integer; overload;
        function Block_Get(no:integer):TBlockParEC; overload;
        function Block_GetName(no:integer):WideString;
        procedure Block_Delete(const name:WideString);overload;
        procedure Block_Delete(no:integer);overload;

        function All_Count:integer;
        function All_GetTip(no:integer):integer; // 0 - пусто   1 - Par     2 - Block
        function All_GetBlock(no:integer):TBlockParEC;
        function All_GetPar(no:integer):WideString;
        function All_GetName(no:integer):WideString;

        private procedure SaveInBuf_r(tbuf:TBufEC; level:integer=0);
        private procedure SaveInBufAnsi_r(tbuf:TBufEC; level:integer=0);
        public procedure SaveInBuf(tbuf:TBufEC; fansi:boolean=false);
        procedure SaveInFile(filename:PAnsiChar; fansi:boolean=false);

        private procedure LoadFromBuf_r(tbuf:TBufEC; const predstr:WideString; fa:boolean=false; fcom:boolean=true);
        public procedure LoadFromBuf(tbuf:TBufEC; fcom:boolean=false);
        procedure LoadFromFile(filename:PAnsiChar; fcom:boolean=false);

        function LoadFromCA(ca:TCodeAnalyzerEC; caun:TCodeAnalyzerUnitEC=nil):TCodeAnalyzerUnitEC;

        procedure Save(bd:TBufEC); overload;
        procedure Load(bd:TBufEC); overload;
        procedure Save(const filename:WideString); overload;
        procedure Load(const filename:WideString); overload;
end;

implementation

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TBlockParElEC.Create;
begin
    inherited Create;
end;

destructor TBlockParElEC.Destroy;
begin
    Clear;
    inherited Destroy;
end;

procedure TBlockParElEC.Clear;
begin
    if m_Block<>nil then begin
        m_Block.Free;
        m_Block:=nil;
    end;
    m_Tip:=0;
    m_Name:='';
    m_Zn:='';
    m_Com:='';
end;

procedure TBlockParElEC.CreateBlock;
begin
    if m_Block<>nil then begin
        m_Block.Free;
        m_Block:=nil;
    end;
    m_Block:=TBlockParEC.Create;
    m_Tip:=2;
    m_Zn:='';
end;

procedure TBlockParElEC.CopyFrom(bp:TBlockParElEC);
begin
    Clear;

    m_Tip:=bp.m_Tip;
    m_Name:=bp.m_Name;
    m_Zn:=bp.m_Zn;
    m_Com:=bp.m_Com;
    m_Block:=nil;
    if bp.m_Block<>nil then begin
        m_Block:=TBlockParEC.Create;
        m_Block.CopyFrom(bp.m_Block);
    end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TBlockParEC.Create(sort:boolean=true);
begin
    inherited Create;
    m_Sort:=sort;
end;

destructor TBlockParEC.Destroy;
begin
    Clear;
    inherited Destroy;
end;

procedure TBlockParEC.Clear;
var
    t,tt:TBlockParElEC;
begin
    t:=m_First;
    while t<>nil do begin
        tt:=t;
        t:=t.m_Next;
        tt.Free;
    end;
    m_First:=nil;
    m_Last:=nil;

    m_Cnt:=0;
	m_CntPar:=0;
	m_CntBlock:=0;

    m_Array:=nil;
    m_ArrayCnt:=0;
end;

procedure TBlockParEC.CopyFrom(bp:TBlockParEC);
var
    el,el2:TBlockParElEC;
begin
    Clear;
    m_Sort:=bp.m_Sort;
    el:=bp.m_First;
    while el<>nil do begin
        el2:=El_Add;
        el2.CopyFrom(el);
        if m_Sort then Array_Add(el2);
        if el.m_Tip=1 then inc(m_CntPar)
        else if el.m_Tip=2 then inc(m_CntBlock);
        el:=el.m_Next;
    end;
end;
{var
    bd:TBufEC;
begin
    Clear;
    bd:=TBufEC.Create;
    bp.SaveInBuf(bd);
    bd.Pointer:=0;
    LoadFromBuf(bd);
    bd.Free;
end;}

function TBlockParEC.El_Add:TBlockParElEC;
var
    el:TBlockParElEC;
begin
    el:=TBlockParElEC.Create;

    el.m_Parent:=Self;

    if m_Last<>nil then m_Last.m_Next:=el;
	el.m_Prev:=m_Last;
	el.m_Next:=nil;
	m_Last:=el;
	if m_First=nil then m_First:=el;

    inc(m_Cnt);

    Result:=el;
end;

procedure TBlockParEC.El_Del(el:TBlockParElEC);
begin
	if el.m_Prev<>nil then el.m_Prev.m_Next:=el.m_Next;
	if el.m_Next<>nil then el.m_Next.m_Prev:=el.m_Prev;
	if m_Last=el then m_Last:=el.m_Prev;
	if m_First=el then m_First:=el.m_Next;

    dec(m_Cnt);
    if el.m_Tip=1 then dec(m_CntPar)
    else if el.m_Tip=2 then dec(m_CntBlock);

    el.Free;
end;

function TBlockParEC.El_Get(const path:WideString):TBlockParElEC;
var
//    countraz:integer;
    i,u,no:integer;
//    name:WideString;
    ne:TBlockParElEC;
    us:TBlockParEC;

    path_len:integer;
    name_sme:integer;
    name_len:integer;
    name_next:integer;

    function nameExtractNext:boolean;
    var
    	ch:WideChar;
        sme:integer;
    begin
    	if name_next>=path_len then begin Result:=false; Exit; end;
    	name_sme:=name_next;
        sme:=name_sme;
        while sme<path_len do begin
        	ch:=path[sme+1];
            if (ch='.') or (ch='/') or (ch='\') then break;
        	inc(sme);
        end;
        name_len:=sme-name_sme;
        name_next:=sme+1;
        Result:=true;
    end;
    procedure noExtract;
    var
    	sme,smeend:integer;
        ch:WideChar;
    begin
    	no:=0;
        sme:=name_sme;
        smeend:=name_sme+name_len;
        while sme<smeend do begin
        	if path[sme+1]=':' then begin
            	name_len:=sme-name_sme;
            	inc(sme);
		        while sme<smeend do begin
                	ch:=path[sme+1];
                    if (ch>='0') and (ch<='9') then no:=no*10+(integer(ch)-integer('0'));
                	inc(sme);
                end;
            	Exit;
            end;
        	inc(sme);
        end;
    end;
    function nameCmp(tstr:WideString):boolean;
    begin
    	if Length(tstr)<>name_len then begin Result:=false; exit; end;
        Result:=CompareMem(PWideChar(path)+name_sme,PWideChar(tstr),name_len*2);
    end;
begin
	path_len:=Length(path);
    name_next:=0;

{	countraz:=GetCountParEC(path,'./\');
    if countraz<1 then raise Exception.Create('GetEl. Path=' + path);}
    us:=Self;
    ne:=nil;
//    for i:=0 to countraz-1 do begin
    while nameExtractNext() do begin
//        name:=TrimEx(GetStrParEC(path,i,'./\'));
{        if GetCountParEC(name,':')>1 then begin
            no:=StrToInt(GetStrParEC(name,1,':'));
            name:=TrimEx(GetStrParEC(name,0,':'));
        end else begin
            no:=0;
        end;}
        noExtract;

        if us.m_Sort then begin
        	ne:=nil;
	        i:=us.Array_Find(Copy(path,name_sme+1,name_len));
            if i>=0 then begin
            	ne:=us.m_Array[i];
                if no=0 then
            	else if (no<ne.m_FastCnt) then begin
                	ne:=us.m_Array[i+no];
                end else ne:=nil;
            end;

        end else begin
	        ne:=us.m_First;
    	    u:=0;
        	while (u<=no) and (ne<>nil) do begin
            	while ne<>nil do begin
	                if nameCmp(ne.m_Name) then begin
    	                if u<no then ne:=ne.m_Next;
        	            break;
            	    end;
	                ne:=ne.m_Next;
    	        end;
        	    Inc(u);
	        end;
        end;

        if ne=nil then raise Exception.Create('GetEl. Path=' + path);
//		if i=countraz-1 then break;
		if name_next>=path_len then break;
		if ne.m_Tip<>2 then raise Exception.Create('GetEl. Path=' + path);
		us:=ne.m_Block;
    end;
    if ne=nil then raise Exception.Create('GetEl. Path=' + path);
	Result:=ne;
end;
{function TBlockParEC.El_Get(path:WideString):TBlockParElEC;
var
    countraz:integer;
    i,u,no:integer;
    name:WideString;
    ne:TBlockParElEC;
    us:TBlockParEC;
begin
	countraz:=GetCountParEC(path,'./\');
    if countraz<1 then raise Exception.Create('GetEl. Path=' + path);
    us:=Self;
    ne:=nil;
    for i:=0 to countraz-1 do begin
        name:=TrimEx(GetStrParEC(path,i,'./\'));
        if GetCountParEC(name,':')>1 then begin
            no:=StrToInt(GetStrParEC(name,1,':'));
            name:=TrimEx(GetStrParEC(name,0,':'));
        end else begin
            no:=0;
        end;
        ne:=us.m_First;
        u:=0;
        while (u<=no) and (ne<>nil) do begin
            while ne<>nil do begin
                if ne.m_Name=name then begin
                    if u<no then ne:=ne.m_Next;
                    break;
                end;
                ne:=ne.m_Next;
            end;
            Inc(u);
        end;
        if ne=nil then raise Exception.Create('GetEl. Path=' + path);
		if i=countraz-1 then break;
		if ne.m_Tip<>2 then raise Exception.Create('GetEl. Path=' + path);
		us:=ne.m_Block;
    end;
	Result:=ne;
end;}

function TBlockParEC.Array_Find(const name:WideString):integer;
var
    istart,iend,icur,cz:integer;
    el:TBlockParElEC;
begin
    if m_ArrayCnt<1 then begin Result:=-1; Exit; End;
    istart:=0;
    iend:=m_ArrayCnt-1;
    while true do begin
        icur:=istart+((iend-istart) div 2);
//        el:=IndexToVar(icur);
        el:=m_Array[icur];
//        cz:=CompareStr(tname,el.Name);
		cz:=ComparerStrEC(PWideChar(name),PWideChar(el.m_Name));
        if cz=0 then begin
        	Result:=icur-el.m_FastFirst;
            Exit;
        End
        else if cz<0 then begin
            iend:=icur-1;
        end else begin
            istart:=icur+1;
        end;
        if iend<istart then begin
            Result:=-1;
            Exit;
        end;
    end;
end;

function TBlockParEC.Array_FindInsertIndex(ael:TBlockParElEC):integer;
var
    istart,iend,icur,cz:integer;
    el:TBlockParElEC;
begin
    if m_ArrayCnt<=0 then begin
    	Result:=0;
		ael.m_FastFirst:=0;
        ael.m_FastCnt:=1;
        Exit;
    end;
    istart:=0;
    iend:=m_ArrayCnt-1;
    while true do begin
        icur:=istart+((iend-istart) shr 1);
        el:=m_Array[icur];
//        cz:=CompareStr(ael.m_Name,el.m_Name);
		cz:=ComparerStrEC(PWideChar(ael.m_Name),PWideChar(el.m_Name));
        if cz=0 then begin
            if el.m_FastFirst<>0 then begin
	        	Result:=icur-el.m_FastFirst;
            	el:=m_Array[Result];
            end else Result:=icur;
            ael.m_FastFirst:=el.m_FastCnt;
            Result:=Result+el.m_FastCnt;
            inc(el.m_FastCnt);
            Exit;
        end else if cz<0 then begin
            iend:=icur-1;
        end else begin
            istart:=icur+1;
        end;
        if iend<istart then begin
            if cz<0 then Result:=icur
            else Result:=icur+1;

            ael.m_FastFirst:=0;
            ael.m_FastCnt:=1;
            Exit;
        end;
    end;
end;

procedure TBlockParEC.Array_Add(el:TBlockParElEC);
var
	no:integer;
begin
    SetLength(m_Array,m_ArrayCnt+1);

	no:=Array_FindInsertIndex(el);
    if no>=m_ArrayCnt then begin
    	m_Array[m_ArrayCnt]:=el;
        inc(m_ArrayCnt);
    end else begin
        MoveMemory(@(m_Array[no+1]),@(m_Array[no]),(m_ArrayCnt-no)*4);
    	m_Array[no]:=el;
    	inc(m_ArrayCnt);
    end;
end;

procedure TBlockParEC.Array_Del(el:TBlockParElEC);
var
	i,no:integer;
    el2:TBlockParElEC;
begin
	no:=0;
    while no<m_ArrayCnt do begin
    	if m_Array[no]=el then begin
			el2:=m_Array[no-el.m_FastFirst];
            for i:=no+1 to no-el.m_FastFirst+el2.m_FastCnt-1 do dec(m_Array[i].m_FastFirst);
            dec(el2.m_FastCnt);
            if (el.m_FastFirst=0) and (el2.m_FastCnt>0) then begin
            	m_Array[no+1].m_FastCnt:=el.m_FastCnt;
            end;

        	if no<(m_ArrayCnt-1) then MoveMemory(@(m_Array[no]),@(m_Array[no+1]),(m_ArrayCnt-no-1)*4);
            dec(m_ArrayCnt);
		    SetLength(m_Array,m_ArrayCnt);
        	Exit;
        end;
    	inc(no);
    end;
end;

procedure TBlockParEC.ParPath_Add(const path,zn:WideString);
var
    countep:integer;
    name:WideString;
    el:TBlockParElEC;
    cd:TBlockParEC;
begin
    countep:=GetCountParEC(path,'./\');
    if countep>1 then begin
        cd:=BlockPath_GetAdd(GetStrParEC(path,0,countep-2,'./\'));
        name:=GetStrParEC(path,countep-1,'./\');
    end else begin
        name:=path;
        cd:=Self;
    end;
    el:=cd.El_Add;
    el.m_Tip:=1;
    el.m_Name:=name;
    el.m_Zn:=zn;
    inc(m_CntPar);
    if m_Sort then Array_Add(el);
end;

procedure TBlockParEC.ParPath_Set(const path,zn:WideString);
var
    te:TBlockParElEC;
begin
    te:=El_Get(path);
    if te.m_Tip<>1 then raise Exception.Create('Par_Set. Path=' + path + ' zn=' + zn);
    te.m_Zn:=zn;
end;

procedure TBlockParEC.ParPath_SetAdd(const path,zn:WideString);
var
    te:TBlockParElEC;
begin
    try
        te:=El_Get(path);
        if te.m_Tip<>1 then raise Exception.Create('Par_SetAdd. Path=' + path + ' zn=' + zn);
        te.m_Zn:=zn;
    except
        on E: Exception do begin
            ParPath_Add(path,zn);
        end;
    end;
end;

procedure TBlockParEC.ParPath_Delete(const path:WideString);
var
    te:TBlockParElEC;
begin
    te:=El_Get(path);
    if te.m_Tip<>1 then raise Exception.Create('Par_Delete. Path=' + path);
    if te.m_Parent.m_Sort then te.m_Parent.Array_Del(te);
    te.m_Parent.El_Del(te);
end;

function TBlockParEC.ParPath_Get(const path:WideString):WideString;
var
    te:TBlockParElEC;
begin
    te:=El_Get(path);
    if te.m_Tip<>1 then raise Exception.Create('Par_Get. Path=' + path);
    Result:=te.m_Zn;
end;

function TBlockParEC.ParPath_Count(const path:WideString):integer;
var
    countep:integer;
    name:WideString;
    cd:TBlockParEC;
begin
    countep:=GetCountParEC(path,'./\');
    if countep>1 then begin
        cd:=BlockPath_GetAdd(GetStrParEC(path,0,countep-2,'./\'));
        name:=GetStrParEC(path,countep-1,'./\');
    end else begin
        name:=path;
        cd:=Self;
    end;
    Result:=cd.Par_Count(name);
end;

////////////////////////////////////////////////////////////////////////////////
function TBlockParEC.Par_Add(const name,zn:WideString):TBlockParElEC;
var
    el:TBlockParElEC;
begin
    el:=El_Add;
    el.m_Tip:=1;
    el.m_Name:=name;
    el.m_Zn:=zn;
    if m_Sort then Array_Add(el);
    inc(m_CntPar);
    Result:=el;
end;

procedure TBlockParEC.Par_Set(const name,zn:WideString);
var
    el:TBlockParElEC;
begin
    el:=m_First;
    while el<>nil do begin
        if (el.m_Name=name) and (el.m_Tip=1) then begin
            el.m_Zn:=zn;
            Exit;
        end;
        el:=el.m_Next;
    end;
    raise Exception.Create('TBlockParEC.Block_Get. name=' + name);
end;

procedure TBlockParEC.Par_SetAdd(const name,zn:WideString);
var
    el:TBlockParElEC;
begin
    el:=m_First;
    while el<>nil do begin
        if (el.m_Name=name) and (el.m_Tip=1) then begin
            el.m_Zn:=zn;
            Exit;
        end;
        el:=el.m_Next;
    end;
    Par_Add(name,zn);
{    try
        Par_Set(name,zn);
    except
        on E: Exception do begin
            Par_Add(name,zn);
        end;
    end;}
end;

procedure TBlockParEC.Par_Delete(const name:WideString);
var
    el:TBlockParElEC;
begin
    el:=m_First;
    while el<>nil do begin
        if (el.m_Name=name) and (el.m_Tip=1) then begin
		    if m_Sort then Array_Del(el);
            El_Del(el);
            Exit;
        end;
        el:=el.m_Next;
    end;
    raise Exception.Create('TBlockParEC.Block_Get. name=' + name);
end;

Procedure TBlockParEC.Par_Delete(no:integer);
var
    el:TBlockParElEC;
begin
    el:=m_First;
    while el<>nil do begin
        if (el.m_Tip=1) then begin
            if no=0 then begin
				if m_Sort then Array_Del(el);
                El_Del(el);
                Exit;
            end;
            Dec(no);
        end;
        el:=el.m_Next;
    end;
    raise Exception.Create('TBlockParEC.Par_Get. no=' + IntToStr(no));
end;

procedure TBlockParEC.Block_Delete(const name:WideString);
var
    el:TBlockParElEC;
begin
    el:=m_First;
    while el<>nil do begin
        if (el.m_Name=name) and (el.m_Tip=2) then begin
		    if m_Sort then Array_Del(el);
            El_Del(el);
            Exit;
        end;
        el:=el.m_Next;
    end;
    raise Exception.Create('TBlockParEC.Block_Get. name=' + name);
end;

procedure TBlockParEC.Block_Delete(no:integer);
var
    el:TBlockParElEC;
begin
    el:=m_First;
    while el<>nil do begin
        if (el.m_Tip=2) then begin
            if no=0 then begin
			    if m_Sort then Array_Del(el);
                El_Del(el);
                Exit;
            end;
            Dec(no);
        end;
        el:=el.m_Next;
    end;
    raise Exception.Create('TBlockParEC.Block_Get. no=' + IntToStr(no));
end;

function TBlockParEC.Par_Get(const name:WideString):WideString;
var
    el:TBlockParElEC;
begin
    el:=m_First;
    while el<>nil do begin
        if (el.m_Name=name) and (el.m_Tip=1) then begin
            Result:=el.m_Zn;
            Exit;
        end;
        el:=el.m_Next;
    end;
    raise Exception.Create('TBlockParEC.Block_Get. name=' + name);
end;

function TBlockParEC.Par_GetNE(const name:WideString):WideString;
var
    el:TBlockParElEC;
begin
    el:=m_First;
    while el<>nil do begin
        if (el.m_Name=name) and (el.m_Tip=1) then begin
            Result:=el.m_Zn;
            Exit;
        end;
        el:=el.m_Next;
    end;
    Result:='';
end;

////////////////////////////////////////////////////////////////////////////////
function TBlockParEC.Par_Count:integer;
{var
    el:TBlockParElEC;
    count:integer;}
begin
	Result:=m_CntPar;
{    el:=m_First;
    count:=0;
    while el<>nil do begin
        if (el.m_Tip=1) then Inc(count);
        el:=el.m_Next;
    end;
    Result:=count;}
end;

function TBlockParEC.Par_Count(const name:WideString):integer;
var
    el:TBlockParElEC;
    count,i,li:integer;
begin
	if m_Sort then begin
		i:=Array_Find(name);
        Result:=0;
        if i>=0 then begin
        	li:=i+m_Array[i].m_FastCnt;
            while i<li do begin
	        	el:=m_Array[i];
	    	    if (el.m_Tip=1) then Inc(Result);
            	inc(i);
            end;
        end;
    end else begin
	    el:=m_First;
    	count:=0;
	    while el<>nil do begin
    	    if (el.m_Tip=1) and (el.m_Name=name) then Inc(count);
        	el:=el.m_Next;
	    end;
    	Result:=count;
    end;
end;

function TBlockParEC.Par_Get(no:integer):WideString;
var
    el:TBlockParElEC;
begin
	if m_Sort and (m_Cnt=m_CntPar) then begin
    	Result:=m_Array[no].m_Zn;
    end else begin
	    el:=m_First;
    	while el<>nil do begin
	        if (el.m_Tip=1) then begin
    	        if no=0 then begin
        	        Result:=el.m_Zn;
            	    Exit;
	            end;
    	        Dec(no);
        	end;
	        el:=el.m_Next;
    	end;
	    raise Exception.Create('TBlockParEC.Par_Get. no=' + IntToStr(no));
    end;
end;

function TBlockParEC.Par_GetName(no:integer):WideString;
var
    el:TBlockParElEC;
begin
	if m_Sort and (m_Cnt=m_CntPar) then begin
    	Result:=m_Array[no].m_Name;
    end else begin
	    el:=m_First;
    	while el<>nil do begin
        	if (el.m_Tip=1) then begin
	            if no=0 then begin
    	            Result:=el.m_Name;
        	        Exit;
	            end;
    	        Dec(no);
        	end;
	        el:=el.m_Next;
    	end;
	    raise Exception.Create('TBlockParEC.Par_GetName. no=' + IntToStr(no));
    end;
end;

procedure TBlockParEC.Par_Set(no:integer; zn:WideString);
var
    el:TBlockParElEC;
begin
	if m_Sort and (m_Cnt=m_CntPar) then begin
    	m_Array[no].m_Zn:=zn;
    end else begin
	    el:=m_First;
    	while el<>nil do begin
        	if (el.m_Tip=1) then begin
	            if no=0 then begin
    	            el.m_Zn:=zn;
        	        Exit;
	            end;
    	        Dec(no);
        	end;
	        el:=el.m_Next;
    	end;
	    raise Exception.Create('TBlockParEC.Par_Set. no=' + IntToStr(no));
    end;
end;

procedure TBlockParEC.Par_SetName(no:integer; zn:WideString);
var
    el:TBlockParElEC;
begin
	if m_Sort and (m_Cnt=m_CntPar) then begin
    	m_Array[no].m_Name:=zn;
    end else begin
	    el:=m_First;
    	while el<>nil do begin
        	if (el.m_Tip=1) then begin
	            if no=0 then begin
    	            el.m_Name:=zn;
        	        Exit;
	            end;
    	        Dec(no);
        	end;
	        el:=el.m_Next;
    	end;
	    raise Exception.Create('TBlockParEC.Par_SetName. no=' + IntToStr(no));
    end;
end;

////////////////////////////////////////////////////////////////////////////////
function TBlockParEC.BlockPath_Add(const path:WideString):TBlockParEC;
var
    countep:integer;
    name:WideString;
    el:TBlockParElEC;
    cd:TBlockParEC;
begin
    countep:=GetCountParEC(path,'./\');
    if countep>1 then begin
        cd:=BlockPath_GetAdd(GetStrParEC(path,0,countep-2,'./\'));
        name:=GetStrParEC(path,countep-1,'./\');
    end else begin
        name:=path;
        cd:=Self;
    end;
    el:=cd.El_Add;
    el.CreateBlock;
    el.m_Name:=name;
    if m_Sort then Array_Add(el);
    inc(m_CntBlock);
    Result:=el.m_Block;
end;

function TBlockParEC.BlockPath_Get(const path:WideString):TBlockParEC;
var
    te:TBlockParElEC;
begin
    te:=El_Get(path);
    if te.m_Tip<>2 then raise Exception.Create('TBlockParEC.BlockPath_Get. Path=' + path);
    Result:=te.m_Block;
end;

function TBlockParEC.BlockPath_GetAdd(const path:WideString):TBlockParEC;
var
    te:TBlockParEC;
begin
    try
        te:=BlockPath_Get(path);
        Result:=te;
    except
        on E: Exception do begin
            Result:=BlockPath_Add(path);
        end;
    end;
end;

////////////////////////////////////////////////////////////////////////////////
function TBlockParEC.Block_Add(const name:WideString):TBlockParEC;
var
    el:TBlockParElEC;
begin
    el:=El_Add;
    el.CreateBlock;
    el.m_Name:=name;
    if m_Sort then Array_Add(el);
    inc(m_CntBlock);
    Result:=el.m_Block;
end;

function TBlockParEC.Block_Get(const name:WideString):TBlockParEC;
var
    el:TBlockParElEC;
begin
    el:=m_First;
    while el<>nil do begin
        if (el.m_Name=name) and (el.m_Tip=2) then begin
            Result:=el.m_Block;
            Exit;
        end;
        el:=el.m_Next;
    end;
    raise Exception.Create('TBlockParEC.Block_Get. name=' + name);
end;

function TBlockParEC.Block_GetNE(const name:WideString):TBlockParEC;
var
    el:TBlockParElEC;
begin
    el:=m_First;
    while el<>nil do begin
        if (el.m_Name=name) and (el.m_Tip=2) then begin
            Result:=el.m_Block;
            Exit;
        end;
        el:=el.m_Next;
    end;
    Result:=nil;
end;

function TBlockParEC.Block_GetAdd(const name:WideString):TBlockParEC;
begin
	Result:=Block_GetNE(name);
	if Result=nil then Result:=Block_Add(name);
end;

////////////////////////////////////////////////////////////////////////////////
function TBlockParEC.Block_Count:integer;
{var
    el:TBlockParElEC;
    count:integer;}
begin
	Result:=m_CntBlock;
{    el:=m_First;
    count:=0;
    while el<>nil do begin
        if (el.m_Tip=2) then Inc(count);
        el:=el.m_Next;
    end;
    Result:=count;}
end;

function TBlockParEC.Block_Count(const name:WideString):integer;
var
    el:TBlockParElEC;
    count,i,li:integer;
begin
	if m_Sort then begin
		i:=Array_Find(name);
        Result:=0;
        if i>=0 then begin
        	li:=i+m_Array[i].m_FastCnt;
            while i<li do begin
	        	el:=m_Array[i];
	    	    if (el.m_Tip=2) then Inc(Result);
            	inc(i);
            end;
        end;
    end else begin
	    el:=m_First;
    	count:=0;
	    while el<>nil do begin
    	    if (el.m_Tip=2) and (el.m_Name=name) then Inc(count);
        	el:=el.m_Next;
	    end;
	    Result:=count;
    end;
end;

function TBlockParEC.Block_Get(no:integer):TBlockParEC;
var
    el:TBlockParElEC;
begin
	if m_Sort and (m_Cnt=m_CntBlock) then begin
    	Result:=m_Array[no].m_Block;
    end else begin
	    el:=m_First;
    	while el<>nil do begin
        	if (el.m_Tip=2) then begin
	            if no=0 then begin
    	            Result:=el.m_Block;
        	        Exit;
            	end;
	            Dec(no);
    	    end;
        	el:=el.m_Next;
	    end;
	    raise Exception.Create('TBlockParEC.Block_Get. no=' + IntToStr(no));
    end;
end;

function TBlockParEC.Block_GetName(no:integer):WideString;
var
    el:TBlockParElEC;
begin
	if m_Sort and (m_Cnt=m_CntBlock) then begin
    	Result:=m_Array[no].m_Name;
    end else begin
	    el:=m_First;
    	while el<>nil do begin
        	if (el.m_Tip=2) then begin
	            if no=0 then begin
    	            Result:=el.m_Name;
        	        Exit;
            	end;
	            Dec(no);
    	    end;
        	el:=el.m_Next;
	    end;
	    raise Exception.Create('TBlockParEC.Block_GetName. no=' + IntToStr(no));
    end;
end;

////////////////////////////////////////////////////////////////////////////////
function TBlockParEC.All_Count:integer;
begin
	Result:=m_Cnt;
end;
{var
    el:TBlockParElEC;
    count:integer;
begin
    el:=m_First;
    count:=0;
    while el<>nil do begin
        Inc(count);
        el:=el.m_Next;
    end;
    Result:=count;
end;}

function TBlockParEC.All_GetTip(no:integer):integer;
var
    el:TBlockParElEC;
begin
	if m_Sort and (m_Cnt=m_ArrayCnt) then begin
    	Result:=m_Array[no].m_Tip;
    end else begin
	    el:=m_First;
    	while el<>nil do begin
        	if no=0 then begin
	            Result:=el.m_Tip;
    	        Exit;
        	end;
	        Dec(no);
    	    el:=el.m_Next;
	    end;
	    raise Exception.Create('TBlockParEC.All_GetTip. no=' + IntToStr(no));
    end;
end;

function TBlockParEC.All_GetBlock(no:integer):TBlockParEC;
var
    el:TBlockParElEC;
begin
	if m_Sort and (m_Cnt=m_ArrayCnt) then begin
    	el:=m_Array[no];
		if el.m_Tip<>2 then raise Exception.Create('TBlockParEC.All_GetBlock. Error tip.');
    	Result:=el.m_Block;
    end else begin
	    el:=m_First;
    	while el<>nil do begin
        	if no=0 then begin
	            if el.m_Tip<>2 then raise Exception.Create('TBlockParEC.All_GetBlock. Error tip.');
    	        Result:=el.m_Block;
        	    Exit;
	        end;
    	    Dec(no);
        	el:=el.m_Next;
	    end;
    	raise Exception.Create('TBlockParEC.All_GetBlock. no=' + IntToStr(no));
    end;
end;

function TBlockParEC.All_GetPar(no:integer):WideString;
var
    el:TBlockParElEC;
begin
	if m_Sort and (m_Cnt=m_ArrayCnt) then begin
    	el:=m_Array[no];
		if el.m_Tip<>1 then raise Exception.Create('TBlockParEC.All_GetPar. Error tip.');
    	Result:=el.m_Zn;
    end else begin
	    el:=m_First;
    	while el<>nil do begin
        	if no=0 then begin
	            if el.m_Tip<>1 then raise Exception.Create('TBlockParEC.All_GetPar. Error tip.');
    	        Result:=el.m_Zn;
        	    Exit;
	        end;
    	    Dec(no);
        	el:=el.m_Next;
	    end;
    	raise Exception.Create('TBlockParEC.All_GetPar. no=' + IntToStr(no));
    end;
end;

function TBlockParEC.All_GetName(no:integer):WideString;
var
    el:TBlockParElEC;
begin
	if m_Sort and (m_Cnt=m_ArrayCnt) then begin
    	el:=m_Array[no];
		if (el.m_Tip<>1) and (el.m_Tip<>2) then raise Exception.Create('TBlockParEC.All_GetName. Error tip.');
    	Result:=el.m_Name;
    end else begin
	    el:=m_First;
    	while el<>nil do begin
        	if no=0 then begin
	            if (el.m_Tip<>1) and (el.m_Tip<>2) then raise Exception.Create('TBlockParEC.All_GetName. Error tip.');
    	        Result:=el.m_Name;
        	    Exit;
	        end;
    	    Dec(no);
        	el:=el.m_Next;
	    end;
    	raise Exception.Create('TBlockParEC.All_GetName. no=' + IntToStr(no));
    end;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TBlockParEC.SaveInBuf_r(tbuf:TBufEC; level:integer=0);
var
    tt:TBlockParElEC;
    i:integer;
begin
    tt:=m_First;
    while tt<>nil do begin
        if tt.m_Tip=0 then begin
            if tt.m_Com<>'' then tbuf.AddN0((tt.m_Com));
            tbuf.Add(WORD($0d));
            tbuf.Add(WORD($0a));
        end else if tt.m_Tip=1 then begin
            for i:=1 to level*4 do tbuf.Add(WORD(32));
            tbuf.AddN0((tt.m_Name));
            tbuf.Add(WORD(61));
            tbuf.AddN0((tt.m_Zn));
            if tt.m_Com<>'' then tbuf.AddN0((tt.m_Com));
            tbuf.Add(WORD($0d));
            tbuf.Add(WORD($0a));
        end else begin
            for i:=1 to level*4 do tbuf.Add(WORD(32));
            tbuf.AddN0((tt.m_Name));
            tbuf.Add(WORD(32));
            if m_Sort then tbuf.Add(WORD('^'))
            else tbuf.Add(WORD('~'));
            tbuf.Add(WORD(123));
            tbuf.Add(WORD($0d));
            tbuf.Add(WORD($0a));

            tt.m_Block.SaveInBuf_r(tbuf,level+1);

            for i:=1 to level*4 do tbuf.Add(WORD(32));
            tbuf.Add(WORD(125));
            if tt.m_Com<>'' then tbuf.AddN0((tt.m_Com));
            tbuf.Add(WORD($0d));
            tbuf.Add(WORD($0a));
        end;
        tt:=tt.m_Next;
    end;
end;

procedure TBlockParEC.SaveInBufAnsi_r(tbuf:TBufEC; level:integer=0);
var
    tt:TBlockParElEC;
    i:integer;
begin
    tt:=m_First;
    while tt<>nil do begin
        if tt.m_Tip=0 then begin
            if tt.m_Com<>'' then tbuf.AddN0(PAnsiChar(AnsiString(tt.m_Com)));
            tbuf.Add(BYTE($0d));
            tbuf.Add(BYTE($0a));
        end else if tt.m_Tip=1 then begin
            for i:=1 to level*4 do tbuf.Add(BYTE(32));
            tbuf.AddN0(PAnsiChar(AnsiString(tt.m_Name)));
            tbuf.Add(BYTE(61));
            tbuf.AddN0(PAnsiChar(AnsiString(tt.m_Zn)));
            if tt.m_Com<>'' then tbuf.AddN0(PAnsiChar(AnsiString(tt.m_Com)));
            tbuf.Add(BYTE($0d));
            tbuf.Add(BYTE($0a));
        end else begin
            for i:=1 to level*4 do tbuf.Add(BYTE(32));
            tbuf.AddN0(PAnsiChar(AnsiString(tt.m_Name)));
            tbuf.Add(BYTE(32));
            if m_Sort then tbuf.Add(BYTE('^'))
            else tbuf.Add(BYTE('~'));
            tbuf.Add(BYTE(123));
            tbuf.Add(BYTE($0d));
            tbuf.Add(BYTE($0a));

            tt.m_Block.SaveInBufAnsi_r(tbuf,level+1);

            for i:=1 to level*4 do tbuf.Add(BYTE(32));
            tbuf.Add(BYTE(125));
            if tt.m_Com<>'' then tbuf.AddN0(PAnsiChar(AnsiString(tt.m_Com)));
            tbuf.Add(BYTE($0d));
            tbuf.Add(BYTE($0a));
        end;
        tt:=tt.m_Next;
    end;
end;

procedure TBlockParEC.SaveInBuf(tbuf:TBufEC; fansi:boolean);
begin
    if not fansi then begin
        tbuf.Add(WORD($0FEFF));
        SaveInBuf_r(tbuf)
    end else SaveInBufAnsi_r(tbuf);
end;

procedure TBlockParEC.SaveInFile(filename:PAnsiChar; fansi:boolean);
var
    fa:TFileEC;
    tbuf:TBufEC;
begin
    fa:=TFileEC.Create;
    tbuf:=TBufEC.Create;
    try
        SaveInBuf(tbuf,fansi);
        fa.Init(filename);
        fa.CreateNew;
        fa.Write(tbuf.Buf,tbuf.Len);
        fa.Close;
    finally
        fa.Free;
        tbuf.Free;
    end;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TBlockParEC.LoadFromBuf_r(tbuf:TBufEC; const predstr:WideString; fa:boolean; fcom:boolean);
var
    tstr,tstr2,tstr3,com:WideString;
    tb:TBlockParEC;
    countpar:integer;
    tel:TBlockParElEC;
    zsort:boolean;
begin
    tstr:=TrimEx(predstr);
    while (not tbuf.TestEnd) do begin
        if tstr='' then begin
            if fa then tstr:=TrimEx(tbuf.GetAnsiTextStr) else tstr:=TrimEx(tbuf.GetWideTextStr);
        end;


        com:=GetComEC(tstr);
        tstr:=TrimEx(GetStrNoComEC(tstr));

        countpar:=GetCountParEC(tstr,'{');
        if countpar>1 then begin
            tstr2:=TrimEx(GetStrParEC(tstr,0,'{'));
            if tstr2='' then raise Exception.Create('TBlockParEC.LoadFromBuf_r. tstr=' + tstr);

            zsort:=tstr2[Length(tstr2)]='^';
            if zsort then begin
                SetLength(tstr2,Length(tstr2)-1);
                tstr2:=TrimEx(tstr2);
            end else begin
	            zsort:=tstr2[Length(tstr2)]<>'~';
                if not zsort then begin
	                SetLength(tstr2,Length(tstr2)-1);
    	            tstr2:=TrimEx(tstr2);
                end;
            end;

            tstr3:='';
            if GetCountParEC(tstr2,'=')=2 then begin
                tstr3:=TrimEx(GetStrParEC(tstr2,1,'='));
                tstr2:=TrimEx(GetStrParEC(tstr2,0,'='));
            end;

            tb:=Block_Add(tstr2);
            tb.m_Sort:=zsort;
            tstr2:=TrimEx(GetStrParEC(tstr,1,countpar-1,'{'));
            tb.LoadFromBuf_r(tbuf,tstr2,fa,fcom);

            if tstr3<>'' then begin
{if tstr3='cfg\Rus\Lang.txt' then begin
    if tstr3='cfg\Rus\Lang.txt' then begin end;
end;}
                tb.LoadFromFile(PAnsiChar(AnsiString(tstr3)));
            end;
        end else begin
            if GetCountParEC(tstr,'}')>1 then begin
                Exit;
            end;
            countpar:=GetCountParEC(tstr,'=');
            if countpar>1 then begin
                tstr2:=TrimEx(GetStrParEC(tstr,0,'='));
{if tstr2='Exit' then begin
    if tstr2='Exit' then begin end;
end;}
                tstr3:={Trim}(GetStrParEC(tstr,1,countpar-1,'='));
                if fcom then Par_Add(tstr2,tstr3).m_Com:=com
                else Par_Add(tstr2,tstr3);
            end else {if TrimEx(com)<>'' then} begin
                if fcom then begin
                    tel:=El_Add;
                    tel.m_Tip:=0;
                    tel.m_Com:=com;
                end;
            end;
        end;
        tstr:='';
    end;
end;

procedure TBlockParEC.LoadFromBuf(tbuf:TBufEC; fcom:boolean=false);
begin
    if tbuf.Len-tbuf.BPointer>2 then begin
        if tbuf.GetWORD<>$0feff then begin
            tbuf.BPointerSet(tbuf.BPointer-2);
            LoadFromBuf_r(tbuf,WideString(''),true,fcom);
        end else begin
            LoadFromBuf_r(tbuf,WideString(''),false,fcom);
        end;
    end;
end;

procedure TBlockParEC.LoadFromFile(filename:PAnsiChar; fcom:boolean=false);
var
    tbuf:TBufEC;
begin
    tbuf:=TBufEC.Create;
    try
        tbuf.LoadFromFile(filename);
        LoadFromBuf(tbuf,fcom);
    finally
        tbuf.Free;
    end;
end;

function TBlockParEC.LoadFromCA(ca:TCodeAnalyzerEC; caun:TCodeAnalyzerUnitEC):TCodeAnalyzerUnitEC;
var
    iscode,isblock,ispar,fend:boolean;
    tname,tstr:WideString;
    cntopen:integer;
begin
    if caun=nil then caun:=ca.FFirst;

    fend:=false;
    while (caun<>nil) and (not fend) do begin
        tstr:='';
        tname:='';
        iscode:=false;
        isblock:=false;
        ispar:=false;
        cntopen:=0;
        while caun<>nil do begin
            if (iscode) and (caun.FType=caeOpen2) then begin
                inc(cntopen);
                tstr:=tstr+ca.BuildStr(false,caun,caun.FNext);
            end else if (iscode) and (caun.FType=caeClose2) then begin
                dec(cntopen);
                if cntopen<0 then begin
                    caun:=caun.FNext;
                    break;
                end else begin
                    tstr:=tstr+ca.BuildStr(false,caun,caun.FNext);
                end;
            end else if (not iscode) and (caun.FType=caeClose2) then begin
                fend:=true;
                caun:=caun.FNext;
                break;
            end else if (not ispar) and (not iscode) and (caun.FType=caeNot) and (caun.FNext<>nil) and (caun.FNext.FType=caeOpen2) then begin
                tname:=TrimEx(tstr);
                tstr:='';
                iscode:=true;
                caun:=caun.FNext;
            end else if (not ispar) and (not iscode) and (caun.FType=caeOpen2) then begin
                tname:=TrimEx(tstr);
                tstr:='';
                isblock:=true;
                caun:=caun.FNext;
                break;
            end else if (not ispar) and (not iscode) and (caun.FType=caeAssume) then begin
                tname:=TrimEx(tstr);
                tstr:='';
                ispar:=true;
            end else if (not iscode) and (caun.FType=caeSemicolon) then begin
                caun:=caun.FNext;
                break;
            end else begin
                tstr:=tstr+ca.BuildStr(iscode,caun,caun.FNext);
            end;
            caun:=caun.FNext;
        end;

        if isblock then begin
            caun:=Block_Add(tname).LoadFromCA(ca,caun);
        end else if iscode then begin
            Par_Add(tname,tstr);
        end else if ispar then begin
            Par_Add(tname,tstr);
        end;

    end;
    Result:=caun;
end;

procedure TBlockParEC.Save(bd:TBufEC);
var
	el:TBlockParElEC;
    i:integer;
begin
	bd.AddBoolean(m_Sort);
	bd.AddInteger(m_CntPar+m_CntBlock);
    if not m_Sort then begin
        el:=m_First;
        while el<>nil do begin
        	if el.m_Tip=1 then begin
            	bd.AddBYTE(el.m_Tip);
                bd.Add(el.m_Name);
                bd.Add(el.m_Zn);
            end else if el.m_Tip=2 then begin
            	bd.AddBYTE(el.m_Tip);
                bd.Add(el.m_Name);
                el.m_Block.Save(bd);
            end;
        	el:=el.m_Next;
        end;
    end else begin
    	for i:=0 to m_ArrayCnt-1 do begin
        	el:=m_Array[i];
            bd.AddInteger(el.m_FastFirst);
            bd.AddInteger(el.m_FastCnt);
        	if el.m_Tip=1 then begin
            	bd.AddBYTE(el.m_Tip);
                bd.Add(el.m_Name);
                bd.Add(el.m_Zn);
            end else if el.m_Tip=2 then begin
            	bd.AddBYTE(el.m_Tip);
                bd.Add(el.m_Name);
                el.m_Block.Save(bd);
            end;
        end;
    end;
end;

procedure TBlockParEC.Load(bd:TBufEC);
var
	i,cnt:integer;
	el:TBlockParElEC;
begin
	Clear;
    m_Sort:=bd.GetBoolean;
    cnt:=bd.GetInteger;

    if m_Sort then begin
	    m_ArrayCnt:=cnt;
    	SetLength(m_Array,cnt);
    end;

    for i:=0 to cnt-1 do begin
    	el:=El_Add;
        if m_Sort then begin
            el.m_FastFirst:=bd.GetInteger;
            el.m_FastCnt:=bd.GetInteger;
        end;
	    el.m_Tip:=bd.GetBYTE();
	    el.m_Name:=bd.GetWideStr;

        if el.m_Tip=1 then begin
	        el.m_Zn:=bd.GetWideStr;
            inc(m_CntPar);
            if m_Sort then m_Array[i]:=el;

        end else if el.m_Tip=2 then begin
	        el.CreateBlock;
            if m_Sort then m_Array[i]:=el;
		    inc(m_CntBlock);
            el.m_Block.Load(bd);

        end;
    end;
end;

procedure TBlockParEC.Save(const filename:WideString);
var
	bd:TBufEC;
	fi:TFileEC;
begin
	bd:=TBufEC.Create;
    Save(bd);
//    bd.Compress;
    fi:=TFileEC.Create;
	fi.Init(PAnsiChar(AnsiString(filename)));
    fi.CreateNew;
    fi.Write(bd.Buf,bd.Len);
    bd.Free;
    fi.Free;
end;

procedure TBlockParEC.Load(const filename:WideString);
var
	bd:TBufEC;
begin
	bd:=TBufEC.Create;
    bd.LoadFromFile(PAnsiChar(AnsiString(filename)));
//    bd.UnCompress;
    Load(bd);
    bd.Free;
end;

end.

