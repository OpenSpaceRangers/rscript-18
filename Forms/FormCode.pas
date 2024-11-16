unit FormCode;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  GraphUnit, StdCtrls, Buttons, EC_Buf, Menus, ComCtrls, ExtCtrls, Math;

type

Tcode = class(TGraphPoint)
  public
    FExpr:WideString;
    FType: integer; // 0-normal 1-init 2-global 3-dialogbegin
  public
    constructor Create;
    destructor Destroy; override;

    procedure Save(bd:TBufEC); override;
    procedure Load(bd:TBufEC); override;

    function Info:WideString; override;
end;

TFormCode = class(TForm)
    RxSpeedButton2: TSpeedButton;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    EditExpr: TRichEdit;
    ComboBoxType: TComboBox;

    procedure FormShowI(Sender: TObject);
    procedure ConfirmI(Sender: TObject);
    procedure InsertI(Sender: TObject);
private
    { Private declarations }
public
    { Public declarations }
    Fcode: Tcode;
end;

implementation

uses Form_ExprInsert;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor Tcode.Create;
begin
  inherited Create;
  FType:=0;
end;

destructor Tcode.Destroy;
begin
  inherited Destroy;
end;

procedure Tcode.Save(bd:TBufEC);
begin
  inherited Save(bd);

  bd.Add(FExpr);
  bd.AddBYTE(FType);
end;

procedure Tcode.Load(bd:TBufEC);
begin
  inherited Load(bd);

  FExpr:=bd.GetWideStr;
  if(GFileVersion < $00000006) then
  begin
    if bd.GetBoolean() then FType:=1
    else FType:=0;
  end else begin
    FType:=bd.GetBYTE();
  end;

  if      FType=1 then FImage[1]:='I'
  else if FType=2 then FImage[1]:='G'
  else if FType=3 then FImage[1]:='D'
  else FImage[1]:='N'
end;

function Tcode.Info:WideString;
var
  i,len:integer;
begin
  Result:=FExpr;

  if FType=1 then
  begin
    len:=max(Length(FExpr),Length(CT('RunInitScript')));
    Result:=Result+#13#10;
    for i:=0 to len-1 do Result:=Result+'-';
    Result:=Result+#13#10+CT('RunInitScript');
  end else if FType=2 then
  begin
    len:=max(Length(FExpr),Length(CT('RunGlobal')));
    Result:=Result+#13#10;
    for i:=0 to len-1 do Result:=Result+'-';
    Result:=Result+#13#10+CT('RunGlobal');
  end else if(FType=3) then
  begin
    len:=max(Length(FExpr),Length(CT('RunDialogBegin')));
    Result:=Result+#13#10;
    for i:=0 to len-1 do Result:=Result+'-';
    Result:=Result+#13#10+CT('RunDialogBegin');
  end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
procedure TFormCode.FormShowI(Sender: TObject);
begin
  EditExpr.Text:=Fcode.FExpr;
  ComboBoxType.ItemIndex:=Fcode.FType;
end;

procedure TFormCode.ConfirmI(Sender: TObject);
begin
  Fcode.FExpr:=EditExpr.Text;
  Fcode.FType:=ComboBoxType.ItemIndex;

  if      Fcode.FType=1 then Fcode.FImage[1]:='I'
  else if Fcode.FType=2 then Fcode.FImage[1]:='G'
  else if Fcode.FType=3 then Fcode.FImage[1]:='D'
  else Fcode.FImage[1]:='N'
end;

procedure TFormCode.InsertI(Sender: TObject);
begin
  FormExprInsert.FTypeFun:=2;
  if FormExprInsert.ShowModal<>mrOk then Exit;
  if FormExprInsert.FResult<>'' then EditExpr.SelText:=FormExprInsert.FResult;
end;

end.
