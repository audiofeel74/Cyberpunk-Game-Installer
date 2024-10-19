
//  Cyberpunk 2077
//  audiofeel
//  FMXInno.dll 10-June-2024
//  Last Updated: 29-July-2024

#define MyAppName        "Cyberpunk 2077"
#define MyAppVersion     "1.62"
#define MyAppPublisher   "CD Projekt Red"
#define MyAppExeName     "game.exe"

#define Slide            "19"

#define Font             "Blender Pro Medium"

#define WebLink1         "https://www.cdprojektred.com/"
#define WebLink2         "https://forums.cdprojektred.com/index.php?forums/cyberpunk.119/"
#define WebLink3         "https://www.youtube.com/user/CyberPunkGame"
#define WebLink4         "https://www.cyberpunk.net/ru/news/45334/"

#define InfoLink1        "https://www.cyberpunk.net/ru/news/45334/"
#define InfoLink2        "https://www.cyberpunk.net/ru/edgerunners"
#define InfoLink3        "https://www.cyberpunk.net/us/ru/next-gen"
#define InfoLink4        "https://www.cyberpunk.net/ru/dlc"

#define CPUThreads       "12"
#define RAM              "16384"
#define GpuRAM           "8192"
#define BuildOS          "19042"
#define NeedSpace        "71680"

#define Redist1
#ifdef Redist1
#define Redist1Name      "RED LAUNCHER"
#define Redist1Path      "Redist\REDprelauncher.exe"
#define Redist1Key       "/SILENT"
#endif

#define Redist2
#ifdef Redist2
#define Redist2Name      "DirectX"
#define Redist2Path      "Redist\dxwebsetup.exe"
#define Redist2Key       "/Q"
#endif

#define Redist3
#ifdef Redist3
#define Redist3Name      "Visual C++ 2013"
#define Redist3Path      "Redist\vc_redist.x64.exe"
#define Redist3Key       "/q /norestart"
#endif

#define DiskPassword     "123test123"
#define srep
#define CalcAccuracy     "4"

#define data1 "data1.bin"
#define data2 "data2.bin"
#define data3 "data3.bin"
#define data4 "data4.bin"
#define data5 "data5.bin"

#include                 "Modules\FMXInnoHandle.iss"

