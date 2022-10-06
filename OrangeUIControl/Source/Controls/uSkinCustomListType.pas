/// <summary>
///   <para>
///     �Զ����б��
///   </para>
///   <para>
///     Custom List Box
///   </para>
/// </summary>
unit uSkinCustomListType;


interface
{$I FrameWork.inc}

uses
  Classes,
  SysUtils,
  Types,
  DateUtils,
  Math,
  StrUtils,

  {$IFDEF VCL}
  Messages,
  ExtCtrls,
  Controls,
  Forms,
  StdCtrls,
  Graphics,
  Dialogs,
  {$ENDIF}
  {$IFDEF FMX}
  UITypes,
  FMX.Types,
  FMX.Controls,
  FMX.Dialogs,
  FMX.Graphics,

  FMX.Edit,
  FMX.Memo,
  FMX.ListBox,
  FMX.ComboEdit,
  FMX.Forms,
  {$ENDIF}


  uSkinPicture,
  uFuncCommon,
  uSkinAnimator,
  uBaseList,
  uBaseLog,
  uSkinItems,
  uUrlPicture,
  uDownloadPictureManager,
  uSkinListLayouts,
  uDrawParam,
  uGraphicCommon,
  uSkinBufferBitmap,
  uDrawCanvas,
  uFileCommon,
  uComponentType,
  uDrawEngine,
  uBinaryTreeDoc,
  uDrawPicture,
  uSkinMaterial,
  uDrawTextParam,
  uDrawLineParam,
  uDrawRectParam,
  uSkinImageList,
  uSkinImageType,
  uBasePageStructure,

//  {$IFDEF SKIN_SUPEROBJECT}
  uSkinSuperObject,
//  {$ELSE}
//  XSuperObject,
//  XSuperJson,
//  {$ENDIF}



//  BaseListItemStyleFrame,
  uSkinItemDesignerPanelType,

  {$IFDEF VCL}
//  uSkinWindowsItemDesignerPanel,
  {$ENDIF}
  {$IFDEF FMX}
  uSkinFireMonkeyItemDesignerPanel,
  {$ENDIF}


  uSkinControlGestureManager,
  uSkinControlPanDragGestureManager,
  uSkinScrollControlType,
  uDrawPictureParam;



const
  IID_ISkinCustomList:TGUID='{5DDEC959-1404-4586-878C-B9FA44EEE20C}';


const
  IID_IFrameBaseListItemStyle:TGUID='{5600B7F4-122E-4E7B-AD72-F9F3C3B4CB1D}';
  IID_IFrameBaseListItemStyle_Init:TGUID='{BE00E25C-17BF-42D6-A703-F25F84F86F6D}';


type
  TSkinCustomListLayoutsManagerClass=class of TSkinCustomListLayoutsManager;
  TBaseSkinItemMaterialClass=class of TBaseSkinListItemMaterial;
  TCustomListProperties=class;






  //ListBox.Prop.ItemHeight,
  //�����-1,��ʾ�ǿؼ��ĸ߶�,
  //�����>=0,���ö��پ��Ƕ���
  //ListBox.Prop.ItemWidth,
  //�����-1,��ʾ�ǿؼ��Ŀ��,
  //�����>=0,��ô���ö��پ��Ƕ���


  //TBaseSkinItem.Width,
  //�����-1,��ʾʹ��ListBox.Prop.ItemWidth,
  //�������>=0,��ô���ö��پ��Ƕ���
  //TBaseSkinItem.Height,
  //�����-1,��ʾʹ��ListBox.Prop.ItemHeight,
  //�����>=0,��ô���ö��پ��Ƕ���



  //�༭�б�����¼�
  TCustomListEditingItemEvent=procedure(Sender:TObject;
                                        AItem:TBaseSkinItem;
                                        AEditControl:TChildControl) of object;
  //�����б����¼�
  TCustomListDrawItemEvent=procedure(Sender:TObject;
                                      ACanvas:TDrawCanvas;
                                      AItem:TBaseSkinItem;
                                      AItemDrawRect:TRect) of object;
  //�б�������չ�¼�
  TCustomListClickItemExEvent=procedure(Sender:TObject;
                                        AItem:TBaseSkinItem;
                                        X:Double;Y:Double) of object;
  TCustomListClickItemEvent=procedure(AItem:TBaseSkinItem) of object;
  //ѡ���б�����¼�
  TCustomListDoItemEvent=procedure(Sender:TObject;
                                  AItem:TBaseSkinItem) of object;
  //��������������ӿؼ����¼�
  TCustomListClickItemDesignerPanelChildEvent=procedure(Sender:TObject;
                                        AItem:TBaseSkinItem;//����Ӧ����TBaseSkinItem
                                        AItemDesignerPanel:TItemDesignerPanel;
                                        AChild:TChildControl) of object;
//  //������������ӿؼ��Ƿ���������༭
//  TCustomListItemDesignerPanelChildCanStartEditEvent=procedure(Sender:TObject;
//                                        AItem:TSkinItem;
//                                        AItemDesignerPanel:TSkinItemDesignerPanel;
//                                        AChild:TChildControl;
//                                        var AIsCanStartEditingItem:Boolean) of object;


  //��ʼ�б���ƽ����ʹ�õ�ItemPanDragDesignerPanel
  TCustomListPrepareItemPanDragEvent=procedure(Sender:TObject;
      AItem:TBaseSkinItem;
      var AItemIsCanPanDrag:Boolean) of object;


  TPanDragGestureDirectionType=(
                                ipdgdtLeft,
                                ipdgdtRight//,
//                                ipdgdtTop,
//                                ipdgdtBottom
                                );



  TListItemStyleReg=class;



  /// <summary>
  ///   <para>
  ///     �����б��ӿ�
  ///   </para>
  ///   <para>
  ///     Interface of CustomList Box
  ///   </para>
  /// </summary>
  ISkinCustomList=interface//(ISkinScrollControl)
    ['{5DDEC959-1404-4586-878C-B9FA44EEE20C}']

    function GetOnClickItem: TCustomListClickItemEvent;
    function GetOnLongTapItem: TCustomListDoItemEvent;
    function GetOnClickItemEx: TCustomListClickItemExEvent;
    function GetOnSelectedItem: TCustomListDoItemEvent;
    function GetOnCenterItemChange:TCustomListDoItemEvent;

    function GetOnPrepareDrawItem: TCustomListDrawItemEvent;
    function GetOnAdvancedDrawItem: TCustomListDrawItemEvent;

    function GetOnStartEditingItem: TCustomListEditingItemEvent;
    function GetOnStopEditingItem: TCustomListEditingItemEvent;

    function GetOnPrepareItemPanDrag:TCustomListPrepareItemPanDragEvent;

    function GetOnClickItemDesignerPanelChild:TCustomListClickItemDesignerPanelChildEvent;
//    function GetOnItemDesignerPanelChildCanStartEdit:TCustomListItemDesignerPanelChildCanStartEditEvent;

    function GetOnMouseOverItemChange:TNotifyEvent;
    property OnMouseOverItemChange:TNotifyEvent read GetOnMouseOverItemChange;

    //�����б�������¼�
    property OnCenterItemChange:TCustomListDoItemEvent read GetOnCenterItemChange;

    //����б����¼�
    property OnClickItem:TCustomListClickItemEvent read GetOnClickItem;
    //�����б����¼�
    property OnLongTapItem:TCustomListDoItemEvent read GetOnLongTapItem;
    //����б����¼�
    property OnClickItemEx:TCustomListClickItemExEvent read GetOnClickItemEx;
    //�б��ѡ�е��¼�
    property OnSelectedItem:TCustomListDoItemEvent read GetOnSelectedItem;


    //ÿ�λ����б���֮ǰ׼��
    property OnPrepareDrawItem:TCustomListDrawItemEvent read GetOnPrepareDrawItem;
    //��ǿ�����б����¼�
    property OnAdvancedDrawItem:TCustomListDrawItemEvent read GetOnAdvancedDrawItem;

    //׼��ƽ���¼�(���Ը���Item����ItemPanDragDesignerPanel,�Ƿ�����ƽ�ϵĹ���)
    property OnPrepareItemPanDrag:TCustomListPrepareItemPanDragEvent read GetOnPrepareItemPanDrag;

    //�б��ʼ�༭�¼�
    property OnStartEditingItem:TCustomListEditingItemEvent read GetOnStartEditingItem;
    //�б�������༭�¼�
    property OnStopEditingItem:TCustomListEditingItemEvent read GetOnStopEditingItem;

    //����һ�������干������ListBoxʹ�õ�ʱ��,
    //������ListBox�еĴ��¼��ֱ����Ӧ�Ĳ���
    property OnClickItemDesignerPanelChild:TCustomListClickItemDesignerPanelChildEvent read GetOnClickItemDesignerPanelChild;
//    property OnItemDesignerPanelChildCanStartEdit:TCustomListItemDesignerPanelChildCanStartEditEvent read GetOnItemDesignerPanelChildCanStartEdit;


    function GetCustomListProperties:TCustomListProperties;
    property Properties:TCustomListProperties read GetCustomListProperties;
    property Prop:TCustomListProperties read GetCustomListProperties;
  end;














  TFrameClass=class of TFrame;

  IFrameBaseListItemStyle=interface
    ['{5600B7F4-122E-4E7B-AD72-F9F3C3B4CB1D}']
    function GetItemDesignerPanel:TSkinItemDesignerPanel;

    property ItemDesignerPanel:TSkinItemDesignerPanel read GetItemDesignerPanel;
  end;


  //ͬһ��Frame�������ʽʹ��ʱ,���ݲ�ͬReg.DataObject����ʼ
  IFrameBaseListItemStyle_Init=interface
    ['{BE00E25C-17BF-42D6-A703-F25F84F86F6D}']
    procedure Init(AListItemStyleReg:TListItemStyleReg);
    procedure SetPage(APage:TObject);
  end;



  //�б�����ע����
  TListItemStyleReg=class
  public
    //�������
    Name:String;
    //������Frame,ʹ�õ�ʱ�򴴽�һ��Frame,
    //����ʹ�������ItemDesignerPanel
    FrameClass:TFrameClass;
    //Ĭ���б���߶�
    DefaultItemHeight:Double;
    //�Ƿ���Ҫ����Ӧ�ߴ�
    IsAutoSize:Boolean;
    //�Զ�������,��Frame������ʱ��ʹ�õ�
    DataObject:TObject;
  end;
  TListItemStyleRegList=class(TBaseList)
  private
    function GetItem(Index: Integer): TListItemStyleReg;
  public
    property Items[Index:Integer]:TListItemStyleReg read GetItem;default;
    function FindItemByName(AName:String):TListItemStyleReg;
    function FindItemByClass(AFrameClass:TFrameClass):TListItemStyleReg;
  end;




  //ÿ��ListBox��������Frame�Ļ���
  TListItemStyleFrameCache=class
  public
    //�Ƿ�ʹ��
    FIsUsed:Boolean;
    //���ĸ�Itemʹ����
    FSkinItem:TBaseSkinItem;
    FItemStyleFrame:TFrame;
    FItemStyleFrameIntf:IFrameBaseListItemStyle;
    FItemStyleFrameInitIntf:IFrameBaseListItemStyle_Init;
    destructor Destroy;override;
  end;
  TListItemStyleFrameCacheList=class(TBaseList)
  private
    function GetItem(Index: Integer): TListItemStyleFrameCache;
  public
    property Items[Index:Integer]:TListItemStyleFrameCache read GetItem;default;
  end;

  TListItemTypeStyleSetting=class;
  TNewListItemStyleFrameCacheInitEvent=procedure(Sender:TObject;AListItemTypeStyleSetting:TListItemTypeStyleSetting;ANewListItemStyleFrameCache:TListItemStyleFrameCache) of object;
  //�б������͵ķ������,ÿ������һ��,Default,Item1,Item2,Header,Footer��
  TListItemTypeStyleSetting=class
  private
  private
    //���ڸ��û������ʱָ����������,����ʹ�÷��
    //ԭ����ֱ��ListBox.FItemDesignerPanel,���������õ�StyleSetting.FItemDesignerPanel
    FItemDesignerPanel:TSkinItemDesignerPanel;
  private
    FItemType:TSkinItemType;



    //Ĭ����ʹ�û����
    //ListItemStyleFrame���Ի���,ItemDesignerPanelҲ���Ի����
    FIsUseCache: Boolean;
    //�����б�
    FFrameCacheList:TListItemStyleFrameCacheList;
//    //�Զ����,��ʽ��
//    FCustomBinding: String;



    procedure SetItemDesignerPanel(const Value: TSkinItemDesignerPanel);
    procedure SetStyle(const Value: String);
    procedure SetIsUseUrlStyle(const Value: Boolean);
    procedure SetStyleRootUrl(const Value: String);
    procedure DoDownloadListItemStyleStateChange(Sender:TObject;AUrlCacheItem:TUrlCacheItem);
    procedure SetListItemStyleReg(AListItemStyleReg:TListItemStyleReg);
    procedure SetConfig(const Value: TStringList);
    procedure ReConfig;
  public
    procedure Clear;
    constructor Create(AProp:TCustomListProperties;AItemType:TSkinItemType);
    destructor Destroy;override;
  public
    //0.��ʼ����ʱ,�Ƚ����еĻ��� ���Ϊ��ʹ��,����FIsUsed����ΪFalse,����FSkinItem�����
    procedure MarkAllCacheNoUsed;
    //1.����ӦItem�Ļ�����Ϊʹ��,�һ�����FSkinItem�Լ��Ļ���
    procedure MarkCacheUsed(ASkinItem:TBaseSkinItem);
    //2.����,��ȡItem��Ӧ�Ļ���,
    //��ȡδʹ�õ�Frame,��ռΪ����,����ڻ���ʱû�п��õĻ���ʱ,�ٴ���һ��
    //��ȡ���õ�Frame����
    function GetItemStyleFrameCache(ASkinItem:TBaseSkinItem):TListItemStyleFrameCache;
      function NewListItemStyleFrameCache:TListItemStyleFrameCache;
        //3.��ȡ���õ�������
        function GetInnerItemDesignerPanel(ASkinItem:TBaseSkinItem):TSkinItemDesignerPanel;
  public
    //�Զ������б���ĳߴ�
    function CalcItemAutoSize(AItem: TBaseSkinItem;const ABottomSpace:TControlSize=20): TSizeF;
  public
    //���Ի�����,����ͬһ���б�����ʽ�����õ�ListBoxʹ��,��������ʽ��࣬��ʱ�����ֻ��Ҫ�ĸ�������ɫ֮���
    //��Ȼ��Ҳ������OnPrepareDrawItem�¼��г�ʼ
    FConfig:TStringList;
    //�����
    FStyle:String;
    FStyleRootUrl: String;
    FIsUseUrlStyle: Boolean;
    //���ע����,ʡ�Ĵ�����ʱ��ÿ����
    FListItemStyleReg:TListItemStyleReg;
    FCustomListProperties:TCustomListProperties;

    //�б�����ʽFrame��ʼ�¼�
    FOnInit:TNewListItemStyleFrameCacheInitEvent;
    procedure ResetStyle;

    //�Ƿ�ʹ�û���,Ĭ����ʹ�õ�
    property IsUseCache:Boolean read FIsUseCache write FIsUseCache;
    //�б���������
    property Style:String read FStyle write SetStyle;
    //�б���������
    property ItemDesignerPanel:TSkinItemDesignerPanel read FItemDesignerPanel write SetItemDesignerPanel;


    //property UrlStyle:String read FUrlStyle write SetUrlStyle;
    //�Ƿ�ʹ����Դ����
    property IsUseUrlStyle:Boolean read FIsUseUrlStyle write SetIsUseUrlStyle;
    //��Դ����
    property StyleRootUrl:String read FStyleRootUrl write SetStyleRootUrl;

//    //�Զ����
//    property CustomBinding:String read FCustomBinding write FCustomBinding;
    property Config:TStringList read FConfig write SetConfig;

  end;
  TListItemTypeStyleSettingList=class(TBaseList)
  private
    function GetItem(Index: Integer): TListItemTypeStyleSetting;
  public
    function FindByItemType(AItemType:TSkinItemType):TListItemTypeStyleSetting;
    function FindByStyle(AStyle:String):TListItemTypeStyleSetting;
    property Items[Index:Integer]:TListItemTypeStyleSetting read GetItem;default;
  end;




  //��ȡ�����б�����ʽ���¼�
//  TGetUrlListItemStyleRegEvent=procedure(Sender:TObject;
//                                          AListItemTypeStyleSetting:TListItemTypeStyleSetting;
//                                          AUrlCacheItem:TUrlCacheItem;
//                                          var AListItemStyleReg:TListItemStyleReg);
  TGetUrlListItemStyleRegEvent=procedure(AListItemTypeStyleSetting:TListItemTypeStyleSetting;AOnDownloadStateChange:TDownloadProgressStateChangeEvent);
  TBaseUrlListItemStyle=class(TUrlCacheItem)
  public
    FListItemStyleReg:TListItemStyleReg;
  end;












  /// <summary>
  ///   <para>
  ///     �����б������
  ///   </para>
  ///   <para>
  ///     Properties of CustomList Box
  ///   </para>
  /// </summary>
  TCustomListProperties=class(TScrollControlProperties)
  protected
    //�Ƿ������б����ѡ
    FMultiSelect:Boolean;


    //�Ƿ����б�����Զ�ѡ��
    FIsAutoSelected:Boolean;


    //����ѡ����
    FCenterItem:TBaseSkinItem;
    //�Ƿ����þ���ѡ��ģʽ
    FIsEnabledCenterItemSelectMode: Boolean;


    //��갴�µ��б���
    //��ʱ���������ItemDesignerPanel���ӿؼ���,
    //��ôMouseDownItemΪnil,��Ȼ�б�����е��Ч��
    FMouseDownItem:TBaseSkinItem;
    FInteractiveMouseDownItem:TBaseSkinItem;

    //�ӳٵ���ClickItem�¼���ʹ��
    FLastMouseDownItem:TBaseSkinItem;
    FLastMouseDownX:Double;
    FLastMouseDownY:Double;
    //��갴�µ��б���
    //��ʹ�������ItemDesignerPanel���ӿؼ���,
    //MouseDownItemΪnil,InnerMouseDownItemָ�����������
    FInnerMouseDownItem:TBaseSkinItem;


    //���ͣ�����б���
    FMouseOverItem:TBaseSkinItem;

    //ѡ�е��б���
    FSelectedItem:TBaseSkinItem;



    //ƽ���б����������
    FItemPanDragDesignerPanel: TSkinItemDesignerPanel;
    //ƽ�ϵ��б���
    FPanDragItem:TBaseSkinItem;
    //�Ƿ�����ƽ��
    FEnableItemPanDrag:Boolean;
    //�����б���ƽ�ϵķ���
    FItemPanDragGestureDirection:TPanDragGestureDirectionType;
    //ƽ���б������ƹ���
    FItemPanDragGestureManager:TSkinControlGestureManager;
    //�б����������ػ�����
    FItemDesignerPanelInvalidateLink: TSkinObjectChangeLink;



    //������λ�õ���������
    FAdjustCenterItemPositionAnimator:TSkinAnimator;


    FEmptyContentCaption: String;
    FEmptyContentDescription: String;
    FEmptyContentPicture: TDrawPicture;

    FSkinCustomListIntf:ISkinCustomList;

    FEmptyContentControl: TControl;
    procedure SetEmptyContentControl(const Value: TControl);

    procedure SetMouseDownItem(Value: TBaseSkinItem);
    procedure SetMouseOverItem(Value: TBaseSkinItem);
    procedure SetSelectedItem(Value: TBaseSkinItem);
    procedure SetCenterItem(Value: TBaseSkinItem);
    procedure SetPanDragItem(Value: TBaseSkinItem);


    procedure SetEmptyContentCaption(const Value: String);
    procedure SetEmptyContentDescription(const Value: String);
    procedure SetEmptyContentPicture(const Value: TDrawPicture);

    //��Ҫִ��ԭMouseOverItem.DrawItemDesignerPanel.MouseLeave�¼�
    procedure DoMouseOverItemChange(ANewItem,AOldItem: TBaseSkinItem);virtual;
  protected
    //��ǰ�༭���б���
    FEditingItem:TBaseSkinItem;

    //�����༭�Ŀؼ�(һ����Edit,��Ҳ������ComboBox,ComboEdit,DateEdit��)
    FEditingItem_EditControl:TControl;
    FEditingItem_EditControlIntf:ISkinControl;
    //�󶨿ؼ������ItemDesignerPanel����(���ڰڷ�EditControl��λ��)
    FEditingItem_EditControlPutRect:TRectF;
    //�������������Ϣ�¼�,���԰�����ֵ���ظ�Item
    FEditingItem_EditControl_ItemEditorIntf:ICustomListItemEditor;


    //ԭʼ��Ϣ,���ڽ����༭ʱ�ָ�//
    //ԭParent,�����༭��ʱ�򸳻�ԭParent
    FEditingItem_EditControlOldParent:TChildControl;
    //ԭλ��,�����༭��ʱ�����û�ԭλ��
    FEditingItem_EditControlOldRect:TRectF;
    //ԭAlign,�����༭��ʱ�����û�ԭAlign
    FEditingItem_EditControlOldAlign:TAlignLayout;


    //�����༭��ʱ��ѱ༭���ֵ����Item������
    procedure DoSetValueToEditingItem;virtual;
    //�����༭ʱ����,���һЩ����
    procedure DoStopEditingItemEnd;virtual;


    //�ؼ����ƹ�����λ�ø���,��Ӧ���Ĺ�������λ��
    //����������ʱ���ı༭���λ��
    procedure DoVert_InnerPositionChange(Sender:TObject);override;
    procedure DoHorz_InnerPositionChange(Sender:TObject);override;

    //���±༭�ؼ���λ��(�ڻ��Ƶ�ʱ��)
    procedure SyncEditControlBounds;
  public
    /// <summary>
    ///   <para>
    ///     ��ʼ�༭�б���
    ///   </para>
    ///   <para>
    ///     Start editing ListItem
    ///   </para>
    /// </summary>
    function StartEditingItem(
                                //�༭�ĸ��б���
                                AItem:TBaseSkinItem;
                                //�༭�ؼ�
                                AEditControl:TControl;
                                //�༭�ؼ����λ��
                                AEditControlPutRect:TRectF;
                                //��ʼֵ
                                AEditValue:String;
                                //��������������,����ȷ���������λ��
                                X, Y: Double):Boolean;

    /// <summary>
    ///   <para>
    ///     �����༭�б���
    ///   </para>
    ///   <para>
    ///     Stop editing ListItem
    ///   </para>
    /// </summary>
    procedure StopEditingItem;
    /// <summary>
    ///   <para>
    ///     ȡ���༭�б���
    ///   </para>
    ///   <para>
    ///     Cancel editing ListItem
    ///   </para>
    /// </summary>
    procedure CancelEditingItem;

    /// <summary>
    ///   <para>
    ///     ��ȡ��ǰ�༭����
    ///   </para>
    ///   <para>
    ///     Get editing item
    ///   </para>
    /// </summary>
    property EditingItem:TBaseSkinItem read FEditingItem;
  protected
    //�б���ֹ�����
    FListLayoutsManager:TSkinCustomListLayoutsManager;

    //��ȡ�б���
    function GetItemsClass:TBaseSkinItemsClass;virtual;
    //��ȡ�б��ֹ�����
    function GetCustomListLayoutsManagerClass:TSkinCustomListLayoutsManagerClass;virtual;
  protected
    //FListLayoutsManager������//

    //��ȡ�б���߶�
    function GetItemHeight: Double;
    //��ȡ�б�����
    function GetItemWidth: Double;
    //��ȡ�б�����
    function GetItemSpace: Double;
    //��ȡ�б���������
    function GetItemSpaceType: TSkinItemSpaceType;

    //��ȡ�б���ѡ��ʱ�ĸ߶�
    function GetSelectedItemHeight: Double;
    //��ȡ�б���ѡ��ʱ�Ŀ��
    function GetSelectedItemWidth: Double;


    //�����б���߶�
    procedure SetItemHeight(const Value: Double);
    //�����б�����
    procedure SetItemWidth(const Value: Double);
    //�����б�����
    procedure SetItemSpace(const Value: Double);
    //�����б���������
    procedure SetItemSpaceType(const Value: TSkinItemSpaceType);

    //�����б���ѡ��ʱ�ĸ߶�
    procedure SetSelectedItemHeight(const Value: Double);
    //�����б���ѡ��ʱ�Ŀ��
    procedure SetSelectedItemWidth(const Value: Double);



    //�б���ߴ��������
    function GetItemHeightCalcType: TItemSizeCalcType;
    function GetItemWidthCalcType: TItemSizeCalcType;
    procedure SetItemHeightCalcType(const Value: TItemSizeCalcType);
    procedure SetItemWidthCalcType(const Value: TItemSizeCalcType);

    //�б�����з�ʽ
    function GetItemLayoutType: TItemLayoutType;
    procedure SetItemLayoutType(const Value: TItemLayoutType);

  protected
    //FListLayoutsManager��Ҫ���¼�


    //�ѿؼ��߶ȴ��ݸ�ListLayoutsManager
    function DoGetListLayoutsManagerControlHeight(Sender:TObject):Double;
    //�ѿؼ���ȴ��ݸ�ListLayoutsManager
    function DoGetListLayoutsManagerControlWidth(Sender:TObject):Double;


    //ListLayoutsManager��ѡ��Item���б���ݸ�ListBox
    procedure DoSetListLayoutsManagerSelectedItem(Sender:TObject);


    //ListLayoutsManager���ݳ����б���ߴ�����¼�(��Ҫ���¼������ݳߴ�,�ػ��б�)
    procedure DoItemSizeChange(Sender:TObject);virtual;
    //ListLayoutsManager���ݳ����б������Ը����¼�(�ػ��б�)
    procedure DoItemPropChange(Sender:TObject);virtual;
    //ListLayoutsManager���ݳ����б���������ʾ�����¼�(��Ҫ���¼������ݳߴ�,�ػ��б�)
    procedure DoItemVisibleChange(Sender:TObject);virtual;

  public
    //
    function GetItemTopDrawOffset:Double;virtual;

    //�������ݳߴ�(���ڴ����������Max)
    function CalcContentWidth:Double;override;
    function CalcContentHeight:Double;override;
  protected

    //���б��ֵ
    procedure SetItems(const Value: TBaseSkinItems);

    //�б�����¼�
    procedure DoItemsChange(Sender:TObject);virtual;
    //�б���ɾ���¼�
    procedure DoItemDelete(Sender:TObject;AItem:TObject;AIndex:Integer);virtual;
  protected
    //�����б����¼�����//

    //�Ƿ��Ѿ�������OnLongTapItem�¼�,
    //����Ѿ�������OnLongTapItem�¼�,
    //��ô���ٵ���OnClickItem�¼�
    FHasCalledOnLongTapItem:Boolean;
    //��ⳤ����ʱ��
    FCheckLongTapItemTimer:TTimer;
    //�����೤ʱ���㳤��(Ĭ��һ��)
    FLongTapItemInterval:Integer;


    //�����Ƿ��OnLongTapItem��ֵ���ж��Ƿ���Ҫ��鳤���б����¼�
    Procedure CreateCheckLongTapItemTimer;
    Procedure StartCheckLongTapItemTimer;
    Procedure StopCheckLongTapItemTimer;
    procedure DoCheckLongTapItemTimer(Sender:TObject);

  protected
    //�������Ƿ�סû���ƶ�
    //�ж��Ƿ���Ҫ���ư��µ�Ч��
    //�����갴ס�ƶ���8������
    //��ô��ʾ��ǰ�����ǻ���,�����ǵ��
    FIsStayPressedItem:Boolean;
    FCheckStayPressedItemTimer:TTimer;
    FStayPressedItemInterval:Integer;

    Procedure CreateCheckStayPressedItemTimer;
    Procedure StartCheckStayPressedItemTimer;
    Procedure StopCheckStayPressedItemTimer;
    procedure DoCheckStayPressedItemTimer(Sender:TObject);

  protected
    //�ӳٵ���OnClickItem
    FCallOnClickItemTimer:TTimer;

    Procedure CreateCallOnClickItemTimer;
    Procedure StartCallOnClickItemTimer;
    Procedure StopCallOnClickItemTimer;
    procedure DoCallOnClickItemTimer(Sender:TObject);
  public
    //�б����б�
    FItems:TBaseSkinItems;

    //�Ƿ�����ֹͣ�б���ƽ��
    FIsStopingItemPanDrag:Boolean;

    //�����жϵ�ǰ�б����Ƿ�����ƽ��,��PrepareItemPanDrag��ȷ��
    FIsCurrentMouseDownItemCanPanDrag:Boolean;

    //ƽ���б�����ٶ�
    FStartItemPanDragVelocity:Double;

    //��ʼƽ��
    procedure StartItemPanDrag(AItem:TBaseSkinItem);
    //ֹͣƽ��
    procedure StopItemPanDrag;

    //׼��ƽ���б���,DoItemPanDragGestureManagerFirstMouseDown�е���
    procedure PrepareItemPanDrag(AMouseDownItem:TBaseSkinItem);

    //�Ƿ���������б���ƽ��
    function CanEnableItemPanDrag:Boolean;virtual;
    //�б����Ѿ�ƽ��
    function IsStartedItemPanDrag:Boolean;virtual;


    //ƽ����Ļ��ƾ���
    function GetPanDragItemDrawRect:TRectF;
    //ƽ�������Ļ��ƾ���
    function GetPanDragItemDesignerPanelDrawRect:TRectF;


    //ƽ����������һ�ΰ���,׼��ƽ���б���
    procedure DoItemPanDragGestureManagerFirstMouseDown(Sender:TObject;X,Y:Double);

    //ƽ�����ƿ�ʼ�϶�
    procedure DoItemPanDragGestureManagerStartDrag(Sender:TObject);

    //ƽ������λ�ø���
    procedure DoItemPanDragGestureManagerPositionChange(Sender:TObject);


    //ƽ�����ƹ�������СֵԽ��
    procedure DoItemPanDragGestureManagerMinOverRangePosValueChange(
                                                  Sender:TObject;
                                                  NextValue:Double;
                                                  LastValue:Double;
                                                  Step:Double;
                                                  var NewValue:Double;
                                                  var CanChange:Boolean);
    //ƽ�����ƹ��������ֵԽ��
    procedure DoItemPanDragGestureManagerMaxOverRangePosValueChange(
                                                  Sender:TObject;
                                                  NextValue:Double;
                                                  LastValue:Double;
                                                  Step:Double;
                                                  var NewValue:Double;
                                                  var CanChange:Boolean);

    //������Ҫ���Թ����ľ���
    procedure DoItemPanDragGestureManagerCalcInertiaScrollDistance(
                                                  Sender:TObject;
                                                  var InertiaDistance:Double;
                                                  var CanInertiaScroll:Boolean
                                                  );

    //ƽ���б�����ص���ʼ����
    procedure DoItemPanDragGestureManagerScrollToInitialAnimateEnd(Sender:TObject);

  protected
    //����������¼�(��Ҫ�ػ��б�)
    procedure DoItemDesignerPanelChange(Sender: TObject);

    procedure SetItemPanDragDesignerPanel(const Value: TSkinItemDesignerPanel);

    //�Ƴ��б���������
    procedure RemoveOldDesignerPanel(const AOldItemDesignerPanel: TSkinItemDesignerPanel);
    //����б���������,��������ĵ�ʱ��,ˢ������ListBox
    procedure AddNewDesignerPanel(const ANewItemDesignerPanel: TSkinItemDesignerPanel);
    //�б����������ػ�����
    property ItemDesignerPanelInvalidateLink:TSkinObjectChangeLink read FItemDesignerPanelInvalidateLink;
  protected
    //����б���,TreeView��Ҫ��չ����ʵ���Զ�չ��
    procedure DoClickItem(AItem:TBaseSkinItem;X:Double;Y:Double);virtual;
    //����ѡ�е��б���
    procedure DoSetSelectedItem(Value: TBaseSkinItem);virtual;
    //���þ��е��б���
    procedure DoSetCenterItem(Value: TBaseSkinItem);
  protected
    //�¼�//

    //ƽ���б���׼���¼�
    procedure CallOnPrepareItemPanDrag(Sender:TObject;AItem:TBaseSkinItem; var AItemIsCanPanDrag: Boolean);virtual;

    //���е��б�������¼�
    procedure CallOnCenterItemChangeEvent(Sender:TObject;AItem:TBaseSkinItem);virtual;

    //����б����¼�
    procedure CallOnClickItemEvent(AItem:TBaseSkinItem);virtual;
    //�Ƿ������˳����б����¼�(��Ϊÿ���ؼ����͵�OnLongTapItem��һ��,������Ҫ����)
    function HasOnLongTapItemEvent:Boolean;virtual;
    //�����б����¼�
    procedure CallOnLongTapItemEvent(Sender:TObject;AItem:TBaseSkinItem);virtual;
    //����б�����չ�¼�
    procedure CallOnClickItemExEvent(AItem:TBaseSkinItem;X:Double;Y:Double);virtual;
    //�б��ѡ�е��¼�
    procedure CallOnSelectedItemEvent(Sender:TObject;AItem:TBaseSkinItem);virtual;

    //�б��ʼ�༭�¼�
    procedure CallOnStartEditingItemEvent(Sender:TObject;AItem:TBaseSkinItem;AEditControl:TChildControl);virtual;
    //�б�������༭�¼�
    procedure CallOnStopEditingItemEvent(Sender:TObject;AItem:TBaseSkinItem;AEditControl:TChildControl);virtual;
  public
    //ÿ�λ����б���֮ǰ׼��
    procedure CallOnPrepareDrawItemEvent(
                Sender:TObject;
                ACanvas:TDrawCanvas;
                AItem:TBaseSkinItem;
                AItemDrawRect:TRectF;
                AIsDrawItemInteractiveState:Boolean);virtual;
    //��ǿ�����б����¼�
    procedure CallOnAdvancedDrawItemEvent(
                Sender:TObject;
                ACanvas:TDrawCanvas;
                AItem:TBaseSkinItem;
                AItemDrawRect:TRectF);virtual;

  protected
    //��ȡ��ǰ�������б���,������ʾ�������ϰ�ť���¼���
    function GetInteractiveItem:TBaseSkinItem;
  protected
    //����ѡ����б���
    function GetCenterItem:TBaseSkinItem;

    //����ѡ��ģʽ�Ļ���ƫ��
    function GetCenterItemSelectModeTopDrawOffset:Double;
    function GetCenterItemSelectModeLeftDrawOffset:Double;

    //�Ƿ����þ���ѡ��ģʽ
    procedure SetIsEnabledCenterItemSelectMode(const Value: Boolean);


    //���Խ����,��ô���ر߽�,�ص�
    procedure DoAdjustCenterItemPositionAnimate(Sender:TObject);
    //���ر߽�����¼�
    procedure DoAdjustCenterItemPositionAnimateBegin(Sender:TObject);

    //����ѡ��ʱ,���ص���ʼ����
    procedure DoVert_InnerScrollToInitialAnimateEnd(Sender:TObject);override;
    procedure DoHorz_InnerScrollToInitialAnimateEnd(Sender:TObject);override;
  private
    FIsEmptyContent: Boolean;
    procedure SetIsEmptyContent(const Value: Boolean);
  protected

    //����ƽ̨�Ŀ������Ҫʹ�õ�,�洢��ͬ�ؼ�����������,������ÿ�����Զ��Ӹ��ֶεİ�,��˵�ǲ���
    procedure GetPropJson(ASuperObject:ISuperObject);override;
    procedure SetPropJson(ASuperObject:ISuperObject);override;

    //��ֵ
    procedure AssignProperties(Src:TSkinControlProperties);override;
    //��ȡ��������
    function GetComponentClassify:String;override;
  public
    constructor Create(ASkinControl:TControl);override;
    destructor Destroy;override;
  public
    //�����б���ķ��
    function SetListBoxItemStyle(AItemType:TSkinItemType;
                                  AListItemStyle:String):Boolean;virtual;
    //��������ѡ���б����λ��(��Ҫ�ھ���ѡ�񻬶�ʱȷ����ѡ���Item)
    procedure DoAdjustCenterItemPositionAnimateEnd(Sender:TObject);
  public
    /// <summary>
    ///   <para>
    ///     �б���ֹ�����
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ListLayoutsManager:TSkinCustomListLayoutsManager read FListLayoutsManager;

    /// <summary>
    ///   <para>
    ///     ������ָ���б���
    ///   </para>
    ///   <para>
    ///     Scroll to assigned ListItem
    ///   </para>
    /// </summary>
    procedure ScrollToItem(Item: TBaseSkinItem);
    /// <summary>
    ///   <para>
    ///     ��ȡ�б���Ŀ��
    ///   </para>
    ///   <para>
    ///     Get ListItem's width
    ///   </para>
    /// </summary>
    function CalcItemWidth(AItem:TBaseSkinItem):Double;
    /// <summary>
    ///   <para>
    ///     ��ȡ�б���ĸ߶�
    ///   </para>
    ///   <para>
    ///     Get ListItem's height
    ///   </para>
    /// </summary>
    function CalcItemHeight(AItem:TBaseSkinItem):Double;

    /// <summary>
    ///   <para>
    ///     �����б����λ��(�̶�)
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    function GetCenterItemRect:TRectF;

    /// <summary>
    ///   <para>
    ///     ��ȡ�б������ڵľ���(TreeView��Ҫ��,ֻ��ItemDrawRect()�б�����)
    ///   </para>
    ///   <para>
    ///     Get ListItem's rectangle
    ///   </para>
    /// </summary>
    function VisibleItemRect(AVisibleItemIndex:Integer): TRectF;virtual;
    /// <summary>
    ///   <para>
    ///     �б������ڵĻ��ƾ���(TreeView��Ҫ��)
    ///   </para>
    ///   <para>
    ///     ListItem's draw rectangle
    ///   </para>
    /// </summary>
    function VisibleItemDrawRect(AVisibleItemIndex:Integer): TRectF;overload;
    /// <summary>
    ///   <para>
    ///     ��ȡ�б������ڵĻ��ƾ���
    ///   </para>
    ///   <para>
    ///     Get ListItem's draw rectangle
    ///   </para>
    /// </summary>
    function VisibleItemDrawRect(AVisibleItem:TBaseSkinItem): TRectF;overload;
    /// <summary>
    ///   <para>
    ///     ��ȡ�������ڵ��б���
    ///   </para>
    ///   <para>
    ///     Get ListItem's draw rectangle
    ///   </para>
    /// </summary>
    function VisibleItemIndexAt(X, Y: Double):Integer;
    /// <summary>
    ///   <para>
    ///     ��ȡ�������ڵ��б���
    ///   </para>
    ///   <para>
    ///     Get ListItem's draw rectangle
    ///   </para>
    /// </summary>
    function VisibleItemAt(X, Y: Double):TBaseSkinItem;
  public

    /// <summary>
    ///   <para>
    ///     ��ȡ��ǰ��������
    ///   </para>
    ///   <para>
    ///     Get interactive Item
    ///   </para>
    /// </summary>
    property InteractiveItem:TBaseSkinItem read GetInteractiveItem;

    /// <summary>
    ///   <para>
    ///     ѡ�е��б���
    ///   </para>
    ///   <para>
    ///     Selected ListItem
    ///   </para>
    /// </summary>
    property SelectedItem:TBaseSkinItem read FSelectedItem write SetSelectedItem;

    /// <summary>
    ///   <para>
    ///     ��갴�µ��б���
    ///   </para>
    ///   <para>
    ///     Pressed ListItem
    ///   </para>
    /// </summary>
    property MouseDownItem:TBaseSkinItem read FMouseDownItem write SetMouseDownItem;
    property InnerMouseDownItem:TBaseSkinItem read FInnerMouseDownItem write FInnerMouseDownItem;

    /// <summary>
    ///   <para>
    ///     ���е��б���
    ///   </para>
    ///   <para>
    ///     Centered ListItem
    ///   </para>
    /// </summary>
    property CenterItem:TBaseSkinItem read GetCenterItem write SetCenterItem;

    /// <summary>
    ///   <para>
    ///     ͣ�����б���
    ///   </para>
    ///   <para>
    ///     Hovered :ListItem
    ///   </para>
    /// </summary>
    property MouseOverItem:TBaseSkinItem read FMouseOverItem write SetMouseOverItem;
    /// <summary>
    ///   <para>
    ///     ƽ�ϵ��б���
    ///   </para>
    ///   <para>
    ///     PanDragged ListItem
    ///   </para>
    /// </summary>
    property PanDragItem:TBaseSkinItem read FPanDragItem write SetPanDragItem;
    /// <summary>
    ///   <para>
    ///     ƽ���б�������ƹ���
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ItemPanDragGestureManager:TSkinControlGestureManager read FItemPanDragGestureManager;
    /// <summary>
    ///   <para>
    ///     �����б���ƽ��
    ///   </para>
    ///   <para>
    ///     Enable Item PanDrag
    ///   </para>
    /// </summary>
    property EnableItemPanDrag:Boolean read FEnableItemPanDrag write FEnableItemPanDrag;//SetEnableItemPanDrag;
  public
    //���಻����������

    /// <summary>
    ///   <para>
    ///     ѡ�е��б�����
    ///   </para>
    ///   <para>
    ///     Selected ListItem's width
    ///   </para>
    /// </summary>
    property SelectedItemWidth:Double read GetSelectedItemWidth write SetSelectedItemWidth;
    /// <summary>
    ///   <para>
    ///     �б����ȼ��㷽ʽ
    ///   </para>
    ///   <para>
    ///     Calculate type of LIstItem width
    ///   </para>
    /// </summary>
    property ItemWidthCalcType:TItemSizeCalcType read GetItemWidthCalcType write SetItemWidthCalcType;
    /// <summary>
    ///   <para>
    ///     �б������������
    ///   </para>
    ///   <para>
    ///     ListItem's layout type
    ///   </para>
    /// </summary>
    property ItemLayoutType:TItemLayoutType read GetItemLayoutType write SetItemLayoutType;
    /// <summary>
    ///   <para>
    ///     �б����б�
    ///   </para>
    ///   <para>
    ///     List of ListItem
    ///   </para>
    /// </summary>
    property Items:TBaseSkinItems read FItems write SetItems;

    /// <summary>
    ///   <para>
    ///     �Ƿ����þ���ѡ��ģʽ
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property IsEnabledCenterItemSelectMode:Boolean read FIsEnabledCenterItemSelectMode write SetIsEnabledCenterItemSelectMode;

    /// <summary>
    ///   <para>
    ///     �б�����
    ///   </para>
    ///   <para>
    ///     ListItem's width
    ///   </para>
    /// </summary>
    property ItemWidth:Double read GetItemWidth write SetItemWidth;
  published
    /// <summary>
    ///   <para>
    ///     ��ֱ��������ʾ����
    ///   </para>
    ///   <para>
    ///     ShowType of vertical scrollbar
    ///   </para>
    /// </summary>
    property VertScrollBarShowType;
    /// <summary>
    ///   <para>
    ///     ˮƽ��������ʾ����
    ///   </para>
    ///   <para>
    ///     ShowType of horizontal scrollbar
    ///   </para>
    /// </summary>
    property HorzScrollBarShowType;
    /// <summary>
    ///   <para>
    ///     ���ö�ѡ
    ///   </para>
    ///   <para>
    ///     Enable multiselect
    ///   </para>
    /// </summary>
    property MultiSelect:Boolean read FMultiSelect write FMultiSelect;
    /// <summary>
    ///   <para>
    ///     �������ʱ���Ƿ��Զ�ѡ���б���
    ///   </para>
    ///   <para>
    ///     Whether select ListItem automatically
    ///   </para>
    ///   <para>
    ///     when mouse clicking
    ///   </para>
    /// </summary>
    property IsAutoSelected:Boolean read FIsAutoSelected write FIsAutoSelected ;//default True;

    /// <summary>
    ///   <para>
    ///     �б���߶�
    ///   </para>
    ///   <para>
    ///     ListItem's height
    ///   </para>
    /// </summary>
    property ItemHeight:Double read GetItemHeight write SetItemHeight;

    /// <summary>
    ///   <para>
    ///     �б�����
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ItemSpace:Double read GetItemSpace write SetItemSpace;
    /// <summary>
    ///   <para>
    ///     �б���������
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ItemSpaceType:TSkinItemSpaceType read GetItemSpaceType write SetItemSpaceType;
    /// <summary>
    ///   <para>
    ///     ѡ�е��б���߶�
    ///   </para>
    ///   <para>
    ///     Selected ListItem's height
    ///   </para>
    /// </summary>
    property SelectedItemHeight:Double read GetSelectedItemHeight write SetSelectedItemHeight;
    /// <summary>
    ///   <para>
    ///     �б���߶ȼ��㷽ʽ
    ///   </para>
    ///   <para>
    ///     Calculate type of ListItem height
    ///   </para>
    /// </summary>
    property ItemHeightCalcType:TItemSizeCalcType read GetItemHeightCalcType write SetItemHeightCalcType;

    /// <summary>
    ///   <para>
    ///     ƽ���б���ķ���
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ItemPanDragGestureDirection:TPanDragGestureDirectionType read FItemPanDragGestureDirection write FItemPanDragGestureDirection;

    /// <summary>
    ///   <para>
    ///     ƽ���б����������(���ڷ�ɾ����ť��)
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ItemPanDragDesignerPanel: TSkinItemDesignerPanel read FItemPanDragDesignerPanel write SetItemPanDragDesignerPanel;

    //�հ�����ʱ��
    property IsEmptyContent:Boolean read FIsEmptyContent write SetIsEmptyContent;
    property EmptyContentControl:TControl read FEmptyContentControl write SetEmptyContentControl;
    property EmptyContentPicture:TDrawPicture read FEmptyContentPicture write SetEmptyContentPicture;
    property EmptyContentCaption:String read FEmptyContentCaption write SetEmptyContentCaption;
    property EmptyContentDescription:String read FEmptyContentDescription write SetEmptyContentDescription;
  end;








  //�б����زĻ���
  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TBaseSkinListItemMaterial=class(TSkinMaterial)
  protected
    //������ɫ���Ʋ���
    FDrawItemBackColorParam:TDrawRectParam;
    //����ͼƬ���Ʋ���
    FDrawItemBackGndPictureParam:TDrawPictureParam;


    //չ��ͼƬ
    FItemAccessoryPicture:TDrawPicture;
    //չ��ͼƬ���Ʋ���
    FDrawItemAccessoryPictureParam:TDrawPictureParam;



    //����״̬ͼƬ
    FItemBackNormalPicture: TDrawPicture;
    //���ͣ��״̬ͼƬ
    FItemBackHoverPicture: TDrawPicture;
    //��갴��״̬ͼƬ
    FItemBackDownPicture: TDrawPicture;
    //����״̬ͼƬ
    FItemBackPushedPicture: TDrawPicture;

