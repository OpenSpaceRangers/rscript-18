unit Form_If;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  StdCtrls, Buttons, ComCtrls, ExtCtrls,
  GraphUnit, FormCode;

type
TifInterface=class(TGraphPointInterface)
  public
  public
    constructor Create;
    function NewPoint(tpos:TPoint):TGraphPoint; override;
end;

Tif = class(Tcode)
  public
    constructor Create;
    destructor Destroy; override;

    function DblClick:boolean; override;
end;

TFormIf = class(TFormCode)
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
  FormIf: TFormIf;

implementation

uses Form_ExprInsert;

{$R *.DFM}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TifInterface.Create;
begin
  inherited Create;
  FName:='if';
  FGroup:=2;
end;

function TifInterface.NewPoint(tpos:TPoint):TGraphPoint;
begin
  Result:=Tif.Create;
  Result.FPos:=tpos;
  Result.FText:='';
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor Tif.Create;
begin
  inherited Create;
  FImage:='Nif';
end;

destructor Tif.Destroy;
begin
  inherited Destroy;
end;

function Tif.DblClick:boolean;
begin
  Result:=false;
  FormIf.Fcode:=self;
  if FormIf.ShowModal=mrOk then Result:=true;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
procedure TFormIf.FormShow(Sender: TObject);
begin
  FormShowI(Sender);
end;

procedure TFormIf.BitBtn1Click(Sender: TObject);
begin
  ConfirmI(Sender);
end;

procedure TFormIf.RxSpeedButton2Click(Sender: TObject);
begin
  InsertI(Sender);
end;


end.