[Setup]
AllowNoIcons=yes
AppId={{A470EEA0-90EF-4879-951F-5F66DAA55B94}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
Compression=lzma2/ultra64
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=True
DisableReadyPage=True
DisableWelcomePage=False
DirExistsWarning=False
InternalCompressLevel=ultra64
OutputBaseFilename=Cyber
ExtraDiskSpaceRequired={#DoCalculationExternal(NeedSpace + '*1024*1024')}
LanguageDetectionMethod=uilanguage
ShowLanguageDialog=True
SolidCompression=True
UninstallDisplayIcon={uninstallexe}
UninstallDisplayName={#MyAppName}
UninstallFilesDir={app}\Uninstall
UsePreviousAppDir=False
UsePreviousGroup=False
UsePreviousLanguage=False
UsePreviousSetupType=False

[Components]
Name : Cyber; Description : 'CyberPunk';

[Files]
Source: "Files\*"; Flags: dontcopy  recursesubdirs
Source: "Modules\FMXInno.dll"; Flags: dontcopy
Source: "NewsRu\*"; Flags: dontcopy ; Languages: "russian"
Source: "NewsEn\*"; Flags: dontcopy ; Languages: "english"

Source: "Unpack\*"; Flags: dontcopy
#ifdef srep
  Source: "Unpack\srep\*"; Flags: dontcopy
#endif

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Check: CreateShortcuts;
Name: "{group}\{cm:ProgramOnTheWeb,{#MyAppName}}"; Filename: "{#WebLink1}"; Check: CreateShortcuts;
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Check: CreateShortcuts;

#include "Modules\Messages.iss"

[UninstallDelete]
Type: filesandordirs; Name: {app};

[Code]
var
  FMXForm: FForm;
	Splash: FSplashScreen;
  MacTB: FMacTitleBar;
  MusicPlayer: IXBass;

  BasePage: FRectangle;

  //{ About Page }\\
  AboutPage: FCustomPage;
  AboutBackBtn: FRectangle;
  AboutBackBtnLbl: array [1..2] of FLabel;
  AboutPageScrollBox: FVertScrollBox;
  AboutPageLbl: array [1..2] of FText;
  InfoLayer: array [1..4] of FRectangle;
  InfoImg: array [1..4] of FImage;
  InfoLbl: array [1..8] of FText;

  //{ Check Page }\\
  CheckPage: FCustomPage;
  CpuUsage: FCpuUsage;
  RamUsage: FRamUsage;
  GPUInfo: FGPUInfo;
  OSInfo: FOSInfo;
  CheckBackBtn: FRectangle;
  CheckBackBtnLbl: array [1..2] of FLabel;
  CheckPageLbl: array [1..14] of FText;
  CheckLayer: FRectangle;
  CheckStar: array[1..10] of FRatingStar;
  CheckFrame: FImage;

  //{ Wizard Page }\\
  WizardPage: FCustomPage;
  WebBtn: array [1..7] of FImage;
  WebBtnGlow: array [1..7] of FGlow;
  NextBtn: FRectangle;
  NextBtnLbl: array [1..2] of FLabel;
  AdvertisingImg: FImage;
  AdvertisingLbl: array [1..2] of FText;
  BackBtn: FRectangle;
  BackBtnLbl: array [1..2] of FLabel;
  AboutBtn: FRectangle;
  AboutBtnLbl: array [1..2] of FLabel;
  CheckBtn: FRectangle;
  CheckBtnLbl: array [1..2] of FLabel;
  WrnLbl: FScrollText;

  //{ Page 1 }\\
  Page1: FCustomPage;
  SlideshowLayer: FRectangle;
  Slideshow: FFormImgSlide;
  SlideshowFrame: FImage;
  Page1Lbl: FText;

  //{ Page 2 }\\
  Page2: FCustomPage;
  DiskUsage: FDiskUsage;
  Page2Lbl: array [1..3] of FText;
  Page2Edit: FEdit;
  Page2EditLine: FRectangle;
  DirBrowseForm: FFluentDirBrowse;
  BrowseBtn: FRectangle;
  BrowseBtnLbl: array [1..2] of FLabel;
  ShortcutSwitch: FToggleCheckBox;

  //{ Page 3 }\\
  Page3: FCustomPage;
  Page3Lbl: array [1..7] of FText;
  RedistSwitch: array [1..3] of FToggleCheckBox;

  //{ Page 4 }\\
  Page4: FCustomPage;
  Page4Lbl: array [1..5] of FText;
  Page4ProgressBar: FThinProgressBar;
  Page4ProgressBarLine: FRectangle;

  //{ Page 5 }\\
  Page5: FCustomPage;
  Page5Lbl: array [1..3] of FText;

  //{ Exit Form }\\
  ExitForm: FExitMsg;
  ExitYesBtn: FRectangle;
  ExitYesBtnLbl: array [1..2] of FLabel;
  ExitNoBtn: FRectangle;
  ExitNoBtnLbl: array [1..2] of FLabel;

procedure FMXInnoInit;
var
  i: Integer;
begin
  FMXForm:= InitFormHandle;
  Splash:= InitSplashHandle;
  MacTB:= InitMacTitleBar;
  MusicPlayer:= InitXBass;

  BasePage:= InitRectangleHandle;

  //{ About Page }\\
  AboutPage:= InitCustomPageHandle;
  AboutPageScrollBox:= InitVertScrollBoxHandle;
  for i:= 1 to 2 do
	begin
    AboutPageLbl[i]:= InitTextHandle;
    AboutBackBtnLbl[i]:= InitLabelHandle;
	end;
  AboutBackBtn:= InitRectangleHandle;
  for i:= 1 to 4 do
	begin
    InfoLayer[i]:= InitRectangleHandle;
    InfoImg[i]:= InitImageHandle;
	end;
  for i:= 1 to 8 do
    InfoLbl[i]:= InitTextHandle;

  //{ Check Page }\\
  CheckPage:= InitCustomPageHandle;
  CpuUsage:= InitCpuUsage;
  RamUsage:= InitRamUsage;
  GPUInfo:= InitGPUInfo;
  OSInfo:= InitOSInfo;
  for i:= 1 to 14 do
    CheckPageLbl[i]:= InitTextHandle;
  CheckBackBtn:= InitRectangleHandle;
  for i:= 1 to 2 do
    CheckBackBtnLbl[i]:= InitLabelHandle;
  CheckLayer:= InitRectangleHandle;
  for i := 1 to 10 do
    CheckStar[i]:= InitRatingStarHandle;
  CheckFrame:= InitImageHandle;

    //{ Wizard Page }\\
  WizardPage:= InitCustomPageHandle;
  for i:= 1 to 7 do
	begin
    WebBtn[i]:= InitImageHandle;
    WebBtnGlow[i]:= InitGlowHandle;
	end;

  NextBtn:= InitRectangleHandle;
  for i:= 1 to 2 do
	begin
    NextBtnLbl[i]:= InitLabelHandle;
    AdvertisingLbl[i]:= InitTextHandle;
    BackBtnLbl[i]:= InitLabelHandle;
    AboutBtnLbl[i]:= InitLabelHandle;
  	CheckBtnLbl[i]:= InitLabelHandle;
	end;

  AdvertisingImg:= InitImageHandle;
  BackBtn:= InitRectangleHandle;
  AboutBtn:= InitRectangleHandle;
  CheckBtn:= InitRectangleHandle;
  WrnLbl:= InitScrollingTextHandle;

  //{ Page 1 }\\
  Page1:= InitCustomPageHandle;
  SlideshowLayer:= InitRectangleHandle;
  Slideshow:= InitFormImgSlide;
  SlideshowFrame:= InitImageHandle;
  Page1Lbl:= InitTextHandle;

  //{ Page 2 }\\
  Page2:= InitCustomPageHandle;
  DiskUsage:= InitDiskUsage;
  for i:= 1 to 3 do
    Page2Lbl[i]:= InitTextHandle;
  Page2Edit:= InitEditHandle;
  Page2EditLine:= InitRectangleHandle;
  DirBrowseForm:= InitFluentDirBrowse;
  BrowseBtn:= InitRectangleHandle;
  for i:= 1 to 2 do
    BrowseBtnLbl[i]:= InitLabelHandle;
  ShortcutSwitch:= InitToggleCheckBoxHandle;

  //{ Page 3 }\\
  Page3:= InitCustomPageHandle;
  for i:= 1 to 5 do
    Page3Lbl[i]:= InitTextHandle;
  for i:= 1 to 3 do
    RedistSwitch[i]:= InitToggleCheckBoxHandle;

  //{ Page 4 }\\
  Page4:= InitCustomPageHandle;
  for i:= 1 to 3 do
    Page4Lbl[i]:= InitTextHandle;
  Page4ProgressBar := InitThinProgressBarHandle;
  Page4ProgressBarLine:= InitRectangleHandle;

  //{ Page 5 }\\
  Page5:= InitCustomPageHandle;
  for i:= 1 to 3 do
    Page5Lbl[i]:= InitTextHandle;

  //{ Exit Form }\\
  ExitForm:= InitExitMsgHandle;
  ExitYesBtn:= InitRectangleHandle;
  ExitNoBtn:= InitRectangleHandle;
  for i:= 1 to 2 do
	begin
    ExitYesBtnLbl[i]:= InitLabelHandle;
    ExitNoBtnLbl[i]:= InitLabelHandle;
	end;  
end;

function InitializeSetup: Boolean;
begin
  AddFontResource2(ExtractAndLoad('BlenderPro-Medium.ttf'));
  FMXInnoInit;
  Result:= True;
end;

//{ Progress Bar }\\
function ProgressCallbackEx(OverallPct, CurrentPct, DiskTotalMB, DiskExtractedMB, TotalFiles, CurFiles: Integer; DiskName,
          CurrentFile, RemainsTimeS, ElapsedTimeS, CurSpeed, AvgSpeed: WideString): longword;
begin
  Page4ProgressBar.SetValue(OverallPct, 1000);
  Page4Lbl[3].Text('R' + IntToStr(OverallPct div 10));
  Result:= ISArcExCancel;
end;

//{ Shortcuts }\\
function CreateShortcuts: Boolean;
begin
  Result := (not ISArcExError) and ShortcutSwitch.ISChecked;
end;

procedure DirUpdateProc;
begin
  DiskUsage.SetDir(WizardForm.DirEdit.Text);

  if Round(DiskUsage.FreeSpace) > StrToInt('{#NeedSpace}') then
  begin
    NextBtn.Enabled(True)
    WrnLbl.SetText(CustomMessage('WrnLbl'));
  end else
  begin
    NextBtn.Enabled(False);
    WrnLbl.SetText(CustomMessage('WrnLblERR3'));
  end;
end;

procedure CancelButtonClick(CurPageID: Integer; var Cancel, Confirm: Boolean);
begin
  Confirm:= False;
end;

Procedure CommonOnClick(Sender: TObject);
var
  ErrorCode: Integer;
  ADir: WideString;
begin
  case Sender of

    TObject(MacTB.GetObjectCloseBtn):
    begin
      if WizardForm.CurPageID = wpInstalling then
        ISArcExSuspendProc;
      ExitForm.Show;
    end;

    TObject(MacTB.GetObjectMinimizeBtn):
      pMinimizeWindow(WizardForm.Handle);

    //{ Exit Form }\\
    TObject(ExitYesBtn.GetObject):
    begin
      if WizardForm.CurPageID = wpFinished then
        WizardForm.NextButton.OnClick(Sender)
      else
      if WizardForm.CurPageID = wpInstalling then
      begin
        ISArcExCancel:= 1;
        if ISArcExIsSuspended then
          ISArcExResumeProc;
        ExitForm.Close;
      end else
        WizardForm.CancelButton.OnClick(Sender);
    end;

    TObject(ExitNoBtn.GetObject):
    begin
      if WizardForm.CurPageID = wpInstalling then
      begin
        ISArcExCancel:= 0;
        if ISArcExIsSuspended then
          ISArcExResumeProc;
        end;
      ExitForm.Close;
    end;

    //{ Web Buttons }\\
    TObject(WebBtn[1].GetObject):
      ShellExec('open', '{#WebLink1}', '', '', SW_SHOW, ewNoWait, ErrorCode);

    TObject(WebBtn[2].GetObject):
      ShellExec('open', '{#WebLink2}', '', '', SW_SHOW, ewNoWait, ErrorCode);

    TObject(WebBtn[3].GetObject):
      ShellExec('open', '{#WebLink3}', '', '', SW_SHOW, ewNoWait, ErrorCode);

    TObject(WebBtn[5].GetObject):
      ShellExec('open', '{#WebLink4}', '', '', SW_SHOW, ewNoWait, ErrorCode);

    TObject(WebBtn[4].GetObject):
    begin
      if MusicPlayer.IsPaused then
        MusicPlayer.Resume
      else
        MusicPlayer.Pause;
    end;

    //{ Next Button }\\
    TObject(NextBtn.GetObject):
    begin
      if WizardForm.CurPageID = wpInstalling then
      begin
        ISArcExSuspendProc;
        ExitForm.Show;
      end else
        WizardForm.NextButton.OnClick(Sender);
    end;

    //{ Back Button }\\
    TObject(BackBtn.GetObject):
      WizardForm.BackButton.OnClick(Sender);

    //{ About Button }\\
    TObject(AboutBtn.GetObject):
    begin
      WizardPage.Visible(False);
      AboutPage.Visible(True);
      AboutPage.AnimEnable(True);
		end;

    //{ Check Button }\\
    TObject(CheckBtn.GetObject):
    begin
      WizardPage.Visible(False);
      CheckPage.Visible(True);
      CheckPage.AnimEnable(True);
		end;

    //{ About Back Button }\\
    TObject(AboutBackBtn.GetObject):
    begin
			AboutPage.Visible(False);
      WizardPage.Visible(True);
      WizardPage.AnimEnable(True);
		end;

    //{ Check Back Button }\\
    TObject(CheckBackBtn.GetObject):
    begin
      CheckPage.Visible(False);
      WizardPage.Visible(True);
      WizardPage.AnimEnable(True);
		end;

    //{ InfoLayer Click }\\
    TObject(InfoLayer[1].GetObject):
      ShellExec('open', '{#InfoLink1}', '', '', SW_SHOW, ewNoWait, ErrorCode);

    TObject(InfoLayer[2].GetObject):
      ShellExec('open', '{#InfoLink2}', '', '', SW_SHOW, ewNoWait, ErrorCode);

    TObject(InfoLayer[3].GetObject):
      ShellExec('open', '{#InfoLink3}', '', '', SW_SHOW, ewNoWait, ErrorCode);

    TObject(InfoLayer[4].GetObject):
      ShellExec('open', '{#InfoLink4}', '', '', SW_SHOW, ewNoWait, ErrorCode);

    //{ Browse Button }\\
    TObject(BrowseBtn.GetObject):
    begin
      DirBrowseForm.DoBrowse(ADir);
      WizardForm.DirEdit.Text:= ADir;
      Page2Edit.Text(MinimizePathName(WizardForm.DirEdit.Text, WizardForm.DirEdit.Font, 450));
      DirUpdateProc;
    end;

  end;
end;

procedure CommonEnter(Sender: TObject);
begin
  case Sender of

    TObject(NextBtn.GetObject):
      NextBtn.FillColor($FF00FFFF);

    TObject(InfoLayer[1].GetObject):
      InfoLayer[1].AnimateColor(FllColor, $FFFFFFFF, 0.6);

    TObject(InfoLayer[2].GetObject):
      InfoLayer[2].AnimateColor(FllColor, $FFFFFFFF, 0.6);

    TObject(InfoLayer[3].GetObject):
      InfoLayer[3].AnimateColor(FllColor, $FFFFFFFF, 0.6);

    TObject(InfoLayer[4].GetObject):
      InfoLayer[4].AnimateColor(FllColor, $FFFFFFFF, 0.6);
  end;
end;

procedure CommonLeave(Sender: TObject);
begin
  case Sender of

    TObject(InfoLayer[1].GetObject):
      InfoLayer[1].AnimateColor(FllColor, $FF00FFFF, 0.6);

    TObject(InfoLayer[2].GetObject):
      InfoLayer[2].AnimateColor(FllColor, $FF00FFFF, 0.6);

    TObject(InfoLayer[3].GetObject):
      InfoLayer[3].AnimateColor(FllColor, $FF00FFFF, 0.6);

    TObject(InfoLayer[4].GetObject):
      InfoLayer[4].AnimateColor(FllColor, $FF00FFFF, 0.6);

    TObject(AboutBackBtn.GetObject):
    begin
      AboutBackBtn.FillColor($00000000);
      AboutBackBtnLbl[1].Color($FFDCDCDC);
    end;

    TObject(CheckBackBtn.GetObject):
    begin
      CheckBackBtn.FillColor($00000000);
      CheckBackBtnLbl[1].Color($FFDCDCDC);
    end;

    TObject(BackBtn.GetObject):
    begin
      BackBtn.FillColor($00000000);
      BackBtnLbl[1].Color($FFDCDCDC);
    end;

    TObject(AboutBtn.GetObject):
    begin
      AboutBtn.FillColor($00000000);
      AboutBtnLbl[1].Color($FFDCDCDC);
    end;

    TObject(CheckBtn.GetObject):
    begin
      CheckBtn.FillColor($00000000);
      CheckBtnLbl[1].Color($FFDCDCDC);
    end;

    TObject(NextBtn.GetObject):
      NextBtn.FillColor($FFF8003C);

    TObject(ExitYesBtn.GetObject):
    begin
      ExitYesBtn.FillColor($00000000);
      ExitYesBtnLbl[1].Color($FFDCDCDC);
    end;

    TObject(ExitNoBtn.GetObject):
    begin
      ExitNoBtn.FillColor($00000000);
      ExitNoBtnLbl[1].Color($FFDCDCDC);
    end;

    TObject(BrowseBtn.GetObject):
    begin
      BrowseBtn.StrokeColor($FF000000);
      BrowseBtnLbl[1].Color($FF000000);
    end;

  end;
end;

procedure CommonDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  case Sender of

    TObject(AboutBackBtn.GetObject):
    begin
      AboutBackBtn.FillColor($FFDCDCDC);
      AboutBackBtnLbl[1].Color($FF000000);
    end;                                       

    TObject(CheckBackBtn.GetObject):
    begin
      CheckBackBtn.FillColor($FFDCDCDC);
      CheckBackBtnLbl[1].Color($FF000000);
    end;

    TObject(BackBtn.GetObject):
    begin
      BackBtn.FillColor($FFDCDCDC);
      BackBtnLbl[1].Color($FF000000);
    end;

    TObject(AboutBtn.GetObject):
    begin
      AboutBtn.FillColor($FFDCDCDC);
      AboutBtnLbl[1].Color($FF000000);
    end;

    TObject(CheckBtn.GetObject):
    begin
      CheckBtn.FillColor($FFDCDCDC);
      CheckBtnLbl[1].Color($FF000000);
    end;

    TObject(NextBtn.GetObject):
      NextBtn.FillColor($FFF8003C);

    TObject(ExitYesBtn.GetObject):
    begin
      ExitYesBtn.FillColor($FFDCDCDC);
      ExitYesBtnLbl[1].Color($FF000000);
    end;

    TObject(ExitNoBtn.GetObject):
    begin
      ExitNoBtn.FillColor($FFDCDCDC);
      ExitNoBtnLbl[1].Color($FF000000);
    end;

    TObject(BrowseBtn.GetObject):
    begin
      BrowseBtn.StrokeColor($FF00FFFF);
      BrowseBtnLbl[1].Color($FF00FFFF);
    end;

  end;
end;

procedure CommonUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  case Sender of
    TObject(AboutBackBtn.GetObject):
    begin
      AboutBackBtn.FillColor($00000000);
      AboutBackBtnLbl[1].Color($FFDCDCDC);
    end;

    TObject(CheckBackBtn.GetObject):
    begin
      CheckBackBtn.FillColor($00000000);
      CheckBackBtnLbl[1].Color($FFDCDCDC);
    end;

    TObject(BackBtn.GetObject):
    begin
      BackBtn.FillColor($00000000);
      BackBtnLbl[1].Color($FFDCDCDC);
    end;

    TObject(AboutBtn.GetObject):
    begin
      AboutBtn.FillColor($00000000);
      AboutBtnLbl[1].Color($FFDCDCDC);
    end;

    TObject(CheckBtn.GetObject):
    begin
      CheckBtn.FillColor($00000000);
      CheckBtnLbl[1].Color($FFDCDCDC);
    end;

    TObject(NextBtn.GetObject):
      NextBtn.FillColor($FF00FFFF);

    TObject(ExitYesBtn.GetObject):
    begin
      ExitYesBtn.FillColor($00000000);
      ExitYesBtnLbl[1].Color($FFDCDCDC);
    end;

    TObject(ExitNoBtn.GetObject):
    begin
      ExitNoBtn.FillColor($00000000);
      ExitNoBtnLbl[1].Color($FFDCDCDC);
    end;

    TObject(BrowseBtn.GetObject):
    begin
      BrowseBtn.StrokeColor($FF000000);
      BrowseBtnLbl[1].Color($FF000000);
    end;

  end;
end;

procedure FMXDesigning;
var
  i: Integer;
  S1, S2, S3, S4: AnsiString;
begin
  FMXForm.FCreateImageForm(WizardForm.Handle, ExtractAndLoad('img.jpg'), 1);
  FMXForm.LoadStyleFromFile(ExtractAndLoad('Style.bin'));

	MacTB.FCreate(FMXForm.Handle);
  MacTB.MinimizeOnClick(@CommonOnClick);
  MacTB.ExitOnClick(@CommonOnClick);

  BasePage.FCreate(FMXForm.Handle);
  BasePage.Align(Contents);
  BasePage.FillColor($00000000);
  BasePage.StrokeColor($FF292929);
  BasePage.StrokeSetting(1.5, scFlat, sdSolid, sjBevel);
  BasePage.HitTest(False);

  //{ About Page }\\
  AboutPage.FCreate(BasePage.Handle);
 	AboutPage.AnimDuration(0.3);
	AboutPage.AnimPropertyName('Opacity');
	AboutPage.AnimSetValues(0, 1);
	AboutPage.Visible(False);

  AboutPageScrollBox.FCreate(AboutPage.Handle);
  AboutPageScrollBox.SetBounds(0, 40, AboutPage.GetWidth, 683);
  AboutPageScrollBox.SmoothScroll(True);

  AboutPageLbl[1].FCreate(AboutPageScrollBox.Handle);
  AboutPageLbl[1].Text(AnsiUppercase(CustomMessage('AboutPageLbl1')));
  AboutPageLbl[1].TextSetting(False, txCenter, txLeading);
  AboutPageLbl[1].FontSetting('{#Font}', VCLFontSizeToFMX(52), $FF000000);
 	AboutPageLbl[1].SetBounds(0, 5, AboutPageScrollBox.GetWidth, 80);

  AboutPageLbl[2].FCreate(AboutPageScrollBox.Handle);
  AboutPageLbl[2].Text(CustomMessage('AboutPageLbl2'));
  AboutPageLbl[2].TextSetting(True, txCenter, txLeading);
  AboutPageLbl[2].FontSetting('{#Font}', VCLFontSizeToFMX(17), $FF000000);
  AboutPageLbl[2].SetBounds(210, 97, AboutPageScrollBox.GetWidth - 420, 90);

  //{ Info 1 }\\
  InfoLayer[1].FCreate(AboutPageScrollBox.Handle);
  InfoLayer[1].SetBounds(49, 215, 650, 660);
  InfoLayer[1].FillColor($FF00FFFF);
  InfoLayer[1].StrokeColor($FF000000);
  InfoLayer[1].StrokeSetting(5, scFlat, sdSolid, sjBevel);
  InfoLayer[1].OnMouseEnter(@CommonEnter);
  InfoLayer[1].OnMouseLeave(@CommonLeave);
  InfoLayer[1].OnClick(@CommonOnClick);

  InfoImg[1].FCreate(InfoLayer[1].Handle);
  InfoImg[1].SetBounds(16, 16, 618, 347);
  InfoImg[1].LoadPicture(ExtractAndLoad('InfoImg1.jpg'), iwStretch);
  InfoImg[1].HitTest(False);

  InfoLbl[1].FCreate(InfoLayer[1].Handle);
  InfoLbl[1].Text(AnsiUppercase(CustomMessage('InfoLbl1')));
  InfoLbl[1].AutoSize(True);
  InfoLbl[1].TextSetting(False, txLeading, txLeading);
  InfoLbl[1].FontSetting('{#Font}', VCLFontSizeToFMX(29), $FF000000);
  InfoLbl[1].Position(74, 375);
  InfoLbl[1].HitTest(False);

  if ActiveLanguage = 'russian' then
    LoadStringFromFile(ExtractAndLoad('News1Ru.txt'), S1)
  else
    LoadStringFromFile(ExtractAndLoad('News1En.txt'), S1);

  InfoLbl[2].FCreate(InfoLayer[1].Handle);
  InfoLbl[2].Text(CnvtToWStr(S1));
  InfoLbl[2].TextSetting(True, txLeading, txLeading);
  InfoLbl[2].FontSetting('{#Font}', VCLFontSizeToFMX(16), $FF000000);
  InfoLbl[2].SetBounds(74, 475, 510, 140);
  InfoLbl[2].HitTest(False);

  //{ Info 2 }\\
  InfoLayer[2].FCreate(AboutPageScrollBox.Handle);
  InfoLayer[2].SetBounds(InfoLayer[1].GetLeft + InfoLayer[1].GetWidth + 25, InfoLayer[1].GetTop, 650, 660);
  InfoLayer[2].FillColor($FF00FFFF);
  InfoLayer[2].StrokeColor($FF000000);
  InfoLayer[2].StrokeSetting(5, scFlat, sdSolid, sjBevel);
  InfoLayer[2].OnMouseEnter(@CommonEnter);
  InfoLayer[2].OnMouseLeave(@CommonLeave);
  InfoLayer[2].OnClick(@CommonOnClick);

  InfoImg[2].FCreate(InfoLayer[2].Handle);
  InfoImg[2].SetBounds(16, 16, 618, 347);
  InfoImg[2].LoadPicture(ExtractAndLoad('InfoImg2.jpg'), iwStretch);
  InfoImg[2].HitTest(False);

  InfoLbl[3].FCreate(InfoLayer[2].Handle);
  InfoLbl[3].Text(AnsiUppercase(CustomMessage('InfoLbl3')));
  InfoLbl[3].AutoSize(True);
  InfoLbl[3].TextSetting(False, txLeading, txLeading);
  InfoLbl[3].FontSetting('{#Font}', VCLFontSizeToFMX(29), $FF000000);
  InfoLbl[3].Position(74, 375);
  InfoLbl[3].HitTest(False);

  if ActiveLanguage = 'russian' then
    LoadStringFromFile(ExtractAndLoad('News1Ru.txt'), S2)
  else
    LoadStringFromFile(ExtractAndLoad('News1En.txt'), S2);

  InfoLbl[4].FCreate(InfoLayer[2].Handle);
  InfoLbl[4].Text(CnvtToWStr(S2));
  InfoLbl[4].TextSetting(True, txLeading, txLeading);
  InfoLbl[4].FontSetting('{#Font}', VCLFontSizeToFMX(16), $FF000000);
  InfoLbl[4].SetBounds(74, 435, 499, 160);
  InfoLbl[4].HitTest(False);

  //{ Info 3 }\\
  InfoLayer[3].FCreate(AboutPageScrollBox.Handle);
  InfoLayer[3].SetBounds(InfoLayer[1].GetLeft, InfoLayer[1].GetTop + InfoLayer[1].GetHeight + 25, 650, 660);
  InfoLayer[3].FillColor($FF00FFFF);
  InfoLayer[3].StrokeColor($FF000000);
  InfoLayer[3].StrokeSetting(5, scFlat, sdSolid, sjBevel);
  InfoLayer[3].OnMouseEnter(@CommonEnter);
  InfoLayer[3].OnMouseLeave(@CommonLeave);
  InfoLayer[3].OnClick(@CommonOnClick);

  InfoImg[3].FCreate(InfoLayer[3].Handle);
  InfoImg[3].SetBounds(16, 16, 618, 347);
  InfoImg[3].LoadPicture(ExtractAndLoad('InfoImg3.jpg'), iwStretch);
  InfoImg[3].HitTest(False);

  InfoLbl[5].FCreate(InfoLayer[3].Handle);
  InfoLbl[5].Text(AnsiUppercase(CustomMessage('InfoLbl5')));
  InfoLbl[5].AutoSize(True);
  InfoLbl[5].TextSetting(False, txLeading, txLeading);
  InfoLbl[5].FontSetting('{#Font}', VCLFontSizeToFMX(29), $FF000000);
  InfoLbl[5].Position(74, 375);
  InfoLbl[5].HitTest(False);

  if ActiveLanguage = 'russian' then
    LoadStringFromFile(ExtractAndLoad('News1Ru.txt'), S3)
  else
    LoadStringFromFile(ExtractAndLoad('News1En.txt'), S3);

  InfoLbl[6].FCreate(InfoLayer[3].Handle);
  InfoLbl[6].Text(CnvtToWStr(S3));
  InfoLbl[6].TextSetting(True, txLeading, txLeading);
  InfoLbl[6].FontSetting('{#Font}', VCLFontSizeToFMX(16), $FF000000);
  InfoLbl[6].SetBounds(74, 477, 499, 140);
  InfoLbl[6].HitTest(False);

  //{ Info 4 }\\
  InfoLayer[4].FCreate(AboutPageScrollBox.Handle);
  InfoLayer[4].SetBounds(InfoLayer[2].GetLeft, InfoLayer[3].GetTop, 650, 660);
  InfoLayer[4].FillColor($FF00FFFF);
  InfoLayer[4].StrokeColor($FF000000);
  InfoLayer[4].StrokeSetting(5.0, scFlat, sdSolid, sjBevel);
  InfoLayer[4].OnMouseEnter(@CommonEnter);
  InfoLayer[4].OnMouseLeave(@CommonLeave);
  InfoLayer[4].OnClick(@CommonOnClick);

  InfoImg[4].FCreate(InfoLayer[4].Handle);
  InfoImg[4].SetBounds(16, 16, 618, 347);
  InfoImg[4].LoadPicture(ExtractAndLoad('InfoImg4.jpg'), iwStretch);
  InfoImg[4].HitTest(False);

  InfoLbl[7].FCreate(InfoLayer[4].Handle);
  InfoLbl[7].Text(AnsiUppercase(CustomMessage('InfoLbl7')));
  InfoLbl[7].AutoSize(True);
  InfoLbl[7].TextSetting(False, txLeading, txLeading);
  InfoLbl[7].FontSetting('{#Font}', VCLFontSizeToFMX(29), $FF000000);
  InfoLbl[7].Position(74, 375);
  InfoLbl[7].HitTest(False);

  if ActiveLanguage = 'russian' then
    LoadStringFromFile(ExtractAndLoad('News1Ru.txt'), S4)
  else
    LoadStringFromFile(ExtractAndLoad('News1En.txt'), S4);

  InfoLbl[8].FCreate(InfoLayer[4].Handle);
  InfoLbl[8].Text(CnvtToWStr(S4));
  InfoLbl[8].TextSetting(True, txLeading, txLeading);
  InfoLbl[8].FontSetting('{#Font}', VCLFontSizeToFMX(16), $FF000000);
  InfoLbl[8].SetBounds(74, 477, 499, 140);
  InfoLbl[8].HitTest(False);

  //{ AboutBack Button }\\
  AboutBackBtn.FCreate(AboutPage.Handle);
  AboutBackBtn.SetBounds(195, 744, 155, 50);
  AboutBackBtn.FillColor($00000000);
  AboutBackBtn.StrokeColor($FFDCDCDC);
  AboutBackBtn.StrokeSetting(2, scFlat, sdSolid, sjBevel);
  AboutBackBtn.CornerStyle(20, 20, [tcBottomLeft], ctBevel);
  AboutBackBtn.OnMouseLeave(@CommonLeave);
  AboutBackBtn.OnMouseDown(@CommonDown);
  AboutBackBtn.OnMouseUp(@CommonUp);
  AboutBackBtn.OnClick(@CommonOnClick);
  AboutBackBtnLbl[1].FCreate(AboutBackBtn.Handle, AnsiUppercase(CustomMessage('AboutBackBtnLbl1')));
  AboutBackBtnLbl[1].Align(Contents);
  AboutBackBtnLbl[1].AutoSize(True);
  AboutBackBtnLbl[1].TextSetting(False, txCenter, txCenter);
  AboutBackBtnLbl[1].FontSetting('{#Font}', VCLFontSizeToFMX2(10.5), $FFDCDCDC);
  AboutBackBtnLbl[1].FontStyle([fsBold]);
  AboutBackBtnLbl[2].FCreate(AboutPage.Handle, AnsiUppercase('R23'));
  AboutBackBtnLbl[2].AutoSize(True);
  AboutBackBtnLbl[2].TextSetting(False, txLeading, txLeading);
  AboutBackBtnLbl[2].FontSetting('{#Font}', VCLFontSizeToFMX2(6), $FFDCDCDC);
  AboutBackBtnLbl[2].Position(318, 793);

  //{ Check Page }\\
  CheckPage.FCreate(BasePage.Handle);
 	CheckPage.AnimDuration(0.3);
	CheckPage.AnimPropertyName('Opacity');
	CheckPage.AnimSetValues(0, 1);
	CheckPage.Visible(False);

  CheckPageLbl[1].FCreate(CheckPage.Handle);
  CheckPageLbl[1].AutoSize(True);
  CheckPageLbl[1].Text(AnsiUppercase(CustomMessage('CheckPageLbl1')));
  CheckPageLbl[1].TextSetting(False, txLeading, txLeading);
  CheckPageLbl[1].FontSetting('{#Font}', VCLFontSizeToFMX(25), $FF000000);
  CheckPageLbl[1].Position(765, 165);

  CheckPageLbl[2].FCreate(CheckPage.Handle);
  CheckPageLbl[2].AutoSize(True);
  CheckPageLbl[2].Text(CustomMessage('CheckPageLbl2'));
  CheckPageLbl[2].TextSetting(False, txLeading, txLeading);
  CheckPageLbl[2].FontSetting('{#Font}', VCLFontSizeToFMX(12), $FF000000);
  CheckPageLbl[2].Position(785, 216);

  CheckLayer.FCreate(CheckPage.Handle);
  CheckLayer.FillPicture(ExtractAndLoad('chwall.jpg'), wmTileStretch);
  CheckLayer.Opacity(0.95);
  CheckLayer.SetBounds(767, 300, 583, 330);
  CheckLayer.RotationAngle(- 2.5);

  CheckPageLbl[3].FCreate(CheckLayer.Handle);
  CheckPageLbl[3].AutoSize(True);
  CheckPageLbl[3].Text(CustomMessage('CheckPageLbl3'));
  CheckPageLbl[3].TextSetting(False, txLeading, txLeading);
  CheckPageLbl[3].FontSetting('{#Font}', VCLFontSizeToFMX(12), $FFFFFFFF);
  CheckPageLbl[3].Position(20, 15);

  CheckPageLbl[4].FCreate(CheckLayer.Handle);
  CheckPageLbl[4].AutoSize(True);
  CheckPageLbl[4].Text('CPU Threads ' + '{#CPUThreads}');
  CheckPageLbl[4].TextSetting(False, txLeading, txLeading);
  CheckPageLbl[4].FontSetting('{#Font}', VCLFontSizeToFMX(12), $FFFFFFFF);
  CheckPageLbl[4].Position(50, 55);

  CheckStar[1].FCreate(CheckLayer.Handle);
  CheckStar[1].SetBounds(60, 75, 120, 15);
  CheckStar[1].MaximumRating({#CPUThreads});
  CheckStar[1].Value({#CPUThreads});
  CheckStar[1].Color($FF00FFFF);
  CheckStar[1].BackgroundColor($FFF8003C);

  CheckPageLbl[5].FCreate(CheckLayer.Handle);
  CheckPageLbl[5].AutoSize(True);
  CheckPageLbl[5].Text('Physical Memory ' + MbOrTb({#RAM}, 0));
  CheckPageLbl[5].TextSetting(False, txLeading, txLeading);
  CheckPageLbl[5].FontSetting('{#Font}', VCLFontSizeToFMX(12), $FFFFFFFF);
  CheckPageLbl[5].Position(CheckPageLbl[4].GetLeft, 100);

  CheckStar[2].FCreate(CheckLayer.Handle);
  CheckStar[2].SetBounds(CheckStar[1].GetLeft, 120, 120, 15);
  CheckStar[2].MaximumRating({#RAM});
  CheckStar[2].Value({#RAM});
  CheckStar[2].Color($FF00FFFF);
  CheckStar[2].BackgroundColor($FFF8003C);

  CheckPageLbl[6].FCreate(CheckLayer.Handle);
  CheckPageLbl[6].AutoSize(True);
  CheckPageLbl[6].Text('GPU Memory ' + MbOrTb({#GpuRAM}, 0));
  CheckPageLbl[6].TextSetting(False, txLeading, txLeading);
  CheckPageLbl[6].FontSetting('{#Font}', VCLFontSizeToFMX(12), $FFFFFFFF);
  CheckPageLbl[6].Position(CheckPageLbl[4].GetLeft, 145);

  CheckStar[3].FCreate(CheckLayer.Handle);
  CheckStar[3].SetBounds(CheckStar[1].GetLeft, 165, 120, 15);
  CheckStar[3].MaximumRating({#GpuRAM});
  CheckStar[3].Value({#GpuRAM});
  CheckStar[3].Color($FF00FFFF);
  CheckStar[3].BackgroundColor($FFF8003C);

  CheckPageLbl[7].FCreate(CheckLayer.Handle);
  CheckPageLbl[7].AutoSize(True);
  CheckPageLbl[7].Text('Need Space ' + MbOrTb({#NeedSpace}, 0));
  CheckPageLbl[7].TextSetting(False, txLeading, txLeading);
  CheckPageLbl[7].FontSetting('{#Font}', VCLFontSizeToFMX(12), $FFFFFFFF);
  CheckPageLbl[7].Position(CheckPageLbl[4].GetLeft, 190);

  CheckStar[4].FCreate(CheckLayer.Handle);
  CheckStar[4].SetBounds(CheckStar[1].GetLeft, 210, 120, 15);
  CheckStar[4].MaximumRating({#NeedSpace});
  CheckStar[4].Value({#NeedSpace});
  CheckStar[4].Color($FF00FFFF);
  CheckStar[4].BackgroundColor($FFF8003C);

  CheckPageLbl[8].FCreate(CheckLayer.Handle);
  CheckPageLbl[8].AutoSize(True);
  CheckPageLbl[8].Text('Build OS ' + '{#BuildOS}');
  CheckPageLbl[8].TextSetting(False, txLeading, txLeading);
  CheckPageLbl[8].FontSetting('{#Font}', VCLFontSizeToFMX(12), $FFFFFFFF);
  CheckPageLbl[8].Position(CheckPageLbl[4].GetLeft, 235);

  CheckStar[5].FCreate(CheckLayer.Handle);
  CheckStar[5].SetBounds(CheckStar[1].GetLeft, 255, 120, 15);
  CheckStar[5].MaximumRating({#BuildOS});
  CheckStar[5].Value({#BuildOS});
  CheckStar[5].Color($FF00FFFF);
  CheckStar[5].BackgroundColor($FFF8003C);

  CheckPageLbl[9].FCreate(CheckLayer.Handle);
  CheckPageLbl[9].AutoSize(True);
  CheckPageLbl[9].Text(CustomMessage('CheckPageLbl9'));
  CheckPageLbl[9].TextSetting(False, txLeading, txLeading);
  CheckPageLbl[9].FontSetting('{#Font}', VCLFontSizeToFMX(12), $FFFFFFFF);
  CheckPageLbl[9].Position(290, CheckPageLbl[3].GetTop);

  CheckPageLbl[10].FCreate(CheckLayer.Handle);
  CheckPageLbl[10].AutoSize(True);
  CheckPageLbl[10].Text('CPU Threads ' + IntToStr(CpuUsage.Threads));
  CheckPageLbl[10].TextSetting(False, txLeading, txLeading);
  CheckPageLbl[10].FontSetting('{#Font}', VCLFontSizeToFMX(12), $FFFFFFFF);
  CheckPageLbl[10].Position(315, CheckPageLbl[4].GetTop);

  CheckStar[6].FCreate(CheckLayer.Handle);
  CheckStar[6].SetBounds(325, CheckStar[1].GetTop, 120, 15);
  CheckStar[6].MaximumRating({#CPUThreads});
  CheckStar[6].Value(CpuUsage.Threads);
  CheckStar[6].Color($FF00FFFF);
  CheckStar[6].BackgroundColor($FFF8003C);

  CheckPageLbl[11].FCreate(CheckLayer.Handle);
  CheckPageLbl[11].AutoSize(True);
  CheckPageLbl[11].Text('Physical Memory ' + MbOrTb(RamUsage.TotalRam, 0));
  CheckPageLbl[11].TextSetting(False, txLeading, txLeading);
  CheckPageLbl[11].FontSetting('{#Font}', VCLFontSizeToFMX(12), $FFFFFFFF);
  CheckPageLbl[11].Position(CheckPageLbl[10].GetLeft, CheckPageLbl[5].GetTop);

  CheckStar[7].FCreate(CheckLayer.Handle);
  CheckStar[7].SetBounds(CheckStar[6].GetLeft, CheckStar[2].GetTop, 120, 15);
  CheckStar[7].MaximumRating({#RAM});
  CheckStar[7].Value(RamUsage.TotalRam);
  CheckStar[7].Color($FF00FFFF);
  CheckStar[7].BackgroundColor($FFF8003C);

  CheckPageLbl[12].FCreate(CheckLayer.Handle);
  CheckPageLbl[12].AutoSize(True);
  CheckPageLbl[12].Text('GPU Memory ' + MbOrTb(GPUInfo.GPUMemory, 0));
  CheckPageLbl[12].TextSetting(False, txLeading, txLeading);
  CheckPageLbl[12].FontSetting('{#Font}', VCLFontSizeToFMX(12), $FFFFFFFF);
  CheckPageLbl[12].Position(CheckPageLbl[10].GetLeft, CheckPageLbl[6].GetTop);

  CheckStar[8].FCreate(CheckLayer.Handle);
  CheckStar[8].SetBounds(CheckStar[6].GetLeft, CheckStar[3].GetTop, 120, 15);
  CheckStar[8].MaximumRating({#GpuRAM});
  CheckStar[8].Value(GPUInfo.GPUMemory);
  CheckStar[8].Color($FF00FFFF);
  CheckStar[8].BackgroundColor($FFF8003C);

  CheckPageLbl[13].FCreate(CheckLayer.Handle);
  CheckPageLbl[13].AutoSize(True);
  CheckPageLbl[13].Text('Free Space ' + MbOrTb(DiskUsage.FreeSpace, 0));
  CheckPageLbl[13].TextSetting(False, txLeading, txLeading);
  CheckPageLbl[13].FontSetting('{#Font}', VCLFontSizeToFMX(12), $FFFFFFFF);
  CheckPageLbl[13].Position(CheckPageLbl[10].GetLeft, CheckPageLbl[7].GetTop);

  CheckStar[9].FCreate(CheckLayer.Handle);
  CheckStar[9].SetBounds(CheckStar[6].GetLeft, CheckStar[4].GetTop, 120, 15);
  CheckStar[9].MaximumRating({#NeedSpace});
  CheckStar[9].Value(DiskUsage.FreeSpace);
  CheckStar[9].Color($FF00FFFF);
  CheckStar[9].BackgroundColor($FFF8003C);

  CheckPageLbl[14].FCreate(CheckLayer.Handle);
  CheckPageLbl[14].AutoSize(True);
  CheckPageLbl[14].Text('Build OS ' + OSInfo.BuildNumber);
  CheckPageLbl[14].TextSetting(False, txLeading, txLeading);
  CheckPageLbl[14].FontSetting('{#Font}', VCLFontSizeToFMX(12), $FFFFFFFF);
  CheckPageLbl[14].Position(CheckPageLbl[10].GetLeft, CheckPageLbl[8].GetTop);

  CheckStar[10].FCreate(CheckLayer.Handle);
  CheckStar[10].SetBounds(CheckStar[6].GetLeft, CheckStar[5].GetTop, 120, 15);
  CheckStar[10].MaximumRating({#BuildOS});
  CheckStar[10].Value(GetWinBuildNumber);
  CheckStar[10].Color($FF00FFFF);
  CheckStar[10].BackgroundColor($FFF8003C);

  CheckFrame.FCreate(CheckPage.Handle);
  CheckFrame.SetBounds(661, 236, 778, 508);
  CheckFrame.LoadPicture(ExtractAndLoad('Chfrm.png'), iwStretch);

  //{ CheckBack Button }\\
  CheckBackBtn.FCreate(CheckPage.Handle);
  CheckBackBtn.SetBounds(195, 744, 155, 50);
  CheckBackBtn.FillColor($00000000);
  CheckBackBtn.StrokeColor($FFDCDCDC);
  CheckBackBtn.StrokeSetting(2.0, scFlat, sdSolid, sjBevel);
  CheckBackBtn.CornerStyle(20, 20, [tcBottomLeft], ctBevel);
  CheckBackBtn.OnMouseLeave(@CommonLeave);
  CheckBackBtn.OnMouseDown(@CommonDown);
  CheckBackBtn.OnMouseUp(@CommonUp);
  CheckBackBtn.OnClick(@CommonOnClick);
  CheckBackBtnLbl[1].FCreate(CheckBackBtn.Handle, AnsiUppercase(CustomMessage('CheckBackBtnLbl1')));
  CheckBackBtnLbl[1].Align(Contents);
  CheckBackBtnLbl[1].AutoSize(True);
  CheckBackBtnLbl[1].TextSetting(False, txCenter, txCenter);
  CheckBackBtnLbl[1].FontSetting('{#Font}', VCLFontSizeToFMX2(10.5), $FFDCDCDC);
  CheckBackBtnLbl[1].FontStyle([fsBold]);
  CheckBackBtnLbl[2].FCreate(CheckPage.Handle, AnsiUppercase('R23'));
  CheckBackBtnLbl[2].Text(AnsiUppercase('R23'));
  CheckBackBtnLbl[2].AutoSize(True);
  CheckBackBtnLbl[2].TextSetting(False, txLeading, txLeading);
  CheckBackBtnLbl[2].FontSetting('{#Font}', VCLFontSizeToFMX2(6), $FFDCDCDC);
  CheckBackBtnLbl[2].Position(318, 793);

  //{ Wizard Page }\\
  WizardPage.FCreate(BasePage.Handle);
	WizardPage.AnimDuration(0.3);
	WizardPage.AnimPropertyName('Opacity');
	WizardPage.AnimSetValues(0, 1);

  //{ Web Button }\\
  WebBtn[1].FCreate(WizardPage.Handle);
  WebBtn[1].SetBounds(1200, 28, 184, 81);
  WebBtn[1].LoadPicture(ExtractAndLoad('wbtn1.png'), iwStretch);
  WebBtn[1].OnClick(@CommonOnClick);
  WebBtnGlow[1].FCreate(WebBtn[1].Handle);
  WebBtnGlow[1].Enabled(False);
  WebBtnGlow[1].GlowColor($FFFF0000);
  WebBtnGlow[1].GlowAnimate(0.3, 0.2, 0);
  WebBtnGlow[1].Opacity(0.3);
  WebBtnGlow[1].Trigger('IsMouseOver=true');

  WebBtn[2].FCreate(WizardPage.Handle);
  WebBtn[2].SetBounds(1147, 64, 26, 26);
  WebBtn[2].LoadPicture(ExtractAndLoad('wbtn2.png'), iwStretch);
  WebBtn[2].OnClick(@CommonOnClick);
  WebBtnGlow[2].FCreate(WebBtn[2].Handle);
  WebBtnGlow[2].Enabled(False);
  WebBtnGlow[2].GlowColor($FF000000);
  WebBtnGlow[2].GlowAnimate(0.3, 0.2, 0);
  WebBtnGlow[2].Opacity(0.3);
  WebBtnGlow[2].Trigger('IsMouseOver=true');

  WebBtn[3].FCreate(WizardPage.Handle);
  WebBtn[3].SetBounds(1100, 64, 25, 25);
  WebBtn[3].LoadPicture(ExtractAndLoad('wbtn3.png'), iwStretch);
  WebBtn[3].OnClick(@CommonOnClick);
  WebBtnGlow[3].FCreate(WebBtn[3].Handle);
  WebBtnGlow[3].Enabled(False);
  WebBtnGlow[3].GlowColor($FF000000);
  WebBtnGlow[3].GlowAnimate(0.3, 0.2, 0);
  WebBtnGlow[3].Opacity(0.3);
  WebBtnGlow[3].Trigger('IsMouseOver=true');

  WebBtn[4].FCreate(WizardPage.Handle);
  WebBtn[4].SetBounds(1053, 64, 27, 27);
  WebBtn[4].LoadPicture(ExtractAndLoad('wbtn4.png'), iwStretch);
  WebBtn[4].OnClick(@CommonOnClick);
  WebBtnGlow[4].FCreate(WebBtn[4].Handle);
  WebBtnGlow[4].Enabled(False);
  WebBtnGlow[4].GlowColor($FF000000);
  WebBtnGlow[4].GlowAnimate(0.3, 0.2, 0);
  WebBtnGlow[4].Opacity(0.3);
  WebBtnGlow[4].Trigger('IsMouseOver=true');

  WebBtn[5].FCreate(WizardPage.Handle);
  WebBtn[5].SetBounds(375, 535, 294, 87);
  WebBtn[5].LoadPicture(ExtractAndLoad('wbtn5.png'), iwStretch);
  WebBtn[5].OnClick(@CommonOnClick);
  WebBtnGlow[5].FCreate(WebBtn[5].Handle);
  WebBtnGlow[5].Enabled(False);
  WebBtnGlow[5].GlowColor($FF00FFFF);
  WebBtnGlow[5].GlowAnimate(0.3, 0.2, 0);
  WebBtnGlow[5].Trigger('IsMouseOver=true');

  //{ Next Button }\\
  NextBtn.FCreate(WizardPage.Handle);
  NextBtn.SetBounds(827, 530, 339, 85);
  NextBtn.FillColor($FFF8003C);
  NextBtn.CornerStyle(20, 20, [tcBottomLeft], ctBevel);
  NextBtn.OnMouseEnter(@CommonEnter);
  NextBtn.OnMouseLeave(@CommonLeave);
  NextBtn.OnMouseDown(@CommonDown);
  NextBtn.OnMouseUp(@CommonUp);
  NextBtn.OnClick(@CommonOnClick);
  NextBtnLbl[1].FCreate(NextBtn.Handle, AnsiUppercase(CustomMessage('NextBtnLbl1')));
  NextBtnLbl[1].Align(Contents);
  NextBtnLbl[1].AutoSize(True);
  NextBtnLbl[1].TextSetting(False, txCenter, txCenter);
  NextBtnLbl[1].FontSetting('{#Font}', VCLFontSizeToFMX2(21), $FFFFFFFF);
  NextBtnLbl[1].FontStyle([fsBold]);
  NextBtnLbl[2].FCreate(WizardPage.Handle, AnsiUppercase('R25'));
  NextBtnLbl[2].Text(AnsiUppercase('R25'));
  NextBtnLbl[2].AutoSize(True);
  NextBtnLbl[2].TextSetting(False, txLeading, txLeading);
  NextBtnLbl[2].FontSetting('{#Font}', VCLFontSizeToFMX2(8), $FFF8003C);
  NextBtnLbl[2].Position(1130, 614);

  AdvertisingImg.FCreate(WizardPage.Handle);
  AdvertisingImg.SetBounds(804, 625, 392, 22);
  AdvertisingImg.LoadPicture(ExtractAndLoad('adv.png'), iwStretch);

  AdvertisingLbl[1].FCreate(WizardPage.Handle);
  AdvertisingLbl[1].Text(AnsiUppercase(CustomMessage('AdvertisingLbl1')));
  AdvertisingLbl[1].TextSetting(False, txCenter, txLeading);
  AdvertisingLbl[1].FontSetting('{#Font}', VCLFontSizeToFMX(11.6), $FF000000);
  AdvertisingLbl[1].SetBounds(815, 655, 365, 35);

  AdvertisingLbl[2].FCreate(WizardPage.Handle);
  AdvertisingLbl[2].Text(CustomMessage('AdvertisingLbl2'));
  AdvertisingLbl[2].TextSetting(False, txCenter, txLeading);
  AdvertisingLbl[2].FontSetting('{#Font}', VCLFontSizeToFMX(9), $FF000000);
  AdvertisingLbl[2].SetBounds(815, 695, 365, 29);

  //{ Back Button }\\
  BackBtn.FCreate(WizardPage.Handle);
  BackBtn.SetBounds(195, 744, 155, 50);
  BackBtn.FillColor($00000000);
  BackBtn.StrokeColor($FFDCDCDC);
  BackBtn.StrokeSetting(2, scFlat, sdSolid, sjBevel);
  BackBtn.CornerStyle(20, 20, [tcBottomLeft], ctBevel);
  BackBtn.OnMouseLeave(@CommonLeave);
  BackBtn.OnMouseDown(@CommonDown);
  BackBtn.OnMouseUp(@CommonUp);
  BackBtn.OnClick(@CommonOnClick);
  BackBtnLbl[1].FCreate(BackBtn.Handle, AnsiUppercase(CustomMessage('BackBtnLbl1')));
  BackBtnLbl[1].Align(Contents);
  BackBtnLbl[1].AutoSize(True);
  BackBtnLbl[1].TextSetting(False, txCenter, txCenter);
  BackBtnLbl[1].FontSetting('{#Font}', VCLFontSizeToFMX2(10.5), $FFDCDCDC);
  BackBtnLbl[1].FontStyle([fsBold]);
  BackBtnLbl[2].FCreate(WizardPage.Handle, AnsiUppercase('R22'));
  BackBtnLbl[2].AutoSize(True);
  BackBtnLbl[2].TextSetting(False, txLeading, txLeading);
  BackBtnLbl[2].FontSetting('{#Font}', VCLFontSizeToFMX2(6), $FFDCDCDC);
  BackBtnLbl[2].Position(318, 793);

  //{ About Button }\\
  AboutBtn.FCreate(WizardPage.Handle);
  AboutBtn.SetBounds(350, 744, 155, 50);
  AboutBtn.FillColor($00000000);
  AboutBtn.StrokeColor($FFDCDCDC);
  AboutBtn.StrokeSetting(2, scFlat, sdSolid, sjBevel);
  AboutBtn.OnMouseLeave(@CommonLeave);
  AboutBtn.OnMouseDown(@CommonDown);
  AboutBtn.OnMouseUp(@CommonUp);
  AboutBtn.OnClick(@CommonOnClick);
  AboutBtnLbl[1].FCreate(AboutBtn.Handle, AnsiUppercase(CustomMessage('AboutBtnLbl1')));
  AboutBtnLbl[1].Align(Contents)
  AboutBtnLbl[1].AutoSize(True);
  AboutBtnLbl[1].TextSetting(False, txCenter, txCenter);
  AboutBtnLbl[1].FontSetting('{#Font}', VCLFontSizeToFMX2(10.5), $FFDCDCDC);
  AboutBtnLbl[1].FontStyle([fsBold]);
  AboutBtnLbl[2].FCreate(WizardPage.Handle, AnsiUppercase('R23'));
  AboutBtnLbl[2].AutoSize(True);
  AboutBtnLbl[2].TextSetting(False, txLeading, txLeading);
  AboutBtnLbl[2].FontSetting('{#Font}', VCLFontSizeToFMX2(6), $FFDCDCDC);
  AboutBtnLbl[2].Position(475, 793);

  //{ Check Button }\\
  CheckBtn.FCreate(WizardPage.Handle);
  CheckBtn.SetBounds(505, 744, 155, 50);
  CheckBtn.FillColor($00000000);
  CheckBtn.StrokeColor($FFDCDCDC);
  CheckBtn.StrokeSetting(2, scFlat, sdSolid, sjBevel);
  CheckBtn.CornerStyle(20, 20, [tcTopRight], ctBevel);
  CheckBtn.OnMouseLeave(@CommonLeave);
  CheckBtn.OnMouseDown(@CommonDown);
  CheckBtn.OnMouseUp(@CommonUp);
  CheckBtn.OnClick(@CommonOnClick);
  CheckBtnLbl[1].FCreate(CheckBtn.Handle, AnsiUppercase(CustomMessage('CheckBtnLbl1')));
  CheckBtnLbl[1].Align(Contents)
  CheckBtnLbl[1].AutoSize(True);
  CheckBtnLbl[1].TextSetting(False, txCenter, txCenter);
  CheckBtnLbl[1].FontSetting('{#Font}', VCLFontSizeToFMX2(10.5), $FFDCDCDC);
  CheckBtnLbl[1].FontStyle([fsBold]);
  CheckBtnLbl[2].FCreate(WizardPage.Handle, AnsiUppercase('R24'));
  CheckBtnLbl[2].AutoSize(True);
  CheckBtnLbl[2].TextSetting(False, txLeading, txLeading);
  CheckBtnLbl[2].FontSetting('{#Font}', VCLFontSizeToFMX2(6), $FFDCDCDC);
  CheckBtnLbl[2].Position(630, 793);

  WrnLbl.FCreate(WizardPage.Handle, 661, 770, 500, 20, CustomMessage('WrnLbl'), 100, False);
  WrnLbl.TextSetting('{#Font}', VCLFontSizeToFMX2(9.5), $FFF8003C);
  WrnLbl.ShadowSetting($FFFFFF00, 0.5, 0.3);

  //{ Page1 }\\
  Page1.FCreate(WizardPage.Handle);
	Page1.AnimDuration(0.3);
	Page1.AnimPropertyName('Opacity');
	Page1.AnimSetValues(0, 1);
	Page1.Visible(False);

	//{ Slideshow }\\
  SlideshowLayer.FCreate(Page1.Handle);
  SlideshowLayer.FillPicture(ExtractAndLoad('1.jpg'), iwStretch);
  SlideshowLayer.SetBounds(735, 164, 507, 287);
  SlideshowLayer.RotationAngle(- 2.3);

	Slideshow.FCreate(SlideshowLayer.Handle, 7, 1, 1);
  for i:= 1 to {#Slide} do
    Slideshow.AddImage(ExtractAndLoad(IntToStr(i) + '.jpg'));
  Slideshow.Play;

  SlideshowFrame.FCreate(Page1.Handle);
  SlideshowFrame.SetBounds(713, 141, 551, 335);
  SlideshowFrame.LoadPicture(ExtractAndLoad('vfrm.png'), iwStretch);

  Page1Lbl.FCreate(Page1.Handle);
  Page1Lbl.Text(AnsiUppercase(CustomMessage('Page1Lbl')));
  Page1Lbl.TextSetting(False, txCenter, txLeading);
  Page1Lbl.FontSetting('{#Font}', VCLFontSizeToFMX(20), $FF000000);
  Page1Lbl.SetBounds(760, 481, 482, 30);

    //{ Page2 }\\
  Page2.FCreate(WizardPage.Handle);
	Page2.AnimDuration(0.3);
	Page2.AnimPropertyName('Opacity');
	Page2.AnimSetValues(0, 1);
	Page2.Visible(False);
	
	Page2Lbl[1].FCreate(Page2.Handle);
  Page2Lbl[1].Text(AnsiUppercase(CustomMessage('Page2Lbl1')));
  Page2Lbl[1].AutoSize(True);
  Page2Lbl[1].TextSetting(False, txLeading, txLeading);
  Page2Lbl[1].FontSetting('{#Font}', VCLFontSizeToFMX(25), $FF000000);
  Page2Lbl[1].Position(725, 245);

  Page2Edit.FCreate(Page2.Handle);
  Page2Edit.SetBounds(729, 345, 450, 34);
  Page2Edit.FontSetting('{#Font}', VCLFontSizeToFMX2(15), $FF000000);
  Page2Edit.ReadOnly(False);
  Page2Edit.TextPrompt(CustomMessage('Page2Edit'));

  Page2EditLine.FCreate(Page2.Handle);
  Page2EditLine.SetBounds(725, 377, 455, 2);
  Page2EditLine.FillColor($FF00FFFF);

  //{ BrowseForm }\\
  DirBrowseForm.FCreateBlankForm($FF00FFD2, CustomMessage('BrowseForm'), WizardForm.DirEdit.Text, '');
  DirBrowseForm.TextFontSettings('{#Font}', 17, $FF2B2B29);
  DirBrowseForm.DrawFrame(1, $FF2B2B29);
  DirBrowseForm.ButtonColors(1, $FFFBF103, $FF2B2B29);
  DirBrowseForm.ButtonColors(2, $FFFBF103, $FF2B2B29);
  DirBrowseForm.ButtonColors(3, $FFFBF103, $FF2B2B29);
  DirBrowseForm.ButtonFontSetttings(1, '{#Font}', 17, $FF2B2B29);
  DirBrowseForm.ButtonFontSetttings(2, '{#Font}', 17, $FF2B2B29);
  DirBrowseForm.ButtonFontSetttings(3, '{#Font}', 17, $FF2B2B29);
  DirBrowseForm.ButtonCornerCurve(1, 0);
  DirBrowseForm.ButtonCornerCurve(2, 0);
  DirBrowseForm.ButtonCornerCurve(3, 0);
  DirBrowseForm.ChangeBtnTitle(CustomMessage('BrowseFormNF'), CustomMessage('BrowseFormOK'), CustomMessage('BrowseFormCANCEL'));
  DirBrowseForm.SetFrameSharpCorners(True);
  DirBrowseForm.SetFrameBoundsAdjusment(0, 0, 0, 0);
  SetWin11FormCorners(DirBrowseForm.HandleHWND, ctw11Sharp);

  //{ Browse Button }\\
  BrowseBtn.FCreate(Page2.Handle);
  BrowseBtn.SetBounds(1200, 345, 185, 55);
  BrowseBtn.FillColor($00000000);
  BrowseBtn.StrokeColor($FF000000);
  BrowseBtn.StrokeSetting(2, scFlat, sdSolid, sjBevel);
  BrowseBtn.CornerStyle(20, 20, [tcBottomLeft, tcTopRight], ctBevel);
  BrowseBtn.OnMouseLeave(@CommonLeave);
  BrowseBtn.OnMouseDown(@CommonDown);
  BrowseBtn.OnMouseUp(@CommonUp);
  BrowseBtn.OnClick(@CommonOnClick);
  BrowseBtnLbl[1].FCreate(BrowseBtn.Handle, AnsiUppercase(CustomMessage('BrowseBtnLbl1')));
  BrowseBtnLbl[1].Align(Contents)
  BrowseBtnLbl[1].AutoSize(True);
  BrowseBtnLbl[1].TextSetting(False, txCenter, txCenter);
  BrowseBtnLbl[1].FontSetting('{#Font}', VCLFontSizeToFMX2(14.5), $FF000000);
  BrowseBtnLbl[1].FontStyle([fsBold]);
  BrowseBtnLbl[2].FCreate(Page2.Handle, AnsiUppercase('R26'));
  BrowseBtnLbl[2].Text(AnsiUppercase('R26'));
  BrowseBtnLbl[2].AutoSize(True);
  BrowseBtnLbl[2].TextSetting(False, txLeading, txLeading);
  BrowseBtnLbl[2].FontSetting('{#Font}', VCLFontSizeToFMX2(6), $FF000000);
  BrowseBtnLbl[2].Position(1358, 400);

  //{ Shortcut }\\
  ShortcutSwitch.FCreate(Page2.Handle, 725, 399, 20, 20, $FF00FFFF, '', False);
  ShortcutSwitch.SetChecked(False);
  ShortcutSwitch.SetDisabledColorIn($FFFCF405);
  ShortcutSwitch.SetDisabledColorOut($FF00FFFF);

  Page2Lbl[2].FCreate(Page2.Handle);
  Page2Lbl[2].Text(CustomMessage('Page2Lbl2'));
  Page2Lbl[2].AutoSize(True);
  Page2Lbl[2].TextSetting(False, txLeading, txLeading);
  Page2Lbl[2].FontSetting('{#Font}', VCLFontSizeToFMX(10.8), $FF000000);
  Page2Lbl[2].Position(755, 399);

  //{ Page 3 }\\
  Page3.FCreate(WizardPage.Handle);
	Page3.AnimDuration(0.3);
	Page3.AnimPropertyName('Opacity');
	Page3.AnimSetValues(0, 1);
	Page3.Visible(False);
	
	Page3Lbl[1].FCreate(Page3.Handle);
  Page3Lbl[1].Text(AnsiUppercase(CustomMessage('Page3Lbl1')));
  Page3Lbl[1].AutoSize(True);
  Page3Lbl[1].TextSetting(False, txLeading, txLeading);
  Page3Lbl[1].FontSetting('{#Font}', VCLFontSizeToFMX(25), $FF000000);
  Page3Lbl[1].Position(725, 245);

  Page3Lbl[2].FCreate(Page3.Handle);
  Page3Lbl[2].Text(CustomMessage('Page3Lbl2'));
  Page3Lbl[2].AutoSize(True);
  Page3Lbl[2].TextSetting(False, txLeading, txLeading);
  Page3Lbl[2].FontSetting('{#Font}', VCLFontSizeToFMX(12), $FF000000);
  Page3Lbl[2].Position(755, 327);

#ifdef Redist1
  RedistSwitch[1].FCreate(Page3.Handle, 725, 380, 20, 20, $FF00FFFF, '', False);
  RedistSwitch[1].SetChecked(False);
  RedistSwitch[1].SetDisabledColorIn($FFFCF405);
  RedistSwitch[1].SetDisabledColorOut($FF00FFFF);

  Page3Lbl[3].FCreate(Page3.Handle);
  Page3Lbl[3].Text(CustomMessage('Page3Lbl3'));
  Page3Lbl[3].AutoSize(True);
  Page3Lbl[3].TextSetting(False, txLeading, txLeading);
  Page3Lbl[3].FontSetting('{#Font}', VCLFontSizeToFMX(10.8), $FF000000);
  Page3Lbl[3].Position(755, 380);
#endif
#ifdef Redist2
  RedistSwitch[2].FCreate(Page3.Handle, 725, 420, 20, 20, $FF00FFFF, '', False);
  RedistSwitch[2].SetChecked(False);
  RedistSwitch[2].SetDisabledColorIn($FFFCF405);
  RedistSwitch[2].SetDisabledColorOut($FF00FFFF);

  Page3Lbl[4].FCreate(Page3.Handle);
  Page3Lbl[4].Text(CustomMessage('Page3Lbl4'));
  Page3Lbl[4].AutoSize(True);
  Page3Lbl[4].TextSetting(False, txLeading, txLeading);
  Page3Lbl[4].FontSetting('{#Font}', VCLFontSizeToFMX(10.8), $FF000000);
  Page3Lbl[4].Position(755, 420);
#endif
#ifdef Redist3
  RedistSwitch[3].FCreate(Page3.Handle, 725, 459, 20, 20, $FF00FFFF, '', False);
  RedistSwitch[3].SetChecked(False);
  RedistSwitch[3].SetDisabledColorIn($FFFCF405);
  RedistSwitch[3].SetDisabledColorOut($FF00FFFF);

  Page3Lbl[5].FCreate(Page3.Handle);
  Page3Lbl[5].Text(CustomMessage('Page3Lbl5'));
  Page3Lbl[5].AutoSize(True);
  Page3Lbl[5].TextSetting(False, txLeading, txLeading);
  Page3Lbl[5].FontSetting('{#Font}', VCLFontSizeToFMX(10.8), $FF000000);
  Page3Lbl[5].Position(755, 459);
#endif

  //{ Page 4 }\\
  Page4.FCreate(WizardPage.Handle);
	Page4.AnimDuration(0.3);
	Page4.AnimPropertyName('Opacity');
	Page4.AnimSetValues(0, 1);
	Page4.Visible(False);
	
	Page4Lbl[1].FCreate(Page4.Handle);
  Page4Lbl[1].Text(AnsiUppercase(CustomMessage('Page4Lbl1')));
  Page4Lbl[1].AutoSize(True);
  Page4Lbl[1].TextSetting(False, txLeading, txLeading);
  Page4Lbl[1].FontSetting('{#Font}', VCLFontSizeToFMX(25), $FF000000);
  Page4Lbl[1].Position(725, 245);

  Page4Lbl[2].FCreate(Page4.Handle);
  Page4Lbl[2].Text(CustomMessage('Page4Lbl2'));
  Page4Lbl[2].AutoSize(True);
  Page4Lbl[2].TextSetting(False, txLeading, txLeading);
  Page4Lbl[2].FontSetting('{#Font}', VCLFontSizeToFMX(12), $FF000000);
  Page4Lbl[2].Position(755, 289);

  //{ Progress Bar }\\
  Page4ProgressBar.FCreate(Page4.Handle, 729, 347, 540, 23, $FF00FFFF, $00000000, False);
  Page4ProgressBar.FillGradient($FF00FFFF, $FFF8003C, gsLinear);
  Page4ProgressBar.FillGradientLinearAngle(- 45);
  Page4ProgressBar.FillGradientAnimSetting(atOut, 1.8, 0, False, True, True);
  Page4ProgressBar.FillGradientAnimInterpolationType(itLinear);
  Page4ProgressBar.FillGradientAnimColors($FF00FFFF, $FFF8003C, $FFF8003C, $FF00FFFF);
  Page4ProgressBar.FillGradientAnimEnable(True);

  Page4ProgressBarLine.FCreate(Page4.Handle);
  Page4ProgressBarLine.SetBounds(725, 377, 549, 2);
  Page4ProgressBarLine.FillColor($FF00FFFF);

  Page4Lbl[3].FCreate(Page4.Handle);
  Page4Lbl[3].Text('R');
  Page4Lbl[3].AutoSize(True);
  Page4Lbl[3].TextSetting(False, txLeading, txLeading);
  Page4Lbl[3].FontSetting('{#Font}', VCLFontSizeToFMX(6.5), $FFF8003C);
  Page4Lbl[3].Position(1250, 367);

  //{ Page 5 }\\
  Page5.FCreate(WizardPage.Handle);
 	Page5.AnimDuration(0.3);
	Page5.AnimPropertyName('Opacity');
	Page5.AnimSetValues(0, 1);
	Page5.Visible(False);
	
	Page5Lbl[1].FCreate(Page5.Handle);
  Page5Lbl[1].Text(AnsiUppercase(CustomMessage('Page5Lbl1')));
  Page5Lbl[1].AutoSize(True);
  Page5Lbl[1].TextSetting(False, txLeading, txLeading);
  Page5Lbl[1].FontSetting('{#Font}', VCLFontSizeToFMX(25), $FF000000);
  Page5Lbl[1].Position(725, 245);

  Page5Lbl[2].FCreate(Page5.Handle);
  Page5Lbl[2].Text(CustomMessage('Page5Lbl2'));
  Page5Lbl[2].AutoSize(True);
  Page5Lbl[2].TextSetting(False, txLeading, txLeading);
  Page5Lbl[2].FontSetting('{#Font}', VCLFontSizeToFMX(12), $FF000000);
  Page5Lbl[2].Position(755, 325);

  //{ Exit Form }\\
  ExitForm.FCreate(FMXForm.Handle, 190, $FFDC143C, '', '', CustomMessage('ExitForm1'), CustomMessage('ExitForm2'), True, True, False);

  ExitForm.DrawFrame($FF00FFFF, 3.5);
  ExitForm.Opacity(0.99);
  ExitForm.BackgroundOpacity(0.2);
  ExitForm.CornerCurve(35);
  ExitForm.Corners([tcBottomLeft, tcTopRight]);
  ExitForm.CornerType(ctBevel);
  ExitForm.Msg1TextSetting('{#Font}', VCLFontSizeToFMX2(21), $FFFFFFFF, txLeading, txLeading, False);
  ExitForm.Msg1ShadowSetting(0, 0, 0);
  ExitForm.Msg2Height(60);
	ExitForm.Msg2TextSetting('{#Font}', VCLFontSizeToFMX2(12.5), $FFFFFFFF, txLeading, txLeading, False);
  ExitForm.Msg2ShadowSetting(0, 0, 0);
  ExitForm.PositionOffset(13);

  ExitForm.YesBtnVisible(False);
  ExitForm.NoBtnVisible(False);

  //{ Exit Yes Button }\\
  ExitYesBtn.FCreate(ExitForm.Handle);
  ExitYesBtn.SetBounds(1020, 124, 155, 50);
  ExitYesBtn.FillColor($00000000);
  ExitYesBtn.StrokeColor($FFDCDCDC);
  ExitYesBtn.StrokeSetting(2, scFlat, sdSolid, sjBevel);
  ExitYesBtn.CornerStyle(20, 20, [tcBottomLeft], ctBevel);
  ExitYesBtn.OnMouseLeave(@CommonLeave);
  ExitYesBtn.OnMouseDown(@CommonDown);
  ExitYesBtn.OnMouseUp(@CommonUp);
  ExitYesBtn.OnClick(@CommonOnClick);
  ExitYesBtnLbl[1].FCreate(ExitYesBtn.Handle, AnsiUppercase(CustomMessage('ExitYesBtnLbl')));
  ExitYesBtnLbl[1].Align(Contents);
  ExitYesBtnLbl[1].AutoSize(True);
  ExitYesBtnLbl[1].TextSetting(False, txCenter, txCenter);
  ExitYesBtnLbl[1].FontSetting('{#Font}', VCLFontSizeToFMX2(10.5), $FFDCDCDC);
  ExitYesBtnLbl[1].FontStyle([fsBold]);
  ExitYesBtnLbl[2].FCreate(ExitForm.Handle, 'R21');
  ExitYesBtnLbl[2].AutoSize(True);
  ExitYesBtnLbl[2].TextSetting(False, txLeading, txLeading);
  ExitYesBtnLbl[2].FontSetting('{#Font}', VCLFontSizeToFMX2(6), $FFDCDCDC);
  ExitYesBtnLbl[2].SetBounds(1149, 173, 0, 0);

  //{ Exit No Button }\\
  ExitNoBtn.FCreate(ExitForm.Handle);
  ExitNoBtn.SetBounds(1171, 124, 155, 50);
  ExitNoBtn.FillColor($00000000);
  ExitNoBtn.StrokeColor($FFDCDCDC);
  ExitNoBtn.StrokeSetting(2, scFlat, sdSolid, sjBevel);
  ExitNoBtn.CornerStyle(20, 20, [tcTopRight], ctBevel);
  ExitNoBtn.OnMouseLeave(@CommonLeave);
  ExitNoBtn.OnMouseDown(@CommonDown);
  ExitNoBtn.OnMouseUp(@CommonUp);
  ExitNoBtn.OnClick(@CommonOnClick);
  ExitNoBtnLbl[1].FCreate(ExitNoBtn.Handle, AnsiUppercase(CustomMessage('ExitNoBtnLbl')));
  ExitNoBtnLbl[1].Align(Contents);
  ExitNoBtnLbl[1].AutoSize(True);
  ExitNoBtnLbl[1].TextSetting(False, txCenter, txCenter);
  ExitNoBtnLbl[1].FontSetting('{#Font}', VCLFontSizeToFMX2(10.5), $FFDCDCDC);
  ExitNoBtnLbl[1].FontStyle([fsBold]);
  ExitNoBtnLbl[2].FCreate(ExitForm.Handle, 'R22');
  ExitNoBtnLbl[2].AutoSize(True);
  ExitNoBtnLbl[2].TextSetting(False, txLeading, txLeading);
  ExitNoBtnLbl[2].FontSetting('{#Font}', VCLFontSizeToFMX2(6), $FFDCDCDC);
  ExitNoBtnLbl[2].Position(1298, 173);
end;

procedure InitializeWizard();
begin
  EmptyWizardForm(True, 1424, 806);
  Splash.FCreate(WizardForm.Handle, ExtractAndLoad('splash1.png'), ExtractAndLoad('splash1.wav'), 700);
  Splash.Play;

  FMXDesigning;
  FMXForm.Show;

  MusicPlayer.FCreate(WizardForm.Handle, ExtractAndLoad('music1.mp3'), 1, True, nil);
  MusicPlayer.Play;

	pTaskbarPreviewEx(FMXForm.HandleHWND, True);
end;

procedure HideComponents;
begin

#ifdef Redist1
  if not FileExists(ExpandConstant('{src}\{#Redist1Path}')) then
  begin
    RedistSwitch[1].SetChecked(False);
    RedistSwitch[1].Enable(False);
    Page3Lbl[3].Enabled(False);
  end;
#endif
#ifdef Redist2
  if not FileExists(ExpandConstant('{src}\{#Redist2Path}')) then
  begin
    RedistSwitch[2].SetChecked(False);
    RedistSwitch[2].Enable(False);
    Page3Lbl[4].Enabled(False);
  end;
#endif
#ifdef Redist3
  if not FileExists(ExpandConstant('{src}\{#Redist3Path}')) then
  begin
    RedistSwitch[3].SetChecked(False);
    RedistSwitch[3].Enable(False);
    Page3Lbl[5].Enabled(False);
  end;
#endif

  Page1.Visible(False);
  Page2.Visible(False);
  Page3.Visible(False);
  Page4.Visible(False);
  Page5.Visible(False);
end;

procedure ShowComponents(CurPageID: Integer);
begin
  NextBtn.Enabled(True);
	NextBtnLbl[1].Text(AnsiUppercase(CustomMessage('NextBtnLbl1')));
  BackBtn.Enabled(False);

  case CurPageID of

    wpWelcome:
    begin
			Page1.Visible(True);
		  Page1.AnimEnable(True);
		end;

    wpSelectDir:
    begin
      Page2.Visible(True);
      Page2.AnimEnable(True);
			DirUpdateProc;
      BackBtn.Enabled(True);
		end;

    wpSelectComponents:
    begin
      Page3.Visible(True);
      Page3.AnimEnable(True);
			NextBtnLbl[1].Text(AnsiUppercase(CustomMessage('NextBtnLbl2')));
      BackBtn.Enabled(True);
		end;

    wpInstalling:
    begin
      Page4.Visible(True);
      Page4.AnimEnable(True);
			NextBtnLbl[1].Text(AnsiUppercase(CustomMessage('NextBtnLbl3')));
      Slideshow.Pause;
		end;

    wpFinished:
    begin
      Page5.Visible(True);
      Page5.AnimEnable(True);
			NextBtnLbl[1].Text(AnsiUppercase(CustomMessage('NextBtnLbl4')));
      if ISArcExError then
      begin
        Page5Lbl[1].Text(AnsiUppercase(CustomMessage('Page5Lbl1ERR')));
        Page5Lbl[2].Text(CustomMessage('Page5Lbl2ERR'));
      end;
		end;

  end;
end;

procedure CurPageChanged(CurPageID: Integer);
begin
  HideComponents;
  ShowComponents(CurPageID);
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  i, ErrCode: integer;
begin
  if CurStep = ssInstall then
  begin
    ISArcExCancel:= 0;
    ISArcExDiskCount:= 0;
    ISArcDiskAddingSuccess:= False;
    ISArcExError:= True;
    if ActiveLanguage = 'russian' then
      ExtractTemporaryFile('russian.ini')
    else
      ExtractTemporaryFile('english.ini');
    ExtractTemporaryFile('unarc.dll');
    ExtractTemporaryFile('arc.ini');
    ExtractTemporaryFile('cls.ini');
    ExtractTemporaryFile('facompress.dll');
  #ifdef srep
    ExtractTemporaryFile('cls-srep.dll');
    ExtractTemporaryFile('cls-srep_x64.exe');
  #endif

    repeat

    #ifdef Data1
      if FileExists(ExpandConstant('{src}\{#data1}')) then
      begin
        ISArcDiskAddingSuccess:= ISArcExAddDisks(ExpandConstant('{src}\{#data1}'), '{#DiskPassword}', ExpandConstant('{app}'));
        if not ISArcDiskAddingSuccess then
          break;
          ISArcExDiskCount:= ISArcExDiskCount + 1;
      end;
    #endif
    #ifdef Data2
      if FileExists(ExpandConstant('{src}\{#data2}')) then
      begin
        ISArcDiskAddingSuccess:= ISArcExAddDisks(ExpandConstant('{src}\{#data2}'), '{#DiskPassword}', ExpandConstant('{app}'));
        if not ISArcDiskAddingSuccess then
          break;
          ISArcExDiskCount:= ISArcExDiskCount + 1;
      end;
    #endif
    #ifdef Data3
      if FileExists(ExpandConstant('{src}\{#data3}')) then
      begin
        ISArcDiskAddingSuccess:= ISArcExAddDisks(ExpandConstant('{src}\{#data3}'), '{#DiskPassword}', ExpandConstant('{app}'));
        if not ISArcDiskAddingSuccess then
          break;
          ISArcExDiskCount:= ISArcExDiskCount + 1;
      end;
    #endif
    #ifdef Data4
      if FileExists(ExpandConstant('{src}\{#data4}')) then
      begin
        ISArcDiskAddingSuccess:= ISArcExAddDisks(ExpandConstant('{src}\{#data4}'), '{#DiskPassword}', ExpandConstant('{app}'));
        if not ISArcDiskAddingSuccess then
          break;
          ISArcExDiskCount:= ISArcExDiskCount + 1;
      end;
    #endif
    #ifdef Data5
      if FileExists(ExpandConstant('{src}\{#data5}')) then
      begin
        ISArcDiskAddingSuccess:= ISArcExAddDisks(ExpandConstant('{src}\{#data5}'), '{#DiskPassword}', ExpandConstant('{app}'));
        if not ISArcDiskAddingSuccess then
          break;
          ISArcExDiskCount:= ISArcExDiskCount + 1;
      end;
    #endif

    until true;

    if ISArcExDiskCount = 0 then
      WrnLbl.SetText(CustomMessage('WrnLblERR1'));
    if (ISArcDiskAddingSuccess) and ISArcExInitEx(MainForm.Handle, 3, @ProgressCallbackEx) then
    begin
      repeat
        ISArcExReduceCalcAccuracy({#CalcAccuracy});
        ISArcExChangeLanguage(ActiveLanguage);
        for i:= 1 to ISArcExDiskCount do
        begin
          ISArcExError:= not ISArcExExtract(i, ExpandConstant('{tmp}\arc.ini'), ExpandConstant('{app}'));
          if ISArcExError then
            break;
        end;
      until true;

      ISArcExStop;

      if ISArcExError then
        WrnLbl.SetText(CustomMessage('WrnLblERR2'));
    end;
  end;
  if (CurStep = ssPostInstall) and ISArcExError then
  begin
    Exec2(ExpandConstant('{uninstallexe}'), '/VERYSILENT', false);
    DelTree(ExpandConstant('{app}'), True, True, True);
    RemoveDir(ExpandConstant('{app}'));
  end else
  if (CurStep = ssPostInstall) and (not ISArcExError) then
  begin
  #ifdef Redist1
    if RedistSwitch[1].ISChecked then
    begin
      Exec(ExpandConstant('{src}\{#Redist1Path}'), '{#Redist1Key}', '', SW_HIDE, ewWaitUntilTerminated, ErrCode);
    end;
  #endif
  #ifdef Redist2
    if RedistSwitch[2].ISChecked then
    begin
      Exec(ExpandConstant('{src}\{#Redist2Path}'), '{#Redist2Key}', '', SW_HIDE, ewWaitUntilTerminated, ErrCode);
    end;
  #endif
  #ifdef Redist3
    if RedistSwitch[3].ISChecked then
    begin
      Exec(ExpandConstant('{src}\{#Redist3Path}'), '{#Redist3Key}', '', SW_HIDE, ewWaitUntilTerminated, ErrCode);
    end;
  #endif
  end;
end;

procedure DeinitializeSetup();
begin
  RemoveFontResource2(ExpandConstant('{tmp}\BlenderPro-Medium.ttf'));
  FMXInnoShutDown;
end;

procedure InitializeUninstallProgressForm;
begin
  with UninstallProgressForm do
  begin
    ClientWidth := ScaleX(400);
    ClientHeight := ScaleY(150);
    InnerNotebook.Hide;
    OuterNotebook.Hide;
    CancelButton.Hide;
    Bevel.Hide;
    PageNameLabel.Hide;
    Position := poDesktopCenter;
    BorderStyle := bsNone;
    Color := $001E1715;
    ProgressBar.Parent := UninstallProgressForm;
    ProgressBar.Top := ScaleY(120);
    ProgressBar.Width := ScaleX(380);
    ProgressBar.Left := (ClientWidth - ProgressBar.Width) div 2;
    ProgressBar.Height := ScaleY(12);
  end;

  with TLabel.Create(nil) do
  begin
    Parent := UninstallProgressForm;
    AutoSize := True;
    Left := UninstallProgressForm.PageNameLabel.Left;
    Top := ScaleY(20);
    Caption := UninstallProgressForm.PageNameLabel.Caption;
    Font.Size := 13;
    Font.Name := 'Segoe UI';
    Font.Style := [fsBold];
    Font.Color := $00FFFFFE;
  end;

  with TLabel.Create(nil) do
  begin
    Parent := UninstallProgressForm;
    WordWrap := True;
    Left := UninstallProgressForm.PageDescriptionLabel.Left - ScaleX(2);
    Top := ScaleY(55);
    Width := UninstallProgressForm.ProgressBar.Width;
    Height := UninstallProgressForm.PageDescriptionLabel.Height  + ScaleY(45);
    Caption := UninstallProgressForm.PageDescriptionLabel.Caption;
    Font.Size := 11;
    Font.Name := 'Segoe UI';
    Font.Color := $00C0C0C0;
  end;
end;