//    //����״̬ͼƬ
//    FItemBackDisabledPicture: TDrawPicture;
//    //�õ�����״̬ͼƬ
//    FItemBackFocusedPicture: TDrawPicture;


    procedure SetItemBackPushedPicture(const Value: TDrawPicture);
    procedure SetItemBackHoverPicture(const Value: TDrawPicture);
    procedure SetItemBackNormalPicture(const Value: TDrawPicture);
    procedure SetItemBackDownPicture(const Value: TDrawPicture);
//    procedure SetItemBackDisabledPicture(const Value: TDrawPicture);
//    procedure SetItemBackFocusedPicture(const Value: TDrawPicture);

    procedure SetItemAccessoryPicture(const Value:TDrawPicture);
    procedure SetDrawItemAccessoryPictureParam(const Value: TDrawPictureParam);

    procedure SetDrawItemBackColorParam(const Value: TDrawRectParam);
    procedure SetDrawItemBackGndPictureParam(const Value: TDrawPictureParam);
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published


    /// <summary>
    ///   <para>
    ///     �б����չ��ͼƬ
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ItemAccessoryPicture:TDrawPicture read FItemAccessoryPicture write SetItemAccessoryPicture;
    /// <summary>
    ///   <para>
    ///     �б����չ��ͼƬ���Ʋ���
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawItemAccessoryPictureParam:TDrawPictureParam read FDrawItemAccessoryPictureParam write SetDrawItemAccessoryPictureParam;
    /// <summary>
    ///   <para>
    ///     �б��������״̬ͼƬ
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ItemBackNormalPicture:TDrawPicture read FItemBackNormalPicture write SetItemBackNormalPicture;

    /// <summary>
    ///   <para>
    ///     �б�������ͣ��״̬ͼƬ
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ItemBackHoverPicture:TDrawPicture read FItemBackHoverPicture write SetItemBackHoverPicture;

    /// <summary>
    ///   <para>
    ///     �б������갴��״̬ͼƬ
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ItemBackDownPicture: TDrawPicture read FItemBackDownPicture write SetItemBackDownPicture;
//    //�б���Ľ���״̬ͼƬ
//    property ItemBackDisabledPicture: TDrawPicture read FItemBackDisabledPicture write SetItemBackDisabledPicture;
//    //�б���ĵõ�����״̬ͼƬ
//    property ItemBackFocusedPicture: TDrawPicture read FItemBackFocusedPicture write SetItemBackFocusedPicture;

    /// <summary>
    ///   <para>
    ///     �б���İ���״̬ͼƬ
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ItemBackPushedPicture:TDrawPicture read FItemBackPushedPicture write SetItemBackPushedPicture;

    /// <summary>
    ///   <para>
    ///     �б���ı�����ɫ���Ʋ���
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawItemBackColorParam:TDrawRectParam read FDrawItemBackColorParam write SetDrawItemBackColorParam;

    /// <summary>
    ///   <para>
    ///     �б���ı���ͼƬ���Ʋ���
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawItemBackGndPictureParam:TDrawPictureParam read FDrawItemBackGndPictureParam write SetDrawItemBackGndPictureParam;
  end;






  //�б��زĻ���
  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinCustomListDefaultMaterial=class(TSkinScrollControlDefaultMaterial)
  protected
    //�ָ���
    FDrawItemDevideParam:TDrawRectParam;
    FDrawItemDevideLineParam:TDrawLineParam;


    //ֻ�Ǽ򵥵Ļ�һ��һ�����ص�ֱ��
    FIsSimpleDrawItemDevide: Boolean;

    //�Ƿ�������������
    FIsDrawCenterItemRect: Boolean;
    //��������λ��Ʋ���
    FDrawCenterItemRectParam: TDrawRectParam;


    //Ĭ�������б�������ز�
    FDefaultTypeItemMaterial:TBaseSkinListItemMaterial;
    FItem1TypeItemMaterial:TBaseSkinListItemMaterial;

    FDrawEmptyContentCaptionParam: TDrawTextParam;
    FDrawEmptyContentDescriptionParam: TDrawTextParam;
    FDrawEmptyContentPictureParam: TDrawPictureParam;

    //Ĭ�����͵��б�����Ʒ��TBaseSkinListItemMaterial��StyleName
    FDefaultTypeItemStyle: String;


    procedure SetDrawEmptyContentCaptionParam(const Value: TDrawTextParam);
    procedure SetDrawEmptyContentDescriptionParam(const Value: TDrawTextParam);
    procedure SetDrawEmptyContentPictureParam(const Value: TDrawPictureParam);

    function GetItemBackHoverPicture: TDrawPicture;
    function GetItemBackNormalPicture: TDrawPicture;
    function GetItemBackPushedPicture: TDrawPicture;
    function GetItemBackDownPicture: TDrawPicture;

    function GetDrawItemBackColorParam: TDrawRectParam;
    function GetDrawItemBackGndPictureParam: TDrawPictureParam;

    function GetItemAccessoryPicture: TDrawPicture;
    function GetDrawItemAccessoryPictureParam: TDrawPictureParam;

    procedure SetItemBackPushedPicture(const Value: TDrawPicture);
    procedure SetItemBackHoverPicture(const Value: TDrawPicture);
    procedure SetItemBackNormalPicture(const Value: TDrawPicture);
    procedure SetItemBackDownPicture(const Value: TDrawPicture);
//    procedure SetItemBackDisabledPicture(const Value: TDrawPicture);
//    procedure SetItemBackFocusedPicture(const Value: TDrawPicture);

    procedure SetDrawItemBackGndPictureParam(const Value: TDrawPictureParam);
    procedure SetDrawItemBackColorParam(const Value: TDrawRectParam);

    procedure SetItemAccessoryPicture(const Value:TDrawPicture);
    procedure SetDrawItemAccessoryPictureParam(const Value: TDrawPictureParam);

  protected
    procedure SetIsDrawCenterItemRect(const Value: Boolean);
    procedure SetDrawCenterItemRectParam(const Value: TDrawRectParam);

    procedure SetDrawItemDevideParam(const Value: TDrawRectParam);
    procedure SetIsSimpleDrawItemDevide(const Value: Boolean);

    procedure SetDefaultTypeItemMaterial(const Value: TBaseSkinListItemMaterial);
    procedure SetItem1TypeItemMaterial(const Value: TBaseSkinListItemMaterial);

    procedure SetDefaultTypeItemStyle(const Value: String);
  protected
    FItemMaterialChangeLink:TSkinObjectChangeLink;

    procedure AssignTo(Dest: TPersistent); override;

    //��ȡ�б����زĻ���
    function GetSkinCustomListItemMaterialClass:TBaseSkinItemMaterialClass;virtual;

  protected
    //���ĵ��ڵ��м���
    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;override;
    //���浽�ĵ��ڵ�
    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;override;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public

    /// <summary>
    ///   <para>
    ///     �б��������״̬ͼƬ
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ItemBackNormalPicture:TDrawPicture read GetItemBackNormalPicture write SetItemBackNormalPicture;
    /// <summary>
    ///   <para>
    ///     �б�������ͣ��״̬ͼƬ
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ItemBackHoverPicture:TDrawPicture read GetItemBackHoverPicture write SetItemBackHoverPicture;

    /// <summary>
    ///   <para>
    ///     �б������갴��״̬ͼƬ
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ItemBackDownPicture: TDrawPicture read GetItemBackDownPicture write SetItemBackDownPicture;
//    //�б���Ľ���״̬ͼƬ
//    property ItemBackDisabledPicture: TDrawPicture read GetItemBackDisabledPicture write SetItemBackDisabledPicture;
//    //�б���ĵõ�����״̬ͼƬ
//    property ItemBackFocusedPicture: TDrawPicture read GetItemBackFocusedPicture write SetItemBackFocusedPicture;

    /// <summary>
    ///   <para>
    ///     �б���İ���״̬ͼƬ
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ItemBackPushedPicture:TDrawPicture read GetItemBackPushedPicture write SetItemBackPushedPicture;
    /// <summary>
    ///   <para>
    ///     �б���ı�����ɫ���Ʋ���
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawItemBackColorParam:TDrawRectParam read GetDrawItemBackColorParam write SetDrawItemBackColorParam;

    /// <summary>
    ///   <para>
    ///     �б���ı���ͼƬ���Ʋ���
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawItemBackGndPictureParam:TDrawPictureParam read GetDrawItemBackGndPictureParam write SetDrawItemBackGndPictureParam;
    /// <summary>
    ///   <para>
    ///     �б����չ��ͼƬ
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ItemAccessoryPicture:TDrawPicture read GetItemAccessoryPicture write SetItemAccessoryPicture;

    /// <summary>
    ///   <para>
    ///     �б����չ��ͼƬ���Ʋ���
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawItemAccessoryPictureParam:TDrawPictureParam read GetDrawItemAccessoryPictureParam write SetDrawItemAccessoryPictureParam;
  public


    //Ĭ�������б���ķ��TBaseSkinListItemMaterial��StyleName,���Ա���̭��
    property DefaultTypeItemStyle:String read FDefaultTypeItemStyle write SetDefaultTypeItemStyle;


    /// <summary>
    ///   <para>
    ///     Ĭ�������б�������ز�
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DefaultTypeItemMaterial:TBaseSkinListItemMaterial read FDefaultTypeItemMaterial write SetDefaultTypeItemMaterial;
    property Item1TypeItemMaterial:TBaseSkinListItemMaterial read FItem1TypeItemMaterial write SetItem1TypeItemMaterial;

    /// <summary>
    ///   <para>
    ///     �Ƿ�������ľ��ο�
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property IsDrawCenterItemRect:Boolean read FIsDrawCenterItemRect write SetIsDrawCenterItemRect;

    /// <summary>
    ///   <para>
    ///     ���ľ��ο���Ʋ���
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawCenterItemRectParam:TDrawRectParam read FDrawCenterItemRectParam write SetDrawCenterItemRectParam;

    /// <summary>
    ///   <para>
    ///     �Ƿ�򵥻��Ʒָ���
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property IsSimpleDrawItemDevide:Boolean read FIsSimpleDrawItemDevide write SetIsSimpleDrawItemDevide ;//default True;

    /// <summary>
    ///   <para>
    ///     �ָ��߻��Ʋ���
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawItemDevideParam:TDrawRectParam read FDrawItemDevideParam write SetDrawItemDevideParam;
  published
    //����Ϊ��ʱ�ı���
    property DrawEmptyContentCaptionParam: TDrawTextParam read FDrawEmptyContentCaptionParam write SetDrawEmptyContentCaptionParam;
    //����Ϊ��ʱ������
    property DrawEmptyContentDescriptionParam: TDrawTextParam read FDrawEmptyContentDescriptionParam write SetDrawEmptyContentDescriptionParam;
    //����Ϊ��ʱ��ͼƬ
    property DrawEmptyContentPictureParam: TDrawPictureParam read FDrawEmptyContentPictureParam write SetDrawEmptyContentPictureParam;
  end;






  //�б���ؼ����ͻ���
  TSkinCustomListDefaultType=class(TSkinScrollControlDefaultType)
  public

    //���ƿ�ʼ�ͽ�����
    FDrawStartIndex:Integer;
    FDrawEndIndex:Integer;

    //��һ��������
    FFirstDrawItem:TBaseSkinItem;
    FFirstDrawItemRect:TRectF;

    //���һ�еĻ�����
    FLastColDrawItem:TBaseSkinItem;
    FLastColDrawItemRect:TRectF;

    //���һ��������
    FLastRowDrawItem:TBaseSkinItem;
    FLastRowDrawItemRect:TRectF;


    FSkinCustomListIntf:ISkinCustomList;

  protected
    //���ڴ���ItemDsignerPanel���¼�
    //�����б����������¼�
    //�ж�������¼��Ƿ��б����ItemDesignerPanel������
    function DoProcessItemCustomMouseDown(AMouseOverItem:TBaseSkinItem;
                                          AItemDrawRect:TRectF;
                                          Button: TMouseButton; Shift: TShiftState;X, Y: Double):Boolean;virtual;
    //���ڴ���ItemDsignerPanel���¼�
    //�����б���������Ϣ
    //�ж������Ϣ�Ƿ��б����DrawItemDesignerPanel������ӿؼ�����
    function DoProcessItemCustomMouseUp(AMouseDownItem:TBaseSkinItem;
                                        Button: TMouseButton; Shift: TShiftState;X, Y: Double):Boolean;virtual;
    //���ڴ���ItemDsignerPanel���¼�
    function DoProcessItemCustomMouseMove(AMouseOverItem:TBaseSkinItem;
                                          Shift: TShiftState;X,Y:Double):Boolean;virtual;
    //���ڴ���ItemDsignerPanel���¼�
    procedure DoProcessItemCustomMouseLeave(AMouseLeaveItem:TBaseSkinItem);virtual;

  protected
    procedure CustomMouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Double);override;
    procedure CustomMouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Double);override;
    procedure CustomMouseMove(Shift: TShiftState;X,Y:Double);override;
    procedure CustomMouseEnter;override;
    procedure CustomMouseLeave;override;

    procedure SizeChanged;override;
  protected
    //�󶨶���
    function CustomBind(ASkinControl:TControl):Boolean;override;
    //�����
    procedure CustomUnBind;override;
  protected
    function GetSkinMaterial:TSkinCustomListDefaultMaterial;
    //�����б�����ʹ�õ��ز�
    function DecideItemMaterial(AItem:TBaseSkinItem;ASkinMaterial:TSkinCustomListDefaultMaterial): TBaseSkinListItemMaterial;virtual;


    //�Զ�����Ʒ���
    function CustomPaintContent(ACanvas:TDrawCanvas;
                                ASkinMaterial:TSkinControlMaterial;
                                const ADrawRect:TRectF;
                                APaintData:TPaintData
                                ):Boolean;override;
    //�Զ�����Ʒ���-׼��
    function CustomPaintContentBegin(ACanvas:TDrawCanvas;
                                    ASkinMaterial:TSkinControlMaterial;
                                    const ADrawRect:TRectF;
                                    APaintData:TPaintData
                                    ):Boolean;virtual;
    procedure MarkAllListItemTypeStyleSettingCacheUnUsed(
                        //��ʼ�±�
                        ADrawStartIndex:Integer;
                        ADrawEndIndex:Integer);virtual;
    //����ָ����ʼ�±���б���
    function PaintItems(ACanvas:TDrawCanvas;
                        ASkinMaterial:TSkinControlMaterial;
                        const ADrawRect:TRectF;
                        AControlClientRect:TRectF;

                        //����ѡ����ƫ��
                        ADrawRectCenterItemSelectModeTopOffset,
                        ADrawRectCenterItemSelectModeLeftOffset,

                        //�������ݵ�ƫ��
                        ADrawRectTopOffset,
                        ADrawRectLeftOffset,
                        ADrawRectRightOffset,
                        ADrawRectBottomOffset:Double;

                        //��ʼ�±�
                        ADrawStartIndex:Integer;
                        ADrawEndIndex:Integer;

                        APaintData:TPaintData
                        ):Boolean;
    //����Item
    function PaintItem(ACanvas: TDrawCanvas;
                        AItemIndex:Integer;
                        AItem:TBaseSkinItem;
                        AItemDrawRect:TRectF;
                        ASkinMaterial:TSkinCustomListDefaultMaterial;
                        const ADrawRect: TRectF;
                        ACustomListPaintData:TPaintData
                        ): Boolean;
    //����Item��״̬
    function ProcessItemDrawEffectStates(AItem:TBaseSkinItem):TDPEffectStates;virtual;
    //����Item���Ʋ���
    procedure ProcessItemDrawParams(ASkinMaterial:TSkinCustomListDefaultMaterial;
                                    ASkinItemMaterial:TBaseSkinListItemMaterial;
                                    AItemEffectStates:TDPEffectStates);virtual;
    //׼��,����OnPrepareDrawItem�¼�
    function CustomDrawItemBegin(ACanvas: TDrawCanvas;
                                  AItemIndex:Integer;
                                  AItem:TBaseSkinItem;
                                  AItemDrawRect:TRectF;
                                  ASkinMaterial:TSkinCustomListDefaultMaterial;
                                  const ADrawRect: TRectF;
                                  ACustomListPaintData:TPaintData;
                                  ASkinItemMaterial:TBaseSkinListItemMaterial;
                                  AItemEffectStates:TDPEffectStates;
                                  AIsDrawItemInteractiveState:Boolean
                                  ): Boolean;virtual;
    //��������(���Ʊ���ɫ)
    function CustomDrawItemContent(ACanvas: TDrawCanvas;
                                    AItemIndex:Integer;
                                    AItem:TBaseSkinItem;
                                    AItemDrawRect:TRectF;
                                    ASkinMaterial:TSkinCustomListDefaultMaterial;
                                    const ADrawRect: TRectF;
                                    ACustomListPaintData:TPaintData;
                                    ASkinItemMaterial:TBaseSkinListItemMaterial;
                                    AItemEffectStates:TDPEffectStates;
                                    AIsDrawItemInteractiveState:Boolean
                                    ): Boolean;virtual;
    //������ʼ�ָ���
    function CustomDrawItemEnd(ACanvas: TDrawCanvas;
                                AItemIndex:Integer;
                                AItem:TBaseSkinItem;
                                AItemDrawRect:TRectF;
                                ASkinMaterial:TSkinCustomListDefaultMaterial;
                                const ADrawRect: TRectF;
                                ACustomListPaintData:TPaintData;
                                ASkinItemMaterial:TBaseSkinListItemMaterial;
                                AItemEffectStates:TDPEffectStates;
                                AIsDrawItemInteractiveState:Boolean
                                ): Boolean;virtual;

    //����ListView���зָ���
    function AdvancedCustomPaintContent(ACanvas:TDrawCanvas;
                                        ASkinMaterial:TSkinControlMaterial;
                                        const ADrawRect:TRectF;
                                        APaintData:TPaintData
                                        ):Boolean;virtual;
  end;




  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinCustomList=class(TSkinScrollControl,
                        ISkinCustomList,
                        ISkinItems)
  private
    //׼��ƽ���¼�(���Ը���Item����ItemPanDragDesignerPanel)
    FOnPrepareItemPanDrag:TCustomListPrepareItemPanDragEvent;

    //����б����¼�
    FOnClickItem:TCustomListClickItemEvent;
    //�����б����¼�
    FOnLongTapItem:TCustomListDoItemEvent;
    //����б����¼�
    FOnClickItemEx:TCustomListClickItemExEvent;
    //�б��ѡ�е��¼�
    FOnSelectedItem:TCustomListDoItemEvent;
    //�м��б�������¼�
    FOnCenterItemChange:TCustomListDoItemEvent;

    //�����б���׼���¼�
    FOnPrepareDrawItem: TCustomListDrawItemEvent;
    FOnAdvancedDrawItem: TCustomListDrawItemEvent;

    //��ʼ�༭�б����¼�
    FOnStartEditingItem:TCustomListEditingItemEvent;
    //�����༭�б����¼�
    FOnStopEditingItem:TCustomListEditingItemEvent;

    FOnClickItemDesignerPanelChild:TCustomListClickItemDesignerPanelChildEvent;
