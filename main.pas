unit main;

interface

uses Windows,GraphUnit,SysUtils,Graphics,Menus,Classes,ActiveX,
     EC_Str,EC_Buf,EC_BlockPar,forms,
     Form_Star,Form_StarLink,Form_StarShip,Form_Planet,Form_Group,Form_GroupLink,
     Form_State,Form_StateLink,Form_Place,Form_Item,Form_If,Form_Op,Form_Ether,Form_Var,Form_While,
     Form_Dialog,Form_DialogMsg,Form_DialogAnswer,Form_Build,FormCode;

procedure MainInit;
procedure MainSave(bd:TBufEC);
procedure MainLoad(bd:TBufEC);
procedure MainNew;
function CreateByName(tstr:WideString):TObject;
function MainCreateLink(pbegin:TGraphPoint; pend:TGraphPoint):TGraphLink;

function CA(a:DWORD; i:integer):boolean; overload;
function CA(a:DWORD; i:integer; zn:boolean):DWORD; overload;
procedure SCA(var a:DWORD; i:integer; zn:boolean);
function CA1(a:DWORD; i:integer):DWORD;

function BuildRazd(tstr:WideString):WideString;

procedure ReplaceColor(bm:TBitmap; oldcolor:TColor; newcolor:TColor);

function NewGUID:WideString;

procedure CheckEditedText(oldText:WideString; newText:WideString);

type
TFun=record
    FType:integer;
    FName:WideString;
    FResult:WideString;
    FArg:WideString;
    FDesc:WideString;
end;

var

GFun:array of TFun;

GScriptName:WideString;
GScriptFileOut:WideString;
GScriptTextOut:WideString;

//GScriptFileTextOut:TBlockParEC;
//GScriptTranslate:TBlockParEC;
GScriptTranslateId:TBlockParEC;

implementation

uses Form_Main;

procedure MainInit;
var
    bm:TBitmap;
    bp:TBlockParEC;
    i,cnt:integer;
    tstr:WideString;
