unit Form_Group;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, GraphUnit,EC_Str,EC_Buf{, RXCtrls};

type
TGroupInterface=class(TGraphPointInterface)
  public
  public
    constructor Create;
    function NewPoint(tpos:TPoint):TGraphPoint; override;
end;

TGroup = class(TGraphPoint)
  public
    FOwner:DWORD;
    FType:DWORD;
    FCntShipMin,FCntShipMax:integer;
    FSpeedMin,FSpeedMax:integer;
    FWeapon:integer;
    FCargoHook:integer;
    FEmptySpace:integer;
    FAddPlayer:boolean;

    FRuins:WideString;

    FStatusTraderMin,FStatusTraderMax:integer;
    FStatusWarriorMin,FStatusWarriorMax:integer;
    FStatusPirateMin,FStatusPirateMax:integer;

    FStrengthMin,FStrengthMax:single;

    FDistSearch:integer;

    FDialog:TGraphPoint;
  public
    constructor Create;

    function DblClick:boolean; override;

    procedure Save(bd:TBufEC); override;
    procedure Load(bd:TBufEC); override;
    procedure LoadLink; override;

    procedure MsgDeletePoint(p:TGraphPoint); override;

    function Info:WideString; override;
end;

TFormGroup = class(TForm)
    BitBtn2: TBitBtn;
    BitBtn1: TBitBtn;
    GroupBox3: TGroupBox;

    CheckBoxOwner: TCheckBox;
    CheckBoxOwnerMaloc: TCheckBox;
    CheckBoxOwnerPeleng: TCheckBox;
    CheckBoxOwnerPeople: TCheckBox;
    CheckBoxOwnerFei: TCheckBox;
    CheckBoxOwnerGaal: TCheckBox;
    CheckBoxOwnerKling: TCheckBox;
    CheckBoxOwnerPirate: TCheckBox;

    EditName: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    EditCntShip: TEdit;
    Label3: TLabel;
    ComboBoxWeapon: TComboBox;
    ComboBoxCargoHook: TComboBox;
    Label4: TLabel;
    Label5: TLabel;
    EditEmptySpace: TEdit;
    CheckBoxPlayer: TCheckBox;
    EditSpeed: TEdit;
    Label7: TLabel;
    GroupBox1: TGroupBox;
    Label9: TLabel;
    Label8: TLabel;
    Label10: TLabel;
    EditSTrader: TEdit;
    EditSWarrior: TEdit;
    EditSPirate: TEdit;
    Label13: TLabel;
    ComboBoxDialog: TComboBox;
    GroupBox4: TGroupBox;
    CheckBoxType: TCheckBox;
    CheckBoxRanger: TCheckBox;
    CheckBoxWarrior: TCheckBox;
    CheckBoxPirate: TCheckBox;
    CheckBoxTransport: TCheckBox;
    CheckBoxLiner: TCheckBox;
    CheckBoxDiplomat: TCheckBox;
    CheckBoxTranclucator: TCheckBox;
    Label14: TLabel;
    EditDistSearch: TEdit;
    Label15: TLabel;
    EditStrength: TEdit;
    EditRuins: TEdit;
    Label16: TLabel;
    CheckBoxOwnerByPlayer: TCheckBox;
    Label17: TLabel;
    CheckBoxK0Blazer: TCheckBox;
    CheckBoxK1Blazer: TCheckBox;
    CheckBoxK2Blazer: TCheckBox;
    CheckBoxK3Blazer: TCheckBox;
    CheckBoxK4Blazer: TCheckBox;
    CheckBoxK5Blazer: TCheckBox;
    Label18: TLabel;
    CheckBoxK0Keller: TCheckBox;
    CheckBoxK1Keller: TCheckBox;
    CheckBoxK2Keller: TCheckBox;
    CheckBoxK3Keller: TCheckBox;
    CheckBoxK4Keller: TCheckBox;
    CheckBoxK5Keller: TCheckBox;
    Label19: TLabel;
    CheckBoxK0Terron: TCheckBox;
    CheckBoxK1Terron: TCheckBox;
    CheckBoxK2Terron: TCheckBox;
    CheckBoxK3Terron: TCheckBox;
    CheckBoxK4Terron: TCheckBox;
    CheckBoxK5Terron: TCheckBox;
    CheckBoxK6Blazer: TCheckBox;
    CheckBoxK7Blazer: TCheckBox;
    CheckBoxK7Keller: TCheckBox;
    CheckBoxK6Keller: TCheckBox;
    CheckBoxK6Terron: TCheckBox;
    CheckBoxK7Terron: TCheckBox;

    procedure CheckBoxOwnerClick(Sender: TObject);
    procedure CheckBoxTypeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FGroup:TGroup;
