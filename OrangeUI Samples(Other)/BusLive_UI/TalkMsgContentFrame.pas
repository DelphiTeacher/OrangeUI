//convert pas to utf8 by ¥
unit TalkMsgContentFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  uBaseList,
  BusLiveCommonSkinMaterialModule,


  uSkinMaterial,
  uDrawCanvas,
  uComponentType,
  uBufferBitmap,
  uDrawTextParam,
  uSkinButtonType,
  uSkinFireMonkeyLabel,
  uSkinFireMonkeyImage,
  uSkinFireMonkeyControl, uSkinFireMonkeyButton,
  uSkinFireMonkeyRoundImage, uSkinFireMonkeyPanel, uSkinImageType,
  uSkinRoundImageType, uSkinPanelType;

const
  Const_Default_HeaderSize=45;
  Const_Default_VertGap=4;
  Const_Default_HorzGap=8;
  Const_Default_ContentTopGap=12;

  Const_Default_ContentItem_VertGap=2;

type
  TMessageItem=class
  public
    //消息ID
    MsgId:string;
    //发送人
    Sender_UserId:Integer;
    //内容
    Content:String;
    //发送时间
    SendTime:TDateTime;
    //字体
    Font:String;
    SuperObjects:String;

    ContentItems:TStringList;
    SuperObjectCodes:TStringList;
    SuperObjectFiles:TStringList;

  public
    constructor Create;
    destructor Destroy;override;
    procedure ParseContent;
  end;




  TFrameTalkMsgContent = class(TFrame)
    pnlClient: TSkinFMXPanel;
    btnContent: TSkinFMXButton;
    imgHead: TSkinFMXRoundImage;
  private
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    FMessageItem:TMessageItem;
    FContentControlList:TBaseList;
    procedure LoadContactMessage(ASender_UserId: Integer;
                                  AMsgId: string;
                                  AContent:String;
                                  AFontString:String;
                                  ASuperObjects: string;
                                  ASendTime: TDateTime);

    { Public declarations }
  end;

implementation

{$R *.fmx}

{ TFrameFriendTalkMsg_Content_TextMsg }

constructor TFrameTalkMsgContent.Create(AOwner: TComponent);
begin
  inherited;
  FMessageItem:=TMessageItem.Create;
  FContentControlList:=TBaseList.Create;
end;

destructor TFrameTalkMsgContent.Destroy;
begin
  FreeAndNil(FContentControlList);
  FreeAndNil(FMessageItem);
  inherited;
end;

procedure TFrameTalkMsgContent.LoadContactMessage(
  ASender_UserId: Integer;
  AMsgId: string;
  AContent: string;
  AFontString: string;
  ASuperObjects: string;
  ASendTime: TDateTime);
var
  I:Integer;
  AContentSize:TSizeF;
  AObjectIndex:Integer;
var
  AContentLabel:TSkinFMXLabel;
  AContentImage:TSkinFMXImage;
  AContentSumHeight:Double;
  ASuiteMaxContentWidth:Double;
  AMaxContentWidth:Double;
