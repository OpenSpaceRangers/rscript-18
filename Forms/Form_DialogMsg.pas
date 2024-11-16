unit Form_DialogMsg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  GraphUnit, StdCtrls, Buttons,EC_Buf, ExtCtrls, Menus, Math, ComCtrls;

type
TDialogMsgInterface=class(TGraphPointInterface)
    public
    public
        constructor Create;
        function NewPoint(tpos:TPoint):TGraphPoint; override;
end;

TDialogMsg = class(TGraphPoint)
  public
    FMsg:WideString;
  public
    constructor Create;

    function DblClick:boolean; override;

    procedure Save(bd:TBufEC); override;
    procedure Load(bd:TBufEC); override;

    function Info:WideString; override;
end;

TFormDialogMsg = class(TForm)
    Panel1: TPanel;
    Label2: TLabel;
    Panel2: TPanel;
    Panel3: TPanel;
    EditName: TEdit;
    Label1: TLabel;
    Panel4: TPanel;
    Panel5: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    MemoText: TRichEdit;
    RxSpeedButton2: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure RxSpeedButton2Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure MemoTextChange(Sender: TObject);
private
    { Private declarations }
public
    { Public declarations }
    FDialogMsg:TDialogMsg;
end;

var
    FormDialogMsg: TFormDialogMsg;

implementation

uses Form_Main,Form_ExprInsert,main;

{$R *.DFM}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TDialogMsgInterface.Create;
begin
  inherited Create;
  FName:='DialogMsg';
  FGroup:=3;
end;

function TDialogMsgInterface.NewPoint(tpos:TPoint):TGraphPoint;
begin
  Result:=TDialogMsg.Create;
  with Result do
  begin
    FPos:=tpos;
    FText:='';
  end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TDialogMsg.Create;
begin
  inherited Create;
  FImage:='DialogMsg';
end;

function TDialogMsg.DblClick:boolean;
begin
  Result:=false;
  FormDialogMsg.FDialogMsg:=self;
  if FormDialogMsg.ShowModal=mrOk then Result:=true;
end;

procedure TDialogMsg.Save(bd:TBufEC);
begin
  inherited Save(bd);

  bd.Add(FMsg);
end;

procedure TDialogMsg.Load(bd:TBufEC);
begin
  inherited Load(bd);

  FMsg:=bd.GetWideStr();
end;

function TDialogMsg.Info:WideString;
var
  li: TList;
  i:integer;
begin
  Result:='';
  
  li:=TList.Create();
  FindAllPoint('TDialogMsg',li);
  for i:=0 to li.Count-1 do begin
    if(li.Items[i] = self) then Result:='Message #' + IntToStr(i) + #13#10;
  end;
  li.Clear();
  li.Free();

  if FMsg<>'' then
  begin
    if Length(FMsg)<=60 then Result:=Result+FMsg
    else Result:=Result+Copy(FMsg,1,60)+' ...';
  end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
procedure TFormDialogMsg.FormShow(Sender: TObject);
var
  li: TList;
  i:integer;
begin
  Caption:='Dialog message';

  li:=TList.Create();
  FindAllPoint('TDialogMsg',li);
  for i:=0 to li.Count-1 do begin
    if(li.Items[i] = FDialogMsg) then Caption:=Caption+' #' + IntToStr(i);
  end;
  li.Clear();
  li.Free();

  EditName.Text:=FDialogMsg.FText;
  MemoText.Text:=FDialogMsg.FMsg;
end;

procedure TFormDialogMsg.BitBtn1Click(Sender: TObject);
var tstr:WideString;
begin
  FDialogMsg.FText:=EditName.Text;
  tstr:=FDialogMsg.FMsg;
  FDialogMsg.FMsg:=MemoText.Text;
  CheckEditedText(tstr,MemoText.Text);
end;

procedure TFormDialogMsg.RxSpeedButton2Click(Sender: TObject);
begin
  FormExprInsert.FTypeFun:=1;
  if FormExprInsert.ShowModal<>mrOk then Exit;
  if FormExprInsert.FResult<>'' then MemoText.SelText:=FormExprInsert.FResult;
end;

procedure TFormDialogMsg.FormResize(Sender: TObject);
begin
  EditName.Width:=MemoText.Width;
end;

procedure TFormDialogMsg.MemoTextChange(Sender: TObject);
begin
  RichEditRStyle(MemoText,self);
end;

end.
