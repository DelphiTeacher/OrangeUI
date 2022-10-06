//convert pas to utf8 by ¥
/// <summary>
///   <para>
///     列表视图
///   </para>
///   <para>
///     List view
///   </para>
/// </summary>
unit uSkinRegExTagLabelViewType;



interface
{$I FrameWork.inc}

uses
  Classes,
  SysUtils,
  uFuncCommon,
  Types,
  Math,
  uBaseList,
  uBaseLog,
  {$IFDEF VCL}
  Messages,
  ExtCtrls,
  Controls,
  Graphics,
  {$ENDIF}
  {$IFDEF FMX}
  UITypes,
  FMX.Types,
  FMX.Controls,
  FMX.Graphics,
  FMX.Dialogs,
  {$ENDIF}
  uSkinItems,
  uSkinListLayouts,
  uDrawParam,
  uGraphicCommon,
  uSkinBufferBitmap,

//  {$IFDEF SKIN_SUPEROBJECT}
  uSkinSuperObject,
//  {$ELSE}
//  XSuperObject,
//  XSuperJson,
//  {$ENDIF}


  {$IF CompilerVersion <= 21.0} // D2010之前
  PerlRegEx,
  {$ELSE}
    System.RegularExpressions,
    System.Generics.Collections,
  {$IFEND}


  uDrawCanvas,
  uComponentType,
  uDrawEngine,
  uBinaryTreeDoc,
  uDrawPicture,
  uSkinMaterial,
  uDrawTextParam,
  uDrawLineParam,
  uDrawRectParam,
  uSkinImageList,
  uSkinListViewType,
  uSkinCustomListType,
  uSkinVirtualListType,
  uSkinItemDesignerPanelType,
  uSkinControlGestureManager,
  uSkinScrollControlType,
  uDrawPictureParam;







const
  IID_ISkinRegExTagLabelView:TGUID='{4AA3E17A-4734-4BDD-86B4-16D10381EC8C}';


type
  TRegExTagLabelViewProperties=class;


  //链接和话题等的正则表达式
  TRegExPatternItem=class(TCollectionItem)
  private
    FName: String;
    FRegEx: String;
    procedure SetName(const Value: String);
    procedure SetRegEx(const Value: String);
  protected
    procedure AssignTo(Dest: TPersistent); override;
  published
    property Name:String read FName write SetName;
    property RegEx:String read FRegEx write SetRegEx;
  end;
  TRegExPatterns=class(TCollection)
  private
    function GetItem(Index: Integer): TRegExPatternItem;
    procedure SetItem(Index: Integer; const Value: TRegExPatternItem);
  public
    function Add:TRegExPatternItem;
    property Items[Index:Integer]:TRegExPatternItem read GetItem write SetItem;default;
  end;





  TElementKindType=(
                //普通文本,sitDefault
                etText,
                //链接,要符合哪些正则表达式,sitItem1
                etLink);
  //内容中的元素,比如一个文本,一个链接
  TElement=class
  public
    //元素类型,是文本还是链接
    Kind:TElementKindType;


    //在内容中的开始下标
    Index:Integer;
    //文本长度
    Length:Integer;
    //文本
    Text:String;


    //单行绘制所需要的水平宽度
    DrawWidth:TControlSize;

    //
    RegExPattern:TRegExPatternItem;
  end;

  TElementList=class(TBaseList)
  private
    function GetItem(Index: Integer): TElement;
  public
    property Items[Index:Integer]:TElement read GetItem;default;
  end;





  //绘制的拆分项
  //比如一段文本显示出来要分多行来绘制
  //比如一个链接要分多行来绘制
  TDrawElementSplit=class
  public
    //所属那个内容元素
    Parent:TElement;


    RowIndex:Integer;
    IsRowEnd:Boolean;
    Text:String;
    //绘制所需要的宽度
    DrawWidth:TControlSize;
  end;
  TDrawElementSplitList=class(TBaseList)
  private
    function GetItem(Index: Integer): TDrawElementSplit;
  public
    property Items[Index:Integer]:TDrawElementSplit read GetItem;default;
  end;






  ISkinRegExTagLabelView=interface//(ISkinScrollControl)
    ['{4AA3E17A-4734-4BDD-86B4-16D10381EC8C}']
    function GetRegExTagLabelViewProperties:TRegExTagLabelViewProperties;


    property Properties:TRegExTagLabelViewProperties read GetRegExTagLabelViewProperties;
    property Prop:TRegExTagLabelViewProperties read GetRegExTagLabelViewProperties;
  end;





  TRegExTagLabelViewProperties=class(TListViewProperties)
  private
    FText: String;

    FRegExPatterns:TRegExPatterns;
    procedure SetText(const Value: String);
    procedure SetRegExPatterns(const Value: TRegExPatterns);
  protected
    FSkinRegExTagLabelViewIntf:ISkinRegExTagLabelView;
    //获取分类名称
    function GetComponentClassify:String;override;

  public
    constructor Create(ASkinControl:TControl);override;
    destructor Destroy;override;
  public
    //元素列表
    FElementList:TElementList;
    //拆分后的绘制元素列表
    FDrawElementSplitList:TDrawElementSplitList;
    procedure Sync;
    procedure LoadDrawElementToItems(ADrawElementSplitList:TDrawElementSplitList;
                                    ASkinItems:TSkinItems);
  published
    //内容
    property Text:String read FText write SetText;
    //符合标记的正则表达式
    property RegExPatterns:TRegExPatterns read FRegExPatterns write SetRegExPatterns;
  end;



  TSkinRegExTagLabelViewDefaultType=class(TSkinListViewDefaultType)
  public
    FSkinRegExTagLabelViewIntf:ISkinRegExTagLabelView;
    //绑定对象
    function CustomBind(ASkinControl:TControl):Boolean;override;
    procedure SizeChanged;override;
  public
  public
    constructor Create(ASkinControl:TControl);override;
  end;



  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinRegExTagLabelViewDefaultMaterial=class(TSkinListViewDefaultMaterial)
  public
    constructor Create(AOwner:TComponent);override;
  end;



  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinRegExTagLabelView=class(TSkinListView,
                                ISkinRegExTagLabelView,
                                IBindSkinItemTextControl,
                                IBindSkinItemValueControl

                                )
  private
    function GetRegExTagLabelViewProperties:TRegExTagLabelViewProperties;
    procedure SetRegExTagLabelViewProperties(Value:TRegExTagLabelViewProperties);
    function GetText: String;
    procedure SetText(const Value: String);
  protected
    //绑定列表项
    procedure BindingItemText(const AName:String;const AText:String;ASkinItem:TObject;AIsDrawItemInteractiveState:Boolean);

    procedure SetControlValueByBindItemField(const AFieldName:String;
                                              const AFieldValue:Variant;
                                              ASkinItem:TObject;
                                              AIsDrawItemInteractiveState:Boolean);
  protected
    //获取控件属性类
    function GetPropertiesClassType:TPropertiesClassType;override;
  public
    property Prop:TRegExTagLabelViewProperties read GetRegExTagLabelViewProperties write SetRegExTagLabelViewProperties;
  published
    //属性(必须在VertScrollBar和HorzScrollBar之前)
    property Properties:TRegExTagLabelViewProperties read GetRegExTagLabelViewProperties write SetRegExTagLabelViewProperties;
    property Text:String read GetText write SetText;
  end;




  {$IFDEF VCL}
  TSkinWinRegExTagLabelView=class(TSkinRegExTagLabelView)
  end;
  {$ENDIF VCL}