begin
    if GScriptTranslateId<>nil then begin GScriptTranslateId.Free; GScriptTranslateId:=nil; end;
    GScriptTranslateId:=TBlockParEC.Create();

    GScriptTextOut:='';

    bp:=FCfg.Block['Function'];
    cnt:=bp.Par_Count();
    SetLength(GFun,cnt);
    for i:=0 to cnt-1 do begin
        GFun[i].FType:=StrToIntEC(bp.Par_GetName(i));
        tstr:=bp.Par_Get(i);
        if GetCountParEC(tstr,'~')<>4 then raise Exception.Create('Load function error. Nom='+IntToStr(i));
        GFun[i].FResult:=TrimEx(GetStrParEC(tstr,0,'~'));
        GFun[i].FName:=TrimEx(GetStrParEC(tstr,1,'~'));
        GFun[i].FArg:=TrimEx(GetStrParEC(tstr,2,'~'));
        GFun[i].FDesc:=TrimEx(GetStrParEC(tstr,3,'~'));
    end;

    bm:=TBitmap.Create;
    bm.LoadFromFile(GSysWorkDir+'\Image\Star.bmp');
    ReplaceColor(bm,bm.Canvas.Pixels[0,0],ColorBG);
    bm.Transparent:=true;
    ImageAdd('Star',bm);

    bm:=TBitmap.Create;
    bm.LoadFromFile(GSysWorkDir+'\Image\Planet.bmp');
    ReplaceColor(bm,bm.Canvas.Pixels[0,0],ColorBG);
    bm.Transparent:=true;
    ImageAdd('Planet',bm);

    bm:=TBitmap.Create;
    bm.LoadFromFile(GSysWorkDir+'\Image\Place.bmp');
    ReplaceColor(bm,bm.Canvas.Pixels[0,0],ColorBG);
    bm.Transparent:=true;
    ImageAdd('Place',bm);

    bm:=TBitmap.Create;
    bm.LoadFromFile(GSysWorkDir+'\Image\Group.bmp');
    ReplaceColor(bm,bm.Canvas.Pixels[0,0],ColorBG);
    bm.Transparent:=true;
    ImageAdd('Group',bm);

    bm:=TBitmap.Create;
    bm.LoadFromFile(GSysWorkDir+'\Image\Ship.bmp');
    ReplaceColor(bm,bm.Canvas.Pixels[0,0],ColorBG);
    bm.Transparent:=true;
    ImageAdd('Ship',bm);

    bm:=TBitmap.Create;
    bm.LoadFromFile(GSysWorkDir+'\Image\Player.bmp');
    ReplaceColor(bm,bm.Canvas.Pixels[0,0],ColorBG);
    bm.Transparent:=true;
    ImageAdd('Player',bm);

    bm:=TBitmap.Create;
    bm.LoadFromFile(GSysWorkDir+'\Image\Item.bmp');
    ReplaceColor(bm,bm.Canvas.Pixels[0,0],ColorBG);
    bm.Transparent:=true;
    ImageAdd('Item',bm);

    bm:=TBitmap.Create;
    bm.LoadFromFile(GSysWorkDir+'\Image\State.bmp');
    ReplaceColor(bm,bm.Canvas.Pixels[0,0],ColorBG);
    bm.Transparent:=true;
    ImageAdd('State',bm);

    bm:=TBitmap.Create;
    bm.LoadFromFile(GSysWorkDir+'\Image\If.bmp');
    ReplaceColor(bm,bm.Canvas.Pixels[0,0],ColorBG);
    bm.Transparent:=true;
    ImageAdd('Nif',bm);

    bm:=TBitmap.Create;
    bm.LoadFromFile(GSysWorkDir+'\Image\If_Init.bmp');
    ReplaceColor(bm,bm.Canvas.Pixels[0,0],ColorBG);
    bm.Transparent:=true;
    ImageAdd('Iif',bm);

    bm:=TBitmap.Create;
    bm.LoadFromFile(GSysWorkDir+'\Image\If_Global.bmp');
    ReplaceColor(bm,bm.Canvas.Pixels[0,0],ColorBG);
    bm.Transparent:=true;
    ImageAdd('Gif',bm);

    bm:=TBitmap.Create;
    bm.LoadFromFile(GSysWorkDir+'\Image\If_Dialog.bmp');
    ReplaceColor(bm,bm.Canvas.Pixels[0,0],ColorBG);
    bm.Transparent:=true;
    ImageAdd('Dif',bm);

    bm:=TBitmap.Create;
    bm.LoadFromFile(GSysWorkDir+'\Image\While.bmp');
    ReplaceColor(bm,bm.Canvas.Pixels[0,0],ColorBG);
    bm.Transparent:=true;
    ImageAdd('Nwhile',bm);

    bm:=TBitmap.Create;
    bm.LoadFromFile(GSysWorkDir+'\Image\While_Init.bmp');
    ReplaceColor(bm,bm.Canvas.Pixels[0,0],ColorBG);
    bm.Transparent:=true;
    ImageAdd('Iwhile',bm);

    bm:=TBitmap.Create;
    bm.LoadFromFile(GSysWorkDir+'\Image\While_Global.bmp');
    ReplaceColor(bm,bm.Canvas.Pixels[0,0],ColorBG);
    bm.Transparent:=true;
    ImageAdd('Gwhile',bm);

    bm:=TBitmap.Create;
    bm.LoadFromFile(GSysWorkDir+'\Image\While_Dialog.bmp');
    ReplaceColor(bm,bm.Canvas.Pixels[0,0],ColorBG);
    bm.Transparent:=true;
    ImageAdd('Dwhile',bm);

    bm:=TBitmap.Create;
    bm.LoadFromFile(GSysWorkDir+'\Image\Op.bmp');
    ReplaceColor(bm,bm.Canvas.Pixels[0,0],ColorBG);
    bm.Transparent:=true;
    ImageAdd('Nop',bm);

    bm:=TBitmap.Create;
    bm.LoadFromFile(GSysWorkDir+'\Image\Op_Init.bmp');
    ReplaceColor(bm,bm.Canvas.Pixels[0,0],ColorBG);
    bm.Transparent:=true;
    ImageAdd('Iop',bm);

    bm:=TBitmap.Create;
    bm.LoadFromFile(GSysWorkDir+'\Image\Op_Global.bmp');
    ReplaceColor(bm,bm.Canvas.Pixels[0,0],ColorBG);
    bm.Transparent:=true;
    ImageAdd('Gop',bm);

    bm:=TBitmap.Create;
    bm.LoadFromFile(GSysWorkDir+'\Image\Op_Dialog.bmp');
    ReplaceColor(bm,bm.Canvas.Pixels[0,0],ColorBG);
    bm.Transparent:=true;
    ImageAdd('Dop',bm);

    bm:=TBitmap.Create;
    bm.LoadFromFile(GSysWorkDir+'\Image\ether.bmp');
    ReplaceColor(bm,bm.Canvas.Pixels[0,0],ColorBG);
    bm.Transparent:=true;
    ImageAdd('Ether',bm);

    bm:=TBitmap.Create;
    bm.LoadFromFile(GSysWorkDir+'\Image\var.bmp');
    ReplaceColor(bm,bm.Canvas.Pixels[0,0],ColorBG);
    bm.Transparent:=true;
    ImageAdd('Var',bm);

    bm:=TBitmap.Create;
    bm.LoadFromFile(GSysWorkDir+'\Image\Dialog.bmp');
    ReplaceColor(bm,bm.Canvas.Pixels[0,0],ColorBG);
    bm.Transparent:=true;
    ImageAdd('Dialog',bm);

    bm:=TBitmap.Create;
    bm.LoadFromFile(GSysWorkDir+'\Image\DialogMsg.bmp');
    ReplaceColor(bm,bm.Canvas.Pixels[0,0],ColorBG);
    bm.Transparent:=true;
    ImageAdd('DialogMsg',bm);

    bm:=TBitmap.Create;
    bm.LoadFromFile(GSysWorkDir+'\Image\DialogAnswer.bmp');
    ReplaceColor(bm,bm.Canvas.Pixels[0,0],ColorBG);
    bm.Transparent:=true;
    ImageAdd('DialogAnswer',bm);

    GGraphPointInterface.Add(TStarInterface.Create);
    GGraphPointInterface.Add(TPlanetInterface.Create);
    GGraphPointInterface.Add(TStarShipInterface.Create);
    GGraphPointInterface.Add(TItemInterface.Create);
    GGraphPointInterface.Add(TPlaceInterface.Create);
    GGraphPointInterface.Add(TGroupInterface.Create);
    GGraphPointInterface.Add(TStateInterface.Create);
    GGraphPointInterface.Add(TifInterface.Create);
    GGraphPointInterface.Add(TwhileInterface.Create);
    GGraphPointInterface.Add(TopInterface.Create);
    GGraphPointInterface.Add(TEtherInterface.Create);
    GGraphPointInterface.Add(TvarInterface.Create);
    GGraphPointInterface.Add(TDialogInterface.Create);
    GGraphPointInterface.Add(TDialogMsgInterface.Create);
    GGraphPointInterface.Add(TDialogAnswerInterface.Create);
