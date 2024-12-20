unit Form_Ether;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  GraphUnit, StdCtrls, Buttons,EC_Buf, Menus, ComCtrls, ExtCtrls, Math;

type
TEtherInterface=class(TGraphPointInterface)
    public
    public
        constructor Create;
        function NewPoint(tpos:TPoint):TGraphPoint; override;
end;

TEther = class(TGraphPoint)
    public
        FType:integer;
        FUnique:WideString;
        FMsg:WideString;
        FShip1,FShip2,FShip3:WideString;
    public
        constructor Create;
        destructor Destroy; override;

        function DblClick:boolean; override;

        procedure Save(bd:TBufEC); override;
        procedure Load(bd:TBufEC); override;
        procedure LoadLink; override;

        procedure MsgDeletePoint(p:TGraphPoint); override;

        function Info:WideString; override;
end;

TFormEther = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    ComboBoxType: TComboBox;
    Label2: TLabel;
    EditUnique: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ComboBoxShip1: TComboBox;
    ComboBoxShip2: TComboBox;
    ComboBoxShip3: TComboBox;
    RxSpeedButton2: TSpeedButton;
    MemoMsg: TRichEdit;
    SpeedButton1: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure RxSpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure MemoMsgChange(Sender: TObject);
private
    { Private declarations }
public
    { Public declarations }
    FEther:TEther;
end;

var
  FormEther: TFormEther;

implementation

uses Main,Form_Main,Form_ExprInsert,Form_Group;

{$R *.DFM}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TEtherInterface.Create;
begin
    inherited Create;
    FName:='Ether';
    FGroup:=2;
end;

function TEtherInterface.NewPoint(tpos:TPoint):TGraphPoint;
begin
    Result:=TEther.Create;
    with Result do
    begin
        FPos:=tpos;
        FText:='';
    end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TEther.Create;
begin
    inherited Create;
    FImage:='Ether';

    FType:=1;
end;

destructor TEther.Destroy;
begin
    inherited Destroy;
end;

function TEther.DblClick:boolean;
begin
    Result:=false;
    FormEther.FEther:=self;
    if FormEther.ShowModal=mrOk then Result:=true;
end;

procedure TEther.Save(bd:TBufEC);
begin
    inherited Save(bd);

    bd.AddInteger(FType);
    bd.Add(FUnique);
    bd.Add(FMsg);
    bd.Add(FShip1);
    bd.Add(FShip2);
    bd.Add(FShip3);
end;

procedure TEther.Load(bd:TBufEC);
begin
    inherited Load(bd);

    FType:=bd.GetInteger;
    FUnique:=bd.GetWideStr;
    FMsg:=bd.GetWideStr;
    FShip1:=bd.GetWideStr;
    FShip2:=bd.GetWideStr;
    FShip3:=bd.GetWideStr;
end;

procedure TEther.LoadLink;
begin
    inherited LoadLink;
end;

procedure TEther.MsgDeletePoint(p:TGraphPoint);
begin
    inherited MsgDeletePoint(p);
end;

function TEther.Info:WideString;
begin
    Result:=FMsg;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
procedure TFormEther.FormShow(Sender: TObject);
var
    i:integer;
    tstr:WideString;
    gp:TGraphPoint;
begin
    ComboBoxType.ItemIndex:=FEther.FType;
    EditUnique.Text:=FEther.FUnique;
    MemoMsg.Text:=FEther.FMsg;
    ComboBoxShip1.Text:=FEther.FShip1;
    ComboBoxShip2.Text:=FEther.FShip2;
    ComboBoxShip3.Text:=FEther.FShip3;

    ComboBoxShip1.Items.Clear;
    ComboBoxShip2.Items.Clear;
    ComboBoxShip3.Items.Clear;

    tstr:='Player()';
    ComboBoxShip1.Items.Add(tstr);
    ComboBoxShip2.Items.Add(tstr);
    ComboBoxShip3.Items.Add(tstr);
    tstr:='CurShip';
    ComboBoxShip1.Items.Add(tstr);
    ComboBoxShip2.Items.Add(tstr);
    ComboBoxShip3.Items.Add(tstr);

    for i:=0 to GGraphPoint.Count-1 do
    begin
        gp:=GGraphPoint.Items[i];
        if gp is TGroup then
        begin
            tstr:='GroupToShip('+TGroup(gp).FText+')';
            ComboBoxShip1.Items.Add(tstr);
            ComboBoxShip2.Items.Add(tstr);
            ComboBoxShip3.Items.Add(tstr);
        end;
    end;
end;

procedure TFormEther.BitBtn1Click(Sender: TObject);
var tstr:WideString;
begin
    FEther.FType:=ComboBoxType.ItemIndex;
    FEther.FUnique:=EditUnique.Text;
    tstr:=FEther.FMsg;
    FEther.FMsg:=MemoMsg.Text;
    FEther.FShip1:=ComboBoxShip1.Text;
    FEther.FShip2:=ComboBoxShip2.Text;
    FEther.FShip3:=ComboBoxShip3.Text;

    CheckEditedText(tstr,MemoMsg.Text);
end;

procedure TFormEther.RxSpeedButton2Click(Sender: TObject);
begin
    FormExprInsert.FTypeFun:=1;
    if FormExprInsert.ShowModal<>mrOk then Exit;
    if FormExprInsert.FResult<>'' then MemoMsg.SelText:=FormExprInsert.FResult;
end;

procedure TFormEther.SpeedButton1Click(Sender: TObject);
begin
    EditUnique.Text:=NewGuid;
end;

procedure TFormEther.MemoMsgChange(Sender: TObject);
begin
    RichEditRStyle(MemoMsg,self);
end;

end.
