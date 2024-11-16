unit Form_While;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  StdCtrls, Buttons, ComCtrls, ExtCtrls,
  GraphUnit, FormCode;

type
TwhileInterface=class(TGraphPointInterface)
  public
  public
    constructor Create;
    function NewPoint(tpos:TPoint):TGraphPoint; override;
end;

Twhile = class(Tcode)
  public
    constructor Create;
    destructor Destroy; override;

    function DblClick:boolean; override;
end;

TFormWhile = class(TFormCode)
    Label1: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;

    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure RxSpeedButton2Click(Sender: TObject);
private
    { Private declarations }
public
    { Public declarations }
end;

var
  FormWhile: TFormWhile;

implementation

uses Form_ExprInsert;

{$R *.DFM}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TwhileInterface.Create;
begin
  inherited Create;
  FName:='while';
  FGroup:=2;
end;

function TwhileInterface.NewPoint(tpos:TPoint):TGraphPoint;
begin
  Result:=Twhile.Create;
  Result.FPos:=tpos;
  Result.FText:='';
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor Twhile.Create;
begin
  inherited Create;
  FImage:='Nwhile';
end;

destructor Twhile.Destroy;
begin
  inherited Destroy;
end;

function Twhile.DblClick:boolean;
begin
  Result:=false;
  FormWhile.Fcode:=self;
  if FormWhile.ShowModal=mrOk then Result:=true;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
procedure TFormWhile.FormShow(Sender: TObject);
begin
  FormShowI(Sender);
end;

procedure TFormWhile.BitBtn1Click(Sender: TObject);
begin
  ConfirmI(Sender);
end;

procedure TFormWhile.RxSpeedButton2Click(Sender: TObject);
begin
  InsertI(Sender);
end;

end.

