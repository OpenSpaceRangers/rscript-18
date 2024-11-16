unit Form_Op;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  StdCtrls, Buttons, ComCtrls, ExtCtrls,
  GraphUnit, FormCode;

type
TopInterface=class(TGraphPointInterface)
  public
  public
    constructor Create;
    function NewPoint(tpos:TPoint):TGraphPoint; override;
end;

Top = class(Tcode)
  public
    constructor Create;
    destructor Destroy; override;

    function DblClick:boolean; override;
end;

TFormOp = class(TFormCode)
    Label1: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel6: TPanel;

    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure RxSpeedButton2Click(Sender: TObject);
private
    { Private declarations }
public
    { Public declarations }
end;

var
  FormOp: TFormOp;

implementation

{$R *.DFM}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TopInterface.Create;
begin
  inherited Create;
  FName:='Operation';
  FGroup:=2;
end;

function TopInterface.NewPoint(tpos:TPoint):TGraphPoint;
begin
  Result:=Top.Create;
  Result.FPos:=tpos;
  Result.FText:='';
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor Top.Create;
begin
  inherited Create;
  FImage:='Nop';
end;

destructor Top.Destroy;
begin
  inherited Destroy;
end;

function Top.DblClick:boolean;
begin
  Result:=false;
  FormOp.Fcode:=self;
  if FormOp.ShowModal=mrOk then Result:=true;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
procedure TFormOp.FormShow(Sender: TObject);
begin
  FormShowI(Sender);
end;

procedure TFormOp.BitBtn1Click(Sender: TObject);
begin
  ConfirmI(Sender);
end;

procedure TFormOp.RxSpeedButton2Click(Sender: TObject);
begin
  InsertI(Sender);
end;

end.