//    FOnItemDesignerPanelChildCanStartEdit:TCustomListItemDesignerPanelChildCanStartEditEvent;

    FOnMouseOverItemChange:TNotifyEvent;


    function GetOnPrepareItemPanDrag:TCustomListPrepareItemPanDragEvent;

    function GetOnSelectedItem: TCustomListDoItemEvent;
    function GetOnClickItem: TCustomListClickItemEvent;
    function GetOnLongTapItem: TCustomListDoItemEvent;
    function GetOnClickItemEx: TCustomListClickItemExEvent;
    function GetOnCenterItemChange:TCustomListDoItemEvent;

    function GetOnPrepareDrawItem: TCustomListDrawItemEvent;
    function GetOnAdvancedDrawItem: TCustomListDrawItemEvent;

    function GetOnStartEditingItem: TCustomListEditingItemEvent;
    function GetOnStopEditingItem: TCustomListEditingItemEvent;

    function GetOnClickItemDesignerPanelChild:TCustomListClickItemDesignerPanelChildEvent;
//    function GetOnItemDesignerPanelChildCanStartEdit:TCustomListItemDesignerPanelChildCanStartEditEvent;
    function GetOnMouseOverItemChange:TNotifyEvent;

    function GetCustomListProperties:TCustomListProperties;
    procedure SetCustomListProperties(Value:TCustomListProperties);

  protected
    procedure ReadState(Reader: TReader); override;

    procedure Loaded;override;
    //֪ͨ
    procedure Notification(AComponent:TComponent;Operation:TOperation);override;
    //��ȡ�ؼ�������
    function GetPropertiesClassType:TPropertiesClassType;override;

  protected
    //ISkinItems�ӿڵ�ʵ��
    function GetItems:TBaseSkinItems;
    property Items:TBaseSkinItems read GetItems;
  public
    //���ҳ���ܵĿؼ��ӿ�
    function LoadFromFieldControlSetting(ASetting:TFieldControlSetting;AFieldControlSettingMap:TObject):Boolean;override;
//    //��ȡ���ʵĸ߶�
//    function GetSuitDefaultItemHeight:Double;
//    //��ȡ�������Զ�������
//    function GetPropJsonStr:String;override;
//    procedure SetPropJsonStr(AJsonStr:String);override;

    //��ȡ�ύ��ֵ
    function GetPostValue(ASetting:TFieldControlSetting;APageDataDir:String;ASetRecordFieldValueIntf:ISetRecordFieldValue;
                            var AErrorMessage:String):Variant;override;
    //����ֵ
    procedure SetControlValue(ASetting:TFieldControlSetting;APageDataDir:String;AImageServerUrl:String;AValue:Variant;AValueCaption:String;
                            //Ҫ���ö��ֵ,�����ֶεļ�¼
                            AGetDataIntfResultFieldValueIntf:IGetDataIntfResultFieldValue);override;
//    //��������
//    function GetProp(APropName:String):Variant;override;
//    procedure SetProp(APropName:String;APropValue:Variant);override;
  public
    function SelfOwnMaterialToDefault:TSkinCustomListDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinCustomListDefaultMaterial;
    function Material:TSkinCustomListDefaultMaterial;
  public
    property Prop:TCustomListProperties read GetCustomListProperties write SetCustomListProperties;
  published
    //����(������VertScrollBar��HorzScrollBar֮ǰ)
    property Properties:TCustomListProperties read GetCustomListProperties write SetCustomListProperties;

    //��ֱ������
    property VertScrollBar;

    //ˮƽ������
    property HorzScrollBar;

    //����б����¼�
    property OnClickItem:TCustomListClickItemEvent read GetOnClickItem write FOnClickItem;
    //�����б����¼�
    property OnLongTapItem:TCustomListDoItemEvent read GetOnLongTapItem write FOnLongTapItem;
    //����б����¼�
    property OnClickItemEx:TCustomListClickItemExEvent read GetOnClickItemEx write FOnClickItemEx;
    //�б��ѡ���¼�
    property OnSelectedItem:TCustomListDoItemEvent read GetOnSelectedItem write FOnSelectedItem;

    //�м����б����¼�
    property OnCenterItemChange:TCustomListDoItemEvent read GetOnCenterItemChange write FOnCenterItemChange;

    //ÿ�λ����б���֮ǰ׼��
    property OnPrepareDrawItem:TCustomListDrawItemEvent read GetOnPrepareDrawItem write FOnPrepareDrawItem;
    //��ǿ�����б����¼�
    property OnAdvancedDrawItem:TCustomListDrawItemEvent read GetOnAdvancedDrawItem write FOnAdvancedDrawItem;

    //׼��ƽ���¼�(���Ը���Item����ItemPanDragDesignerPanel)
    property OnPrepareItemPanDrag:TCustomListPrepareItemPanDragEvent read GetOnPrepareItemPanDrag write FOnPrepareItemPanDrag;

    property OnMouseOverItemChange:TNotifyEvent read GetOnMouseOverItemChange write FOnMouseOverItemChange;

    property OnStartEditingItem:TCustomListEditingItemEvent read GetOnStartEditingItem write FOnStartEditingItem;
    property OnStopEditingItem:TCustomListEditingItemEvent read GetOnStopEditingItem write FOnStopEditingItem;

    property OnClickItemDesignerPanelChild:TCustomListClickItemDesignerPanelChildEvent
                read GetOnClickItemDesignerPanelChild write FOnClickItemDesignerPanelChild;

  end;










var
  //�б������б�
  GlobalListItemStyleRegList:TListItemStyleRegList;
  //��ȡ�����б�����ʽ���¼�
  GlobalOnGetUrlListItemStyleReg:TGetUrlListItemStyleRegEvent;


//��ֵ����Edit�ؼ�
procedure SetValueToEditControl(AEditControl:TControl;AValue:String);
//��Edit�ؼ���ȡֵ
function GetValueFromEditControl(AEditControl:TControl):String;
////����ListBox�б���ķ��
//function SetListBoxItemStyle(AListBox:TSkinCustomList;
//                            AItemType:TSkinItemType;
//                            AItemStyle:String):Boolean;

function GetGlobalListItemStyleRegList:TListItemStyleRegList;
//ע���б���ķ��
function RegisterListItemStyle(//�������
                                AStyle:String;
                                //���������ڵ�Frame
                                AListItemStyleFrameClass:TFrameClass;
                                //-1��ʾ����ListBox��Ĭ��
                                ADefaultItemHeight:Double=-1;
                                //�Ƿ��Զ��ߴ�
                                AIsAutoSize:Boolean=False;
                                //ͬһ��Frame�ж��������Ƶ�ʱ��,ʹ�����������ʼ,��δ���Frame��ʼ��ʱ��
                                //��TListItemStyleReg����Frame
                                ADataObject:TObject=nil):TListItemStyleReg;
procedure UnRegisterListItemStyle(AStyle:String);overload;
procedure UnRegisterListItemStyle(AListItemStyleFrameClass:TFrameClass);overload;



function GetItemSizeCalcTypeStr(AItemSizeCalcType:TItemSizeCalcType):String;
function GetItemLayoutTypeStr(AItemLayoutType:TItemLayoutType):String;
function GetItemSpaceTypeStr(AItemSpaceType:TSkinItemSpaceType):String;
function GetScrollBarShowTypeStr(AScrollBarShowType:TScrollBarShowType):String;

function GetItemSizeCalcTypeByStr(AItemSizeCalcTypeStr:String):TItemSizeCalcType;
function GetItemLayoutTypeByStr(AItemLayoutTypeStr:String):TItemLayoutType;
function GetItemSpaceTypeByStr(AItemSpaceTypeStr:String):TSkinItemSpaceType;
function GetScrollBarShowTypeByStr(AScrollBarShowTypeStr:String):TScrollBarShowType;
function GetScrollBarOverRangeTypeByStr(AScrollBarOverRangeTypeStr:String):TCanOverRangeTypes;


//����ListItemStyleFrame���Զ�������
procedure LoadListItemStyleFrameConfig(AFrame:TFrame;AConfig:TStringList);




implementation



uses
//  uDownloadListItemStyleManager,
  uSkinVirtualListType;



