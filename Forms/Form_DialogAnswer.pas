unit Form_DialogAnswer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  GraphUnit, StdCtrls, Buttons,EC_Buf, ComCtrls, ExtCtrls, Menus;

type
TDialogAnswerInterface=class(TGraphPointInterface)
    public
    public
        constructor Create;
        function NewPoint(tpos:TPoint):TGraphPoint; override;
end;

TDialogAnswer = class(TGraphPoint)
  public
    FMsg:WideString;
  public
    constructor Create;

    function DblClick:boolean; override;

    procedure Save(bd:TBufEC); override;
    procedure Load(bd:TBufEC); override;

    function Info:WideString; override;
end;

TFormDialogAnswer = class(TForm)
    Panel1: TPanel;
    Label2: TLabel;
    Panel2: TPanel;
    RxSpeedButton2: TSpeedButton;
    Panel5: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Panel3: TPanel;
    Label1: TLabel;
    EditName: TEdit;
    Panel4: TPanel;
    MemoText: TRichEdit;

    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure RxSpeedButton2Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure MemoTextChange(Sender: TObject);
private
    { Private declarations }
public
    { Public declarations }
    FDialogAnswer:TDialogAnswer;
end;

var
  FormDialogAnswer: TFormDialogAnswer;

implementation

uses Form_Main,Form_ExprInsert,main;

{$R *.DFM}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TDialogAnswerInterface.Create;
begin
  inherited Create;
  FName:='DialogAnswer';
  FGroup:=3;
end;

function TDialogAnswerInterface.NewPoint(tpos:TPoint):TGraphPoint;
begin
  Result:=TDialogAnswer.Create;
  with Result do begin
    FPos:=tpos;
    FText:='';
  end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TDialogAnswer.Create;
begin
  inherited Create;
  FImage:='DialogAnswer';
end;

function TDialogAnswer.DblClick:boolean;
begin
  Result:=false;
  FormDialogAnswer.FDialogAnswer:=self;
  if FormDialogAnswer.ShowModal=mrOk then Result:=true;
end;

procedure TDialogAnswer.Save(bd:TBufEC);
begin
  inherited Save(bd);

  bd.Add(FMsg);
end;

procedure TDialogAnswer.Load(bd:TBufEC);
begin
  inherited Load(bd);

  FMsg:=bd.GetWideStr();
end;

function TDialogAnswer.Info:WideString;
var
  li: TList;
  i:integer;
begin

  Result:='';

  li:=TList.Create();
  FindAllPoint('TDialogAnswer',li);
  for i:=0 to li.Count-1 do begin
    if(li.Items[i] = self) then Result:='Answer #' + IntToStr(i) + #13#10;
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
procedure TFormDialogAnswer.FormShow(Sender: TObject);
var
  li: TList;
  i:integer;
begin
  Caption:='Dialog answer';

  li:=TList.Create();
  FindAllPoint('TDialogAnswer',li);
  for i:=0 to li.Count-1 do begin
    if(li.Items[i] = FDialogAnswer) then Caption:=Caption+' #' + IntToStr(i);
  end;
  li.Clear();
  li.Free();

  EditName.Text:=FDialogAnswer.FText;
  MemoText.Text:=FDialogAnswer.FMsg;
end;

procedure TFormDialogAnswer.BitBtn1Click(Sender: TObject);
var tstr:WideString;
begin
  FDialogAnswer.FText:=EditName.Text;
  tstr:=FDialogAnswer.FMsg;
  FDialogAnswer.FMsg:=MemoText.Text;
  CheckEditedText(tstr,MemoText.Text);
end;

procedure TFormDialogAnswer.RxSpeedButton2Click(Sender: TObject);
begin
  FormExprInsert.FTypeFun:=1;
  if FormExprInsert.ShowModal<>mrOk then Exit;
  if FormExprInsert.FResult<>'' then MemoText.SelText:=FormExprInsert.FResult;
end;

procedure TFormDialogAnswer.FormResize(Sender: TObject);
begin
  EditName.Width:=MemoText.Width;
end;

procedure TFormDialogAnswer.MemoTextChange(Sender: TObject);
begin
  RichEditRStyle(MemoText,self);
end;

end.