//将字符串根据正则表达式解析出文本和标记列表
procedure Parse(AInput:String;
                ARegExPatterns:TRegExPatterns;
                AElementList:TElementList//;
//                    ADrawElementSplitList:TDrawElementSplitList
                );

//一个文本可能占用两三行,要分隔开来
procedure ReAlignDrawElement(ACanvas:TCanvas;
                              ANormalFont:TFont;
                              ATagFont:TFont;
                              AElementList:TElementList;
                              ADrawElementSplitList:TDrawElementSplitList;
                              AControlWidth:TControlSize);

//计算字符串的尺寸
function CalcTextSize(//ACanvas:TCanvas;
                        AText:String;
                        AControlWidth:TControlSize;
                        AFont:TFont):TSizeF;


implementation


function HasChinese(AText:String):Boolean;
var
  I: Integer;
begin
  Result:=False;
  {$IF CompilerVersion <= 21.0} // D2010之前
  for I := 1 to Length(AText) do
  begin
    if not ((Ord(AText[I])<255) or (Ord(AText[I])>=$DB00)) then
    begin
      Result:=True;
      Break;
    end;
  end;
  {$ELSE}
  for I := 0 to AText.Length-1 do
  begin
    if not ((Ord(AText.Chars[I])<255) or (Ord(AText.Chars[I])>=$DB00)) then
    begin
      Result:=True;
      Break;
    end;
  end;
  {$IFEND}
end;

//计算字符串的尺寸
function CalcTextSize(//ACanvas:TCanvas;
                        AText:String;
                        AControlWidth:TControlSize;
                        AFont:TFont):TSizeF;
var
//  AElement:TElement;
  AElementList:TElementList;
  ADrawElementSplitList:TDrawElementSplitList;
  I: Integer;
  ARowWidth:Double;
  ARowHeight:Double;
begin
  Result.cx:=0;
  Result.cy:=0;


  AElementList:=TElementList.Create;
  ADrawElementSplitList:=TDrawElementSplitList.Create;
  try

//      AElement:=TElement.Create;
//      AElement.Kind:=etText;
//      AElement.Index:=0;
//      AElement.Length:=AText.Length;
//      AElement.Text:=AText;
//      AElement.RegExPattern:=nil;
//      AElementList.Add(AElement);


      Parse(AText,nil,AElementList);


//      {$IFDEF FMX}
//      ReAlignDrawElement(GetGlobalAutoSizeBufferBitmap.SelfBitmap.Bitmap.Canvas,AFont,AFont,AElementList,ADrawElementSplitList,AControlWidth);
//      {$ENDIF FMX}
//      {$IFDEF VCL}
      ReAlignDrawElement(GetGlobalAutoSizeBufferBitmap.DrawCanvas.Canvas,AFont,AFont,AElementList,ADrawElementSplitList,AControlWidth);
//      {$ENDIF VCL}


      //看看有几行
      if ADrawElementSplitList.Count>0 then
      begin
          //如果是一行,直接返回AElement.DrawWidth
          if ADrawElementSplitList[ADrawElementSplitList.Count-1].RowIndex=0 then
          begin
              Result.cx:=ADrawElementSplitList[ADrawElementSplitList.Count-1].DrawWidth;
//              {$IFDEF FMX}
//              Result.cy:=GetGlobalAutoSizeBufferBitmap.SelfBitmap.Bitmap.Canvas.TextHeight(AText);
//              {$ENDIF FMX}
//              {$IFDEF VCL}
              Result.cy:=GetGlobalAutoSizeBufferBitmap.DrawCanvas.Canvas.TextHeight(AText);
//              {$ENDIF VCL}
          end
          else
          begin
              //如果是多行,要返回行数
              //取每一行最宽的

              ARowWidth:=0;
              AText:='';
              for I := 0 to ADrawElementSplitList.Count-1 do
              begin
                  ARowWidth:=ARowWidth+ADrawElementSplitList[I].DrawWidth;
                  AText:=AText+ADrawElementSplitList[I].Text;

                  if ADrawElementSplitList[I].IsRowEnd then
                  begin
                    if ARowWidth>Result.cx then
                    begin
                      Result.cx:=ARowWidth;
                    end;

                    ARowHeight:=GetGlobalAutoSizeBufferBitmap.DrawCanvas.Canvas.TextHeight(AText);
                    Result.cy:=Result.cy+ARowHeight;

