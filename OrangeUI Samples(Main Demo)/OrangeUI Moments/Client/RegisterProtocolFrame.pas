//convert pas to utf8 by ¥
unit RegisterProtocolFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 

  uFileCommon,
  uFuncCommon,
  uComponentType,


  uUIFunction,
  uTimerTask,
  XSuperObject,
  uBaseHttpControl,

  {$IFDEF ANDROID}
  FMX.WebBrowser.Android,
  {$ENDIF}

  uSkinFireMonkeyEdit,

  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, uSkinFireMonkeyMemo,
  uSkinFireMonkeyLabel, FMX.WebBrowser, uSkinButtonType, uSkinLabelType,
  uBaseSkinControl, uSkinPanelType;

type
  TFrameRegisterProtocol = class(TFrame)
    pnlBackground: TSkinFMXPanel;
    pnlClient: TSkinFMXPanel;
    pnlTop: TSkinFMXPanel;
    lblType: TSkinFMXLabel;
    pnlTopDevide: TSkinFMXPanel;
    btnClose: TSkinFMXButton;
    procedure btnCloseClick(Sender: TObject);
  private
    FWebBrowser: TWebBrowser;
    { Private declarations }
  public
    destructor Destroy;override;
  public
    procedure Load;
    { Public declarations }
  end;


var
  GlobalRegisterProtocolFrame:TFrameRegisterProtocol;

implementation

{$R *.fmx}

procedure TFrameRegisterProtocol.btnCloseClick(Sender: TObject);
begin
  RestoreGlobalEditListAsPlatformType;
  RestoreGlobalMemoListAsPlatformType;

  GlobalRegisterProtocolFrame.Visible:=False;
  uFuncCommon.FreeAndNil(GlobalRegisterProtocolFrame);
  GlobalRegisterProtocolFrame:=nil;
end;

destructor TFrameRegisterProtocol.Destroy;
begin
  uFuncCommon.FreeAndNil(FWebBrowser);

  inherited;
end;

procedure TFrameRegisterProtocol.Load;
var
  HtmlSource:TStringList;
  HtmlLocalFileCodePath:String;
begin
  SetGlobalEditListAsStyleType;
  SetGlobalMemoListAsStyleType;

  //把保存成html,然后用WebBrowser加载