end;

var
  FormGroup: TFormGroup;

implementation

uses Form_Planet,Form_Dialog,Main;

{$R *.DFM}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TGroupInterface.Create;
begin
  inherited Create;
  FName:='Group';
  FGroup:=1;
end;

function TGroupInterface.NewPoint(tpos:TPoint):TGraphPoint;
begin
  Result:=TGroup.Create;
  with Result do begin
    FPos:=tpos;
    FText:='GroupNew';
  end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TGroup.Create;
begin
  inherited Create;

  FImage:='Group';

  FOwner:=CA1(CA1(CA1(CA1(CA1(0,5),4),3),2),1);
  FType:=CA1(CA1(CA1(CA1(CA1(CA1(0,6),5),4),3),2),1);

  FCntShipMin:=2;
  FCntShipMax:=3;
  FSpeedMin:=100;
  FSpeedMax:=10000;
  FWeapon:=0;
  FCargoHook:=0;
  FEmptySpace:=0;
  FAddPlayer:=false;

  FStatusTraderMin:=0;
  FStatusTraderMax:=100;
  FStatusWarriorMin:=0;
  FStatusWarriorMax:=100;
  FStatusPirateMin:=0;
  FStatusPirateMax:=100;

  FStrengthMin:=0;
  FStrengthMax:=0;

  FDistSearch:=10000;

  FRuins:='';
end;

function TGroup.DblClick:boolean;
begin
  Result:=false;
  FormGroup.FGroup:=self;
  if FormGroup.ShowModal=mrOk then Result:=true;
end;

procedure TGroup.Save(bd:TBufEC);
begin
  inherited Save(bd);

  bd.AddDWORD(FOwner);
  bd.AddDWORD(FType);
  bd.AddInteger(FCntShipMin);
  bd.AddInteger(FCntShipMax);
  bd.AddInteger(FSpeedMin);
  bd.AddInteger(FSpeedMax);
  bd.AddInteger(FWeapon);
  bd.AddInteger(FCargoHook);
  bd.AddInteger(FEmptySpace);
  bd.AddInteger(0);
  bd.AddBoolean(FAddPlayer);

  bd.AddInteger(0);
  bd.AddInteger(0);
  bd.AddInteger(FStatusTraderMin);
  bd.AddInteger(FStatusTraderMax);
  bd.AddInteger(FStatusWarriorMin);
  bd.AddInteger(FStatusWarriorMax);
  bd.AddInteger(FStatusPirateMin);
  bd.AddInteger(FStatusPirateMax);
  bd.AddInteger(0);
  bd.AddInteger(0);

  bd.AddInteger(FDistSearch);

  bd.AddDWORD(GGraphPoint.IndexOf(FDialog));

  bd.AddSingle(FStrengthMin);
  bd.AddSingle(FStrengthMax);

  bd.Add(FRuins);
end;