function GetStringValue(AValueStr:String):String;
begin
  Result:=ReplaceStr(AValueStr,'''','');
end;


procedure LoadListItemStyleFrameConfigCodeLine(AFrame:TFrame;AConfigCodeLine:String);
var
  APosIndex:Integer;
  AName:String;
  AValueStr:String;
  {$IFDEF FMX}
  AColorValue:TAlphaColor;
  {$ENDIF}
  {$IFDEF VCL}
  AColorValue:TColor;
  {$ENDIF}
  AComponent:TComponent;
  ASkinControlIntf:ISkinControl;
  ASkinMaterial:TSkinControlMaterial;
  ADrawParam:TDrawParam;
  ADrawTextParam:TDrawTextParam;
  ADrawRectParam:TDrawRectParam;

  AVariableName:String;
  ASkinItemBindingControlIntf:ISkinItemBindingControl;
begin
//{$IFDEF FMX}
  //lblItemCaption.SelfOwnMaterial.DrawCaptionParam.FontColor:=$FFFFFFFF
  //lblItemCaption.SelfOwnMaterial.DrawCaptionParam.FontSize:=16
  //ItemDesignerPanel.SelfOwnMaterial.DrawCaptionParam.FontSize:=16
  //ItemDesignerPanel.SelfOwnMaterial.DrawBackColorParam.IsFill:=True
  //lblItemCaption.BindItemFieldName:='username';


  {$IF CompilerVersion>31.0}
  //���ҵ��ؼ�lblItemCaption
  //���ҵ�������


  //�ҵ����Դ�FontColor:=$FFFFFFFF
  APosIndex:=AConfigCodeLine.IndexOf(':=');//�������Ƿ���-1
  if APosIndex=-1 then Exit;
  //ȡ��������,����lblItemCaption.SelfOwnMaterial.DrawCaptionParam.FontColor
  //����lblItemCaption.BindItemFieldName
  //ȡ��ֵ
  AVariableName:=AConfigCodeLine.Substring(0,APosIndex);
  AValueStr:=AConfigCodeLine.Substring(APosIndex+2);
  if AValueStr.Substring(AValueStr.Length-1)=';' then
  begin
    AValueStr:=AValueStr.Substring(0,AValueStr.Length-1);
  end;



  //�ҵ��ؼ���
//  APosIndex:=AVariableName.IndexOf('.');
  APosIndex:=AVariableName.IndexOf('.');//�������Ƿ���-1
  if APosIndex=-1 then Exit;
  AName:=AVariableName.Substring(0,APosIndex);
  //ʣ�µ�
  AVariableName:=AVariableName.Substring(APosIndex+1);
  
  AComponent:=AFrame.FindComponent(AName);
  if AComponent=nil then Exit;

  if not AComponent.GetInterface(IID_ISkinControl,ASkinControlIntf) then Exit;
  



  //�ҵ�������,�����ز�SelfOwnMaterail,����BindItemFieldName,����Properties
  APosIndex:=AVariableName.IndexOf('.');//�������Ƿ���-1
  if APosIndex=-1 then
  begin
    APosIndex:=AVariableName.Length;
  end;
  AName:=AVariableName.Substring(0,APosIndex);
  //ʣ�µ�
  AVariableName:=AVariableName.Substring(APosIndex+1);


  //���ÿؼ��İ��ֶ�
  if (AName='BindItemFieldName') then
  begin
    if AComponent.GetInterface(IID_ISkinItemBindingControl,ASkinItemBindingControlIntf) then
    begin
      ASkinItemBindingControlIntf.SetBindItemFieldName(GetStringValue(AValueStr));
    end;
    Exit;
  end;
  if (AName='Visible') then
  begin
    TControl(AComponent).Visible:=StrToBool(AValueStr);
    Exit;
  end;
  if (AName='Height') then
  begin
    TControl(AComponent).Height:=ControlSize(StrToFloat(AValueStr));
    Exit;
  end;
  if (AName='Align') then
  begin
    TControl(AComponent).Align:=GetAlign(AValueStr);
    Exit;
  end;
  if (AName='Width') then
  begin
    TControl(AComponent).Width:=ControlSize(StrToFloat(AValueStr));
    Exit;
  end;
  if (AName='Margins') then
  begin

    if AVariableName='Left' then
    begin
      TControl(AComponent).Margins.Left:=ControlSize(StrToFloat(AValueStr));
    end;
    if AVariableName='Top' then
    begin
      TControl(AComponent).Margins.Top:=ControlSize(StrToFloat(AValueStr));
    end;
    if AVariableName='Right' then
    begin
      TControl(AComponent).Margins.Right:=ControlSize(StrToFloat(AValueStr));
    end;
    if AVariableName='Bottom' then
    begin
      TControl(AComponent).Margins.Bottom:=ControlSize(StrToFloat(AValueStr));
    end;

    {$IFDEF VCL}
    TControl(AComponent).AlignWithMargins:=True;
    {$ENDIF}

    Exit;
  end;

  if (AName='Properties') then
  begin

    if AVariableName='Picture.SkinImageListName' then
    begin
      TSkinImage(AComponent).Prop.Picture.SkinImageListName:=GetStringValue(AValueStr);
    end;
    if AVariableName='Picture.DefaultImageIndex' then
    begin
      TSkinImage(AComponent).Prop.Picture.DefaultImageIndex:=StrToInt(AValueStr);
    end;
    if AVariableName='Picture.IsClipRound' then
    begin
      TSkinImage(AComponent).Prop.Picture.IsClipRound:=StrToBool(AValueStr);
    end;



    Exit;
  end;



  if (AName<>'SelfOwnMaterial') and (AName<>'Material') then Exit;


  ASkinMaterial:=ASkinControlIntf.GetCurrentUseMaterial;
  if ASkinMaterial=nil then Exit;


  if AVariableName='IsTransparent' then
  begin
    ASkinMaterial.IsTransparent:=StrToBool(AValueStr);
  end
  ;

  //�ҵ����Ʋ���DrawTextParam
  APosIndex:=AVariableName.IndexOf('.');
  if APosIndex=-1 then Exit;
  AName:=AVariableName.Substring(0,APosIndex);
  AVariableName:=AVariableName.Substring(APosIndex+1);
  ADrawParam:=ASkinMaterial.FindParamByName(AName);
  if AName='BackColor' then
  begin
    ADrawParam:=ASkinMaterial.BackColor;
  end;





  if ADrawParam=nil then
  begin


    Exit;
  end;

  if AVariableName='Alpha' then
  begin
    ADrawParam.Alpha:=StrToInt(AValueStr);
  end;


  if ADrawParam is TDrawRectParam then
  begin
      ADrawRectParam:=TDrawRectParam(ADrawParam);
      if AVariableName='FillColor' then
      begin
        {$IFDEF FMX}
        AColorValue:=StrToInt(AValueStr);
        ADrawRectParam.FillColor.Color:=AColorValue;
        {$ENDIF FMX}
      end
      else if AVariableName='IsFill' then
      begin
        ADrawRectParam.IsFill:=StrToBool(AValueStr);
      end
      else if AVariableName='IsRound' then
      begin
        ADrawRectParam.IsRound:=StrToBool(AValueStr);
      end
      //
      //����͸��,���Ҳ���Ҫѡ�еİ׵�Ч��
      //+'ItemDesignerPanel.SelfOwnMaterial.BackColor.DrawEffectSetting.PushedEffect.IsFill:=False;'
      else if AVariableName='DrawEffectSetting.PushedEffect.IsFill' then
      begin
        ADrawRectParam.DrawEffectSetting.PushedEffect.IsFill:=StrToBool(AValueStr);
      end
      ;
  end;


  if ADrawParam is TDrawTextParam then
  begin

      ADrawTextParam:=TDrawTextParam(ADrawParam);
      if AVariableName='FontColor' then
      begin

        {$IFDEF FMX}
        AColorValue:=StrToInt(AValueStr);
        ADrawTextParam.FontColor:=AColorValue;
        {$ENDIF FMX}
        {$IFDEF VCL}
        if Pos('$',AValueStr)>0 then
        begin
          //VCL����BGR,ת��RGB
          //$FF FF FF FF
          //012 34 56 78
          AValueStr:='$'+AValueStr.Substring(7,2)
                    +AValueStr.Substring(5,2)
                    +AValueStr.Substring(3,2);
          AColorValue:=StrToInt(AValueStr);
        end
        else
        begin
          AColorValue:=ColorNameToColor(AValueStr);
        end;
        ADrawTextParam.FontColor:=AColorValue;
        {$ENDIF VCL}

      end
      else if AVariableName='FontSize' then
      begin
        ADrawTextParam.FontSize:=Ceil(StrToFloat(AValueStr));
      end
      else if AVariableName='FontHorzAlign' then
      begin
        ADrawTextParam.FontHorzAlign:=GetFontHorzAlign(AValueStr);
      end
      else if AVariableName='FontVertAlign' then
      begin
        ADrawTextParam.FontVertAlign:=GetFontVertAlign(AValueStr);
      end
      ;


  end;
  {$IFEND}


//{$ENDIF FMX}

end;

procedure LoadListItemStyleFrameConfig(AFrame:TFrame;AConfig:TStringList);
var
  I:Integer;
begin
  for I := 0 to AConfig.Count-1 do
  begin
    LoadListItemStyleFrameConfigCodeLine(AFrame,AConfig[I]);
  end;
end;

function GetItemSizeCalcTypeStr(AItemSizeCalcType:TItemSizeCalcType):String;
begin
  Result:='';
  case AItemSizeCalcType of
    isctFixed: Result:='Fixed';
    isctSeparate: Result:='Separate';
  end;
end;

function GetItemLayoutTypeStr(AItemLayoutType:TItemLayoutType):String;
begin
  case AItemLayoutType of
    iltVertical: Result:='Vertical';
    iltHorizontal: Result:='Horizontal';
  end;
end;

function GetItemSpaceTypeStr(AItemSpaceType:TSkinItemSpaceType):String;
begin
  case AItemSpaceType of
    sistDefault: Result:='Default';
    sistMiddle: Result:='Middle';
  end;
end;

function GetScrollBarShowTypeStr(AScrollBarShowType:TScrollBarShowType):String;
begin
  case AScrollBarShowType of
    sbstNone: Result:='None';
    sbstAlwaysCoverShow: Result:='AlwaysCoverShow';
    sbstAlwaysClipShow: Result:='AlwaysClipShow';
    sbstAutoCoverShow: Result:='AutoCoverShow';
    sbstAutoClipShow: Result:='AutoClipShow';
    sbstHide: Result:='Hide';
  end;
end;


function GetItemSizeCalcTypeByStr(AItemSizeCalcTypeStr:String):TItemSizeCalcType;
begin
  if SameText(AItemSizeCalcTypeStr,'Fixed') then
  begin
    Result:=isctFixed;
  end
  else
  begin
    Result:=isctSeparate;
  end;

end;

function GetItemLayoutTypeByStr(AItemLayoutTypeStr:String):TItemLayoutType;
begin

  if SameText(AItemLayoutTypeStr,'Horizontal') then
  begin
    Result:=iltHorizontal;
  end
  else
  begin
    Result:=iltVertical;
  end;

end;

function GetItemSpaceTypeByStr(AItemSpaceTypeStr:String):TSkinItemSpaceType;
begin
  if SameText(AItemSpaceTypeStr,'Middle') then
  begin
    Result:=sistMiddle;
  end
  else
  begin
    Result:=sistDefault;
  end;

end;

function GetScrollBarOverRangeTypeByStr(AScrollBarOverRangeTypeStr:String):TCanOverRangeTypes;
begin
  Result:=[];
  if Pos('Min',AScrollBarOverRangeTypeStr)>0 then
  begin
    Result:=Result+[TCanOverRangeType.cortMin];
  end;
  if Pos('Max',AScrollBarOverRangeTypeStr)>0 then
  begin
    Result:=Result+[TCanOverRangeType.cortMax];
  end;

end;

function GetScrollBarShowTypeByStr(AScrollBarShowTypeStr:String):TScrollBarShowType;
begin
  if SameText(AScrollBarShowTypeStr,'AlwaysCoverShow') then
  begin
    Result:=sbstAlwaysCoverShow;
  end
  else if SameText(AScrollBarShowTypeStr,'AlwaysClipShow') then
  begin
    Result:=sbstAlwaysClipShow;
  end
  else if SameText(AScrollBarShowTypeStr,'None') then
  begin
    Result:=sbstNone;
  end
  else if SameText(AScrollBarShowTypeStr,'AutoCoverShow') then
  begin
    Result:=sbstAutoCoverShow;
  end
  else if SameText(AScrollBarShowTypeStr,'AutoClipShow') then
  begin
    Result:=sbstAutoClipShow;
  end
  else if SameText(AScrollBarShowTypeStr,'Hide') then
  begin
    Result:=sbstHide;
  end
  else
  begin
    Result:=sbstAutoCoverShow;
  end;

end;





function GetGlobalListItemStyleRegList:TListItemStyleRegList;
begin
  if GlobalListItemStyleRegList=nil then
  begin
    GlobalListItemStyleRegList:=TListItemStyleRegList.Create();
  end;
  Result:=GlobalListItemStyleRegList;
end;

function RegisterListItemStyle(
                              AStyle:String;
                              AListItemStyleFrameClass:TFrameClass;
                              ADefaultItemHeight:Double=-1;
                              AIsAutoSize:Boolean=False;
                              ADataObject:TObject=nil):TListItemStyleReg;
//var
//  AListItemStyleReg:TListItemStyleReg;
begin
  Result:=TListItemStyleReg.Create;
  Result.Name:=AStyle;
  Result.FrameClass:=AListItemStyleFrameClass;
  Result.DefaultItemHeight:=ADefaultItemHeight;
  Result.IsAutoSize:=AIsAutoSize;
  Result.DataObject:=ADataObject;
  GetGlobalListItemStyleRegList.Add(Result);
end;

procedure UnRegisterListItemStyle(AStyle:String);
var
  AListItemStyleReg:TListItemStyleReg;
begin
  if GlobalListItemStyleRegList<>nil then
  begin
    AListItemStyleReg:=GlobalListItemStyleRegList.FindItemByName(AStyle);
    GlobalListItemStyleRegList.Remove(AListItemStyleReg);
  end;
end;

procedure UnRegisterListItemStyle(AListItemStyleFrameClass:TFrameClass);
var
  AListItemStyleReg:TListItemStyleReg;
begin
  if GlobalListItemStyleRegList<>nil then
  begin
    AListItemStyleReg:=GlobalListItemStyleRegList.FindItemByClass(AListItemStyleFrameClass);
    GlobalListItemStyleRegList.Remove(AListItemStyleReg);
  end;
end;

//function SetListBoxItemStyle(AListBox:TSkinCustomList;
//                            AItemType:TSkinItemType;
//                            AItemStyle:String):Boolean;
//var
//  AListItemStyle:TListItemStyleReg;
//begin
//  Result:=False;
//  AListItemStyle:=GlobalListItemStyleRegList.FindItemByName(AItemStyle);
//  if AListItemStyle<>nil then
//  begin
//    Result:=AListBox.Prop.SetListBoxItemStyle(AListItemStyle);
//  end;
//end;

function GetValueFromEditControl(AEditControl:TControl):String;
begin
  Result:='';

  if AEditControl is TCustomEdit then
  begin
    Result:=TCustomEdit(AEditControl).Text;
  end;

  if AEditControl is TCustomMemo then
  begin
    Result:=TCustomMemo(AEditControl).Text;
  end;

  if AEditControl is TCustomComboBox then
  begin
    if TCustomComboBox(AEditControl).ItemIndex<>-1 then
    begin
      Result:=TCustomComboBox(AEditControl).Items[TCustomComboBox(AEditControl).ItemIndex];
    end;
  end;

  {$IFDEF FMX}
  if AEditControl is TCustomComboEdit then
  begin
    Result:=TCustomComboEdit(AEditControl).Text;
  end;
  {$ENDIF FMX}

end;

procedure SetValueToEditControl(AEditControl:TControl;AValue:String);
begin
  if AEditControl is TCustomEdit then
  begin
    TCustomEdit(AEditControl).Text:=AValue;
  end;

  if AEditControl is TCustomMemo then
  begin
    TCustomMemo(AEditControl).Text:=AValue;
  end;

  if AEditControl is TCustomComboBox then
  begin
    TCustomComboBox(AEditControl).ItemIndex:=
      TCustomComboBox(AEditControl).Items.IndexOf(AValue);
  end;

  {$IFDEF FMX}
  if AEditControl is TCustomComboEdit then
  begin
    TCustomComboEdit(AEditControl).Text:=AValue;
  end;
  {$ENDIF FMX}

end;



{ TCustomListProperties }


function TCustomListProperties.CalcContentHeight:Double;
begin
  Result:=Self.FListLayoutsManager.ContentHeight;

  if Self.FIsEnabledCenterItemSelectMode then
  begin
    case Self.FListLayoutsManager.ItemLayoutType of
      iltVertical:
      begin
        //��ֱ����ѡ��ģʽ
        Result:=Result
                +Self.GetClientRect.Height
                -Self.FListLayoutsManager.ItemHeight;
      end;
      iltHorizontal:
      begin
      end;
    end;
  end;
end;

function TCustomListProperties.CalcContentWidth:Double;
begin
  Result:=Self.FListLayoutsManager.ContentWidth;

  if Self.FIsEnabledCenterItemSelectMode then
  begin
    case Self.FListLayoutsManager.ItemLayoutType of
      iltVertical:
      begin
      end;
      iltHorizontal:
      begin
        //ˮƽ����ѡ��ģʽ
        Result:=Result
                +Self.GetClientRect.Width
                -Self.FListLayoutsManager.ItemWidth;
      end;
    end;
  end;
end;

constructor TCustomListProperties.Create(ASkinControl:TControl);
begin
  inherited Create(ASkinControl);

  if Not ASkinControl.GetInterface(IID_ISkinCustomList,Self.FSkinCustomListIntf) then
  begin
    ShowException('This Component Do not Support ISkinCustomList Interface');
  end
  else
  begin

      //���ݿ��
      FContentWidth:=-1;
      //���ݸ߶�
      FContentHeight:=-1;

      //�Ƿ��Զ�ѡ��
      FIsAutoSelected:=True;


      //����ʱ��Ϊ1����
      FHasCalledOnLongTapItem:=False;
      FLongTapItemInterval:=1000;


      //�̰�ʱ��
      FStayPressedItemInterval:=300;

      FIsStayPressedItem:=False;


      FItemDesignerPanelInvalidateLink:=TSkinObjectChangeLink.Create;
      FItemDesignerPanelInvalidateLink.OnChange:=DoItemDesignerPanelChange;


      FSelectedItem:=nil;
      FMouseDownItem:=nil;
      FInteractiveMouseDownItem:=nil;
      FLastMouseDownItem:=nil;
      FInnerMouseDownItem:=nil;
      FCenterItem:=nil;
      FMouseOverItem:=nil;
      FPanDragItem:=nil;


      FEditingItem:=nil;
      FEditingItem_EditControl:=nil;
      FEditingItem_EditControlIntf:=nil;
      FEditingItem_EditControlOldParent:=nil;
      FEditingItem_EditControl_ItemEditorIntf:=nil;



      //Ĭ��û��ˮƽ������
      Self.FHorzScrollBarShowType:=sbstNone;


      //�����б�
      FItems:=GetItemsClass.Create;
      FItems.OnChange:=DoItemsChange;
      FItems.OnItemDelete:=DoItemDelete;



      //�������ֹ�����
      FListLayoutsManager:=GetCustomListLayoutsManagerClass.Create(FItems);
      FListLayoutsManager.StaticItemWidth:=-1;
      FListLayoutsManager.StaticItemHeight:=Const_DefaultItemHeight;
      //Ĭ�Ͼ����ó�isctSeparate,�����û�ʹ���ϳ�������
      FListLayoutsManager.StaticItemSizeCalcType:=isctSeparate;

      FListLayoutsManager.OnItemPropChange:=DoItemPropChange;
      FListLayoutsManager.OnItemSizeChange:=DoItemSizeChange;
      FListLayoutsManager.OnItemVisibleChange:=DoItemVisibleChange;

      FListLayoutsManager.OnGetControlWidth:=Self.DoGetListLayoutsManagerControlWidth;
      FListLayoutsManager.OnGetControlHeight:=Self.DoGetListLayoutsManagerControlHeight;

      FListLayoutsManager.OnSetSelectedItem:=Self.DoSetListLayoutsManagerSelectedItem;





      //�Ƿ�����ƽ��
      FEnableItemPanDrag:=True;

      //����ƽ��ʱ���ٶ�
      FStartItemPanDragVelocity:=1000;

      //�б���ƽ�ϵķ���
      FItemPanDragGestureDirection:=ipdgdtLeft;




      //�����б����������ʼλ�õĶ�ʱ��
      FAdjustCenterItemPositionAnimator:=TSkinAnimator.Create(nil);
      FAdjustCenterItemPositionAnimator.TweenType:=TTweenType.Quadratic;//TTweenType.Linear;//Quartic;//Quadratic;
      FAdjustCenterItemPositionAnimator.EaseType:=TEaseType.easeOut;
      FAdjustCenterItemPositionAnimator.EndTimesCount:=6;//5;//
      FAdjustCenterItemPositionAnimator.OnAnimate:=Self.DoAdjustCenterItemPositionAnimate;
      FAdjustCenterItemPositionAnimator.OnAnimateBegin:=Self.DoAdjustCenterItemPositionAnimateBegin;
      FAdjustCenterItemPositionAnimator.OnAnimateEnd:=Self.DoAdjustCenterItemPositionAnimateEnd;
      FAdjustCenterItemPositionAnimator.Speed:=Const_Deafult_AnimatorSpeed;//6;//15֡




      //ƽ�Ͽؼ����ƹ���
      FItemPanDragGestureManager:=TSkinControlGestureManager.Create(nil,Self.FSkinControl);
      //�Ƿ���Ҫ�жϵ�һ�����Ƶķ���
      FItemPanDragGestureManager.IsNeedDecideFirstGestureKind:=True;


      FItemPanDragGestureManager.OnFirstMouseDown:=DoItemPanDragGestureManagerFirstMouseDown;
      //Position����
      FItemPanDragGestureManager.OnPositionChange:=DoItemPanDragGestureManagerPositionChange;
      FItemPanDragGestureManager.OnStartDrag:=DoItemPanDragGestureManagerStartDrag;
      //��СֵԽ�����
      FItemPanDragGestureManager.OnMinOverRangePosValueChange:=DoItemPanDragGestureManagerMinOverRangePosValueChange;
      //���ֵԽ�����
      FItemPanDragGestureManager.OnMaxOverRangePosValueChange:=DoItemPanDragGestureManagerMaxOverRangePosValueChange;
      //���ص���ʼ
      FItemPanDragGestureManager.OnScrollToInitialAnimateEnd:=DoItemPanDragGestureManagerScrollToInitialAnimateEnd;
      //��������ٶȺ;���
      FItemPanDragGestureManager.OnCalcInertiaScrollDistance:=Self.DoItemPanDragGestureManagerCalcInertiaScrollDistance;


      FEmptyContentPicture:=CreateDrawPicture('EmptyContentPicture','����Ϊ�յ�ͼƬ','');

  end;
end;

procedure TCustomListProperties.CreateCheckLongTapItemTimer;
begin
  //����Ƿ񳤰��б���
  if HasOnLongTapItemEvent then
  begin
    if FCheckLongTapItemTimer=nil then
    begin
      FCheckLongTapItemTimer:=TTimer.Create(nil);
      FCheckLongTapItemTimer.OnTimer:=Self.DoCheckLongTapItemTimer;
    end;
    FCheckLongTapItemTimer.Interval:=FLongTapItemInterval;
  end;
end;

procedure TCustomListProperties.CreateCheckStayPressedItemTimer;
begin
  //����Ƿ�̰��б���
  if FCheckStayPressedItemTimer=nil then
  begin
    FCheckStayPressedItemTimer:=TTimer.Create(nil);
    FCheckStayPressedItemTimer.OnTimer:=Self.DoCheckStayPressedItemTimer;
  end;
  FCheckStayPressedItemTimer.Interval:=FStayPressedItemInterval;
end;

procedure TCustomListProperties.CreateCallOnClickItemTimer;
begin
  if FCallOnClickItemTimer=nil then
  begin
    FCallOnClickItemTimer:=TTimer.Create(nil);
    FCallOnClickItemTimer.OnTimer:=Self.DoCallOnClickItemTimer;
  end;
  FCallOnClickItemTimer.Interval:=100;
end;

procedure TCustomListProperties.DoItemPanDragGestureManagerPositionChange(Sender: TObject);
begin
  //ƽ���б����ƶ���ʱ����Ҫ���ϵ��ػ�
  Invalidate;
end;

procedure TCustomListProperties.DoItemPanDragGestureManagerCalcInertiaScrollDistance(
          Sender: TObject;
          var InertiaDistance: Double;
          var CanInertiaScroll: Boolean);
begin


  Self.FItemPanDragGestureManager.InertiaScrollAnimator.TweenType:=TTweenType.Cubic;
  Self.FItemPanDragGestureManager.InertiaScrollAnimator.EaseType:=TEaseType.easeOut;
  Self.FItemPanDragGestureManager.InertiaScrollAnimator.d:=10;
  Self.FItemPanDragGestureManager.InertiaScrollAnimator.Speed:=Const_Deafult_AnimatorSpeed;
  Self.FItemPanDragGestureManager.InertiaScrollAnimator.InitialSpeed:=3;
  Self.FItemPanDragGestureManager.InertiaScrollAnimator.MaxSpeed:=3;
  Self.FItemPanDragGestureManager.InertiaScrollAnimator.minps:=6;


  case FItemPanDragGestureDirection of
    ipdgdtLeft:
    begin
      case Self.FItemPanDragGestureManager.MouseMoveDirection of
        isdScrollToMin:
        begin
          //����
          //����ֹͣ
//          OutputDebugString('ƽ�Ϸ���');
          Self.FIsStopingItemPanDrag:=True;
          InertiaDistance:=Self.FItemPanDragGestureManager.Max+20;
        end;
        isdScrollToMax:
        begin
          //������
//          OutputDebugString('ƽ��ǰ��');
          InertiaDistance:=Self.FItemPanDragGestureManager.Max+20;
        end;
      end;
    end;
    ipdgdtRight:
    begin
      case Self.FItemPanDragGestureManager.MouseMoveDirection of
        isdScrollToMin:
        begin
          //������
//          OutputDebugString('ƽ��ǰ��');
          InertiaDistance:=Self.FItemPanDragGestureManager.Max+20;
        end;
        isdScrollToMax:
        begin
          //����
          //����ֹͣ
//          OutputDebugString('ƽ�Ϸ���');
          Self.FIsStopingItemPanDrag:=True;
          InertiaDistance:=Self.FItemPanDragGestureManager.Max+20;
        end;
      end;
    end;
//    ipdgdtTop: ;
//    ipdgdtBottom: ;
  end;

end;

procedure TCustomListProperties.DoItemPanDragGestureManagerMaxOverRangePosValueChange(Sender: TObject;
      NextValue:Double;
      LastValue:Double;
      Step:Double;
      var NewValue: Double;
      var CanChange: Boolean);
begin
//  uBaseLog.OutputDebugString('Max '+FloatToStr(NewValue));
//  //ˢ��
//  Self.Invalidate;
end;

procedure TCustomListProperties.DoItemPanDragGestureManagerFirstMouseDown(Sender:TObject;X,Y:Double);
var
  AMouseDownItem:TBaseSkinItem;
begin
  AMouseDownItem:=Self.FSkinCustomListIntf.Prop.VisibleItemAt(X,Y);
  if AMouseDownItem<>nil then
  begin
    Self.PrepareItemPanDrag(AMouseDownItem);
  end;
end;

procedure TCustomListProperties.DoItemPanDragGestureManagerMinOverRangePosValueChange(Sender: TObject;
        NextValue:Double;
        LastValue:Double;
        Step:Double;
        var NewValue: Double;
        var CanChange: Boolean);
begin
//  uBaseLog.OutputDebugString('Min '+FloatToStr(NewValue));
//  //ˢ��
//  Self.Invalidate;
end;

procedure TCustomListProperties.DoItemPanDragGestureManagerScrollToInitialAnimateEnd(Sender: TObject);
begin
    case Self.FItemPanDragGestureDirection of
      ipdgdtLeft:
      begin
            //����������˳�ʼλ��,��ôƽ�Ͻ���
            if (IsSameDouble(Self.FItemPanDragGestureManager.Position,Self.FItemPanDragGestureManager.Min)) then
            begin
//              OutputDebugString('ƽ�Ͻ���');
              Self.FPanDragItem:=nil;
              FIsStopingItemPanDrag:=False;
              Self.Invalidate;
            end
            else
            if (IsSameDouble(Self.FItemPanDragGestureManager.Position,Self.FItemPanDragGestureManager.Max)) then
            begin
              //�ж���Max,����Ҫ����

            end
            else
            begin
                  //�ж��ǲ���Min����Max,�������м�
                  //�жϷ���
                  case Self.FItemPanDragGestureManager.MouseMoveDirection of
                    isdScrollToMin:
                    begin
                      //����
//                      OutputDebugString('ƽ�Ϸ���');
                      Self.StopItemPanDrag;
                    end;
                    isdScrollToMax:
                    begin
                      //������
//                      OutputDebugString('ƽ��ǰ��');
                      Self.StartItemPanDrag(FPanDragItem);
                    end;
                  end;
            end;
      end;
      ipdgdtRight:
      begin
            //����������˳�ʼλ��,��ôƽ�Ͻ���
            if (IsSameDouble(Self.FItemPanDragGestureManager.Position,Self.FItemPanDragGestureManager.Max)) then
            begin
//              OutputDebugString('ƽ�Ͻ���');
              Self.FPanDragItem:=nil;
              FIsStopingItemPanDrag:=False;
              Self.Invalidate;
            end
            else
            if (IsSameDouble(Self.FItemPanDragGestureManager.Position,Self.FItemPanDragGestureManager.Min)) then
            begin
              //�ж���Max,����Ҫ����
              Self.Invalidate;

            end
            else
            begin
                  //�ж��ǲ���Min����Max,�������м�
                  //�жϷ���
                  case Self.FItemPanDragGestureManager.MouseMoveDirection of
                    isdScrollToMin:
                    begin
                      //������
//                      OutputDebugString('ƽ��ǰ��');
                      Self.StartItemPanDrag(FPanDragItem);
                    end;
                    isdScrollToMax:
                    begin
                      //����
//                      OutputDebugString('ƽ�Ϸ���');
                      Self.StopItemPanDrag;
                    end;
                  end;
            end;

      end;
//      ipdgdtTop: ;
//      ipdgdtBottom: ;
    end;
end;

procedure TCustomListProperties.DoItemPanDragGestureManagerStartDrag(Sender: TObject);
begin

  if not FIsStopingItemPanDrag
      //���������б���ƽ��
      and Self.CanEnableItemPanDrag then
  begin
      //��δ��ʼƽ��
      if (FPanDragItem=nil) then
      begin

          if FIsCurrentMouseDownItemCanPanDrag then
          begin
    //        OutputDebugString('ȷ��ƽ�ϵ��б���');
            //ƽ�ϵ��б���
            Self.FPanDragItem:=Self.FMouseDownItem;
          end;

      end;
  end;

end;

procedure TCustomListProperties.DoItemDesignerPanelChange(Sender: TObject);
begin
  //�б�������������¼�
  Self.Invalidate;
end;

procedure TCustomListProperties.PrepareItemPanDrag(AMouseDownItem:TBaseSkinItem);
begin
    FIsCurrentMouseDownItemCanPanDrag:=True;
    CallOnPrepareItemPanDrag(Self,AMouseDownItem,FIsCurrentMouseDownItemCanPanDrag);

    //�ؼ����ƹ���
    case Self.FItemPanDragGestureDirection of
      ipdgdtLeft:
      begin
          FItemPanDragGestureManager.Kind:=TGestureKind.gmkHorizontal;
          if Self.FPanDragItem=nil then
          begin
            Self.FVertControlGestureManager.Enabled:=True;

            FItemPanDragGestureManager.FIsNeedDecideFirstGestureKind:=True;
            FItemPanDragGestureManager.DecideFirstGestureKindDirections:=[isdScrollToMin];
          end
          else
          begin
            Self.FVertControlGestureManager.Enabled:=False;

            FItemPanDragGestureManager.FIsNeedDecideFirstGestureKind:=False;
            //���ص�ʱ��,���Ҷ����϶�
            FItemPanDragGestureManager.DecideFirstGestureKindDirections:=[isdScrollToMin,isdScrollToMax];
          end;
          //ƽ�ϵ������ֵ
          if FItemPanDragDesignerPanel<>nil then
          begin
            Self.FItemPanDragGestureManager.StaticMax:=Self.FItemPanDragDesignerPanel.Width;
          end
          else
          begin
            Self.FItemPanDragGestureManager.StaticMax:=0;
          end;
      end;
      ipdgdtRight:
      begin
          FItemPanDragGestureManager.Kind:=TGestureKind.gmkHorizontal;
          if Self.FPanDragItem=nil then
          begin
            FItemPanDragGestureManager.FIsNeedDecideFirstGestureKind:=True;
            FItemPanDragGestureManager.DecideFirstGestureKindDirections:=[isdScrollToMax];
          end
          else
          begin
            FItemPanDragGestureManager.FIsNeedDecideFirstGestureKind:=False;
            //���ص�ʱ��,���Ҷ����϶�
            FItemPanDragGestureManager.DecideFirstGestureKindDirections:=[isdScrollToMin,isdScrollToMax];
          end;
          //ƽ�ϵ������ֵ
          if FItemPanDragDesignerPanel<>nil then
          begin
            Self.FItemPanDragGestureManager.StaticMax:=Self.FItemPanDragDesignerPanel.Width;
          end
          else
          begin
            Self.FItemPanDragGestureManager.StaticMax:=0;
          end;
          if Self.FPanDragItem=nil then
          begin
            Self.FItemPanDragGestureManager.StaticPosition:=Self.FItemPanDragGestureManager.StaticMax;
          end;
        end;
  //      ipdgdtTop:
  //      begin
  //        FItemPanDragGestureManager.Kind:=TGestureKind.gmkVertical;
  //        FItemPanDragGestureManager.DecideFirstGestureKindDirections:=[isdScrollToMin];
  //      end;
  //      ipdgdtBottom:
  //      begin
  //        FItemPanDragGestureManager.Kind:=TGestureKind.gmkVertical;
  //        FItemPanDragGestureManager.DecideFirstGestureKindDirections:=[isdScrollToMax];
  //      end;
    end;


end;

procedure TCustomListProperties.RemoveOldDesignerPanel(const AOldItemDesignerPanel: TSkinItemDesignerPanel);
begin
  if AOldItemDesignerPanel<>nil then
  begin
    if AOldItemDesignerPanel.Properties<>nil then
    begin
      AOldItemDesignerPanel.Properties.BindControlInvalidateChange.UnRegisterChanges(Self.FItemDesignerPanelInvalidateLink);
    end;
    //ȥ���ͷ�֪ͨ
    RemoveFreeNotification(AOldItemDesignerPanel,Self.FSkinControl);
  end;
end;

destructor TCustomListProperties.Destroy;
begin
  try
      FreeAndNil(FAdjustCenterItemPositionAnimator);

      SetItemPanDragDesignerPanel(nil);

      FreeAndNil(FItemDesignerPanelInvalidateLink);


      //���µ��б���
      FMouseDownItem:=nil;
      FInteractiveMouseDownItem:=nil;
      FLastMouseDownItem:=nil;
      FInnerMouseDownItem:=nil;
      FCenterItem:=nil;
      //���ͣ�����б���
      FMouseOverItem:=nil;
      //ѡ�е��б���
      FSelectedItem:=nil;

      FPanDragItem:=nil;



      FEditingItem:=nil;
      FEditingItem_EditControl:=nil;
      FEditingItem_EditControlIntf:=nil;
      FEditingItem_EditControlOldParent:=nil;
      FEditingItem_EditControl_ItemEditorIntf:=nil;



      FListLayoutsManager.OnItemPropChange:=nil;
      FListLayoutsManager.OnItemSizeChange:=nil;
      FListLayoutsManager.OnItemVisibleChange:=nil;
      FListLayoutsManager.OnGetItemIconSkinImageList:=nil;
      FListLayoutsManager.OnGetItemIconDownloadPictureManager:=nil;
      FListLayoutsManager.OnGetControlWidth:=nil;
      FListLayoutsManager.OnGetControlHeight:=nil;
      FListLayoutsManager.OnSetSelectedItem:=nil;
      FreeAndNil(FListLayoutsManager);

      if FItems<>nil then
      begin
        FItems.OnChange:=nil;
        FItems.OnItemDelete:=nil;
        FreeAndNil(FItems);
      end;


      FreeAndNil(FItemPanDragGestureManager);

      FreeAndNil(FCheckLongTapItemTimer);

      FreeAndNil(FCheckStayPressedItemTimer);

      FreeAndNil(FCallOnClickItemTimer);

      FreeAndNil(FEmptyContentPicture);

      inherited;
  except
    on E:Exception do
    begin
      uBaseLog.HandleException(E,'TCustomListProperties.Destroy');
    end;
  end;
end;

procedure TCustomListProperties.DoAdjustCenterItemPositionAnimate(Sender: TObject);
begin
  //�����б���ʱ���ù�������

  //����λ��
  if Self.FAdjustCenterItemPositionAnimator.Tag=1 then
  begin
    //��ֱ
    Self.FVertControlGestureManager.Position:=
        Self.FVertControlGestureManager.Position
        +(Self.FAdjustCenterItemPositionAnimator.Position-Self.FAdjustCenterItemPositionAnimator.LastPosition);
  end;
  //����λ��
  if Self.FAdjustCenterItemPositionAnimator.Tag=2 then
  begin
    //ˮƽ
    Self.FHorzControlGestureManager.Position:=
        Self.FHorzControlGestureManager.Position
        +(Self.FAdjustCenterItemPositionAnimator.Position-Self.FAdjustCenterItemPositionAnimator.LastPosition);
  end;
end;

procedure TCustomListProperties.DoAdjustCenterItemPositionAnimateBegin(Sender: TObject);
begin

end;

procedure TCustomListProperties.DoAdjustCenterItemPositionAnimateEnd(Sender: TObject);
var
  ACenterItem:TBaseSkinItem;
begin
  //�жϾ��е��б���
  ACenterItem:=Self.FSkinCustomListIntf.Prop.VisibleItemAt(
      Self.FSkinCustomListIntf.Prop.GetCenterItemRect.Left+1,
      Self.FSkinCustomListIntf.Prop.GetCenterItemRect.Top+1
      );

  //��������
  DoSetCenterItem(ACenterItem);

  //����ѡ���¼�
  if Self.FIsEnabledCenterItemSelectMode then
  begin
    DoSetSelectedItem(ACenterItem);
  end;
end;

procedure TCustomListProperties.DoCheckLongTapItemTimer(Sender: TObject);
begin
  Self.FCheckLongTapItemTimer.Enabled:=False;
  Self.CallOnLongTapItemEvent(Sender,MouseDownItem);
end;

procedure TCustomListProperties.DoCallOnClickItemTimer(Sender: TObject);
begin
  Self.FCallOnClickItemTimer.Enabled:=False;

  if FLastMouseDownItem<>nil then
  begin
//    uBaseLog.OutputDebugString('TSkinCustomListDefaultType.DoCallOnClickItemTimer Item');

    //���е���¼�
    //ѡ���б���
    Self.DoClickItem(Self.FLastMouseDownItem,
                      FLastMouseDownX,
                      FLastMouseDownY);

    //ȡ������Ч��,Ȼ���ػ�
    Self.FLastMouseDownItem:=nil;
  end;
  Invalidate;
end;

procedure TCustomListProperties.DoCheckStayPressedItemTimer(Sender: TObject);
begin
  Self.FCheckStayPressedItemTimer.Enabled:=False;

  //����һ��ʱ��,���û�е���,Ҳû���ƶ���λ��,��ô��ʾ��ָ������û��
  //�ػ�
  FIsStayPressedItem:=True;
  Self.Invalidate;

end;

procedure TCustomListProperties.DoClickItem(AItem: TBaseSkinItem;X:Double;Y:Double);
begin

  //��������Զ�ѡ��,��ôѡ���б���
  if not Self.FIsEnabledCenterItemSelectMode and Self.FIsAutoSelected then
  begin
    if not Self.FMultiSelect then
    begin
      Self.SetSelectedItem(AItem);
    end
    else
    begin
      if not AItem.Selected then
      begin
        Self.SetSelectedItem(AItem);
      end
      else
      begin
//        Self.SetSelectedItem(nil);
        AItem.Selected:=False;
        CallOnSelectedItemEvent(Self,nil);
      end;
      
    end;

  end;

  //����б�
  if (Self.FListLayoutsManager.GetVisibleItemObjectIndex(AItem)<>-1) then
  begin
    CallOnClickItemEvent(AItem);
    CallOnClickItemExEvent(AItem,X,Y);
  end;

end;

function TCustomListProperties.DoGetListLayoutsManagerControlHeight(Sender: TObject): Double;
begin
  Result:=Self.FSkinControlIntf.Height;
end;

function TCustomListProperties.DoGetListLayoutsManagerControlWidth(Sender: TObject): Double;
begin
  Result:=Self.FSkinControlIntf.Width;
end;

procedure TCustomListProperties.DoHorz_InnerPositionChange(Sender: TObject);
begin
  inherited;

  //���µ�ǰ�༭�ı༭��
  SyncEditControlBounds;
end;

procedure TCustomListProperties.DoHorz_InnerScrollToInitialAnimateEnd(Sender: TObject);
var
  ALeftItem,ARightItem:TBaseSkinItem;
begin
  inherited;

  //����ѡ��ģʽ
  if Self.FIsEnabledCenterItemSelectMode
    //�й�������
    and (Self.FHorzControlGestureManager.MouseMoveDirection<>isdNone)
    //��������1
    and (Self.FItems.Count>1) then
  begin
      //�жϵ�ǰ�������Լ�����
      FAdjustCenterItemPositionAnimator.Tag:=2;
      //�����������
      ALeftItem:=Self.FSkinCustomListIntf.Prop.VisibleItemAt(
        Self.FSkinCustomListIntf.Prop.GetCenterItemRect.Left+1,
        Self.FSkinCustomListIntf.Prop.GetCenterItemRect.Top+1
        );
      ARightItem:=Self.FSkinCustomListIntf.Prop.VisibleItemAt(
        Self.FSkinCustomListIntf.Prop.GetCenterItemRect.Right-1,
        Self.FSkinCustomListIntf.Prop.GetCenterItemRect.Top+1
        );


      //��һ���ĸ������
      if (ALeftItem<>ARightItem)
        and (ALeftItem<>nil)
        and (ARightItem<>nil) then
      begin

        case Self.FHorzControlGestureManager.MouseMoveDirection of
          isdScrollToMin:
          begin
            //�������Ϲ���
            if (ALeftItem.ItemDrawRect.Right
                -Self.FSkinCustomListIntf.Prop.GetCenterItemRect.Left)
                //����ռ�������ж�
              /Self.FSkinCustomListIntf.Prop.FListLayoutsManager.ItemHeight>0.3
  //            >8
            then
            begin//��һ��
              FAdjustCenterItemPositionAnimator.Min:=0;
              FAdjustCenterItemPositionAnimator.Max:=(Self.FSkinCustomListIntf.Prop.FListLayoutsManager.ItemWidth
                  -(ALeftItem.ItemDrawRect.Right
                -Self.FSkinCustomListIntf.Prop.GetCenterItemRect.Left));
              FAdjustCenterItemPositionAnimator.DirectionType:=TAnimateDirectionType.adtBackward;
            end
            else
            begin//����
              FAdjustCenterItemPositionAnimator.Min:=0;
              FAdjustCenterItemPositionAnimator.Max:=(ALeftItem.ItemDrawRect.Right
                -Self.FSkinCustomListIntf.Prop.GetCenterItemRect.Left);
              FAdjustCenterItemPositionAnimator.DirectionType:=TAnimateDirectionType.adtForward;
            end;

          end;
          isdScrollToMax:
          begin
            //�������¹���
            //��ȥһ�����ƶ�
            //��һ��,�������¹���
            if (Self.FSkinCustomListIntf.Prop.GetCenterItemRect.Right
                  -ARightItem.ItemDrawRect.Left)
                  //����
              /Self.FSkinCustomListIntf.Prop.FListLayoutsManager.ItemWidth>0.3
              //����
  //            >8
              then
            begin//��һ��
              FAdjustCenterItemPositionAnimator.Min:=0;
              FAdjustCenterItemPositionAnimator.Max:=(Self.FSkinCustomListIntf.Prop.FListLayoutsManager.ItemWidth
                  -(Self.FSkinCustomListIntf.Prop.GetCenterItemRect.Right
                    -ARightItem.ItemDrawRect.Left));
              FAdjustCenterItemPositionAnimator.DirectionType:=TAnimateDirectionType.adtForward;
            end
            else
            begin//����
              FAdjustCenterItemPositionAnimator.Min:=0;
              FAdjustCenterItemPositionAnimator.Max:=(
                Self.FSkinCustomListIntf.Prop.GetCenterItemRect.Right
                -ARightItem.ItemDrawRect.Left);
              FAdjustCenterItemPositionAnimator.DirectionType:=TAnimateDirectionType.adtBackward;
            end;

          end;
        end;

        FAdjustCenterItemPositionAnimator.Start;
      end
      else
      begin
        //λ�øպ�
        DoAdjustCenterItemPositionAnimateEnd(Self);
      end;
  end;
end;

procedure TCustomListProperties.DoItemDelete(Sender:TObject;AItem:TObject;AIndex:Integer);
begin
  //�ж�һ��ѡ�е�,���ͣ������Ŀ�����ڲ�����
  if (FMouseDownItem<>nil) and (FMouseDownItem=AItem) then
  begin
    FMouseDownItem:=nil;
  end;
  if (FInteractiveMouseDownItem<>nil) and (FInteractiveMouseDownItem=AItem) then
  begin
    FInteractiveMouseDownItem:=nil;
  end;

  if (FLastMouseDownItem<>nil) and (FLastMouseDownItem=AItem) then
  begin
    FLastMouseDownItem:=nil;
  end;
  if (FInnerMouseDownItem<>nil) and (FInnerMouseDownItem=AItem) then
  begin
    FInnerMouseDownItem:=nil;
  end;
  if (FCenterItem<>nil) and (FCenterItem=AItem) then
  begin
    FCenterItem:=nil;
  end;
  if (FMouseOverItem<>nil) and (FMouseOverItem=AItem) then
  begin
    FMouseOverItem:=nil;
  end;
  if (FEditingItem<>nil) and (FEditingItem=AItem) then
  begin
    CancelEditingItem;
  end;
  if (FSelectedItem<>nil) and (FSelectedItem=AItem) then
  begin
//    uBaseLog.OutputDebugString('FSelectedItem Ϊnil DoItemDelete');
    FSelectedItem:=nil;
  end;
  if (FPanDragItem<>nil) and (FPanDragItem=AItem) then
  begin
    SetPanDragItem(nil);
  end;
end;

procedure TCustomListProperties.DoItemsChange(Sender: TObject);
begin
  if Self.FItems.HasItemDeleted
    //FVisibleItems�Ѿ��������
    //��Ȼ��
    and Not Self.FListLayoutsManager.FIsNeedReCalcVisibleItems then
  begin
      //�ж�һ��ѡ�е�,���ͣ������Ŀ�����ڲ�����
      if (FMouseDownItem<>nil) and (Self.FListLayoutsManager.GetVisibleItemObjectIndex(Self.FMouseDownItem)=-1) then
      begin
        FMouseDownItem:=nil;
      end;
      if (FInteractiveMouseDownItem<>nil) and (Self.FListLayoutsManager.GetVisibleItemObjectIndex(Self.FInteractiveMouseDownItem)=-1) then
      begin
        FInteractiveMouseDownItem:=nil;
      end;

      if (FLastMouseDownItem<>nil) and (Self.FListLayoutsManager.GetVisibleItemObjectIndex(Self.FLastMouseDownItem)=-1) then
      begin
        FLastMouseDownItem:=nil;
      end;
      if (FInnerMouseDownItem<>nil) and (Self.FListLayoutsManager.GetVisibleItemObjectIndex(Self.FInnerMouseDownItem)=-1) then
      begin
        FInnerMouseDownItem:=nil;
      end;
      if (FCenterItem<>nil) and (Self.FListLayoutsManager.GetVisibleItemObjectIndex(Self.FCenterItem)=-1) then
      begin
        FCenterItem:=nil;
      end;
      if (FMouseOverItem<>nil) and (Self.FListLayoutsManager.GetVisibleItemObjectIndex(Self.FMouseOverItem)=-1) then
      begin
        FMouseOverItem:=nil;
      end;
      if (FEditingItem<>nil) and (Self.FListLayoutsManager.GetVisibleItemObjectIndex(Self.FEditingItem)=-1) then
      begin
        CancelEditingItem;
      end;
      if (FSelectedItem<>nil) and (Self.FListLayoutsManager.GetVisibleItemObjectIndex(Self.FSelectedItem)=-1) then
      begin
//        uBaseLog.OutputDebugString('FSelectedItem Ϊnil DoItemsChange');
        FSelectedItem:=nil;
      end;
      if (FPanDragItem<>nil) and (Self.FListLayoutsManager.GetVisibleItemObjectIndex(Self.FPanDragItem)=-1) then
      begin
        SetPanDragItem(nil);
      end;
  end;
end;

procedure TCustomListProperties.DoItemSizeChange(Sender: TObject);
begin
//  uBaseLog.OutputDebugString('UpdateScrollBars In DoItemSizeChange');

  Self.UpdateScrollBars;
  Invalidate;
end;

procedure TCustomListProperties.DoItemVisibleChange(Sender: TObject);
begin
  //���������������,��ô��Ҫ���þ�����Ϊ��
  if (FCenterItem<>nil) and (not FCenterItem.Visible) then
  begin
    FCenterItem:=nil;
    //����
    Self.DoAdjustCenterItemPositionAnimateEnd(Self);
  end;

//  uBaseLog.OutputDebugString('UpdateScrollBars In DoItemVisibleChange');
  Self.UpdateScrollBars;

  Invalidate;
end;

procedure TCustomListProperties.DoMouseOverItemChange(ANewItem,AOldItem: TBaseSkinItem);
begin
  if Assigned(Self.FSkinCustomListIntf.OnMouseOverItemChange) then
  begin
    Self.FSkinCustomListIntf.OnMouseOverItemChange(Self);
  end;

end;

procedure TCustomListProperties.DoSetListLayoutsManagerSelectedItem(Sender: TObject);
begin
  //����ѡ�е��б���
  SelectedItem:=TBaseSkinItem(Sender);
end;


procedure TCustomListProperties.DoVert_InnerPositionChange(Sender: TObject);
begin
  inherited;

  //���µ�ǰ�༭�ı༭��
  SyncEditControlBounds;

end;

procedure TCustomListProperties.DoVert_InnerScrollToInitialAnimateEnd(Sender: TObject);
var
  ATopItem,ABottomItem:TBaseSkinItem;
begin
  inherited;

  //���þ���ѡ��ģʽ
  if Self.FIsEnabledCenterItemSelectMode
    //�й�������
    and (Self.FVertControlGestureManager.MouseMoveDirection<>isdNone)
    //��������1
    and (Self.FItems.Count>1) then
  begin
      //�жϵ�ǰ�������Լ�����
      FAdjustCenterItemPositionAnimator.Tag:=1;
      //�����������
      ATopItem:=Self.FSkinCustomListIntf.Prop.VisibleItemAt(
        Self.FSkinCustomListIntf.Prop.GetCenterItemRect.Left+1,
        Self.FSkinCustomListIntf.Prop.GetCenterItemRect.Top+1
        );
      ABottomItem:=Self.FSkinCustomListIntf.Prop.VisibleItemAt(
        Self.FSkinCustomListIntf.Prop.GetCenterItemRect.Left+1,
        Self.FSkinCustomListIntf.Prop.GetCenterItemRect.Bottom-1
        );


      //��һ���ĸ������
      if (ATopItem<>ABottomItem)
        and (ATopItem<>nil)
        and (ABottomItem<>nil) then
      begin

          case Self.FVertControlGestureManager.MouseMoveDirection of
            isdScrollToMin:
            begin
              //�������Ϲ���
              if (ATopItem.ItemDrawRect.Bottom
                  -Self.FSkinCustomListIntf.Prop.GetCenterItemRect.Top)
                  //����
                /Self.FSkinCustomListIntf.Prop.FListLayoutsManager.ItemHeight>0.3
              then
              begin//��һ��
                FAdjustCenterItemPositionAnimator.Min:=0;
                FAdjustCenterItemPositionAnimator.Max:=(Self.FSkinCustomListIntf.Prop.FListLayoutsManager.ItemHeight
                    -(ATopItem.ItemDrawRect.Bottom
                  -Self.FSkinCustomListIntf.Prop.GetCenterItemRect.Top));
                FAdjustCenterItemPositionAnimator.DirectionType:=TAnimateDirectionType.adtBackward;
              end
              else
              begin//����
                FAdjustCenterItemPositionAnimator.Min:=0;
                FAdjustCenterItemPositionAnimator.Max:=(ATopItem.ItemDrawRect.Bottom
                  -Self.FSkinCustomListIntf.Prop.GetCenterItemRect.Top);
                FAdjustCenterItemPositionAnimator.DirectionType:=TAnimateDirectionType.adtForward;
              end;

            end;
            isdScrollToMax:
            begin
              //�������¹���
              //��ȥһ�����ƶ�
              //��һ��,�������¹���
              if (Self.FSkinCustomListIntf.Prop.GetCenterItemRect.Bottom
                    -ABottomItem.ItemDrawRect.Top)
                    //����
                /Self.FSkinCustomListIntf.Prop.FListLayoutsManager.ItemHeight>0.3
                then
              begin//��һ��
                FAdjustCenterItemPositionAnimator.Min:=0;
                FAdjustCenterItemPositionAnimator.Max:=(Self.FSkinCustomListIntf.Prop.FListLayoutsManager.ItemHeight
                    -(Self.FSkinCustomListIntf.Prop.GetCenterItemRect.Bottom
                      -ABottomItem.ItemDrawRect.Top));
                FAdjustCenterItemPositionAnimator.DirectionType:=TAnimateDirectionType.adtForward;
              end
              else
              begin//����
                FAdjustCenterItemPositionAnimator.Min:=0;
                FAdjustCenterItemPositionAnimator.Max:=(
                  Self.FSkinCustomListIntf.Prop.GetCenterItemRect.Bottom
                  -ABottomItem.ItemDrawRect.Top);
                FAdjustCenterItemPositionAnimator.DirectionType:=TAnimateDirectionType.adtBackward;
              end;

            end;
          end;

          FAdjustCenterItemPositionAnimator.Start;
      end
      else
      begin
          //λ�øպ�
          DoAdjustCenterItemPositionAnimateEnd(Self);
      end;
  end;
end;

procedure TCustomListProperties.DoItemPropChange(Sender: TObject);
begin
  //�б������Ը���,��Ҫ�ػ�
  Invalidate;
end;

function TCustomListProperties.GetComponentClassify: String;
begin
  Result:='SkinCustomList';
end;

procedure TCustomListProperties.CancelEditingItem;
begin
  try
    if FEditingItem<>nil then
    begin

        //����ԭParent,����ԭλ��,ԭAlign
        FEditingItem_EditControl.Parent:=TParentControl(FEditingItem_EditControlOldParent);
  //      FEditingItem_EditControlIntf.SetBounds(FEditingItem_EditControlOldRect);
        FEditingItem_EditControl.SetBounds(ControlSize(FEditingItem_EditControlOldRect.Left),
                                           ControlSize(FEditingItem_EditControlOldRect.Top),
                                           ControlSize(FEditingItem_EditControlOldRect.Width),
                                           ControlSize(FEditingItem_EditControlOldRect.Height)
                                           );
        FEditingItem_EditControl.Align:=FEditingItem_EditControlOldAlign;


        FEditingItem:=nil;
        DoStopEditingItemEnd;

        FEditingItem_EditControl:=nil;
        FEditingItem_EditControlIntf:=nil;
        FEditingItem_EditControlOldParent:=nil;
        FEditingItem_EditControl_ItemEditorIntf:=nil;

    end;
  except
    on E:Exception do
    begin
      uBaseLog.HandleException(E,'OrangeUIControl','uSkinCustomListType','TCustomListProperties.CancelEditingItem');
    end;
  end;
end;

function TCustomListProperties.CanEnableItemPanDrag: Boolean;
begin
  Result:=False;
  if
      Self.FEnableItemPanDrag                 //����
    and (Self.FItemPanDragDesignerPanel<>nil) //����ƽ����ʾ���
    then
  begin
    Result:=True;
  end;
end;

function TCustomListProperties.GetCenterItem: TBaseSkinItem;
begin
  if FCenterItem=nil then
  begin
    DoAdjustCenterItemPositionAnimateEnd(Self);
  end;
  Result:=FCenterItem;
end;

function TCustomListProperties.GetCenterItemRect: TRectF;
begin
  Result:=Self.FListLayoutsManager.GetCenterItemRect;
end;

function TCustomListProperties.IsStartedItemPanDrag: Boolean;
begin
  Result:=False;
  if Self.CanEnableItemPanDrag
    and (Self.FPanDragItem<>nil) then
  begin
    Result:=True;
  end;
end;

function TCustomListProperties.GetInteractiveItem: TBaseSkinItem;
begin
  Result:=FInteractiveMouseDownItem;//FMouseOverItem;
end;

function TCustomListProperties.CalcItemHeight(AItem: TBaseSkinItem): Double;
begin
  Result:=FListLayoutsManager.CalcItemHeight(AItem);
end;

function TCustomListProperties.CalcItemWidth(AItem: TBaseSkinItem): Double;
begin
  Result:=FListLayoutsManager.CalcItemWidth(AItem);
end;

procedure TCustomListProperties.CallOnClickItemEvent(AItem: TBaseSkinItem);
begin
  if Assigned(Self.FSkinCustomListIntf.OnClickItem) then
  begin
    Self.FSkinCustomListIntf.OnClickItem(AItem);
  end;
end;

procedure TCustomListProperties.CallOnAdvancedDrawItemEvent(Sender: TObject;
  ACanvas: TDrawCanvas; AItem: TBaseSkinItem; AItemDrawRect: TRectF);
begin
  if Assigned(Self.FSkinCustomListIntf.OnAdvancedDrawItem) then
  begin
    Self.FSkinCustomListIntf.OnAdvancedDrawItem(Self,ACanvas,AItem,RectF2Rect(AItemDrawRect));
  end;
end;

procedure TCustomListProperties.CallOnCenterItemChangeEvent(Sender: TObject;AItem: TBaseSkinItem);
begin
  if Assigned(Self.FSkinCustomListIntf.OnCenterItemChange) then
  begin
    Self.FSkinCustomListIntf.OnCenterItemChange(Self,AItem);
  end;
end;

procedure TCustomListProperties.CallOnStartEditingItemEvent(Sender: TObject;
  AItem: TBaseSkinItem; AEditControl: TChildControl);
begin
  if Assigned(Self.FSkinCustomListIntf.OnStartEditingItem) then
  begin
    FSkinCustomListIntf.OnStartEditingItem(Sender,TBaseSkinItem(AItem),AEditControl);
  end;
end;

procedure TCustomListProperties.CallOnStopEditingItemEvent(Sender: TObject;
  AItem: TBaseSkinItem; AEditControl: TChildControl);
begin
  if Assigned(Self.FSkinCustomListIntf.OnStopEditingItem) then
  begin
    FSkinCustomListIntf.OnStopEditingItem(Sender,TBaseSkinItem(AItem),AEditControl);
  end;
end;

procedure TCustomListProperties.CallOnClickItemExEvent(AItem: TBaseSkinItem; X,Y: Double);
begin
  if Assigned(Self.FSkinCustomListIntf.OnClickItemEx) then
  begin
    Self.FSkinCustomListIntf.OnClickItemEx(Self.FSkinControl,
                                            AItem,
                                            X-AItem.ItemDrawRect.Left,
                                            Y-AItem.ItemDrawRect.Top);
  end;
end;

procedure TCustomListProperties.CallOnLongTapItemEvent(Sender: TObject;AItem: TBaseSkinItem);
begin
  if Assigned(Self.FSkinCustomListIntf.OnLongTapItem) and (MouseDownItem<>nil) then
  begin
    FHasCalledOnLongTapItem:=True;
    //������LongTap֮��,�Ͳ��ٵ���ClickItem��
    Self.FSkinCustomListIntf.OnLongTapItem(Self,AItem);
  end;
end;

procedure TCustomListProperties.CallOnPrepareDrawItemEvent(
  Sender: TObject;
  ACanvas: TDrawCanvas;
  AItem: TBaseSkinItem;
  AItemDrawRect: TRectF;
  AIsDrawItemInteractiveState:Boolean);
begin
  if Assigned(Self.FSkinCustomListIntf.OnPrepareDrawItem) then
  begin
    //�ֶ���ֵ
    Self.FSkinCustomListIntf.OnPrepareDrawItem(Self,ACanvas,AItem,RectF2Rect(AItemDrawRect));
  end;
end;

procedure TCustomListProperties.CallOnPrepareItemPanDrag(Sender: TObject;AItem: TBaseSkinItem; var AItemIsCanPanDrag: Boolean);
begin
  if Assigned(Self.FSkinCustomListIntf.OnPrepareItemPanDrag) then
  begin
    Self.FSkinCustomListIntf.OnPrepareItemPanDrag(Self,AItem,AItemIsCanPanDrag);
  end;
end;

procedure TCustomListProperties.CallOnSelectedItemEvent(Sender: TObject;AItem: TBaseSkinItem);
begin
  if Assigned(Self.FSkinCustomListIntf.OnSelectedItem) then
  begin
    FSkinCustomListIntf.OnSelectedItem(Sender,AItem);
  end;
end;

function TCustomListProperties.HasOnLongTapItemEvent: Boolean;
begin
  Result:=Assigned(Self.FSkinCustomListIntf.OnLongTapItem);
end;

function TCustomListProperties.GetPanDragItemDesignerPanelDrawRect: TRectF;
begin
    //��ȡƽ��������Ļ��ƾ���
    Result:=Self.VisibleItemDrawRect(FPanDragItem);

    case Self.FItemPanDragGestureDirection of
      ipdgdtLeft:
      begin
        Result.Left:=Result.Right
                      -Self.FItemPanDragGestureManager.Position;
        Result.Right:=Result.Left+Self.FItemPanDragGestureManager.Max;
      end;
      ipdgdtRight:
      begin
        Result.Left:=Result.Left
                      -Self.FItemPanDragGestureManager.Position;
        Result.Right:=Result.Left+Self.FItemPanDragGestureManager.Max;
      end;
//      ipdgdtTop:
//      begin
//        Result.Top:=Result.Bottom-Self.FItemPanDragDesignerPanel.Height;
//      end;
//      ipdgdtBottom:
//      begin
//        Result.Bottom:=Result.Top+Self.FItemPanDragDesignerPanel.Height;
//      end;
    end;

end;

function TCustomListProperties.GetPanDragItemDrawRect: TRectF;
begin
    //��ȡƽ���б���Ļ������
    Result:=Self.VisibleItemDrawRect(FPanDragItem);

    case Self.FItemPanDragGestureDirection of
      ipdgdtLeft:
      begin
        //��ȡƽ�ϵ�λ��,������
        OffsetRect(Result,-Self.FItemPanDragGestureManager.Position,0);
      end;
      ipdgdtRight:
      begin
        //��ȡƽ�ϵ�λ��,������
        OffsetRect(Result,
              Self.FItemPanDragGestureManager.Max-Self.FItemPanDragGestureManager.Position,0);
      end;
//      ipdgdtTop:
//      begin
//        //��ȡƽ�ϵ�λ��
//        OffsetRect(Result,
//              0,-Self.FItemPanDragGestureManager.Position
//              );
//      end;
//      ipdgdtBottom:
//      begin
//        //��ȡƽ�ϵ�λ��
//        OffsetRect(Result,
//              0,Self.FItemPanDragGestureManager.Position
//              );
//      end;
    end;
end;

procedure TCustomListProperties.GetPropJson(ASuperObject: ISuperObject);
begin
  inherited;

  if ItemWidthCalcType<>isctSeparate then ASuperObject.S['ItemSizeCalcType']:=GetItemSizeCalcTypeStr(ItemWidthCalcType);
  if ItemLayoutType<>iltVertical then ASuperObject.S['ItemLayoutType']:=GetItemLayoutTypeStr(ItemLayoutType);


  {$IFDEF FMX}
  ASuperObject.F['ItemWidth']:=ItemWidth;
  ASuperObject.F['ItemHeight']:=ItemHeight;
  if SelectedItemWidth<>-1 then ASuperObject.F['SelectedItemWidth']:=SelectedItemWidth;
  if SelectedItemHeight<>-1 then ASuperObject.F['SelectedItemHeight']:=SelectedItemHeight;
  if ItemSpace<>0 then ASuperObject.F['ItemSpace']:=ItemSpace;
  {$ENDIF FMX}


  if ItemSpaceType<>sistDefault then ASuperObject.S['ItemSpaceType']:=GetItemSpaceTypeStr(ItemSpaceType);

//      //�Զ�������ʾ������
//      FHorzScrollBarShowType:=sbstNone;
//      FVertScrollBarShowType:=sbstAutoCoverShow;

  if VertScrollBarShowType<>sbstAutoCoverShow then ASuperObject.S['VertScrollBarShowType']:=GetScrollBarShowTypeStr(VertScrollBarShowType);
  if HorzScrollBarShowType<>sbstNone then ASuperObject.S['HorzScrollBarShowType']:=GetScrollBarShowTypeStr(HorzScrollBarShowType);



  if MultiSelect then ASuperObject.B['MultiSelect']:=MultiSelect;
  if not IsAutoSelected then ASuperObject.B['IsAutoSelected']:=IsAutoSelected;

end;

function TCustomListProperties.GetItemHeight: Double;
begin
  Result:=Self.FListLayoutsManager.ItemHeight;
end;

function TCustomListProperties.GetItemSpace: Double;
begin
  Result:=Self.FListLayoutsManager.ItemSpace;
end;

function TCustomListProperties.GetItemSpaceType: TSkinItemSpaceType;
begin
  Result:=Self.FListLayoutsManager.ItemSpaceType;
end;

function TCustomListProperties.GetItemTopDrawOffset: Double;
begin
  Result:=0;
end;

function TCustomListProperties.GetSelectedItemHeight: Double;
begin
  Result:=Self.FListLayoutsManager.SelectedItemHeight;
end;

function TCustomListProperties.GetSelectedItemWidth: Double;
begin
  Result:=Self.FListLayoutsManager.SelectedItemWidth;
end;

function TCustomListProperties.GetCenterItemSelectModeTopDrawOffset: Double;
begin
  Result:=0;
  if Self.FIsEnabledCenterItemSelectMode then
  begin
    case Self.FListLayoutsManager.ItemLayoutType of
      iltVertical:
      begin
        Result:=Result+(Self.GetClientRect.Height-FListLayoutsManager.ItemHeight)/2;
      end;
      iltHorizontal:
      begin
        Result:=0;
      end;
    end;
  end;
end;

function TCustomListProperties.GetItemHeightCalcType: TItemSizeCalcType;
begin
  Result:=Self.FListLayoutsManager.ItemSizeCalcType;
end;

function TCustomListProperties.GetItemLayoutType: TItemLayoutType;
begin
  Result:=Self.FListLayoutsManager.ItemLayoutType;
end;

function TCustomListProperties.GetItemWidthCalcType: TItemSizeCalcType;
begin
  Result:=Self.FListLayoutsManager.ItemSizeCalcType;
end;

function TCustomListProperties.GetCenterItemSelectModeLeftDrawOffset: Double;
begin
  Result:=0;
  if Self.FIsEnabledCenterItemSelectMode then
  begin
    case Self.FListLayoutsManager.ItemLayoutType of
      iltVertical:
      begin
        Result:=0;
      end;
      iltHorizontal:
      begin
        Result:=Result+(Self.GetClientRect.Width-FListLayoutsManager.ItemWidth)/2;
      end;
    end;
  end;
end;

function TCustomListProperties.GetItemsClass: TBaseSkinItemsClass;
begin
  Result:=TBaseSkinItems;
end;

function TCustomListProperties.GetCustomListLayoutsManagerClass: TSkinCustomListLayoutsManagerClass;
begin
  Result:=TSkinCustomListLayoutsManager;
end;

function TCustomListProperties.GetItemWidth: Double;
begin
  Result:=Self.FListLayoutsManager.ItemWidth;
end;

procedure TCustomListProperties.AddNewDesignerPanel(const ANewItemDesignerPanel: TSkinItemDesignerPanel);
begin
  if ANewItemDesignerPanel<>nil then
  begin
    ANewItemDesignerPanel.Properties.BindControlInvalidateChange.RegisterChanges(Self.FItemDesignerPanelInvalidateLink);
    //ANewItemDesignerPanel�ͷŵ�ʱ��֪ͨFSkinControl
    AddFreeNotification(ANewItemDesignerPanel,Self.FSkinControl);
  end;
  Invalidate;
end;

procedure TCustomListProperties.AssignProperties(Src: TSkinControlProperties);
begin
  inherited;
//  FIsAutoSelected:=TCustomListProperties(Src).FIsAutoSelected;
//
//
//  FItemDrawType:=TCustomListProperties(Src).FItemDrawType;
//
//  FItems.Assign(TCustomListProperties(Src).FItems);
//
//  FListLayoutsManager.StaticItemWidth:=TCustomListProperties(Src).FListLayoutsManager.StaticItemWidth;
//  FListLayoutsManager.StaticItemHeight:=TCustomListProperties(Src).FListLayoutsManager.StaticItemHeight;
//  FListLayoutsManager.StaticItemSizeCalcType:=TCustomListProperties(Src).FListLayoutsManager.StaticItemSizeCalcType;
//
//  FSkinImageList:=TCustomListProperties(Src).FSkinImageList;
//  SetSkinImageList(FSkinImageList);
//
//
//
//  FItemDesignerPanel:=TCustomListProperties(Src).FItemDesignerPanel;
//  FItem1DesignerPanel:=TCustomListProperties(Src).FItem1DesignerPanel;
//  FItem2DesignerPanel:=TCustomListProperties(Src).FItem2DesignerPanel;
//  FItem3DesignerPanel:=TCustomListProperties(Src).FItem3DesignerPanel;
//  FItem4DesignerPanel:=TCustomListProperties(Src).FItem4DesignerPanel;
//  FHeaderDesignerPanel:=TCustomListProperties(Src).FHeaderDesignerPanel;
//  FFooterDesignerPanel:=TCustomListProperties(Src).FFooterDesignerPanel;
//  FSearchBarDesignerPanel:=TCustomListProperties(Src).FSearchBarDesignerPanel;
//  FItemPanDragDesignerPanel:=TCustomListProperties(Src).FItemPanDragDesignerPanel;
//
//
//
//
//  //�б���ƽ�ϵķ���
//  FItemPanDragGestureDirection:=TCustomListProperties(Src).FItemPanDragGestureDirection;
//
////  //����ƽ��λ��
////  FMaxItemPanDragPosition:=TCustomListProperties(Src).FMaxItemPanDragPosition;
////  //��С��ƽ��λ��
////  FMinItemPanDragPosition:=TCustomListProperties(Src).FMinItemPanDragPosition;
//
//
//  //�Ƿ�����ƽ��
//  FEnableItemPanDrag:=TCustomListProperties(Src).FEnableItemPanDrag;
//
//
////  //��ʼƽ�ϵ�����
////  FDecideStartItemPanDragPosition:=TCustomListProperties(Src).FDecideStartItemPanDragPosition;


end;

procedure TCustomListProperties.ScrollToItem(Item: TBaseSkinItem);
var
  AVisibleItemIndex:Integer;
  AItemRect:TRectF;
begin
//  uBaseLog.OutputDebugString('UpdateScrollBars In ScrollToItem');
  UpdateScrollBars;

  AVisibleItemIndex:=Self.FListLayoutsManager.GetVisibleItemObjectIndex(Item);
  if (AVisibleItemIndex <> -1) and (AVisibleItemIndex<Self.FListLayoutsManager.GetVisibleItemsCount) then
  begin
        //���ѡ�е��б����ڿ���������,��ô�ƶ��Ŀ���������
        AItemRect:=Self.FListLayoutsManager.VisibleItemRectByIndex(AVisibleItemIndex);


        if (AItemRect.Top - Self.FVertControlGestureManager.Position < Self.GetClientRect.Top) then
        begin
          Self.FVertControlGestureManager.Position:=AItemRect.Top;
        end;
        if (AItemRect.Bottom - Self.FVertControlGestureManager.Position > Self.GetClientRect.Bottom) then
        begin
          if Self.FVertControlGestureManager.Max<AItemRect.Bottom then
          begin
            Self.FVertControlGestureManager.Position:=AItemRect.Bottom;
          end
          else
          begin
            Self.FVertControlGestureManager.Position:=AItemRect.Top;
          end;
        end;

  end;
end;

procedure TCustomListProperties.SetIsEmptyContent(const Value: Boolean);
begin
  if FIsEmptyContent<>Value then
  begin
    FIsEmptyContent := Value;
    Self.Invalidate;
  end;
end;

procedure TCustomListProperties.SetIsEnabledCenterItemSelectMode(const Value: Boolean);
begin
  if FIsEnabledCenterItemSelectMode<>Value then
  begin
    FIsEnabledCenterItemSelectMode := Value;
    DoAdjustCenterItemPositionAnimateEnd(Self);
  end;
end;

procedure TCustomListProperties.SetItemPanDragDesignerPanel(const Value: TSkinItemDesignerPanel);
begin
  if FItemPanDragDesignerPanel <> Value then
  begin
    RemoveOldDesignerPanel(FItemPanDragDesignerPanel);
    FItemPanDragDesignerPanel:=Value;
    AddNewDesignerPanel(FItemPanDragDesignerPanel);
  end;
end;

procedure TCustomListProperties.SetCenterItem(Value: TBaseSkinItem);
begin
  DoSetCenterItem(Value);
  if Self.FIsEnabledCenterItemSelectMode then
  begin
    DoSetSelectedItem(Value);
  end;
end;

procedure TCustomListProperties.SetEmptyContentCaption(
  const Value: String);
begin
  if FEmptyContentCaption<>Value then
  begin
    FEmptyContentCaption := Value;
    Self.Invalidate;
  end;
end;

procedure TCustomListProperties.SetEmptyContentControl(const Value: TControl);
begin
  if FEmptyContentControl<>Value then
  begin


    if FEmptyContentControl<>nil then
    begin
      RemoveFreeNotification(FEmptyContentControl,Self.FSkinControl);
    end;


    FEmptyContentControl := Value;

    if FEmptyContentControl<>nil then
    begin
      AddFreeNotification(FEmptyContentControl,Self.FSkinControl);
    end;

    Self.Invalidate;
  end;
end;

procedure TCustomListProperties.SetEmptyContentDescription(
  const Value: String);
begin
  if FEmptyContentDescription<>Value then
  begin
    FEmptyContentDescription := Value;
    Self.Invalidate;
  end;
end;

procedure TCustomListProperties.SetEmptyContentPicture(
  const Value: TDrawPicture);
begin
  FEmptyContentPicture.Assign(Value);
end;

procedure TCustomListProperties.StartCheckLongTapItemTimer;
begin
  if FCheckLongTapItemTimer<>nil then
  begin
    FCheckLongTapItemTimer.Enabled:=True;
  end;
end;

procedure TCustomListProperties.StartCheckStayPressedItemTimer;
begin
  if FCheckStayPressedItemTimer<>nil then
  begin
    FCheckStayPressedItemTimer.Enabled:=True;
  end;
end;

procedure TCustomListProperties.SyncEditControlBounds;
var
  AItemDrawRect:TRectF;
  AParent:TControl;
begin
  if Self.FEditingItem<>nil then
  begin
    AItemDrawRect:=Self.VisibleItemDrawRect(FEditingItem);

    Self.FEditingItem_EditControl.SetBounds(
                //�ü��ϲ㼶ƫ��
                ControlSize(AItemDrawRect.Left
                              +FEditingItem_EditControlPutRect.Left),
                ControlSize(AItemDrawRect.Top
                              +FEditingItem_EditControlPutRect.Top),
                ControlSize(Self.FEditingItem_EditControlPutRect.Width),
                ControlSize(Self.FEditingItem_EditControlPutRect.Height)
                );

  end;

end;

function TCustomListProperties.StartEditingItem(
                                                AItem: TBaseSkinItem;
                                                AEditControl: TControl;
                                                AEditControlPutRect: TRectF;
                                                AEditValue:String;
                                                X, Y: Double):Boolean;
begin

    Result:=False;

    if (FEditingItem=AItem)
      and (FEditingItem_EditControl=AEditControl) then
    begin
      //�ظ�������ͬ�ı༭,��ôֱ���˳�
      Exit;
    end;


    //ֹͣ�༭�ϴε��б���
    if FEditingItem<>nil then
    begin
      FEditingItem.DoPropChange;
      StopEditingItem;
    end;


    if AItem=nil then
    begin
      Exit;
    end;


    //����Ҫ�б༭�ؼ�
    if AEditControl=nil then
    begin
      Exit;
    end;


    FEditingItem_EditControl:=TControl(AEditControl);
    //��һ��Ҫ֧��ISkinControl,
    //���֧�����ISkinControl,�������ܹ�����ParentMouseEvent
    FEditingItem_EditControl.GetInterface(IID_ISkinControl,FEditingItem_EditControlIntf);



    //��EditControl��ԭ���ĵط�ȥ��,
    //��ʾ��ListBox��,
    //������ParentΪListBox
    FEditingItem:=AItem;
    FEditingItem.DoPropChange;
    Invalidate;


    //�༭�������ItemRect��λ��
    FEditingItem_EditControlPutRect:=AEditControlPutRect;



    //����ԭ��Ϣ,�Խ����༭ʱ���ڻָ�//
    //ԭParent
    FEditingItem_EditControlOldParent:=FEditingItem_EditControl.Parent;
    //ԭλ�úͳߴ�
    FEditingItem_EditControlOldRect.Left:=GetControlLeft(FEditingItem_EditControl);
    FEditingItem_EditControlOldRect.Top:=GetControlTop(FEditingItem_EditControl);
    FEditingItem_EditControlOldRect.Width:=FEditingItem_EditControl.Width;
    FEditingItem_EditControlOldRect.Height:=FEditingItem_EditControl.Height;
    //ԭAlign
    FEditingItem_EditControlOldAlign:=FEditingItem_EditControl.Align;



    //������λ��
    FEditingItem_EditControl.Align:={$IFDEF FMX}TAlignLayout.None{$ENDIF}{$IFDEF VCL}TAlignLayout.alNone{$ENDIF};
    if FEditingItem_EditControlIntf<>nil then
    begin
      //������ʱ�򴫵���Ϣ��ListBox
//      FEditingItem_EditControlIntf.ParentMouseEvent:=True;
      FEditingItem_EditControlIntf.ParentMouseEvent:=False;
      FEditingItem_EditControlIntf.MouseEventTransToParentType:=mettptNotTrans;
      //  edtCount.ParentMouseEvent:=False;
      //  edtCount.MouseEventTransToParentType:=mettptNotTrans;
    end;
    //�����µ�λ��
    Self.SyncEditControlBounds;

    //���ñ༭�ؼ���ParentΪListBox
    FEditingItem_EditControl.Parent:=TParentControl(Self.FSkinControl);
    //��ʾ
    FEditingItem_EditControl.Visible:=True;



    //���������Ϣ���ݸ�Edit,�Ա���Զ�λ���Ǳ༭�ĸ��ַ�
    if (FEditingItem_EditControl<>nil)
      and FEditingItem_EditControl.GetInterface(IID_ICustomListItemEditor,FEditingItem_EditControl_ItemEditorIntf) then
    begin

        //����ֵ
        FEditingItem_EditControl_ItemEditorIntf.EditSetValue(AEditValue);
        //��λ������
        FEditingItem_EditControl_ItemEditorIntf.EditMouseDown(TMouseButton.mbLeft,[ssLeft],X,Y);
        FEditingItem_EditControl_ItemEditorIntf.EditMouseMove([],X,Y);
        FEditingItem_EditControl_ItemEditorIntf.EditMouseUp(TMouseButton.mbLeft,[ssLeft],X,Y);

    end
    else
    begin

        //���б����ֵ�����༭�ؼ�TEdit,TComboBox֮���
        //����ȡ����
        SetValueToEditControl(FEditingItem_EditControl,AEditValue);


        {$IFDEF FMX}
        if TControl(FEditingItem_EditControl).CanFocus then
        begin
          TControl(FEditingItem_EditControl).SetFocus;
        end;
        {$ELSE}
        if TParentControl(FEditingItem_EditControl).CanFocus then
        begin
          TParentControl(FEditingItem_EditControl).SetFocus;
        end;
        {$ENDIF}

    end;


    //�����༭,��ʱ,���Ը�FEditingItem_EditControl����ֵ,
    //�����AItem.Detail����TEdit
    CallOnStartEditingItemEvent(Self,
                                AItem,
                                FEditingItem_EditControl
                                );

    Result:=True;
end;

procedure TCustomListProperties.StartCallOnClickItemTimer;
begin
  if FCallOnClickItemTimer<>nil then
  begin
    FCallOnClickItemTimer.Enabled:=True;
  end;
end;

procedure TCustomListProperties.StartItemPanDrag(AItem: TBaseSkinItem);
begin
  if CanEnableItemPanDrag and (AItem<>nil) then
  begin

      FPanDragItem:=AItem;
      FIsStopingItemPanDrag:=False;
      Self.FItemPanDragGestureManager.ScrollingToInitialAnimator.Pause;

      PrepareItemPanDrag(AItem);

//      OutputDebugString('�ֶ���ʼƽ��');
      case FItemPanDragGestureDirection of
        ipdgdtLeft:
        begin
          Self.FItemPanDragGestureManager.DoInertiaScroll(
                                    FStartItemPanDragVelocity,
                                    Self.FItemPanDragGestureManager.Max+20);
        end;
        ipdgdtRight:
        begin
          Self.FItemPanDragGestureManager.DoInertiaScroll(
                                    -FStartItemPanDragVelocity,
                                    Self.FItemPanDragGestureManager.Max+20);
        end;
  //      ipdgdtTop: ;
  //      ipdgdtBottom: ;
      end;

  end;
end;

procedure TCustomListProperties.StopCheckLongTapItemTimer;
begin
  if FCheckLongTapItemTimer<>nil then
  begin
    FCheckLongTapItemTimer.Enabled:=False;
  end;
end;

procedure TCustomListProperties.StopCheckStayPressedItemTimer;
begin
  if FCheckStayPressedItemTimer<>nil then
  begin
    FCheckStayPressedItemTimer.Enabled:=False;
  end;
end;

procedure TCustomListProperties.StopEditingItem;
begin
  try
    if FEditingItem<>nil then
    begin


        //����ֵ
        DoSetValueToEditingItem;


        //��EditControl�޸ĺõ�ֵ���ظ�EditingItem
        CallOnStopEditingItemEvent(Self,FEditingItem,FEditingItem_EditControl);



        //����ԭParent,����ԭλ��,ԭAlign
        FEditingItem_EditControl.Parent:=TParentControl(FEditingItem_EditControlOldParent);
        FEditingItem_EditControl.SetBounds(
                                          ControlSize(FEditingItem_EditControlOldRect.Left),
                                          ControlSize(FEditingItem_EditControlOldRect.Top),
                                          ControlSize(FEditingItem_EditControlOldRect.Width),
                                          ControlSize(FEditingItem_EditControlOldRect.Height)
                                          );
        FEditingItem_EditControl.Align:=FEditingItem_EditControlOldAlign;



        FEditingItem:=nil;

        DoStopEditingItemEnd;

        FEditingItem_EditControl:=nil;
        FEditingItem_EditControlIntf:=nil;
        FEditingItem_EditControlOldParent:=nil;
        FEditingItem_EditControl_ItemEditorIntf:=nil;


    end;
  except
    on E:Exception do
    begin
      uBaseLog.HandleException(E,'OrangeUIControl','uSkinCustomListType','TCustomListProperties.StopEditingItem');
    end;
  end;

end;

procedure TCustomListProperties.StopCallOnClickItemTimer;
begin
  if FCallOnClickItemTimer<>nil then
  begin
    FCallOnClickItemTimer.Enabled:=False;
  end;
end;

procedure TCustomListProperties.StopItemPanDrag;
begin
  if (FPanDragItem<>nil) then
  begin
//    OutputDebugString('�ֶ�����ƽ��');
    FIsStopingItemPanDrag:=True;
    Self.FItemPanDragGestureManager.InertiaScrollAnimator.Pause;
    case FItemPanDragGestureDirection of
      ipdgdtLeft:
      begin
        Self.FItemPanDragGestureManager.DoInertiaScroll(-FStartItemPanDragVelocity,
                                      FItemPanDragGestureManager.Max+20);
      end;
      ipdgdtRight:
      begin
        Self.FItemPanDragGestureManager.DoInertiaScroll(FStartItemPanDragVelocity,
                                      FItemPanDragGestureManager.Max+20);
      end;
//      ipdgdtTop: ;
//      ipdgdtBottom: ;
    end;
  end;
end;

procedure TCustomListProperties.SetItemHeight(const Value: Double);
begin
  FListLayoutsManager.ItemHeight:=Value;
end;

procedure TCustomListProperties.SetSelectedItem(Value: TBaseSkinItem);
begin
  if FSelectedItem<>Value then
  begin
    DoSetSelectedItem(Value);


    //����ѡ��
    if Self.FIsEnabledCenterItemSelectMode then
    begin
      DoSetCenterItem(Value);
    end;
  end;
end;

procedure TCustomListProperties.SetSelectedItemHeight(const Value: Double);
begin
  FListLayoutsManager.SelectedItemHeight:=Value;
end;

procedure TCustomListProperties.SetSelectedItemWidth(const Value: Double);
begin
  FListLayoutsManager.SelectedItemWidth:=Value;
end;

procedure TCustomListProperties.SetItemWidth(const Value: Double);
begin
  FListLayoutsManager.ItemWidth:=Value;
end;

procedure TCustomListProperties.SetItemSpace(const Value: Double);
begin
  FListLayoutsManager.ItemSpace:=Value;
end;

procedure TCustomListProperties.SetItemSpaceType(const Value: TSkinItemSpaceType);
begin
  FListLayoutsManager.ItemSpaceType:=Value;
end;

procedure TCustomListProperties.SetItemHeightCalcType(const Value: TItemSizeCalcType);
begin
  FListLayoutsManager.ItemSizeCalcType:=Value;
end;

procedure TCustomListProperties.SetItemLayoutType(const Value: TItemLayoutType);
begin
  FListLayoutsManager.ItemLayoutType:=Value;
end;

procedure TCustomListProperties.SetItemWidthCalcType(const Value: TItemSizeCalcType);
begin
  //�����ϵ�
  FListLayoutsManager.ItemSizeCalcType:=Value;
end;

function TCustomListProperties.SetListBoxItemStyle(AItemType: TSkinItemType;
  AListItemStyle: String): Boolean;
begin
  Result:=True;
end;

procedure TCustomListProperties.SetItems(const Value: TBaseSkinItems);
begin
  FItems.Assign(Value);
end;

procedure TCustomListProperties.SetMouseDownItem(Value: TBaseSkinItem);
begin
  if FMouseDownItem<>Value then
  begin
    FMouseDownItem := Value;
    Invalidate;
  end;
end;

procedure TCustomListProperties.DoSetCenterItem(Value: TBaseSkinItem);
begin

  //����CenterItem
  if FCenterItem<>nil then
  begin
    FCenterItem.DoPropChange;
  end;

  FCenterItem := Value;

  Self.CallOnCenterItemChangeEvent(Self,FCenterItem);

  if FCenterItem<>nil then
  begin
    FCenterItem.DoPropChange;
  end;


  Invalidate;


  if (FCenterItem<>nil) then
  begin
    case Self.FListLayoutsManager.ItemLayoutType of
      iltVertical:
      begin
        //����λ��(�þ���ѡ����б�����ʾ�ڽ�����)
        Self.FVertControlGestureManager.Position:=
          //����
          Self.VisibleItemRect(Self.FListLayoutsManager.GetVisibleItemObjectIndex(FCenterItem)).Top
          ;
      end;
      iltHorizontal: ;
    end;
  end;
end;

procedure TCustomListProperties.SetPanDragItem(Value: TBaseSkinItem);
begin
  if FPanDragItem<>Value then
  begin
    if FPanDragItem<>nil then
    begin
      FPanDragItem.DoPropChange;
    end;

    FPanDragItem:=Value;

    if FPanDragItem<>nil then
    begin
      FPanDragItem.DoPropChange;
    end;


    Invalidate;
  end;
end;

procedure TCustomListProperties.SetPropJson(ASuperObject: ISuperObject);
begin
  inherited;



//  {$IFDEF FMX}
  {$IF CompilerVersion >= 30.0}
  if ASuperObject.Contains('ItemSizeCalcType') then ItemWidthCalcType:=GetItemSizeCalcTypeByStr(ASuperObject.S['ItemSizeCalcType']);
  if ASuperObject.Contains('ItemLayoutType') then ItemLayoutType:=GetItemLayoutTypeByStr(ASuperObject.S['ItemLayoutType']);

  if ASuperObject.Contains('ItemWidth') then ItemWidth:=ASuperObject.{$IFDEF FMX}F{$ELSE}F{$ENDIF}['ItemWidth'];
  if ASuperObject.Contains('ItemHeight') then ItemHeight:=ASuperObject.{$IFDEF FMX}F{$ELSE}F{$ENDIF}['ItemHeight'];
  if ASuperObject.Contains('SelectedItemWidth') then SelectedItemWidth:=ASuperObject.{$IFDEF FMX}F{$ELSE}F{$ENDIF}['SelectedItemWidth'];
  if ASuperObject.Contains('SelectedItemHeight') then SelectedItemHeight:=ASuperObject.{$IFDEF FMX}F{$ELSE}F{$ENDIF}['SelectedItemHeight'];
  if ASuperObject.Contains('ItemSpace') then ItemSpace:=ASuperObject.{$IFDEF FMX}F{$ELSE}I{$ENDIF}['ItemSpace'];
  if ASuperObject.Contains('ItemSpaceType') then ItemSpaceType:=GetItemSpaceTypeByStr(ASuperObject.S['ItemSpaceType']);

  if ASuperObject.Contains('VertScrollBarShowType') then VertScrollBarShowType:=GetScrollBarShowTypeByStr(ASuperObject.S['VertScrollBarShowType']);
  if ASuperObject.Contains('HorzScrollBarShowType') then HorzScrollBarShowType:=GetScrollBarShowTypeByStr(ASuperObject.S['HorzScrollBarShowType']);

  if ASuperObject.Contains('VertCanOverRangeTypes') then Self.VertCanOverRangeTypes:=GetScrollBarOverRangeTypeByStr(ASuperObject.S['VertCanOverRangeTypes']);
  if ASuperObject.Contains('HorzCanOverRangeTypes') then HorzCanOverRangeTypes:=GetScrollBarOverRangeTypeByStr(ASuperObject.S['HorzCanOverRangeTypes']);

//  AFieldControlSetting.PropJson.B['EnableAutoPullDownRefreshPanel']:=False;
//  AFieldControlSetting.PropJson.B['EnableAutoPullUpLoadMorePanel']:=False;
  if ASuperObject.Contains('EnableAutoPullDownRefreshPanel') then EnableAutoPullDownRefreshPanel:=ASuperObject.B['EnableAutoPullDownRefreshPanel'];
  if ASuperObject.Contains('EnableAutoPullUpLoadMorePanel') then EnableAutoPullUpLoadMorePanel:=ASuperObject.B['EnableAutoPullUpLoadMorePanel'];

  if ASuperObject.Contains('MultiSelect') then MultiSelect:=ASuperObject.B['MultiSelect'];
  if ASuperObject.Contains('IsAutoSelected') then IsAutoSelected:=ASuperObject.B['IsAutoSelected'];
  {$IFEND}
//  {$ENDIF FMX}


end;

procedure TCustomListProperties.SetMouseOverItem(Value: TBaseSkinItem);
begin
  if FMouseOverItem<>Value then
  begin
    if FMouseOverItem<>nil then
    begin
      FMouseOverItem.IsBufferNeedChange:=True;
    end;

    DoMouseOverItemChange(Value,FMouseOverItem);

    FMouseOverItem := Value;

    //��ΪFMouseOverItem�Ĺ���֮��,Ҫ��ִ��һ��
    DoMouseOverItemChange(FMouseOverItem,nil);


    if FMouseOverItem<>nil then
    begin
      FMouseOverItem.IsBufferNeedChange:=True;
    end;

    Invalidate;
  end;
end;

procedure TCustomListProperties.DoSetSelectedItem(Value: TBaseSkinItem);
begin
  if FSelectedItem<>Value then
  begin

      //����ǵ�ѡ��,��ô֮ǰѡ�е��б���ȡ��ѡ��
      if FSelectedItem<>nil then
      begin
  //        uBaseLog.OutputDebugString('--ȡ��ѡ�� ');
          if not Self.FMultiSelect then
          begin
            FSelectedItem.StaticSelected:=False;
          end;
          FSelectedItem.DoPropChange;

      end
      else
      begin
  //        uBaseLog.OutputDebugString('FSelectedItem Ϊnil');
      end;

      FSelectedItem := Value;

      if FSelectedItem<>nil then
      begin
  //        uBaseLog.OutputDebugString('--ѡ�� ');
          FSelectedItem.StaticSelected:=True;
          FSelectedItem.DoPropChange;

          CallOnSelectedItemEvent(Self,FSelectedItem);
      end;


      //���ѡ���б���Ŀ�Ⱥ͸߶��������Ŀ�Ⱥ͸߶Ȳ�һ��,
      //��ô��Ҫ���¼���ÿ���б���Ļ��Ƴߴ�
      if IsNotSameDouble(Self.FListLayoutsManager.SelectedItemHeight,-1)
        or IsNotSameDouble(Self.FListLayoutsManager.SelectedItemWidth,-1) then
      begin
        //���¼���ߴ�
        Self.FListLayoutsManager.DoItemSizeChange(Self);
      end;

      Invalidate;

  end
  else
  begin
//    uBaseLog.OutputDebugString('�Ѿ�ѡ�д�Item');
  end;
end;

procedure TCustomListProperties.DoSetValueToEditingItem;
begin
  //����ֵ
end;

procedure TCustomListProperties.DoStopEditingItemEnd;
begin

end;

function TCustomListProperties.VisibleItemDrawRect(AVisibleItem:TBaseSkinItem): TRectF;
//var
//  AVisibleItemIndex:Integer;
begin

  Result:=Self.FListLayoutsManager.VisibleItemRectByItem(AVisibleItem);

  Result.Top:=Result.Top
              -Self.GetTopDrawOffset
              +GetItemTopDrawOffset
              +GetCenterItemSelectModeTopDrawOffset;
  Result.Bottom:=Result.Bottom
              -Self.GetBottomDrawOffset
              +GetItemTopDrawOffset
              +GetCenterItemSelectModeTopDrawOffset;
  Result.Left:=Result.Left
                -Self.GetLeftDrawOffset
                +GetCenterItemSelectModeLeftDrawOffset;
  Result.Right:=Result.Right
                -Self.GetRightDrawOffset
                +GetCenterItemSelectModeLeftDrawOffset;

  AVisibleItem.ItemDrawRect:=Result;

//  Result:=RectF(0,0,0,0);
//  AVisibleItemIndex:=Self.FListLayoutsManager.GetVisibleItemObjectIndex(AVisibleItem);
//  if AVisibleItemIndex<>-1 then
//  begin
//    Result:=VisibleItemDrawRect(AVisibleItemIndex);
//  end;
end;

function TCustomListProperties.VisibleItemRect(AVisibleItemIndex:Integer): TRectF;
begin
  Result:=Self.FListLayoutsManager.VisibleItemRectByIndex(AVisibleItemIndex)
end;

function TCustomListProperties.VisibleItemAt(X, Y: Double):TBaseSkinItem;
var
  AVisibleItemIndex:Integer;
begin
  Result:=nil;
  AVisibleItemIndex:=Self.VisibleItemIndexAt(X,Y);
  if AVisibleItemIndex<>-1 then
  begin
    Result:=TBaseSkinItem(Self.FListLayoutsManager.GetVisibleItemObject(AVisibleItemIndex));
  end
  else
  begin
    Result:=nil;
  end;
end;

function TCustomListProperties.VisibleItemDrawRect(AVisibleItemIndex: Integer): TRectF;
begin
  Result:=VisibleItemRect(AVisibleItemIndex);

  Result.Top:=Result.Top
              -Self.GetTopDrawOffset
              +GetItemTopDrawOffset
              +GetCenterItemSelectModeTopDrawOffset;
  Result.Bottom:=Result.Bottom
              -Self.GetBottomDrawOffset
              +GetItemTopDrawOffset
              +GetCenterItemSelectModeTopDrawOffset;
  Result.Left:=Result.Left
                -Self.GetLeftDrawOffset
                +GetCenterItemSelectModeLeftDrawOffset;
  Result.Right:=Result.Right
                -Self.GetRightDrawOffset
                +GetCenterItemSelectModeLeftDrawOffset;

  Self.FListLayoutsManager.GetVisibleItem(AVisibleItemIndex).ItemDrawRect:=Result;
end;

function TCustomListProperties.VisibleItemIndexAt(X, Y: Double):Integer;
var
  I: Integer;
  ADrawStartIndex,ADrawEndIndex:Integer;
begin
  Result:=-1;
  if Self.FListLayoutsManager.GetVisibleItemsCount>0 then
  begin
    Self.FListLayoutsManager.CalcDrawStartAndEndIndex(

                                                      Self.GetLeftDrawOffset,
                                                      Self.GetTopDrawOffset,
                                          //            Self.GetRightDrawOffset,
                                          //            Self.GetBottomDrawOffset,
                                                      Self.FListLayoutsManager.GetControlWidth,
                                                      Self.FListLayoutsManager.GetControlHeight,
                                                      ADrawStartIndex,
                                                      ADrawEndIndex
                                                      );

    for I:=ADrawStartIndex to ADrawEndIndex do
    begin
      if PtInRect(VisibleItemDrawRect(TBaseSkinItem(Self.FListLayoutsManager.GetVisibleItemObject(I))),PointF(X,Y)) then
      begin
        Result:=I;
        Break;
      end;
    end;

  end;
end;



{ TSkinCustomListDefaultType }

function TSkinCustomListDefaultType.PaintItem(ACanvas: TDrawCanvas;
                                              AItemIndex:Integer;
                                              AItem:TBaseSkinItem;
                                              AItemDrawRect:TRectF;
                                              ASkinMaterial:TSkinCustomListDefaultMaterial;
                                              const ADrawRect: TRectF;
                                              ACustomListPaintData:TPaintData): Boolean;
var
  AItemEffectStates:TDPEffectStates;
  AIsDrawItemInteractiveState:Boolean;
  AItemPaintData:TPaintData;
  ASkinItemMaterial:TBaseSkinListItemMaterial;
  AItemDesignerPanel:TSkinItemDesignerPanel;
begin


    //�����б���Ч��״̬
    AIsDrawItemInteractiveState:=(AItem=Self.FSkinCustomListIntf.Prop.FMouseOverItem);


    AItemEffectStates:=ProcessItemDrawEffectStates(AItem);



    //����ƽ�ϵ��б���������
    if (Self.FSkinCustomListIntf.Prop.FPanDragItem=AItem)
      and (Self.FSkinCustomListIntf.Prop.FItemPanDragDesignerPanel<>nil)
      then
    begin
        AItemDesignerPanel:=Self.FSkinCustomListIntf.Prop.FItemPanDragDesignerPanel;


        AItemDrawRect:=Self.FSkinCustomListIntf.Prop.GetPanDragItemDrawRect;
        //����ItemPanDragDesignerPanel
        //ѡ��ItemPanDragDesignerPanel�Ļ��Ʒ��,һ�Ǹ���,����һֱ��ʾ������

        //������ʾ
        AItemDesignerPanel.SkinControlType.IsUseCurrentEffectStates:=True;
        AItemDesignerPanel.SkinControlType.CurrentEffectStates:=AItemEffectStates;
        //����ItemDesignerPanel�ı���
        AItemPaintData:=GlobalNullPaintData;
        AItemPaintData.IsDrawInteractiveState:=True;
        AItemPaintData.IsInDrawDirectUI:=True;
        AItemDesignerPanel.SkinControlType.Paint(ACanvas,
                              AItemDesignerPanel.SkinControlType.GetPaintCurrentUseMaterial,
                              Self.FSkinCustomListIntf.Prop.GetPanDragItemDesignerPanelDrawRect,
                              AItemPaintData);
        //����ItemDesignerPanel���ӿؼ�
        AItemPaintData:=GlobalNullPaintData;
        AItemPaintData.IsDrawInteractiveState:=True;
        AItemPaintData.IsInDrawDirectUI:=True;
        AItemDesignerPanel.SkinControlType.DrawChildControls(ACanvas,
                              Self.FSkinCustomListIntf.Prop.GetPanDragItemDesignerPanelDrawRect,
                              AItemPaintData,
                              ADrawRect);
    end;






    //����AItemʹ���ĸ�TBaseSkinItemMaterial������
    ASkinItemMaterial:=DecideItemMaterial(AItem,ASkinMaterial);
    ProcessItemDrawParams(ASkinMaterial,ASkinItemMaterial,AItemEffectStates);

    //�����б��ʼ
    CustomDrawItemBegin(ACanvas,
                        AItemIndex,
                        AItem,
                        AItemDrawRect,

                        ASkinMaterial,
                        ADrawRect,
                        ACustomListPaintData,
                        ASkinItemMaterial,
                        AItemEffectStates,
                        AIsDrawItemInteractiveState);
    //�����б�������
    CustomDrawItemContent(ACanvas,
                          AItemIndex,
                          AItem,
                          AItemDrawRect,

                          ASkinMaterial,
                          ADrawRect,
                          ACustomListPaintData,
                          ASkinItemMaterial,
                          AItemEffectStates,
                          AIsDrawItemInteractiveState);

    //�����б������
    CustomDrawItemEnd(ACanvas,
                      AItemIndex,
                      AItem,
                      AItemDrawRect,

                      ASkinMaterial,
                      ADrawRect,
                      ACustomListPaintData,
                      ASkinItemMaterial,
                      AItemEffectStates,
                      AIsDrawItemInteractiveState);

    //��ǿ����
    Self.FSkinCustomListIntf.Prop.CallOnAdvancedDrawItemEvent(Self,ACanvas,AItem,AItemDrawRect);


end;

function TSkinCustomListDefaultType.CustomPaintContent(
                                ACanvas:TDrawCanvas;
                                ASkinMaterial:TSkinControlMaterial;
                                const ADrawRect:TRectF;
                                APaintData:TPaintData
                                ):Boolean;
//var
//  BeginTickCount:Cardinal;
//  BeginTickCount2:Cardinal;
var
//  I:Integer;
//  AItem:TSkinItem;
  ABeginTime:TDateTime;
  AControlClientRect:TRectF;
begin
  ABeginTime:=Now;
//  BeginTickCount:=UIGetTickCount;
//  BeginTickCount2:=UIGetTickCount;

//  if Self.FSkinControl.ClassName='TSkinFMXItemGrid' then  Exit;



  FFirstDrawItem:=nil;

  FLastColDrawItem:=nil;
  FLastRowDrawItem:=nil;



  Inherited CustomPaintContent(ACanvas,ASkinMaterial,ADrawRect,APaintData);


  if (Self.FSkinCustomListIntf.Prop.FItems.SkinObjectChangeManager<>nil)
    and (Self.FSkinCustomListIntf.Prop.FItems.SkinObjectChangeManager.UpdateCount>0) then
  begin
    //���޸��в�ˢ��
//    uBaseLog.OutputDebugString('CustomList.Items���޸���,��ˢ��');
    Exit;
  end;



  CustomPaintContentBegin(ACanvas,ASkinMaterial,ADrawRect,APaintData);






  //����ѡ���������ƫ��
  FDrawRectCenterItemSelectModeTopOffset:=Self.FSkinCustomListIntf.Prop.GetCenterItemSelectModeTopDrawOffset;
  FDrawRectCenterItemSelectModeLeftOffset:=Self.FSkinCustomListIntf.Prop.GetCenterItemSelectModeLeftDrawOffset;


  //���������������ƫ��
  FDrawRectTopOffset:=Self.FSkinScrollControlIntf.Prop.GetTopDrawOffset;
  FDrawRectLeftOffset:=Self.FSkinScrollControlIntf.Prop.GetLeftDrawOffset;
  FDrawRectRightOffset:=Self.FSkinScrollControlIntf.Prop.GetRightDrawOffset;
  FDrawRectBottomOffset:=Self.FSkinScrollControlIntf.Prop.GetBottomDrawOffset;



  //��ȡ��Ҫ���ƵĿ�ʼ�±�ͽ����±�
  Self.FSkinCustomListIntf.Prop.FListLayoutsManager.CalcDrawStartAndEndIndex(

                                                    FDrawRectLeftOffset
                                                      -FDrawRectCenterItemSelectModeLeftOffset,
                                                    FDrawRectTopOffset
                                                      -Self.FSkinCustomListIntf.Prop.GetItemTopDrawOffset
                                                      -FDrawRectCenterItemSelectModeTopOffset,
//                                                    FDrawRectRightOffset,
//                                                    FDrawRectBottomOffset
//                                                      -Self.FSkinCustomListIntf.Prop.GetItemTopDrawOffset,

                                                    Self.FSkinCustomListIntf.Prop.FListLayoutsManager.GetControlWidth,
                                                    Self.FSkinCustomListIntf.Prop.FListLayoutsManager.GetControlHeight,
                                                    FDrawStartIndex,
                                                    FDrawEndIndex
                                                    );



//  uBaseLog.OutputDebugString(Self.FSkinControl.Name
//                            +'���б��������ʼ�±� FDrawStartIndex:'+IntToStr(FDrawStartIndex)
//                            +' FDrawEndIndex:'+IntToStr(FDrawEndIndex)
//                            );



  //�ͻ�������(�����ж���ЩItem��Ҫ����)
  AControlClientRect:=Self.FSkinScrollControlIntf.Prop.GetClientRect;


//  if not (csDesigning in Self.FSkinControl.ComponentState) then
//  begin
    //������ʱ,��Ҫ��סItemDesignerPanel���ӿؼ���ˢ��,
    //ʵ��,��VCLƽ̨�£�Ҳ����ɲ��ϵ�ˢ�£�������ʱ����
    LockSkinControlInvalidate;
//  end;
  try



      //����Ҫ���Ƶ��б���
      if Self.FSkinCustomListIntf.Prop.FListLayoutsManager.GetVisibleItemsCount>0 then
      begin

        if Self.FSkinCustomListIntf.Prop.FEmptyContentControl<>nil then
        begin
          if Self.FSkinCustomListIntf.Prop.FEmptyContentControl.Visible then
          begin
            Self.FSkinCustomListIntf.Prop.FEmptyContentControl.Visible:=False;
          end;
        end;



        //�����б�
        PaintItems(ACanvas,
                    ASkinMaterial,
                    ADrawRect,
                    AControlClientRect,

                    FDrawRectCenterItemSelectModeTopOffset,
                    FDrawRectCenterItemSelectModeLeftOffset,

                    FDrawRectTopOffset,
                    FDrawRectLeftOffset,
                    FDrawRectRightOffset,
                    FDrawRectBottomOffset,

                    FDrawStartIndex,
                    FDrawEndIndex,

                    APaintData
                    );


      end
      else
      begin
          //û����Ҫ���Ƶ��б���
          if Self.FSkinCustomListIntf.Prop.FIsEmptyContent then
          begin
            //���ƿհ�����
            ACanvas.DrawPicture(TSkinCustomListDefaultMaterial(ASkinMaterial).FDrawEmptyContentPictureParam,
                    Self.FSkinCustomListIntf.Prop.FEmptyContentPicture,
                    ADrawRect);
            ACanvas.DrawText(TSkinCustomListDefaultMaterial(ASkinMaterial).FDrawEmptyContentCaptionParam,
                    Self.FSkinCustomListIntf.Prop.FEmptyContentCaption,
                    ADrawRect);
            ACanvas.DrawText(TSkinCustomListDefaultMaterial(ASkinMaterial).FDrawEmptyContentDescriptionParam,
                    Self.FSkinCustomListIntf.Prop.FEmptyContentDescription,
                    ADrawRect);
            if Self.FSkinCustomListIntf.Prop.FEmptyContentControl<>nil then
            begin
              if Not Self.FSkinCustomListIntf.Prop.FEmptyContentControl.Visible then
              begin
                Self.FSkinCustomListIntf.Prop.FEmptyContentControl.Visible:=True;
              end;
            end;
          end;
      end;



      //���ƾ���ѡ���
      if TSkinCustomListDefaultMaterial(ASkinMaterial).IsDrawCenterItemRect then
      begin
        ACanvas.DrawRect(TSkinCustomListDefaultMaterial(ASkinMaterial).FDrawCenterItemRectParam,
                        Self.FSkinCustomListIntf.Prop.GetCenterItemRect);
      end;









      //ListView�����������зָ���
      AdvancedCustomPaintContent(ACanvas,ASkinMaterial,ADrawRect,APaintData);


//      uBaseLog.OutputDebugString(Self.FSkinControl.Name+' Paint TickCount:'+IntToStr(UIGetTickCount-BeginTickCount));
//      uBaseLog.OutputDebugString(Self.FSkinControl.Name+' Paint Cost :'+IntToStr(DateUtils.MilliSecondsBetween(ABeginTime,Now)));




//      //���ƹ̶���
//      for I := 0 to Self.FSkinCustomListIntf.Prop.FListLayoutsManager.FFixedItems.Count-1 do
//      begin
//          AItem:=TSkinItem(Self.FSkinCustomListIntf.Prop.FListLayoutsManager.FFixedItems[I]);
//
//          //�����б���
//          PaintItem(ACanvas,
//                    I,
//                    AItem,
//                    AItem.ItemRect,
//                    TSkinCustomListDefaultMaterial(ASkinMaterial),
//                    ADrawRect,
//                    APaintData);
//      end;





  finally
//    if not (csDesigning in Self.FSkinControl.ComponentState) then
//    begin
      UnLockSkinControlInvalidate;
//    end;
  end;

end;

function TSkinCustomListDefaultType.CustomPaintContentBegin(
                                ACanvas:TDrawCanvas;
                                ASkinMaterial:TSkinControlMaterial;
                                const ADrawRect:TRectF;
                                APaintData:TPaintData
                                ):Boolean;
begin

end;

function TSkinCustomListDefaultType.PaintItems(ACanvas: TDrawCanvas;
                                                ASkinMaterial: TSkinControlMaterial;
                                                const ADrawRect:TRectF;
                                                AControlClientRect:TRectF;

                                                ADrawRectCenterItemSelectModeTopOffset,
                                                ADrawRectCenterItemSelectModeLeftOffset,

                                                ADrawRectTopOffset,
                                                ADrawRectLeftOffset,
                                                ADrawRectRightOffset,
                                                ADrawRectBottomOffset:Double;

                                                ADrawStartIndex, ADrawEndIndex: Integer;

                                                APaintData: TPaintData): Boolean;
var
  I: Integer;
  AItem:TBaseSkinItem;

  AItemDrawRect:TRectF;
  ALastItemDrawRect:TRectF;

  ASkinCustomListMaterial:TSkinCustomListDefaultMaterial;
//var
//  BeginTickCount:Cardinal;
begin
      ASkinCustomListMaterial:=TSkinCustomListDefaultMaterial(ASkinMaterial);



      //�Ƚ����еĻ�������Ϊ��ռ��
      MarkAllListItemTypeStyleSettingCacheUnUsed(ADrawStartIndex,ADrawEndIndex);




      //��ʼ����ÿ��Item
      for I:=ADrawStartIndex to ADrawEndIndex do
      begin

//          uBaseLog.OutputDebugString(
//            Self.FSkinControl.Name+' '+'Item '+IntToStr(I)+'------------------ ');
//
//          BeginTickCount:=UIGetTickCount;


          AItem:=Self.FSkinCustomListIntf.Prop.FListLayoutsManager.GetVisibleItems(I);


          //����Ҫ�ж�AItem.Visible
//          if not AItem.Visible then Continue;


          //ItemRect���Ѿ�����õ�
          AItemDrawRect:=AItem.ItemRect;



          //�����Ⱥ͸߶�Ϊ0,��ô������
          //���ж�,��Ϊ����ֱ������Visible�����
//          if IsSameDouble(RectWidthF(AItemDrawRect),0)
//            or IsSameDouble(RectHeightF(AItemDrawRect),0) then
//          begin
//            Continue;
//          end;


          //���Ͼ���ƫ��
          AItemDrawRect.Left:=AItemDrawRect.Left
                              -ADrawRectLeftOffset
                              +ADrawRectCenterItemSelectModeLeftOffset;
          AItemDrawRect.Top:=AItemDrawRect.Top
                              -ADrawRectTopOffset
                              //���ϱ����ͷ
                              +Self.FSkinCustomListIntf.Prop.GetItemTopDrawOffset
                              +ADrawRectCenterItemSelectModeTopOffset;
          AItemDrawRect.Right:=AItemDrawRect.Right
                              -ADrawRectRightOffset
                              +ADrawRectCenterItemSelectModeLeftOffset;
          AItemDrawRect.Bottom:=AItemDrawRect.Bottom
                                -ADrawRectBottomOffset
                                //���ϱ����ͷ
                                +Self.FSkinCustomListIntf.Prop.GetItemTopDrawOffset
                                +ADrawRectCenterItemSelectModeTopOffset;
          AItem.ItemDrawRect:=AItemDrawRect;


          //�������Ʒ�Χ������
          //ADrawStartIndex��ADrawEndIndex��������,
          //�ٻ���һ����Ż�һ��,����Ҫ,���ֻ��ϻ�������Ч��������
          if Not ((AItemDrawRect.Bottom <= AControlClientRect.Top)
                  or (AItemDrawRect.Top >= AControlClientRect.Bottom)
                  or (AItemDrawRect.Right <= AControlClientRect.Left)
                  or (AItemDrawRect.Left >= AControlClientRect.Right)
                  ) then
          begin

              //���ϻ��ƾ���ƫ��
              OffsetRect(AItemDrawRect,ADrawRect.Left,ADrawRect.Top);


              //���ڻ������зָ���
              //��һ�����е�Item
              if FFirstDrawItem=nil then
              begin
                  //��һ��Item

                  //��ͷ
                  FFirstDrawItem:=AItem;
                  FFirstDrawItemRect:=AItemDrawRect;
                  //��β
                  FLastColDrawItem:=AItem;
                  FLastColDrawItemRect:=AItemDrawRect;
                  //��ͷ
                  FLastRowDrawItem:=AItem;
                  FLastRowDrawItemRect:=AItemDrawRect;
              end
              else
              begin

                  //�жϻ���
                  //��β,ֻҪ�ҳ�Right����Item�Ϳ�����
                  if BiggerDouble(AItemDrawRect.Right,FLastColDrawItemRect.Right) then
                  begin
                    FLastColDrawItem:=AItem;
                    FLastColDrawItemRect:=AItemDrawRect;
                  end;

                  if IsNotSameDouble(AItemDrawRect.Top,ALastItemDrawRect.Top) then
                  begin
                    //��ͷ
                    //���һ��
                    FLastRowDrawItem:=AItem;
                    FLastRowDrawItemRect:=AItemDrawRect;
                  end;

              end;




              //�����б���
              PaintItem(ACanvas,
                        I,
                        AItem,
                        AItemDrawRect,
                        ASkinCustomListMaterial,
                        ADrawRect,
                        APaintData);



              ALastItemDrawRect:=AItemDrawRect;


              //����ǻ�����
              //��ô��Ҫ�������зָ���
              //�����������һ����

//              uBaseLog.OutputDebugString(
//                Self.FSkinControl.Name+' '+'Item '+IntToStr(I)+'------------------ Paint TickCount:'+IntToStr(UIGetTickCount-BeginTickCount)
//                );


          end;
      end;




end;

function TSkinCustomListDefaultType.AdvancedCustomPaintContent(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF; APaintData: TPaintData): Boolean;
begin
end;

function TSkinCustomListDefaultType.CustomBind(ASkinControl:TControl):Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinCustomList,Self.FSkinCustomListIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinCustomList Interface');
    end;
  end;
end;

function TSkinCustomListDefaultType.CustomDrawItemContent(ACanvas: TDrawCanvas;
                                                          AItemIndex:Integer;
                                                          AItem:TBaseSkinItem;
                                                          AItemDrawRect:TRectF;
                                                          ASkinMaterial:TSkinCustomListDefaultMaterial;
                                                          const ADrawRect: TRectF;
                                                          ACustomListPaintData:TPaintData;
                                                          ASkinItemMaterial:TBaseSkinListItemMaterial;
                                                          AItemEffectStates:TDPEffectStates;
                                                          AIsDrawItemInteractiveState:Boolean): Boolean;
var
  AItemBackPicture:TDrawPicture;
  AItemPaintData:TPaintData;
begin
  //Ĭ�ϻ���
  if (ASkinMaterial<>nil) then
  begin


      //�����б����ɫ
      ACanvas.DrawRect(ASkinItemMaterial.FDrawItemBackColorParam,AItemDrawRect);



      //�����б����ͼƬ
      AItemBackPicture:=nil;
      if AItem.Selected then
      begin
        AItemBackPicture:=ASkinItemMaterial.FItemBackPushedPicture;
      end
      else
      if AItem=Self.FSkinCustomListIntf.Prop.MouseDownItem then
      begin
        AItemBackPicture:=ASkinItemMaterial.FItemBackDownPicture;
      end
      else
      if AItem=Self.FSkinCustomListIntf.Prop.MouseOverItem then
      begin
        AItemBackPicture:=ASkinItemMaterial.FItemBackHoverPicture;
      end
      else
      begin
        AItemBackPicture:=ASkinItemMaterial.FItemBackNormalPicture;
      end;
      if AItemBackPicture.IsEmpty then
      begin
        AItemBackPicture:=ASkinItemMaterial.FItemBackNormalPicture;
      end;
      ACanvas.DrawPicture(ASkinItemMaterial.FDrawItemBackGndPictureParam,AItemBackPicture,AItemDrawRect);


      //�����б���չ��ͼƬ
      ACanvas.DrawPicture(ASkinItemMaterial.FDrawItemAccessoryPictureParam,ASkinItemMaterial.FItemAccessoryPicture,AItemDrawRect);

  end;

end;

function TSkinCustomListDefaultType.CustomDrawItemBegin(ACanvas: TDrawCanvas;
                                                        AItemIndex:Integer;
                                                        AItem:TBaseSkinItem;
                                                        AItemDrawRect:TRectF;
                                                        ASkinMaterial:TSkinCustomListDefaultMaterial;
                                                        const ADrawRect: TRectF;
                                                        ACustomListPaintData:TPaintData;
                                                        ASkinItemMaterial:TBaseSkinListItemMaterial;
                                                        AItemEffectStates:TDPEffectStates;
                                                        AIsDrawItemInteractiveState:Boolean): Boolean;
begin

  //׼�������б���
  Self.FSkinCustomListIntf.Prop.CallOnPrepareDrawItemEvent(
          Self,
          ACanvas,
          AItem,
          AItemDrawRect,
          AIsDrawItemInteractiveState);

end;

function TSkinCustomListDefaultType.CustomDrawItemEnd(ACanvas: TDrawCanvas;
                                                      AItemIndex:Integer;
                                                      AItem:TBaseSkinItem;
                                                      AItemDrawRect:TRectF;
                                                      ASkinMaterial:TSkinCustomListDefaultMaterial;
                                                      const ADrawRect: TRectF;
                                                      ACustomListPaintData:TPaintData;
                                                      ASkinItemMaterial:TBaseSkinListItemMaterial;
                                                      AItemEffectStates:TDPEffectStates;
                                                      AIsDrawItemInteractiveState:Boolean): Boolean;
var
  ADrawItemDevideRect:TRectF;
begin

    if ASkinMaterial.FIsSimpleDrawItemDevide then
    begin

        case Self.FSkinCustomListIntf.Prop.ItemLayoutType of
          iltVertical:
          begin
            if Not AItem.IsNotNeedDrawDevide then
            begin
              //��Ҫ���ָ���
              ACanvas.DrawRect(ASkinMaterial.FDrawItemDevideParam,
                              RectF(AItemDrawRect.Left,
                                  AItemDrawRect.Bottom,
                                  AItemDrawRect.Right,
                                  AItemDrawRect.Bottom+1)
                                  );
            end;
          end;
          iltHorizontal:
          begin
            if Not AItem.IsNotNeedDrawDevide then
            begin
              //��Ҫ���ָ���
              ACanvas.DrawRect(ASkinMaterial.FDrawItemDevideParam,
                              RectF(AItemDrawRect.Right,
                                  AItemDrawRect.Top,
                                  AItemDrawRect.Right+1,
                                  AItemDrawRect.Bottom)
                                  );
            end;

          end;
        end;

    end
    else
    begin
      ACanvas.DrawRect(ASkinMaterial.FDrawItemDevideParam,AItemDrawRect);
    end;

end;

procedure TSkinCustomListDefaultType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinCustomListIntf:=nil;
end;

function TSkinCustomListDefaultType.DecideItemMaterial(AItem:TBaseSkinItem;ASkinMaterial:TSkinCustomListDefaultMaterial): TBaseSkinListItemMaterial;
begin
  Result:=ASkinMaterial.FDefaultTypeItemMaterial;
end;

function TSkinCustomListDefaultType.DoProcessItemCustomMouseDown(AMouseOverItem:TBaseSkinItem;AItemDrawRect:TRectF;Button: TMouseButton; Shift: TShiftState; X, Y: Double): Boolean;
begin
  Result:=False;
end;

procedure TSkinCustomListDefaultType.DoProcessItemCustomMouseLeave(AMouseLeaveItem:TBaseSkinItem);
begin

end;

function TSkinCustomListDefaultType.DoProcessItemCustomMouseMove(
                                              AMouseOverItem: TBaseSkinItem;
                                              Shift: TShiftState;
                                              X, Y: Double): Boolean;
begin
  Result:=False;
end;

function TSkinCustomListDefaultType.DoProcessItemCustomMouseUp(
                                              AMouseDownItem: TBaseSkinItem;
                                              Button: TMouseButton;
                                              Shift: TShiftState;
                                              X, Y: Double):Boolean;
var
  AItemDrawRect:TRectF;
begin
  Result:=False;

  if FSkinCustomListIntf.Prop.FEditingItem<>nil then
  begin
        //������ڱ༭�б�������,Ȼ���������ط�,��ȡ���༭
        if (Self.FMouseDownAbsolutePt.X<>0)
          and (Abs(Self.FMouseDownAbsolutePt.X-Self.FMouseMoveAbsolutePt.X)<Const_CanCallClickEventDistance)
          and (Abs(Self.FMouseDownAbsolutePt.Y-Self.FMouseMoveAbsolutePt.Y)<Const_CanCallClickEventDistance) then
        begin

            if Self.FSkinCustomListIntf.Prop.FMouseOverItem<>FSkinCustomListIntf.Prop.FEditingItem then
            begin
                //�б����л�����
                Self.FSkinCustomListIntf.Prop.StopEditingItem;
            end
            else
            begin

                AItemDrawRect:=AMouseDownItem.ItemDrawRect;

                //�Ƿ����˱༭�ؼ�������
                if Not PtInRect(
        //                      RectF(FSkinCustomListIntf.Prop.FEditingItem_EditControl.Left,
        //                             FSkinCustomListIntf.Prop.FEditingItem_EditControl.Top,
        //                             FSkinCustomListIntf.Prop.FEditingItem_EditControl.Left
        //                              +FSkinCustomListIntf.Prop.FEditingItem_EditControl.Width,
        //                              FSkinCustomListIntf.Prop.FEditingItem_EditControl.Top
        //                              +FSkinCustomListIntf.Prop.FEditingItem_EditControl.Height
        //                                )
                                FSkinCustomListIntf.Prop.FEditingItem_EditControlPutRect
                                ,PointF(X-AItemDrawRect.Left,Y-AItemDrawRect.Top)) then
                begin
                  Self.FSkinCustomListIntf.Prop.StopEditingItem;
                end;
            end;

        end;
  end;


end;

function TSkinCustomListDefaultType.GetSkinMaterial: TSkinCustomListDefaultMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinCustomListDefaultMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;

procedure TSkinCustomListDefaultType.MarkAllListItemTypeStyleSettingCacheUnUsed(
  ADrawStartIndex, ADrawEndIndex: Integer);
begin

end;

function TSkinCustomListDefaultType.ProcessItemDrawEffectStates(AItem: TBaseSkinItem): TDPEffectStates;
begin
  Result:=[];

  if Self.FSkinCustomListIntf.Prop.FMouseOverItem=AItem then
  begin
    Result:=Result+[dpstMouseOver];
  end;

  if (Self.FSkinCustomListIntf.Prop.FMouseDownItem=AItem) then
  begin
      //��ǰ����,���ƶ����벻����5�����أ�������OnClickItem�¼�,��Ҫ�ػ�
      if Self.FSkinCustomListIntf.Prop.FIsStayPressedItem then
      begin
        Result:=Result+[dpstMouseDown];

        Self.FSkinCustomListIntf.Prop.StopCheckStayPressedItemTimer;
      end;
  end;


  //�ϴΰ��µ��б���,������OnClickItem֮������
  if (Self.FSkinCustomListIntf.Prop.FLastMouseDownItem=AItem) then
  begin
    Result:=Result+[dpstMouseDown];
  end;

  //ѡ�е�Ч��
  if AItem.Selected then
  begin
    Result:=Result+[dpstPushed];
  end;

end;

procedure TSkinCustomListDefaultType.ProcessItemDrawParams(
                                            ASkinMaterial:TSkinCustomListDefaultMaterial;
                                            ASkinItemMaterial: TBaseSkinListItemMaterial;
                                            AItemEffectStates: TDPEffectStates);
begin

    ASkinItemMaterial.FDrawItemBackColorParam.StaticEffectStates:=AItemEffectStates;
    ProcessDrawParamDrawAlpha(ASkinItemMaterial.FDrawItemBackColorParam);
    ASkinItemMaterial.FDrawItemBackGndPictureParam.StaticEffectStates:=AItemEffectStates;
    ProcessDrawParamDrawAlpha(ASkinItemMaterial.FDrawItemBackGndPictureParam);

    ASkinItemMaterial.FDrawItemAccessoryPictureParam.StaticEffectStates:=AItemEffectStates;
    ProcessDrawParamDrawAlpha(ASkinItemMaterial.FDrawItemAccessoryPictureParam);

    ASkinMaterial.FDrawItemDevideParam.StaticEffectStates:=AItemEffectStates;
    ProcessDrawParamDrawAlpha(ASkinMaterial.FDrawItemDevideParam);

end;

procedure TSkinCustomListDefaultType.CustomMouseDown(Button: TMouseButton;Shift: TShiftState;X, Y: Double);
var
  AItemDrawRect:TRectF;
  APanDragItemDrawRect:TRectF;
  APanDragItemDrawItemDesignerPanel:TSkinItemDesignerPanel;
  APanDragItemDesignerPanelClipRect:TRectF;
begin
//  uBaseLog.OutputDebugString('TSkinCustomListDefaultType.CustomMouseDown');


  inherited;


  //ȥ���ӿؼ����ݹ����������Ϣ
  if Self.FCurrentMouseEventIsChildOwn then
  begin
//    uBaseLog.OutputDebugString('TSkinCustomListDefaultType.CustomMouseDown IsChildMouseEvent');
    Exit;
  end;


    //���������б����¼��Ķ�ʱ��
    Self.FSkinCustomListIntf.Prop.FHasCalledOnLongTapItem:=False;
    Self.FSkinCustomListIntf.Prop.CreateCheckLongTapItemTimer;
    Self.FSkinCustomListIntf.Prop.StartCheckLongTapItemTimer;


    Self.FSkinCustomListIntf.Prop.FIsStayPressedItem:=False;
    Self.FSkinCustomListIntf.Prop.FLastMouseDownItem:=nil;
    Self.FSkinCustomListIntf.Prop.CreateCheckStayPressedItemTimer;
    Self.FSkinCustomListIntf.Prop.StartCheckStayPressedItemTimer;



    //��ȡ�б�����ƾ���
    AItemDrawRect:=RectF(0,0,0,0);
    if Self.FSkinCustomListIntf.Prop.FMouseOverItem<>nil then
    begin
        AItemDrawRect:=Self.FSkinCustomListIntf.Prop.VisibleItemDrawRect(Self.FSkinCustomListIntf.Prop.FMouseOverItem);
        //ƽ�Ϲ���,���ȡƽ���б���Ļ��ƾ���(����ƽ��֮���ƫ��)
        if Self.FSkinCustomListIntf.Prop.IsStartedItemPanDrag
          and (Self.FSkinCustomListIntf.Prop.FMouseOverItem=Self.FSkinCustomListIntf.Prop.FPanDragItem) then
        begin
          AItemDrawRect:=Self.FSkinCustomListIntf.Prop.GetPanDragItemDrawRect;
        end;
    end;





    //������������ڲ����б���
    //������굯���ʱ��,���ø�Item.FDrawItemDesignerPanel�ĵ����¼�
    //��������ItemDesignerPanel�е��ӿؼ�,����֪����������ĸ��б���
    if PtInRect(AItemDrawRect,PointF(X,Y)) then
    begin
        Self.FSkinCustomListIntf.Prop.InnerMouseDownItem:=
              Self.FSkinCustomListIntf.Prop.VisibleItemAt(X,Y);
        Self.FSkinCustomListIntf.Prop.FInteractiveMouseDownItem:=
              Self.FSkinCustomListIntf.Prop.InnerMouseDownItem;


        if Self.FSkinCustomListIntf.Prop.FInnerMouseDownItem<>
          Self.FSkinCustomListIntf.Prop.FEditingItem then
        begin
          //������б����л�����,�����༭
          Self.FSkinCustomListIntf.Prop.StopEditingItem;
        end
    end;




    //�����б����������¼�
    //�ж�������¼��Ƿ��б����ItemDesignerPanel������
    if DoProcessItemCustomMouseDown(Self.FSkinCustomListIntf.Prop.FMouseOverItem,
                                    AItemDrawRect,Button,Shift,X,Y) then
    begin
      //�����HitTestΪTrue���ӿؼ�
      Self.Invalidate;
      Exit;
    end
    else
    begin
      //����¼�û�б�����,��ô���ݸ�Item,Ҳ���ǵ���б���
    end;
    





    //������û�е����ItemDesignerPanel������ӿؼ�
    //��ô������������б���
    Self.FSkinCustomListIntf.Prop.MouseDownItem:=
        Self.FSkinCustomListIntf.Prop.InnerMouseDownItem;



    //ƽ���б�����¼�
    //�����ʼ���б���ƽ��,��ȡƽ���б������갴���¼�,���������ƽ���б���������
    if Self.FSkinCustomListIntf.Prop.IsStartedItemPanDrag then
    begin
        APanDragItemDrawRect:=Self.FSkinCustomListIntf.Prop.VisibleItemDrawRect(Self.FSkinCustomListIntf.Prop.FPanDragItem);
        APanDragItemDesignerPanelClipRect:=Self.FSkinCustomListIntf.Prop.GetPanDragItemDesignerPanelDrawRect;

        if PtInRect(APanDragItemDrawRect,PointF(X,Y)) then
        begin

            Self.FSkinCustomListIntf.Prop.FItemPanDragGestureManager.MouseDown(Button,Shift,X,Y);


            if PtInRect(APanDragItemDesignerPanelClipRect,PointF(X,Y)) then
            begin
              APanDragItemDrawItemDesignerPanel:=TSkinItemDesignerPanel(Self.FSkinCustomListIntf.Prop.FItemPanDragDesignerPanel);
              //��ʼ�¼�û�б�����
              APanDragItemDrawItemDesignerPanel.SkinControlType.EventProcessedByChild:=False;
              //������갴����Ϣ
              APanDragItemDrawItemDesignerPanel.SkinControlType
                              .DirectUIMouseDown(Self.FSkinControl,Button,Shift,X-APanDragItemDesignerPanelClipRect.Left,Y-APanDragItemDesignerPanelClipRect.Top);
              if APanDragItemDrawItemDesignerPanel.SkinControlType.EventProcessedByChild then
              begin
                Self.Invalidate;
                //��Ϣ��ƽ���б���Ŀؼ��������
                Exit;
              end
              else
              begin
                //����¼�û�б�����,��ô���ݸ�Item,Ҳ���ǵ���б���
              end;
            end;


        end
        else
        begin
          //�ڱ�ĵط�ƽ��
          //ֹͣƽ��
          Self.FSkinCustomListIntf.Prop.StopItemPanDrag;
        end;


    end
    else
    begin

        //��û������ƽ��
        if Self.FSkinCustomListIntf.Prop.CanEnableItemPanDrag
          and (Self.FSkinCustomListIntf.Prop.FMouseDownItem<>nil) then
        begin
          Self.FSkinCustomListIntf.Prop.FItemPanDragGestureManager.MouseDown(Button,Shift,X,Y);
        end;


    end;

end;

procedure TSkinCustomListDefaultType.CustomMouseEnter;
begin
  Inherited;

  Self.FSkinCustomListIntf.Prop.FItemPanDragGestureManager.MouseEnter;

end;

procedure TSkinCustomListDefaultType.CustomMouseLeave;
begin
  inherited;

  Self.FSkinCustomListIntf.Prop.FItemPanDragGestureManager.MouseLeave;

  //�����ʼ��Ŀƽ����
  if Self.FSkinCustomListIntf.Prop.IsStartedItemPanDrag then
  begin
    TSkinItemDesignerPanel(Self.FSkinCustomListIntf.Prop.FItemPanDragDesignerPanel).SkinControlType.DirectUIMouseLeave;
  end;

  DoProcessItemCustomMouseLeave(Self.FSkinCustomListIntf.Prop.MouseOverItem);

  Self.FSkinCustomListIntf.Prop.MouseOverItem:=nil;

end;

procedure TSkinCustomListDefaultType.CustomMouseMove(Shift: TShiftState;X,Y:Double);
var
  AItemDrawRect:TRectF;
  APanDragItemDrawItemDesignerPanel:TSkinItemDesignerPanel;
  APanDragItemDesignerPanelClipRect:TRectF;
begin
  inherited;


  //ȥ���ӿؼ����ݹ����������Ϣ
  if Self.FCurrentMouseEventIsChildOwn then
  begin
//    uBaseLog.OutputDebugString('TSkinCustomListDefaultType.CustomMouseMove IsChildMouseEvent');
    Exit;
  end;



  //��һ��ʱ������곬��һ�ξ���
  //�ͱ�ʾ����������¼�
  //��Ҫֹͣ�����Ķ�ʱ��
  if (Self.FSkinCustomListIntf.Prop.FMouseDownItem<>nil)
    and (GetDis(PointF(X,Y),FMouseDownPt)>8) then
  begin
    Self.FSkinCustomListIntf.Prop.StopCheckLongTapItemTimer;
    Self.FSkinCustomListIntf.Prop.StopCheckStayPressedItemTimer;
  end;





  //������ҲҪ�ж��Ƿ���Ҫƽ���б���,��Ϊ�ƶ�ƽ̨���п���MouseMove��Ϣ��MousrDown��Ϣ��
  if
    Self.FSkinCustomListIntf.Prop.CanEnableItemPanDrag
    and not Self.FSkinCustomListIntf.Prop.FIsStopingItemPanDrag
   then
  begin
    Self.FSkinCustomListIntf.Prop.FItemPanDragGestureManager.MouseMove(Shift,X,Y);
  end;






  //ԭItemDesignerPanel��������뿪Ч��
  Self.FSkinCustomListIntf.Prop.MouseOverItem:=Self.FSkinCustomListIntf.Prop.VisibleItemAt(X,Y);





  //��ȡƽ���б��������ƶ��¼�
  if Self.FSkinCustomListIntf.Prop.IsStartedItemPanDrag then
  begin
      APanDragItemDesignerPanelClipRect:=Self.FSkinCustomListIntf.Prop.GetPanDragItemDesignerPanelDrawRect;
      APanDragItemDrawItemDesignerPanel:=TSkinItemDesignerPanel(Self.FSkinCustomListIntf.Prop.FItemPanDragDesignerPanel);

      //��ʼ�¼�û�б�����
      APanDragItemDrawItemDesignerPanel.SkinControlType.EventProcessedByChild:=False;
      //������갴����Ϣ
      APanDragItemDrawItemDesignerPanel.SkinControlType.DirectUIMouseMove(Self.FSkinControl,Shift,X-APanDragItemDesignerPanelClipRect.Left,Y-APanDragItemDesignerPanelClipRect.Top);
      if APanDragItemDrawItemDesignerPanel.SkinControlType.EventProcessedByChild then
      begin
        Exit;
      end;
  end;



  //��ItemDesignerPanel��������ƶ�Ч��
  Self.DoProcessItemCustomMouseMove(Self.FSkinCustomListIntf.Prop.FMouseOverItem,
                  Shift,X,Y);


end;

procedure TSkinCustomListDefaultType.CustomMouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
var
  AItem:TBaseSkinItem;
  APanDragItemDrawItemDesignerPanel:TSkinItemDesignerPanel;
  APanDragItemDesignerPanelClipRect:TRectF;

  AIsDoProcessItemCustomMouseUp:Boolean;
begin
//  uBaseLog.OutputDebugString('TSkinCustomListDefaultType.CustomMouseUp');

  inherited;

  //ȥ���ӿؼ����ݹ����������Ϣ
  if Self.FCurrentMouseEventIsChildOwn then
  begin
//    uBaseLog.OutputDebugString('TSkinCustomListDefaultType.CustomMouseDown IsChildMouseEvent');
    Exit;
  end;


      //ֹͣ��ⳤ���б����¼�
      Self.FSkinCustomListIntf.Prop.StopCheckLongTapItemTimer;
      Self.FSkinCustomListIntf.Prop.StopCheckStayPressedItemTimer;



      //ƽ���б����
      if Self.FSkinCustomListIntf.Prop.CanEnableItemPanDrag
        and Not Self.FSkinCustomListIntf.Prop.FIsStopingItemPanDrag then
      begin
        Self.FSkinCustomListIntf.Prop.FItemPanDragGestureManager.MouseUp(Button,Shift,X,Y);
      end;




      //��ȡƽ���б������굯���¼�
      if Self.FSkinCustomListIntf.Prop.IsStartedItemPanDrag then
      begin
          APanDragItemDesignerPanelClipRect:=Self.FSkinCustomListIntf.Prop.GetPanDragItemDesignerPanelDrawRect;
          APanDragItemDrawItemDesignerPanel:=TSkinItemDesignerPanel(Self.FSkinCustomListIntf.Prop.FItemPanDragDesignerPanel);
          //��ʼ�¼�û�б�����
          APanDragItemDrawItemDesignerPanel.SkinControlType.EventProcessedByChild:=False;

          //������갴����Ϣ
          APanDragItemDrawItemDesignerPanel.SkinControlType
                          .DirectUIMouseUp(Self.FSkinControl,Button,
                                Shift,
                                X-APanDragItemDesignerPanelClipRect.Left,
                                Y-APanDragItemDesignerPanelClipRect.Top,
                                True);
          if APanDragItemDrawItemDesignerPanel.SkinControlType.EventProcessedByChild then
          begin
            Invalidate;

            Exit;
          end;

      end;



      //�����б���������Ϣ
      //�ж������Ϣ�Ƿ��б����DrawItemDesignerPanel������ӿؼ�����
      AIsDoProcessItemCustomMouseUp:=DoProcessItemCustomMouseUp(
                                Self.FSkinCustomListIntf.Prop.FInnerMouseDownItem,
                                Button,Shift,X,Y
                                );



      if
        Not Self.FSkinCustomListIntf.Prop.FHasCalledOnLongTapItem
        and Not AIsDoProcessItemCustomMouseUp
        then
      begin

          //ѡ���б���
          AItem:=Self.FSkinCustomListIntf.Prop.VisibleItemAt(X,Y);
          if
            (AItem = Self.FSkinCustomListIntf.Prop.FMouseDownItem)

              and (Abs(FMouseDownAbsolutePt.X-Self.FMouseUpAbsolutePt.X)<Const_CanCallClickEventDistance)
                and (Abs(FMouseDownAbsolutePt.Y-FMouseUpAbsolutePt.Y)<Const_CanCallClickEventDistance) then
              begin



                  //Ҳ���Ժ��е���¼�
                  //ѡ���б���
//                  Self.FSkinCustomListIntf.Prop.DoClickItem(AItem,X,Y);

//                  uBaseLog.OutputDebugString('TSkinCustomListDefaultType.CustomMouseUp ClickItem');


                  //��Timer�е���DoClickItem
                  Self.FSkinCustomListIntf.Prop.CreateCallOnClickItemTimer;
                  Self.FSkinCustomListIntf.Prop.StartCallOnClickItemTimer;

                  //��Ҫ���Ƶ��Ч��
                  Self.FSkinCustomListIntf.Prop.FLastMouseDownItem:=AItem;
                  Self.FSkinCustomListIntf.Prop.FLastMouseDownX:=X;
                  Self.FSkinCustomListIntf.Prop.FLastMouseDownY:=Y;
              end
              else
              begin
//                  uBaseLog.OutputDebugString('TSkinCustomListDefaultType.CustomMouseUp Move Over 5Pixel,Not Click');

              end;

      end;



      Self.FSkinCustomListIntf.Prop.FMouseDownItem:=nil;
      Self.FSkinCustomListIntf.Prop.FInnerMouseDownItem:=nil;

      Invalidate;


end;

procedure TSkinCustomListDefaultType.SizeChanged;
begin
  inherited;

  if (FSkinCustomListIntf<>nil)
    and (Self.FSkinCustomListIntf.Properties<>nil)
    and (Self.FSkinCustomListIntf.Prop.FListLayoutsManager<>nil) then
  begin
    Self.FSkinCustomListIntf.Prop.FListLayoutsManager.DoItemSizeChange(nil);
  end;

end;


{ TSkinCustomListDefaultMaterial }

function TSkinCustomListDefaultMaterial.GetSkinCustomListItemMaterialClass:TBaseSkinItemMaterialClass;
begin
  Result:=TBaseSkinListItemMaterial;
end;

procedure TSkinCustomListDefaultMaterial.AssignTo(Dest: TPersistent);
var
  DestObject:TSkinCustomListDefaultMaterial;
begin
  if Dest is TSkinCustomListDefaultMaterial then
  begin

    DestObject:=TSkinCustomListDefaultMaterial(Dest);


    DestObject.FDefaultTypeItemMaterial.Assign(FDefaultTypeItemMaterial);

    DestObject.FItem1TypeItemMaterial.Assign(FItem1TypeItemMaterial);

    DestObject.FIsSimpleDrawItemDevide:=FIsSimpleDrawItemDevide;


  end;
  inherited;
end;

constructor TSkinCustomListDefaultMaterial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);


  //Ĭ�������б�������ز�
  FDefaultTypeItemMaterial:=GetSkinCustomListItemMaterialClass.Create(Self);
  FDefaultTypeItemMaterial.SetSubComponent(True);
  FDefaultTypeItemMaterial.Name:='DefaultTypeItemMaterial';



  //Item1�����б�������ز�
  FItem1TypeItemMaterial:=GetSkinCustomListItemMaterialClass.Create(Self);
  FItem1TypeItemMaterial.SetSubComponent(True);
  FItem1TypeItemMaterial.Name:='Item1TypeItemMaterial';


  //�����زĸ���֪ͨ����
  FItemMaterialChangeLink:=TSkinObjectChangeLink.Create;
  FItemMaterialChangeLink.OnChange:=DoChange;
  FDefaultTypeItemMaterial.RegisterChanges(Self.FItemMaterialChangeLink);
  FItem1TypeItemMaterial.RegisterChanges(Self.FItemMaterialChangeLink);


  FDrawItemDevideLineParam:=TDrawLineParam.Create('','');

  FDrawItemDevideParam:=CreateDrawRectParam('DrawItemDevideParam','�ָ��߻��Ʋ���');
  FDrawItemDevideParam.IsControlParam:=False;
  FDrawItemDevideParam.FillDrawColor.InitDefaultColor(Const_DefaultBorderColor);
  FDrawItemDevideParam.BorderDrawColor.InitDefaultColor(Const_DefaultBorderColor);

  FIsDrawCenterItemRect:=False;

  FDrawCenterItemRectParam:=CreateDrawRectParam('DrawCenterItemRectParam','�м����Ʋ���');
  FDrawCenterItemRectParam.IsControlParam:=False;
  FDrawCenterItemRectParam.FillDrawColor.InitDefaultColor(Const_DefaultBorderColor);
  FDrawCenterItemRectParam.BorderDrawColor.InitDefaultColor(Const_DefaultBorderColor);



  FDrawEmptyContentCaptionParam:=CreateDrawTextParam('DrawEmptyContentCaptionParam','�հ�����ʱ����Ļ��Ʋ���');
  FDrawEmptyContentCaptionParam.IsControlParam:=False;

  FDrawEmptyContentDescriptionParam:=CreateDrawTextParam('DrawEmptyContentDescriptionParam','�հ�����ʱ�����Ļ��Ʋ���');
  FDrawEmptyContentDescriptionParam.IsControlParam:=False;

  FDrawEmptyContentPictureParam:=CreateDrawPictureParam('DrawEmptyContentPictureParam','�հ�����ʱͼƬ�Ļ��Ʋ���');
  FDrawEmptyContentPictureParam.IsControlParam:=False;




  FIsSimpleDrawItemDevide:=True;
end;

function TSkinCustomListDefaultMaterial.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I: Integer;
  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited LoadFromDocNode(ADocNode);

  for I := 0 to ADocNode.ChildNodes.Count - 1 do
  begin
    ABTNode:=ADocNode.ChildNodes[I];


    if ABTNode.NodeName='IsSimpleDrawItemDevide' then
    begin
      FIsSimpleDrawItemDevide:=ABTNode.ConvertNode_Bool32.Data;
    end

    else if ABTNode.NodeName='DefaultTypeItemMaterial' then
    begin
      FDefaultTypeItemMaterial.LoadFromDocNode(ABTNode.ConvertNode_Class);
    end

    else if ABTNode.NodeName='Item1TypeItemMaterial' then
    begin
      FItem1TypeItemMaterial.LoadFromDocNode(ABTNode.ConvertNode_Class);
    end
    ;
  end;

  Result:=True;
end;

function TSkinCustomListDefaultMaterial.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited SaveToDocNode(ADocNode);


  ABTNode:=ADocNode.AddChildNode_Bool32('IsSimpleDrawItemDevide','�Ƿ�򵥻��Ʒָ���');
  ABTNode.ConvertNode_Bool32.Data:=FIsSimpleDrawItemDevide;

  ABTNode:=ADocNode.AddChildNode_Class('DefaultTypeItemMaterial','Ĭ���б�����Ʋ���');
  Self.FDefaultTypeItemMaterial.SaveToDocNode(ABTNode.ConvertNode_Class);


  ABTNode:=ADocNode.AddChildNode_Class('Item1TypeItemMaterial','Item1�����б�����Ʋ���');
  Self.FItem1TypeItemMaterial.SaveToDocNode(ABTNode.ConvertNode_Class);

  Result:=True;
end;

destructor TSkinCustomListDefaultMaterial.Destroy;
begin
  FreeAndNil(FDrawItemDevideParam);
  FreeAndNil(FDrawItemDevideLineParam);

  FreeAndNil(FDrawCenterItemRectParam);



  FDefaultTypeItemMaterial.UnRegisterChanges(Self.FItemMaterialChangeLink);
  FItem1TypeItemMaterial.UnRegisterChanges(Self.FItemMaterialChangeLink);
  FreeAndNil(FDefaultTypeItemMaterial);
  FreeAndNil(FItem1TypeItemMaterial);





  FreeAndNil(FDrawEmptyContentCaptionParam);
  FreeAndNil(FDrawEmptyContentDescriptionParam);
  FreeAndNil(FDrawEmptyContentPictureParam);


  //FItemMaterialChangeLinkҪ����FDefaultTypeItemMaterial�ͷ�֮��,��Ȼ�ᱨ��
  FreeAndNil(FItemMaterialChangeLink);
  inherited;
end;

function TSkinCustomListDefaultMaterial.GetDrawItemAccessoryPictureParam: TDrawPictureParam;
begin
  Result:=FDefaultTypeItemMaterial.FDrawItemAccessoryPictureParam;
end;

function TSkinCustomListDefaultMaterial.GetDrawItemBackColorParam: TDrawRectParam;
begin
  Result:=FDefaultTypeItemMaterial.FDrawItemBackColorParam;
end;

function TSkinCustomListDefaultMaterial.GetDrawItemBackGndPictureParam: TDrawPictureParam;
begin
  Result:=FDefaultTypeItemMaterial.FDrawItemBackGndPictureParam;
end;

function TSkinCustomListDefaultMaterial.GetItemAccessoryPicture: TDrawPicture;
begin
  Result:=FDefaultTypeItemMaterial.FItemAccessoryPicture;
end;

function TSkinCustomListDefaultMaterial.GetItemBackDownPicture: TDrawPicture;
begin
  Result:=FDefaultTypeItemMaterial.FItemBackDownPicture;
end;

function TSkinCustomListDefaultMaterial.GetItemBackHoverPicture: TDrawPicture;
begin
  Result:=FDefaultTypeItemMaterial.FItemBackHoverPicture;
end;

function TSkinCustomListDefaultMaterial.GetItemBackNormalPicture: TDrawPicture;
begin
  Result:=FDefaultTypeItemMaterial.FItemBackNormalPicture;
end;

function TSkinCustomListDefaultMaterial.GetItemBackPushedPicture: TDrawPicture;
begin
  Result:=FDefaultTypeItemMaterial.FItemBackPushedPicture;
end;

//procedure TSkinCustomListDefaultMaterial.SetItemBackDisabledPicture(const Value: TDrawPicture);
//begin
//  FDefaultTypeItemMaterial.FItemBackDisabledPicture.Assign(Value);
//end;

procedure TSkinCustomListDefaultMaterial.SetItemBackDownPicture(const Value: TDrawPicture);
begin
  FDefaultTypeItemMaterial.FItemBackDownPicture.Assign(Value);
end;

//procedure TSkinCustomListDefaultMaterial.SetItemBackFocusedPicture(const Value: TDrawPicture);
//begin
//  FDefaultTypeItemMaterial.FItemBackFocusedPicture.Assign(Value);
//end;

procedure TSkinCustomListDefaultMaterial.SetItemBackHoverPicture(const Value: TDrawPicture);
begin
  FDefaultTypeItemMaterial.FItemBackHoverPicture.Assign(Value);
end;

procedure TSkinCustomListDefaultMaterial.SetItemBackNormalPicture(const Value: TDrawPicture);
begin
  FDefaultTypeItemMaterial.FItemBackNormalPicture.Assign(Value);
end;

procedure TSkinCustomListDefaultMaterial.SetIsDrawCenterItemRect(const Value: Boolean);
begin
  if FIsDrawCenterItemRect<>Value then
  begin
    FIsDrawCenterItemRect := Value;
    DoChange;
  end;
end;

procedure TSkinCustomListDefaultMaterial.SetIsSimpleDrawItemDevide(const Value: Boolean);
begin
  if FIsSimpleDrawItemDevide<>Value then
  begin
    FIsSimpleDrawItemDevide := Value;
    Self.DoChange;
  end;
end;

procedure TSkinCustomListDefaultMaterial.SetItemAccessoryPicture(const Value: TDrawPicture);
begin
  FDefaultTypeItemMaterial.FItemAccessoryPicture.Assign(Value);
end;

procedure TSkinCustomListDefaultMaterial.SetItemBackPushedPicture(const Value: TDrawPicture);
begin
  FDefaultTypeItemMaterial.FItemBackPushedPicture.Assign(Value);
end;

procedure TSkinCustomListDefaultMaterial.SetDefaultTypeItemMaterial(const Value: TBaseSkinListItemMaterial);
begin
  FDefaultTypeItemMaterial.Assign(Value);
end;

procedure TSkinCustomListDefaultMaterial.SetItem1TypeItemMaterial(const Value: TBaseSkinListItemMaterial);
begin
  FItem1TypeItemMaterial.Assign(Value);
end;

procedure TSkinCustomListDefaultMaterial.SetDefaultTypeItemStyle(const Value: String);
begin
  if FDefaultTypeItemStyle<>Value then
  begin
    FDefaultTypeItemStyle := Value;
    Self.DoChange;
  end;
end;

procedure TSkinCustomListDefaultMaterial.SetDrawCenterItemRectParam(const Value: TDrawRectParam);
begin
  FDrawCenterItemRectParam.Assign(Value);
end;

procedure TSkinCustomListDefaultMaterial.SetDrawEmptyContentCaptionParam(
  const Value: TDrawTextParam);
begin
  FDrawEmptyContentCaptionParam.Assign(Value);
end;

procedure TSkinCustomListDefaultMaterial.SetDrawEmptyContentDescriptionParam(
  const Value: TDrawTextParam);
begin
  FDrawEmptyContentDescriptionParam.Assign(Value);
end;

procedure TSkinCustomListDefaultMaterial.SetDrawEmptyContentPictureParam(
  const Value: TDrawPictureParam);
begin
  FDrawEmptyContentPictureParam.Assign(Value);
end;

procedure TSkinCustomListDefaultMaterial.SetDrawItemDevideParam(const Value: TDrawRectParam);
begin
  FDrawItemDevideParam.Assign(Value);
end;

procedure TSkinCustomListDefaultMaterial.SetDrawItemBackColorParam(const Value: TDrawRectParam);
begin
  FDefaultTypeItemMaterial.FDrawItemBackColorParam.Assign(Value);
end;

procedure TSkinCustomListDefaultMaterial.SetDrawItemBackGndPictureParam(const Value: TDrawPictureParam);
begin
  FDefaultTypeItemMaterial.FDrawItemBackGndPictureParam.Assign(Value);
end;

procedure TSkinCustomListDefaultMaterial.SetDrawItemAccessoryPictureParam(const Value: TDrawPictureParam);
begin
  FDefaultTypeItemMaterial.FDrawItemAccessoryPictureParam.Assign(Value);
end;




{ TBaseSkinListItemMaterial }


constructor TBaseSkinListItemMaterial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);


  FDrawItemBackColorParam:=CreateDrawRectParam('DrawItemBackColorParam','�������Ʋ���');
  FDrawItemBackColorParam.IsControlParam:=False;

  FDrawItemBackGndPictureParam:=CreateDrawPictureParam('DrawItemBackGndPictureParam','����ͼƬ���Ʋ���');
  FDrawItemBackGndPictureParam.IsControlParam:=False;



  FItemAccessoryPicture:=CreateDrawPicture('ItemAccessoryPicture','չ��ͼƬ');
  FDrawItemAccessoryPictureParam:=CreateDrawPictureParam('DrawItemAccessoryPictureParam','չ��ͼƬ���Ʋ���');
  FDrawItemAccessoryPictureParam.IsControlParam:=False;



  FItemBackNormalPicture:=CreateDrawPicture('ItemBackNormalPicture','����״̬ͼƬ','����״̬ͼƬ');
  FItemBackHoverPicture:=CreateDrawPicture('ItemBackHoverPicture','���ͣ��״̬ͼƬ','����״̬ͼƬ');
  FItemBackDownPicture:=CreateDrawPicture('ItemBackDownPicture','��갴��״̬ͼƬ','����״̬ͼƬ');
//  FItemBackDisabledPicture:=CreateDrawPicture('ItemBackDisabledPicture','����״̬ͼƬ','����״̬ͼƬ');
//  FItemBackFocusedPicture:=CreateDrawPicture('ItemBackFocusedPicture','�õ�����״̬ͼƬ','����״̬ͼƬ');
  FItemBackPushedPicture:=CreateDrawPicture('ItemBackPushedPicture','����״̬ͼƬ','����״̬ͼƬ');


end;

destructor TBaseSkinListItemMaterial.Destroy;
begin
  FreeAndNil(FDrawItemBackColorParam);
  FreeAndNil(FDrawItemBackGndPictureParam);

  FreeAndNil(FItemAccessoryPicture);
  FreeAndNil(FDrawItemAccessoryPictureParam);

  FreeAndNil(FItemBackHoverPicture);
  FreeAndNil(FItemBackNormalPicture);
  FreeAndNil(FItemBackDownPicture);
  FreeAndNil(FItemBackPushedPicture);
//  FreeAndNil(FItemBackFocusedPicture);
//  FreeAndNil(FItemBackDisabledPicture);

  inherited;
end;

//procedure TBaseSkinListItemMaterial.SetItemBackDisabledPicture(const Value: TDrawPicture);
//begin
//  FItemBackDisabledPicture.Assign(Value);
//end;

procedure TBaseSkinListItemMaterial.SetItemBackDownPicture(const Value: TDrawPicture);
begin
  FItemBackDownPicture.Assign(Value);
end;

//procedure TBaseSkinListItemMaterial.SetItemBackFocusedPicture(const Value: TDrawPicture);
//begin
//  FItemBackFocusedPicture.Assign(Value);
//end;

procedure TBaseSkinListItemMaterial.SetItemBackHoverPicture(const Value: TDrawPicture);
begin
  FItemBackHoverPicture.Assign(Value);
end;

procedure TBaseSkinListItemMaterial.SetItemBackNormalPicture(const Value: TDrawPicture);
begin
  FItemBackNormalPicture.Assign(Value);
end;

procedure TBaseSkinListItemMaterial.SetItemAccessoryPicture(const Value: TDrawPicture);
begin
  FItemAccessoryPicture.Assign(Value);
end;

procedure TBaseSkinListItemMaterial.SetItemBackPushedPicture(const Value: TDrawPicture);
begin
  FItemBackPushedPicture.Assign(Value);
end;

procedure TBaseSkinListItemMaterial.SetDrawItemBackColorParam(const Value: TDrawRectParam);
begin
  FDrawItemBackColorParam.Assign(Value);
end;

procedure TBaseSkinListItemMaterial.SetDrawItemBackGndPictureParam(const Value: TDrawPictureParam);
begin
  FDrawItemBackGndPictureParam.Assign(Value);
end;

procedure TBaseSkinListItemMaterial.SetDrawItemAccessoryPictureParam(const Value: TDrawPictureParam);
begin
  FDrawItemAccessoryPictureParam.Assign(Value);
end;




{ TSkinCustomList }

function TSkinCustomList.Material:TSkinCustomListDefaultMaterial;
begin
  Result:=TSkinCustomListDefaultMaterial(SelfOwnMaterial);
end;

function TSkinCustomList.SelfOwnMaterialToDefault:TSkinCustomListDefaultMaterial;
begin
  Result:=TSkinCustomListDefaultMaterial(SelfOwnMaterial);
end;

function TSkinCustomList.CurrentUseMaterialToDefault:TSkinCustomListDefaultMaterial;
begin
  Result:=TSkinCustomListDefaultMaterial(CurrentUseMaterial);
end;

function TSkinCustomList.GetPostValue(ASetting: TFieldControlSetting;
  APageDataDir: String; ASetRecordFieldValueIntf: ISetRecordFieldValue;
  var AErrorMessage: String): Variant;
var
  I: Integer;
  AItem:TSkinItem;
  AStringList:TStringList;
begin
  Result:=Inherited;


  //���ؼ�����ֵ
  //�ж�AValue�Ƿ����ַ����б�,
  //Ӧ���ڽ�Ⱥ��ʱ�򷵻�Ⱥ��ԱID�б�
  AStringList:=TStringList.Create;
  Self.Prop.Items.BeginUpdate;
  try

    for I := 0 to Self.Prop.Items.Count - 1 do
    begin
      AItem:=TSkinItem(Self.Prop.Items[I]);
      AStringList.Add(AItem.Caption);

    end;

    Result:=AStringList.CommaText;

  finally
    Self.Prop.Items.EndUpdate;
    FreeAndNil(AStringList);
  end;

end;

//function TSkinCustomList.GetProp(APropName: String): Variant;
//begin
//  Result:=Inherited;
//
//
//end;

function TSkinCustomList.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TCustomListProperties;
end;

//function TSkinCustomList.GetPropJsonStr: String;
//begin
//  Result:=Inherited;
//
//
//end;

function TSkinCustomList.GetCustomListProperties: TCustomListProperties;
begin
  Result:=TCustomListProperties(Self.FProperties);
end;

procedure TSkinCustomList.SetControlValue(ASetting: TFieldControlSetting;
  APageDataDir, AImageServerUrl: String; AValue: Variant; AValueCaption: String;
  AGetDataIntfResultFieldValueIntf: IGetDataIntfResultFieldValue);
var
  AStringList:TStringList;
  I: Integer;
  AItem:TSkinItem;
begin
  inherited;

  //���ؼ�����ֵ
  //�ж�AValue�Ƿ����ַ����б�
  AStringList:=TStringList.Create;
  Self.Prop.Items.BeginUpdate;
  try
    Self.Prop.Items.Clear;
    AStringList.CommaText:=AValue;

    for I := 0 to AStringList.Count - 1 do
    begin
      AItem:=TSkinItem(Self.Prop.Items.Add);
      AItem.Caption:=AStringList[I];
    end;

  finally
    Self.Prop.Items.EndUpdate;
    FreeAndNil(AStringList);
  end;
end;

procedure TSkinCustomList.SetCustomListProperties(Value: TCustomListProperties);
begin
  Self.FProperties.Assign(Value);
end;

//procedure TSkinCustomList.SetProp(APropName: String; APropValue: Variant);
//begin
//  inherited;
//
//end;

//procedure TSkinCustomList.SetPropJsonStr(AJsonStr: String);
//begin
//  inherited;
//
//end;

function TSkinCustomList.GetItems:TBaseSkinItems;
begin
  Result:=Self.Properties.Items;
end;

procedure TSkinCustomList.Loaded;
begin
  Inherited;

  //��������
  Self.Properties.Items.EndUpdate(True);


  //Ĭ��ѡ�о�����ʾ��
  if Properties.IsEnabledCenterItemSelectMode then
  begin
    Properties.DoAdjustCenterItemPositionAnimateEnd(Self);
  end;
end;

function TSkinCustomList.LoadFromFieldControlSetting(ASetting: TFieldControlSetting;AFieldControlSettingMap:TObject): Boolean;
begin
  Result:=Inherited;

  Self.Prop.MultiSelect:=(ASetting.options_is_multi_select=1);


//  if (ASetting.options_value<>'')
//    or (ASetting.options_page_name<>'') then
//  begin
//
//  end;

end;

procedure TSkinCustomList.ReadState(Reader: TReader);
begin
  //��ʼ����
  Self.Properties.Items.BeginUpdate;

  LockSkinControlInvalidate;
  try
    inherited ReadState(Reader);
  finally
    UnLockSkinControlInvalidate;
  end;


end;

procedure TSkinCustomList.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);

  if (Operation=opRemove) then
  begin
    if (Self.Properties<>nil) then
    begin

      //��������Component�ͷ�֮��,�������
      if (AComponent=Self.Properties.ItemPanDragDesignerPanel) then
      begin
        Self.Properties.ItemPanDragDesignerPanel:=nil;
      end;

      //��������Component�ͷ�֮��,�������
      if (AComponent=Self.Properties.EmptyContentControl) then
      begin
        Self.Properties.EmptyContentControl:=nil;
      end;

    end;
  end;
end;

function TSkinCustomList.GetOnAdvancedDrawItem: TCustomListDrawItemEvent;
begin
  Result:=FOnAdvancedDrawItem;
end;

function TSkinCustomList.GetOnClickItem: TCustomListClickItemEvent;
begin
  Result:=FOnClickItem;
end;

function TSkinCustomList.GetOnClickItemDesignerPanelChild: TCustomListClickItemDesignerPanelChildEvent;
begin
  Result:=FOnClickItemDesignerPanelChild;
end;

//function TSkinCustomList.GetOnItemDesignerPanelChildCanStartEdit: TCustomListItemDesignerPanelChildCanStartEditEvent;
//begin
//  Result:=FOnItemDesignerPanelChildCanStartEdit;
//end;

function TSkinCustomList.GetOnLongTapItem: TCustomListDoItemEvent;
begin
  Result:=FOnLongTapItem;
end;

function TSkinCustomList.GetOnMouseOverItemChange: TNotifyEvent;
begin
  Result:=FOnMouseOverItemChange;
end;

function TSkinCustomList.GetOnClickItemEx: TCustomListClickItemExEvent;
begin
  Result:=FOnClickItemEx;
end;

function TSkinCustomList.GetOnCenterItemChange: TCustomListDoItemEvent;
begin
  Result:=FOnCenterItemChange;
end;

function TSkinCustomList.GetOnPrepareDrawItem: TCustomListDrawItemEvent;
begin
  Result:=FOnPrepareDrawItem;
end;

function TSkinCustomList.GetOnSelectedItem: TCustomListDoItemEvent;
begin
  Result:=FOnSelectedItem;
end;

function TSkinCustomList.GetOnPrepareItemPanDrag: TCustomListPrepareItemPanDragEvent;
begin
  Result:=FOnPrepareItemPanDrag;
end;

function TSkinCustomList.GetOnStartEditingItem: TCustomListEditingItemEvent;
begin
  Result:=FOnStartEditingItem;
end;

function TSkinCustomList.GetOnStopEditingItem: TCustomListEditingItemEvent;
begin
  Result:=FOnStopEditingItem;
end;



{ TListItemStyleRegList }

function TListItemStyleRegList.FindItemByClass(AFrameClass: TFrameClass): TListItemStyleReg;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Self.Count-1 do
  begin
    if AFrameClass=Items[I].FrameClass then
    begin
      Result:=Items[I];
      Break;
    end;
  end;
end;

function TListItemStyleRegList.FindItemByName(AName: String): TListItemStyleReg;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Self.Count-1 do
  begin
    if SameText(AName,Items[I].Name) then
    begin
      Result:=Items[I];
      Break;
    end;
  end;
end;

function TListItemStyleRegList.GetItem(Index: Integer): TListItemStyleReg;
begin
  Result:=TListItemStyleReg(Inherited Items[Index]);
end;

function GetSuitControlContentHeight(AControl:TParentControl;const ABottomSpace:TControlSize):TControlSize;
var
  I: Integer;
  AChild:TControl;
//  ALastControl:TControl;
begin
  Result:=0;
//  ALastControl:=nil;

  for I := 0 to GetParentChildControlCount(AControl)-1 do
  begin
    AChild:=GetParentChildControl(AControl,I);
    if  //����Ҫͳ����ʾ�Ŀؼ�
        AChild.Visible
      and BiggerDouble(AChild.Height,0)
      and (GetControlTop(AChild)+AChild.Height>Result) then
    begin
//      ALastControl:=GetParentChildControl(AControl,I);
      Result:=GetControlTop(AChild)+AChild.Height;
    end;
  end;
  Result:=Result+ABottomSpace;


//  //�����ڲ���
//  if ALastControl<>nil then
//  begin
//    uBaseLog.OutputDebugString('GetSuitControlContentHeight LastControl '+ALastControl.Name);
//  end;
end;

{ TListItemTypeStyleSetting }

function TListItemTypeStyleSetting.CalcItemAutoSize(AItem: TBaseSkinItem; const ABottomSpace: TControlSize): TSizeF;
var
  AItemDrawRect:TRect;
  AItemDrawRectF:TRectF;
  AItemDesignerPanel:TSkinItemDesignerPanel;
begin
  //Ĭ��ֵ
  Result.cx:=AItem.GetWidth;
  Result.cy:=AItem.GetHeight;


  //ʹ����������
  AItemDesignerPanel:=GetInnerItemDesignerPanel(nil);


  if (AItemDesignerPanel<>nil) and (FCustomListProperties<>nil) then
  begin
      //�����Item�ľ���,����Ҫλ��,ֻ��Ҫ�߶ȺͿ��
      AItemDrawRect:=Rect(0,
                          0,
                          Ceil(Self.FCustomListProperties.CalcItemWidth(AItem)),
                          Ceil(Self.FCustomListProperties.CalcItemHeight(AItem))
                          );
      AItemDrawRectF:=RectF(0,
                          0,
                          Ceil(Self.FCustomListProperties.CalcItemWidth(AItem)),
                          Ceil(Self.FCustomListProperties.CalcItemHeight(AItem))
                          );
      //���óߴ�,��Ϊ��Щ�ؼ���Ҫ����
      AItemDesignerPanel.Height:=ControlSize(RectHeight(AItemDrawRect));
      AItemDesignerPanel.Width:=ControlSize(RectWidth(AItemDrawRect));


      AItemDesignerPanel.Prop.SetControlsValueByItem(
                                                    TSkinVirtualList(Self.FCustomListProperties.FSkinControl).Prop.SkinImageList,
                                                    TSkinItem(AItem),
                                                    False);


      if Assigned(AItemDesignerPanel.OnPrepareDrawItem) then
      begin
        AItemDesignerPanel.OnPrepareDrawItem(
                                            nil,
                                            nil,
                                            TItemDesignerPanel(AItemDesignerPanel),
                                            TSkinItem(AItem),
                                            AItemDrawRectF
                                            );
      end;



      if Assigned(TSkinVirtualList(Self.FCustomListProperties.FSkinControl).OnPrepareDrawItem) then
      begin
        TSkinVirtualList(Self.FCustomListProperties.FSkinControl).OnPrepareDrawItem(
              nil,
              nil,
              TItemDesignerPanel(AItemDesignerPanel),
              TSkinItem(AItem),
              AItemDrawRect
              );
      end;

      Result.cy:=GetSuitControlContentHeight(AItemDesignerPanel,ABottomSpace);
  end;

//    Result:=Self.GetItemStyleFrameCache(nil)
//                .FItemStyleFrame.CalcItemSize(
//                  TSkinVirtualList(Self.FSkinControl),
//                  AItem,
//                  Rect(0,0,
//                        Ceil(Self.FSkinControl.Width),
//                        Ceil(Self.ItemHeight)
//                        )
//                  );


end;

procedure TListItemTypeStyleSetting.Clear;
begin
  //�б���������
  Style:='';// read FStyle write SetStyle;
  //�б���������
  ItemDesignerPanel:=nil;// read FItemDesignerPanel write SetItemDesignerPanel;
end;

constructor TListItemTypeStyleSetting.Create(AProp: TCustomListProperties;AItemType:TSkinItemType);
begin
  FConfig:=TStringList.Create;
  FCustomListProperties:=AProp;
  FItemType:=AItemType;
  FIsUseCache:=True;
  FFrameCacheList:=TListItemStyleFrameCacheList.Create;
end;

destructor TListItemTypeStyleSetting.Destroy;
begin
  try
    SetItemDesignerPanel(nil);

    FreeAndNil(FFrameCacheList);

    FreeAndNil(FConfig);

    inherited;
  except
    on E:Exception do
    begin
      uBaseLog.HandleException(E,'TListItemTypeStyleSetting.Destroy');
    end;
  end;
end;

procedure TListItemTypeStyleSetting.DoDownloadListItemStyleStateChange(
  Sender: TObject; AUrlCacheItem: TUrlCacheItem);
begin
  //���سɹ�
  if (AUrlCacheItem.State=dpsDownloadSucc) and (AUrlCacheItem.IsLoaded) then
  begin
    Self.SetListItemStyleReg(TBaseUrlListItemStyle(AUrlCacheItem).FListItemStyleReg);
  end;
end;

function TListItemTypeStyleSetting.GetInnerItemDesignerPanel(ASkinItem: TBaseSkinItem): TSkinItemDesignerPanel;
var
  AItemStyleFrameCache:TListItemStyleFrameCache;
begin
//  if ASkinItem<>nil then
//  begin
//    //Ҫ������
//    TBaseSkinItem(ASkinItem).FDrawListItemTypeStyleSetting:=Self;
//  end;

  if (Self.FStyle<>'') and (FListItemStyleReg<>nil) then
  begin

      //ʹ���˷��
      //��ȡ����
      AItemStyleFrameCache:=GetItemStyleFrameCache(ASkinItem);


      if AItemStyleFrameCache<>nil then
      begin
        Result:=AItemStyleFrameCache.FItemStyleFrameIntf.ItemDesignerPanel;
      end
      else
      begin
        uBaseLog.HandleException(nil,'TListItemTypeStyleSetting.GetInnerItemDesignerPanel AItemStyleFrame is nil');
      end;

  end
  else
  begin

      //��ʹ�÷��,ֱ��ʹ��������
      Result:=Self.FItemDesignerPanel;
  end;
end;

function TListItemTypeStyleSetting.GetItemStyleFrameCache(ASkinItem: TBaseSkinItem): TListItemStyleFrameCache;
var
  I:Integer;
begin
  Result:=nil;
  if (Self.Style<>'') and (FListItemStyleReg<>nil) then
  begin
      if FIsUseCache then
      begin




          //ʹ�û���
          //�����,ֱ���ҵ��ϴ�ʹ�õ�
          for I := 0 to FFrameCacheList.Count-1 do
          begin
            if (FFrameCacheList[I].FSkinItem=ASkinItem) then
            begin
              Result:=FFrameCacheList[I];
              Exit;
            end;
          end;




          //Ѱ�ҳ����õ�,���߽п��е�
          if Result=nil then
          begin
              for I := 0 to FFrameCacheList.Count-1 do
              begin
                if not FFrameCacheList[I].FIsUsed then
                begin

                    Result:=FFrameCacheList[I];
                    //���Ϊ��ʹ��
                    FFrameCacheList[I].FSkinItem:=ASkinItem;
                    FFrameCacheList[I].FIsUsed:=True;

                    //��������
                    if ASkinItem<>nil then
                    begin
                      LoadListItemStyleFrameConfig(FFrameCacheList[I].FItemStyleFrame,ASkinItem.FItemStyleConfig);
                    end;

                    Exit;
                end;
              end;
          end;




          //ʵ��û��,�ʹ���һ���µ�
          //��Ҳ����һֱ�����µ�
          if Result=nil then
          begin
              uBaseLog.HandleException(nil,'TListItemTypeStyleSetting.GetItemStyleFrame IsUseCache Create A New FrameCache '+FListItemStyleReg.FrameClass.ClassName);

              //Ҫ����һ��StyleFrameCache,
              Result:=NewListItemStyleFrameCache;

              //wn
              Result.FSkinItem:=ASkinItem;

              Result.FIsUsed:=True;

              //��������
              //��������
              if ASkinItem<>nil then
              begin
                LoadListItemStyleFrameConfig(Result.FItemStyleFrame,ASkinItem.FItemStyleConfig);
              end;

          end;



      end
      else
      begin
          //��ʹ�û���,��ôֻȡ��һ��������
          if FFrameCacheList.Count=0 then
          begin
              //Ҫ����һ��Frame,
              uBaseLog.HandleException(nil,'TListItemTypeStyleSetting.GetItemStyleFrame IsNoCache Create A New FrameCache '+FListItemStyleReg.FrameClass.ClassName);

              Result:=NewListItemStyleFrameCache;

//              TListItemStyleFrameCache.Create;
//              Self.FFrameCacheList.Add(Result);//�����,������XPϵͳ����һ������ʧ��,�������������������
//              try
//                  Result.FItemStyleFrame:=FListItemStyleReg.FrameClass.Create(nil);
//
////                  uBaseLog.HandleException(nil,'TListItemTypeStyleSetting.GetItemStyleFrame IsNoCache Create A New FrameCache 1');
//
//                  SetFrameName(Result.FItemStyleFrame);
//                  LoadListItemStyleFrameConfig(Result.FItemStyleFrame,Self.FConfig);
//                  Result.FItemStyleFrame.GetInterface(IID_IFrameBaseListItemStyle,Result.FItemStyleFrameIntf);
//
//
////                  uBaseLog.HandleException(nil,'TListItemTypeStyleSetting.GetItemStyleFrame IsNoCache Create A New FrameCache 2');
//                  {$IFDEF FMX}
//    //              Result.FItemStyleFrame.Position.X:=-1000;
//    //              Result.FItemStyleFrame.Position.Y:=-1000;
//                  {$ELSE}
//                  Result.FItemStyleFrame.Parent:=TParentControl(FCustomListProperties.FSkinControl);
////                  uBaseLog.HandleException(nil,'TListItemTypeStyleSetting.GetItemStyleFrame IsNoCache Create A New FrameCache 3');
//                  Result.FItemStyleFrame.Left:=-1000;
//                  Result.FItemStyleFrame.Top:=-1000;
////                  uBaseLog.HandleException(nil,'TListItemTypeStyleSetting.GetItemStyleFrame IsNoCache Create A New FrameCache 4');
//                  Result.FItemStyleFrame.Width:=0;
//                  Result.FItemStyleFrame.Height:=0;
//                  {$ENDIF}
//
//
////                  uBaseLog.HandleException(nil,'TListItemTypeStyleSetting.GetItemStyleFrame IsNoCache Create A New FrameCache 5');
//
//                  //������ˢ�µ�ʱ��,ˢ������ListBox
//                  if FCustomListProperties<>nil then
//                  begin
//                    Result.FItemStyleFrameIntf.ItemDesignerPanel.Properties.BindControlInvalidateChange.RegisterChanges(
//                      Self.FCustomListProperties.FItemDesignerPanelInvalidateLink);
//                  end;
//
//              except
//                on E:Exception do
//                begin
//                  uBaseLog.HandleException(E,'TListItemTypeStyleSetting.GetItemStyleFrame IsNoCache Create A New FrameCache '+FListItemStyleReg.FrameClass.ClassName);
//                end;
//              end;

          end
          else
          begin
              //ֻ����һ��,ֱ��ʹ�õ�һ��
              Result:=FFrameCacheList[0];
          end;
      end;
  end;
end;

procedure TListItemTypeStyleSetting.MarkAllCacheNoUsed;
var
  I:Integer;
begin
  for I := 0 to Self.FFrameCacheList.Count-1 do
  begin
    Self.FFrameCacheList[I].FIsUsed:=False;
  end;
end;

procedure TListItemTypeStyleSetting.MarkCacheUsed(ASkinItem: TBaseSkinItem);
var
  I:Integer;
begin
  for I := 0 to FFrameCacheList.Count-1 do
  begin
    if (FFrameCacheList[I].FSkinItem=ASkinItem) then
    begin
      FFrameCacheList[I].FIsUsed:=True;
      Break;
    end;
  end;
end;

function TListItemTypeStyleSetting.NewListItemStyleFrameCache: TListItemStyleFrameCache;
begin
        LockSkinControlInvalidate;
        try
          Result:=TListItemStyleFrameCache.Create;
          Self.FFrameCacheList.Add(Result);
          try

              //����һ��Frame
              Result.FItemStyleFrame:=FListItemStyleReg.FrameClass.Create(nil);
              SetFrameName(Result.FItemStyleFrame);

              //�����û���ListItemStyleFrame�������Զ�������
              LoadListItemStyleFrameConfig(Result.FItemStyleFrame,Self.FConfig);


              Result.FItemStyleFrame.GetInterface(IID_IFrameBaseListItemStyle,Result.FItemStyleFrameIntf);


              {$IFDEF FMX}
//              Result.FItemStyleFrame.Position.X:=-1000;
//              Result.FItemStyleFrame.Position.Y:=-1000;
              if not (csDesigning in FCustomListProperties.FSkinControl.ComponentState) then
              begin
                //����Ҫ����parent,��Ȼ͸����û��Ч����
                Result.FItemStyleFrame.Parent:=TParentControl(FCustomListProperties.FSkinControl);
                Result.FItemStyleFrame.Visible:=False;
              end;
              {$ELSE}
//              //����Parent,��ᵼ��ListBoxˢ��,���º����FOnInit��Init
//              Result.FItemStyleFrame.Parent:=TParentControl(FCustomListProperties.FSkinControl);
//              Result.FItemStyleFrame.Left:=-1000;
//              Result.FItemStyleFrame.Top:=-1000;
//              Result.FItemStyleFrame.Width:=0;
//              Result.FItemStyleFrame.Height:=0;
              {$ENDIF}



              if Assigned(FOnInit) then
              begin
                FOnInit(Self,Self,Result);
              end;


              //��ʼ
              //ͬһ��Frame�������ʽʹ��ʱ,���ݲ�ͬReg.DataObject����ʼ
              //����ListItemStyleFrame_Page
              if Result.FItemStyleFrame.GetInterface(IID_IFrameBaseListItemStyle_Init,Result.FItemStyleFrameInitIntf) then
              begin
                Result.FItemStyleFrameInitIntf.Init(FListItemStyleReg);
              end;


//              //��Ϊ����������
//              SetComponentUniqueName(Result.FItemStyleFrame);
//              Result.FItemStyleFrame.Parent:=Application.MainForm;
//              Result.FItemStyleFrame.Position.X:=2000;
//              Result.FItemStyleFrameIntf.ItemDesignerPanel.Visible:=True;

              uBaseLog.HandleException(nil,'TListItemTypeStyleSetting.GetItemStyleFrame '+FListItemStyleReg.FrameClass.ClassName+' Count:'+IntToStr(Self.FFrameCacheList.Count));
//              procedure SetComponentUniqueName(AComponent:TComponent);



              //������ˢ�µ�ʱ��,ˢ������ListBox
              if FCustomListProperties<>nil then
              begin
                Result.FItemStyleFrameIntf.ItemDesignerPanel.Properties.BindControlInvalidateChange.RegisterChanges(
                  Self.FCustomListProperties.FItemDesignerPanelInvalidateLink);
              end;


              {$IFDEF VCL}
              //��ᵼ��ListBoxˢ��
              Result.FItemStyleFrame.Parent:=TParentControl(FCustomListProperties.FSkinControl);
              Result.FItemStyleFrame.Left:=-1000;
              Result.FItemStyleFrame.Top:=-1000;
              Result.FItemStyleFrame.Width:=0;
              Result.FItemStyleFrame.Height:=0;
              {$ENDIF}



          except
            on E:Exception do
            begin
              uBaseLog.HandleException(E,'TListItemTypeStyleSetting.GetItemStyleFrame IsUseCache Create A New FrameCache '+FListItemStyleReg.FrameClass.ClassName);
            end;
          end;
        finally
          UnLockSkinControlInvalidate;
        end;

end;

procedure TListItemTypeStyleSetting.ReConfig;
var
  I: Integer;
begin
  for I := 0 to Self.FFrameCacheList.Count-1 do
  begin
    //�����û���ListItemStyleFrame�������Զ�������
    LoadListItemStyleFrameConfig(FFrameCacheList[I].FItemStyleFrame,Self.FConfig);
  end;

end;

procedure TListItemTypeStyleSetting.ResetStyle;
var
  AUrlCacheItem:TUrlCacheItem;
  AListItemStyleReg: TListItemStyleReg;
begin
  if FIsUseUrlStyle then
  begin


      if (Self.FStyleRootUrl<>'')
          and (Self.FStyle<>'') then
      begin

        //ʹ��������ʽ
        //Self.FListItemStyleReg:=
        if Assigned(GlobalOnGetUrlListItemStyleReg) then
        begin
          GlobalOnGetUrlListItemStyleReg(Self,Self.DoDownloadListItemStyleStateChange);
        end
        else
        begin
          raise Exception.Create('GlobalOnGetUrlListItemStyleRegδ��ֵ,������uDownloadListItemStyleManager��Ԫ');
        end;

      end
      else
      begin
        //��������,�ݲ�����
        //Self.FListItemStyleReg:=nil;


      end;

  end
  else
  begin

      //ʹ�ñ�����ʽ

      //���������ҵ��б�����ע����
      AListItemStyleReg:=GetGlobalListItemStyleRegList.FindItemByName(FStyle);
//      if (FStyle<>'') and (AListItemStyleReg=nil) then
//      begin
//        ShowMessage('δע���б�����ʽ'+FStyle+',�밲װOrangeUIStyles�������ö�Ӧ����ʽ��Ԫ');
//      end;
      uBaseLog.HandleException(nil,'TListItemTypeStyleSetting.ResetStyle δע���б�����ʽ'+FStyle+',�밲װOrangeUIStyles�������ö�Ӧ����ʽ��Ԫ');
      SetListItemStyleReg(AListItemStyleReg);


  end;
end;

procedure TListItemTypeStyleSetting.SetConfig(const Value: TStringList);
begin
  FConfig.Assign(Value);
  ReConfig;
end;

procedure TListItemTypeStyleSetting.SetIsUseUrlStyle(const Value: Boolean);
begin
  if FIsUseUrlStyle<>Value then
  begin
    FIsUseUrlStyle := Value;

    ResetStyle;
  end;
end;

procedure TListItemTypeStyleSetting.SetItemDesignerPanel(const Value: TSkinItemDesignerPanel);
begin
  if FItemDesignerPanel <> Value then
  begin
    if FCustomListProperties<>nil then
    begin
      FCustomListProperties.RemoveOldDesignerPanel(FItemDesignerPanel);
    end;

    FItemDesignerPanel:=Value;

    if FCustomListProperties<>nil then
    begin
      FCustomListProperties.AddNewDesignerPanel(FItemDesignerPanel);
    end;
  end;
end;

procedure TListItemTypeStyleSetting.SetListItemStyleReg(
  AListItemStyleReg: TListItemStyleReg);
begin
  if AListItemStyleReg<>FListItemStyleReg then
  begin
    //�������
    FFrameCacheList.Clear(True);


    //ͬʱֻ����һ�ַ�ʽ
    //��ItemDesignerPanel����Ϊnil,���ⷢ������,�����õ����ĸ�����?
    Self.SetItemDesignerPanel(nil);

    FListItemStyleReg:=AListItemStyleReg;
  end;
end;

procedure TListItemTypeStyleSetting.SetStyle(const Value: String);
begin
  if FStyle<>Value then
  begin
    FStyle := Value;

    uBaseLog.HandleException(nil,'TListItemTypeStyleSetting.SetStyle '+Value);


    ResetStyle;

  end;
end;

procedure TListItemTypeStyleSetting.SetStyleRootUrl(const Value: String);
begin
  if FStyleRootUrl<>Value then
  begin
    FStyleRootUrl := Value;

    ResetStyle;

  end;
end;

{ TListItemStyleFrameCacheList }

function TListItemStyleFrameCacheList.GetItem(Index: Integer): TListItemStyleFrameCache;
begin
  Result:=TListItemStyleFrameCache(Inherited Items[Index]);
end;

{ TListItemStyleFrameCache }

destructor TListItemStyleFrameCache.Destroy;
begin
  FItemStyleFrameIntf:=nil;
  FreeAndNil(FItemStyleFrame);
  inherited;
end;

{ TListItemTypeStyleSettingList }

function TListItemTypeStyleSettingList.FindByItemType(AItemType: TSkinItemType): TListItemTypeStyleSetting;
var
  I:Integer;
begin
  Result:=nil;
  for I := 0 to Self.Count-1 do
  begin
    if Items[I].FItemType=AItemType then
    begin
      Result:=Items[I];
      Break;
    end;
  end;
end;

function TListItemTypeStyleSettingList.FindByStyle(AStyle: String): TListItemTypeStyleSetting;
var
  I:Integer;
begin
  Result:=nil;
  if AStyle<>'' then
  begin
    for I := 0 to Self.Count-1 do
    begin
      if SameText(Items[I].FStyle,AStyle) then
      begin
        Result:=Items[I];
        Break;
      end;
    end;
  end;
end;

function TListItemTypeStyleSettingList.GetItem(Index: Integer): TListItemTypeStyleSetting;
begin
  Result:=TListItemTypeStyleSetting(Inherited Items[Index]);
end;

initialization

finalization
  FreeAndNil(GlobalListItemStyleRegList);


end.