//                    FMX.Types.Log.d('OrangeUI CalcTextSize ARowHeight '+FloatToStr(ARowHeight));

                    //如果是纯英文的,要加增量
  //                  {$IFDEF ANDROID}
                    if not HasChinese(AText) then
                    begin
                      Result.cy:=Result.cy+5;
                    end
                    else
                    begin
//                      Result.cy:=Result.cy+2;
                    end;
  //                  {$ENDIF ANDROID}

                    ARowWidth:=0;
                    AText:='';
                  end;

              end;

          end;

      end;
  finally
    FreeAndNil(AElementList);
    FreeAndNil(ADrawElementSplitList);
  end;


end;


function SortByIndex_Compare(Item1, Item2: Pointer): Integer;
var
  Param1,Param2:TElement;
begin
  Param1:=TElement(Item1);
  Param2:=TElement(Item2);
  if Param1.Index>Param2.Index then
  begin
    Result:=1;
  end
  else if Param1.Index<Param2.Index then
  begin
    Result:=-1;
  end
  else
  begin
    Result:=0;
  end;
end;


procedure SpaceStr(var AStr:String;AIndex:Integer;ALength:Integer);
var
  I: Integer;
begin
  for I := 0 to ALength-1 do
  begin
    {$IFDEF MSWINDOWS}
    //以1为起始下标的
    AStr[AIndex-1+1+I]:=#0;
    {$ELSE}
    //以0为起始下标的
    AStr[AIndex-1+I]:=#0;
    {$ENDIF}
  end;
end;

procedure SplitDrawElement(AElement:TElement;
                          ADrawElementSplitList:TDrawElementSplitList;
                          ACanvas:TCanvas;
                          //传入和返回当前解析到了第几行
                          var ARowIndex:Integer;
                          //当前行绘制了多少宽度了
                          var ADrawWidth:TControlSize;
                          AControlWidth:TControlSize);
var
  ALeftElementText:String;
  ALeftElementDrawWidth:TControlSize;

  ANeedCutCharCount:Integer;
  ANeedCutWidth:TControlSize;
  ADrawElementSplit:TDrawElementSplit;
  I: Integer;
  ATempStr:String;
  ATempDrawWidth:TControlSize;
  ATempStrLength:Integer;

//  ALastDrawElement:TDrawElementSplit;
begin
  //剩下的文本
  ALeftElementText:=AElement.Text;
  //剩下的长度
  ALeftElementDrawWidth:=AElement.DrawWidth;
//  ALastDrawElement:=nil;

  {$IFDEF FMX}

  while ALeftElementText<>'' do
  begin

      //有没有回车符

      //判断有没有超过控件宽度,需不需要换行
      if ADrawWidth+ALeftElementDrawWidth<AControlWidth then
      begin
          //不需要换行,已经是最后一行了
          ADrawWidth:=ADrawWidth+ALeftElementDrawWidth;
          //没有超过一行
          ADrawElementSplit:=TDrawElementSplit.Create;
          ADrawElementSplit.Parent:=AElement;
          ADrawElementSplit.Text:=ALeftElementText;
          ADrawElementSplit.RowIndex:=ARowIndex;
          ADrawElementSplit.DrawWidth:=ALeftElementDrawWidth;
          ADrawElementSplitList.Add(ADrawElementSplit);
//          ALastDrawElement:=ADrawElementSplit;