end;

function CreateByName(tstr:WideString):TObject;
begin
    tstr:=LowerCase(tstr);
    if tstr='tgraphpoint' then Result:=TGraphPoint.Create
    else if tstr='tgraphlink' then Result:=TGraphLink.Create
    else if tstr='tgraphrecttext' then Result:=TGraphRectText.Create
    else if tstr='tstar' then Result:=TStar.Create
    else if tstr='tstarlink' then Result:=TStarLink.Create
    else if tstr='tstarship' then Result:=TStarShip.Create
    else if tstr='tplanet' then Result:=TPlanet.Create
    else if tstr='tgroup' then Result:=TGroup.Create
    else if tstr='tgrouplink' then Result:=TGroupLink.Create
    else if tstr='tstate' then Result:=TState.Create
    else if tstr='tstatelink' then Result:=TStateLink.Create
    else if tstr='tplace' then Result:=TPlace.Create
    else if tstr='titem' then Result:=TItem.Create
    else if tstr='tif' then Result:=Tif.Create
    else if tstr='top' then Result:=Top.Create
    else if tstr='twhile' then Result:=Twhile.Create
    else if tstr='tether' then Result:=TEther.Create
    else if tstr='tvar' then Result:=Tvar.Create
    else if tstr='tdialog' then Result:=TDialog.Create
    else if tstr='tdialogmsg' then Result:=TDialogMsg.Create
    else if tstr='tdialoganswer' then Result:=TDialogAnswer.Create
    else raise Exception.Create('Unknown type : '+tstr);
