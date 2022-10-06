//convert pas to utf8 by ¥

unit ButtonFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, uSkinFireMonkeyPanel, uSkinFireMonkeyControl, uSkinFireMonkeyButton,
  System.Actions,
  FMX.ActnList,

  EasyServiceCommonMaterialDataMoudle,
//  FlyFilesUtils,
  uVersion,
  uLang,
  uFrameContext,
  uSkinImageList,
  uDrawPicture,
  uSkinMaterial,
  uSkinButtonType,
  uSkinFireMonkeyImage,
  FMX.Controls.Presentation, uBaseSkinControl, uSkinFireMonkeyScrollBoxContent,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyScrollBox,
  uSkinScrollBoxContentType, uSkinScrollControlType, uSkinScrollBoxType;




type
  TFrameButton = class(TFrame,IFrameChangeLanguageEvent)
    imglistNetworkState: TSkinImageList;
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    btnAll: TSkinFMXButton;
    btnConnectState: TSkinFMXButton;
    btnGroup: TSkinFMXButton;
    btnServerSetting: TSkinFMXButton;
    btnSortByDate: TSkinFMXButton;
    btnSortByName: TSkinFMXButton;
    btnSortBySize: TSkinFMXButton;
    btnTrackBar: TSkinFMXButton;
    btnOK: TSkinFMXButton;
    btnPictureLogin: TSkinFMXButton;
    btnFilterAlreadyCancel: TSkinFMXButton;
    btnOK1: TSkinFMXButton;
    btnMenu: TSkinFMXButton;
    btnFilterNo: TSkinFMXButton;
    btnFilterAlreadySend: TSkinFMXButton;
    btnFilterAlreadyRecv: TSkinFMXButton;
    btnHasDetail: TSkinFMXButton;
    btnSendGood: TSkinFMXButton;
    btnBuyGood: TSkinFMXButton;
    btnOneKMSendGood: TSkinFMXButton;
    btnPackageSend: TSkinFMXButton;
    btnSendCaptcha: TSkinFMXButton;
    btnColorLogin: TSkinFMXButton;
    SkinFMXButton4: TSkinFMXButton;
    SkinFMXButton5: TSkinFMXButton;
    lblButtonCanBeGrouped: TLabel;
    lblPictureButton: TLabel;
    lblColorButton: TLabel;
    lblHasTwoState: TLabel;
    lblButtonHasCaptionAndDetail: TLabel;
    lblButtonHasIcon: TLabel;
    SkinFMXButton1: TSkinFMXButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  private
    procedure ChangeLanguage(ALangKind:TLangKind);
  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

implementation

{$R *.fmx}

{ TFrameButton }

procedure TFrameButton.Button1Click(Sender: TObject);
begin

//  {$IFDEF MSWINDOWS}
//  Self.MakeScreenshot.SaveToFile('C:\aa.png');
//  {$ENDIF}
//
//  {$IFDEF ANDROID}
//  Self.MakeScreenshot.SaveToFile(GetSDCardPath+'aa.png');
//  {$ENDIF}
end;

procedure TFrameButton.ChangeLanguage(ALangKind: TLangKind);
begin
  //翻译
  Self.lblButtonCanBeGrouped.Text:=GetLangString('ButtonCanBeGrouped',ALangKind);
  Self.btnSortByName.Text:=GetLangString(Self.btnSortByName.Name,ALangKind);
  Self.btnSortByDate.Text:=GetLangString(Self.btnSortByDate.Name,ALangKind);
  Self.btnSortBySize.Text:=GetLangString(Self.btnSortBySize.Name,ALangKind);


  Self.btnGroup.Text:=GetLangString(Self.btnGroup.Name,ALangKind);
  Self.btnAll.Text:=GetLangString(Self.btnAll.Name,ALangKind);

  Self.lblPictureButton.Text:=GetLangString(Self.lblPictureButton.Name,ALangKind);
  Self.btnOK.Text:=GetLangString('OK',ALangKind);
  Self.btnOK1.Text:=GetLangString('OK',ALangKind);
  Self.btnPictureLogin.Text:=GetLangString('Login',ALangKind);

  Self.lblColorButton.Text:=GetLangString('ColorButton',ALangKind);
  Self.btnColorLogin.Text:=GetLangString('Login',ALangKind);
  Self.btnSendCaptcha.Text:=GetLangString('SendCaptcha',ALangKind);

  Self.lblHasTwoState.Text:=GetLangString('ButtonHasTwoStates',ALangKind);

  Self.lblButtonHasCaptionAndDetail.Text:=GetLangString('ButtonHasCaptionAndDetail',ALangKind);

  Self.lblButtonHasIcon.Text:=GetLangString('ButtonHasIcon',ALangKind);
  Self.btnConnectState.Text:=GetLangString('ConnectState',ALangKind);
  Self.btnServerSetting.Text:=GetLangString('ServerSetting',ALangKind);

end;

constructor TFrameButton.Create(AOwner: TComponent);
begin
  inherited;

  //初始多语言
  RegLangString('ButtonCanBeGrouped',[Self.lblButtonCanBeGrouped.Text,'Button can be grouped']);
  RegLangString(Self.btnSortByName.Name,[Self.btnSortByName.Text,'Name']);
  RegLangString(Self.btnSortByDate.Name,[Self.btnSortByDate.Text,'Date']);
  RegLangString(Self.btnSortBySize.Name,[Self.btnSortBySize.Text,'Size']);

  RegLangString(Self.btnGroup.Name,[Self.btnGroup.Text,'Group']);
  RegLangString(Self.btnAll.Name,[Self.btnAll.Text,'All']);


  RegLangString(Self.lblPictureButton.Name,[Self.lblPictureButton.Text,'Picture Button']);
  RegLangString('OK',['确定','Sure']);
  RegLangString('Login',['登录','Login']);


  RegLangString('ColorButton',[Self.lblColorButton.Text,'Color Button']);
  RegLangString('SendCaptcha',[Self.btnSendCaptcha.Caption,'Send captcha']);


  RegLangString('ButtonHasTwoStates',[Self.lblHasTwoState.Text,'Button has two states']);


  RegLangString('ButtonHasCaptionAndDetail',[Self.lblButtonHasCaptionAndDetail.Text,'Button has caption and detail']);


  RegLangString('ButtonHasIcon',[Self.lblButtonHasIcon.Text,'Button has icon']);
  RegLangString('ConnectState',[Self.btnConnectState.Text,'Connect server']);
  RegLangString('ServerSetting',[Self.btnServerSetting.Text,'Server setting']);


end;

end.