procedure TGroup.Load(bd:TBufEC);
begin
  inherited Load(bd);

  FOwner:=bd.GetDWORD;
  FType:=bd.GetDWORD;
  FCntShipMin:=bd.GetInteger;
  FCntShipMax:=bd.GetInteger;
  FSpeedMin:=bd.GetInteger;
  FSpeedMax:=bd.GetInteger;
  FWeapon:=bd.GetInteger;
  FCargoHook:=bd.GetInteger;
  FEmptySpace:=bd.GetInteger;
  bd.GetInteger;
  FAddPlayer:=bd.GetBoolean;

  bd.GetInteger;
  bd.GetInteger;
  FStatusTraderMin:=bd.GetInteger;
  FStatusTraderMax:=bd.GetInteger;
  FStatusWarriorMin:=bd.GetInteger;
  FStatusWarriorMax:=bd.GetInteger;
  FStatusPirateMin:=bd.GetInteger;
  FStatusPirateMax:=bd.GetInteger;
  bd.GetInteger;
  bd.GetInteger;

  FDistSearch:=bd.GetInteger;

  FDialog:=TGraphPoint(bd.GetDWORD);

  if GFileVersion>=$00000002 then begin
    FStrengthMin:=bd.GetSingle;
    FStrengthMax:=bd.GetSingle;
    FRuins:=bd.GetWideStr;
  end;
end;

procedure TGroup.LoadLink;
begin
  inherited LoadLink;

  if integer(DWORD(FDialog))=-1 then FDialog:=nil
  else FDialog:=GGraphPoint.Items[DWORD(FDialog)];
end;

procedure TGroup.MsgDeletePoint(p:TGraphPoint);
begin
  inherited MsgDeletePoint(p);

  if FDialog=p then FDialog:=nil;
end;

function TGroup.Info:WideString;
const
  ao:array[0..7] of WideString = ('Maloc','Peleng','People','Fei','Gaal','Kling','None','PirateClan');
  at:array[0..24] of WideString = ('Ranger','Warrior','Pirate','Transport','Liner','Diplomat','K0 Blazer','K1 Blazer','K2 Blazer','K3 Blazer','K4 Blazer','K5 Blazer','K0 Keller','K1 Keller','K2 Keller','K3 Keller','K4 Keller','K5 Keller','K0 Terron','K1 Terron','K2 Terron','K3 Terron','K4 Terron','K5 Terron','Tranclucator');
var
  sl:TStringList;
  i:integer;
  tstr:WideString;
begin
  sl:=TStringList.Create;

  if CA(FOwner,0) then begin
    tstr:='';
    for i:=0 to 7 do begin
      if CA(FOwner,i+1) then begin
        if tstr<>'' then tstr:=tstr+',';
        tstr:=tstr+ao[i];
      end;
    end;
    sl.Add('Owner : '+tstr);
  end;
  if CA(FType,0) then begin
    tstr:='';
    for i:=0 to High(at) do begin
      if CA(FType,i+1) then begin
        if tstr<>'' then tstr:=tstr+',';
        tstr:=tstr+at[i];
      end;
    end;
    sl.Add('Type : '+tstr);
  end;

  if FRuins<>'' then sl.Add('Ruins : '+FRuins);

  sl.Add('Count : '+IntToStr(FCntShipMin)+','+IntToStr(FCntShipMax));
  if (FSpeedMin>0) or (FSpeedMax<10000) then sl.Add('Speed : '+IntToStr(FSpeedMin)+','+IntToStr(FSpeedMax));
  if FWeapon=1 then sl.Add('Weapon : Yes') else if FWeapon=2 then sl.Add('Weapon : No');
  if FCargoHook<>0 then sl.Add('CargoHook : '+IntToStr(FCargoHook));
  if FEmptySpace<>0 then sl.Add('Empty space : '+IntToStr(FEmptySpace));

  if (FStatusTraderMin>0) or (FStatusTraderMax<100) or (FStatusWarriorMin>0) or (FStatusWarriorMax<100) or (FStatusPirateMin>0) or (FStatusPirateMax<100) then begin
    sl.Add(Format('Status : {%d,%d}{%d,%d}{%d,%d}',[FStatusTraderMin,FStatusTraderMax,FStatusWarriorMin,FStatusWarriorMax,FStatusPirateMin,FStatusPirateMax]));
  end;

  if (FStrengthMin<>0) or (FStrengthMax<>0) then sl.Add('Strength : '+FloatToStrEC(Round(FStrengthMin*100)/100)+','+FloatToStrEC(Round(FStrengthMax*100)/100));

  if FDialog<>nil then begin
    sl.Add('Dialog : '+FDialog.FText);
  end;

  if FDistSearch<>10000 then begin
    sl.Add('Max dist search : '+IntToStr(FDistSearch));
  end;

  Result:='';
  for i:=0 to sl.Count-1 do begin
    if i<>0 then Result:=Result+#13#10;
    Result:=Result+sl.Strings[i];
  end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
