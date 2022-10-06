//convert pas to utf8 by ¥
unit ChatBoxFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinImageList, uSkinFireMonkeyLabel, uSkinFireMonkeyItemDesignerPanel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyListBox, uSkinFireMonkeyImage,
  uUIFunction,
  uFrameContext,
  FMX.VirtualKeyboard,
  FMX.Platform,
  uSkinItems,
  uDrawCanvas,
//  uSkinPackage,
  uComponentType,
  uBufferBitmap,
  uBaseList,
  DateUtils,
  uDrawTextParam,

  TalkMsgContentFrame,
  TalkMsgTimeFrame,
  BusLiveCommonSkinMaterialModule,
  uSkinListBoxType,
  uSkinFireMonkeyControl, uSkinFireMonkeyPanel, uSkinFireMonkeyButton,
  FMX.Controls.Presentation, FMX.Edit, uSkinFireMonkeyEdit, FMX.Layouts,
  FMX.Memo, uSkinFireMonkeyMemo, uDrawPicture,
  FMX.ScrollBox,
  uSkinPageControlType, uSkinFireMonkeyPageControl,
  uSkinFireMonkeySwitchPageListPanel, uSkinMaterial, uSkinButtonType,
  uSkinFireMonkeyFrameImage, uSkinFireMonkeyDirectUIParent,
  uSkinFireMonkeyScrollBoxContent, uSkinFireMonkeyScrollBox,
  uSkinFireMonkeyScrollControlCorner, uSkinFireMonkeyScrollBar,
  uSkinScrollBoxContentType, uSkinScrollControlType, uSkinScrollBoxType;

type
  TFrameChatBox = class(TFrame)
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    procedure sbcClientStayClick(Sender: TObject);
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    FTalkMsgFrameList:TBaseList;

    //清除消息记录
    procedure Clear;
    //更新聊天记录图片下载
    procedure UpdateSuperObjectStatus(AMsgId:String;ASuperObjectCode:String;AFileName:String);

    //添加消息
    function AddContactMessage(ASender_UserId: Integer;
                                  AMsgId: string;
                                  AContent,
                                  AFontString,
                                  ASuperObjects: string;
                                  ASendTime: TDateTime):TFrameTalkMsgContent;
    procedure ProcessTalkMsgContentFrame(ATalkMsgContentFrame:TFrameTalkMsgContent);
    { Public declarations }
  end;


implementation

{$R *.fmx}

{ TFrameChatBox }

function TFrameChatBox.AddContactMessage(ASender_UserId: Integer;
                              AMsgId: string;
                              AContent,
                              AFontString,
                              ASuperObjects: string;
                              ASendTime: TDateTime):TFrameTalkMsgContent;
var
  ATalkMsgContentFrame:TFrameTalkMsgContent;
begin
  //添加到消息记录
  ATalkMsgContentFrame:=TFrameTalkMsgContent.Create(Self);
  ATalkMsgContentFrame.Width:=Width;
  SetFrameName(ATalkMsgContentFrame);


  ATalkMsgContentFrame.LoadContactMessage(
                  ASender_UserId,
                  AMsgId,
                  AContent,
                  AFontString,
                  ASuperObjects,
                  ASendTime
                  );

  ProcessTalkMsgContentFrame(ATalkMsgContentFrame);
end;

procedure TFrameChatBox.Clear;
begin
  //清空消息控件
  FTalkMsgFrameList.Clear(True);
  Self.sbcClient.Height:=0;

end;

constructor TFrameChatBox.Create(AOwner: TComponent);
begin
  inherited;
  Self.sbcClient.Height:=0;
  FTalkMsgFrameList:=TBaseList.Create;
end;

destructor TFrameChatBox.Destroy;
begin
  FreeAndNil(FTalkMsgFrameList);
  inherited;
end;

procedure TFrameChatBox.ProcessTalkMsgContentFrame(ATalkMsgContentFrame: TFrameTalkMsgContent);
var
  I: Integer;
  ALastTalkTime:TDateTime;
  ATalkMsgTimeFrame:TFrameTalkMsgTime;
  ALastTalkMsgContentFrame:TFrameTalkMsgContent;
