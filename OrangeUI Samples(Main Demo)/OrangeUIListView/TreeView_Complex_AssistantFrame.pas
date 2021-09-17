//convert pas to utf8 by ¥

unit TreeView_Complex_AssistantFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,


  uFuncCommon,
  uTimerTask,

  XSuperObject,
  XSuperJson,

  uDrawCanvas,
  uSkinItems,
  uSkinTreeViewType,

  uSkinFireMonkeyControl, uSkinFireMonkeyPanel, uSkinFireMonkeyButton,
  uSkinFireMonkeyImage, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyTreeView,
  uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyLabel, uSkinMaterial,
  uSkinLabelType, FMX.Controls.Presentation, FMX.StdCtrls, uSkinButtonType,
  uSkinImageType, uDrawPicture, uSkinImageList, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, uSkinFireMonkeyPopup,
  uSkinFireMonkeyListView, uSkinScrollControlType, uSkinVirtualListType,
  uSkinListViewType, uSkinCustomListType, uSkinFireMonkeyCustomList,
  uSkinItemDesignerPanelType;

type
  TFrameTreeView_Complex_Assistant = class(TFrame)
    SkinFMXTreeView1: TSkinFMXTreeView;
    Item2: TSkinFMXItemDesignerPanel;
    Item3: TSkinFMXItemDesignerPanel;
    imgItem2LeftBackGround: TSkinFMXImage;
    imgItem2RightBackGround: TSkinFMXImage;
    lblItem2Caption: TSkinFMXLabel;
    lblItem2Detail: TSkinFMXLabel;
    lblItem2Detail1: TSkinFMXLabel;
    lblItem2Detail2: TSkinFMXLabel;
    lblItem2VSHint: TSkinFMXLabel;
    lblItem2Detail3: TSkinFMXLabel;
    btnItem2Select1: TSkinFMXButton;
    btnItem2Select2: TSkinFMXButton;
    btnItem2Select3: TSkinFMXButton;
    lblItem2Detail4: TSkinFMXLabel;
    lblItem2Detail5: TSkinFMXLabel;
    btnItem2Select4: TSkinFMXButton;
    btnItem2Select5: TSkinFMXButton;
    btnItem2Select6: TSkinFMXButton;
    imgItem3Row1: TSkinFMXImage;
    imgItemParentBackGround: TSkinFMXImage;
    imgItem3Row2: TSkinFMXImage;
    imgItem3Row3: TSkinFMXImage;
    imgItem3Row6: TSkinFMXImage;
    imgItem3Row4: TSkinFMXImage;
    lblItem3OrderHint: TSkinFMXLabel;
    lblItem3HisHint: TSkinFMXLabel;
    lblItem3SecondHint: TSkinFMXLabel;
    lblItem3PayHint: TSkinFMXLabel;
    imgItem3Row5: TSkinFMXImage;
    lblItem3PercentHint: TSkinFMXLabel;
    lblItem3Caption: TSkinFMXLabel;
    lblItem3Detail1Win: TSkinFMXLabel;
    lblItem3SecondDetail4: TSkinFMXLabel;
    lblItem3Pay1: TSkinFMXLabel;
    SkinFMXLabel13: TSkinFMXLabel;
    SkinFMXLabel14: TSkinFMXLabel;
    lblItem3Detail2Equal: TSkinFMXLabel;
    lblItem3SecondDetail5: TSkinFMXLabel;
    lblItem3Pay2: TSkinFMXLabel;
    SkinFMXLabel18: TSkinFMXLabel;
    lblItem3Detail: TSkinFMXLabel;
    lblItem3Detail3Fail: TSkinFMXLabel;
    lblItem3SecondDetail6: TSkinFMXLabel;
    lblItem3Pay3: TSkinFMXLabel;
    SkinFMXLabel23: TSkinFMXLabel;
    btnAn: TSkinFMXButton;
    ItemDay: TSkinFMXItemDesignerPanel;
    imgItemDayIcon: TSkinFMXImage;
    lblItemDayCaption: TSkinFMXLabel;
    imgItemDayExpandState: TSkinFMXImage;
    imgTreeExpandState: TSkinImageList;
    imgItem2ExpandState: TSkinFMXImage;
    btnDefaultButtonMaterial: TSkinButtonDefaultMaterial;
    IdHTTP1: TIdHTTP;
    procedure imgItem2LeftBackGroundClick(Sender: TObject);
    procedure SkinFMXTreeView1ClickItem(Sender: TSkinItem);
    procedure SkinFMXTreeView1PrepareDrawItem(Sender: TObject;
      Canvas: TDrawCanvas; ItemDesignerPanel: TSkinFMXItemDesignerPanel;
      Item: TSkinItem; ItemRect: TRect);
    procedure btnItem2Select1Click(Sender: TObject);
    procedure btnItem2Select2Click(Sender: TObject);
    procedure btnItem2Select3Click(Sender: TObject);
    procedure btnItem2Select4Click(Sender: TObject);
    procedure btnItem2Select5Click(Sender: TObject);
    procedure btnItem2Select6Click(Sender: TObject);
    procedure btnFilterClick(Sender: TObject);
    procedure btnMenuClick(Sender: TObject);
    procedure imgItem2RightBackGroundResize(Sender: TObject);
  private

    FData:String;
    FDataJsonArray:TSuperArray;
    procedure DoGetDataExecute(ATimerTask:TObject);
    procedure DoGetDataExecuteEnd(ATimerTask:TObject);

    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;


