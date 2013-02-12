program acBGAnimationDemo;

uses
  Forms,
  bgAniDemo in 'bgAniDemo.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmLines, frmLines);
  Application.Run;
end.