procedure TFormGroup.CheckBoxOwnerClick(Sender: TObject);
begin
  CheckBoxOwnerMaloc.Enabled:=CheckBoxOwner.Checked;
  CheckBoxOwnerPeleng.Enabled:=CheckBoxOwner.Checked;
  CheckBoxOwnerPeople.Enabled:=CheckBoxOwner.Checked;
  CheckBoxOwnerFei.Enabled:=CheckBoxOwner.Checked;
  CheckBoxOwnerGaal.Enabled:=CheckBoxOwner.Checked;
  CheckBoxOwnerKling.Enabled:=CheckBoxOwner.Checked;
  CheckBoxOwnerPirate.Enabled:=CheckBoxOwner.Checked;
  CheckBoxOwnerByPlayer.Enabled:=CheckBoxOwner.Checked;
end;

procedure TFormGroup.CheckBoxTypeClick(Sender: TObject);
begin
  CheckBoxRanger.Enabled:=CheckBoxType.Checked;
  CheckBoxWarrior.Enabled:=CheckBoxType.Checked;
  CheckBoxPirate.Enabled:=CheckBoxType.Checked;
  CheckBoxTransport.Enabled:=CheckBoxType.Checked;
  CheckBoxLiner.Enabled:=CheckBoxType.Checked;
  CheckBoxDiplomat.Enabled:=CheckBoxType.Checked;
  CheckBoxK0Blazer.Enabled:=CheckBoxType.Checked;
  CheckBoxK1Blazer.Enabled:=CheckBoxType.Checked;
  CheckBoxK2Blazer.Enabled:=CheckBoxType.Checked;
  CheckBoxK3Blazer.Enabled:=CheckBoxType.Checked;
  CheckBoxK4Blazer.Enabled:=CheckBoxType.Checked;
  CheckBoxK5Blazer.Enabled:=CheckBoxType.Checked;
  // added by Koc
  CheckBoxK6Blazer.Enabled:=CheckBoxType.Checked;
  CheckBoxK7Blazer.Enabled:=CheckBoxType.Checked;
  // ------------
  CheckBoxK0Keller.Enabled:=CheckBoxType.Checked;
  CheckBoxK1Keller.Enabled:=CheckBoxType.Checked;
  CheckBoxK2Keller.Enabled:=CheckBoxType.Checked;
  CheckBoxK3Keller.Enabled:=CheckBoxType.Checked;
  CheckBoxK4Keller.Enabled:=CheckBoxType.Checked;
  CheckBoxK5Keller.Enabled:=CheckBoxType.Checked;
  // added by Koc
  CheckBoxK6Keller.Enabled:=CheckBoxType.Checked;
  CheckBoxK7Keller.Enabled:=CheckBoxType.Checked;
  // ------------
  CheckBoxK0Terron.Enabled:=CheckBoxType.Checked;
  CheckBoxK1Terron.Enabled:=CheckBoxType.Checked;
  CheckBoxK2Terron.Enabled:=CheckBoxType.Checked;
  CheckBoxK3Terron.Enabled:=CheckBoxType.Checked;
  CheckBoxK4Terron.Enabled:=CheckBoxType.Checked;
  CheckBoxK5Terron.Enabled:=CheckBoxType.Checked;
  // added by Koc
  CheckBoxK6Terron.Enabled:=CheckBoxType.Checked;
  CheckBoxK7Terron.Enabled:=CheckBoxType.Checked;
  // ------------
  CheckBoxTranclucator.Enabled:=CheckBoxType.Checked;
  EditRuins.Enabled:=CheckBoxType.Checked;
