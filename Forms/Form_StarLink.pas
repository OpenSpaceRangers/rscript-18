unit Form_StarLink;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, GraphUnit, EC_Str, EC_Buf;

type
TStarLink = class(TGraphLink)
    public
        FDistMin,FDistMax:integer;
        FHole:boolean;
    public
        constructor Create;

        function DblClick:boolean; override;

        procedure Save(bd:TBufEC); override;
        procedure Load(bd:TBufEC); override;

        function Info:WideString; override;
end;

TFormStarLink = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label5: TLabel;
    EditDist: TEdit;
    CheckBoxHole: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
private
    { Private declarations }
public
    { Public declarations }
    FLink:TStarLink;
end;

var
  FormStarLink: TFormStarLink;

implementation

{$R *.DFM}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TStarLink.Create;
begin
    inherited Create;
    FArrow:=false;

    FDistMin:=0;
    FDistMax:=150;
end;

function TStarLink.DblClick:boolean;
begin
    Result:=false;
    FormStarLink.FLink:=self;
    if FormStarLink.ShowModal=mrOk then Result:=true;
end;

procedure TStarLink.Save(bd:TBufEC);
begin
    inherited Save(bd);

    bd.AddInteger(FDistMin);
    bd.AddInteger(FDistMax);
    bd.AddInteger(0);
    bd.AddInteger(0);
    bd.AddInteger(0);
    bd.AddBoolean(FHole);
end;

procedure TStarLink.Load(bd:TBufEC);
begin
    inherited Load(bd);

    FDistMin:=bd.GetInteger;
    FDistMax:=bd.GetInteger;
    bd.GetInteger;
    bd.GetInteger;
    bd.GetInteger;
    FHole:=bd.GetBoolean;
end;

function TStarLink.Info:WideString;
begin
    Result:='';
    if (FDistMin>0) or (FDistMax<150) then Result:=Result+'Distance  : '+IntToStr(FDistMin)+','+IntToStr(FDistMax)+#13#10;
    if FHole then Result:=Result+'Hole'+#13#10;

    Result:=TrimEx(Result);
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
procedure TFormStarLink.FormShow(Sender: TObject);
begin
    EditDist.Text:=IntToStr(FLink.FDistMin)+','+IntToStr(FLink.FDistMax);
    CheckBoxHole.Checked:=FLink.FHole;
end;

procedure TFormStarLink.BitBtn1Click(Sender: TObject);
begin
    if GetCountParEC(EditDist.Text,',')<2 then Exit;

    FLink.FDistMin:=StrToIntEC(GetStrParEC(EditDist.Text,0,','));
    FLink.FDistMax:=StrToIntEC(GetStrParEC(EditDist.Text,1,','));
    FLink.FHole:=CheckBoxHole.Checked;

    ModalResult:=mrOk;
end;

end.