implementation

{$R *.fmx}

procedure TFrameTreeView_Complex_Assistant.btnFilterClick(Sender: TObject);
var
  I: Integer;
  J: Integer;
  AParentTreeViewItem:TSkinTreeViewItem;
  AChildTreeViewItem:TSkinTreeViewItem;
  ASelectResult:TStringList;
begin
  //选择结果
  ASelectResult:=TStringList.Create;

  //每天
  for I := 0 to Self.SkinFMXTreeView1.Prop.Items.Count-1 do
  begin
    AParentTreeViewItem:=Self.SkinFMXTreeView1.Prop.Items[I];

    //每场比赛
    for J := 0 to AParentTreeViewItem.Childs.Count-1 do
    begin
      AChildTreeViewItem:=AParentTreeViewItem.Childs[J];
      if AChildTreeViewItem.SubItems[6]='1' then ASelectResult.Add(AChildTreeViewItem.Caption+' '+AChildTreeViewItem.Detail+' 第一行 '+'胜');
      if AChildTreeViewItem.SubItems[7]='1' then ASelectResult.Add(AChildTreeViewItem.Caption+' '+AChildTreeViewItem.Detail+' 第一行 '+'平');
      if AChildTreeViewItem.SubItems[8]='1' then ASelectResult.Add(AChildTreeViewItem.Caption+' '+AChildTreeViewItem.Detail+' 第一行 '+'负');

      if AChildTreeViewItem.SubItems[9]='1' then ASelectResult.Add(AChildTreeViewItem.Caption+' '+AChildTreeViewItem.Detail+' 第二行 '+'胜');
      if AChildTreeViewItem.SubItems[10]='1' then ASelectResult.Add(AChildTreeViewItem.Caption+' '+AChildTreeViewItem.Detail+' 第二行 '+'平');
      if AChildTreeViewItem.SubItems[11]='1' then ASelectResult.Add(AChildTreeViewItem.Caption+' '+AChildTreeViewItem.Detail+' 第二行 '+'负');
    end;

  end;

  ShowMessage('您选择了 '+ASelectResult.CommaText);

  ASelectResult.Free;
end;

procedure TFrameTreeView_Complex_Assistant.btnItem2Select1Click(Sender: TObject);
begin
  if Self.SkinFMXTreeView1.Prop.InteractiveItem.SubItems[6]='1' then
  begin
    Self.SkinFMXTreeView1.Prop.InteractiveItem.SubItems[6]:='0';
  end
  else
  begin
    Self.SkinFMXTreeView1.Prop.InteractiveItem.SubItems[6]:='1';
  end;
  //点击事件

end;

procedure TFrameTreeView_Complex_Assistant.btnItem2Select2Click(Sender: TObject);
begin
  if Self.SkinFMXTreeView1.Prop.InteractiveItem.SubItems[7]='1' then
  begin
    Self.SkinFMXTreeView1.Prop.InteractiveItem.SubItems[7]:='0';
  end
  else
  begin
    Self.SkinFMXTreeView1.Prop.InteractiveItem.SubItems[7]:='1';
  end;
  //点击事件

end;

procedure TFrameTreeView_Complex_Assistant.btnItem2Select3Click(Sender: TObject);
begin
  if Self.SkinFMXTreeView1.Prop.InteractiveItem.SubItems[8]='1' then
  begin
    Self.SkinFMXTreeView1.Prop.InteractiveItem.SubItems[8]:='0';
  end
  else
  begin
    Self.SkinFMXTreeView1.Prop.InteractiveItem.SubItems[8]:='1';
  end;
  //点击事件

end;