begin
  FMessageItem.MsgId:=AMsgId;
  FMessageItem.Content:=AContent;
  FMessageItem.SuperObjects:=ASuperObjects;
  FMessageItem.Font:=AFontString;
  FMessageItem.Sendtime:=ASendTime;
  FMessageItem.Sender_UserId:=ASender_UserId;
  //分析出结构
  FMessageItem.ParseContent;


  //清空内容
  Self.btnContent.Caption:='';

  //头像的尺寸
  Self.imgHead.Top:=Const_Default_VertGap;
  Self.imgHead.Width:=Const_Default_HeaderSize;
  Self.imgHead.Height:=Const_Default_HeaderSize;



  //添加到界面上
  Self.btnContent.Top:=Const_Default_ContentTopGap;
  if FMessageItem.Sender_UserId=0 then
  begin
    //我发的消息
    Self.imgHead.Left:=Width-imgHead.Width-Const_Default_HorzGap;
    Self.btnContent.RefMaterial:=BusLiveDataModuleCommonSkinMaterial.bdmTalkMsg_Content_MyTextMsg;
  end
  else
  begin
    //别人发的消息
    Self.imgHead.Left:=Const_Default_HorzGap;
    Self.btnContent.RefMaterial:=BusLiveDataModuleCommonSkinMaterial.bdmTalkMsg_Content_YourTextMsg;
  end;


  //消息内容
  //分解出内容和图片,表情不用换行,图片要换行
  //分解出
  //而且图片的最大宽度和最大高度要处理
  AMaxContentWidth:=0;
  if ASuperObjects<>'' then
  begin
    ASuiteMaxContentWidth:=120;
  end
  else
  begin
    ASuiteMaxContentWidth:=Width
                            -Self.imgHead.Width
                            -2*Const_Default_HorzGap
                            -Const_Default_HorzGap
                            //额外
                            -2*Const_Default_HorzGap;
  end;
  AContentSumHeight:=TSkinButtonDefaultMaterial(Self.btnContent.RefMaterial).DrawCaptionParam.DrawRectSetting.Top;

  for I := 0 to FMessageItem.ContentItems.Count - 1 do
  begin
    AContentSumHeight:=AContentSumHeight+Const_Default_ContentItem_VertGap;

    if FMessageItem.ContentItems[I].IndexOf('[Msg_Image]') >= 0 then
    begin
      //是图片
      AObjectIndex:=FMessageItem.SuperObjectCodes.IndexOf(FMessageItem.ContentItems[I]);

      AContentImage:=TSkinFMXImage.Create(Self);
      Self.FContentControlList.Add(AContentImage);
      AContentImage.Parent:=Self.btnContent;
      AContentImage.Left:=TSkinButtonDefaultMaterial(Self.btnContent.RefMaterial).DrawPictureParam.DestDrawStretchMargins.Left;
      AContentImage.Top:=AContentSumHeight;
      AContentImage.ParentMouseEvent:=True;

      if FileExists(FMessageItem.SuperObjectFiles[AObjectIndex]) then
      begin
        //图片已经存在或下载
        AContentImage.Prop.Picture.LoadFromFile(FMessageItem.SuperObjectFiles[AObjectIndex]);
        AContentImage.Prop.Animated:=True;
      end
      else
      begin
        //正在加载的图片
        AContentImage.Prop.Picture.SkinImageList:=BusLiveDataModuleCommonSkinMaterial.imglistDownloadState;
        AContentImage.Prop.Picture.ImageIndex:=0;
      end;
      AContentSize:=AutoFitPictureDrawRect(AContentImage.Prop.Picture.CurrentPictureWidth,
                      AContentImage.Prop.Picture.CurrentPictureHeight,
                      ASuiteMaxContentWidth,
                      AContentImage.Prop.Picture.CurrentPictureHeight);
      AContentImage.Width:=AContentSize.Width;
      AContentImage.Height:=AContentSize.Height;
      AContentImage.SelfOwnMaterialToDefault.DrawPictureParam.IsAutoFit:=True;

      AContentSumHeight:=AContentSumHeight+AContentImage.Height+Const_Default_ContentItem_VertGap;
      if AContentImage.Width>AMaxContentWidth then
      begin
        AMaxContentWidth:=AContentImage.Width;
      end;


    end
    else if FMessageItem.ContentItems[I].IndexOf('[Msg_File]') >= 0 then
    begin
      //文件内容
    end
    else
    begin
      //文本内容
      //在这里生成一个Label
      AContentLabel:=TSkinFMXLabel.Create(Self);
      Self.FContentControlList.Add(AContentLabel);
      AContentLabel.Caption:=FMessageItem.ContentItems[I];
      AContentLabel.Parent:=Self.btnContent;
      AContentLabel.Left:=TSkinButtonDefaultMaterial(Self.btnContent.RefMaterial).DrawCaptionParam.DrawRectSetting.Left;
      AContentLabel.Top:=AContentSumHeight;
      AContentLabel.ParentMouseEvent:=True;
      AContentLabel.MaterialUseKind:=mukRef;
      AContentLabel.RefMaterial:=BusLiveDataModuleCommonSkinMaterial.ldmTalkMsg_Content_Default;


      //计算尺寸
      AContentSize:=GetStringSize(FMessageItem.ContentItems[I],
              RectF(0,
                    0,
                    //最大宽度
                    ASuiteMaxContentWidth,
                    100),
              AContentLabel.CurrentUseMaterialToDefault.DrawCaptionParam);
      AContentLabel.Width:=AContentSize.cx+8;
      AContentLabel.Height:=AContentSize.cy;


      AContentSumHeight:=AContentSumHeight+AContentLabel.Height+Const_Default_ContentItem_VertGap;
      if AContentLabel.Width>AMaxContentWidth then
      begin
        AMaxContentWidth:=AContentLabel.Width;
      end;


    end;
  end;


  //消息内容按钮加上边距
  AContentSize.cx:=AMaxContentWidth;
  AContentSize.cy:=AContentSumHeight;
  AContentSize.cx:=AContentSize.cx
      +TSkinButtonDefaultMaterial(Self.btnContent.RefMaterial).DrawCaptionParam.DrawRectSetting.Left
      +TSkinButtonDefaultMaterial(Self.btnContent.RefMaterial).DrawCaptionParam.DrawRectSetting.Right;
  AContentSize.cy:=AContentSize.cy
      +TSkinButtonDefaultMaterial(Self.btnContent.RefMaterial).DrawCaptionParam.DrawRectSetting.Bottom;
  Self.btnContent.Width:=AContentSize.cx;
  Self.btnContent.Height:=AContentSize.cy;


  //设置Content的位置
  if FMessageItem.Sender_UserId=0 then
  begin
    //我发的消息
    Self.btnContent.Left:=Self.imgHead.Left-Const_Default_HorzGap-Self.btnContent.Width;
  end
  else
  begin
    //别人发的消息
    Self.btnContent.Left:=Self.imgHead.Left+Self.imgHead.Width+Const_Default_HorzGap;
  end;


  //设置Frame的Height
  if Self.imgHead.Top+Self.imgHead.Height>Self.btnContent.Top+Self.btnContent.Height then
  begin
    Height:=Self.imgHead.Top+Self.imgHead.Height+Const_Default_HorzGap;
  end
  else
  begin
    Height:=Self.btnContent.Top+Self.btnContent.Height+Const_Default_HorzGap;
  end;