end;

procedure MainSave(bd:TBufEC);
begin
    bd.Add(GScriptName);
    bd.Add(GScriptFileOut);
    bd.Add(GScriptTextOut);

    GScriptTranslateId.Save(bd);
end;

procedure MainLoad(bd:TBufEC);
var bl:TBlockParEC;
begin
    GScriptTranslateId.Clear;

    GScriptName:=bd.GetWideStr;
    GScriptFileOut:=bd.GetWideStr;

    if (GFileVersion<$05) or (GFileVersion>=$08) then
    begin
      GScriptTextOut:=bd.GetWideStr;
    end else begin
      bl:=TBlockParEC.Create;
      bl.Load(bd);
      GScriptTextOut:=bl.Par_GetNE('rus');
      bl.Free;
    end;

    if GFileVersion>=$05 then
    begin
        if GFileVersion<$08 then
        begin
          bl:=TBlockParEC.Create;
          bl.Load(bd);
          bl.Free;
        end;
        GScriptTranslateId.Load(bd);
    end;
end;

procedure MainNew;
begin
    GScriptName:='';
    GScriptFileOut:='';
    GScriptTextOut:='';

    if GScriptTranslateId<>nil then begin GScriptTranslateId.Free; GScriptTranslateId:=nil; end;
    GScriptTranslateId:=TBlockParEC.Create();
end;

function codeFindLoop(pfrom:TGraphPoint; pto:TGraphPoint):boolean;
var
    i:integer;
    gl:TGraphLink;
begin
    for i:=0 to GGraphLink.Count-1 do
    begin
        gl:=GGraphLink.Items[i];
        if (gl.FBegin=pfrom) and (gl.FEnd is Tcode) then
        begin
            if gl.FEnd=pto then begin Result:=true; Exit; end;
            Result:=codeFindLoop(gl.FEnd,pto);
            if Result then Exit;
        end;
    end;
    Result:=false;
end;

