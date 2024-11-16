unit Form_StateLink;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Buttons, GraphUnit, EC_Str, EC_Buf, ExtCtrls, Menus, Math;

type
TStateLink = class(TGraphLink)
    public
        FExpr:WideString;
        FPriority:integer;
    public
        constructor Create;

        function DblClick:boolean; override;

        procedure Save(bd:TBufEC); override;
        procedure Load(bd:TBufEC); override;

        function Info:WideString; override;
end;

TFormStateLink = class(TForm)
    Panel2: TPanel;
    RxSpeedButton2: TSpeedButton;
    Panel3: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Panel1: TPanel;
    Label1: TLabel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    EditExpr: TRichEdit;
    Label2: TLabel;
    EditPriority: TEdit;
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure RxSpeedButton2Click(Sender: TObject);
private
    { Private declarations }
public
    { Public declarations }
    FLink:TStateLink;
end;

var
    FormStateLink: TFormStateLink;

implementation

uses Form_ExprInsert;

{$R *.DFM}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TStateLink.Create;
begin
    inherited Create;
end;

function TStateLink.DblClick:boolean;
begin
    Result:=false;
    FormStateLink.FLink:=self;
    if FormStateLink.ShowModal=mrOk then Result:=true;
end;

procedure TStateLink.Save(bd:TBufEC);
begin
    inherited Save(bd);

    bd.Add(FExpr);
    bd.AddInteger(FPriority);
end;

procedure TStateLink.Load(bd:TBufEC);
begin
    inherited Load(bd);

    FExpr:=bd.GetWideStr();
    FPriority:=bd.GetInteger;
end;

function TStateLink.Info:WideString;
var
    i,len:integer;
begin
    Result:=FExpr;

    if FPriority<>0 then
    begin
        len:=max(Length(FExpr),Length('Priority : '+IntToStr(FPriority)));
        Result:=Result+#13#10;
        for i:=0 to len-1 do Result:=Result+'-';
        Result:=Result+#13#10+'Priority : '+IntToStr(FPriority);
    end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
procedure TFormStateLink.FormShow(Sender: TObject);
begin
    EditExpr.Text:=FLink.FExpr;
    EditPriority.Text:=IntToStr(FLink.FPriority);
end;

procedure TFormStateLink.BitBtn1Click(Sender: TObject);
begin
    FLink.FExpr:=EditExpr.Text;
    FLink.FPriority:=StrToIntEC(EditPriority.Text);
end;

procedure TFormStateLink.RxSpeedButton2Click(Sender: TObject);
begin
    FormExprInsert.FTypeFun:=1;
    if FormExprInsert.ShowModal<>mrOk then Exit;
    if FormExprInsert.FResult<>'' then EditExpr.SelText:=FormExprInsert.FResult;
end;

end.
