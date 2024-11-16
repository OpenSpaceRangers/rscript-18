program RScript;

uses
  Forms,SysUtils,
  Form_Build in 'Forms\Form_Build.pas' {FormBuild},
  Form_Dialog in 'Forms\Form_Dialog.pas' {FormDialog},
  Form_DialogAnswer in 'Forms\Form_DialogAnswer.pas' {FormDialogAnswer},
  Form_DialogMsg in 'Forms\Form_DialogMsg.pas' {FormDialogMsg},
  Form_Ether in 'Forms\Form_Ether.pas' {FormEther},
  Form_ExprInsert in 'Forms\Form_ExprInsert.pas' {FormExprInsert},
  Form_Group in 'Forms\Form_Group.pas' {FormGroup},
  Form_GroupLink in 'Forms\Form_GroupLink.pas' {FormGroupLink},
  Form_If in 'Forms\Form_If.pas' {FormIf},
  Form_Item in 'Forms\Form_Item.pas' {FormItem},
  Form_Main in 'Forms\Form_Main.pas' {FormMain},
  Form_Op in 'Forms\Form_Op.pas' {FormOp},
  Form_Place in 'Forms\Form_Place.pas' {FormPlace},
  Form_Planet in 'Forms\Form_Planet.pas' {FormPlanet},
  Form_RectText in 'Forms\Form_RectText.pas' {FormRectText},
  Form_Star in 'Forms\Form_Star.pas' {FormStar},
  Form_StarLink in 'Forms\Form_StarLink.pas' {FormStarLink},
  Form_StarShip in 'Forms\Form_StarShip.pas' {FormStarShip},
  Form_State in 'Forms\Form_State.pas' {FormState},
  Form_StateLink in 'Forms\Form_StateLink.pas' {FormStateLink},
  Form_Var in 'Forms\Form_Var.pas' {FormVar},
  Form_While in 'Forms\Form_While.pas' {FormWhile},
  GraphUnit in 'GraphUnit.pas',
  Global in 'Global.pas',
  main in 'main.pas',
  EC_BlockPar in 'EC\EC_BlockPar.pas',
  EC_Buf in 'EC\EC_Buf.pas',
  EC_Expression in 'EC\EC_Expression.pas',
  EC_File in 'EC\EC_File.pas',
  EC_Mem in 'EC\EC_Mem.pas',
  EC_Str in 'EC\EC_Str.pas',
  FormCode in 'Forms\FormCode.pas';

{$R *.RES}

var s:string;
    i:integer;

begin
  Application.Initialize;

  s:=ParamStr(0);
  for i:=Length(s) downto 1 do
    if s[i]='\' then
    begin
      SetLength(s,i-1);
      SetCurrentDir(s);
      break;
    end;

  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormBuild, FormBuild);
  Application.CreateForm(TFormDialog, FormDialog);
  Application.CreateForm(TFormDialogAnswer, FormDialogAnswer);
  Application.CreateForm(TFormDialogMsg, FormDialogMsg);
  Application.CreateForm(TFormEther, FormEther);
  Application.CreateForm(TFormExprInsert, FormExprInsert);
  Application.CreateForm(TFormGroup, FormGroup);
  Application.CreateForm(TFormGroupLink, FormGroupLink);
  Application.CreateForm(TFormIf, FormIf);
  Application.CreateForm(TFormItem, FormItem);
  Application.CreateForm(TFormOp, FormOp);
  Application.CreateForm(TFormPlace, FormPlace);
  Application.CreateForm(TFormPlanet, FormPlanet);
  Application.CreateForm(TFormRectText, FormRectText);
  Application.CreateForm(TFormStar, FormStar);
  Application.CreateForm(TFormStarLink, FormStarLink);
  Application.CreateForm(TFormStarShip, FormStarShip);
  Application.CreateForm(TFormState, FormState);
  Application.CreateForm(TFormStateLink, FormStateLink);
  Application.CreateForm(TFormVar, FormVar);
  Application.CreateForm(TFormWhile, FormWhile);

  if ParamCount>0 then FormMain.LoadFromFile(ParamStr(1));

  Application.Run;
end.