function MainCreateLink(pbegin:TGraphPoint; pend:TGraphPoint):TGraphLink;
begin
    Result:=nil;
    if (pbegin is TStar) and (pend is TStar) then
    begin
        if FindLinkFull(pbegin,pend)=nil then
        begin
            Result:=TStarLink.Create;
            Result.FBegin:=pbegin;
            Result.FEnd:=pend;
            Exit;
        end;
    end
    else if ((pbegin is TStar) and (pend is TStarShip)) or ((pbegin is TStarShip) and (pend is TStar)) then
    begin
        if FindLinkFull(pbegin,pend)=nil then
        begin
            Result:=TGraphLink.Create;
            if pbegin is TStarShip then
            begin
                Result.FBegin:=pbegin;
                Result.FEnd:=pend;
            end
            else begin
                Result.FBegin:=pend;
                Result.FEnd:=pbegin;
            end;
            Result.FArrow:=true;
            Exit;
        end;
    end
    else if ((pbegin is TStar) and (pend is TPlanet)) or ((pbegin is TPlanet) and (pend is TStar)) then
    begin
        if FindLinkFull(pbegin,pend)=nil then
        begin
            if pbegin is TPlanet then Result:=FindLinkFull(pbegin,'TStar')
            else Result:=FindLinkFull(pend,'TStar');
            if Result<>nil then
            begin
                GGraphLink.Delete(GGraphLink.IndexOf(Result));
                Result.Free;
            end;
            Result:=TGraphLink.Create;
            if pbegin is TPlanet then
            begin
                Result.FBegin:=pbegin;
                Result.FEnd:=pend;
            end
            else begin
                Result.FBegin:=pend;
                Result.FEnd:=pbegin;
            end;
            Result.FArrow:=true;
            Exit;
        end;
    end
    else if ((pbegin is TGroup) and (pend is TPlanet)) or ((pbegin is TPlanet) and (pend is TGroup)) then
    begin
        if FindLinkFull(pbegin,pend)=nil then
        begin
            if pbegin is TGroup then Result:=FindLinkFull(pbegin,'TPlanet')
            else Result:=FindLinkFull(pend,'TPlanet');
            if Result<>nil then
            begin
                GGraphLink.Delete(GGraphLink.IndexOf(Result));
                Result.Free;
            end;
            Result:=TGraphLink.Create;
            if pbegin is TGroup then
            begin
                Result.FBegin:=pbegin;
                Result.FEnd:=pend;
            end
            else begin
                Result.FBegin:=pend;
                Result.FEnd:=pbegin;
            end;
            Result.FArrow:=true;
            Exit;
        end;
    end
    else if (pbegin is TGroup) and (pend is TGroup) then
    begin
        if FindLink(pbegin,pend)=nil then
        begin
            Result:=TGroupLink.Create;
            Result.FBegin:=pbegin;
            Result.FEnd:=pend;
            Result.FArrow:=true;
            Exit;
        end;
    end
    else if ((pbegin is TGroup) and (pend is TState)) or ((pbegin is TState) and (pend is TGroup)) then
    begin
        if FindLinkFull(pbegin,pend)=nil then
        begin
            if pbegin is TGroup then Result:=FindLinkFull(pbegin,'TState')
            else Result:=FindLinkFull(pend,'TState');
            if Result<>nil then
            begin
                GGraphLink.Delete(GGraphLink.IndexOf(Result));
                Result.Free;
            end;
            Result:=TGraphLink.Create;
            if pbegin is TGroup then
            begin
                Result.FBegin:=pbegin;
                Result.FEnd:=pend;
            end
            else begin
                Result.FBegin:=pend;
                Result.FEnd:=pbegin;
            end;
            Result.FArrow:=true;
            Exit;
        end;
    end
    else if ((pbegin is TItem) and (pend is TPlace)) or ((pbegin is TPlace) and (pend is TItem)) then
    begin
        if FindLinkFull(pbegin,pend)=nil then
        begin
            if pbegin is TItem then Result:=FindLinkFull(pbegin,'TPlanet')
            else Result:=FindLinkFull(pend,'TPlanet');
            if Result<>nil then
            begin
                GGraphLink.Delete(GGraphLink.IndexOf(Result));
                Result.Free;
            end;
            if pbegin is TItem then Result:=FindLinkFull(pbegin,'TGroup')
            else Result:=FindLinkFull(pend,'TGroup');
            if Result<>nil then
            begin
                GGraphLink.Delete(GGraphLink.IndexOf(Result));
                Result.Free;
            end;
            if pbegin is TItem then Result:=FindLinkFull(pbegin,'TPlace')
            else Result:=FindLinkFull(pend,'TPlace');
            if Result<>nil then
            begin
                GGraphLink.Delete(GGraphLink.IndexOf(Result));
                Result.Free;
            end;
            Result:=TGraphLink.Create;
            if pbegin is TItem then
            begin
                Result.FBegin:=pbegin;
                Result.FEnd:=pend;
            end
            else begin
                Result.FBegin:=pend;
                Result.FEnd:=pbegin;
            end;
            Result.FArrow:=true;
            Exit;
        end;
    end
    else if ((pbegin is TItem) and (pend is TGroup)) or ((pbegin is TGroup) and (pend is TItem)) then
    begin
        if FindLinkFull(pbegin,pend)=nil then
        begin
            if pbegin is TItem then Result:=FindLinkFull(pbegin,'TPlanet')
            else Result:=FindLinkFull(pend,'TPlanet');
            if Result<>nil then
            begin
                GGraphLink.Delete(GGraphLink.IndexOf(Result));
                Result.Free;
            end;
            if pbegin is TItem then Result:=FindLinkFull(pbegin,'TGroup')
            else Result:=FindLinkFull(pend,'TGroup');
            if Result<>nil then
            begin
                GGraphLink.Delete(GGraphLink.IndexOf(Result));
                Result.Free;
            end;
            if pbegin is TItem then Result:=FindLinkFull(pbegin,'TPlace')
            else Result:=FindLinkFull(pend,'TPlace');
            if Result<>nil then
            begin
                GGraphLink.Delete(GGraphLink.IndexOf(Result));
                Result.Free;
            end;
            Result:=TGraphLink.Create;
            if pbegin is TItem then
            begin
                Result.FBegin:=pbegin;
                Result.FEnd:=pend;
            end
            else begin
                Result.FBegin:=pend;
                Result.FEnd:=pbegin;
            end;
            Result.FArrow:=true;
            Exit;
        end;
    end
    else if ((pbegin is TItem) and (pend is TPlanet)) or ((pbegin is TPlanet) and (pend is TItem)) then
    begin
        if FindLinkFull(pbegin,pend)=nil then
        begin
            if pbegin is TItem then Result:=FindLinkFull(pbegin,'TPlanet')
            else Result:=FindLinkFull(pend,'TPlanet');
            if Result<>nil then
            begin
                GGraphLink.Delete(GGraphLink.IndexOf(Result));
                Result.Free;
            end;
            if pbegin is TItem then Result:=FindLinkFull(pbegin,'TGroup')
            else Result:=FindLinkFull(pend,'TGroup');
            if Result<>nil then
            begin
                GGraphLink.Delete(GGraphLink.IndexOf(Result));
                Result.Free;
            end;
            if pbegin is TItem then Result:=FindLinkFull(pbegin,'TPlace')
            else Result:=FindLinkFull(pend,'TPlace');
            if Result<>nil then
            begin
                GGraphLink.Delete(GGraphLink.IndexOf(Result));
                Result.Free;
            end;
            Result:=TGraphLink.Create;
            if pbegin is TItem then
            begin
                Result.FBegin:=pbegin;
                Result.FEnd:=pend;
            end
            else begin
                Result.FBegin:=pend;
                Result.FEnd:=pbegin;
            end;
            Result.FArrow:=true;
            Exit;
        end;
    end
    else if ((pbegin is TPlace) and (pend is TStar)) or ((pbegin is TStar) and (pend is TPlace)) then
    begin
        if FindLinkFull(pbegin,pend)=nil then
        begin
            if pbegin is TPlace then Result:=FindLinkFull(pbegin,'TStar')
            else Result:=FindLinkFull(pend,'TStar');
            if Result<>nil then
            begin
                GGraphLink.Delete(GGraphLink.IndexOf(Result));
                Result.Free;
            end;
            Result:=TGraphLink.Create;
            if pbegin is TPlace then
            begin
                Result.FBegin:=pbegin;
                Result.FEnd:=pend;
            end
            else begin
                Result.FBegin:=pend;
                Result.FEnd:=pbegin;
            end;
            Result.FArrow:=true;
            Exit;
        end;
    end
    else if (pbegin is Tcode) and (pend is Tcode) then
    begin
        if FindLink(pbegin,pend)=nil then
        begin
            if not codeFindLoop(pend,pbegin) then
            begin
                Result:=TGraphLink.Create;
                Result.FBegin:=pbegin;
                Result.FEnd:=pend;
                Result.FArrow:=true;
                Exit;
            end;
        end;
    end
    else if (pbegin is TState) and (pend is Tcode) then
    begin
        if FindLink(pbegin,pend)=nil then
        begin
            Result:=TGraphLink.Create;
            Result.FBegin:=pbegin;
            Result.FEnd:=pend;
            Result.FArrow:=true;
            Exit;
        end;
    end
    else if (pbegin is Tcode) and (pend is TState) then
    begin
        if FindLink(pbegin,pend)=nil then
        begin
            Result:=FindLinkBegin(pbegin,'TState');
            if Result<>nil then
            begin
                GGraphLink.Delete(GGraphLink.IndexOf(Result));
                Result.Free;
            end;
            Result:=TGraphLink.Create;
            Result.FBegin:=pbegin;
            Result.FEnd:=pend;
            Result.FArrow:=true;
            Exit;
        end;
    end
    else if (pbegin is Tcode) and (pend is TEther) then
    begin
        if FindLink(pbegin,pend)=nil then
        begin
            Result:=TGraphLink.Create;
            Result.FBegin:=pbegin;
            Result.FEnd:=pend;
            Result.FArrow:=true;
            Exit;
        end;
    end
    else if (pbegin is TEther) and (pend is Tcode) then
    begin
        if FindLink(pbegin,pend)=nil then
        begin
            Result:=TGraphLink.Create;
            Result.FBegin:=pbegin;
            Result.FEnd:=pend;
            Result.FArrow:=true;
            Exit;
        end;
    end
    else if (pbegin is TDialogMsg) and (pend is TDialogAnswer) then
    begin
        if FindLink(pbegin,pend)=nil then
        begin
            Result:=TGraphLink.Create;
            Result.FBegin:=pbegin;
            Result.FEnd:=pend;
            Result.FArrow:=true;
            Exit;
        end;
    end
    else if (pbegin is TDialogAnswer) and (pend is TDialogMsg) then
    begin
        if FindLink(pbegin,pend)=nil then
        begin
            Result:=FindLinkBegin(pbegin,'TDialogMsg');
            if Result<>nil then
            begin
                GGraphLink.Delete(GGraphLink.IndexOf(Result));
                Result.Free;
            end;
            Result:=TGraphLink.Create;
            Result.FBegin:=pbegin;
            Result.FEnd:=pend;
            Result.FArrow:=true;
            Exit;
        end;
    end
    else if (pbegin is TDialogAnswer) and (pend is Tcode) then
    begin
        if FindLink(pbegin,pend)=nil then
        begin
            Result:=TGraphLink.Create;
            Result.FBegin:=pbegin;
            Result.FEnd:=pend;
            Result.FArrow:=true;
            Exit;
        end;
    end else if (pbegin is Tcode) and (pend is TDialogAnswer) then
    begin
        if FindLink(pbegin,pend)=nil then
        begin
            Result:=TGraphLink.Create;
            Result.FBegin:=pbegin;
            Result.FEnd:=pend;
            Result.FArrow:=true;
            Exit;
        end;
    end else if (pbegin is TDialogMsg) and (pend is Tcode) then
    begin
        if FindLink(pbegin,pend)=nil then
        begin
            Result:=FindLinkFull(pbegin,pend);
            if Result<>nil then
            begin
                GGraphLink.Delete(GGraphLink.IndexOf(Result));
                Result.Free;
            end;
            Result:=TGraphLink.Create;
            Result.FBegin:=pbegin;
            Result.FEnd:=pend;
            Result.FArrow:=true;
            Exit;
        end;
    end
    else if (pbegin is TDialog) and ((pend is TDialogMsg)) then begin
        if FindLink(pbegin,pend)=nil then
        begin
            Result:=FindLinkBegin(pbegin,'TDialogMsg');
            if Result<>nil then
            begin
                GGraphLink.Delete(GGraphLink.IndexOf(Result));
                Result.Free;
            end;
            Result:=TGraphLink.Create;
            Result.FBegin:=pbegin;
            Result.FEnd:=pend;
            Result.FArrow:=true;
            Exit;
        end;
    end
    else if (pbegin is TDialog) and (pend is Tcode) then
    begin
        if FindLinkFull(pbegin,pend)=nil then
        begin
            Result:=TGraphLink.Create;
            Result.FBegin:=pbegin;
            Result.FEnd:=pend;
            Result.FArrow:=true;
            Exit;
        end;
    end
    else if (pbegin is Tcode) and (pend is TDialogMsg) then
    begin
        if FindLink(pbegin,pend)=nil then
        begin
            Result:=FindLinkBegin(pbegin,'TDialogMsg');
            if Result<>nil then
            begin
                GGraphLink.Delete(GGraphLink.IndexOf(Result));
                Result.Free;
            end;
            Result:=FindLink(pend,pbegin);
            if Result<>nil then
            begin
                GGraphLink.Delete(GGraphLink.IndexOf(Result));
                Result.Free;
            end;
            Result:=TGraphLink.Create;
            Result.FBegin:=pbegin;
            Result.FEnd:=pend;
            Result.FArrow:=true;
            Exit;
        end;
    end else if (pbegin is TState) and (pend is TState) then
    begin
            Result:=TStateLink.Create;
            Result.FBegin:=pbegin;
            Result.FEnd:=pend;
            Result.FArrow:=true;
            Exit;
    end;