procedure TFrameTreeView_Complex_Assistant.btnItem2Select4Click(Sender: TObject);
begin
  if Self.SkinFMXTreeView1.Prop.InteractiveItem.SubItems[9]='1' then
  begin
    Self.SkinFMXTreeView1.Prop.InteractiveItem.SubItems[9]:='0';
  end
  else
  begin
    Self.SkinFMXTreeView1.Prop.InteractiveItem.SubItems[9]:='1';
  end;
  //点击事件

end;

procedure TFrameTreeView_Complex_Assistant.btnItem2Select5Click(Sender: TObject);
begin
  if Self.SkinFMXTreeView1.Prop.InteractiveItem.SubItems[10]='1' then
  begin
    Self.SkinFMXTreeView1.Prop.InteractiveItem.SubItems[10]:='0';
  end
  else
  begin
    Self.SkinFMXTreeView1.Prop.InteractiveItem.SubItems[10]:='1';
  end;
  //点击事件

end;

procedure TFrameTreeView_Complex_Assistant.btnItem2Select6Click(Sender: TObject);
begin
  if Self.SkinFMXTreeView1.Prop.InteractiveItem.SubItems[11]='1' then
  begin
    Self.SkinFMXTreeView1.Prop.InteractiveItem.SubItems[11]:='0';
  end
  else
  begin
    Self.SkinFMXTreeView1.Prop.InteractiveItem.SubItems[11]:='1';
  end;
  //点击事件

end;

procedure TFrameTreeView_Complex_Assistant.btnMenuClick(Sender: TObject);
var
  I: Integer;
  J: Integer;
  AParentTreeViewItem:TSkinTreeViewItem;
  AChildTreeViewItem:TSkinTreeViewItem;
begin
  //清空

  //每天
  for I := 0 to Self.SkinFMXTreeView1.Prop.Items.Count-1 do
  begin
    AParentTreeViewItem:=Self.SkinFMXTreeView1.Prop.Items[I];

    //每场比赛
    for J := 0 to AParentTreeViewItem.Childs.Count-1 do
    begin
      AParentTreeViewItem.Childs[J].SubItems[6]:='0';
      AParentTreeViewItem.Childs[J].SubItems[7]:='0';
      AParentTreeViewItem.Childs[J].SubItems[8]:='0';
      AParentTreeViewItem.Childs[J].SubItems[9]:='0';
      AParentTreeViewItem.Childs[J].SubItems[10]:='0';
      AParentTreeViewItem.Childs[J].SubItems[11]:='0';
    end;

  end;

  Self.SkinFMXTreeView1.Repaint;
end;

constructor TFrameTreeView_Complex_Assistant.Create(AOwner: TComponent);
begin
  inherited;

  Self.SkinFMXTreeView1.Prop.Items.BeginUpdate;
  try
    Self.SkinFMXTreeView1.Prop.Items.Clear(True);
  finally
    Self.SkinFMXTreeView1.Prop.Items.EndUpdate;
  end;

  uTimerTask.GetGlobalTimerThread.RunTempTask(
      Self.DoGetDataExecute,
      Self.DoGetDataExecuteEnd
      );

end;

destructor TFrameTreeView_Complex_Assistant.Destroy;
begin

  FreeAndNil(FDataJsonArray);
  inherited;
end;

procedure TFrameTreeView_Complex_Assistant.DoGetDataExecute(ATimerTask: TObject);
begin

  IdHTTP1.Request.UserAgent:='Mozilla/3.0';
  FData:=Self.IdHTTP1.Get('http://info.sporttery.cn/interface/interface_mixed.php?action=fb_list');//,ADataStream);


  //var data=[[["周三031","奥运会男足","巴西国奥$-1$丹麦国奥",
  //;getData();
  FData:=Copy(FData,
            Length('var data=')+1,
            Length(FData)-Length('var data=')-Length(';getData();')
            );

  FreeAndNil(FDataJsonArray);
  FDataJsonArray:=TSuperArray.Create(FData);

end;

procedure TFrameTreeView_Complex_Assistant.DoGetDataExecuteEnd(ATimerTask: TObject);
var
  I: Integer;
  J: Integer;
  K: Integer;
  ACurDay:String;
  AIndex:Integer;
  ATemp:String;
  AGameCount:Integer;
  ADayTreeViewItem:TSkinTreeViewItem;
  AGameTreeViewItem:TSkinTreeViewItem;
  ADetailTreeViewItem:TSkinTreeViewItem;