end;

procedure TFormGroup.FormShow(Sender: TObject);
var
  i:integer;
  gp:TGraphPoint;
begin
  EditName.Text:=FGroup.FText;

  CheckBoxOwner.Checked:=CA(FGroup.FOwner,0);
  CheckBoxOwnerMaloc.Checked:=CA(FGroup.FOwner,1);
  CheckBoxOwnerPeleng.Checked:=CA(FGroup.FOwner,2);
  CheckBoxOwnerPeople.Checked:=CA(FGroup.FOwner,3);
  CheckBoxOwnerFei.Checked:=CA(FGroup.FOwner,4);
  CheckBoxOwnerGaal.Checked:=CA(FGroup.FOwner,5);
  CheckBoxOwnerKling.Checked:=CA(FGroup.FOwner,6);
  CheckBoxOwnerPirate.Checked:=CA(FGroup.FOwner,8);
  CheckBoxOwnerByPlayer.Checked:=CA(FGroup.FOwner,9);
  CheckBoxOwnerClick(nil);

  CheckBoxType.Checked:=CA(FGroup.FType,0);
  CheckBoxRanger.Checked:=CA(FGroup.FType,1);
  CheckBoxWarrior.Checked:=CA(FGroup.FType,2);
  CheckBoxPirate.Checked:=CA(FGroup.FType,3);
  CheckBoxTransport.Checked:=CA(FGroup.FType,4);
  CheckBoxLiner.Checked:=CA(FGroup.FType,5);
  CheckBoxDiplomat.Checked:=CA(FGroup.FType,6);
  CheckBoxK0Blazer.Checked:=CA(FGroup.FType,7);
  CheckBoxK1Blazer.Checked:=CA(FGroup.FType,8);
  CheckBoxK2Blazer.Checked:=CA(FGroup.FType,9);
  CheckBoxK3Blazer.Checked:=CA(FGroup.FType,10);
  CheckBoxK4Blazer.Checked:=CA(FGroup.FType,11);
  CheckBoxK5Blazer.Checked:=CA(FGroup.FType,12);
  CheckBoxK0Keller.Checked:=CA(FGroup.FType,13);
  CheckBoxK1Keller.Checked:=CA(FGroup.FType,14);
  CheckBoxK2Keller.Checked:=CA(FGroup.FType,15);
  CheckBoxK3Keller.Checked:=CA(FGroup.FType,16);
  CheckBoxK4Keller.Checked:=CA(FGroup.FType,17);
  CheckBoxK5Keller.Checked:=CA(FGroup.FType,18);
  CheckBoxK0Terron.Checked:=CA(FGroup.FType,19);
  CheckBoxK1Terron.Checked:=CA(FGroup.FType,20);
  CheckBoxK2Terron.Checked:=CA(FGroup.FType,21);
  CheckBoxK3Terron.Checked:=CA(FGroup.FType,22);
  CheckBoxK4Terron.Checked:=CA(FGroup.FType,23);
  CheckBoxK5Terron.Checked:=CA(FGroup.FType,24);
  CheckBoxTranclucator.Checked:=CA(FGroup.FType,25);
  // added by Koc
  CheckBoxK6Blazer.Checked:=CA(FGroup.FType,26);
  CheckBoxK7Blazer.Checked:=CA(FGroup.FType,27);
  CheckBoxK6Keller.Checked:=CA(FGroup.FType,28);
  CheckBoxK7Keller.Checked:=CA(FGroup.FType,29);
  CheckBoxK6Terron.Checked:=CA(FGroup.FType,30);
  CheckBoxK7Terron.Checked:=CA(FGroup.FType,31);
  // ------------
  CheckBoxTypeClick(nil);

  EditRuins.Text:=FGroup.FRuins;

  EditCntShip.Text:=IntToStr(FGroup.FCntShipMin)+','+IntToStr(FGroup.FCntShipMax);
  EditSpeed.Text:=IntToStr(FGroup.FSpeedMin)+','+IntToStr(FGroup.FSpeedMax);
  ComboBoxWeapon.ItemIndex:=FGroup.FWeapon;
  ComboBoxCargoHook.ItemIndex:=FGroup.FCargoHook;
  EditEmptySpace.Text:=IntToStr(FGroup.FEmptySpace);
  CheckBoxPlayer.Checked:=FGroup.FAddPlayer;

  EditSTrader.Text:=IntToStr(FGroup.FStatusTRaderMin)+','+IntToStr(FGroup.FStatusTRaderMax);
  EditSWarrior.Text:=IntToStr(FGroup.FStatusWarriorMin)+','+IntToStr(FGroup.FStatusWarriorMax);
  EditSPirate.Text:=IntToStr(FGroup.FStatusPirateMin)+','+IntToStr(FGroup.FStatusPirateMax);

  EditStrength.Text:=FloatToStrEC(Round(FGroup.FStrengthMin*100)/100)+','+FloatToStrEC(Round(FGroup.FStrengthMax*100)/100);

  EditDistSearch.Text:=IntToStr(FGroup.FDistSearch);

  ComboBoxDialog.Clear;
  ComboBoxDialog.Items.Add('');
  ComboBoxDialog.Items.Objects[0]:=nil;
  ComboBoxDialog.ItemIndex:=0;
  for i:=0 to GGraphPoint.Count-1 do begin
    gp:=GGraphPoint.Items[i];
    if gp is TDialog then begin
      ComboBoxDialog.Items.Add(gp.FText);
      ComboBoxDialog.Items.Objects[ComboBoxDialog.Items.Count-1]:=gp;
      if gp=FGroup.FDialog then ComboBoxDialog.ItemIndex:=ComboBoxDialog.Items.Count-1;
    end;
  end;