end;

function CA(a:DWORD; i:integer):boolean;
begin
    Result:=Boolean((a shr i) and 1);
end;

function CA(a:DWORD; i:integer; zn:boolean):DWORD;
begin
    if zn then Result:=a or (1 shl i)
    else Result:=a and (not (1 shl i));
end;

procedure SCA(var a:DWORD; i:integer; zn:boolean);
begin
    if zn then a:=a or (1 shl i)
    else a:=a and (not (1 shl i));
end;

function CA1(a:DWORD; i:integer):DWORD;
begin
    Result:=a or (1 shl i);
end;

function BuildRazd(tstr:WideString):WideString;
var
    i,tstrlen,len,maxlen:integer;
begin
    tstrlen:=Length(tstr);
    i:=0;
    len:=0;
    maxlen:=0;
    while i<tstrlen do
    begin
        if (i<(tstrlen-1)) and (tstr[i+1]=#13) and (tstr[i+2]=#10) then
        begin
            if len>maxlen then maxlen:=len; 
            len:=0;
            inc(i);
        end
        else if tstr[i+1]='~' then
        else begin
            len:=len+1;
        end;
        inc(i);
    end;
    if len>maxlen then maxlen:=len;

    Result:='';
    for i:=0 to maxlen-1 do Result:=Result+'-';

    Result:=StringReplaceEC(tstr,'~',Result+#13#10);
end;

procedure ReplaceColor(bm:TBitmap; oldcolor:TColor; newcolor:TColor);
var
    x,y:integer;
begin
    for y:=0 to bm.Height-1 do
        for x:=0 to bm.Width-1 do
            if bm.Canvas.Pixels[x,y]=oldcolor then bm.Canvas.Pixels[x,y]:=newcolor;

end;


procedure CheckEditedText(oldText:WideString; newText:WideString);
var i,no,cnt:integer;
    tstr:WideString;
    gp:TGraphPoint;
    found:boolean;
    bl:TBlockParEC;
begin
  cnt:=GScriptTranslateId.Par_Count;
  tstr:=ApplySubs(oldText);
  i:=0;
  while i<cnt do
  begin
    if GScriptTranslateId.Par_Get(i)=tstr then break;
    inc(i);
  end;
  if i<cnt then
  begin
    no:=i;
    found:=false;
    for i:=0 to GGraphPoint.Count-1 do
    begin
      gp:=GGraphPoint.Items[i];
      if gp is TDialogAnswer then
      begin
        if ApplySubs(TDialogAnswer(gp).FMsg) = oldText then
        begin
          found:=true;
          break;
        end;
      end
      else if gp is TDialogMsg then
      begin
        if ApplySubs(TDialogMsg(gp).FMsg) = oldText then
        begin
          found:=true;
          break;
        end;
      end
      else if gp is TEther then
      begin
        if ApplySubs(TEther(gp).FMsg) = oldText then
        begin
          found:=true;
          break;
        end;
      end;
    end;
    if not found then
    begin
      tstr:=ApplySubs(newText);
      GScriptTranslateId.Par_Set(no,tstr);
    end;
  end;
end;

function NewGUID:WideString;
var
    tstr:WideString;
    id:TGUID;
begin
    if CoCreateGuid(id)<>S_OK then raise Exception.Create('NewGUID');
    SetLength(tstr,40);
    if StringFromGUID2(id,PWideChar(tstr),40)=0 then raise Exception.Create('GUIDToStr');
    Result:=UpperCase(Copy(tstr,2,36));
end;

end.