begin
  //根据返回的数据显示到界面上
  Self.SkinFMXTreeView1.Prop.Items.BeginUpdate;
  try
    Self.SkinFMXTreeView1.Prop.Items.Clear(True);

    if FDataJsonArray=nil then Exit;


    ACurDay:='';
    I:=0;
    while I <FDataJsonArray.Length do
    begin
      ADayTreeViewItem:=Self.SkinFMXTreeView1.Prop.Items.Add;
      ADayTreeViewItem.ItemType:=sitItem1;
      ADayTreeViewItem.Height:=50;
      //第一个展开
      ADayTreeViewItem.Expanded:=I=0;




      AGameCount:=0;


      if ACurDay='' then
      begin
        ACurDay:=FormatDateTime('YYYY-MM-DD',StandardStrToDateTime('20'+FDataJsonArray.A[0].A[0].S[3]));
      end;


      for J := I to FDataJsonArray.Length-1 do
      begin



        //判断日期是否相同
//        if FormatDateTime('YYYY-MM-DD',StandardStrToDateTime('20'+FDataJsonArray.A[I].A[0].S[3]))>=
//          FormatDateTime('YYYY-MM-DD',Now) then
//        begin
//          Inc(AGameCount);
//        end
//        else
//        begin
//          Break;
//        end;
        if FormatDateTime('YYYY-MM-DD',StandardStrToDateTime('20'+FDataJsonArray.A[I].A[0].S[3]))=
            ACurDay then
        begin
          Inc(AGameCount);
        end
        else
        begin
          ACurDay:=FormatDateTime('YYYY-MM-DD',StandardStrToDateTime('20'+FDataJsonArray.A[I].A[0].S[3]));
          Break;
        end;



        //"周三031","奥运会男足","巴西国奥$-1$丹麦国奥","16-08-11 09:00","82867","#F157B9"]
        //["1.70","3.70","3.70","2"],
        //["6.50","5.40","8.00","6.75","10.00","25.00","11.00","16.00","35.00","20.00","30.00",
          //"70.00","13.00","13.00","10.00","21.00","80.00","400.0","22.00","60.00","25.00","200.0",
          //"100.0","80.00","600.0","300.0","300.0","900.0","900.0","900.0","300.0","1","2"],
        //["13.00","5.50","3.70","3.50","4.60","7.50","12.00","16.00","2"],
        //["1.55","20.00","100.0","3.60","7.50","21.00","25.00","20.00","17.00","2"],
        //["1.17","5.45","11.00","2"]]
        AGameTreeViewItem:=ADayTreeViewItem.Childs.Add;
        AGameTreeViewItem.ItemType:=sitItem2;
        AGameTreeViewItem.Height:=120;
        AGameTreeViewItem.Expanded:=False;


//        AGameTreeViewItem.Caption:='00'+IntToStr(J);
        AGameTreeViewItem.Caption:=Copy(FDataJsonArray.A[J].A[0].S[0],3,MaxInt);
//        AGameTreeViewItem.Detail:='欧洲联赛'+IntToStr(J);
        AGameTreeViewItem.Detail:=FDataJsonArray.A[J].A[0].S[1];
        //"16-08-11 09:00"
        AGameTreeViewItem.Detail1:= FormatDateTime('HH:MM',StandardStrToDateTime('20'+FDataJsonArray.A[J].A[0].S[3]))+'截止';
        //巴西国奥$-1$丹麦国奥
        ATemp:=FDataJsonArray.A[J].A[0].S[2];
        AIndex:=Pos('$',ATemp);
        AGameTreeViewItem.Detail2:=Copy(FDataJsonArray.A[J].A[0].S[2],1,AIndex-1);
        ATemp:=Copy(ATemp,AIndex+1,MaxInt);
        AGameTreeViewItem.Detail4:='0';
        AGameTreeViewItem.Detail5:=Copy(ATemp,1,2);
        ATemp:=Copy(ATemp,4,MaxInt);
        AGameTreeViewItem.Detail3:=ATemp;




        AGameTreeViewItem.SubItems.Clear;

        AGameTreeViewItem.SubItems.Add('1');
        AGameTreeViewItem.SubItems.Add('2');
        AGameTreeViewItem.SubItems.Add('3');
        AGameTreeViewItem.SubItems.Add('4');
        AGameTreeViewItem.SubItems.Add('5');
        AGameTreeViewItem.SubItems.Add('6');

        //是否选中
        AGameTreeViewItem.SubItems.Add('');
        AGameTreeViewItem.SubItems.Add('');
        AGameTreeViewItem.SubItems.Add('');
        AGameTreeViewItem.SubItems.Add('');
        AGameTreeViewItem.SubItems.Add('');
        AGameTreeViewItem.SubItems.Add('');