//          FMX.Types.Log.d('OrangeUI SplitDrawElement '+ADrawElementSplit.Text);


          //回车符肯定是最后一个字符(因为拆分的时候是这么拆的),另起一行
          if ALeftElementText.IndexOf(#13)>=0 then
          begin
            //需要换行了
            ADrawElementSplit.IsRowEnd:=True;
            ARowIndex:=ARowIndex+1;
            ADrawWidth:=0;
          end;


          Exit;
      end
      else
      begin

          //要填多宽
          ANeedCutWidth:=AControlWidth-ADrawWidth;


          //要填多少个字符
          //中文字符的宽度要比英文字符大
          //我是王能呀
          //delphi,同样是6个字符,但是明显还能继续绘制
          ANeedCutCharCount:=Floor(  Length(AElement.Text)*(ANeedCutWidth/AElement.DrawWidth)  /2 )
                                          //怕有超出的,减小一个
//                                          -4
                                          ;

          //#$D83D
          if ANeedCutCharCount>0 then
          begin

              //如果最后一个字符,是表情符的前一个字符,那么要配对
              //不一定是前一个字符呀
              if ((ALeftElementText.Chars[ANeedCutCharCount-1]>=Char($D800))
                  and (ALeftElementText.Chars[ANeedCutCharCount-1]<=Char($DBFF))) then
              begin
//                FMX.Types.Log.d('OrangeUI SplitDrawElement ANeedCutCharCount Happened $D800');
                ANeedCutCharCount:=ANeedCutCharCount+1;
              end
              else
              begin
//                FMX.Types.Log.d('OrangeUI SplitDrawElement ANeedCutCharCount Happened '+IntToStr(Ord(ALeftElementText.Chars[ANeedCutCharCount-1])));
              end;



              ATempStr:=ALeftElementText.Substring(0,ANeedCutCharCount);
//              FMX.Types.Log.d('OrangeUI SplitDrawElement ATempStr 0 '+ATempStr);
              ATempDrawWidth:=ACanvas.TextWidth(ATempStr);
//              FMX.Types.Log.d('OrangeUI SplitDrawElement ATempStr 1 '+ATempStr);



              if ATempDrawWidth<ANeedCutWidth-20 then
              begin
                  //截取的字符串的宽度与所需要的宽度相差太大了,要重新计算


                  //有些情况下,字母数字符号占的宽度小,中文占的宽度大
                  //表情符号是不是占用两个字节
                  ATempStrLength:=ATempStr.Length;
                  I := ATempStrLength;
                  while  I < ALeftElementText.Length do
                  begin
                      //if(Unicode第一个字节 >=0xD8 && Unicode <=0xDB){
                      //    //这是代理区域，表示第1——16平面的字符。每四个字节表示一个单元
                      //}
                      //else{
                      //    //这是正常映射区域，表示第0个平面。每两个字节表示一个单元。
                      //}

                      if ((ALeftElementText.Chars[I]>=Char($D800)) and (ALeftElementText.Chars[I]<=Char($DBFF))) then
                      begin
                          //有Unicode要小心,表情符占两个字符
                          //等下一个即可,配好对
                          ATempDrawWidth:=ACanvas.TextWidth(ATempStr+ALeftElementText.Chars[I]+ALeftElementText.Chars[I+1]);
                      end
                      else
                      begin
                          ATempDrawWidth:=ACanvas.TextWidth(ATempStr+ALeftElementText.Chars[I]);
                      end;


                      if ATempDrawWidth>ANeedCutWidth then
                      begin
                        Break;
                      end
                      else
                      begin

                          if ((ALeftElementText.Chars[I]>=Char($D800)) and (ALeftElementText.Chars[I]<=Char($DBFF))) then
                          begin
//                              //有Unicode要小心,表情符占两个字符
//                              //等下一个即可,配好对
                              ATempStr:=ATempStr+ALeftElementText.Chars[I]+ALeftElementText.Chars[I+1];
                              ANeedCutCharCount:=ANeedCutCharCount+2;
                              Inc(I);
                          end
                          else
                          begin
                              ATempStr:=ATempStr+ALeftElementText.Chars[I];
                              ANeedCutCharCount:=ANeedCutCharCount+1;
                          end;



                      end;

                      Inc(I);
                  end;
              end;




              //超过一行
              //截断
              ADrawElementSplit:=TDrawElementSplit.Create;
              ADrawElementSplit.Parent:=AElement;

              //ANeedCutWidth占几个字符
              //截断到哪个字符串
              ADrawElementSplit.Text:=ATempStr;//ALeftElementText.Substring(0,ANeedCutCharCount);
              ADrawElementSplit.RowIndex:=ARowIndex;

              ANeedCutWidth:=ACanvas.TextWidth(ADrawElementSplit.Text);
              ADrawElementSplit.IsRowEnd:=True;

              ADrawElementSplit.DrawWidth:=ANeedCutWidth;
              ADrawElementSplitList.Add(ADrawElementSplit);
//              ALastDrawElement:=ADrawElementSplit;

//              FMX.Types.Log.d('OrangeUI SplitDrawElement '+ADrawElementSplit.Text);

          end
          else
          begin
              //显示不下了
              ANeedCutWidth:=0;

              //上一个强制换行
              if ADrawElementSplitList.Count>0 then
              begin
                  ADrawElementSplitList[ADrawElementSplitList.Count-1].IsRowEnd:=True;
              end;
          end;



          //换行了,重新开始了
          ADrawWidth:=0;
          ARowIndex:=ARowIndex+1;
          ALeftElementText:=ALeftElementText.Substring(ANeedCutCharCount,MaxInt);
          ALeftElementDrawWidth:=ALeftElementDrawWidth-ANeedCutWidth;
      end;
  end;

  {$ENDIF FMX}


  {$IFDEF VCL}

  while ALeftElementText<>'' do
  begin

      //有没有回车符

      //判断有没有超过控件宽度,需不需要换行
      if ADrawWidth+ALeftElementDrawWidth<AControlWidth then
      begin
          //不需要换行,已经是最后一行了
          ADrawWidth:=ADrawWidth+ALeftElementDrawWidth;
          //没有超过一行
          ADrawElementSplit:=TDrawElementSplit.Create;
          ADrawElementSplit.Parent:=AElement;
          ADrawElementSplit.Text:=ALeftElementText;
          ADrawElementSplit.RowIndex:=ARowIndex;
          ADrawElementSplit.DrawWidth:=ALeftElementDrawWidth;
          ADrawElementSplitList.Add(ADrawElementSplit);
//          ALastDrawElement:=ADrawElementSplit;


//          FMX.Types.Log.d('OrangeUI SplitDrawElement '+ADrawElementSplit.Text);


          //回车符肯定是最后一个字符(因为拆分的时候是这么拆的),另起一行
          if Pos(#13,ALeftElementText)>0 then
          begin
            //需要换行了
            ADrawElementSplit.IsRowEnd:=True;
            ARowIndex:=ARowIndex+1;
            ADrawWidth:=0;
          end;


          Exit;
      end
      else
      begin

          //要填多宽
          ANeedCutWidth:=AControlWidth-ADrawWidth;


          //要填多少个字符
          //中文字符的宽度要比英文字符大
          //我是王能呀
          //delphi,同样是6个字符,但是明显还能继续绘制
          ANeedCutCharCount:=Floor(  Length(AElement.Text)*(ANeedCutWidth/AElement.DrawWidth)  /2 )
                                          //怕有超出的,减小一个
//                                          -4
                                          ;

          //#$D83D
          if ANeedCutCharCount>0 then
          begin

              //如果最后一个字符,是表情符的前一个字符,那么要配对
              //不一定是前一个字符呀
              if ((ALeftElementText[ANeedCutCharCount-1]>=Char($D800))
                  and (ALeftElementText[ANeedCutCharCount-1]<=Char($DBFF))) then
              begin
//                FMX.Types.Log.d('OrangeUI SplitDrawElement ANeedCutCharCount Happened $D800');
                ANeedCutCharCount:=ANeedCutCharCount+1;
              end
              else
              begin
//                FMX.Types.Log.d('OrangeUI SplitDrawElement ANeedCutCharCount Happened '+IntToStr(Ord(ALeftElementText.Chars[ANeedCutCharCount-1])));
              end;



              ATempStr:=Copy(ALeftElementText,1,ANeedCutCharCount);
//              FMX.Types.Log.d('OrangeUI SplitDrawElement ATempStr 0 '+ATempStr);
              ATempDrawWidth:=ACanvas.TextWidth(ATempStr);
//              FMX.Types.Log.d('OrangeUI SplitDrawElement ATempStr 1 '+ATempStr);



              if ATempDrawWidth<ANeedCutWidth-20 then
              begin
                  //截取的字符串的宽度与所需要的宽度相差太大了,要重新计算


                  //有些情况下,字母数字符号占的宽度小,中文占的宽度大
                  //表情符号是不是占用两个字节
                  ATempStrLength:=Length(ATempStr);
                  I := ATempStrLength;
                  while  I < Length(ALeftElementText) do
                  begin
                      //if(Unicode第一个字节 >=0xD8 && Unicode <=0xDB){
                      //    //这是代理区域，表示第1——16平面的字符。每四个字节表示一个单元
                      //}
                      //else{
                      //    //这是正常映射区域，表示第0个平面。每两个字节表示一个单元。
                      //}

                      if ((ALeftElementText[I]>=Char($D800)) and (ALeftElementText[I]<=Char($DBFF))) then
                      begin
                          //有Unicode要小心,表情符占两个字符
                          //等下一个即可,配好对
                          ATempDrawWidth:=ACanvas.TextWidth(ATempStr+ALeftElementText[I]+ALeftElementText[I+1]);
                      end
                      else
                      begin
                          ATempDrawWidth:=ACanvas.TextWidth(ATempStr+ALeftElementText[I]);
                      end;


                      if ATempDrawWidth>ANeedCutWidth then
                      begin
                        Break;
                      end
                      else
                      begin

                          if ((ALeftElementText[I]>=Char($D800)) and (ALeftElementText[I]<=Char($DBFF))) then
                          begin
//                              //有Unicode要小心,表情符占两个字符
//                              //等下一个即可,配好对
                              ATempStr:=ATempStr+ALeftElementText[I]+ALeftElementText[I+1];
                              ANeedCutCharCount:=ANeedCutCharCount+2;
                              Inc(I);
                          end
                          else
                          begin
                              ATempStr:=ATempStr+ALeftElementText[I];
                              ANeedCutCharCount:=ANeedCutCharCount+1;
                          end;



                      end;

                      Inc(I);
                  end;
              end;




              //超过一行
              //截断
              ADrawElementSplit:=TDrawElementSplit.Create;
              ADrawElementSplit.Parent:=AElement;

              //ANeedCutWidth占几个字符
              //截断到哪个字符串
              ADrawElementSplit.Text:=ATempStr;//ALeftElementText.Substring(0,ANeedCutCharCount);
              ADrawElementSplit.RowIndex:=ARowIndex;

              ANeedCutWidth:=ACanvas.TextWidth(ADrawElementSplit.Text);
              ADrawElementSplit.IsRowEnd:=True;

              ADrawElementSplit.DrawWidth:=ANeedCutWidth;
              ADrawElementSplitList.Add(ADrawElementSplit);
//              ALastDrawElement:=ADrawElementSplit;

//              FMX.Types.Log.d('OrangeUI SplitDrawElement '+ADrawElementSplit.Text);

          end
          else
          begin
              //显示不下了
              ANeedCutWidth:=0;

              //上一个强制换行
              if ADrawElementSplitList.Count>0 then
              begin
                  ADrawElementSplitList[ADrawElementSplitList.Count-1].IsRowEnd:=True;
              end;
          end;



          //换行了,重新开始了
          ADrawWidth:=0;
          ARowIndex:=ARowIndex+1;
          ALeftElementText:=Copy(ALeftElementText,ANeedCutCharCount,MaxInt);
          ALeftElementDrawWidth:=ALeftElementDrawWidth-ANeedCutWidth;
      end;
  end;

  {$ENDIF VCL}

end;



{ TRegExTagLabelViewProperties }

constructor TRegExTagLabelViewProperties.Create(ASkinControl:TControl);
var
  ARegExPatternItem:TRegExPatternItem;
begin
  inherited Create(ASkinControl);
  if Not ASkinControl.GetInterface(IID_ISkinRegExTagLabelView,Self.FSkinRegExTagLabelViewIntf) then
  begin
    ShowException('This Component Do not Support ISkinRegExTagLabelView Interface');
  end
  else
  begin
    FElementList:=TElementList.Create;//TObjectList<TElement>;
    FDrawElementSplitList:=TDrawElementSplitList.Create;
    FRegExPatterns:=TRegExPatterns.Create(TRegExPatternItem);


    ARegExPatternItem:=TRegExPatternItem(FRegExPatterns.Add);
    ARegExPatternItem.Name:='Link';
    ARegExPatternItem.RegEx:=
              '((https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|])'
              +'|'+'(www.[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|])'
                ;

    ARegExPatternItem:=TRegExPatternItem(FRegExPatterns.Add);
    ARegExPatternItem.Name:='@Topic';
    ARegExPatternItem.RegEx:=
                 '#['+Char($4e00)+'-'+Char($9fa5)+'a-zA-Z0-9_-]{2,30}';


    ARegExPatternItem:=TRegExPatternItem(FRegExPatterns.Add);
    ARegExPatternItem.Name:='@User';
    ARegExPatternItem.RegEx:=
                 '@['+Char($4e00)+'-'+Char($9fa5)+'a-zA-Z0-9_-]{2,30}';


    //默认的高度
    ListLayoutsManager.StaticItemHeight:=24;
    Self.ListLayoutsManager.FIsChangeRowOnlyByItemIsRowEnd:=True;


    //不允许滑动
    Self.FVertScrollBarShowType:=TScrollBarShowType.sbstNone;

  end;
end;

destructor TRegExTagLabelViewProperties.Destroy;
begin
  FreeAndNil(FElementList);
  FreeAndNil(FDrawElementSplitList);
  FreeAndNil(FRegExPatterns);

  inherited;
end;

function TRegExTagLabelViewProperties.GetComponentClassify: String;
begin
  Result:='SkinRegExTagLabelView';

end;

procedure TRegExTagLabelViewProperties.LoadDrawElementToItems(
  ADrawElementSplitList: TDrawElementSplitList;
  ASkinItems: TSkinItems);
var
  I:Integer;
  ADrawWidth:Double;
  ADrawElementSplit:TDrawElementSplit;
//  ARowIndex:Integer;
  ASkinItem:TSkinItem;
begin
  //仅添加
  Self.ListLayoutsManager.FIsChangeRowOnlyByItemIsRowEnd:=True;
//  ARowIndex:=0;
  ASkinItems.BeginUpdate;
  try
      ASkinItems.Clear;
      for I := 0 to ADrawElementSplitList.Count-1 do
      begin
          ASkinItem:=TSkinItem(ASkinItems.Add);
          ASkinItem.Width:=ADrawElementSplitList[I].DrawWidth;//+20;
          ASkinItem.Caption:=ADrawElementSplitList[I].Text;
          ASkinItem.FIsRowEnd:=ADrawElementSplitList[I].IsRowEnd;
          if ADrawElementSplitList[I].Parent.RegExPattern<>nil then
          begin
            ASkinItem.Name:=ADrawElementSplitList[I].Parent.RegExPattern.FName;
          end;
          ASkinItem.Data:=ADrawElementSplitList[I];


          if TElement(ADrawElementSplitList[I].Parent).Kind=etText then
          begin
            ASkinItem.ItemType:=sitDefault;
          end
          else
          begin
            ASkinItem.ItemType:=sitItem1;
          end;



    //    if ADrawElementSplitList[I].Text.IndexOf(#13)>=0 then
    //    if ARowIndex<>ADrawElementSplitList[I].RowIndex then
    //    begin
    //      ARowIndex:=ADrawElementSplitList[I].RowIndex;
    //      //有回车才需要加换行
    //      Self.SkinFMXListView1.Prop.AItems[I-1].FIsRowEnd:=True;
    //    end;


      end;

  finally
    ASkinItems.EndUpdate;
  end;

end;

procedure Parse(AInput:String;
  ARegExPatterns:TRegExPatterns;
  AElementList: TElementList//;
//  ADrawElementSplitList: TDrawElementSplitList
  );
var
  I:Integer;
  ALinkPattern:TRegExPatternItem;
//  AInput:String;

  {$IF CompilerVersion <= 21.0} // D2010之前
  FPerlRegEx:TPerlRegEx;
  UTF8HtmlString:UTF8String;
  {$ELSE}
  LRegEx: TRegEx;
  Match: TMatch;
  {$IFEND}


//  AStarChar,AEndChar:Char;

  //记下来下标和长度,以及字符串
  AElement:TElement;
  AStartIndex:Integer;
  ALength:Integer;
  ADrawWidth:Double;
begin
//  //取链接
//  AStarChar:=Char($4e00);//\u4e00;
//  AEndChar:=Char($9fa5);


  AElementList.Clear();
//  ADrawElementSplitList.Clear();



  if AInput='' then
  begin
    Exit;
  end;



  if ARegExPatterns<>nil then
  begin
      for I := 0 to ARegExPatterns.Count-1 do
      begin
          //匹配链接
          ALinkPattern:=ARegExPatterns[I];
    //                '((https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|])'
    //                +'|'+'(www.[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|])'
    //    //            +'|'+'(#[^#]+#)'
    //    //            +'|'+'(@['+AStarChar+'-'+AEndChar+'a-zA-Z0-9_-]{2,30})'
    //                ;

          {$IF CompilerVersion <= 21.0} // D2010之前
          UTF8HtmlString:=AInput;
          FPerlRegEx := TPerlRegEx.Create();
          FPerlRegEx.Subject := UTF8HtmlString;
          FPerlRegEx.RegEx := ALinkPattern.RegEx;//'<body([^>]*)>';
          FPerlRegEx.Options := FPerlRegEx.Options + [preCaseLess, preMultiLine, preUnGreedy];
          while FPerlRegEx.Match do
          begin
        //      Self.Memo2.Lines.Add(Match.Value);
              //置空,避免下次被匹配到
              SpaceStr(AInput,FPerlRegEx.MatchedOffset,FPerlRegEx.MatchedLength);

              AElement:=TElement.Create;
              AElement.Kind:=etLink;
              AElement.Index:=FPerlRegEx.MatchedOffset;
              AElement.Length:=FPerlRegEx.MatchedLength;
              AElement.Text:=FPerlRegEx.MatchedText;
              AElement.RegExPattern:=ALinkPattern;
              AElementList.Add(AElement);

          end;
        //  Self.Memo2.Lines.Add(AInput);
        //  Self.Memo2.Lines.Add('');
          {$ELSE}
          LRegEx := TRegEx.Create(ALinkPattern.RegEx);
          Match := LRegEx.Match(AInput);
          while Match.Success do
          begin
        //      Self.Memo2.Lines.Add(Match.Value);
              //置空,避免下次被匹配到
              SpaceStr(AInput,Match.Index,Match.Length);

              AElement:=TElement.Create;
              AElement.Kind:=etLink;
              AElement.Index:=Match.Index;
              AElement.Length:=Match.Length;
              AElement.Text:=Match.Value;
              AElement.RegExPattern:=ALinkPattern;
              AElementList.Add(AElement);

              Match:=Match.NextMatch;
          end;
        //  Self.Memo2.Lines.Add(AInput);
        //  Self.Memo2.Lines.Add('');
          {$IFEND}



      end;
  end;


  {$IF CompilerVersion <= 21.0} // D2010之前
  UTF8HtmlString:=AInput;
  //添加正常的字符串
  AStartIndex:=-1;
  for I := 1 to Length(UTF8HtmlString) do
  begin
      if (UTF8HtmlString[I]<>#0)
//        or (UTF8HtmlString.Chars[I]<>#13)
        //换行符
        and (UTF8HtmlString[I]<>#10) then
      begin

          if AStartIndex=-1 then
          begin
              //字符串开始
              AStartIndex:=I;
          end;

          if I=Length(UTF8HtmlString) then
          begin
              //字符串结束
              AElement:=TElement.Create;
              AElement.Kind:=etText;
              AElement.Index:=AStartIndex;
              AElement.Length:=I-AStartIndex+1;
              AElement.Text:=Copy(UTF8HtmlString,AElement.Index,AElement.Length);
              AElementList.Add(AElement);

//              FMX.Types.Log.d('OrangeUI Parse '+AElement.Text);

              AStartIndex:=-1;
          end;

      end
      else//=#0
      begin
          //字符串结束
          if (AStartIndex<>-1) then
          begin
              AElement:=TElement.Create;
              AElement.Kind:=etText;
              AElement.Index:=AStartIndex;


              if (UTF8HtmlString[I]=#10) then
              begin
                  AElement.Length:=I-AStartIndex;
                  AElement.Text:=Copy(UTF8HtmlString,AElement.Index,AElement.Length);
              end
              else
              begin
                  AElement.Length:=I-AStartIndex;
                  AElement.Text:=Copy(UTF8HtmlString,AElement.Index,AElement.Length);
              end;


              AElementList.Add(AElement);

//              FMX.Types.Log.d('OrangeUI Parse '+AElement.Text);


              //重新开始找了
              AStartIndex:=-1;
          end;
      end;
  end;
  {$ELSE}
  //添加正常的字符串
  AStartIndex:=-1;
  for I := 0 to AInput.Length-1 do
  begin
      if (AInput.Chars[I]<>#0)
//        or (AInput.Chars[I]<>#13)
        //换行符
        and (AInput.Chars[I]<>#10) then
      begin

          if AStartIndex=-1 then
          begin
              //字符串开始
              AStartIndex:=I;
          end;

          if I=AInput.Length-1 then
          begin
              //字符串结束
              AElement:=TElement.Create;
              AElement.Kind:=etText;
              AElement.Index:=AStartIndex;
              AElement.Length:=I-AStartIndex+1;
              AElement.Text:=AInput.Substring(AElement.Index,AElement.Length);
              AElementList.Add(AElement);

//              FMX.Types.Log.d('OrangeUI Parse '+AElement.Text);

              AStartIndex:=-1;
          end;

      end
      else//=#0
      begin
          //字符串结束
          if (AStartIndex<>-1) then
          begin
              AElement:=TElement.Create;
              AElement.Kind:=etText;
              AElement.Index:=AStartIndex;


              if (AInput.Chars[I]=#10) then
              begin
                  AElement.Length:=I-AStartIndex;
                  AElement.Text:=AInput.Substring(AElement.Index,AElement.Length);
              end
              else
              begin
                  AElement.Length:=I-AStartIndex;
                  AElement.Text:=AInput.Substring(AElement.Index,AElement.Length);
              end;


              AElementList.Add(AElement);

//              FMX.Types.Log.d('OrangeUI Parse '+AElement.Text);


              //重新开始找了
              AStartIndex:=-1;
          end;
      end;
  end;
  {$IFEND}



  //根据下标,排序排好,输出来
  AElementList.Sort(SortByIndex_Compare);
end;

procedure ReAlignDrawElement(ACanvas:TCanvas;
                            ANormalFont:TFont;
                            ATagFont:TFont;
                            AElementList:TElementList;
                            ADrawElementSplitList:TDrawElementSplitList;
                            AControlWidth:TControlSize);
var
  I:Integer;
  ADrawWidth:TControlSize;
//  ADrawElementSplit:TDrawElementSplit;
  ARowIndex:Integer;
//  ANeedCutWidth:Double;
begin
  ADrawWidth:=0;
  ARowIndex:=0;
//  Self.Canvas.Font.Size:=12;

//  {$IFDEF FMX}


  ADrawElementSplitList.Clear();

  for I := 0 to AElementList.Count-1 do
  begin

      if AElementList[I].Kind=etText then
      begin
        //Default
        //字体不一样
        ACanvas.Font.Assign(ANormalFont);//TSkinListViewDefaultMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial).DrawItemCaptionParam.DrawFont);
      end
      else
      begin
        //Item1
        //字体不一样
        ACanvas.Font.Assign(ATagFont);//TSkinListViewDefaultMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial).Item1TypeItemMaterial.DrawItemCaptionParam.DrawFont);
      end;

      //这里很关键,不然显示乱了
      AElementList[I].DrawWidth:=ACanvas.TextWidth(AElementList[I].Text)
                                   //较正宽度
                                   {$IFNDEF MSWINDOWS}+5{$ELSE}+2{$ENDIF};//AElementList[I].Text.Length*1.5
//                                 uSkinBufferBitmap.GetStringWidth(AElementList[I].Text,12)
                                  ;


      //关键是这里,计算每个Item的宽度
      SplitDrawElement(AElementList[I],
                        ADrawElementSplitList,
                        ACanvas,
                        ARowIndex,
                        ADrawWidth,
                        AControlWidth);




//      if TElement(AElementList[I]).Kind=etText then
//      begin
//        Self.Memo2.Lines.Add('Text: '+FloatToStr(AElementList[I].DrawWidth)+' '+TElement(AElementList[I]).Text);
//      end
//      else
//      begin
//        Self.Memo2.Lines.Add('Link: '+FloatToStr(AElementList[I].DrawWidth)+' '+TElement(AElementList[I]).Text);
//      end;


  end;


  //最后一个肯定是行尾的啦，便于我们后面计算
  if ADrawElementSplitList.Count>0 then
  begin
    ADrawElementSplitList[ADrawElementSplitList.Count-1].IsRowEnd:=True;
  end;

//  Panel1.Repaint;
//
//
//
//  Self.SkinFMXListView1.Material.DrawItemBackColorParam.BorderWidth:=0;
//  Self.SkinFMXListView1.Material.Item1TypeItemMaterial.DrawItemBackColorParam.BorderWidth:=0;


//  {$ENDIF FMX}

end;

procedure TRegExTagLabelViewProperties.SetRegExPatterns(const Value: TRegExPatterns);
begin
  FRegExPatterns.Assign(Value);
end;

procedure TRegExTagLabelViewProperties.SetText(const Value: String);
begin
  if FText<>Value then
  begin
    FText := Value;

    Sync;

  end;
end;

procedure TRegExTagLabelViewProperties.Sync;
var
  ANormalFont:TFont;
  ATagFont:TFont;
begin

//    {$IFDEF FMX}

    //解析
    Parse(FText,
                FRegExPatterns,
                FElementList//,
//                FDrawElementSplitList
                );
    ANormalFont:=TSkinListViewDefaultMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial).DrawItemCaptionParam.DrawFont;
    ATagFont:=TSkinListViewDefaultMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial).Item1TypeItemMaterial.DrawItemCaptionParam.DrawFont;


    //拆分
    ReAlignDrawElement(GetGlobalAutoSizeBufferBitmap.DrawCanvas.GetCanvas,
                      ANormalFont,
                      ATagFont,
                      FElementList,
                      FDrawElementSplitList,
                      Self.FSkinControl.Width
                      );

    //加载Items
    LoadDrawElementToItems(FDrawElementSplitList,Items);

//    {$ENDIF FMX}
end;

{ TSkinRegExTagLabelView }

procedure TSkinRegExTagLabelView.BindingItemText(const AName, AText: String;
  ASkinItem: TObject; AIsDrawItemInteractiveState: Boolean);
begin
  Text:=AText;
end;

function TSkinRegExTagLabelView.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TRegExTagLabelViewProperties;
end;

function TSkinRegExTagLabelView.GetRegExTagLabelViewProperties: TRegExTagLabelViewProperties;
begin
  Result:=TRegExTagLabelViewProperties(Self.FProperties);
end;

function TSkinRegExTagLabelView.GetText: String;
begin
  Result:=Prop.Text;
end;

procedure TSkinRegExTagLabelView.SetControlValueByBindItemField(
  const AFieldName: String; const AFieldValue: Variant; ASkinItem: TObject;
  AIsDrawItemInteractiveState: Boolean);
begin
  Text:=AFieldValue;
end;

procedure TSkinRegExTagLabelView.SetRegExTagLabelViewProperties(
  Value: TRegExTagLabelViewProperties);
begin
  Self.FProperties.Assign(Value);
end;

procedure TSkinRegExTagLabelView.SetText(const Value: String);
begin
  Prop.Text:=Value;
end;

{ TElementList }

function TElementList.GetItem(Index: Integer): TElement;
begin
  Result:=TElement(Inherited Items[Index]);
end;

{ TDrawElementSplitList }

function TDrawElementSplitList.GetItem(Index: Integer): TDrawElementSplit;
begin
  Result:=TDrawElementSplit(Inherited Items[Index]);
end;



{ TSkinRegExTagLabelViewDefaultMaterial }

constructor TSkinRegExTagLabelViewDefaultMaterial.Create(AOwner: TComponent);
begin
  inherited;

  Self.Item1TypeItemMaterial.DrawItemCaptionParam.FontColor:=BlueColor;
end;

{ TRegExPatternItem }

procedure TRegExPatternItem.AssignTo(Dest: TPersistent);
begin
  TRegExPatternItem(Dest).Name:=FName;
  TRegExPatternItem(Dest).RegEx:=FRegEx;
end;

procedure TRegExPatternItem.SetName(const Value: String);
begin
  FName := Value;
end;

procedure TRegExPatternItem.SetRegEx(const Value: String);
begin
  FRegEx := Value;
end;

{ TRegExPatterns }

function TRegExPatterns.Add: TRegExPatternItem;
begin
  Result:=TRegExPatternItem(Inherited Add);
end;

function TRegExPatterns.GetItem(Index: Integer): TRegExPatternItem;
begin
  Result:=TRegExPatternItem(Inherited Items[Index]);
end;

procedure TRegExPatterns.SetItem(Index: Integer;
  const Value: TRegExPatternItem);
begin
  Inherited Items[Index]:=Value;

end;

{ TSkinRegExTagLabelViewDefaultType }

constructor TSkinRegExTagLabelViewDefaultType.Create(ASkinControl:TControl);
begin
  inherited;

end;

function TSkinRegExTagLabelViewDefaultType.CustomBind(
  ASkinControl: TControl): Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinRegExTagLabelView,Self.FSkinRegExTagLabelViewIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinRegExTagLabelView Interface');
    end;
  end;

end;

procedure TSkinRegExTagLabelViewDefaultType.SizeChanged;
begin
  inherited;
  Self.FSkinRegExTagLabelViewIntf.Properties.Sync;
end;

end.


