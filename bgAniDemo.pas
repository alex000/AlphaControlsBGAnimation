unit bgAniDemo;
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls,registry, sSkinProvider, sSkinManager, Buttons,
  sBitBtn, sLabel, sPanel, sEdit, ImgList, acAlphaImageList, sRadioButton,
  sGroupBox, ComCtrls, sTrackBar, sListBox, sCheckBox, sButton, acPNG;

type
  TfrmLines = class(TForm)
    Timer1: TTimer;
    sSkinManager1: TsSkinManager;
    sSkinProvider1: TsSkinProvider;
    sPanel1: TsPanel;
    sLabelFX1: TsLabelFX;
    sPanel2: TsPanel;
    sPanel3: TsPanel;
    Image3: TImage;
    sEdit1: TsEdit;
    sEdit2: TsEdit;
    sAlphaImageList1: TsAlphaImageList;
    sAlphaImageList2: TsAlphaImageList;
    sAlphaImageList3: TsAlphaImageList;
    sAlphaImageList4: TsAlphaImageList;
    sAlphaImageList5: TsAlphaImageList;
    SkinsListBox: TsListBox;
    HueTrackBar: TsTrackBar;
    SaturationTrackBar: TsTrackBar;
    HueLabel: TsStickyLabel;
    SaturationLabel: TsStickyLabel;
    sCheckBox1: TsCheckBox;
    sPanel4: TsPanel;
    sGroupBox1: TsGroupBox;
    sRadioButton1: TsRadioButton;
    sRadioButton2: TsRadioButton;
    sRadioButton3: TsRadioButton;
    sRadioButton4: TsRadioButton;
    sRadioButton5: TsRadioButton;
    sTrackBar1: TsTrackBar;
    sStickyLabel1: TsStickyLabel;
    sButton1: TsButton;
    sPanel5: TsPanel;
    sPanel6: TsPanel;
    sPanel7: TsPanel;
    sPanel8: TsPanel;
    sLabel1: TsLabel;

    procedure Timer1Timer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure sRadioButton1Click(Sender: TObject);
    procedure sRadioButton2Click(Sender: TObject);
    procedure sRadioButton3Click(Sender: TObject);
    procedure sRadioButton4Click(Sender: TObject);
    procedure sRadioButton5Click(Sender: TObject);
    procedure SaturationTrackBarMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure HueTrackBarMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SkinsListBoxClick(Sender: TObject);
    procedure sSkinManager1AfterChange(Sender: TObject);
    procedure sCheckBox1Click(Sender: TObject);
    procedure sTrackBar1Change(Sender: TObject);
  private
    { Private declarations }
    UsedIMGList:TsAlphaImageList;
     y:integer;
  public
    { Public declarations }
  end;

 var  frmLines: TfrmLines;

implementation

{$R *.DFM}

uses sSkinProps,sConst,sStyleSimply;

procedure TfrmLines.sRadioButton1Click(Sender: TObject);
begin
  UsedIMGList := sAlphaImageList1;
end;

procedure TfrmLines.sRadioButton2Click(Sender: TObject);
begin
  UsedIMGList := sAlphaImageList2;
end;

procedure TfrmLines.sRadioButton3Click(Sender: TObject);
begin
  UsedIMGList := sAlphaImageList3;
end;

procedure TfrmLines.sRadioButton4Click(Sender: TObject);
begin
  UsedIMGList := sAlphaImageList4;
end;

procedure TfrmLines.sRadioButton5Click(Sender: TObject);
begin
  UsedIMGList := sAlphaImageList5;
end;

procedure TfrmLines.Timer1Timer(Sender: TObject);
var
  i : integer;
  foundPattern,foundHotPattern :boolean;
begin
  Timer1.Enabled := False;
  try
  //-----------------
  for i := Length(sSkinManager1.ma)-1 downto 0 do
  begin
    if (((UpperCase(sSkinManager1.ma[i].PropertyName) = UpperCase(s_Pattern))
        or (UpperCase(sSkinManager1.ma[i].PropertyName) = UpperCase(s_HotPattern)))
        and (UpperCase(sSkinManager1.ma[i].ClassName) = UpperCase(s_Form))) then
    begin
      // If found then we must define new Bmp
      if (sSkinManager1.ma[i].Bmp = nil) then
         sSkinManager1.ma[i].Bmp := TBitmap.Create();

      // set Bmp size and clear it
      if (sSkinManager1.ma[i].Bmp.Width <> UsedIMGList.Width) then
      begin
        sSkinManager1.ma[i].R := Rect(0,0,0,0);
        sSkinManager1.ma[i].Bmp.SetSize(UsedIMGList.Height,UsedIMGList.Width);
        sSkinManager1.ma[i].Bmp.canvas.brush.color := clblack;
        sSkinManager1.ma[i].Bmp.Canvas.FillRect(rect(0,0,UsedIMGList.Height,UsedIMGList.Width));
      end;

      // draw next frame
      UsedIMGList.GetBitmap32(y,sSkinManager1.ma[i].Bmp);

      if (UpperCase(sSkinManager1.ma[i].PropertyName) = UpperCase(s_Pattern))    then foundPattern := true;
      if (UpperCase(sSkinManager1.ma[i].PropertyName) = UpperCase(s_HotPattern)) then foundHotPattern := true;

      if (foundPattern and foundHotPattern) then // some skins uses s_Pattern, bun some uses s_HotPattern - let's fill both
        break;
    end
  end;

	// Update of all controls
	sSkinManager1.UpdateSkin();
  //
	Inc(y);
  if (y > UsedIMGList.Items.Count-1) then
		y := 0;

  finally
    Timer1.Enabled := True;
  end;