//  {$IFDEF ANDROID}
//  FMX.WebBrowser.Android.WebBrowserSystemStatusBarHeight:=
//        uComponentType.SystemStatusBarHeight;
//  {$ENDIF}

  if FWebBrowser=nil then
  begin
    FWebBrowser:=TWebBrowser.Create(Self);
    FWebBrowser.Parent:=Self.pnlClient;
    FWebBrowser.Align:=TAlignLayout.{$IF CompilerVersion >= 35.0}Client{$ELSE}alClient{$IFEND};

    FWebBrowser.Visible:=True;
  end;

  HtmlSource:=TStringList.Create;

  HtmlSource.Add(''
    +#13#10+'<html>  '
    +#13#10+'<head>  '
    +#13#10+'<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />   '
    +#13#10+'<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" />'
    +#13#10+'</head> '
    +#13#10+'<body>  '

    +#13#10+'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;OrangeUI圈注册协议 <br>                                              '
    +#13#10+'本服务条款是您与软件的所有者王能所订立的合约或合同。 <br>  '
    +#13#10+'请您仔细阅读本条款，您勾选"已经阅读并同意《OrangeUI圈注册协议》"'
              +'并点击【立即注册】按钮注册成功后成为正式用户，'
              +'本服务条款即构成了对双方具有法律约束力的文件。 <br>       '
    +#13#10+'                                                                                                                                                                            '
    +#13#10+'一、定义 <br>                                                                                                                                                               '
    +#13#10+'OrangeUI圈是一个OUI用户分享控件使用心得，交流问题解决方案的APP。'
    +#13#10+'<br>                                                                                                                                                                                                            '
    +#13#10+' 二、协议的效力                                                                                                                                                                                                 '
    +#13#10+'<br>&nbsp;1、在您按照注册页面提示填写信息、'
            +'阅读并同意本协议并完成全部注册程序后，您即受本协议的约束。'
            +'在注册时，您应当按照法律法规要求，或注册页面的提示，'
            +'准确填写您提供的姓名、手机号码等，以便工作人员与您进行有效联系。'
            +'如您的资料发生变更，您应及时更新您的资料，以使之真实、及时，'
            +'完整和准确。'
    +#13#10+'<br>&nbsp;2、 对于您提供的资料及数据信息，'
            +'您授予王能永久的、免费的许可使用权利。您同意，'
            +'王能有权(全部或部分地) 使用、复制、更正、发布、翻译、分发、执行'
            +'和展示您的资料数据（包括但不限于注册资料、行为数据等各类信息）'
            +'或制作其派生作品，并以现在已知或日后开发的任何形式、媒体或技术，'
            +'将上述信息纳入其它作品内。 '
    +#13#10+'<br>                                                                                                                                                                         '
    +#13#10+'三、注册                                                                                                                                                                     '
    +#13#10+'<br>&nbsp;1、 您确认，在您完成注册程序时，'
            +'您应当是具备相应民事行为能力的自然人、法人或其他组织。'
            +'若您不具备前述主体资格，则您及您的监护人应承担因此而导致的一切后果，'
            +'且王能有权注销您的账户，并向您及您的监护人索偿。     '
    +#13#10+'<br>                                                                                               '
    +#13#10+' 四、OrangeUI圈服务使用规范                                                                    '
    +#13#10+'<br>&nbsp;1、 通过OrangeUI圈，您可以按照规则发布交流信息。'
                       +'但所发布之信息不得含有如下内容： '
        +#13#10+'<br>&nbsp;1)煽动抗拒、破坏宪法和法律、行政法规实施的；                                             '
        +#13#10+'<br>&nbsp;2)煽动颠覆国家政权，推翻社会主义制度的；                                                 '
        +#13#10+'<br>&nbsp;3)煽动分裂国家、破坏国家统一的；                                                         '
        +#13#10+'<br>&nbsp;4)煽动民族仇恨、民族歧视，破坏民族团结的；                                               '
        +#13#10+'<br>&nbsp;5)捏造或者歪曲事实，散布谣言，扰乱社会秩序的；                                           '
        +#13#10+'<br>&nbsp;6)宣扬封建迷信、淫秽、色情、赌博、暴力、凶杀、'
                            +'恐怖、教唆犯罪的；                         '
        +#13#10+'<br>&nbsp;7)公然侮辱他人或者捏造事实诽谤他人的，'
                            +'或者进行其他恶意攻击的；                           '
        +#13#10+'<br>&nbsp;8)损害国家机关信誉的；                                                                   '
        +#13#10+'<br>&nbsp;9)其他违反宪法和法律法规的；                                                             '
    +#13#10+'<br>&nbsp;2、在接受OrangeUI圈服务的过程中，您不得从事下列行为：                                '
        +#13#10+'<br>&nbsp;1）发表、传送、传播、储存侵害他人知识产权、'
                            +'商业秘密权等合法权利的内容，包含病毒、木马、'
                            +'定时炸弹等可能对同城互助系统造成伤害或影响其稳定性的内容'
                            +'制造虚假身份以误导、欺骗他人；'
        +#13#10+'<br>&nbsp;2）传送或散布以其他方式实现传送含有受到知识产权法律保护的图像、'
                            +'相片、软件或其他资料的文件，作为举例（但不限于此）：'
                            +'包括版权或商标法（或隐私权或公开权），'
                            +'除非用户拥有或控制着相应的权利或已得到所有必要的认可；       '
        +#13#10+'<br>&nbsp;3）使用任何包含有通过侵犯商标、版权、专利'
                            +'、商业机密或任何一方的其他专有权利的方式利用本“软件”'
                            +'获得的图像或相片的资料或信息；                                                                                    '
        +#13#10+'<br>&nbsp;4）进行危害计算机网络安全的行为，包括但不限于：'
                          +'使用未经许可的数据或进入未经许可的服务器/帐号；'
                          +'未经允许进入公众计算机网络或者他人计算机系统并删除、修改、增加存储信息；'
                          +'未经许可，企图探查、扫描、测试本平台系统或'
                          +'网络的弱点或其它实施破坏网络安全的行为；企图干涉、破坏本平台系统'
                          +'或网站的正常运行，故意传播恶意程序或病毒以及其他破坏干扰正常网络信息服务'
                          +'的行为；伪造TCP/IP数据包名称或部分名称；        '
        +#13#10+'<br>&nbsp;5）修改或伪造软件作品运行中的指令、数据、数据包，增加、删减、变动软件 '
                          +'的功能或运行效果，不得将用于上述用途的软件通过信息网络向公众传播或者运营；              '
        +#13#10+'<br>&nbsp;6） 违背OrangeUI圈公布之活动规则，包括但不限于发布虚假信息。                                                '
    +#13#10+'<br>&nbsp;3、您了解并同意，王能有权应政府部门（包括司法及行政部门）的要求，'
                          +'向其提供您在OrangeUI圈填写的注册信息和发布纪录等必要信息。               '
    +#13#10+'<br>&nbsp;4、在接受OrangeUI圈服务过程中，您承诺遵守以下约定：                                                                                         '
    +#13#10+'<br>&nbsp;在使用OrangeUI圈服务过程中实施的所有行为均遵守国家法律、'
                          +'法规等规范文件及OrangeUI圈各项规则的规定和要求，'
                          +'不违背社会公共利益或公共道德，不损害他人的合法权益，'
                          +'不违反本协议及相关规则。您如果违反前述承诺，产生任何法律后果的，'
                          +'您应以自己的名义独立承担所有的法律责任，'
                          +'并确保王能免于因此产生任何损失。'


    +#13#10+'</body> '
    +#13#10+'</html> ');



  //保存HTML文件
  HtmlLocalFileCodePath:=uFileCommon.GetApplicationPath+'RegisterProtocol_'+CreateGUIDString+'.htm';


  HtmlSource.SaveToFile(HtmlLocalFileCodePath,TEncoding.UTF8);

  //加载HTML文件
  Self.FWebBrowser.Navigate('file://'+HtmlLocalFileCodePath);

  uFuncCommon.FreeAndNil(HtmlSource);

end;

end.
