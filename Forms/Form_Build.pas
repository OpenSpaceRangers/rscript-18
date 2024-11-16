unit Form_Build;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Math,
  GraphUnit, StdCtrls, Buttons, Mask, Grids;

type
TFormBuild = class(TForm)
    BitBtn1: TBitBtn;
    FilenameEditScript: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    EditTextSName: TEdit;
    BitBtnBuild: TBitBtn;
    Co: TMemo;
    FilenameEditText: TEdit;
    CheckBoxLite: TCheckBox;
    constructor Create(AOwner: TComponent); override;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtnBuildClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
private
    { Private declarations }
public
    { Public declarations }
    GNewNomTrasText:integer;
end;

procedure BuildRun;
function ApplySubs(str:WideString):WideString;

var
  FormBuild: TFormBuild;

implementation

{$R *.DFM}

uses Global,EC_Expression,EC_BlockPar,Main,EC_Str,EC_Buf,Form_Main,Form_Star,Form_StarShip,Form_StarLink,
     Form_Planet,Form_Place,Form_Item,Form_Group,Form_GroupLink,
     Form_State,Form_StateLink,Form_If,Form_Var,Form_Op,Form_Ether,Form_While,
     Form_Dialog,Form_DialogMsg,Form_DialogAnswer;

function ToCodeText(tstr:WideString):WideString;
begin
      Result:=StringReplace(tstr,#13#10,'<br>', [rfReplaceAll]);
      Result:=StringReplace(Result,'"','~quot~', [rfReplaceAll]);
      Result:=StringReplace(Result,'''','~apostrophe~', [rfReplaceAll]);
end;

procedure BuildRun;
begin
    FormBuild.ShowModal;
end;

constructor TFormBuild.Create(AOwner: TComponent);
var fl,fl2:boolean;
begin
  inherited Create(AOwner);

    try
      fl:=StrToBool(Settings('LiteBuildForce'));
    except
      fl:=false;
    end;
    FormBuild.CheckBoxLite.Checked := fl;
end;

procedure TFormBuild.FormShow(Sender: TObject);
begin
    EditTextSName.Text:=GScriptName;
    FilenameEditScript.Text:=GScriptFileOut;
    FilenameEditText.Text:=GScriptTextOut;
end;

procedure TFormBuild.BitBtn1Click(Sender: TObject);
begin
    GScriptName:=TrimEx(EditTextSName.Text);
    GScriptFileOut:=TrimEx(FilenameEditScript.Text);
    GScriptTextOut:=FilenameEditText.Text;
end;




////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
procedure Error(tstr:WideString);
begin
    raise EAbort.Create(tstr);
end;

procedure SortPointByPos(li:TList);
var
    i,u:integer;
    p1,p2:TGraphPoint;
begin
    for i:=0 to li.Count-2 do begin
        for u:=i+1 to li.Count-1 do begin
            p1:=li.Items[i];
            p2:=li.Items[u];
            if (p1.FPos.y>p2.FPos.y) or ((p1.FPos.y=p2.FPos.y) and (p1.FPos.x>p2.FPos.x)) then begin
                li.Items[i]:=p2;
                li.Items[u]:=p1;
            end;
        end;
    end;
end;

procedure SortPointByLink(ps:TGraphPoint; li:TList);
var
    i,u:integer;
    p1,p2:TGraphPoint;
    l1,l2:TStateLink;
begin
    for i:=0 to li.Count-2 do begin
        for u:=i+1 to li.Count-1 do begin
            p1:=li.Items[i];
            p2:=li.Items[u];
            l1:=FindLink(ps,p1) as TStateLink;
            l2:=FindLink(ps,p2) as TStateLink;
            if l1.FPriority>l2.FPriority then begin
                li.Items[i]:=p2;
                li.Items[u]:=p1;
            end;
        end;
    end;
end;

procedure BuildCode_r(gp:TGraphPoint; var sc:WideString; var insertto:integer; liststate:TList; listdialogmsg:TList; listdialoganswer:TList; level:WideString);
var
    i:integer;
    li:TList;
    gpt:TGraphPoint;
    pop:Top;
    pif:Tif;
    pwhile:Twhile;
    pether:TEther;
    tstr:WideString;
begin
  li:=TList.Create;

  FindAllLinkPoint(gp,'Top',li);
  FindAllLinkPoint(gp,'TEther',li,true);
  SortPointByPos(li);
  for i:=0 to li.Count-1 do begin
    gpt:=li.Items[i];

    if gpt is Top then begin
      pop:=gpt as Top;

      tstr:=StringReplace(pop.FExpr, #13#10, #13#10+level, [rfReplaceAll]);
      tstr:=level + tstr + ';' + #13#10;
      tstr:=StringReplace(tstr,';;', ';', [rfReplaceAll]);
      tstr:=StringReplace(tstr,'};', '}', [rfReplaceAll]);

      StringInsertEC(sc,insertto,tstr); insertto:=insertto+Length(tstr);

    end else begin
      pether:=gpt as TEther;

      tstr:=level+'Ether('+IntToStr(pether.FType)+','''+pether.FUnique+''',"'+ToCodeText(pether.FMsg)+'"';
      if TrimEx(pether.FShip1)<>'' then tstr:=tstr+','+pether.FShip1;
      if TrimEx(pether.FShip2)<>'' then tstr:=tstr+','+pether.FShip2;
      if TrimEx(pether.FShip3)<>'' then tstr:=tstr+','+pether.FShip3;
      tstr:=tstr+');'+#13#10;
      StringInsertEC(sc,insertto,tstr); insertto:=insertto+Length(tstr);
    end;

    BuildCode_r(gpt,sc,insertto,liststate,listdialogmsg,listdialoganswer,level{+'  '});
  end;

  FindAllLinkPoint(gp,'Tif',li);
  SortPointByPos(li);
  for i:=0 to li.Count-1 do begin
    pif:=li.Items[i];

    tstr:=StringReplace(pif.FExpr, #13#10, #13#10+level, [rfReplaceAll]);
    if(tstr = '1') then begin
      BuildCode_r(pif,sc,insertto,liststate,listdialogmsg,listdialoganswer,level);
      tstr:='';
    end else begin
      tstr:=level + 'if(' + tstr +') {' + #13#10;
      StringInsertEC(sc,insertto,tstr); insertto:=insertto+Length(tstr);

      BuildCode_r(pif,sc,insertto,liststate,listdialogmsg,listdialoganswer,level+'  ');

      tstr:=level+'}'+#13#10;
    end;

    StringInsertEC(sc,insertto,tstr); insertto:=insertto+Length(tstr);
  end;

  FindAllLinkPoint(gp,'Twhile',li);
  SortPointByPos(li);
  for i:=0 to li.Count-1 do begin
    pwhile:=li.Items[i];

    tstr:=StringReplace(pwhile.FExpr, #13#10, #13#10+level, [rfReplaceAll]);

    tstr:=level + 'while(' + tstr +') {' + #13#10;
    StringInsertEC(sc,insertto,tstr); insertto:=insertto+Length(tstr);

    BuildCode_r(pwhile,sc,insertto,liststate,listdialogmsg,listdialoganswer,level+'  ');

    tstr:=level+'}'+#13#10;
    StringInsertEC(sc,insertto,tstr); insertto:=insertto+Length(tstr);
  end;

  FindAllLinkPoint(gp,'TState',li);
  if gp is TState then begin
    SortPointByLink(gp,li);
    for i:=0 to li.Count-1 do begin
      if liststate=nil then Error('Code to state');
      tstr:=level+'if('+TStateLink(FindLink(gp,li.Items[i])).FExpr+') {'+#13#10;
      tstr:=tstr+level+'    '+'ChangeState('+IntToStr(liststate.IndexOf(li.Items[i]))+');'+#13#10;
      tstr:=tstr+level+'    '+'exit;'+#13#10;
      tstr:=tstr+level+'}'+#13#10;
      StringInsertEC(sc,insertto,tstr); insertto:=insertto+Length(tstr);
    end;
  end else begin
    SortPointByPos(li);
    if li.Count>0 then begin
      if liststate=nil then Error('Code to state');
      tstr:=level+'ChangeState('+IntToStr(liststate.IndexOf(li.Items[0]))+');'+#13#10;
      tstr:=tstr+level+'exit;'+#13#10;
      StringInsertEC(sc,insertto,tstr); insertto:=insertto+Length(tstr);
    end;
  end;

  FindAllLinkPoint(gp,'TDialogMsg',li);
  if li.Count>0 then begin
    if listdialogmsg=nil then Error('Code to DialogMsg');
    tstr:=level+'DChange('+IntToStr(listdialogmsg.IndexOf(li.Items[0]))+');'+#13#10;
    tstr:=tstr+level+'exit;'+#13#10;
    StringInsertEC(sc,insertto,tstr); insertto:=insertto+Length(tstr);
  end;

  FindAllLinkPoint(gp,'TDialogAnswer',li);
  for i:=0 to li.Count-1 do begin
    if listdialoganswer=nil then Error('Code to DialogAnswer');
    tstr:=level+'DAdd('+IntToStr(listdialoganswer.IndexOf(li.Items[i]))+');'+#13#10;
    StringInsertEC(sc,insertto,tstr); insertto:=insertto+Length(tstr);
  end;

  li.Free;
end;


function BuildCode(gp:TGraphPoint; liststate:TList; listdialogmsg:TList; listdialoganswer:TList; level:WideString=''):WideString;
var
  insertto:integer;
  tstr:WideString;
begin
  insertto:=0;
  Result:='';

  if gp is Top then begin

    tstr:=StringReplace(Top(gp).FExpr, #13#10, #13#10 + level, [rfReplaceAll]);
    tstr:=level + tstr + ';' + #13#10;
    tstr:=StringReplace(tstr,';;', ';', [rfReplaceAll]);
    tstr:=StringReplace(tstr,'};', '}', [rfReplaceAll]);

    StringInsertEC(Result,insertto,tstr); insertto:=insertto+Length(tstr);

  end else if(gp is Tif) or (gp is Twhile) then begin
    if(gp is Tif) and (Tif(gp).FExpr = '1') then
    else begin
      tstr:=level;
      if(gp is Tif) then tstr:=tstr+'if('+Tif(gp).FExpr
      else tstr:=tstr+'while('+Twhile(gp).FExpr;
      tstr:=tstr+') {'+#13#10;

      StringInsertEC(Result,insertto,tstr); insertto:=insertto+Length(tstr);
      tstr:=level+'}'+#13#10;
      StringInsertEC(Result,insertto,tstr);

      level:=level+'  ';
    end;
  end;

  BuildCode_r(gp,Result,insertto,liststate,listdialogmsg,listdialoganswer,level);
end;

function ApplySubs(str:WideString):WideString;
var
    tstrlen,startt,endt,cnt:integer;
    ts,ts2,tstr:WideString;
    sl:TStringList;
    i:integer;
begin
    tstr:=str;
    tstr:=StringReplace(tstr,#13#10,'<br>', [rfReplaceAll]);
    cnt:=0;
    startt:=0;
    while True do begin
        tstrlen:=Length(tstr);
        while startt<tstrlen do begin
            if tstr[startt+1]='<' then break;
            inc(startt);
        end;
        if startt>=tstrlen then break;

        endt:=FindEndTagEC(tstr,startt);
        if endt<0 then break;

        ts:=Copy(tstr,startt+1,endt-startt+1);
        if (Length(ts)<3) or
           (LowerCase(ts)='<br>') or
           (LowerCase(ts)='<player>') or
           (LowerCase(ts)='<playerfull>') or
           (LowerCase(ts)='<clr>') or
           (LowerCase(ts)='<clrend>') or
           (FindSubstringEC(LowerCase(ts),'<color')>=0) or
           (FindSubstringEC(LowerCase(ts),'</color')>=0) then
        begin
            startt:=endt+1; continue;
        end;

        if (LowerCase(ts)='<name(player())>') then begin
            ts2:='<PlayerFull>';
            StringDeleteEC(tstr,startt,endt-startt+1);
            StringInsertEC(tstr,startt,ts2);
            startt:=startt+Length(ts2);
            continue;
        end else if (LowerCase(ts)='<shortname(player())>') then begin
            ts2:='<Player>';
            StringDeleteEC(tstr,startt,endt-startt+1);
            StringInsertEC(tstr,startt,ts2);
            startt:=startt+Length(ts2);
            continue;
        end;

        ts2:='<'+IntToStr(cnt)+'>';

        StringDeleteEC(tstr,startt,endt-startt+1);
        StringInsertEC(tstr,startt,ts2);
        startt:=startt+Length(ts2);

        inc(cnt);
    end;
    Result:=tstr;
end;

function BuildCodeText_d(tstr:WideString; bt:TBlockParEC; textpath:WideString):WideString;
var
    tstrlen,startt,endt,cnt:integer;
    ts,ts2:WideString;
    sl:TStringList;
    i:integer;
begin
    sl:=TStringList.Create;

    cnt:=0;
    startt:=0;
    while True do begin
        tstrlen:=Length(tstr);
        while startt<tstrlen do begin
            if tstr[startt+1]='<' then break;
            inc(startt);
        end;
        if startt>=tstrlen then break;

        endt:=FindEndTagEC(tstr,startt);
        if endt<0 then break;

        ts:=Copy(tstr,startt+1,endt-startt+1);
        if (Length(ts)<3) or
           (LowerCase(ts)='<br>') or
           (LowerCase(ts)='<player>') or
           (LowerCase(ts)='<playerfull>') or
           (LowerCase(ts)='<clr>') or
           (LowerCase(ts)='<clrend>') or
           (FindSubstringEC(LowerCase(ts),'<color')>=0) or
           (FindSubstringEC(LowerCase(ts),'</color')>=0) then
        begin
            startt:=endt+1; continue;
        end;

        if (LowerCase(ts)='<name(player())>') then begin
            ts2:='<PlayerFull>';
            StringDeleteEC(tstr,startt,endt-startt+1);
            StringInsertEC(tstr,startt,ts2);
            startt:=startt+Length(ts2);
            continue;
        end else if (LowerCase(ts)='<shortname(player())>') then begin
            ts2:='<Player>';
            StringDeleteEC(tstr,startt,endt-startt+1);
            StringInsertEC(tstr,startt,ts2);
            startt:=startt+Length(ts2);
            continue;
        end;

        ts2:='<'+IntToStr(cnt)+'>';

        StringDeleteEC(tstr,startt,endt-startt+1);
        StringInsertEC(tstr,startt,ts2);
        startt:=startt+Length(ts2);

        sl.Add('"'+ts2+'"');
        sl.Add(Copy(ts,2,Length(ts)-2));

        inc(cnt);
    end;

  if tstr[1]='"' then begin
    ts:=Copy(tstr,2,Length(tstr)-2);
    ts:=StringReplace(ts,'~quot~','"', [rfReplaceAll]);
    ts:=StringReplace(ts,'~apostrophe~','''', [rfReplaceAll]);

    cnt:=GScriptTranslateId.Par_Count;
    i:=0;
    while i<cnt do begin
      if GScriptTranslateId.Par_Get(i)=ts then break;
      inc(i);
    end;
    if i<cnt then begin
      i:=StrToIntEC(GScriptTranslateId.Par_GetName(i));
      bt.ParNE[IntToStr(i)]:=ts;
    end else begin
      cnt:=bt.Par_Count;
      i:=0;
      while i<cnt do begin
        if bt.Par_Get(i)=ts then break;
        inc(i);
      end;
      if i>=cnt then begin
        i:=FormBuild.GNewNomTrasText;
        inc(FormBuild.GNewNomTrasText);
        bt.ParNE[IntToStr(i)]:=ts;
      end else i:=StrToIntEC(bt.Par_GetName(i));
    end;
    tstr:='CT("'+textpath+IntToStr(i)+'")';
  end;

  if sl.Count>0 then begin
    Result:='Format('+tstr;
    for i:=0 to sl.Count-1 do Result:=Result+','+sl.Strings[i];
    Result:=Result+')';
  end else begin
    Result:=tstr;
  end;

  sl.Free;
end;

procedure BuildCodeText(var tstr:WideString; bt:TBlockParEC; textpath:WideString);
var
    ca:TCodeAnalyzerEC;
    cau:TCodeAnalyzerUnitEC;
    tstr2:WideString;
begin

    ca:=TCodeAnalyzerEC.Create;
    ca.Clear; ca.Build(tstr); ca.DelCom; ca.DelSpace; ca.DelEnter;

    cau:=ca.FLast;
    while cau<>nil do begin
        while cau<>nil do begin
            if cau.FType=caeStr then break;
            cau:=cau.FPrev;
        end;
        if cau=nil then break;

        if tstr[cau.FSme+1]='"' then tstr2:=BuildCodeText_d('"'+cau.FStr+'"',bt,textpath)
        else tstr2:=BuildCodeText_d(''''+cau.FStr+'''',bt,textpath);
        if tstr2<>cau.FStr then begin
            StringDeleteEC(tstr,cau.FSme,cau.FLen);
            StringInsertEC(tstr,cau.FSme,tstr2);
        end;

        cau:=cau.FPrev;
    end;

    ca.Free;

end;

procedure TFormBuild.BitBtnBuildClick(Sender: TObject);
var
    bs,bsz:TBufEC;
    bt,bt2:TBlockParEC;
    i,u,zn,zn2,cnt,cntu:integer;
    li,li2,listar,ligroup,listate,lidialogmsg,lidialoganswer:TList;
    pg:TGraphPoint;
    ps,ps2:TStar;
    psl:TStarLink;
    pss:TStarShip;
    pp:TPlanet;
    pplace:TPlace;
    pitem:TItem;
    pgroup:TGroup;
    pgl:TGroupLink;
    pstate:TState;
    pv:TVar;
    pop:Form_Op.Top;
    pdmsg:TDialogMsg;
    pdanswer:TDialogAnswer;
    svar:TVarArrayEC;
    svar_g:TVarArrayEC;
    new_arr:TVarArrayEC;
    new_v:TVarEC;
    tstr,tstr2:WideString;
    ca:TCodeAnalyzerEC;
    code:TCodeEC;
    arconst:array of integer;

    procedure TestCode;
    begin
      ca.Clear; ca.Build(tstr); ca.DelCom; ca.DelSpace; ca.DelEnter;
      code.Clear; tstr2:=code.Compiler(ca,0);
      if tstr2<>'' then Error(tstr2);
    end;
begin

    GScriptName:=TrimEx(EditTextSName.Text);
    GScriptFileOut:=TrimEx(FilenameEditScript.Text);
    GScriptTextOut:=TrimEx(FilenameEditText.Text);

    Co.Lines.Clear;

    li:=TList.Create;
    li2:=TList.Create;
    listar:=TList.Create;
    ligroup:=TList.Create;
    listate:=TList.Create;
    lidialogmsg:=TList.Create;
    lidialoganswer:=TList.Create;
    bs:=TBufEC.Create;
    bsz:=TBufEC.Create;
    bt:=TBlockParEC.Create;
    bt2:=TBlockParEC.Create;
    svar:=TVarArrayEC.Create;
    svar_g:=TVarArrayEC.Create;
    ca:=TCodeAnalyzerEC.Create;
    code:=TCodeEC.Create;

    try
        if CheckBoxLite.Checked = true then Co.Lines.Add('Wait a moment');

        GNewNomTrasText:=-1;
        for i:=0 to GScriptTranslateId.Par_Count-1 do begin
            GNewNomTrasText:=max(GNewNomTrasText,StrToIntEC(GScriptTranslateId.Par_GetName(i)));
        end;
        inc(GNewNomTrasText);

        if Length(GScriptName)<1 then Error('Script name error');
        if Length(GScriptFileOut)<1 then Error('Script filename error');
        if Length(GScriptTextOut)<1 then Error('Text filename error');

        bsz.AddDWORD(PVersion);
        bsz.AddDWORD(0);

        // Variable global
        FindAllPoint('TVar',li);
        for i:=0 to li.Count-1 do begin
            pv:=li.Items[i];

            if not pv.FGlobal then continue;

            tstr:=pv.FText;
            if tstr<>TrimEx(tstr) then Error('Variable name : '+tstr);
            if Length(tstr)<1 then Error('Variable name');
            if svar_g.GetVarNE(tstr)<>nil then Error('Variable name not unique');

            if pv.FType=0 then svar_g.Add(tstr,vtUnknown)
            else if pv.FType=1 then svar_g.Add(tstr,vtInt).VInt:=StrToIntFullEC(pv.FInit)
            else if pv.FType=2 then svar_g.Add(tstr,vtDW).VDW:=StrToIntEC(pv.FInit)
            else if pv.FType=3 then svar_g.Add(tstr,vtStr).VStr:=pv.FInit
            else if pv.FType=4 then svar_g.Add(tstr,vtFloat).VFloat:=StrToFloatEC(pv.FInit)
            else if pv.FType=5 then
            begin
              new_arr:=TVarArrayEC.Create;
              svar_g.Add(tstr,vtArray).VArray:=new_arr;
              if (Length(pv.FInit)>2) and (pv.FInit[1]='[') then
              begin
                u:=FindSubstring(pv.FInit,']');
                tstr:=Copy(pv.FInit,2,u-1);
                cnt:=GetCountParEC(tstr,',');
                for u:=0 to cnt-1 do
                begin
                  new_v:=TVarEC.Create(vtUnknown);
                  tstr2:=GetStrParEC(tstr,u,',');
                  if IsIntEC(tstr2) then new_v.VInt:=StrToIntEC(tstr2)
                  else if tstr2<>'' then new_v.VStr:=tstr2;
                  new_arr.Add(new_v);
                end;
              end else begin
                cnt:=max(1,StrToIntEC(pv.FInit));
                for u:=0 to cnt-1 do new_arr.Add(TVarEC.Create(vtUnknown));
              end;
            end;
        end;
        svar_g.Save(bsz);

        // Top,Tif no link
        FindAllPoint('Top',li);
        FindAllPoint('Tif',li2);
        for i:=0 to li2.Count-1 do li.Add(li2.Items[i]);
        FindAllPoint('Twhile',li2);
        for i:=0 to li2.Count-1 do li.Add(li2.Items[i]);
        i:=0;
        while i<li.Count do begin
            pg:=li.Items[i];
            u:=0;
            while u<GGraphLink.Count do begin
                if TGraphLink(GGraphLink.Items[u]).FEnd=pg then break;
                inc(u);
            end;
            if u<GGraphLink.Count then begin
                li.Delete(i);
            end else inc(i);
        end;
        SortPointByPos(li);

        // Global run
        if CheckBoxLite.Checked = false then Co.Lines.Add('Global code {');
        tstr:='';
        for i:=0 to li.Count-1 do begin
            pg:=li.Items[i];
            if ((pg is Tif) and ((pg as Tif).FType=2)) or ((pg is Form_Op.Top) and ((pg as Form_Op.Top).FType=2)) or ((pg is Twhile) and ((pg as Twhile).FType=2)) then begin
                tstr:=tstr + BuildCode(pg,nil,nil,nil,'  ');
            end;
        end;

        tstr:=GetStrParEC(tstr, 0, GetCountParEC(tstr, #13#10)-2, #13#10); // added by Koc - удаление последней пустой строки

        BuildCodeText(tstr,bt,'Script.'+GScriptName+'.');
        if CheckBoxLite.Checked = false then
        begin
          Co.Lines.Add(tstr);
          Co.Lines.Add('}');
        end;

        TestCode;
        bsz.Add(tstr);

        bsz.S(4,DWORD(bsz.BPointer));

        // Variable local
        FindAllPoint('TVar',li);
        for i:=0 to li.Count-1 do begin
            pv:=li.Items[i];

            if pv.FGlobal then continue;

            tstr:=pv.FText;
            if tstr<>TrimEx(tstr) then Error('Variable name : '+tstr);
            if Length(tstr)<1 then Error('Variable name');
            if (svar.GetVarNE(tstr)<>nil) or (svar_g.GetVarNE(tstr)<>nil) then Error('Variable name not unique');

            if pv.FType=0 then svar.Add(tstr,vtUnknown)
            else if pv.FType=1 then svar.Add(tstr,vtInt).VInt:=StrToIntFullEC(pv.FInit)
            else if pv.FType=2 then svar.Add(tstr,vtDW).VDW:=StrToIntEC(pv.FInit)
            else if pv.FType=3 then svar.Add(tstr,vtStr).VStr:=pv.FInit
            else if pv.FType=4 then svar.Add(tstr,vtFloat).VFloat:=StrToFloatEC(pv.FInit)
            else if pv.FType=5 then
            begin
              new_arr:=TVarArrayEC.Create;
              svar.Add(tstr,vtArray).VArray:=new_arr;
              if (Length(pv.FInit)>2) and (pv.FInit[1]='[') then
              begin
                u:=FindSubstring(pv.FInit,']');
                tstr:=Copy(pv.FInit,2,u-1);
                cnt:=GetCountParEC(tstr,',');
                for u:=0 to cnt-1 do
                begin
                  new_v:=TVarEC.Create(vtUnknown);
                  tstr2:=GetStrParEC(tstr,u,',');
                  if IsIntEC(tstr2) then new_v.VInt:=StrToIntEC(tstr2)
                  else if tstr2<>'' then new_v.VStr:=tstr2;
                  new_arr.Add(new_v);
                end;
              end else begin
                cnt:=max(1,StrToIntEC(pv.FInit));
                for u:=0 to cnt-1 do new_arr.Add(TVarEC.Create(vtUnknown));
              end;
            end;
        end;

        // Find DialogMsg
        FindAllPoint('TDialogMsg',lidialogmsg);

        // Find DialogAnswer
        FindAllPoint('TDialogAnswer',lidialoganswer);

        // Find state
        FindAllPoint('TState',listate); if listate.Count<1 then Error('State not found');

        // Find star
        FindAllPoint('TStar',listar); if listar.Count<1 then Error('Star not found');

        FindAllPointLinkFull('TStarShip','TStar',li2);
        if li2.Count<1 then Error('Player''s start not found');
        u:=0;
        for i:=0 to li2.Count-1 do begin
            pss:=li2.Items[i];
            if pss.FPlayer then inc(u);
        end;
        if u<>1 then Error('Player''s start');
        for i:=0 to li2.Count-1 do begin
            pss:=li2.Items[i];
            if pss.FPlayer then begin
                FindAllLinkPointFull(pss,'TStar',li2);
                if li2.Count<>1 then Error('Player''s start');
                break;
            end;
        end;

        // Star sort
        for i:=0 to listar.Count-2 do begin
            for u:=i+1 to listar.Count-1 do begin
                if TStar(listar[i]).FPriority>TStar(listar[u]).FPriority then begin
                    ps:=listar.Items[i];
                    listar.Items[i]:=listar.Items[u];
                    listar.Items[u]:=ps;
                end;
            end;
        end;
        if listar.Count>=2 then begin
            if TStar(listar.Items[0]).FPriority=TStar(listar.Items[1]).FPriority then begin
                Error('Star priority. First unique');
            end;
        end;

        // Constellation
        SetLength(arconst,listar.Count);
        zn:=0;
        for i:=0 to listar.Count-1 do begin
            if (TStar(listar[i]).FConstellation-1)>=0 then begin
                u:=0;
                while u<zn do begin
                    if arconst[u]=(TStar(listar[i]).FConstellation-1) then break;
                    inc(u);
                end;
                if u>=zn then begin
                    arconst[zn]:=TStar(listar[i]).FConstellation-1;
                    inc(zn);
                end;
            end;
        end;
        for i:=0 to zn-2 do begin
            for u:=i+1 to zn-1 do begin
                if arconst[i]>arconst[u] then begin
                    zn2:=arconst[i];
                    arconst[i]:=arconst[u];
                    arconst[u]:=zn2;
                end;
            end;
        end;
        if zn>0 then begin
            if arconst[zn-1]<>(zn-1) then Error('Constellation');
        end;
        bs.AddInteger(zn);

        // Star and if
        bs.AddInteger(listar.Count);
        for i:=0 to listar.Count-1 do begin
            ps:=listar.Items[i];
            tstr:=ps.FText;
            if tstr<>TrimEx(tstr) then Error('Star name : '+tstr);
            if Length(tstr)<1 then Error('Star name');
            if svar.GetVarNE(tstr)<>nil then Error('Star name not unique');
            bs.Add(tstr);
            svar.Add(tstr,vtDW).VDW:=i;

            if CheckBoxLite.Checked = false then Co.Lines.Add('Star : '+tstr);

            bs.AddInteger(ps.FConstellation-1);
            //bs.AddBoolean(false);
            bs.AddBoolean(ps.FNoKling);
            bs.AddBoolean(ps.FNoComeKling);

            FindAllLinkPointFull(ps,'TStar',li);
            u:=0;
            while u<li.Count do begin
                ps2:=li.Items[u];
                psl:=FindLinkFull(ps,ps2) as TStarLink;
                if listar.IndexOf(ps2)>=i then li.Delete(u)
                else if (psl.FDistMin<=0)
                    and (psl.FDistMax>=150) and not psl.FHole then li.Delete(u)
                else inc(u);
            end;

            bs.AddInteger(li.Count);
            for u:=0 to li.Count-1 do begin
                ps2:=li.Items[u];
                bs.AddDWORD(listar.IndexOf(ps2));
                psl:=FindLinkFull(ps,ps2) as TStarLink;
                //zn:=Round(ArcTan2(ps.FPos.x-ps2.FPos.x,-(ps.FPos.y-ps2.FPos.y))*(180.0/3.1415926));
                //if zn<0 then zn:=360+zn;
                //bs.AddInteger(zn);
                bs.AddInteger(psl.FDistMin);
                bs.AddInteger(psl.FDistMax);
                //bs.AddInteger(0);
                //bs.AddInteger(0);
                //bs.AddInteger(0);
                bs.AddBoolean(psl.FHole);
            end;

            // Planet
            FindAllLinkPointFull(ps,'TPlanet',li);
            bs.AddInteger(li.Count);
            for u:=0 to li.Count-1 do begin
                pp:=li.Items[u];
                tstr:=pp.FText;
                if tstr<>TrimEx(tstr) then Error('Planet name : '+tstr);
                if Length(tstr)<1 then Error('Planet name');
                if svar.GetVarNE(tstr)<>nil then Error('Planet name not unique');
                bs.Add(tstr);
                svar.Add(tstr,vtDW).VDW:=0;

                if CheckBoxLite.Checked = false then Co.Lines.Add('  Planet : '+tstr);

                bs.AddDWORD(pp.FRace);
                bs.AddDWORD(pp.FOwner);
                bs.AddDWORD(pp.FEconomy);
                bs.AddDWORD(pp.FGoverment);
                bs.AddInteger(pp.FRangeMin);
                bs.AddInteger(pp.FRangeMax);
                if pp.FDialog=nil then bs.Add(WideString(''))
                else bs.Add(pp.FDialog.FText);
            end;

            // Ship
            FindAllLinkPointFull(ps,'TStarShip',li);
            bs.AddInteger(li.Count);
            for u:=0 to li.Count-1 do begin
                pss:=li.Items[u];

                bs.AddInteger(pss.FCount);
                bs.AddDWORD(pss.FOwner);
                bs.AddDWORD(pss.FType);
                bs.AddBoolean(pss.FPlayer);
                bs.AddInteger(pss.FSpeedMin);
                bs.AddInteger(pss.FSpeedMax);
                bs.AddInteger(pss.FWeapon);
                bs.AddInteger(pss.FCargoHook);
                bs.AddInteger(pss.FEmptySpace);
                //bs.AddInteger(0);
                //bs.AddInteger(0);
                bs.AddInteger(pss.FStatusTraderMin);
                bs.AddInteger(pss.FStatusTraderMax);
                bs.AddInteger(pss.FStatusWarriorMin);
                bs.AddInteger(pss.FStatusWarriorMax);
                bs.AddInteger(pss.FStatusPirateMin);
                bs.AddInteger(pss.FStatusPirateMax);
                //bs.AddInteger(0);
                //bs.AddInteger(0);
                bs.AddSingle(pss.FStrengthMin);
                bs.AddSingle(pss.FStrengthMax);
                bs.Add(pss.FRuins);
            end;
        end;

        // Place
        FindAllPoint('TPlace',li);
        bs.AddInteger(li.Count);
        for i:=0 to li.Count-1 do begin
            pplace:=li.Items[i];

            tstr:=pplace.FText;
            if tstr<>TrimEx(tstr) then Error('Place name : '+tstr);
            if Length(tstr)<1 then Error('Place name');
            if svar.GetVarNE(tstr)<>nil then Error('Place name not unique');
            bs.Add(tstr);
            svar.Add(tstr,vtDW).VDW:=0;

            if CheckBoxLite.Checked = false then Co.Lines.Add('Place : '+tstr);

            FindAllLinkPointFull(pplace,'TStar',li2);
            if li2.Count>1 then Error('Place')
            else if li2.Count<1 then bs.Add(WideString(''))
            else bs.Add(TStar(listar[listar.IndexOf(li2.Items[0])]).FText);

            bs.AddInteger(pplace.FType);

            if pplace.FType=0 then begin // Free
                bs.AddSingle(pplace.FAngle);
                bs.AddSingle(pplace.FDist);
                bs.AddInteger(pplace.FRadius);
            end else if pplace.FType=1 then begin // Near planet
                if pplace.FObj1=nil then Error('Place : '+pplace.FText);
                bs.Add(pplace.FObj1.FText);
                bs.Add(pplace.FRadius);
            end else if pplace.FType=2 then begin // In Planet
                if pplace.FObj1=nil then Error('Place : '+pplace.FText);
                bs.Add(pplace.FObj1.FText);
            end else if pplace.FType=3 then begin // To star
                if pplace.FObj1=nil then Error('Place : '+pplace.FText);
                bs.Add(pplace.FObj1.FText);
                bs.AddSingle(pplace.FDist);
                bs.AddInteger(pplace.FRadius);
                bs.AddSingle(pplace.FAngle);
            end else if pplace.FType=4 then begin // Near item
                if pplace.FObj1=nil then Error('Place : '+pplace.FText);
                bs.Add(pplace.FObj1.FText);
                bs.Add(pplace.FRadius);
            end else if pplace.FType=5 then begin // From ship
                if pplace.FObj1=nil then Error('Place : '+pplace.FText);
                bs.Add(pplace.FObj1.FText);
                bs.AddSingle(pplace.FDist);
                bs.AddInteger(pplace.FRadius);
                bs.AddSingle(pplace.FAngle);
            end else if pplace.FType=6 then begin // coords
                if pplace.FObj1=nil then Error('Var : '+pplace.FText);
                if pplace.FObj2=nil then Error('Var : '+pplace.FText);
                bs.Add(pplace.FObj1.FText);
                bs.Add(pplace.FObj2.FText);
                bs.AddInteger(pplace.FRadius);
            end;
        end;

        // Items
        FindAllPoint('TItem',li);
        bs.AddInteger(li.Count);
        for i:=0 to li.Count-1 do begin
            pitem:=li.Items[i];

            tstr:=pitem.FText;
            if tstr<>TrimEx(tstr) then Error('Items name : '+tstr);
            if Length(tstr)<1 then Error('Items name');
            if svar.GetVarNE(tstr)<>nil then Error('Item name not unique');
            bs.Add(tstr);
            svar.Add(tstr,vtDW).VDW:=0;

            if CheckBoxLite.Checked = false then Co.Lines.Add('Item : '+tstr);

            FindAllLinkPointFull(pitem,'TPlace',li2);
            if li2.Count<1 then begin
                FindAllLinkPointFull(pitem,'TGroup',li2);
                if li2.Count<1 then begin
                    FindAllLinkPointFull(pitem,'TPlanet',li2);
                    if li2.Count<>1 then begin
                        if pitem.FMainType<>5 then Error('Place')
                    end;
                end else if li2.Count<>1 then begin
                    if pitem.FMainType<>5 then Error('Place')
                end;
            end else begin
                pplace:=li2.Items[0];
                if (pplace.FType=2) or (pplace.FType=4) then Error('Place : '+pplace.FText+' Item : '+pitem.FText);
            end;

            if li2.Count>0 then bs.Add(TGraphPoint(li2.Items[0]).FText)
            else bs.Add(WideString(''));

            bs.AddInteger(pitem.FMainType);
            bs.AddInteger(pitem.FType);
            bs.AddInteger(pitem.FSize);
            bs.AddInteger(pitem.FLavel);
            bs.AddInteger(pitem.FRadius);
            bs.AddInteger(pitem.FOwner);
            bs.Add(pitem.FUseless);
        end;

        // Group
        FindAllPoint('TGroup',ligroup);
        bs.AddInteger(ligroup.Count);
        if ligroup.Count<1 then Error('Group not found');
        for i:=0 to ligroup.Count-1 do begin
            pgroup:=ligroup.Items[i];

            tstr:=pgroup.FText;
            if tstr<>TrimEx(tstr) then Error('Group name : '+tstr);
            if Length(tstr)<1 then Error('Group name');
            if svar.GetVarNE(tstr)<>nil then Error('Group name not unique');
            bs.Add(tstr);
            svar.Add(tstr,vtDW).VDW:=i;

            if CheckBoxLite.Checked = false then Co.Lines.Add('Group : '+tstr);

            FindAllLinkPointFull(pgroup,'TPlanet',li);
            if li.Count<>1 then Error('Group-Planet');
            bs.Add(TGraphPoint(li.Items[0]).FText);

            FindAllLinkPointFull(pgroup,'TState',li);
            if li.Count<>1 then Error('Group-State');
            bs.AddInteger(listate.IndexOf(li.Items[0]));

            bs.AddDWORD(pgroup.FOwner);
            bs.AddDWORD(pgroup.FType);
            bs.AddInteger(pgroup.FCntShipMin);
            bs.AddInteger(pgroup.FCntShipMax);
            bs.AddInteger(pgroup.FSpeedMin);
            bs.AddInteger(pgroup.FSpeedMax);
            bs.AddInteger(pgroup.FWeapon);
            bs.AddInteger(pgroup.FCargoHook);
            bs.AddInteger(pgroup.FEmptySpace);
            //bs.AddInteger(0);
            bs.AddBoolean(pgroup.FAddPlayer);

            //bs.AddInteger(0);
            //bs.AddInteger(0);
            //bs.AddInteger(0);
            //bs.AddInteger(0);

            bs.AddInteger(pgroup.FStatusTraderMin);
            bs.AddInteger(pgroup.FStatusTraderMax);

            bs.AddInteger(pgroup.FStatusWarriorMin);
            bs.AddInteger(pgroup.FStatusWarriorMax);

            bs.AddInteger(pgroup.FStatusPirateMin);
            bs.AddInteger(pgroup.FStatusPirateMax);

            bs.AddInteger(pgroup.FDistSearch);

            if pgroup.FDialog=nil then bs.Add(WideString(''))
            else bs.Add(pgroup.FDialog.FText);

            bs.AddSingle(pgroup.FStrengthMin);
            bs.AddSingle(pgroup.FStrengthMax);
            bs.Add(pgroup.FRuins);
        end;

        // Group link
        FindAllLinkFull('TGroup','TGroup',li);
        bs.AddInteger(li.Count);
        for i:=0 to li.Count-1 do begin
            pgl:=li.Items[i];
            bs.AddInteger(ligroup.IndexOf(pgl.FBegin));
            bs.AddInteger(ligroup.IndexOf(pgl.FEnd));
            bs.AddInteger(pgl.FRel1);
            bs.AddInteger(pgl.FRel2);
            bs.AddSingle(pgl.FWarWeightMin);
            bs.AddSingle(pgl.FWarWeightMax);
        end;

        // Top,Tif no link
        FindAllPoint('Top',li);
        FindAllPoint('Tif',li2);
        for i:=0 to li2.Count-1 do li.Add(li2.Items[i]);
        FindAllPoint('Twhile',li2);
        for i:=0 to li2.Count-1 do li.Add(li2.Items[i]);
        i:=0;
        while i<li.Count do begin
            pg:=li.Items[i];
            u:=0;
            while u<GGraphLink.Count do begin
                if TGraphLink(GGraphLink.Items[u]).FEnd=pg then break;
                inc(u);
            end;
            if u<GGraphLink.Count then begin
                li.Delete(i);
            end else inc(i);
        end;
        SortPointByPos(li);
        // Code init
        if CheckBoxLite.Checked = false then Co.Lines.Add('Init code {');
        tstr:='';
        for i:=0 to li.Count-1 do begin
            pg:=li.Items[i];
            if ((pg is Tif) and ((pg as Tif).FType=1)) or ((pg is Form_Op.Top) and ((pg as Form_Op.Top).FType=1)) or ((pg is Twhile) and ((pg as Twhile).FType=1)) then begin
                tstr:=tstr+BuildCode(pg,nil,nil,nil,'  ');
            end;
        end;

        tstr:=GetStrParEC(tstr, 0, GetCountParEC(tstr, #13#10)-2, #13#10); // added by Koc - удаление последней пустой строки

        BuildCodeText(tstr,bt,'Script.'+GScriptName+'.');
        if CheckBoxLite.Checked = false then
        begin
          Co.Lines.Add(tstr);
          Co.Lines.Add('}');
        end;
        TestCode;
        bs.Add(tstr);

        // Code turn
        if CheckBoxLite.Checked = false then Co.Lines.Add('Turn code {');
        tstr:='';
        for i:=0 to li.Count-1 do begin
            pg:=li.Items[i];
            if ((pg is Tif) and ((pg as Tif).FType=0)) or ((pg is Form_Op.Top) and ((pg as Form_Op.Top).FType=0)) or ((pg is Twhile) and ((pg as Twhile).FType=0)) then begin
              tstr:=tstr+BuildCode(pg,nil,nil,nil,'  ');
            end;
        end;

        tstr:=GetStrParEC(tstr, 0, GetCountParEC(tstr, #13#10)-2, #13#10); // added by Koc - удаление последней пустой строки

        BuildCodeText(tstr,bt,'Script.'+GScriptName+'.');
        if CheckBoxLite.Checked = false then
        begin
          Co.Lines.Add(tstr);
          Co.Lines.Add('}');
        end;
        TestCode;
        bs.Add(tstr);

        // Code dialogbegin - added by Koc
        if CheckBoxLite.Checked = false then Co.Lines.Add('DialogBegin code {');
        tstr:='';
        //u:=0;
        for i:=0 to li.Count-1 do begin
            pg:=li.Items[i];
            if((pg is Tif) and ((pg as Tif).FType=3)) or ((pg is Form_Op.Top) and ((pg as Form_Op.Top).FType=3)) or ((pg is Twhile) and ((pg as Twhile).FType=3)) then begin
              tstr:=tstr+BuildCode(pg,nil,nil,nil,'  ')
            end;
        end;

        tstr:=GetStrParEC(tstr, 0, GetCountParEC(tstr, #13#10)-2, #13#10); // added by Koc - удаление последней пустой строки

        BuildCodeText(tstr,bt,'Script.'+GScriptName+'.');
        if CheckBoxLite.Checked = false then
        begin
          Co.Lines.Add(tstr);
          Co.Lines.Add('}');
        end;
        TestCode;
        bs.Add(tstr); // <- added by Koc

        // Find dialog
        FindAllPoint('TDialog',li);

        // State
        bs.AddInteger(listate.Count);
        for i:=0 to listate.Count-1 do begin
            pstate:=listate.Items[i];

            if CheckBoxLite.Checked = false then Co.Lines.Add('State '+IntToStr(i)+' : '+pstate.FText);

            bs.Add(pstate.FText);

            bs.AddInteger(pstate.FMove);
            if(pstate.FMove=0) or (pstate.FMove=5) then begin
            end else {if pstate.FMove=1 then} begin
                if pstate.FMoveObj=nil then Error('State : '+pstate.FText);
                bs.Add(pstate.FMoveObj.FText);
            end;

            bs.AddInteger(pstate.FAttack.Count);
            for u:=0 to pstate.FAttack.Count-1 do begin
                bs.Add(TGraphPoint(pstate.FAttack.Items[u]).FText);
            end;

            if pstate.FTakeItem=nil then bs.Add(WideString(''))
            else bs.Add(pstate.FTakeItem.FText);

            bs.AddBoolean(pstate.FTakeAllItem);

            if TrimEx(pstate.FOnTalk)='' then begin
                bs.Add(WideString(''));
            end else begin
                u:=0;
                while u<li.Count do begin
                    if pstate.FOnTalk=TDialog(li.Items[u]).FText then break;
                    inc(u);
                end;
                if u<li.Count then begin
                    bs.Add(TrimEx(pstate.FOnTalk));
                end else begin
                    tstr:=pstate.FOnTalk;
                    BuildCodeText(tstr,bt,'Script.'+GScriptName+'.');
                    if CheckBoxLite.Checked = false then
                    begin
                      Co.Lines.Add('  CodeTextOut { ');
                      Co.Lines.Add(tstr);
                      Co.Lines.Add('  }');
                    end;

                    TestCode;

                    bs.Add(tstr);
                end;
            end;

            if TrimEx(pstate.FOnActCode)='' then
            begin
                bs.Add(WideString(''));
            end else begin
                bs.Add(pstate.FOnActCode);
                if CheckBoxLite.Checked = false then
                begin
                  Co.Lines.Add('  OnActCode { ');
                  Co.Lines.Add(pstate.FOnActCode);
                  Co.Lines.Add('  }');
                end;

            end;

            if TrimEx(pstate.FEMsg)='' then begin
                bs.Add(WideString(''));
            end else begin
                tstr:='    '+'Ether('+IntToStr(pstate.FEType)+','''+pstate.FEUnique+''',"'+ToCodeText(pstate.FEMsg)+'",CurShip);';//+#13#10;
                BuildCodeText(tstr,bt,'Script.'+GScriptName+'.');
                if CheckBoxLite.Checked = false then
                begin
                  Co.Lines.Add('  CodeEther { ');
                  Co.Lines.Add(tstr);
                  Co.Lines.Add('  }');
                end;

                TestCode;

                bs.Add(tstr);
            end;

            tstr:=(BuildCode(pstate,listate,nil,nil,'    '));

            tstr:=GetStrParEC(tstr, 0, GetCountParEC(tstr, #13#10)-2, #13#10); // added by Koc - удаление последней пустой строки

            BuildCodeText(tstr,bt,'Script.'+GScriptName+'.');
            if CheckBoxLite.Checked = false then
            begin
              Co.Lines.Add('  Code { ');
              Co.Lines.Add(tstr);
              Co.Lines.Add('  }');
            end;

            TestCode;

            bs.Add(tstr);

        end;

        // Dialog
        bs.AddInteger(li.Count);
        for i:=0 to li.Count-1 do begin
            tstr:=TDialog(li.Items[i]).FText;
            if tstr<>TrimEx(tstr) then Error('Dialog name : '+tstr);
            if Length(tstr)<1 then Error('Dialog name');
            if svar.GetVarNE(tstr)<>nil then Error('Dialog name not unique');
            bs.Add(tstr);
            svar.Add(tstr,vtDW).VDW:=i;

            if CheckBoxLite.Checked = false then Co.Lines.Add('Dialog : '+tstr);

            tstr:=BuildCode(li.Items[i],nil,lidialogmsg,nil,'    ');

            tstr:=GetStrParEC(tstr, 0, GetCountParEC(tstr, #13#10)-2, #13#10); // added by Koc - удаление последней пустой строки

            BuildCodeText(tstr,bt,'Script.'+GScriptName+'.');
            if CheckBoxLite.Checked = false then
            begin
              Co.Lines.Add('  Start code { ');
              Co.Lines.Add(tstr);
              Co.Lines.Add('  }');
            end;

            TestCode;

            bs.Add(tstr);
        end;

        // DialogMsg
        bs.AddInteger(lidialogmsg.Count);
        for i:=0 to lidialogmsg.Count-1 do begin
            pdmsg:=lidialogmsg.Items[i];
            bs.Add(pdmsg.FText);

            if CheckBoxLite.Checked = false then Co.Lines.Add('DialogMsg '+IntToStr(i)+' : '+pdmsg.FText);

            tstr:='    '+'DText("'+ToCodeText(pdmsg.FMsg)+'");';//+#13#10;
            tstr:=tstr+BuildCode(pdmsg,nil,nil,lidialoganswer,'    ');
            BuildCodeText(tstr,bt,'Script.'+GScriptName+'.');
            if CheckBoxLite.Checked = false then
            begin
              Co.Lines.Add('  Code { ');
              Co.Lines.Add(tstr);
              Co.Lines.Add('  }');
            end;

            TestCode;

            bs.Add(tstr);
        end;

        // DialogAnswer
        bs.AddInteger(lidialoganswer.Count);
        for i:=0 to lidialoganswer.Count-1 do begin
            pdanswer:=lidialoganswer.Items[i];
            bs.Add(pdanswer.FText);

            if CheckBoxLite.Checked = false then Co.Lines.Add('DialogAnswer '+IntToStr(i)+' : '+pdanswer.FText);

            if TrimEX(pdanswer.FMsg)='' then tstr:='    '+'DAnswer('''+LowerCase(pdanswer.FText)+''');'
            else if pdanswer.FText='' then tstr:='    '+'DAnswer("'+ToCodeText(pdanswer.FMsg)+'");'
            else tstr:='    '+'DAnswer('''+LowerCase(pdanswer.FText)+'~''+"'+ToCodeText(pdanswer.FMsg)+'");';

            BuildCodeText(tstr,bt,'Script.'+GScriptName+'.');
            if CheckBoxLite.Checked = false then
            begin
              Co.Lines.Add('  Answer { ');
              Co.Lines.Add(tstr);
              Co.Lines.Add('  }');
            end;

            TestCode;

            bs.Add(tstr);

            tstr:=BuildCode(pdanswer,nil,lidialogmsg,nil,'    ');

            tstr:=GetStrParEC(tstr, 0, GetCountParEC(tstr, #13#10)-2, #13#10); // added by Koc - удаление последней пустой строки

            BuildCodeText(tstr,bt,'Script.'+GScriptName+'.');
            if CheckBoxLite.Checked = false then
            begin
              Co.Lines.Add('  Code { ');
              Co.Lines.Add(tstr);
              Co.Lines.Add('  }');
            end;

            TestCode;

            bs.Add(tstr);
        end;

        svar.Save(bsz);
        bsz.Add(bs.Buf,bs.Len);

        bsz.SaveInFile(PAnsiChar(AnsiString(GScriptFileOut)));


        cntu:=bt.Par_Count();

            bt2.Clear;
            for u:=0 to cntu-1 do begin
                tstr:=bt.Par_GetName(u);
                if GScriptTranslateId.Par_Count(tstr)>0 then begin
                    bt2.Par_Add(tstr,GScriptTranslateId.Par_Get(tstr));
                end else begin
                    bt2.Par_Add(tstr,bt.Par_Get(u));
                end;
            end;
            bt2.SaveInFile(PAnsiChar(AnsiString(GScriptTextOut)));

        GScriptTranslateId.CopyFrom(bt);

        Co.Lines.Add('OK');
    except
        on ex:EAbort do begin
            Co.Lines.Add('Error : '+ex.Message);
        end;
        on ex:Exception do begin
            Co.Lines.Add('Error : '+ex.Message);
        end;
    end;

    arconst:=nil;
    code.Free;
    ca.Free;
    svar.Free;
    svar_g.Free;
    bt.Free;
    bt2.Free;
    bsz.Free;
    bs.Free;
    lidialoganswer.Free;
    lidialogmsg.Free;
    listate.Free;
    ligroup.Free;
    listar.Free;
    li2.Free;
    li.Free;
end;

end.