//        ADetailTreeViewItem:=AGameTreeViewItem.Childs.Add;
//        ADetailTreeViewItem.ItemType:=sitItem3;
//        ADetailTreeViewItem.Height:=186;
//        ADetailTreeViewItem.Caption:='拉脱甲3';
//        ADetailTreeViewItem.Detail:='稣超2';
//        ADetailTreeViewItem.Detail1:='一胜';
//        ADetailTreeViewItem.Detail2:='0平';
//        ADetailTreeViewItem.Detail3:='0负';
//        ADetailTreeViewItem.Detail4:='0.825';
//        ADetailTreeViewItem.Detail5:='受半球';
//        ADetailTreeViewItem.Detail5:='0.975';
//        ADetailTreeViewItem.SubItems.Clear;
//        ADetailTreeViewItem.SubItems.Add('3.55');
//        ADetailTreeViewItem.SubItems.Add('3.41');
//        ADetailTreeViewItem.SubItems.Add('1.94');



      end;




      //"周三031","奥运会男足","巴西国奥$-1$丹麦国奥","16-08-11 09:00","82867","#F157B9"]
      ADayTreeViewItem.Caption:=
            FormatDateTime('YYYY-MM-DD',StandardStrToDateTime('20'+FDataJsonArray.A[I].A[0].S[3]))
            +' '
            +Copy(FDataJsonArray.A[I].A[0].S[0],1,2)
            +' '
            +IntToStr(AGameCount)+'场比赛可以投'
            ;


      I:=I+AGameCount;

    end;
  finally
    Self.SkinFMXTreeView1.Prop.Items.EndUpdate;
  end;

end;

procedure TFrameTreeView_Complex_Assistant.imgItem2LeftBackGroundClick(Sender: TObject);
begin
  //展开/收拢
  if Self.SkinFMXTreeView1.Prop.InteractiveItem.IsParent then
  begin
    Self.SkinFMXTreeView1.Prop.InteractiveItem.Expanded:=
      Not Self.SkinFMXTreeView1.Prop.InteractiveItem.Expanded;
  end;
end;

procedure TFrameTreeView_Complex_Assistant.imgItem2RightBackGroundResize(Sender: TObject);
begin
  //队伍的对齐
  lblItem2Detail2.Width:=(Self.imgItem2RightBackGround.Width-Self.lblItem2VSHint.Width)/2;
  lblItem2Detail3.Width:=(Self.imgItem2RightBackGround.Width-Self.lblItem2VSHint.Width)/2;
  lblItem2VSHint.Left:=lblItem2Detail2.Left+lblItem2Detail2.Width;
  lblItem2Detail3.Left:=lblItem2VSHint.Left+lblItem2VSHint.Width;

  //按钮的对齐
  btnItem2Select2.Left:=btnItem2Select1.Left+btnItem2Select1.Width
    +((Self.imgItem2RightBackGround.Width-Self.lblItem2Detail4.Width)
        -Self.btnItem2Select1.Width*3
        -10)/2;
  btnItem2Select3.Left:=btnItem2Select2.Left+btnItem2Select2.Width
    +((Self.imgItem2RightBackGround.Width-Self.lblItem2Detail4.Width)
        -Self.btnItem2Select1.Width*3
        -10)/2;


  btnItem2Select5.Left:=btnItem2Select2.Left;
  btnItem2Select6.Left:=btnItem2Select3.Left;

end;

procedure TFrameTreeView_Complex_Assistant.SkinFMXTreeView1ClickItem(Sender: TSkinItem);
begin
  //展开/收拢
  if Sender.ItemType=sitItem1 then
  begin
    TSkinTreeViewItem(Sender).Expanded:=Not TSkinTreeViewItem(Sender).Expanded;
  end;
end;

procedure TFrameTreeView_Complex_Assistant.SkinFMXTreeView1PrepareDrawItem(Sender: TObject;
  Canvas: TDrawCanvas; ItemDesignerPanel: TSkinFMXItemDesignerPanel;
  Item: TSkinItem; ItemRect: TRect);
begin
  if Item.ItemType=sitItem2 then
  begin
    //比赛
    Self.btnItem2Select1.Prop.StaticIsPushed:=Item.SubItems[6]='1';
    Self.btnItem2Select2.Prop.StaticIsPushed:=Item.SubItems[7]='1';
    Self.btnItem2Select3.Prop.StaticIsPushed:=Item.SubItems[8]='1';
    Self.btnItem2Select4.Prop.StaticIsPushed:=Item.SubItems[9]='1';
    Self.btnItem2Select5.Prop.StaticIsPushed:=Item.SubItems[10]='1';
    Self.btnItem2Select6.Prop.StaticIsPushed:=Item.SubItems[11]='1';


  end;
end;

end.