end;

procedure TFormGroup.BitBtn1Click(Sender: TObject);
begin
  if (GetCountParEC(EditCntShip.Text,',')<2) then Exit;
  if (GetCountParEC(EditSpeed.Text,',')<2) then Exit;
  if (GetCountParEC(EditSTrader.Text,',')<2) then Exit;
  if (GetCountParEC(EditSWarrior.Text,',')<2) then Exit;
  if (GetCountParEC(EditSPirate.Text,',')<2) then Exit;
  if (GetCountParEC(EditStrength.Text,',')<2) then Exit;

  FGroup.FText:=EditName.Text;

  SCA(FGroup.FOwner,0,CheckBoxOwner.Checked);
  SCA(FGroup.FOwner,1,CheckBoxOwnerMaloc.Checked);
  SCA(FGroup.FOwner,2,CheckBoxOwnerPeleng.Checked);
  SCA(FGroup.FOwner,3,CheckBoxOwnerPeople.Checked);
  SCA(FGroup.FOwner,4,CheckBoxOwnerFei.Checked);
  SCA(FGroup.FOwner,5,CheckBoxOwnerGaal.Checked);
  SCA(FGroup.FOwner,6,CheckBoxOwnerKling.Checked);
  SCA(FGroup.FOwner,8,CheckBoxOwnerPirate.Checked);
  SCA(FGroup.FOwner,9,CheckBoxOwnerByPlayer.Checked);

  SCA(FGroup.FType,0,CheckBoxType.Checked);
  SCA(FGroup.FType,1,CheckBoxRanger.Checked);
  SCA(FGroup.FType,2,CheckBoxWarrior.Checked);
  SCA(FGroup.FType,3,CheckBoxPirate.Checked);
  SCA(FGroup.FType,4,CheckBoxTransport.Checked);
  SCA(FGroup.FType,5,CheckBoxLiner.Checked);
  SCA(FGroup.FType,6,CheckBoxDiplomat.Checked);
  SCA(FGroup.FType,7,CheckBoxK0Blazer.Checked);
  SCA(FGroup.FType,8,CheckBoxK1Blazer.Checked);
  SCA(FGroup.FType,9,CheckBoxK2Blazer.Checked);
  SCA(FGroup.FType,10,CheckBoxK3Blazer.Checked);
  SCA(FGroup.FType,11,CheckBoxK4Blazer.Checked);
  SCA(FGroup.FType,12,CheckBoxK5Blazer.Checked);
  SCA(FGroup.FType,13,CheckBoxK0Keller.Checked);
  SCA(FGroup.FType,14,CheckBoxK1Keller.Checked);
  SCA(FGroup.FType,15,CheckBoxK2Keller.Checked);
  SCA(FGroup.FType,16,CheckBoxK3Keller.Checked);
  SCA(FGroup.FType,17,CheckBoxK4Keller.Checked);
  SCA(FGroup.FType,18,CheckBoxK5Keller.Checked);
  SCA(FGroup.FType,19,CheckBoxK0Terron.Checked);
  SCA(FGroup.FType,20,CheckBoxK1Terron.Checked);
  SCA(FGroup.FType,21,CheckBoxK2Terron.Checked);
  SCA(FGroup.FType,22,CheckBoxK3Terron.Checked);
  SCA(FGroup.FType,23,CheckBoxK4Terron.Checked);
  SCA(FGroup.FType,24,CheckBoxK5Terron.Checked);
  SCA(FGroup.FType,25,CheckBoxTranclucator.Checked);
  // added by Koc
  SCA(FGroup.FType,26,CheckBoxK6Blazer.Checked);
  SCA(FGroup.FType,27,CheckBoxK7Blazer.Checked);
  SCA(FGroup.FType,28,CheckBoxK6Keller.Checked);
  SCA(FGroup.FType,29,CheckBoxK7Keller.Checked);
  SCA(FGroup.FType,30,CheckBoxK6Terron.Checked);
  SCA(FGroup.FType,31,CheckBoxK7Terron.Checked);
  // ------------
  FGroup.FRuins:=EditRuins.Text;

  FGroup.FCntShipMin:=StrToInt(GetStrParEC(EditCntShip.Text,0,','));
  FGroup.FCntShipMax:=StrToInt(GetStrParEC(EditCntShip.Text,1,','));

  FGroup.FSpeedMin:=StrToInt(GetStrParEC(EditSpeed.Text,0,','));
  FGroup.FSpeedMax:=StrToInt(GetStrParEC(EditSpeed.Text,1,','));

  FGroup.FWeapon:=ComboBoxWeapon.ItemIndex;
  FGroup.FCargoHook:=ComboBoxCargoHook.ItemIndex;
  FGroup.FEmptySpace:=StrToIntEC(EditEmptySpace.Text);
  FGroup.FAddPlayer:=CheckBoxPlayer.Checked;

  FGroup.FStatusTRaderMin:=StrToIntEC(GetStrParEC(EditSTrader.Text,0,','));
  FGroup.FStatusTRaderMax:=StrToIntEC(GetStrParEC(EditSTrader.Text,1,','));

  FGroup.FStatusWarriorMin:=StrToIntEC(GetStrParEC(EditSWarrior.Text,0,','));
  FGroup.FStatusWarriorMax:=StrToIntEC(GetStrParEC(EditSWarrior.Text,1,','));

  FGroup.FStatusPirateMin:=StrToIntEC(GetStrParEC(EditSPirate.Text,0,','));
  FGroup.FStatusPirateMax:=StrToIntEC(GetStrParEC(EditSPirate.Text,1,','));

  FGroup.FStrengthMin:=StrToFloatEC(GetStrParEC(EditStrength.Text,0,','));
  FGroup.FStrengthMax:=StrToFloatEC(GetStrParEC(EditStrength.Text,1,','));

  FGroup.FDistSearch:=StrToIntEc(EditDistSearch.Text);

  FGroup.FDialog:=ComboBoxDialog.Items.Objects[ComboBoxDialog.ItemIndex] as TGraphPoint;

  ModalResult:=mrOk;
end;

end.