end;

{ TMessageItem }

constructor TMessageItem.Create;
begin
  ContentItems:=TStringList.Create;
  SuperObjectCodes:=TStringList.Create;
  SuperObjectFiles:=TStringList.Create;
end;

destructor TMessageItem.Destroy;
begin
  FreeAndNil(SuperObjectCodes);
  FreeAndNil(SuperObjectFiles);
  FreeAndNil(ContentItems);
  inherited;
end;

procedure TMessageItem.ParseContent;
var
  I:Integer;
  objStringList: TStringList;
  strLine: string;
  strContent:String;
  strSuperObjectCode: string;
  ASuperObjectCodeIndex:Integer;
  strSuperObjectCodeSubText:String;
  strSuperObjectFile: string;
begin
  Self.ContentItems.Clear;
  Self.SuperObjectCodes.Clear;
  Self.SuperObjectFiles.Clear;

  strContent:=Self.Content;
  if Self.SuperObjects<>'' then
  begin
    //存在图片或者文件
    objStringList := TStringList.Create();
    try
      objStringList.Text := Self.SuperObjects;
      for i := 0 to objStringList.Count - 1 do
      begin
        strLine := objStringList.Strings[i];

        //代码
        strSuperObjectCode:=strLine.Substring(0,strLine.IndexOf('|'));
        //文件路径
        strSuperObjectFile:=strLine.Substring(Pos('|', strLine),MaxInt);

        //取出图片前的文字
        ASuperObjectCodeIndex:=strContent.IndexOf(strSuperObjectCode);
        strSuperObjectCodeSubText:=strContent.Substring(0,ASuperObjectCodeIndex);
        if strSuperObjectCodeSubText<>'' then
        begin
          ContentItems.Add(strSuperObjectCodeSubText);
        end;

        //添加此Object
        Self.ContentItems.Add(strSuperObjectCode);
        Self.SuperObjectCodes.Add(strSuperObjectCode);
        Self.SuperObjectFiles.Add(strSuperObjectFile);

        strContent:=strContent.Remove(0,ASuperObjectCodeIndex+Length(strSuperObjectCode));

        //最后一段剩余的文本
        if (I=objStringList.Count - 1) and (strContent<>'') then
        begin
          ContentItems.Add(strContent);
        end;

      end;
    finally
      FreeAndNil(objStringList);
    end;

  end
  else
  begin
    //纯文本内容
    ContentItems.Add(strContent);
  end;

end;

end.