end;


function AddBGInSkin(const SkinSection, PropName:string; sm : TsSkinManager) : boolean;
var
  i, l : integer;
  s : string;
begin
  with sm do begin
    Result := False;
    if not SkinData.Active then Exit;

    s := UpperCase(PropName);
    l := Length(ma);
    // ma - is array of records with image description
    if l > 0 then begin
      // search of the required image in the massive
      for i := 0 to l - 1 do begin
        if (UpperCase(ma[i].PropertyName) = s) and (UpperCase(ma[i].ClassName) = UpperCase(skinSection))  then begin
          Result := True;
          Break;
        end;
      end;
    end;

    // If not found we must to add new image
    if not Result then begin
      l := Length(ma) + 1;
      SetLength(ma, l);
      ma[l - 1].PropertyName := '';
      ma[l - 1].ClassName := '';
      try
        ma[l - 1].Bmp := TBitmap.Create;
        ma[l - 1].Bmp.SetSize(256,256);
      finally
        ma[l - 1].PropertyName := s;
        ma[l - 1].ClassName := UpperCase(skinSection);
        ma[l - 1].Manager := sm;
        ma[l - 1].R := Rect(0, 0, ma[l - 1].Bmp.Width, ma[l - 1].Bmp.Height);
        ma[l - 1].ImageCount := 1;
        ma[l - 1].ImgType := itisaTexture;
      end;
      if ma[l - 1].Bmp.Width < 1 then begin
        FreeAndNil(ma[l - 1].Bmp);
        SetLength(ma, l - 1);
      end;

      l := Length(pa);
      if l > 0 then for i := 0 to l - 1 do if (pa[i].PropertyName = s) and (pa[i].ClassName = UpperCase(skinSection)) then begin
        FreeAndNil(pa[i].Img);

        l := Length(pa) - 1;
        if l <> i then begin
          pa[i].Img          := pa[l].Img         ;
          pa[i].ClassName    := pa[l].ClassName   ;
          pa[i].PropertyName := pa[l].PropertyName;
        end;
        SetLength(pa, l);
        Break;
      end;
      Result := True;
    end;
  end
end;


procedure TfrmLines.HueTrackBarMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
	if (not aSkinChanging) then
		sSkinManager1.HueOffset := HueTrackBar.Position;
end;

procedure TfrmLines.SaturationTrackBarMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
	if ( not aSkinChanging) then
		sSkinManager1.Saturation := SaturationTrackBar.Position;
end;

procedure TfrmLines.sSkinManager1AfterChange(Sender: TObject);
var
  SkinIndex : integer;
begin
  AddBGInSkin('FORM', 'PATTERN', sSkinManager1);
  AddBGInSkin('FORM', 'HOTPATTERN', sSkinManager1);
   //Receive an index of the FORM section
  SkinIndex := sSkinManager1.GetSkinIndex('FORM');
  sSkinManager1.gd[SkinIndex].Props[0].ImagePercent := 100;
  sSkinManager1.gd[SkinIndex].Props[0].GradientPercent := 0;
  sSkinManager1.gd[SkinIndex].Props[0].Transparency := 0;
  sSkinManager1.gd[SkinIndex].Props[1].ImagePercent := 100;
  sSkinManager1.gd[SkinIndex].Props[1].GradientPercent := 0;
  sSkinManager1.gd[SkinIndex].Props[1].Transparency := 0;
  sSkinManager1.gd[SkinIndex].GradientPercent := 0;
  sSkinManager1.gd[SkinIndex].ImagePercent := 100;
  sSkinManager1.gd[SkinIndex].HotGradientPercent := 0;
  sSkinManager1.gd[SkinIndex].HotImagePercent := 100;

  sSkinProvider1.SkinData.CtrlSkinState := 0;
  sSkinProvider1.SkinData.Invalidate;
end;

procedure TfrmLines.sTrackBar1Change(Sender: TObject);
var i:integer;
begin
  i := sTrackBar1.Position * 50;
  if (i = 0) then
     i := 1;
  Timer1.Interval := i;
end;

procedure TfrmLines.FormActivate(Sender: TObject);
begin
  y := 0;
  UsedIMGList := sAlphaImageList5;
  sSkinManager1.GetSkinNames(SkinsListBox.Items);
  sSkinManager1AfterChange(nil);
end;

procedure TfrmLines.sCheckBox1Click(Sender: TObject);
begin
  Timer1.Enabled := not Timer1.Enabled;
end;

procedure TfrmLines.SkinsListBoxClick(Sender: TObject);
begin
  sSkinManager1.SkinName := SkinsListBox.Items.Strings[SkinsListBox.ItemIndex];
  Invalidate();
end;

end.