begin

  ALastTalkTime:=Now;
  for I := Self.FTalkMsgFrameList.Count-1 downto 0 do
  begin
    if FTalkMsgFrameList[I] is TFrameTalkMsgContent then
    begin
      ALastTalkTime:=TFrameTalkMsgContent(FTalkMsgFrameList[I]).FMessageItem.SendTime;
      Break;
    end;
  end;

  if (FTalkMsgFrameList.Count=0)
    //或者时间间隔一段时间
    or (DateUtils.MinutesBetween(ALastTalkTime,ATalkMsgContentFrame.FMessageItem.SendTime)>1)
   then
  begin
    //添加时间控件
    ATalkMsgTimeFrame:=TFrameTalkMsgTime.Create(Self);
    SetFrameName(ATalkMsgTimeFrame);
    ATalkMsgTimeFrame.SetTime(ATalkMsgContentFrame.FMessageItem.SendTime);
    ATalkMsgTimeFrame.Position.X:=0;
    ATalkMsgTimeFrame.Width:=Width;
    ATalkMsgTimeFrame.Parent:=Self.sbcClient;

    if FTalkMsgFrameList.Count>0 then
    begin
      ATalkMsgTimeFrame.Position.Y:=
        TFrame(FTalkMsgFrameList[FTalkMsgFrameList.Count-1]).Position.Y
        +TFrame(FTalkMsgFrameList[FTalkMsgFrameList.Count-1]).Height;
    end;

    //设置ScrollBox的高度
    Self.sbcClient.Height:=Self.sbcClient.Height+ATalkMsgTimeFrame.Height;

    FTalkMsgFrameList.Add(ATalkMsgTimeFrame)
  end;


  ATalkMsgContentFrame.Position.X:=0;
  ATalkMsgContentFrame.Width:=Width;
  ATalkMsgContentFrame.Parent:=Self.sbcClient;
  if FTalkMsgFrameList.Count>0 then
  begin
    ATalkMsgContentFrame.Position.Y:=
      TFrame(FTalkMsgFrameList[FTalkMsgFrameList.Count-1]).Position.Y
      +TFrame(FTalkMsgFrameList[FTalkMsgFrameList.Count-1]).Height;
  end;
  FTalkMsgFrameList.Add(ATalkMsgContentFrame);

  //设置ScrollBox的高度
  Self.sbcClient.Height:=Self.sbcClient.Height+ATalkMsgContentFrame.Height;
  //滚动条滚到最后
  Self.sbClient.VertScrollBar.Prop.Position:=Self.sbClient.VertScrollBar.Prop.Max;


end;

procedure TFrameChatBox.sbcClientStayClick(Sender: TObject);
begin
  HideVirtualKeyboard;
end;

procedure TFrameChatBox.UpdateSuperObjectStatus(AMsgId, ASuperObjectCode,AFileName: String);
var
  I: Integer;
  J:Integer;
  AContentImage:TSkinFMXImage;
  ATalkMsgContentFrame:TFrameTalkMsgContent;
begin
  for I := 0 to Self.FTalkMsgFrameList.Count-1 do
  begin
    if (Self.FTalkMsgFrameList[I] is TFrameTalkMsgContent)
      and (TFrameTalkMsgContent(Self.FTalkMsgFrameList[I]).FMessageItem.MsgId=AMsgId) then
    begin
      ATalkMsgContentFrame:=TFrameTalkMsgContent(Self.FTalkMsgFrameList[I]);
      //消息项
      for J := 0 to ATalkMsgContentFrame.FMessageItem.ContentItems.Count-1 do
      begin
        if ATalkMsgContentFrame.FMessageItem.ContentItems[J].IndexOf(ASuperObjectCode)>=0 then
        begin
          if FileExists(AFileName) then
          begin
            AContentImage:=TSkinFMXImage(ATalkMsgContentFrame.FContentControlList[J]);
            AContentImage.Prop.Picture.LoadFromFile(AFileName);
            AContentImage.Prop.Animated:=True;
            //需要重新排列一下
            AContentImage.Invalidate;
          end;
        end;
      end;
    end;
  end;
end;

end.

