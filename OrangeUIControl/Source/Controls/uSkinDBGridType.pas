//convert pas to utf8 by ¥

/// <summary>
///   <para>
///     数据表格
///   </para>
///   <para>
///     Data Grid
///   </para>
/// </summary>
unit uSkinDBGridType;

interface
{$I FrameWork.inc}

{$I Version.inc}


uses
  Classes,
  SysUtils,
  Types,
  DateUtils,
  Math,
  Variants,
  DB,
  RTLConsts,
  DBConsts,

  {$IFDEF VCL}
  Messages,
  ExtCtrls,
  Controls,
  Dialogs,
  {$ENDIF}
  {$IFDEF FMX}
  UITypes,
  FMX.Types,
  FMX.Controls,
  FMX.Dialogs,
  {$ENDIF}


  uFuncCommon,
  uSkinAnimator,
  uBaseList,
  uBaseLog,
  uSkinItems,
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
  uSkinVirtualGridType,
  uSkinCustomListType,
  uSkinControlGestureManager,
  uSkinScrollControlType,
  uDrawPictureParam;




const
  IID_ISkinDBGrid:TGUID='{E9643ACD-B876-4ABD-8AA9-814619BEA3BD}';

const
  MaxMapSize = (MaxInt div 2) div SizeOf(Integer);  { 250 million }


type
  TDBGridProperties=class;


  /// <summary>
  ///   <para>
  ///     数据表格接口
  ///   </para>
  ///   <para>
  ///     Interface of Data grid
  ///   </para>
  /// </summary>
  ISkinDBGrid=interface//(ISkinVirtualGrid)
    ['{E9643ACD-B876-4ABD-8AA9-814619BEA3BD}']

    function GetDBGridProperties:TDBGridProperties;
    property Properties:TDBGridProperties read GetDBGridProperties;
    property Prop:TDBGridProperties read GetDBGridProperties;
  end;





  //表格异常类型
  EInvalidGridOperation = class(Exception);


  TColumnValue = (
//                  cvColor,
                  cvWidth,
//                  cvFont,
//                  cvAlignment,
                  cvReadOnly//,
//                  cvTitleColor,
//                  cvTitleCaption,
//                  cvTitleAlignment,
//                  cvTitleFont,
//                  cvImeMode,
//                  cvImeName
                  );
  TColumnValues = set of TColumnValue;




  //表格列
  TSkinDBGridColumn = class(TSkinVirtualGridColumn)
  private
    //字段
    FField: TField;
    //字段名
    FFieldName: WideString;


    //日期类型格式
    FDateTimeFormat: String;
    //数值型格式
    FValueFormat: String;

    //是否需要保存到dfm(是否更改了标题,宽度,只读等属性)
    FStored: Boolean;

    FAssignedValues: TColumnValues;


//    FColor: TColor;
//    FWidth: Integer;
//    FTitle: TColumnTitle;
//    FFont: TFont;


    //编辑相关
//    FImeMode: TImeMode;
//    FImeName: TImeName;
//    FPickList: TStrings;
//    FPopupMenu: TPopupMenu;
//    FDropDownRows: Cardinal;
//    FButtonStyle: TColumnButtonStyle;


//    FVisible: Boolean;
//    FExpanded: Boolean;
//    FAlignment: TAlignment;



//    procedure FontChanged(Sensder: TObject);
//    function  GetAlignment: TAlignment;
//    function  GetColor: TColor;
//    function  GetExpanded: Boolean;
//    function  GetFont: TFont;
//    function  GetImeMode: TImeMode;
//    function  GetImeName: TImeName;
//    function  GetParentColumn: TSkinDBGridColumn;
//    function  GetPickList: TStrings;
//    procedure SetPickList(Value: TStrings);
//    function  GetShowing: Boolean;
//    function  GetWidth: Integer;
//    function  GetVisible: Boolean;
//    function  IsAlignmentStored: Boolean;
//    function  IsColorStored: Boolean;
//    function  IsFontStored: Boolean;
//    function  IsImeModeStored: Boolean;
//    function  IsImeNameStored: Boolean;

    function  GetField: TField;
    function  GetReadOnly: Boolean;

    procedure SetField(Value: TField); virtual;
    procedure SetFieldName(const Value: WideString);
    procedure SetDateTimeFormat(const Value: String);
    procedure SetValueFormat(const Value: String);
    procedure SetReadOnly(Value: Boolean); virtual;
    procedure SetWidth(const Value: Double);override;

    function  IsWidthStored: Boolean;
    function  IsReadOnlyStored: Boolean;
//    procedure SetAlignment(Value: TAlignment); virtual;
//    procedure SetButtonStyle(Value: TColumnButtonStyle);
//    procedure SetColor(Value: TColor);
//    procedure SetExpanded(Value: Boolean);
//    procedure SetFont(Value: TFont);
//    procedure SetImeMode(Value: TImeMode); virtual;
//    procedure SetImeName(Value: TImeName); virtual;
//    procedure SetPopupMenu(Value: TPopupMenu);
//    procedure SetTitle(Value: TColumnTitle);
//    procedure SetVisible(Value: Boolean);
//    function GetExpandable: Boolean;
  protected
    //属性更改
    procedure DoPropChange(Sender:TObject=nil);override;
    //设计时显示的名称
//    function GetDisplayName: string; override;
    //标题
    function GetCaption: String;override;
    //宽度
    function GetWidth: Double;override;
//    procedure RefreshDefaultFont;
//    procedure SetIndex(Value: Integer); override;
//    function  CreateTitle: TColumnTitle; virtual;

    //是否存储到dfm文件中
    property IsStored: Boolean read FStored write FStored default True;
    function GetProperties:TDBGridProperties;

  protected
    procedure Assign(Source: TPersistent); override;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
  public
//    //获取表格列的内容类型(文本,勾选框,图片)
//    function GetContentTypes:TSkinGridColumnContentTypes;override;
    function GetValueType(ARow:TBaseSkinItem):TVarType;override;
//    function GetValueType1(ARow:TBaseSkinItem):TVarType;override;
    function GetBindItemFieldName: String;override;
    function GetBindItemFieldName1: String;override;
  public
    IsImage:Boolean;

//    function  DefaultAlignment: TAlignment;
//    function  DefaultColor: TColor;
//    function  DefaultFont: TFont;
//    function  DefaultImeMode: TImeMode;
//    function  DefaultImeName: TImeName;

    function  DefaultReadOnly: Boolean;
    function  DefaultWidth: Double;

    //恢复默认
    procedure RestoreDefaults; virtual;


//    function  Depth: Integer;
//    property  Grid: TDBGridProperties read GetProperties;
//    property  Expandable: Boolean read GetExpandable;
//    property  ParentColumn: TSkinDBGridColumn read GetParentColumn;
//    property  Showing: Boolean read GetShowing;

    //设置过哪些属性,如果没有设置过,那么取默认
    property  AssignedValues: TColumnValues read FAssignedValues;

    /// <summary>
    ///   <para>
    ///     绑定的字段
    ///   </para>
    ///   <para>
    ///     Bind field
    ///   </para>
    /// </summary>
    property Field: TField read GetField write SetField;
  published
    /// <summary>
    ///   <para>
    ///     字段名
    ///   </para>
    ///   <para>
    ///     Field name
    ///   </para>
    /// </summary>
    property FieldName: WideString read FFieldName write SetFieldName;
    /// <summary>
    ///   <para>
    ///     日期型字段的格式
    ///   </para>
    ///   <para>
    ///     Format of date field
    ///   </para>
    /// </summary>
    property DateTimeFormat:String read FDateTimeFormat write SetDateTimeFormat;
    /// <summary>
    ///   <para>
    ///     数值型字段的格式
    ///   </para>
    ///   <para>
    ///     Format of value field
    ///   </para>
    /// </summary>
    property ValueFormat:String read FValueFormat write SetValueFormat;

//    property  Alignment: TAlignment read GetAlignment write SetAlignment stored IsAlignmentStored;
//    property  ButtonStyle: TColumnButtonStyle read FButtonStyle write SetButtonStyle default cbsAuto;
//    property  Color: TColor read GetColor write SetColor stored IsColorStored;
//    property  DropDownRows: Cardinal read FDropDownRows write FDropDownRows default 7;
//    property  Expanded: Boolean read GetExpanded write SetExpanded default True;


//    property  Font: TFont read GetFont write SetFont stored IsFontStored;
//    property  ImeMode: TImeMode read GetImeMode write SetImeMode stored IsImeModeStored;
//    property  ImeName: TImeName read GetImeName write SetImeName stored IsImeNameStored;
//    property  PickList: TStrings read GetPickList write SetPickList;
//    property  PopupMenu: TPopupMenu read FPopupMenu write SetPopupMenu;
//    property  Title: TColumnTitle read FTitle write SetTitle;
//    property  Visible: Boolean read GetVisible write SetVisible;


    //是否只读
    property  ReadOnly: Boolean read GetReadOnly write SetReadOnly stored IsReadOnlyStored;
    //宽度
    property  Width: Double read GetWidth write SetWidth stored IsWidthStored;
  end;




  //表格列的状态(是自动创建的还是手动创建的)
  TSkinDBGridColumnsState = (csDefault, csCustomized);


  /// <summary>
  ///   <para>
  ///     表格列的列表
  ///   </para>
  ///   <para>
  ///     List of grid columns
  ///   </para>
  /// </summary>
  TSkinDBGridColumns = class(TSkinVirtualGridColumns)
  protected
    function GetProperties:TDBGridProperties;

    //绑定DataSource时内部添加的,不保存在dfm文件中
    function InternalAdd: TSkinDBGridColumn;
    //
    function GetState: TSkinDBGridColumnsState;
    function GetColumn(Index: Integer): TSkinDBGridColumn;
    procedure SetColumn(Index: Integer; Value: TSkinDBGridColumn);
    procedure SetState(NewState: TSkinDBGridColumnsState);
//  protected
//    function GetOwner: TPersistent; override;
//    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AProperties:TVirtualGridProperties;
                        ItemClass: TCollectionItemClass);override;
  public

    /// <summary>
    ///   <para>
    ///     添加表格列
    ///   </para>
    ///   <para>
    ///     Add grid column
    ///   </para>
    /// </summary>
    function Add: TSkinDBGridColumn;

    procedure RestoreDefaults;

    /// <summary>
    ///   <para>
    ///     重建表格列列表
    ///   </para>
    ///   <para>
    ///     Rebuild grid column list
    ///   </para>
    /// </summary>
    procedure RebuildColumns;

    function FindItemByFieldName(AFieldName:String):TSkinDBGridColumn;

    property State: TSkinDBGridColumnsState read GetState write SetState;
    property Items[Index: Integer]: TSkinDBGridColumn read GetColumn write SetColumn; default;
  end;


  TSkinDBGridColumnLayoutsManager=TSkinVirtualGridColumnLayoutsManager;





  /// <summary>
  ///   <para>
  ///     书签列表
  ///   </para>
  ///   <para>
  ///     Bookmark List
  ///   </para>
  /// </summary>
  TBookmarkList = class
  private
    FList: array of TBookmark;
    //表格列管理
    FProperties:TDBGridProperties;

    FCache: TBookmark;
    FCacheIndex: Integer;
    FCacheFind: Boolean;

    FLinkActive: Boolean;

    function GetCount: Integer;
    function GetCurrentRowSelected: Boolean;
    function GetItem(Index: Integer): TBookmark;
    procedure InsertItem(Index: Integer; Item: TBookmark);
    procedure DeleteItem(Index: Integer);
    procedure SetCurrentRowSelected(Value: Boolean);
    procedure DataChanged(Sender: TObject);
  protected
    function CurrentRow: TBookmark;
    function Compare(const Item1, Item2: TBookmark): Integer;
    procedure LinkActive(Value: Boolean);
  public
    constructor Create(AProperties:TDBGridProperties);
    destructor Destroy; override;
  public
    procedure Clear;           // free all bookmarks
    procedure Delete;          // delete all selected rows from dataset
    function  Find(const Item: TBookmark; var Index: Integer): Boolean;
    function  IndexOf(const Item: TBookmark): Integer;
    function  Refresh: Boolean;// drop orphaned bookmarks; True = orphans found
    property Count: Integer read GetCount;
    property CurrentRowSelected: Boolean read GetCurrentRowSelected write SetCurrentRowSelected;
    property Items[Index: Integer]: TBookmark read GetItem; default;
  end;





  /// <summary>
  ///   <para>
  ///     表格数据链接
  ///   </para>
  ///   <para>
  ///     Grid data Link
  ///   </para>
  /// </summary>
  TSkinDBGridDataLink = class(TDataLink)
  private

    //字段个数
    FFieldCount: Integer;
    FFieldMap: array of Integer;

    FModified: Boolean;
    FInUpdateData: Boolean;
    FSparseMap: Boolean;

    //单元格管理
    FProperties:TDBGridProperties;

    function GetDefaultFields: Boolean;
    function GetFields(ColIndex: Integer): TField;
  protected
    //数据集打开或关闭(重新生成表格列)
    procedure ActiveChanged; override;
//    procedure BuildAggMap;
    //数据集更改
    procedure DataSetChanged; override;
    //数据集滚动
    procedure DataSetScrolled(Distance: Integer); override;
    //
    procedure FocusControl(Field: TFieldRef); override;
    //编辑状态更改
    procedure EditingChanged; override;
//    //
//    function IsAggRow(Value: Integer): Boolean; virtual;
    //设置表格列
    procedure LayoutChanged; override;
    //
    procedure RecordChanged(Field: TField); override;
    //
    procedure UpdateData; override;
    //获取列下标对应的字段下标
    function GetMappedIndex(ColIndex: Integer): Integer;
  public
    constructor Create(AProperties:TDBGridProperties);
    destructor Destroy; override;
  public
    //添加映射
    function AddMapping(const FieldName: string): Boolean;
    procedure ClearMapping;
  public
    procedure Modified;
//    procedure Reset;
    property DefaultFields: Boolean read GetDefaultFields;
    property FieldCount: Integer read FFieldCount;

    //表格列下标所对应的字段
    property Fields[ColIndex: Integer]: TField read GetFields;
    //稀疏的; 稀少的
    property SparseMap: Boolean read FSparseMap write FSparseMap;
    property Properties:TDBGridProperties read FProperties;
  end;




  { The DBGrid's DrawDataCell virtual method and OnDrawDataCell event are only
    called when the grid's Columns.State is csDefault.  This is for compatibility
    with existing code. These routines don't provide sufficient information to
    determine which column is being drawn, so the column attributes aren't
    easily accessible in these routines.  Column attributes also introduce the
    possibility that a column's field may be nil, which would break existing
    DrawDataCell code.   DrawDataCell, OnDrawDataCell, and DefaultDrawDataCell
    are obsolete, retained for compatibility purposes. }
//  TDrawDataCellEvent = procedure (Sender: TObject; const Rect: TRect; Field: TField;
//    State: TGridDrawState) of object;

  { The DBGrid's DrawColumnCell virtual method and OnDrawColumnCell event are
    always called, when the grid has defined column attributes as well as when
    it is in default mode.  These new routines provide the additional
    information needed to access the column attributes for the cell being
    drawn, and must support nil fields.  }

//  TDrawColumnCellEvent = procedure (Sender: TObject; const Rect: TRect;
//    DataCol: Integer; Column: TSkinDBGridColumn; State: TGridDrawState) of object;
//  TDBGridClickEvent = procedure (Column: TSkinDBGridColumn) of object;






  /// <summary>
  ///   <para>
  ///     表格数据行
  ///   </para>
  ///   <para>
  ///     Grid Row
  ///   </para>
  /// </summary>
  TSkinDBGridRow=class(TSkinVirtualGridRow)
  private
    //数据集的下标
    FRecordIndex: Integer;
  public
//    constructor Create;override;
//    destructor Destroy;override;
    //数据集的下标
    property RecordIndex:Integer read FRecordIndex write FRecordIndex;
  end;

  /// <summary>
  ///   <para>
  ///     表格数据行的列表
  ///   </para>
  ///   <para>
  ///     List of Grid Row
  ///   </para>
  /// </summary>
  TSkinDBGridRows=class(TSkinVirtualGridRows)
  public
    procedure DoAdd(AObject:TObject);override;
  public
    //添加数据行
    function Add:TSkinDBGridRow;overload;
  public
    function GetSkinItemClass:TBaseSkinItemClass;override;
//    //创建列表项
//    function CreateBinaryObject(const AClassName:String=''):TInterfacedPersistent;override;
  end;

  TSkinDBGridRowLayoutsManager=class(TSkinVirtualGridRowLayoutsManager)
  end;







  /// <summary>
  ///   <para>
  ///     数据表格属性
  ///   </para>
  ///   <para>
  ///     Data grid properties
  ///   </para>
  /// </summary>
  TDBGridProperties=class(TVirtualGridProperties)
  protected
    //数据链接
    FDataLink: TSkinDBGridDataLink;


//    FIndicators: TImageList;
//    FTitleFont: TFont;


//    FOriginalImeName: TImeName;
//    FOriginalImeMode: TImeMode;
//    FUserChange: Boolean;
//    FIsESCKey: Boolean;

    //表格列的布局从数据集中加载
    FLayoutFromDataset: Boolean;
//    //选项
//    FOptions: TSkinDBGridOptions;

//    FTitleOffset, FIndicatorOffset: Byte;
    FUpdateLock: Byte;
    FLayoutLock: Byte;
//    FInColExit: Boolean;
//    FDefaultDrawing: Boolean;
//    FSelfChangingTitleFont: Boolean;
//    FSelecting: Boolean;
//    FSelRow: Integer;
//    FDataLink: TSkinDBGridDataLink;
//    FOnColEnter: TNotifyEvent;
//    FOnColExit: TNotifyEvent;
//    FOnDrawDataCell: TDrawDataCellEvent;
//    FOnDrawColumnCell: TDrawColumnCellEvent;
//    FEditText: string;
//    FColumns: TSkinDBGridColumns;
//    FVisibleColumns: TList;
    FSelectedRows: TBookmarkList;
//    FSelectionAnchor: TBookmark;
//    FOnEditButtonClick: TNotifyEvent;
//    FOnColumnMoved: TMovedEvent;
//    FOnCellClick: TDBGridClickEvent;
//    FOnTitleClick:TDBGridClickEvent;
//    FDragCol: TSkinDBGridColumn;
//    function AcquireFocus: Boolean;

    //数据发生更改
    procedure DataChanged;
    procedure EditingChanged;

    function GetDataSource: TDataSource;
    procedure SetDataSource(Value: TDataSource);
//    function GetFieldCount: Integer;
//    function GetFields(FieldIndex: Integer): TField;
//    function GetSelectedField: TField;
//    function GetSelectedIndex: Integer;

    //映射字段和自动生成表格列
    procedure InternalLayout;
//    procedure MoveCol(RawCol, Direction: Integer);
//    function PtInExpandButton(X,Y: Integer; var MasterCol: TSkinDBGridColumn): Boolean;

    procedure RecordChanged(Field: TField);
//    procedure SetIme;
//    procedure SetColumns(Value: TSkinDBGridColumns);overload;
//    procedure SetOptions(Value: TSkinDBGridOptions);
//    procedure SetSelectedField(Value: TField);
//    procedure SetSelectedIndex(Value: Integer);
//    procedure SetTitleFont(Value: TFont);
//    procedure TitleFontChanged(Sender: TObject);

    //把编辑后的数据赋给Field.Text
    procedure UpdateData;

    //更新激活的表格数据行,并滚动到此表格数据行
//    procedure UpdateActive;
//    procedure UpdateIme;

    //更新数据行
    procedure UpdateRowCount;

    //更新统计汇总
    procedure UpdateFooter;

//    procedure CMBiDiModeChanged(var Message: TMessage); message CM_BIDIMODECHANGED;
//    procedure CMExit(var Message: TMessage); message CM_EXIT;
//    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
//    procedure CMParentFontChanged(var Message: TMessage); message CM_PARENTFONTCHANGED;
//    procedure CMDeferLayout(var Message); message cm_DeferLayout;
//    procedure CMDesignHitTest(var Msg: TCMDesignHitTest); message CM_DESIGNHITTEST;
//    procedure WMSetCursor(var Msg: TWMSetCursor); message WM_SETCURSOR;
//    procedure WMSize(var Message: TWMSize); message WM_SIZE;
//    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
//    procedure WMIMEStartComp(var Message: TMessage); message WM_IME_STARTCOMPOSITION;
//    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SetFOCUS;
//    procedure WMKillFocus(var Message: TMessage); message WM_KillFocus;
  protected
//    FUpdateFields: Boolean;
    FAcquireFocus: Boolean;
//    function  RawToDataColumn(ACol: Integer): Integer;
//    function  DataToRawColumn(ACol: Integer): Integer;
    function AcquireLayoutLock: Boolean;
    procedure BeginLayout;
    procedure BeginUpdate;
//    procedure CalcSizingState(X, Y: Integer; var State: TGridState;
//      var Index: Longint; var SizingPos, SizingOfs: Integer;
//      var FixedInfo: TGridDrawInfo); override;
    procedure CancelLayout;
    //映射字段和自动生成表格列
    procedure EndLayout;
    procedure EndUpdate;

//    //单元格是否允许编辑
//    function CanEditCell(ACol:TSkinVirtualGridColumn;
//                            ARow:TBaseSkinItem
//                            ):Boolean;override;

//    function  CanEditAcceptKey(Key: Char): Boolean; override;
//    function  CanEditModify: Boolean; override;
//    function  CanEditShow: Boolean; override;
//    procedure CellClick(Column: TSkinDBGridColumn); dynamic;
//    procedure ColumnMoved(FromIndex, ToIndex: Longint); override;
//    function CalcTitleRect(Col: TSkinDBGridColumn; ARow: Integer;
//      var MasterCol: TSkinDBGridColumn): TRect;
//    function ColumnAtDepth(Col: TSkinDBGridColumn; ADepth: Integer): TSkinDBGridColumn;
//    procedure ColEnter; dynamic;
//    procedure ColExit; dynamic;
//    procedure ColWidthsChanged; override;
//    function  CreateColumns: TSkinDBGridColumns; dynamic;
//    function  CreateEditor: TInplaceEdit; override;


    function  CreateDataLink: TSkinDBGridDataLink; dynamic;
//    procedure CreateWnd; override;
//    procedure DeferLayout;


    procedure DefineFieldMap; virtual;

//    //读取和写入表格列
//    procedure ReadColumns(Reader: TReader);
//    procedure WriteColumns(Writer: TWriter);
//    procedure DefineProperties(Filer: TFiler); override;
//    procedure DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState); override;
//    procedure DrawCellBackground(const ARect: TRect; AColor: TColor;
//      AState: TGridDrawState; ACol, ARow: Integer); override;
//    procedure DrawCellHighlight(const ARect: TRect;
//      AState: TGridDrawState; ACol, ARow: Integer); override;
//    procedure DrawDataCell(const Rect: TRect; Field: TField;
//      State: TGridDrawState); dynamic; { obsolete }
//    procedure DrawColumnCell(const Rect: TRect; DataCol: Integer;
//      Column: TSkinDBGridColumn; State: TGridDrawState); dynamic;
//    procedure EditButtonClick; dynamic;
//    function  GetColField(DataCol: Integer): TField;
//    function  GetEditLimit: Integer; override;
//    function  GetEditMask(ACol, ARow: Longint): string; override;
//    function  GetEditStyle(ACol, ARow: Longint): TEditStyle; override;
//    function  GetEditText(ACol, ARow: Longint): string; override;
//    function  GetFieldValue(ACol: Integer): string;
//    function  HighlightCell(DataCol, DataRow: Integer; const Value: string;
//      AState: TGridDrawState): Boolean; virtual;
//    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
//    procedure KeyPress(var Key: Char); override;
//    procedure InvalidateTitles;

    //映射字段和自动生成表格列
    procedure LayoutChanged; virtual;
    //清除选中的数据行,
    procedure LinkActive(Value: Boolean); virtual;

//    procedure Loaded; override;
//    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
//      X, Y: Integer); override;
//    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
//      X, Y: Integer); override;
//    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
//    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
//    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    //数据集滚动的时候,列表也跟着滚动
    procedure Scroll(Distance: Integer); virtual;

//    procedure SetColumnAttributes; virtual;
//    procedure SetEditText(ACol, ARow: Longint; const Value: string); override;
//    function  StoreColumns: Boolean;
//    procedure TimedScroll(Direction: TGridScrollDirection); override;
//    procedure TitleClick(Column: TSkinDBGridColumn); dynamic;
//    procedure TopLeftChanged; override;
//    procedure UpdateScrollBar; virtual;
//    function UseRightToLeftAlignmentForField(const AField: TField;
//      Alignment: TAlignment): Boolean;
//    function BeginColumnDrag(var Origin, Destination: Integer;
//      const MousePt: TPoint): Boolean; override;
//    function CheckColumnDrag(var Origin, Destination: Integer;
//      const MousePt: TPoint): Boolean; override;
//    function EndColumnDrag(var Origin, Destination: Integer;
//      const MousePt: TPoint): Boolean; override;
//    property Columns: TSkinDBGridColumns read FColumns write SetColumns;
//    property DefaultDrawing: Boolean read FDefaultDrawing write FDefaultDrawing default True;
    property DataLink: TSkinDBGridDataLink read FDataLink;
//    property IndicatorOffset: Byte read FIndicatorOffset;
//    property LayoutLock: Byte read FLayoutLock;
//      default [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines,
//      dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack];
//    property ParentColor default False;
//    property ReadOnly: Boolean read FReadOnly write FReadOnly default False;

    //选中的数据行
    property SelectedRows: TBookmarkList read FSelectedRows;
//    property TitleFont: TFont read FTitleFont write SetTitleFont;
    property UpdateLock: Byte read FUpdateLock;
//    property OnColEnter: TNotifyEvent read FOnColEnter write FOnColEnter;
//    property OnColExit: TNotifyEvent read FOnColExit write FOnColExit;
//    property OnDrawDataCell: TDrawDataCellEvent read FOnDrawDataCell
//      write FOnDrawDataCell; { obsolete }
//    property OnDrawColumnCell: TDrawColumnCellEvent read FOnDrawColumnCell
//      write FOnDrawColumnCell;
//    property OnEditButtonClick: TNotifyEvent read FOnEditButtonClick
//      write FOnEditButtonClick;
//    property OnColumnMoved: TMovedEvent read FOnColumnMoved write FOnColumnMoved;
//    property OnCellClick: TDBGridClickEvent read FOnCellClick write FOnCellClick;
//    property OnTitleClick: TDBGridClickEvent read FOnTitleClick write FOnTitleClick;
  public
//    constructor Create(AOwner: TComponent); override;
//    destructor Destroy; override;
//    procedure DefaultDrawDataCell(const Rect: TRect; Field: TField;
//      State: TGridDrawState); { obsolete }
//    procedure DefaultDrawColumnCell(const Rect: TRect; DataCol: Integer;
//      Column: TSkinDBGridColumn; State: TGridDrawState);
//    procedure DefaultHandler(var Msg); override;
//    function ExecuteAction(Action: TBasicAction): Boolean; override;
//    procedure ShowPopupEditor(Column: TSkinDBGridColumn; X: Integer = Low(Integer);
//      Y: Integer = Low(Integer)); dynamic;
//    function UpdateAction(Action: TBasicAction): Boolean; override;
//    function ValidFieldIndex(FieldIndex: Integer): Boolean;
//    property EditorMode;
//    property FieldCount: Integer read GetFieldCount;
//    property Fields[FieldIndex: Integer]: TField read GetFields;
//    property SelectedField: TField read GetSelectedField write SetSelectedField;
//    property SelectedIndex: Integer read GetSelectedIndex write SetSelectedIndex;
//    property DataSource: TDataSource read GetDataSource write SetDataSource;

  protected
    FSkinDBGridIntf:ISkinDBGrid;

    function GetItems:TSkinDBGridRows;

    function GetColumns: TSkinDBGridColumns;
    procedure SetColumns(const Value: TSkinDBGridColumns);

//    //设置数据源
//    function GetDataSource: TDataSource;
//    procedure SetDataSource(Value: TDataSource);

//    //获取行管理
//    function GetCellValueManager: TDBGridProperties;
  protected
    //获取表格数据行的列表类
    function GetItemsClass:TBaseSkinItemsClass;override;
    //获取表格数据行的列表布局管理者
    function GetCustomListLayoutsManagerClass:TSkinCustomListLayoutsManagerClass;override;

    //创建列管理
    function GetColumnClass:TSkinVirtualGridColumnClass;override;
    function GetColumnsClass:TSkinVirtualGridColumnsClass;override;
    //表格列
    function GetColumnLayoutsManagerClass:TSkinListLayoutsManagerClass;override;
  protected
    //更新统计汇总字段
    procedure UpdateFooterRow;override;
//    //读取和写入表格列
//    procedure ReadColumns(Reader: TReader);
//    procedure WriteColumns(Writer: TWriter);
//    procedure DefineProperties(Filer: TFiler); override;
    //选中行
    procedure DoSetSelectedItem(Value: TBaseSkinItem);override;
  protected
    //赋值
    procedure AssignProperties(Src:TSkinControlProperties);override;
    //获取分类名称
    function GetComponentClassify:String;override;
  public
    constructor Create(ASkinControl:TControl);override;
    destructor Destroy;override;
  public
    //表格数据行
    property Items:TSkinDBGridRows read GetItems;
  public
    //获取指定单元格的文字
    function GetGridCellText(ACol:TSkinVirtualGridColumn;
                            ARow:TBaseSkinItem
                            ):String;override;

    function GetCellValue(ACol:TSkinVirtualGridColumn;
                              ARow:TBaseSkinItem):Variant;override;

    function GetCellValueObject(ACol:TSkinVirtualGridColumn;
                              ARow:TBaseSkinItem):TObject;override;

    //设置单元格的值
    procedure SetGridCellValue(ACol:TSkinVirtualGridColumn;
                            ARow:TBaseSkinItem;
                            AValue:Variant
                            );override;
//    //获取指定单元格是否勾选
//    function GetGridCellChecked(ACol:TSkinVirtualGridColumn;
//                                ARow:TBaseSkinItem
//                                ):Boolean;override;
//    property Options: TSkinDBGridOptions read FOptions write SetOptions;
  published

    /// <summary>
    ///   <para>
    ///     表格列
    ///   </para>
    ///   <para>
    ///     Columns
    ///   </para>
    /// </summary>
    property Columns:TSkinDBGridColumns read GetColumns write SetColumns;

    /// <summary>
    ///   <para>
    ///     数据源
    ///   </para>
    ///   <para>
    ///     Data source
    ///   </para>
    /// </summary>
    property DataSource: TDataSource read GetDataSource write SetDataSource;
  end;




  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinDBGridDefaultMaterial=class(TSkinVirtualGridDefaultMaterial)
  end;

  TSkinDBGridDefaultType=class(TSkinVirtualGridDefaultType)
  protected
    FSkinDBGridIntf:ISkinDBGrid;
  protected
    //绑定对象
    function CustomBind(ASkinControl:TControl):Boolean;override;
    //解除绑定
    procedure CustomUnBind;override;
  protected
    function GetSkinMaterial:TSkinDBGridDefaultMaterial;
//  protected
//    //绘制单元格
//    function CustomPaintCellContent(ACanvas: TDrawCanvas;
//                                        ARowIndex:Integer;
//                                        ARow:TBaseSkinItem;
//                                        ARowDrawRect:TRectF;
//                                        AColumn:TSkinVirtualGridColumn;
//                                        AColumnIndex:Integer;
//                                        ACellDrawRect:TRectF;
//                                        ARowEffectStates:TDPEffectStates;
//                                        ASkinVirtualGridMaterial:TSkinVirtualGridDefaultMaterial;
//                                        ADrawColumnMaterial:TSkinVirtualGridColumnMaterial;
//                                        const ADrawRect: TRectF;
//                                        AVirtualGridPaintData:TPaintData
//                                        ): Boolean;override;
  end;



  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinDBGrid=class(TSkinVirtualGrid,ISkinDBGrid)
  private

    function GetDBGridProperties:TDBGridProperties;
    procedure SetDBGridProperties(Value:TDBGridProperties);
  protected
    //获取控件属性类
    function GetPropertiesClassType:TPropertiesClassType;override;
  public
    function SelfOwnMaterialToDefault:TSkinDBGridDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinDBGridDefaultMaterial;
    function Material:TSkinDBGridDefaultMaterial;
  public
    property Prop:TDBGridProperties read GetDBGridProperties write SetDBGridProperties;
  published
    //属性(必须在VertScrollBar和HorzScrollBar之前)
    property Properties:TDBGridProperties read GetDBGridProperties write SetDBGridProperties;

    //垂直滚动条
    property VertScrollBar;
    //水平滚动条
    property HorzScrollBar;


  end;


  {$IFDEF VCL}
  TSkinWinDBGrid=class(TSkinDBGrid)
  end;
  {$ENDIF VCL}


implementation






{ TDBGridProperties }

constructor TDBGridProperties.Create(ASkinControl:TControl);
begin
  inherited Create(ASkinControl);
  if Not ASkinControl.GetInterface(IID_ISkinDBGrid,Self.FSkinDBGridIntf) then
  begin
    ShowException('This Component Do not Support ISkinDBGrid Interface');
  end
  else
  begin

    Self.Columns.FVirtualGridProperties := Self;

    //  inherited DefaultDrawing := False;
    //  FAcquireFocus := True;
    //  Bmp := TBitmap.Create;
    //  try
    //    Bmp.LoadFromResourceName(HInstance, bmArrow);
    //    FIndicators := TImageList.CreateSize(Bmp.Width, Bmp.Height);
    //    FIndicators.AddMasked(Bmp, clWhite);
    //    Bmp.LoadFromResourceName(HInstance, bmEdit);
    //    FIndicators.AddMasked(Bmp, clWhite);
    //    Bmp.LoadFromResourceName(HInstance, bmInsert);
    //    FIndicators.AddMasked(Bmp, clWhite);
    //    Bmp.LoadFromResourceName(HInstance, bmMultiDot);
    //    FIndicators.AddMasked(Bmp, clWhite);
    //    Bmp.LoadFromResourceName(HInstance, bmMultiArrow);
    //    FIndicators.AddMasked(Bmp, clWhite);
    //  finally
    //    Bmp.Free;
    //  end;
    //  FTitleOffset := 1;
    //  FIndicatorOffset := 1;
    //  FUpdateFields := True;
    //  FOptions := [dgEditing, dgTitles, dgIndicator, dgColumnResize,
    //    dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit,
    //    dgTitleClick, dgTitleHotTrack];
    //  if SysLocale.PriLangID = LANG_KOREAN then
    //    Include(FOptions, dgAlwaysShowEditor);
    //  DesignOptionsBoost := [goColSizing];
    //  VirtualView := True;
    //  UsesBitmap;
    //  ScrollBars := ssHorizontal;
    //  inherited Options := [goFixedHorzLine, goFixedVertLine, goHorzLine,
    //    goVertLine, goColSizing, goColMoving, goTabs, goEditing, goFixedRowClick,
    //    goFixedHotTrack];
    //  FColumns := CreateColumns;
    //  FVisibleColumns := TList.Create;
    //  inherited RowCount := 2;
    //  inherited ColCount := 2;
      FDataLink := CreateDataLink;
      FSelectedRows := TBookmarkList.Create(Self);
    //  FDataLink.BufferCount:=-1;
    //  Color := clWindow;
    //  ParentColor := False;
    //  FTitleFont := TFont.Create;
    //  FTitleFont.OnChange := TitleFontChanged;
    //  FSaveCellExtents := False;
    //  FUserChange := True;
    //  FDefaultDrawing := True;
    //  HideEditor;

  end;
end;

function TDBGridProperties.GetColumnsClass: TSkinVirtualGridColumnsClass;
begin
  Result:=TSkinDBGridColumns;
end;

function TDBGridProperties.GetItemsClass: TBaseSkinItemsClass;
begin
  Result:=TSkinDBGridRows;
end;

function TDBGridProperties.GetCustomListLayoutsManagerClass: TSkinCustomListLayoutsManagerClass;
begin
  Result:=TSkinDBGridRowLayoutsManager;
end;

destructor TDBGridProperties.Destroy;
begin
//  FColumns.Free;
//  FColumns := nil;
//  FVisibleColumns.Free;
//  FVisibleColumns := nil;
  FreeAndNil(FDataLink);
//  FDataLink := nil;
//  FIndicators.Free;
//  FTitleFont.Free;
//  FTitleFont := nil;
  FreeAndNil(FSelectedRows);
//  FSelectedRows := nil;

  inherited;
end;

procedure TDBGridProperties.DoSetSelectedItem(Value: TBaseSkinItem);
begin
  inherited;
  //设置当前记录
  if Self.FItems.IndexOf(Value)<>-1 then
  begin
    Self.FDataLink.ActiveRecord:=Self.FItems.IndexOf(Value);
  end;
end;

function TDBGridProperties.GetCellValue(ACol: TSkinVirtualGridColumn;ARow: TBaseSkinItem): Variant;
var
  OldActive:Integer;
begin
  if (TSkinDBGridRow(ARow).RecordIndex<>-1) then
  begin
      if (TSkinDBGridColumn(ACol).Field<>nil) then
      begin
          //保存原位置
          OldActive := Self.FDataLink.ActiveRecord;
          try
              Self.FDatalink.ActiveRecord := TSkinDBGridRow(ARow).RecordIndex;
              Result:=TSkinDBGridColumn(ACol).Field.Value;
          finally
            Self.FDatalink.ActiveRecord := OldActive;
          end;
      end
      else if (TSkinDBGridColumn(ACol).FieldName='ItemChecked')
          or (TSkinDBGridColumn(ACol).FieldName='ItemSelected') then
      begin
          Result:=ARow.GetValueByBindItemField(TSkinDBGridColumn(ACol).FieldName);
      end;
  end
  else
  begin
    Result:='';
  end;
end;

function TDBGridProperties.GetCellValueObject(ACol: TSkinVirtualGridColumn;
  ARow: TBaseSkinItem): TObject;
begin
  Result:=nil;
end;

function TDBGridProperties.GetColumnClass: TSkinVirtualGridColumnClass;
begin
  Result:=TSkinDBGridColumn;
end;

function TDBGridProperties.GetColumnLayoutsManagerClass: TSkinListLayoutsManagerClass;
begin
  Result:=TSkinDBGridColumnLayoutsManager;
end;

function TDBGridProperties.GetColumns: TSkinDBGridColumns;
begin
  Result:=TSkinDBGridColumns(FColumns);
end;

//function TDBGridProperties.GetCellValueManager: TDBGridProperties;
//begin
//  Result:=TDBGridProperties(FCellValueManager);
//end;

function TDBGridProperties.GetComponentClassify: String;
begin
  Result:='SkinDBGrid';
end;

//function TDBGridProperties.GetDataSource: TDataSource;
//begin
//  Result := CellValueManager.FDataLink.DataSource;
//end;

function TDBGridProperties.GetItems:TSkinDBGridRows;
begin
  Result:=TSkinDBGridRows(FItems);
end;

//function TDBGridProperties.GetGridCellChecked(ACol: TSkinVirtualGridColumn;
//                                              ARow: TBaseSkinItem): Boolean;
//var
//  OldActive:Integer;
//begin
//  if (TSkinDBGridRow(ARow).RecordIndex<>-1) and (TSkinDBGridColumn(ACol).Field<>nil) then
//  begin
//      //保存原位置
//      OldActive := Self.FDataLink.ActiveRecord;
//      try
//        try
//          Self.FDatalink.ActiveRecord := TSkinDBGridRow(ARow).RecordIndex;
//          if VarIsNull(TSkinDBGridColumn(ACol).Field.Value) then
//          begin
//              Result:=False;
//          end
//          else
//          begin
//              Result:=TSkinDBGridColumn(ACol).Field.Value;
//          end;
//        except
//          On E:Exception do
//          begin
//            uBaseLog.OutputDebugString('TDBGridProperties.GetGridCellChecked'+' '+E.Message);
//          end;
//        end;
//
//      finally
//        Self.FDatalink.ActiveRecord := OldActive;
//      end;
//  end
//  else
//  begin
//    Result:=False;
//  end;
//end;

function TDBGridProperties.GetGridCellText(ACol: TSkinVirtualGridColumn;
                                          ARow: TBaseSkinItem
                                          ): String;
var
  OldActive:Integer;
begin
  if (TSkinDBGridRow(ARow).RecordIndex<>-1) and (TSkinDBGridColumn(ACol).Field<>nil) then
  begin
      //保存原位置
      OldActive := Self.FDataLink.ActiveRecord;
      try
        try
            Self.FDatalink.ActiveRecord := TSkinDBGridRow(ARow).RecordIndex;
            Result:=TSkinDBGridColumn(ACol).Field.DisplayText;

            //浮点型
            if (TSkinDBGridColumn(ACol).FValueFormat<>'') then
            begin
              Result:=Format(TSkinDBGridColumn(ACol).FValueFormat,[TSkinDBGridColumn(ACol).Field.AsFloat]);
            end;

            //日期型
            if (TSkinDBGridColumn(ACol).FDateTimeFormat<>'')
              and (
                      (TSkinDBGridColumn(ACol).Field.DataType=TFieldType.ftDate)
                   or (TSkinDBGridColumn(ACol).Field.DataType=TFieldType.ftDateTime)
                   or (TSkinDBGridColumn(ACol).Field.DataType=TFieldType.ftTimeStamp)
                  ) then
            begin
              Result:=FormatDateTime(TSkinDBGridColumn(ACol).FDateTimeFormat,TSkinDBGridColumn(ACol).Field.AsDateTime);
            end;


            //从自定义的过程中获取
            if Assigned(Self.FSkinVirtualGridIntf.OnGetCellDisplayText) then
            begin
              Self.FSkinVirtualGridIntf.OnGetCellDisplayText(Self,
                                                          ACol,
                                                          ARow,
  //                                                        AVisibleColIndex,AVisibleRowIndex,
                                                          Result);
            end;

        except
          On E:Exception do
          begin
            uBaseLog.OutputDebugString('TDBGridProperties.GetGridCellText'+' '+E.Message);
          end;
        end;


      finally
        Self.FDatalink.ActiveRecord := OldActive;
      end;
  end
  else
  begin
      Result:='';
  end;

end;

procedure TDBGridProperties.SetColumns(const Value: TSkinDBGridColumns);
begin
  FColumns.Assign(Value);
end;

//procedure TDBGridProperties.SetDataSource(Value: TDataSource);
//begin
//  if Value <> CellValueManager.FDataLink.DataSource then
//  begin
//    //  if Assigned(Value) then
//    //    if Assigned(Value.DataSet) then
//    //      if Value.DataSet.IsUnidirectional then
//    //        DatabaseError(SDataSetUnidirectional);
//    //  FSelectedRows.Clear;
//
//    CellValueManager.FDataLink.DataSource := Value;
//
////      if Value <> nil then Value.FreeNotification(Self);
//  end;
//end;

procedure TDBGridProperties.UpdateFooterRow;
begin
  Self.UpdateFooter;
  Inherited;
end;

//procedure TDBGridProperties.ReadColumns(Reader: TReader);
//begin
//  Columns.Clear;
//  Reader.ReadValue;
//  Reader.ReadCollection(Columns);
//end;
//
//procedure TDBGridProperties.WriteColumns(Writer: TWriter);
//begin
//  if Columns.State = csCustomized then
//    Writer.WriteCollection(Columns)
//  else  // ancestor state is customized, ours is not
//    Writer.WriteCollection(nil);
//end;

//procedure TDBGridProperties.DefineProperties(Filer: TFiler);
//var
//  StoreIt: Boolean;
//  vState: TSkinDBGridColumnsState;
//begin
//  vState := Columns.State;
//  if Filer.Ancestor = nil then
//  begin
//    StoreIt := vState = csCustomized;
//  end
//  else
//  begin
//    if vState <> TDBGridProperties(Filer.Ancestor).Columns.State then
//    begin
//      StoreIt := True;
//    end
//    else
//    begin
//      StoreIt := (vState = csCustomized) and
//        (not CollectionsEqual(Columns,
//                              TDBGridProperties(Filer.Ancestor).Columns,
//
//                              Self.FSkinControl,
//                              TDBGridProperties(Filer.Ancestor).FSkinControl
//                              )
//        );
//    end;
//  end;
//  Filer.DefineProperty('Columns', ReadColumns, WriteColumns, StoreIt);
//end;

procedure TDBGridProperties.AssignProperties(Src: TSkinControlProperties);
begin
  inherited;
end;


{ TSkinDBGridDefaultType }


function TSkinDBGridDefaultType.CustomBind(ASkinControl:TControl):Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinDBGrid,Self.FSkinDBGridIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinDBGrid Interface');
    end;
  end;
end;

procedure TSkinDBGridDefaultType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinDBGridIntf:=nil;
end;

function TSkinDBGridDefaultType.GetSkinMaterial: TSkinDBGridDefaultMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinDBGridDefaultMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;

//function TSkinDBGridDefaultType.CustomPaintCellContent(
//                                    ACanvas: TDrawCanvas;
//                                    ARowIndex:Integer;
//                                    ARow:TBaseSkinItem;
//                                    ARowDrawRect:TRectF;
//                                    AColumn:TSkinVirtualGridColumn;
//                                    AColumnIndex:Integer;
//                                    ACellDrawRect:TRectF;
//                                    ARowEffectStates:TDPEffectStates;
//                                    ASkinVirtualGridMaterial:TSkinVirtualGridDefaultMaterial;
//                                    ADrawColumnMaterial:TSkinVirtualGridColumnMaterial;
//                                    const ADrawRect: TRectF;
//                                    AVirtualGridPaintData:TPaintData
//                                    ): Boolean;
////var
////  ADBGridRow:TSkinDBGridRow;
////  ADBGridColumn:TSkinDBGridColumn;
////var
////  ADisplayText:String;
//begin
//  Inherited;
////  ADBGridRow:=TSkinDBGridRow(ARow);
////  ADBGridColumn:=TSkinDBGridColumn(AColumn);
////
////  if ADrawColumnMaterial<>nil then
////  begin
////      ADrawColumnMaterial.DrawCellTextParam.StaticEffectStates:=ARowEffectStates;
////
////      //获取单元格内容
////      ADisplayText:=Self.FSkinDBGridIntf.Prop.GetGridCellText(
////                  AColumn,
////                  ARow);
////      ACanvas.DrawText(ADrawColumnMaterial.DrawCellTextParam,ADisplayText,ACellDrawRect);
////
////      //如果是图片
////
////
////      //如果是绑定的设计面板
////
////
////  end;
//
//end;


{ TSkinDBGridDefaultMaterial }


//constructor TSkinDBGridDefaultMaterial.Create(AOwner: TComponent);
//begin
//  inherited Create(AOwner);
//
//end;
//
//function TSkinDBGridDefaultMaterial.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
////var
////  I: Integer;
////  ABTNode:TBTNode20;
//begin
//  Result:=False;
//
//  Inherited LoadFromDocNode(ADocNode);
//
////  for I := 0 to ADocNode.ChildNodes.Count - 1 do
////  begin
////    ABTNode:=ADocNode.ChildNodes[I];
////    if ABTNode.NodeName='DrawItemCaptionParam' then
////    begin
////      FDrawItemCaptionParam.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end;
////  end;
//
//  Result:=True;
//end;
//
//function TSkinDBGridDefaultMaterial.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
////var
////  ABTNode:TBTNode20;
//begin
//  Result:=False;
//
//  Inherited SaveToDocNode(ADocNode);
//
////  ABTNode:=ADocNode.AddChildNode_Class('DrawItemCaptionParam',FDrawItemCaptionParam.Name);
////  Self.FDrawItemCaptionParam.SaveToDocNode(ABTNode.ConvertNode_Class);
//
//  Result:=True;
//end;
//
//destructor TSkinDBGridDefaultMaterial.Destroy;
//begin
//  inherited;
//end;
//



{ TSkinDBGridDataLink }


constructor TSkinDBGridDataLink.Create(AProperties:TDBGridProperties);
begin
  inherited Create;
  FProperties:=AProperties;
end;

destructor TSkinDBGridDataLink.Destroy;
begin
  ClearMapping;
  inherited Destroy;
end;

function TSkinDBGridDataLink.GetDefaultFields: Boolean;
var
  I: Integer;
begin
  Result := True;
  if DataSet <> nil then
  begin
    Result := Self.FProperties.FDataLink.DataSet.DefaultFields;
  end;

  if Result and SparseMap then
  begin
    for I := 0 to FFieldCount-1 do
    begin
      if FFieldMap[I] < 0 then
      begin
        Result := False;
        Exit;
      end;
    end;
  end;
end;

function TSkinDBGridDataLink.GetFields(ColIndex: Integer): TField;
begin
  if (0 <= ColIndex) and (ColIndex < FFieldCount) and (FFieldMap[ColIndex] >= 0) then
  begin
    Result := DataSet.FieldList[FFieldMap[ColIndex]];
  end
  else
  begin
    Result := nil;
  end;
end;

function TSkinDBGridDataLink.AddMapping(const FieldName: string): Boolean;
var
  Field: TField;
  NewSize: Integer;
begin
  Result := True;

  if FFieldCount >= MaxMapSize then
  begin
    Raise EInvalidGridOperation.Create(STooManyColumns);
  end;

  if SparseMap then
    Field := DataSet.FindField(FieldName)
  else
    Field := DataSet.FieldByName(FieldName);


  if FFieldCount = Length(FFieldMap) then
  begin
    NewSize := Length(FFieldMap);
    if NewSize = 0 then
    begin
      //初始为8
      NewSize := 8;
    end
    else
    begin
      //*2
      Inc(NewSize, NewSize);
    end;
    if (NewSize < FFieldCount) then
    begin
      NewSize := FFieldCount + 1;
    end;
    if (NewSize > MaxMapSize) then
    begin
      NewSize := MaxMapSize;
    end;

    SetLength(FFieldMap, NewSize);
  end;

  if Assigned(Field) then
  begin
    //存放FieldName,Index
    FFieldMap[FFieldCount] := Dataset.FieldList.IndexOfObject(Field);
//    Field.FreeNotification(FProperties);
  end
  else
  begin
    FFieldMap[FFieldCount] := -1;
  end;
  Inc(FFieldCount);
end;

procedure TSkinDBGridDataLink.ActiveChanged;
begin
  uBaseLog.OutputDebugString('TSkinDBGridDataLink.ActiveChanged 数据集状态更改');


  if Active and Assigned(DataSource) then
  begin
    if Assigned(DataSource.DataSet) then
    begin
      if DataSource.DataSet.IsUnidirectional then
      begin
        DatabaseError(SDataSetUnidirectional);
      end;
    end;
  end;

  Self.FProperties.LinkActive(Active);

  FModified := False;
end;

procedure TSkinDBGridDataLink.ClearMapping;
begin
  FFieldMap := nil;
  FFieldCount := 0;
end;

procedure TSkinDBGridDataLink.Modified;
begin
  FModified := True;
end;

procedure TSkinDBGridDataLink.DataSetChanged;
begin
  uBaseLog.OutputDebugString('TSkinDBGridDataLink.DataSetChanged');

  Self.FProperties.DataChanged;
  FModified := False;
end;

procedure TSkinDBGridDataLink.DataSetScrolled(Distance: Integer);
begin
  uBaseLog.OutputDebugString('TSkinDBGridDataLink.DataSetScrolled Distance='+IntToStr(Distance));

  //数据集滚动
  FProperties.Scroll(Distance);


end;

procedure TSkinDBGridDataLink.LayoutChanged;
var
  SaveState: Boolean;
begin
  uBaseLog.OutputDebugString('TSkinDBGridDataLink.LayoutChanged');


  { FLayoutFromDataset determines whether default column width is forced to
    be at least wide enough for the column title.  }
  SaveState := FProperties.FLayoutFromDataset;
  FProperties.FLayoutFromDataset := True;
  try
    FProperties.LayoutChanged;
  finally
    FProperties.FLayoutFromDataset := SaveState;
  end;
  inherited LayoutChanged;
end;

procedure TSkinDBGridDataLink.FocusControl(Field: TFieldRef);
begin
  uBaseLog.OutputDebugString('TSkinDBGridDataLink.FocusControl');

  //  if Assigned(Field) and Assigned(Field^) then
//  begin
//    FProperties.SelectedField := Field^;
//    if (FProperties.SelectedField = Field^) and FProperties.AcquireFocus then
//    begin
//      Field^ := nil;
//      FProperties.ShowEditor;
//    end;
//  end;
end;

procedure TSkinDBGridDataLink.EditingChanged;
begin
  uBaseLog.OutputDebugString('TSkinDBGridDataLink.EditingChanged');

  Self.FProperties.EditingChanged;
end;

procedure TSkinDBGridDataLink.RecordChanged(Field: TField);
begin
  uBaseLog.OutputDebugString('TSkinDBGridDataLink.RecordChanged');

  // If we get called with a field that is not the selected field
  // and the selected field is modified we need force it to be updated first.
//  if FModified and Assigned(Field) and (Field.FieldKind = fkData)
//    and (FProperties.SelectedField <> Field)
//    and not FInUpdateData then
//  begin
//    UpdateData;
//  end;
  FProperties.RecordChanged(Field);
  FModified := False;
end;

procedure TSkinDBGridDataLink.UpdateData;
begin
  uBaseLog.OutputDebugString('TSkinDBGridDataLink.UpdateData');


  FInUpdateData := True;
  try
    if FModified then
    begin
      FProperties.UpdateData;
    end;
    FModified := False;
  finally
    FInUpdateData := False;
  end;
end;

function TSkinDBGridDataLink.GetMappedIndex(ColIndex: Integer): Integer;
begin
  if (0 <= ColIndex) and (ColIndex < FFieldCount) then
  begin
    Result := FFieldMap[ColIndex];
  end
  else
  begin
    Result := -1;
  end;
end;

//procedure TSkinDBGridDataLink.Reset;
//begin
//  if FModified then RecordChanged(nil) else Dataset.Cancel;
//end;
//
//function TSkinDBGridDataLink.IsAggRow(Value: Integer): Boolean;
//begin
//  Result := False;
//end;
//
//procedure TSkinDBGridDataLink.BuildAggMap;
//begin
//end;




{ TDBGridProperties }

//var
//  DrawBitmap: TBitmap;
//  UserCount: Integer;

function TDBGridProperties.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TDBGridProperties.SetDataSource(Value: TDataSource);
begin
  if Value = FDatalink.Datasource then Exit;


  if Assigned(Value) then
    if Assigned(Value.DataSet) then
      if Value.DataSet.IsUnidirectional then
        DatabaseError(SDataSetUnidirectional);


  FSelectedRows.Clear;


  FDataLink.DataSource := Value;


  //存在数据集
  if (Value<>nil)
    and (Value.DataSet<>nil) then
  begin
    //更新表格列
    Self.LinkActive(Value.DataSet.Active);
  end;


  //更新数据行
  Self.UpdateRowCount;

//  if Value <> nil then Value.FreeNotification(Self);
end;

procedure TDBGridProperties.SetGridCellValue(
        ACol: TSkinVirtualGridColumn;
        ARow: TBaseSkinItem;
        AValue:Variant);
var
  OldActive:Integer;
begin
  //保存字段的值
  if (TSkinDBGridRow(ARow).RecordIndex<>-1) then
  begin
      if (TSkinDBGridColumn(ACol).Field<>nil) then
      begin
          //保存原位置
          OldActive := Self.FDataLink.ActiveRecord;
          try

              try
                Self.FDatalink.ActiveRecord := TSkinDBGridRow(ARow).RecordIndex;
                Self.DataSource.DataSet.Edit;
                TSkinDBGridColumn(ACol).Field.Value:=AValue;
                Self.DataSource.DataSet.Post;
              except
                On E:Exception do
                begin
                  uBaseLog.OutputDebugString('TDBGridProperties.GetGridCellText'+' '+E.Message);
                end;
              end;

          finally
            Self.FDatalink.ActiveRecord := OldActive;
          end;
      end
      else if (TSkinDBGridColumn(ACol).FieldName='ItemChecked') then
      begin
          ARow.SetValueByBindItemField(TSkinDBGridColumn(ACol).FieldName,AValue);
      end;
  end;
end;

procedure TDBGridProperties.LinkActive(Value: Boolean);
//var
//  I: Integer;
//  Comp: TComponent;
begin
//  if not Value then HideEditor;

  FSelectedRows.LinkActive(Value);
  try
      //重新生成表格列并绑定
      LayoutChanged;
  finally
//    for I := ComponentCount-1 downto 0 do
//    begin
//      Comp := Components[I];   // Free all the popped-up subgrids
//      if (Comp is TDBGridProperties)
//        and (TDBGridProperties(Comp).DragKind = dkDock) then
//        Comp.Free;
//    end;
//    UpdateScrollBar;
//    if Value and (dgAlwaysShowEditor in Options) then ShowEditor;
  end;
end;

//function TDBGridProperties.GetGridCellText(ACol:TSkinVirtualGridColumn;ARow:TSkinVirtualGridRow;AVisibleColIndex:Integer;AVisibleRowIndex: Integer): String;
//var
//  OldActive:Integer;
//begin
//  if (TSkinDBGridRow(ARow).RecordIndex<>-1) and (TSkinDBGridColumn(ACol).Field<>nil) then
//  begin
//      OldActive := FDataLink.ActiveRecord;
//      try
//        try
//          FDatalink.ActiveRecord := TSkinDBGridRow(ARow).RecordIndex;
//          Result:=TSkinDBGridColumn(ACol).Field.DisplayText;
//
//
//          if Assigned(Self.FSkinVirtualGridIntf.OnGetCellDisplayText) then
//          begin
//            Self.FSkinVirtualGridIntf.OnGetCellDisplayText(Self,AColumn,ARow,AVisibleColumnIndex,AVisibleRowIndex,ADisplayText);
//          end;
//
//        except
//          On E:Exception do
//          begin
//            uBaseLog.OutputDebugString(E.Message);
//          end;
//        end;
//
//
//      finally
//        FDatalink.ActiveRecord := OldActive;
//      end;
//  end
//  else
//  begin
//    Result:='';
//  end;
//end;
//
//function TDBGridProperties.GetRows: TSkinDBGridRows;
//begin
//  Result:=TSkinDBGridRows(FRows);
//end;
//
//procedure UsesBitmap;
//begin
//  if UserCount = 0 then
//    DrawBitmap := TBitmap.Create;
//  Inc(UserCount);
//end;
//
//procedure ReleaseBitmap;
//begin
//  Dec(UserCount);
//  if UserCount = 0 then DrawBitmap.Free;
//end;
//
//procedure WriteText(ACanvas: TCanvas; ARect: TRect; DX, DY: Integer;
//  const Text: string; Alignment: TAlignment; ARightToLeft: Boolean);
//const
//  AlignFlags : array [TAlignment] of Integer =
//    ( DT_LEFT or DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX,
//      DT_RIGHT or DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX,
//      DT_CENTER or DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX );
//  RTL: array [Boolean] of Integer = (0, DT_RTLREADING);
//var
//  B, R: TRect;
//  Hold, Left: Integer;
//  I: TColorRef;
//begin
//  I := ColorToRGB(ACanvas.Brush.Color);
//  if GetNearestColor(ACanvas.Handle, I) = I then
//  begin                       { Use ExtTextOut for solid colors }
//    { In BiDi, because we changed the window origin, the text that does not
//      change alignment, actually gets its alignment changed. }
//    if (ACanvas.CanvasOrientation = coRightToLeft) and (not ARightToLeft) then
//      ChangeBiDiModeAlignment(Alignment);
//    case Alignment of
//      taLeftJustify:
//        Left := ARect.Left + DX;
//      taRightJustify:
//        Left := ARect.Right - ACanvas.TextWidth(Text) - 3;
//    else { taCenter }
//      Left := ARect.Left + (ARect.Right - ARect.Left) shr 1
//        - (ACanvas.TextWidth(Text) shr 1);
//    end;
//    ACanvas.TextRect(ARect, Left, ARect.Top + DY, Text);
//  end
//  else begin                  { Use FillRect and Drawtext for dithered colors }
//    DrawBitmap.Canvas.Lock;
//    try
//      with DrawBitmap, ARect do { Use offscreen bitmap to eliminate flicker and }
//      begin                     { brush origin tics in painting / scrolling.    }
//        Width := Max(Width, Right - Left);
//        Height := Max(Height, Bottom - Top);
//        R := Rect(DX, DY, Right - Left - 1, Bottom - Top - 1);
//        B := Rect(0, 0, Right - Left, Bottom - Top);
//      end;
//      with DrawBitmap.Canvas do
//      begin
//        Font := ACanvas.Font;
//        Font.Color := ACanvas.Font.Color;
//        Brush := ACanvas.Brush;
//        Brush.Style := bsSolid;
//        FillRect(B);
//        SetBkMode(Handle, TRANSPARENT);
//        if (ACanvas.CanvasOrientation = coRightToLeft) then
//          ChangeBiDiModeAlignment(Alignment);
//        DrawText(Handle, PChar(Text), Length(Text), R,
//          AlignFlags[Alignment] or RTL[ARightToLeft]);
//      end;
//      if (ACanvas.CanvasOrientation = coRightToLeft) then
//      begin
//        Hold := ARect.Left;
//        ARect.Left := ARect.Right;
//        ARect.Right := Hold;
//      end;
//      ACanvas.CopyRect(ARect, DrawBitmap.Canvas, B);
//    finally
//      DrawBitmap.Canvas.Unlock;
//    end;
//  end;
//end;
//
//constructor TDBGridProperties.Create(AColumns:TSkinVirtualGridColumns;ARows:TBaseSkinItems);//(AOwner: TComponent);
////var
////  Bmp: TBitmap;
//begin
//  inherited Create(AColumns,ARows);//(AOwner);
////  inherited DefaultDrawing := False;
////  FAcquireFocus := True;
////  Bmp := TBitmap.Create;
////  try
////    Bmp.LoadFromResourceName(HInstance, bmArrow);
////    FIndicators := TImageList.CreateSize(Bmp.Width, Bmp.Height);
////    FIndicators.AddMasked(Bmp, clWhite);
////    Bmp.LoadFromResourceName(HInstance, bmEdit);
////    FIndicators.AddMasked(Bmp, clWhite);
////    Bmp.LoadFromResourceName(HInstance, bmInsert);
////    FIndicators.AddMasked(Bmp, clWhite);
////    Bmp.LoadFromResourceName(HInstance, bmMultiDot);
////    FIndicators.AddMasked(Bmp, clWhite);
////    Bmp.LoadFromResourceName(HInstance, bmMultiArrow);
////    FIndicators.AddMasked(Bmp, clWhite);
////  finally
////    Bmp.Free;
////  end;
////  FTitleOffset := 1;
////  FIndicatorOffset := 1;
////  FUpdateFields := True;
////  FOptions := [dgEditing, dgTitles, dgIndicator, dgColumnResize,
////    dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit,
////    dgTitleClick, dgTitleHotTrack];
////  if SysLocale.PriLangID = LANG_KOREAN then
////    Include(FOptions, dgAlwaysShowEditor);
////  DesignOptionsBoost := [goColSizing];
////  VirtualView := True;
////  UsesBitmap;
////  ScrollBars := ssHorizontal;
////  inherited Options := [goFixedHorzLine, goFixedVertLine, goHorzLine,
////    goVertLine, goColSizing, goColMoving, goTabs, goEditing, goFixedRowClick,
////    goFixedHotTrack];
////  FColumns := CreateColumns;
////  FVisibleColumns := TList.Create;
////  inherited RowCount := 2;
////  inherited ColCount := 2;
//  FDataLink := CreateDataLink;
//  FSelectedRows := TBookmarkList.Create(Self);
////  FDataLink.BufferCount:=-1;
////  Color := clWindow;
////  ParentColor := False;
////  FTitleFont := TFont.Create;
////  FTitleFont.OnChange := TitleFontChanged;
////  FSaveCellExtents := False;
////  FUserChange := True;
////  FDefaultDrawing := True;
////  HideEditor;
//end;
//
//destructor TDBGridProperties.Destroy;
//begin
////  FColumns.Free;
////  FColumns := nil;
////  FVisibleColumns.Free;
////  FVisibleColumns := nil;
//  FreeAndNil(FDataLink);
////  FDataLink := nil;
////  FIndicators.Free;
////  FTitleFont.Free;
////  FTitleFont := nil;
//  FreeAndNil(FSelectedRows);
////  FSelectedRows := nil;
//  inherited Destroy;
////  ReleaseBitmap;
//end;

//function TDBGridProperties.AcquireFocus: Boolean;
//begin
//  Result := True;
//  if FAcquireFocus and CanFocus and not (csDesigning in ComponentState) then
//  begin
//    SetFocus;
//    Result := Focused or (InplaceEditor <> nil) and InplaceEditor.Focused;
//  end;
//end;
////根据表格列下标转换成真实的下标
//function TDBGridProperties.RawToDataColumn(ACol: Integer): Integer;
//begin
//  Result := ACol - FIndicatorOffset;
//end;
//
//function TDBGridProperties.DataToRawColumn(ACol: Integer): Integer;
//begin
//  Result := ACol + FIndicatorOffset;
//end;

function TDBGridProperties.AcquireLayoutLock: Boolean;
begin
  Result := (FUpdateLock = 0) and (FLayoutLock = 0);
  if Result then BeginLayout;
end;

procedure TDBGridProperties.BeginLayout;
begin
  uBaseLog.OutputDebugString('TDBGridProperties.BeginLayout');

  BeginUpdate;
  if FLayoutLock = 0 then FColumns.BeginUpdate;
  Inc(FLayoutLock);
end;

procedure TDBGridProperties.BeginUpdate;
begin
  Inc(FUpdateLock);
end;

procedure TDBGridProperties.CancelLayout;
begin
  if FLayoutLock > 0 then
  begin
    if FLayoutLock = 1 then
    begin
      Columns.EndUpdate;
    end;
    Dec(FLayoutLock);
    EndUpdate;
  end;
end;

//function TDBGridProperties.CanEditCell(ACol: TSkinVirtualGridColumn;
//  ARow: TBaseSkinItem): Boolean;
//begin
//  Result:=Inherited CanEditCell(ACol,ARow);
//end;

//function TDBGridProperties.CanEditAcceptKey(Key: Char): Boolean;
//begin
//  with Columns[SelectedIndex] do
//    Result := FDatalink.Active and Assigned(Field) and Field.IsValidChar(Key);
//end;
//
//function TDBGridProperties.CanEditModify: Boolean;
//begin
//  Result := False;
//  if not ReadOnly and FDatalink.Active and not FDatalink.Readonly then
//  with Columns[SelectedIndex] do
//    if (not ReadOnly) and Assigned(Field) and Field.CanModify
//      and (not (Field.DataType in ftNonTextTypes) or Assigned(Field.OnSetText)) then
//    begin
//      FDatalink.Edit;
//      Result := FDatalink.Editing;
//      if Result then FDatalink.Modified;
//    end;
//end;
//
//function TDBGridProperties.CanEditShow: Boolean;
//begin
//  Result := (LayoutLock = 0) and inherited CanEditShow;
//end;

//procedure TDBGridProperties.CellClick(Column: TSkinDBGridColumn);
//begin
//  if Assigned(FOnCellClick) then FOnCellClick(Column);
//end;

//procedure TDBGridProperties.ColEnter;
//begin
//  UpdateIme;
//  if Assigned(FOnColEnter) then FOnColEnter(Self);
//end;
//
//procedure TDBGridProperties.ColExit;
//begin
//  if Assigned(FOnColExit) then FOnColExit(Self);
//end;

//procedure TDBGridProperties.ColumnMoved(FromIndex, ToIndex: Longint);
//begin
//  FromIndex := RawToDataColumn(FromIndex);
//  ToIndex := RawToDataColumn(ToIndex);
//  Columns[FromIndex].Index := ToIndex;
//  if Assigned(FOnColumnMoved) then FOnColumnMoved(Self, FromIndex, ToIndex);
//end;
//
//procedure TDBGridProperties.ColWidthsChanged;
//var
//  I: Integer;
//begin
//  inherited ColWidthsChanged;
//  if (FDatalink.Active or (FColumns.State = csCustomized)) and
//    AcquireLayoutLock then
//  try
//    for I := FIndicatorOffset to ColCount - 1 do
//      FColumns[I - FIndicatorOffset].Width := ColWidths[I];
//  finally
//    EndLayout;
//  end;
//end;
//
//function TDBGridProperties.CreateColumns: TSkinDBGridColumns;
//begin
//  Result := TSkinDBGridColumns.Create(Self, TSkinDBGridColumn);
//end;

function TDBGridProperties.CreateDataLink: TSkinDBGridDataLink;
begin
  Result := TSkinDBGridDataLink.Create(Self);
end;

//function TDBGridProperties.CreateEditor: TInplaceEdit;
//begin
//  Result := TDBGridInplaceEdit.Create(Self);
//end;
//
//procedure TDBGridProperties.CreateWnd;
//begin
//  BeginUpdate;   { prevent updates in WMSize message that follows WMCreate }
//  try
//    inherited CreateWnd;
//  finally
//    EndUpdate;
//  end;
//  UpdateRowCount;
//  UpdateActive;
//  UpdateScrollBar;
////  FOriginalImeName := ImeName;
////  FOriginalImeMode := ImeMode;
//end;

procedure TDBGridProperties.DataChanged;
begin
//  if not HandleAllocated then Exit;
  uBaseLog.OutputDebugString('TDBGridProperties.DataChanged');

  //数据更改而已
  UpdateRowCount;

//  UpdateScrollBar;
//  UpdateActive;
//  InvalidateEditor;
//  ValidateRect(Handle, nil);
//  Invalidate;
end;

//procedure TDBGridProperties.DefaultHandler(var Msg);
//var
//  P: TPopupMenu;
//  Cell: TGridCoord;
//begin
//  inherited DefaultHandler(Msg);
//  if TMessage(Msg).Msg = wm_RButtonUp then
//    with TWMRButtonUp(Msg) do
//    begin
//      Cell := MouseCoord(XPos, YPos);
//      if (Cell.X < FIndicatorOffset) or (Cell.Y < 0) then Exit;
//      P := Columns[RawToDataColumn(Cell.X)].PopupMenu;
//      if (P <> nil) and P.AutoPopup then
//      begin
//        SendCancelMode(nil);
//        P.PopupComponent := Self;
//        with ClientToScreen(SmallPointToPoint(Pos)) do
//          P.Popup(X, Y);
//        Result := 1;
//      end;
//    end;
//end;
//
//procedure TDBGridProperties.DeferLayout;
//var
//  M: TMsg;
//begin
//  if HandleAllocated and
//    not PeekMessage(M, Handle, cm_DeferLayout, cm_DeferLayout, pm_NoRemove) then
//    PostMessage(Handle, cm_DeferLayout, 0, 0);
//  CancelLayout;
//end;

procedure TDBGridProperties.DefineFieldMap;
var
  I: Integer;
begin
  if Columns.State = csCustomized then
  begin

      //如果是自定义的表格列
      { Build the column/field map from the column attributes }
      DataLink.SparseMap := True;
      for I := 0 to FColumns.Count-1 do
      begin
        FDataLink.AddMapping(Columns[I].FieldName);
      end;

  end
  else
  begin

      //如果是自动生成的表格列
      //那么需要全部映射
      //{ Build the column/field map from the field list order }
      FDataLink.SparseMap := False;
  //    with Datalink.Dataset do
        for I := 0 to FDatalink.Dataset.FieldList.Count - 1 do
        begin
  //        with FDatalink.Dataset.FieldList[I] do
          if FDatalink.Dataset.FieldList[I].Visible then
          begin
            Datalink.AddMapping(FDatalink.Dataset.FieldList[I].FullName);
          end;
        end;
  end;
end;

//function TDBGridProperties.UseRightToLeftAlignmentForField(const AField: TField;
//  Alignment: TAlignment): Boolean;
//begin
//  Result := False;
//  if IsRightToLeft then
//    Result := OkToChangeFieldAlignment(AField, Alignment);
//end;
////默认绘制单元格文本
//procedure TDBGridProperties.DefaultDrawDataCell(const Rect: TRect; Field: TField;
//  State: TGridDrawState);
//var
//  Alignment: TAlignment;
//  Value: string;
//begin
//  Alignment := taLeftJustify;
//  Value := '';
//  if Assigned(Field) then
//  begin
//    Alignment := Field.Alignment;
//    Value := Field.DisplayText;
//  end;
//  WriteText(Canvas, Rect, 2, 2, Value, Alignment,
//    UseRightToLeftAlignmentForField(Field, Alignment));
//end;
////默认绘制表格列
//procedure TDBGridProperties.DefaultDrawColumnCell(const Rect: TRect;
//  DataCol: Integer; Column: TSkinDBGridColumn; State: TGridDrawState);
//var
//  Value: string;
//begin
//  Value := '';
//  if Assigned(Column.Field) then
//    Value := Column.Field.DisplayText;
//  WriteText(Canvas, Rect, 2, 2, Value, Column.Alignment,
//    UseRightToLeftAlignmentForField(Column.Field, Column.Alignment));
//end;
//
//procedure TDBGridProperties.ReadColumns(Reader: TReader);
//begin
//  Columns.Clear;
//  Reader.ReadValue;
//  Reader.ReadCollection(Columns);
//end;
//
//procedure TDBGridProperties.WriteColumns(Writer: TWriter);
//begin
//  if Columns.State = csCustomized then
//    Writer.WriteCollection(Columns)
//  else  // ancestor state is customized, ours is not
//    Writer.WriteCollection(nil);
//end;
////
//procedure TDBGridProperties.DefineProperties(Filer: TFiler);
//var
//  StoreIt: Boolean;
//  vState: TSkinDBGridColumnsState;
//begin
//  vState := Columns.State;
//  if Filer.Ancestor = nil then
//  begin
//    StoreIt := vState = csCustomized;
//  end
//  else
//  begin
//    if vState <> TDBGridProperties(Filer.Ancestor).Columns.State then
//    begin
//      StoreIt := True;
//    end
//    else
//    begin
//      StoreIt := (vState = csCustomized) and
//        (not CollectionsEqual(Columns, TDBGridProperties(Filer.Ancestor).Columns, Self, TDBGridProperties(Filer.Ancestor)));
//    end;
//  end;
//  Filer.DefineProperty('Columns', ReadColumns, WriteColumns, StoreIt);
//end;
//
//function TDBGridProperties.ColumnAtDepth(Col: TSkinDBGridColumn; ADepth: Integer): TSkinDBGridColumn;
//begin
//  Result := Col;
//  while (Result <> nil) and (Result.Depth > ADepth) do
//    Result := Result.ParentColumn;
//end;
//
//function TDBGridProperties.CalcTitleRect(Col: TSkinDBGridColumn; ARow: Integer;
//  var MasterCol: TSkinDBGridColumn): TRect;
//var
//  I,J: Integer;
//  InBiDiMode: Boolean;
//  DrawInfo: TGridDrawInfo;
//begin
//  MasterCol := ColumnAtDepth(Col, ARow);
//  if MasterCol = nil then Exit;
//
//  I := DataToRawColumn(MasterCol.Index);
//  if I >= LeftCol then
//    J := MasterCol.Depth
//  else
//  begin
//    I := LeftCol;
//    if Col.Depth > ARow then
//      J := ARow
//    else
//      J := Col.Depth;
//  end;
//
//  Result := CellRect(I, J);
//
//  InBiDiMode := UseRightToLeftAlignment and
//                (Canvas.CanvasOrientation = coLeftToRight);
//
//  for I := Col.Index to Columns.Count-1 do
//  begin
//    if ColumnAtDepth(Columns[I], ARow) <> MasterCol then Break;
//    if not InBiDiMode then
//    begin
//      J := CellRect(DataToRawColumn(I), ARow).Right;
//      if J = 0 then Break;
//      Result.Right := Max(Result.Right, J);
//    end
//    else
//    begin
//      J := CellRect(DataToRawColumn(I), ARow).Left;
//      if J >= ClientWidth then Break;
//      Result.Left := J;
//    end;
//  end;
//  J := Col.Depth;
//  if (J <= ARow) and (J < FixedRows-1) then
//  begin
//    CalcFixedInfo(DrawInfo);
//    Result.Bottom := DrawInfo.Vert.FixedBoundary - DrawInfo.Vert.EffectiveLineWidth;
//  end;
//end;
//
//procedure TDBGridProperties.DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState);
//var
//  FrameOffs: Byte;
//
//  function RowIsMultiSelected: Boolean;
//  var
//    Index: Integer;
//  begin
//    Result := (dgMultiSelect in Options) and Datalink.Active and
//      FSelectedRows.Find(Datalink.Datasource.Dataset.Bookmark, Index);
//  end;
//
//  procedure DrawTitleCell(ACol, ARow: Integer; Column: TSkinDBGridColumn; var AState: TGridDrawState);
//  const
//    ScrollArrows: array [Boolean, Boolean] of Integer =
//      ((DFCS_SCROLLRIGHT, DFCS_SCROLLLEFT), (DFCS_SCROLLLEFT, DFCS_SCROLLRIGHT));
//  var
//    MasterCol: TSkinDBGridColumn;
//    TitleRect, TextRect, ButtonRect: TRect;
//    I: Integer;
//    InBiDiMode: Boolean;
//    LFrameOffs: Byte;
//  begin
//    TitleRect := CalcTitleRect(Column, ARow, MasterCol);
//
//    if MasterCol = nil then
//    begin
//      Canvas.FillRect(ARect);
//      Exit;
//    end;
//
//    Canvas.Font := MasterCol.Title.Font;
//    Canvas.Brush.Color := MasterCol.Title.Color;
//    if [dgRowLines, dgColLines] * Options = [dgRowLines, dgColLines] then
//      InflateRect(TitleRect, -1, -1);
//    TextRect := TitleRect;
//    I := GetSystemMetrics(SM_CXHSCROLL);
//    if ((TextRect.Right - TextRect.Left) > I) and MasterCol.Expandable then
//    begin
//      Dec(TextRect.Right, I);
//      ButtonRect := TitleRect;
//      ButtonRect.Left := TextRect.Right;
//      I := SaveDC(Canvas.Handle);
//      try
//        Canvas.FillRect(ButtonRect);
//        InflateRect(ButtonRect, -1, -1);
//        IntersectClipRect(Canvas.Handle, ButtonRect.Left,
//          ButtonRect.Top, ButtonRect.Right, ButtonRect.Bottom);
//        InflateRect(ButtonRect, 1, 1);
//        { DrawFrameControl doesn't draw properly when orienatation has changed.
//          It draws as ExtTextOut does. }
//        InBiDiMode := Canvas.CanvasOrientation = coRightToLeft;
//        if InBiDiMode then { stretch the arrows box }
//          Inc(ButtonRect.Right, GetSystemMetrics(SM_CXHSCROLL) + 4);
//        DrawFrameControl(Canvas.Handle, ButtonRect, DFC_SCROLL,
//          ScrollArrows[InBiDiMode, MasterCol.Expanded] or DFCS_FLAT);
//      finally
//        RestoreDC(Canvas.Handle, I);
//      end;
//    end;
//    DrawCellBackground(TitleRect, FixedColor, AState, ACol, ARow - FTitleOffset);
//
//    LFrameOffs := FrameOffs;
//    if (gdPressed in AState) then
//      Inc(LFrameOffs); // Offset text when fixed cell is pressed
//    with MasterCol.Title do
//      WriteText(Canvas, TextRect, LFrameOffs, LFrameOffs, Caption, Alignment,
//        IsRightToLeft);
//    if ([dgRowLines, dgColLines] * Options = [dgRowLines, dgColLines]) and
//       (FInternalDrawingStyle = gdsClassic) and
//       not (gdPressed in AState) then
//    begin
//      InflateRect(TitleRect, 1, 1);
//      DrawEdge(Canvas.Handle, TitleRect, BDR_RAISEDINNER, BF_BOTTOMRIGHT);
//      DrawEdge(Canvas.Handle, TitleRect, BDR_RAISEDINNER, BF_TOPLEFT);
//    end;
//    AState := AState - [gdFixed];  // prevent box drawing later
//  end;
//
//var
//  OldActive: Integer;
//  Indicator: Integer;
//  Value: string;
//  DrawColumn: TSkinDBGridColumn;
//  MultiSelected: Boolean;
//  ALeft: Integer;
//begin
//  if csLoading in ComponentState then
//  begin
//    Canvas.Brush.Color := Color;
//    Canvas.FillRect(ARect);
//    Exit;
//  end;
//
//  Dec(ARow, FTitleOffset);
//  Dec(ACol, FIndicatorOffset);
//
//  if (gdFixed in AState) and ([dgRowLines, dgColLines] * Options =
//    [dgRowLines, dgColLines]) then
//  begin
//    InflateRect(ARect, -1, -1);
//    FrameOffs := 1;
//  end
//  else
//    FrameOffs := 2;
//
//  if (gdFixed in AState) and (ACol < 0) then
//  begin
//    DrawCellBackground(ARect, FixedColor, AState, ACol, ARow);
//    if Assigned(DataLink) and DataLink.Active  then
//    begin
//      MultiSelected := False;
//      if ARow >= 0 then
//      begin
//        OldActive := FDataLink.ActiveRecord;
//        try
//          FDatalink.ActiveRecord := ARow;
//          MultiSelected := RowIsMultiselected;
//        finally
//          FDatalink.ActiveRecord := OldActive;
//        end;
//      end;
//      if (ARow = FDataLink.ActiveRecord) or MultiSelected then
//      begin
//        Indicator := 0;
//        if FDataLink.DataSet <> nil then
//          case FDataLink.DataSet.State of
//            dsEdit: Indicator := 1;
//            dsInsert: Indicator := 2;
//            dsBrowse:
//              if MultiSelected then
//                if (ARow <> FDatalink.ActiveRecord) then
//                  Indicator := 3
//                else
//                  Indicator := 4;  // multiselected and current row
//          end;
//        FIndicators.BkColor := FixedColor;
//        ALeft := ARect.Right - FIndicators.Width - FrameOffs;
//        if Canvas.CanvasOrientation = coRightToLeft then Inc(ALeft);
//        FIndicators.Draw(Canvas, ALeft,
//          (ARect.Top + ARect.Bottom - FIndicators.Height) shr 1, Indicator, True);
//        if ARow = FDatalink.ActiveRecord then
//          FSelRow := ARow + FTitleOffset;
//      end;
//    end;
//  end
//  else with Canvas do
//  begin
//    DrawColumn := Columns[ACol];
//    if not DrawColumn.Showing then Exit;
//    if not (gdFixed in AState) then
//    begin
//      Font := DrawColumn.Font;
//      Brush.Color := DrawColumn.Color;
//    end;
//    if ARow < 0 then
//      DrawTitleCell(ACol, ARow + FTitleOffset, DrawColumn, AState)
//    else if (FDataLink = nil) or not FDataLink.Active then
//      FillRect(ARect)
//    else
//    begin
//      Value := '';
//      OldActive := FDataLink.ActiveRecord;
//      try
//        FDataLink.ActiveRecord := ARow;
//        if Assigned(DrawColumn.Field) then
//          Value := DrawColumn.Field.DisplayText;
//        if HighlightCell(ACol, ARow, Value, AState) and DefaultDrawing then
//          DrawCellHighlight(ARect, AState, ACol, ARow);
//        if not Enabled then
//          Font.Color := clGrayText;
//        if FDefaultDrawing then
//          WriteText(Canvas, ARect, 3, 2, Value, DrawColumn.Alignment,
//            UseRightToLeftAlignmentForField(DrawColumn.Field, DrawColumn.Alignment));
//        if Columns.State = csDefault then
//          DrawDataCell(ARect, DrawColumn.Field, AState);
//        DrawColumnCell(ARect, ACol, DrawColumn, AState);
//      finally
//        FDataLink.ActiveRecord := OldActive;
//      end;
//      Canvas.Brush.Style := bsSolid;
//      if FDefaultDrawing and (gdSelected in AState)
//        and ((dgAlwaysShowSelection in Options) or Focused)
//        and not (csDesigning in ComponentState)
//        and not (dgRowSelect in Options)
//        and (UpdateLock = 0)
//        and (ValidParentForm(Self).ActiveControl = Self) then
//      begin
//        if (FInternalDrawingStyle = gdsThemed) and (Win32MajorVersion >= 6) then
//          InflateRect(ARect, -1, -1);
//        Windows.DrawFocusRect(Handle, ARect);
//      end;
//    end;
//  end;
//  if (gdFixed in AState) and ([dgRowLines, dgColLines] * Options =
//     [dgRowLines, dgColLines]) and (FInternalDrawingStyle = gdsClassic) and
//     not (gdPressed in AState) then
//  begin
//    InflateRect(ARect, 1, 1);
//    DrawEdge(Canvas.Handle, ARect, BDR_RAISEDINNER, BF_BOTTOMRIGHT);
//    DrawEdge(Canvas.Handle, ARect, BDR_RAISEDINNER, BF_TOPLEFT);
//  end;
//end;
//
//procedure TDBGridProperties.DrawDataCell(const Rect: TRect; Field: TField;
//  State: TGridDrawState);
//begin
//  if Assigned(FOnDrawDataCell) then FOnDrawDataCell(Self, Rect, Field, State);
//end;
//
//procedure TDBGridProperties.DrawCellBackground(const ARect: TRect; AColor: TColor;
//  AState: TGridDrawState; ACol, ARow: Integer);
//var
//  LRect: TRect;
//begin
//  LRect := ARect;
//  if not (csDesigning in ComponentState) then
//    InflateRect(LRect, 1, 1);
//  inherited DrawCellBackground(LRect, AColor, AState, ACol + FIndicatorOffset,
//    ARow + FTitleOffset);
//end;
//
//procedure TDBGridProperties.DrawCellHighlight(const ARect: TRect;
//  AState: TGridDrawState; ACol, ARow: Integer);
//begin
//  if (dgMultiSelect in Options) and Datalink.Active and (FInternalDrawingStyle <> gdsClassic) then
//    Include(AState, gdRowSelected);
//  inherited DrawCellHighlight(ARect, AState, ACol + FIndicatorOffset, ARow + FTitleOffset);
//end;
//
//procedure TDBGridProperties.DrawColumnCell(const Rect: TRect; DataCol: Integer;
//  Column: TSkinDBGridColumn; State: TGridDrawState);
//begin
//  if Assigned(OnDrawColumnCell) then
//    OnDrawColumnCell(Self, Rect, DataCol, Column, State);
//end;
//
//procedure TDBGridProperties.EditButtonClick;
//begin
//  if Assigned(FOnEditButtonClick) then
//    FOnEditButtonClick(Self)
//  else
//    ShowPopupEditor(Columns[SelectedIndex]);
//end;

procedure TDBGridProperties.EditingChanged;
begin
  uBaseLog.OutputDebugString('TDBGridProperties.EditingChanged');

  //  if dgIndicator in Options then InvalidateCell(0, FSelRow);
end;

procedure TDBGridProperties.EndLayout;
begin
  uBaseLog.OutputDebugString('TDBGridProperties.EndLayout');

  if FLayoutLock > 0 then
  begin
    try
        try
            if FLayoutLock = 1 then
            begin
              InternalLayout;
            end;
        finally
            if FLayoutLock = 1 then
            begin
              FColumns.EndUpdate;
            end;
        end;
    finally
        Dec(FLayoutLock);
        EndUpdate;
    end;
  end;
end;

procedure TDBGridProperties.EndUpdate;
begin
  if FUpdateLock > 0 then
  begin
    Dec(FUpdateLock);
  end;
end;

//function TDBGridProperties.GetColField(DataCol: Integer): TField;
//begin
//  Result := nil;
//  if (DataCol >= 0) and FDatalink.Active and (DataCol < Columns.Count) then
//    Result := Columns[DataCol].Field;
//end;
//
//function TDBGridProperties.GetColumns: TSkinDBGridColumns;
//begin
//  Result:=TSkinDBGridColumns(FColumns);
//end;
//
//function TDBGridProperties.GetDataSource: TDataSource;
//begin
//  Result := FDataLink.DataSource;
//end;
//
//function TDBGridProperties.GetEditLimit: Integer;
//begin
//  Result := 0;
//  if Assigned(SelectedField) and (SelectedField.DataType in [ftString, ftWideString]) then
//    Result := SelectedField.Size;
//end;
//
//function TDBGridProperties.GetEditMask(ACol, ARow: Longint): string;
//begin
//  Result := '';
//  if FDatalink.Active then
//  with Columns[RawToDataColumn(ACol)] do
//    if Assigned(Field) then
//      Result := Field.EditMask;
//end;
//
//function TDBGridProperties.GetEditStyle(ACol, ARow: Integer): TEditStyle;
//var
//  Column: TSkinDBGridColumn;
//  MasterField: TField;
//begin
//  TDBGridInplaceEdit(InplaceEditor).FUseDataList := False;
//  Column := Columns[SelectedIndex];
//  Result := esSimple;
//  case Column.ButtonStyle of
//   cbsEllipsis:
//     Result := esEllipsis;
//   cbsAuto:
//     if Assigned(Column.Field) then
//     with Column.Field do
//     begin
//       { Show the dropdown button only if the field is editable }
//       if FieldKind = fkLookup then
//       begin
//         MasterField := Dataset.FieldByName(KeyFields);
//         { Column.DefaultReadonly will always be True for a lookup field.
//           Test if Column.ReadOnly has been assigned a value of True }
//         if Assigned(MasterField) and MasterField.CanModify and
//           not ((cvReadOnly in Column.AssignedValues) and Column.ReadOnly) then
//           if not ReadOnly and DataLink.Active and not Datalink.ReadOnly then
//           begin
//             Result := esPickList;
//             TDBGridInplaceEdit(InplaceEditor).FUseDataList := True;
//           end;
//       end
//       else
//       if Assigned(Column.Picklist) and (Column.PickList.Count > 0) and
//         not Column.Readonly then
//         Result := esPickList
//       else if DataType in [ftDataset, ftReference] then
//         Result := esEllipsis;
//     end;
//  end;
//end;
//
//function TDBGridProperties.GetEditText(ACol, ARow: Longint): string;
//begin
//  Result := '';
//  if FDatalink.Active then
//    with Columns[RawToDataColumn(ACol)] do
//      if Assigned(Field) then
//        Result := Field.Text;
//  FEditText := Result;
//end;
//
//function TDBGridProperties.GetFieldCount: Integer;
//begin
//  Result := FDatalink.FieldCount;
//end;
//
//function TDBGridProperties.GetFields(FieldIndex: Integer): TField;
//begin
//  Result := FDatalink.Fields[FieldIndex];
//end;
//
//function TDBGridProperties.GetFieldValue(ACol: Integer): string;
//var
//  Field: TField;
//begin
//  Result := '';
//  Field := GetColField(ACol);
//  if Field <> nil then Result := Field.DisplayText;
//end;
//
//function TDBGridProperties.GetSelectedField: TField;
//var
//  Index: Integer;
//begin
//  Index := SelectedIndex;
//  if Index <> -1 then
//  begin
//    Result := Columns[Index].Field;
//  end
//  else
//    Result := nil;
//end;
//
//function TDBGridProperties.GetSelectedIndex: Integer;
//begin
//  Result := RawToDataColumn(Col);
//end;
//
//function TDBGridProperties.HighlightCell(DataCol, DataRow: Integer;
//  const Value: string; AState: TGridDrawState): Boolean;
//var
//  Index: Integer;
//begin
//  Result := False;
//  if (dgMultiSelect in Options) and Datalink.Active then
//    Result := FSelectedRows.Find(Datalink.Datasource.Dataset.Bookmark, Index);
//  if not Result then
//    Result := (gdSelected in AState)
//      and ((dgAlwaysShowSelection in Options) or Focused)
//        { updatelock eliminates flicker when tabbing between rows }
//      and ((UpdateLock = 0) or (dgRowSelect in Options));
//end;
//
//procedure TDBGridProperties.KeyDown(var Key: Word; Shift: TShiftState);
//var
//  KeyDownEvent: TKeyEvent;
//
//  procedure ClearSelection;
//  begin
//    if (dgMultiSelect in Options) then
//    begin
//      FSelectedRows.Clear;
//      FSelecting := False;
//    end;
//  end;
//
//  procedure DoSelection(Select: Boolean; Direction: Integer);
//  var
//    AddAfter: Boolean;
//  begin
//    AddAfter := False;
//    BeginUpdate;
//    try
//      if (dgMultiSelect in Options) and FDatalink.Active then
//        if Select and (ssShift in Shift) then
//        begin
//          if not FSelecting then
//          begin
//            FSelectionAnchor := FSelectedRows.CurrentRow;
//            FSelectedRows.CurrentRowSelected := True;
//            FSelecting := True;
//            AddAfter := True;
//          end
//          else
//          with FSelectedRows do
//          begin
//            AddAfter := Compare(CurrentRow, FSelectionAnchor) <> -Direction;
//            if not AddAfter then
//              CurrentRowSelected := False;
//          end
//        end
//        else
//          ClearSelection;
//      FDatalink.MoveBy(Direction);
//      if AddAfter then FSelectedRows.CurrentRowSelected := True;
//    finally
//      EndUpdate;
//    end;
//  end;
//
//  procedure NextRow(Select: Boolean);
//  begin
//    with FDatalink.Dataset do
//    begin
//      if (State = dsInsert) and not Modified and not FDatalink.FModified then
//        if FDataLink.EOF then Exit else Cancel
//      else
//        DoSelection(Select, 1);
//      if FDataLink.EOF and CanModify and (not ReadOnly) and (dgEditing in Options) then
//        Append;
//    end;
//  end;
//
//  procedure PriorRow(Select: Boolean);
//  begin
//    with FDatalink.Dataset do
//      if (State = dsInsert) and not Modified and FDataLink.EOF and
//        not FDatalink.FModified then
//        Cancel
//      else
//        DoSelection(Select, -1);
//  end;
//
//  procedure Tab(GoForward: Boolean);
//  var
//    ACol, Original: Integer;
//  begin
//    ACol := Col;
//    Original := ACol;
//    BeginUpdate;    { Prevent highlight flicker on tab to next/prior row }
//    try
//      while True do
//      begin
//        if GoForward then
//          Inc(ACol) else
//          Dec(ACol);
//        if ACol >= ColCount then
//        begin
//          NextRow(False);
//          ACol := FIndicatorOffset;
//        end
//        else if ACol < FIndicatorOffset then
//        begin
//          PriorRow(False);
//          ACol := ColCount - FIndicatorOffset;
//        end;
//        if ACol = Original then Exit;
//        if TabStops[ACol] then
//        begin
//          MoveCol(ACol, 0);
//          Exit;
//        end;
//      end;
//    finally
//      EndUpdate;
//    end;
//  end;
//
//  function DeletePrompt: Boolean;
//  var
//    Msg: string;
//  begin
//    if (FSelectedRows.Count > 1) then
//      Msg := SDeleteMultipleRecordsQuestion
//    else
//      Msg := SDeleteRecordQuestion;
//    Result := not (dgConfirmDelete in Options) or
//      (MessageDlg(Msg, mtConfirmation, mbOKCancel, 0) <> idCancel);
//  end;
//
//const
//  RowMovementKeys = [VK_UP, VK_PRIOR, VK_DOWN, VK_NEXT, VK_HOME, VK_END];
//
//begin
//  KeyDownEvent := OnKeyDown;
//  if Assigned(KeyDownEvent) then KeyDownEvent(Self, Key, Shift);
//  if not FDatalink.Active or not CanGridAcceptKey(Key, Shift) then Exit;
//  if UseRightToLeftAlignment then
//    if Key = VK_LEFT then
//      Key := VK_RIGHT
//    else if Key = VK_RIGHT then
//      Key := VK_LEFT;
//  with FDatalink.DataSet do
//    if ssCtrl in Shift then
//    begin
//      if (Key in RowMovementKeys) then ClearSelection;
//      case Key of
//        VK_UP, VK_PRIOR: FDataLink.MoveBy(-FDatalink.ActiveRecord);
//        VK_DOWN, VK_NEXT: FDataLink.MoveBy(FDatalink.BufferCount - FDatalink.ActiveRecord - 1);
//        VK_LEFT: MoveCol(FIndicatorOffset, 1);
//        VK_RIGHT: MoveCol(ColCount - 1, -1);
//        VK_HOME: First;
//        VK_END: Last;
//        VK_DELETE:
//          if (not ReadOnly) and not IsEmpty
//            and CanModify and DeletePrompt then
//          if FSelectedRows.Count > 0 then
//            FSelectedRows.Delete
//          else
//            Delete;
//      end
//    end
//    else
//      case Key of
//        VK_UP: PriorRow(True);
//        VK_DOWN: NextRow(True);
//        VK_LEFT:
//          if dgRowSelect in Options then
//            PriorRow(False) else
//            MoveCol(Col - 1, -1);
//        VK_RIGHT:
//          if dgRowSelect in Options then
//            NextRow(False) else
//            MoveCol(Col + 1, 1);
//        VK_HOME:
//          if (ColCount = FIndicatorOffset+1)
//            or (dgRowSelect in Options) then
//          begin
//            ClearSelection;
//            First;
//          end
//          else
//            MoveCol(FIndicatorOffset, 1);
//        VK_END:
//          if (ColCount = FIndicatorOffset+1)
//            or (dgRowSelect in Options) then
//          begin
//            ClearSelection;
//            Last;
//          end
//          else
//            MoveCol(ColCount - 1, -1);
//        VK_NEXT:
//          begin
//            ClearSelection;
//            FDataLink.MoveBy(VisibleRowCount);
//          end;
//        VK_PRIOR:
//          begin
//            ClearSelection;
//            FDataLink.MoveBy(-VisibleRowCount);
//          end;
//        VK_INSERT:
//          if CanModify and (not ReadOnly) and (dgEditing in Options) then
//          begin
//            ClearSelection;
//            Insert;
//          end;
//        VK_TAB: if not (ssAlt in Shift) then Tab(not (ssShift in Shift));
//        VK_ESCAPE:
//          begin
//            if SysLocale.PriLangID = LANG_KOREAN then
//              FIsESCKey := True;
//            FDatalink.Reset;
//            ClearSelection;
//            if not (dgAlwaysShowEditor in Options) then HideEditor;
//          end;
//        VK_F2: EditorMode := True;
//      end;
//end;
//
//procedure TDBGridProperties.KeyPress(var Key: Char);
//begin
//  FIsESCKey := False;
//  if not (dgAlwaysShowEditor in Options) and (Key = #13) then
//    FDatalink.UpdateData;
//  inherited KeyPress(Key);
//end;

{ InternalLayout is called with layout locks and column locks in effect }
procedure TDBGridProperties.InternalLayout;


  //字段是否已经映射过了?
  function FieldIsMapped(F: TField): Boolean;
  var
    X: Integer;
  begin
    Result := False;

    if F = nil then Exit;

    for X := 0 to FDatalink.FieldCount-1 do
    begin
      if FDatalink.Fields[X] = F then
      begin
        Result := True;
        Exit;
      end;
    end;
  end;



  //释放掉自动生成的列
  procedure CheckForPassthroughs;  // check for Columns.State flip-flop
  var
    SeenPassthrough: Boolean;
    I, J: Integer;
    Column: TSkinDBGridColumn;
  begin
      uBaseLog.OutputDebugString('TDBGridProperties.CheckForPassthroughs 清除自动生成的列');


      //难懂啊
      SeenPassthrough := False;
      for I := 0 to FColumns.Count-1 do
      begin
        if not Columns[I].IsStored then
        begin
          //有自动生成的表格列
          SeenPassthrough := True;
        end
        else if SeenPassthrough then
        begin
          // we have both persistent and non-persistent columns.  Kill the latter
          for J := FColumns.Count-1 downto 0 do
          begin
            Column := Columns[J];
            if not Column.IsStored then
            begin
              FreeAndNil(Column);
            end;
          end;
          Exit;
        end;
      end;
  end;




  procedure ResetColumnFieldBindings;
  var
    I, J, K: Integer;
    Fld: TField;
    Column: TSkinDBGridColumn;
  begin
      uBaseLog.OutputDebugString('TDBGridProperties.ResetColumnFieldBindings 重新初始表格列');

      Columns.BeginUpdate;
      try

          if Columns.State = csDefault then
          begin


              //表格列是默认,自动生成的
               { Destroy columns whose fields have been destroyed or are no longer
                 in field map }
              if (not FDataLink.Active)
                  and (FDatalink.DefaultFields) then
              begin
                  //如果数据集没有打开,那么清空表格列
                  //FColumns.Clear;
              end
              else
              begin
                  //如果数据集已经打开,那么判断字段有没有映射
                  //如果没有映射,那么释放此表格列,
                  //如果已经在FDatalink中存在的,那么这个Column可以不用删除
                  for J := FColumns.Count-1 downto 0 do
                  begin
                    if not Assigned(Columns[J].Field)
                      or not FieldIsMapped(Columns[J].Field) then
                    begin
                      Columns[J].Free;
                    end;
                  end;
              end;


              I := FDataLink.FieldCount;
              //if (I = 0) and (FColumns.Count = 0) then Inc(I);

              for J := 0 to I-1 do
              begin
                Fld := FDatalink.Fields[J];
                if Assigned(Fld) then
                begin
                    K := J;
                     { Pointer compare is valid here because the grid sets matching
                       column.field properties to nil in response to field object
                       free notifications.  Closing a dataset that has only default
                       field objects will destroy all the fields and set associated
                       column.field props to nil. }
                    while (K < FColumns.Count) and (Columns[K].Field <> Fld) do
                    begin
                      Inc(K);
                    end;

                    if K < FColumns.Count then
                    begin
                        //已经存在
                        Column := Columns[K];
                    end
                    else
                    begin
                        //不存在,则要添加
                        //内部添加,不保存到dfm
                        Column := Columns.InternalAdd;
                        Column.Field := Fld;
                    end;


                end
                else
                begin
                    //添加一个空列,没有绑定字段
                    //Column := Columns.InternalAdd;
                end;

                //设置顺序
                Column.Index := J;
              end;
          end
          else
          begin
              //清除原Dataset中的Field
              { Force columns to reaquire fields (in case dataset has changed) }
              for I := 0 to Columns.Count-1 do
              begin
                Columns[I].Field := nil;
              end;
          end;


      finally
        Columns.EndUpdate;
      end;
  end;

//  procedure MeasureTitleHeights;
//  var
//    I, J, K, D, B: Integer;
//    RestoreCanvas: Boolean;
//    Heights: array of Integer;
//    TempDc: HDC;
//  begin
//    RestoreCanvas := not HandleAllocated;
//    if RestoreCanvas then
//      Canvas.Handle := GetDC(0);
//    try
//      Canvas.Font := Font;
//      K := Canvas.TextHeight('Wg') + 3;
//      if dgRowLines in Options then
//        Inc(K, GridLineWidth);
//      DefaultRowHeight := K;
//      B := GetSystemMetrics(SM_CYHSCROLL);
//      if dgTitles in Options then
//      begin
//        SetLength(Heights, FTitleOffset+1);
//        for I := 0 to FColumns.Count-1 do
//        begin
//          Canvas.Font := FColumns[I].Title.Font;
//          D := FColumns[I].Depth;
//          if D <= High(Heights) then
//          begin
//            J := Canvas.TextHeight('Wg') + 4;
//            if FColumns[I].Expandable and (B > J) then
//              J := B;
//            Heights[D] := Max(J, Heights[D]);
//          end;
//        end;
//        if Heights[0] = 0 then
//        begin
//          Canvas.Font := FTitleFont;
//          Heights[0] := Canvas.TextHeight('Wg') + 4;
//        end;
//        for I := 0 to High(Heights)-1 do
//          RowHeights[I] := Heights[I];
//      end;
//    finally
//      if RestoreCanvas then
//      begin
//        TempDc := Canvas.Handle;
//        Canvas.Handle := 0;
//        ReleaseDC(0,TempDc);
//      end;
//    end;
//  end;
//
//var
//  I, J: Integer;
begin
  uBaseLog.OutputDebugString('TDBGridProperties.InternalLayout 更新表格列');


  if ([csLoading, csDestroying] * Self.FSkinControl.ComponentState) <> [] then Exit;

//  if HandleAllocated then KillMessage(Handle, cm_DeferLayout);



  //释放自动生成的列
  CheckForPassthroughs;



//  FIndicatorOffset := 0;
//  if dgIndicator in Options then
//    Inc(FIndicatorOffset);



  //清除表格列和字段的映射
  FDatalink.ClearMapping;
  if FDatalink.Active then
  begin
    //生成表格列和字段的映射
    DefineFieldMap;
  end;

//  DoubleBuffered := (FDatalink.Dataset <> nil) and FDatalink.Dataset.ObjectView;

  //重新初始表格列
  ResetColumnFieldBindings;

//  FVisibleColumns.Clear;
//  for I := 0 to FColumns.Count-1 do
//    if FColumns[I].Showing then FVisibleColumns.Add(FColumns[I]);
//  ColCount := FColumns.Count + FIndicatorOffset;
//  inherited FixedCols := FIndicatorOffset;
//  FTitleOffset := 0;
//  if dgTitles in Options then
//  begin
//    FTitleOffset := 1;
//    if (FDatalink <> nil) and (FDatalink.Dataset <> nil)
//      and FDatalink.Dataset.ObjectView then
//    begin
//      for I := 0 to FColumns.Count-1 do
//      begin
//        if FColumns[I].Showing then
//        begin
//          J := FColumns[I].Depth;
//          if J >= FTitleOffset then FTitleOffset := J+1;
//        end;
//      end;
//    end;
//  end;

  UpdateRowCount;

//  MeasureTitleHeights;
//  SetColumnAttributes;
//  UpdateActive;
//  Invalidate;
end;

procedure TDBGridProperties.LayoutChanged;
begin
  uBaseLog.OutputDebugString('TDBGridProperties.LayoutChanged');

  if AcquireLayoutLock then
  begin
    EndLayout;
  end;
end;

//procedure TDBGridProperties.LinkActive(Value: Boolean);
//var
//  Comp: TComponent;
//  I: Integer;
//begin
//  if not Value then HideEditor;
//  FSelectedRows.LinkActive(Value);
//  try
//    LayoutChanged;
//  finally
//    for I := ComponentCount-1 downto 0 do
//    begin
//      Comp := Components[I];   // Free all the popped-up subgrids
//      if (Comp is TDBGridProperties)
//        and (TDBGridProperties(Comp).DragKind = dkDock) then
//        Comp.Free;
//    end;
//    UpdateScrollBar;
//    if Value and (dgAlwaysShowEditor in Options) then ShowEditor;
//  end;
//end;
//
//procedure TDBGridProperties.Loaded;
//begin
//  inherited Loaded;
//  if FColumns.Count > 0 then
//    ColCount := FColumns.Count;
//  LayoutChanged;
//end;
//
//function TDBGridProperties.PtInExpandButton(X,Y: Integer; var MasterCol: TSkinDBGridColumn): Boolean;
//var
//  Cell: TGridCoord;
//  R: TRect;
//begin
//  MasterCol := nil;
//  Result := False;
//  Cell := MouseCoord(X,Y);
//  if (Cell.Y < FTitleOffset) and FDatalink.Active
//    and (Cell.X >= FIndicatorOffset)
//    and (RawToDataColumn(Cell.X) < Columns.Count) then
//  begin
//    R := CalcTitleRect(Columns[RawToDataColumn(Cell.X)], Cell.Y, MasterCol);
//    if not UseRightToLeftAlignment then
//      R.Left := R.Right - GetSystemMetrics(SM_CXHSCROLL)
//    else
//      R.Right := R.Left + GetSystemMetrics(SM_CXHSCROLL);
//    Result := MasterCol.Expandable and PtInRect(R, Point(X,Y));
//  end;
//end;
//
//procedure TDBGridProperties.MouseDown(Button: TMouseButton; Shift: TShiftState;
//  X, Y: Integer);
//var
//  Cell: TGridCoord;
//  OldCol,OldRow: Integer;
//  MasterCol: TSkinDBGridColumn;
//begin
//  if not AcquireFocus then Exit;
//  if (ssDouble in Shift) and (Button = mbLeft) then
//  begin
//    DblClick;
//    Exit;
//  end;
//
//  if Sizing(X, Y) then
//  begin
//    FDatalink.UpdateData;
//    inherited MouseDown(Button, Shift, X, Y);
//    Exit;
//  end;
//
//  Cell := MouseCoord(X, Y);
//  if (Cell.X < 0) and (Cell.Y < 0) then
//  begin
//    if (FDataLink <> nil) and (FDataLink.Editing) then
//      FDataLink.UpdateData;
//    inherited MouseDown(Button, Shift, X, Y);
//    Exit;
//  end;
//
//  if (DragKind = dkDock) and (Cell.X < FIndicatorOffset) and
//    (Cell.Y < FTitleOffset) and (not (csDesigning in ComponentState)) then
//  begin
//    BeginDrag(false);
//    Exit;
//  end;
//
//  if PtInExpandButton(X,Y, MasterCol) then
//  begin
//    MasterCol.Expanded := not MasterCol.Expanded;
//    ReleaseCapture;
//    UpdateDesigner;
//    Exit;
//  end;
//
//  if ((csDesigning in ComponentState) or (dgColumnResize in Options)) and
//    (Cell.Y < FTitleOffset) then
//  begin
//    FDataLink.UpdateData;
//    inherited MouseDown(Button, Shift, X, Y);
//    Exit;
//  end;
//
//  if FDatalink.Active then
//    with Cell do
//    begin
//      BeginUpdate;   { eliminates highlight flicker when selection moves }
//      try
//        FDatalink.UpdateData; // validate before moving
//        HideEditor;
//        OldCol := Col;
//        OldRow := Row;
//        if (Y >= FTitleOffset) and (Y - Row <> 0) then
//          FDatalink.MoveBy(Y - Row);
//        if X >= FIndicatorOffset then
//          MoveCol(X, 0);
//        if (Button = mbLeft) and (dgMultiSelect in Options) and FDatalink.Active then
//          with FSelectedRows do
//          begin
//            FSelecting := False;
//            if ssCtrl in Shift then
//              CurrentRowSelected := not CurrentRowSelected
//            else
//            begin
//              Clear;
//              CurrentRowSelected := True;
//            end;
//          end;
//        if (Button = mbLeft) and
//          (((X = OldCol) and (Y = OldRow)) or (dgAlwaysShowEditor in Options)) then
//          ShowEditor         { put grid in edit mode }
//        else
//          InvalidateEditor;  { draw editor, if needed }
//      finally
//        EndUpdate;
//      end;
//    end;
//end;
//
//procedure TDBGridProperties.MouseUp(Button: TMouseButton; Shift: TShiftState;
//  X, Y: Integer);
//var
//  Cell: TGridCoord;
//  SaveState: TGridState;
//begin
//  SaveState := FGridState;
//  inherited MouseUp(Button, Shift, X, Y);
//  if (SaveState = gsRowSizing) or (SaveState = gsColSizing) or
//    ((InplaceEditor <> nil) and (InplaceEditor.Visible) and
//     (PtInRect(InplaceEditor.BoundsRect, Point(X,Y)))) then Exit;
//  Cell := MouseCoord(X,Y);
//  if (Button = mbLeft) and (Cell.X >= FIndicatorOffset) and (Cell.Y >= 0) then
//    if Cell.Y < FTitleOffset then
//      TitleClick(Columns[RawToDataColumn(Cell.X)])
//    else
//      CellClick(Columns[SelectedIndex]);
//end;
//
//function TDBGridProperties.DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean;
//begin
//  Result := False;
//  if Assigned(OnMouseWheelDown) then
//    OnMouseWheelDown(Self, Shift, MousePos, Result);
//  if (not Result) and (FDataLink.Active) then
//  begin
//    FDataLink.MoveBy(1);
//    Result := True;
//  end;
//end;
//
//function TDBGridProperties.DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean;
//begin
//  Result := False;
//  if Assigned(OnMouseWheelUp) then
//    OnMouseWheelUp(Self, Shift, MousePos, Result);
//  if (not Result) and (FDataLink.Active) then
//  begin
//    FDataLink.MoveBy(-1);
//    Result := True;
//  end;
//end;
//
//procedure TDBGridProperties.MoveCol(RawCol, Direction: Integer);
//var
//  OldCol: Integer;
//begin
//  FDatalink.UpdateData;
//  if RawCol >= ColCount then
//    RawCol := ColCount - 1;
//  if RawCol < FIndicatorOffset then RawCol := FIndicatorOffset;
//  if Direction <> 0 then
//  begin
//    while (RawCol < ColCount) and (RawCol >= FIndicatorOffset) and
//      (ColWidths[RawCol] <= 0) do
//      Inc(RawCol, Direction);
//    if (RawCol >= ColCount) or (RawCol < FIndicatorOffset) then Exit;
//  end;
//  OldCol := Col;
//  if RawCol <> OldCol then
//  begin
//    if not FInColExit then
//    begin
//      FInColExit := True;
//      try
//        ColExit;
//      finally
//        FInColExit := False;
//      end;
//      if Col <> OldCol then Exit;
//    end;
//    if not (dgAlwaysShowEditor in Options) then HideEditor;
//    Col := RawCol;
//    ColEnter;
//  end;
//end;
//
//procedure TDBGridProperties.Notification(AComponent: TComponent;
//  Operation: TOperation);
//var
//  I: Integer;
//  NeedLayout: Boolean;
//begin
//  inherited Notification(AComponent, Operation);
//  if (Operation = opRemove) then
//  begin
//    if (AComponent is TPopupMenu) then
//    begin
//      for I := 0 to Columns.Count-1 do
//        if Columns[I].PopupMenu = AComponent then
//          Columns[I].PopupMenu := nil;
//    end
//    else if (FDataLink <> nil) then
//      if (AComponent = DataSource)  then
//        DataSource := nil
//      else if (AComponent is TField) then
//      begin
//        NeedLayout := False;
//        BeginLayout;
//        try
//          for I := 0 to Columns.Count-1 do
//            with Columns[I] do
//              if Field = AComponent then
//              begin
//                Field := nil;
//                NeedLayout := True;
//              end;
//        finally
//          if NeedLayout and Assigned(FDatalink.Dataset)
//            and not (csDestroying in FDatalink.DataSet.ComponentState)
//            and not FDatalink.Dataset.ControlsDisabled then
//            EndLayout
//          else
//            DeferLayout;
//        end;
//      end;
//  end;
//end;

procedure TDBGridProperties.RecordChanged(Field: TField);
//var
//  I: Integer;
//  CField: TField;
begin
//  if not HandleAllocated then Exit;
//  if Field = nil then
//    Invalidate
//  else
//  begin
//    for I := 0 to Columns.Count - 1 do
//      if Columns[I].Field = Field then
//        InvalidateCol(DataToRawColumn(I));
//  end;
//  CField := SelectedField;
//  if ((Field = nil) or (CField = Field)) and
//    (Assigned(CField) and (CField.Text <> FEditText) and
//    ((SysLocale.PriLangID <> LANG_KOREAN) or FIsESCKey)) then
//  begin
//    InvalidateEditor;
//    if InplaceEditor <> nil then InplaceEditor.Deselect;
//  end;
end;

procedure TDBGridProperties.Scroll(Distance: Integer);
//var
//  OldRect, NewRect: TRect;
//  RowHeight: Integer;
begin
  if (Self.FItems.Count>FDataLink.ActiveRecord)
    and (FDataLink.ActiveRecord>-1) then
  begin
    Self.SelectedItem:=FItems[FDataLink.ActiveRecord];
  end;

//  if not HandleAllocated then Exit;
//  OldRect := BoxRect(0, Row, ColCount - 1, Row);
//  if (FDataLink.ActiveRecord >= RowCount - FTitleOffset) then UpdateRowCount;
//  UpdateScrollBar;
//  UpdateActive;
//  NewRect := BoxRect(0, Row, ColCount - 1, Row);
//  ValidateRect(Handle, @OldRect);
//  InvalidateRect(Handle, @OldRect, False);
//  InvalidateRect(Handle, @NewRect, False);
//  if Distance <> 0 then
//  begin
//    HideEditor;
//    try
//      if Abs(Distance) > VisibleRowCount then
//      begin
//        Invalidate;
//        Exit;
//      end
//      else
//      begin
//        RowHeight := DefaultRowHeight;
//        if dgRowLines in Options then Inc(RowHeight, GridLineWidth);
//        if dgIndicator in Options then
//        begin
//          OldRect := BoxRect(0, FSelRow, ColCount - 1, FSelRow);
//          InvalidateRect(Handle, @OldRect, False);
//        end;
//        NewRect := BoxRect(0, FTitleOffset, ColCount - 1, 1000);
//        ScrollWindowEx(Handle, 0, -RowHeight * Distance, @NewRect, @NewRect,
//          0, nil, SW_Invalidate);
//        if dgIndicator in Options then
//        begin
//          NewRect := BoxRect(0, Row, ColCount - 1, Row);
//          InvalidateRect(Handle, @NewRect, False);
//        end;
//      end;
//    finally
//      if dgAlwaysShowEditor in Options then ShowEditor;
//    end;
//  end;
//  if UpdateLock = 0 then Update;
end;

//procedure TDBGridProperties.SetColumns(Value: TSkinDBGridColumns);
//begin
//  Columns.Assign(Value);
//end;
//
//function ReadOnlyField(Field: TField): Boolean;
//var
//  MasterField: TField;
//begin
//  Result := Field.ReadOnly;
//  if not Result and (Field.FieldKind = fkLookup) then
//  begin
//    Result := True;
//    if Field.DataSet = nil then Exit;
//    MasterField := Field.Dataset.FindField(Field.KeyFields);
//    if MasterField = nil then Exit;
//    Result := MasterField.ReadOnly;
//  end;
//end;
//
//procedure TDBGridProperties.SetColumnAttributes;
//var
//  I: Integer;
//begin
//  for I := 0 to FColumns.Count-1 do
//  with FColumns[I] do
//  begin
//    TabStops[I + FIndicatorOffset] := Showing and not ReadOnly and DataLink.Active and
//      Assigned(Field) and not (Field.FieldKind = fkCalculated) and not ReadOnlyField(Field);
//    ColWidths[I + FIndicatorOffset] := Width;
//  end;
//  if (dgIndicator in Options) then
//    ColWidths[0] := IndicatorWidth;
//end;

//procedure TDBGridProperties.SetDataSource(Value: TDataSource);
//begin
//  if Value = FDatalink.Datasource then Exit;
//  if Assigned(Value) then
//    if Assigned(Value.DataSet) then
//      if Value.DataSet.IsUnidirectional then
//        DatabaseError(SDataSetUnidirectional);
//  FSelectedRows.Clear;
//  FDataLink.DataSource := Value;
//  if Value <> nil then Value.FreeNotification(Self);
//end;
//
//procedure TDBGridProperties.SetEditText(ACol, ARow: Longint; const Value: string);
//begin
//  FEditText := Value;
//end;

//procedure TDBGridProperties.SetOptions(Value: TSkinDBGridOptions);
////const
////  LayoutOptions = [dgEditing, dgAlwaysShowEditor, dgTitles, dgIndicator,
////    dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection];
////var
////  NewGridOptions: TGridOptions;
////  ChangedOptions: TDBGridOptions;
//begin
//  if FOptions <> Value then
//  begin
////    NewGridOptions := [];
////    if dgColLines in Value then
////      NewGridOptions := NewGridOptions + [goFixedVertLine, goVertLine];
////    if dgRowLines in Value then
////      NewGridOptions := NewGridOptions + [goFixedHorzLine, goHorzLine];
////    if dgColumnResize in Value then
////      NewGridOptions := NewGridOptions + [goColSizing, goColMoving];
////    if dgTabs in Value then Include(NewGridOptions, goTabs);
////    if dgRowSelect in Value then
////    begin
////      Include(NewGridOptions, goRowSelect);
////      Exclude(Value, dgAlwaysShowEditor);
////      Exclude(Value, dgEditing);
////    end;
////    if dgEditing in Value then Include(NewGridOptions, goEditing);
////    if dgAlwaysShowEditor in Value then Include(NewGridOptions, goAlwaysShowEditor);
////    if dgTitleClick in Value then Include(NewGridOptions, goFixedRowClick);
////    if dgTitleHotTrack in Value then Include(NewGridOptions, goFixedHotTrack);
////    inherited Options := NewGridOptions;
////    if dgMultiSelect in (FOptions - Value) then FSelectedRows.Clear;
////    ChangedOptions := (FOptions + Value) - (FOptions * Value);
//    FOptions := Value;
////    if ChangedOptions * LayoutOptions <> [] then LayoutChanged;
//  end;
//end;

//procedure TDBGridProperties.SetSelectedField(Value: TField);
//var
//  I: Integer;
//begin
//  if Value = nil then Exit;
//  for I := 0 to Columns.Count - 1 do
//    if Columns[I].Field = Value then
//      MoveCol(DataToRawColumn(I), 0);
//end;
//
//procedure TDBGridProperties.SetSelectedIndex(Value: Integer);
//begin
//  MoveCol(DataToRawColumn(Value), 0);
//end;
//
//procedure TDBGridProperties.SetTitleFont(Value: TFont);
//begin
//  FTitleFont.Assign(Value);
//  if dgTitles in Options then LayoutChanged;
//end;
//
//function TDBGridProperties.StoreColumns: Boolean;
//begin
//  Result := Columns.State = csCustomized;
//end;
//
//procedure TDBGridProperties.TimedScroll(Direction: TGridScrollDirection);
//begin
//  if FDatalink.Active then
//  begin
//    with FDatalink do
//    begin
//      if sdUp in Direction then
//      begin
//        FDataLink.MoveBy(-ActiveRecord - 1);
//        Exclude(Direction, sdUp);
//      end;
//      if sdDown in Direction then
//      begin
//        FDataLink.MoveBy(RecordCount - ActiveRecord);
//        Exclude(Direction, sdDown);
//      end;
//    end;
//    if Direction <> [] then inherited TimedScroll(Direction);
//  end;
//end;
//
//procedure TDBGridProperties.TitleClick(Column: TSkinDBGridColumn);
//begin
//  if (dgTitleClick in FOptions) and Assigned(FOnTitleClick) then
//    FOnTitleClick(Column);
//end;
//
//procedure TDBGridProperties.TitleFontChanged(Sender: TObject);
//begin
//  if (not FSelfChangingTitleFont) and not (csLoading in ComponentState) then
//    ParentFont := False;
//  if dgTitles in Options then LayoutChanged;
//end;

//procedure TDBGridProperties.UpdateActive;
//var
//  NewRow: Integer;
//  Field: TField;
//begin
//  if FDatalink.Active and HandleAllocated and not (csLoading in ComponentState) then
//  begin
//    NewRow := FDatalink.ActiveRecord + FTitleOffset;
//    if Row <> NewRow then
//    begin
//      if not (dgAlwaysShowEditor in Options) then HideEditor;
//      MoveColRow(Col, NewRow, False, False);
//      InvalidateEditor;
//    end;
//    Field := SelectedField;
//    if Assigned(Field) and (Field.Text <> FEditText) then
//      InvalidateEditor;
//  end;
//end;

procedure TDBGridProperties.UpdateData;
//var
//  Field: TField;
begin
//  Field := SelectedField;
//  if Assigned(Field) and (Field.Text <> FEditText) then
//    Field.Text := FEditText;
end;

procedure TDBGridProperties.UpdateFooter;
var
  I: Integer;
  OldActiveRecord:Integer;
  J: Integer;
  AHasSumFooter:Boolean;
  ASumFooterList:TList;
begin
  AHasSumFooter:=False;
  ASumFooterList:=nil;
  for I := 0 to Self.Columns.Count-1 do
  begin

      //暂时清空统计值
      Self.Columns[I].FFooter.SumValue:=0;
      Self.Columns[I].FFooter.AverageValue:=0;
      Self.Columns[I].FFooter.RecordCount:=0;


      if (Self.Columns[I].FFooter.ValueType=fvtSum)
        or (Self.Columns[I].FFooter.ValueType=fvtAverage) then
      begin

          if Self.Columns[I].Field<>nil then
          begin
              AHasSumFooter:=True;
              if ASumFooterList=nil then
              begin
                ASumFooterList:=TList.Create;
              end;
              ASumFooterList.Add(Columns[I]);
          end;

      end;

  end;




  if (Self.FDataLink.DataSet<>nil)
    and Self.FDataLink.DataSet.Active then
  begin
      //数据集打开

      //更新汇总表格列



      //统计记录数
      for I := 0 to Self.Columns.Count-1 do
      begin
//        if (Self.Columns[I].Field<>nil) and (Self.Columns[I].FFooter.ValueType=fvtCount) then
//        begin
//            Self.Columns[I].FFooter.StaticValue:=IntToStr(Self.FDataLink.DataSet.RecordCount);
            Self.Columns[I].FFooter.RecordCount:=Self.FDataLink.DataSet.RecordCount;
//        end;
      end;




      if AHasSumFooter then
      begin
        OldActiveRecord:=Self.FDataLink.ActiveRecord;
        try


              //计算每列的统计值
              for I := 0 to Self.FDataLink.DataSet.RecordCount-1 do
              begin
                Self.FDataLink.ActiveRecord:=I;
                for J := 0 to ASumFooterList.Count-1 do
                begin
                  try
                    if not VarIsNull(TSkinDBGridColumn(ASumFooterList[J]).Field.Value) then
                    begin
                      TSkinDBGridColumn(ASumFooterList[J]).Footer.SumValue:=
                            TSkinDBGridColumn(ASumFooterList[J]).Footer.SumValue
                              +TSkinDBGridColumn(ASumFooterList[J]).Field.AsFloat;
                    end;
                  except

                  end;
                end;
              end;


              //计算平均值
              for J := 0 to ASumFooterList.Count-1 do
              begin
                try
                  TSkinDBGridColumn(ASumFooterList[J]).Footer.AverageValue:=
                      TSkinDBGridColumn(ASumFooterList[J]).Footer.SumValue/Self.FDataLink.DataSet.RecordCount;
                except

                end;
              end;

        finally
          Self.FDataLink.ActiveRecord:=OldActiveRecord;
        end;
      end;

  end;



  if AHasSumFooter then
  begin
    FreeAndNil(ASumFooterList);
  end;


end;

procedure TDBGridProperties.UpdateRowCount;
var
  I: Integer;
  ARow:TSkinDBGridRow;
  AItemsCount:Integer;
//  OldActiveRecord:Integer;
//  J: Integer;
//  AHasSumFooter:Boolean;
//  ASumFooterList:TList;
//var
//  OldRowCount: Integer;
begin
  uBaseLog.OutputDebugString('TDBGridProperties.UpdateRowCount 刷新数据行');

  Self.Items.BeginUpdate;
  try

    //生成表格数据行
    if FDataLink.Active
      and (Self.FDataLink.DataSet.RecordCount>0) then
    begin

        if Self.FItems.Count>Self.FDataLink.DataSet.RecordCount then
        begin
            //删除多余的行
            while Self.FItems.Count>Self.FDataLink.DataSet.RecordCount do
            begin
              Self.FItems.Delete(Self.FItems.Count-1);
            end;
        end
        else
        begin

            //生成表格列
            AItemsCount:=Self.FItems.Count;
            for I := AItemsCount to Self.FDataLink.DataSet.RecordCount-1 do
            begin
                ARow:=Self.Items.Add;
                //记录
                ARow.RecordIndex:=I;

                //设置是否选中
                if I=FDataLink.ActiveRecord then
                begin
                  ARow.Selected:=True;
                end;
            end;

        end;

        //设置缓冲
        DataLink.BufferCount:=Self.FDataLink.DataSet.RecordCount;
    end
    else
    begin

        //表格为空
        Self.Items.Clear(True);

//        //添加空行
//        ARow:=Self.Items.Add;
//        ARow.RecordIndex:=-1;
    end;
  finally
    Self.Items.EndUpdate();
  end;



  if Self.FFooterRowCount>0 then
  begin
    UpdateFooter;
  end;


//  OldRowCount := RowCount;
//  if RowCount <= FTitleOffset then RowCount := FTitleOffset + 1;
//  FixedRows := FTitleOffset;
//  with FDataLink do
//    if not Active or (RecordCount = 0) or not HandleAllocated then
//      RowCount := 1 + FTitleOffset
//    else
//    begin
//      RowCount := 1000;
//      FDataLink.BufferCount := VisibleRowCount;
//      RowCount := RecordCount + FTitleOffset;
//      if dgRowSelect in Options then TopRow := FixedRows;
//      UpdateActive;
//    end;
//  if OldRowCount <> RowCount then Invalidate;
end;

//procedure TDBGridProperties.UpdateScrollBar;
//var
//  SIOld, SINew: TScrollInfo;
//  ScrollBarVisible: Boolean;
//begin
//  if FDatalink.Active and HandleAllocated then
//    with FDatalink.DataSet do
//    begin
//      SIOld.cbSize := sizeof(SIOld);
//      SIOld.fMask := SIF_ALL;
//      GetScrollInfo(Self.Handle, SB_VERT, SIOld);
//      SINew := SIOld;
//      if IsSequenced then
//      begin
//        ScrollBarVisible := RecordCount > 1;
//        if ScrollBarVisible then
//        begin
//          SINew.nMin := 1;
//          SINew.nPage := Self.VisibleRowCount;
//          SINew.nMax := Integer(DWORD(RecordCount) + SINew.nPage - 1);
//          if State in [dsInactive, dsBrowse, dsEdit] then
//            SINew.nPos := RecNo;  // else keep old pos
//        end;
//      end
//      else
//      begin
//        ScrollBarVisible := True;
//        SINew.nMin := 0;
//        SINew.nPage := 0;
//        SINew.nMax := 4;
//        if FDataLink.BOF then SINew.nPos := 0
//        else if FDataLink.EOF then SINew.nPos := 4
//        else SINew.nPos := 2;
//      end;
//      ShowScrollBar(Self.Handle, SB_VERT, ScrollBarVisible);
//      if ScrollBarVisible then
//        SetScrollInfo(Self.Handle, SB_VERT, SINew, True);
//    end;
//end;

//function TDBGridProperties.ValidFieldIndex(FieldIndex: Integer): Boolean;
//begin
//  Result := DataLink.GetMappedIndex(FieldIndex) >= 0;
//end;

//procedure TDBGridProperties.CMParentFontChanged(var Message: TMessage);
//begin
//  inherited;
//  if ParentFont then
//  begin
//    FSelfChangingTitleFont := True;
//    try
//      TitleFont := Font;
//    finally
//      FSelfChangingTitleFont := False;
//    end;
//    LayoutChanged;
//  end;
//end;
//
//procedure TDBGridProperties.CMBiDiModeChanged(var Message: TMessage);
//var
//  Loop: Integer;
//begin
//  inherited;
//  for Loop := 0 to ComponentCount - 1 do
//    if Components[Loop] is TDBGridProperties then
//      with Components[Loop] as TDBGridProperties do
//        { Changing the window, echos down to the subgrid }
//        if Parent <> nil then
//          Parent.BiDiMode := Self.BiDiMode;
//end;
//
//procedure TDBGridProperties.CMExit(var Message: TMessage);
//begin
//  try
//    if FDatalink.Active then
//      with FDatalink.Dataset do
//        if (dgCancelOnExit in Options) and (State = dsInsert) and
//          not Modified and not FDatalink.FModified then
//          Cancel else
//          FDataLink.UpdateData;
//  except
//    SetFocus;
//    raise;
//  end;
//  inherited;
//end;
//
//procedure TDBGridProperties.CMFontChanged(var Message: TMessage);
//var
//  I: Integer;
//begin
//  inherited;
//  BeginLayout;
//  try
//    for I := 0 to Columns.Count-1 do
//      Columns[I].RefreshDefaultFont;
//  finally
//    EndLayout;
//  end;
//end;
//
//procedure TDBGridProperties.CMDeferLayout(var Message);
//begin
//  if AcquireLayoutLock then
//    EndLayout
//  else
//    DeferLayout;
//end;
//
//procedure TDBGridProperties.CMDesignHitTest(var Msg: TCMDesignHitTest);
//var
//  MasterCol: TSkinDBGridColumn;
//begin
//  inherited;
//  if (Msg.Result = 1) and ((FDataLink = nil) or
//    ((Columns.State = csDefault) and
//     (FDataLink.DefaultFields or (not FDataLink.Active)))) then
//    Msg.Result := 0
//  else if (Msg.Result = 0) and (FDataLink <> nil) and (FDataLink.Active)
//    and (Columns.State = csCustomized)
//    and PtInExpandButton(Msg.XPos, Msg.YPos, MasterCol) then
//    Msg.Result := 1;
//end;
//
//procedure TDBGridProperties.WMSetCursor(var Msg: TWMSetCursor);
//begin
//  if (csDesigning in ComponentState) and
//      ((FDataLink = nil) or
//       ((Columns.State = csDefault) and
//        (FDataLink.DefaultFields or not FDataLink.Active))) then
//    Windows.SetCursor(LoadCursor(0, IDC_ARROW))
//  else inherited;
//end;
//
//procedure TDBGridProperties.WMSize(var Message: TWMSize);
//begin
//  inherited;
//  if UpdateLock = 0 then UpdateRowCount;
//  InvalidateTitles;
//end;
//
//procedure TDBGridProperties.WMVScroll(var Message: TWMVScroll);
//var
//  SI: TScrollInfo;
//begin
//  if not AcquireFocus then Exit;
//  if FDatalink.Active then
//    with Message, FDataLink.DataSet do
//      case ScrollCode of
//        SB_LINEUP: FDataLink.MoveBy(-FDatalink.ActiveRecord - 1);
//        SB_LINEDOWN: FDataLink.MoveBy(FDatalink.RecordCount - FDatalink.ActiveRecord);
//        SB_PAGEUP: FDataLink.MoveBy(-VisibleRowCount);
//        SB_PAGEDOWN: FDataLink.MoveBy(VisibleRowCount);
//        SB_THUMBPOSITION:
//          begin
//            if IsSequenced then
//            begin
//              SI.cbSize := sizeof(SI);
//              SI.fMask := SIF_ALL;
//              GetScrollInfo(Self.Handle, SB_VERT, SI);
//              if SI.nTrackPos <= 1 then First
//              else if SI.nTrackPos >= RecordCount then Last
//              else RecNo := SI.nTrackPos;
//            end
//            else
//              case Pos of
//                0: First;
//                1: FDataLink.MoveBy(-VisibleRowCount);
//                2: Exit;
//                3: FDataLink.MoveBy(VisibleRowCount);
//                4: Last;
//              end;
//          end;
//        SB_BOTTOM: Last;
//        SB_TOP: First;
//      end;
//end;
//
//procedure TDBGridProperties.SetIme;
//var
//  Column: TSkinDBGridColumn;
//begin
//  if Columns.Count = 0 then Exit;
//
//  ImeName := FOriginalImeName;
//  ImeMode := FOriginalImeMode;
//  Column := Columns[SelectedIndex];
//  if Column.IsImeNameStored then ImeName := Column.ImeName;
//  if Column.IsImeModeStored then ImeMode := Column.ImeMode;
//
//  if InplaceEditor <> nil then
//  begin
//    TDBGridInplaceEdit(InplaceEditor).ImeName := ImeName;
//    TDBGridInplaceEdit(InplaceEditor).ImeMode := ImeMode;
//  end;
//end;
//
//procedure TDBGridProperties.UpdateIme;
//begin
//  SetIme;
//  SetImeName(ImeName);
//  SetImeMode(Handle, ImeMode);
//end;
//
//procedure TDBGridProperties.WMIMEStartComp(var Message: TMessage);
//begin
//  inherited;
//  ShowEditor;
//end;
//
//procedure TDBGridProperties.WMSetFocus(var Message: TWMSetFocus);
//begin
//  if not ((InplaceEditor <> nil) and
//    (Message.FocusedWnd = InplaceEditor.Handle)) then SetIme;
//  inherited;
//end;
//
//procedure TDBGridProperties.WMKillFocus(var Message: TMessage);
//begin
//  ImeName := Screen.DefaultIme;
//  ImeMode := imDontCare;
//  inherited;
//  if not ((InplaceEditor <> nil) and
//    (HWND(Message.WParam) = InplaceEditor.Handle)) then
//    ActivateKeyboardLayout(Screen.DefaultKbLayout, KLF_ACTIVATE);
//end;
//
//{ Defer action processing to datalink }
//
//function TDBGridProperties.ExecuteAction(Action: TBasicAction): Boolean;
//begin
//  Result := (DataLink <> nil) and DataLink.ExecuteAction(Action);
//end;
//
//function TDBGridProperties.UpdateAction(Action: TBasicAction): Boolean;
//begin
//  Result := (DataLink <> nil) and DataLink.UpdateAction(Action);
//end;
//
//procedure TDBGridProperties.ShowPopupEditor(Column: TSkinDBGridColumn; X, Y: Integer);
//var
//  SubGrid: TDBGridProperties;
//  DS: TDataSource;
//  I: Integer;
//  FloatRect: TRect;
//  Cmp: TControl;
//begin
//  if not ((Column.Field <> nil) and (Column.Field is TDataSetField)) then  Exit;
//
//  // find existing popup for this column field, if any, and show it
//  for I := 0 to ComponentCount-1 do
//    if Components[I] is TDBGridProperties then
//    begin
//      SubGrid := TDBGridProperties(Components[I]);
//      if (SubGrid.DataSource <> nil) and
//        (SubGrid.DataSource.DataSet = (Column.Field as TDatasetField).NestedDataset) and
//        SubGrid.CanFocus then
//      begin
//        SubGrid.Parent.Show;
//        SubGrid.SetFocus;
//        Exit;
//      end;
//    end;
//
//  // create another instance of this kind of grid
//  SubGrid := TDBGridProperties(TComponentClass(Self.ClassType).Create(Self));
//  try
//    DS := TDataSource.Create(SubGrid); // incestuous, but easy cleanup
//    DS.Dataset := (Column.Field as TDatasetField).NestedDataset;
//    DS.DataSet.CheckBrowseMode;
//    SubGrid.DataSource := DS;
//    SubGrid.Columns.State := Columns.State;
//    SubGrid.Columns[0].Expanded := True;
//    SubGrid.Visible := False;
//    SubGrid.FloatingDockSiteClass := TCustomDockForm;
//    FloatRect.TopLeft := ClientToScreen(CellRect(Col, Row).BottomRight);
//    if X > Low(Integer) then FloatRect.Left := X;
//    if Y > Low(Integer) then FloatRect.Top := Y;
//    FloatRect.Right := FloatRect.Left + Width;
//    FloatRect.Bottom := FloatRect.Top + Height;
//    SubGrid.ManualFloat(FloatRect);
////    SubGrid.ManualDock(nil,nil,alClient);
//    SubGrid.Parent.BiDiMode := Self.BiDiMode; { This carries the BiDi setting }
//    I := SubGrid.CellRect(SubGrid.ColCount-1, 0).Right;
//    if (I > 0) and (I < Screen.Width div 2) then
//      SubGrid.Parent.ClientWidth := I
//    else
//      SubGrid.Parent.Width := Screen.Width div 4;
//    SubGrid.Parent.Height := Screen.Height div 4;
//    SubGrid.Align := alClient;
//    SubGrid.DragKind := dkDock;
//    SubGrid.Color := Color;
//    SubGrid.Ctl3D := Ctl3D;
//    SubGrid.Cursor := Cursor;
//    SubGrid.Enabled := Enabled;
//    SubGrid.FixedColor := FixedColor;
//    SubGrid.Font := Font;
//    SubGrid.HelpContext := HelpContext;
//    SubGrid.IMEMode := IMEMode;
//    SubGrid.IMEName := IMEName;
//    SubGrid.Options := Options;
//    Cmp := Self;
//    while (Cmp <> nil) and (TDBGridProperties(Cmp).PopupMenu = nil) do
//      Cmp := Cmp.Parent;
//    if Cmp <> nil then
//      SubGrid.PopupMenu := TDBGridProperties(Cmp).PopupMenu;
//    SubGrid.TitleFont := TitleFont;
//    SubGrid.Visible := True;
//    SubGrid.Parent.Show;
//  except
//    SubGrid.Free;
//    raise;
//  end;
//end;
//
//procedure TDBGridProperties.CalcSizingState(X, Y: Integer;
//  var State: TGridState; var Index, SizingPos, SizingOfs: Integer;
//  var FixedInfo: TGridDrawInfo);
//var
//  R: TGridCoord;
//begin
//  inherited CalcSizingState(X, Y, State, Index, SizingPos, SizingOfs, FixedInfo);
//  if (State = gsColSizing) and (FDataLink <> nil)
//    and (FDatalink.Dataset <> nil) and FDataLink.Dataset.ObjectView then
//  begin
//    R := MouseCoord(X, Y);
//    R.X := RawToDataColumn(R.X);
//    if (R.X >= 0) and (R.X < Columns.Count) and (Columns[R.X].Depth > R.Y) then
//      State := gsNormal;
//  end;
//end;
//
//function TDBGridProperties.CheckColumnDrag(var Origin, Destination: Integer;
//  const MousePt: TPoint): Boolean;
//var
//  I, ARow: Integer;
//  DestCol: TSkinDBGridColumn;
//begin
//  Result := inherited CheckColumnDrag(Origin, Destination, MousePt);
//  if Result and (FDatalink.Dataset <> nil) and FDatalink.Dataset.ObjectView then
//  begin
//    assert(FDragCol <> nil);
//    ARow := FDragCol.Depth;
//    if Destination <> Origin then
//    begin
//      DestCol := ColumnAtDepth(Columns[RawToDataColumn(Destination)], ARow);
//      if DestCol.ParentColumn <> FDragCol.ParentColumn then
//        if Destination < Origin then
//          DestCol := Columns[FDragCol.ParentColumn.Index+1]
//        else
//        begin
//          I := DestCol.Index;
//          while DestCol.ParentColumn <> FDragCol.ParentColumn do
//          begin
//            Dec(I);
//            DestCol := Columns[I];
//          end;
//        end;
//      if (DestCol.Index > FDragCol.Index) then
//      begin
//        I := DestCol.Index + 1;
//        while (I < Columns.Count) and (ColumnAtDepth(Columns[I],ARow) = DestCol) do
//          Inc(I);
//        DestCol := Columns[I-1];
//      end;
//      Destination := DataToRawColumn(DestCol.Index);
//    end;
//  end;
//end;
//
//function TDBGridProperties.BeginColumnDrag(var Origin, Destination: Integer;
//  const MousePt: TPoint): Boolean;
//var
//  I, ARow: Integer;
//begin
//  Result := inherited BeginColumnDrag(Origin, Destination, MousePt);
//  if Result and (FDatalink.Dataset <> nil) and FDatalink.Dataset.ObjectView then
//  begin
//    ARow := MouseCoord(MousePt.X, MousePt.Y).Y;
//    FDragCol := ColumnAtDepth(Columns[RawToDataColumn(Origin)], ARow);
//    if FDragCol = nil then Exit;
//    I := DataToRawColumn(FDragCol.Index);
//    if Origin <> I then Origin := I;
//    Destination := Origin;
//  end;
//end;
//
//function TDBGridProperties.EndColumnDrag(var Origin, Destination: Integer;
//  const MousePt: TPoint): Boolean;
//begin
//  Result := inherited EndColumnDrag(Origin, Destination, MousePt);
//  FDragCol := nil;
//end;
//
//procedure TDBGridProperties.InvalidateTitles;
//var
//  R: TRect;
//  DrawInfo: TGridDrawInfo;
//begin
//  if HandleAllocated and (dgTitles in Options) then
//  begin
//    CalcFixedInfo(DrawInfo);
//    R := Rect(0, 0, Width, DrawInfo.Vert.FixedBoundary);
//    InvalidateRect(Handle, @R, False);
//  end;
//end;
//
//procedure TDBGridProperties.TopLeftChanged;
//begin
//  InvalidateTitles;
//  inherited TopLeftChanged;
//end;



{ TSkinDBGridColumn }

constructor TSkinDBGridColumn.Create(Collection: TCollection);
//var
//  Grid: TDBGridProperties;
begin
//  Grid := nil;
//
//  if Assigned(Collection) and (Collection is TSkinDBGridColumns) then
//    Grid := TSkinDBGridColumns(Collection).FProperties;
//
//  if Assigned(Grid) then Grid.BeginLayout;
//  try

    inherited Create(Collection);

//    FDropDownRows := 7;
//    FButtonStyle := cbsAuto;
//    FFont := TFont.Create;
//    FFont.Assign(DefaultFont);
//    FFont.OnChange := FontChanged;
//    FImeMode := imDontCare;
//    FImeName := Screen.DefaultIme;
//    FTitle := CreateTitle;
//    FVisible := True;
//    FExpanded := True;
    FStored := True;

//  finally
//    if Assigned(Grid) then Grid.EndLayout;
//  end;
end;

destructor TSkinDBGridColumn.Destroy;
begin
//  FTitle.Free;
//  FFont.Free;
//  if FPickList<>nil then
//  begin
//    FreeAndNil(FPickList);
//  end;
  inherited Destroy;
end;

procedure TSkinDBGridColumn.DoPropChange(Sender:TObject);
begin
  inherited;
  Self.FStored:=True;
end;

procedure TSkinDBGridColumn.Assign(Source: TPersistent);
begin
  if Source is TSkinDBGridColumn then
  begin
    if Assigned(Collection) then Collection.BeginUpdate;
    try
      RestoreDefaults;

      FCaption:=TSkinDBGridColumn(Source).FCaption;
      FieldName := TSkinDBGridColumn(Source).FieldName;
//      if cvColor in TSkinDBGridColumn(Source).AssignedValues then
//        Color := TSkinDBGridColumn(Source).Color;
      if cvWidth in TSkinDBGridColumn(Source).AssignedValues then
        Width := TSkinDBGridColumn(Source).Width;
//      if cvFont in TSkinDBGridColumn(Source).AssignedValues then
//        Font := TSkinDBGridColumn(Source).Font;
//      if cvImeMode in TSkinDBGridColumn(Source).AssignedValues then
//        ImeMode := TSkinDBGridColumn(Source).ImeMode;
//      if cvImeName in TSkinDBGridColumn(Source).AssignedValues then
//        ImeName := TSkinDBGridColumn(Source).ImeName;
//      if cvAlignment in TSkinDBGridColumn(Source).AssignedValues then
//        Alignment := TSkinDBGridColumn(Source).Alignment;
      if cvReadOnly in TSkinDBGridColumn(Source).AssignedValues then
        ReadOnly := TSkinDBGridColumn(Source).ReadOnly;
//      Title := TSkinDBGridColumn(Source).Title;
//      DropDownRows := TSkinDBGridColumn(Source).DropDownRows;
//      ButtonStyle := TSkinDBGridColumn(Source).ButtonStyle;
      PickList := TSkinDBGridColumn(Source).PickList;
//      PopupMenu := TSkinDBGridColumn(Source).PopupMenu;
      FVisible := TSkinDBGridColumn(Source).FVisible;
//      FExpanded := TSkinDBGridColumn(Source).FExpanded;
    finally
      if Assigned(Collection) then Collection.EndUpdate;
    end;
  end
  else
  begin
    inherited Assign(Source);
  end;
end;

//function TSkinDBGridColumn.CreateTitle: TColumnTitle;
//begin
//  Result := TColumnTitle.Create(Self);
//end;
//
//function TSkinDBGridColumn.DefaultAlignment: TAlignment;
//begin
//  if Assigned(Field) then
//    Result := FField.Alignment
//  else
//    Result := taLeftJustify;
//end;
//
//function TSkinDBGridColumn.DefaultColor: TColor;
//var
//  Grid: TDBGridProperties;
//begin
//  Grid := GetProperties;
//  if Assigned(Grid) then
//    Result := Grid.FInternalColor
//  else
//    Result := clWindow;
//end;
//
//function TSkinDBGridColumn.DefaultFont: TFont;
//var
//  Grid: TDBGridProperties;
//begin
//  Grid := GetProperties;
//  if Assigned(Grid) then
//    Result := Grid.Font
//  else
//    Result := FFont;
//end;
//
//function TSkinDBGridColumn.DefaultImeMode: TImeMode;
//var
//  Grid: TDBGridProperties;
//begin
//  Grid := GetProperties;
//  if Assigned(Grid) then
//    Result := Grid.ImeMode
//  else
//    Result := FImeMode;
//end;
//
//function TSkinDBGridColumn.DefaultImeName: TImeName;
//var
//  Grid: TDBGridProperties;
//begin
//  Grid := GetProperties;
//  if Assigned(Grid) then
//    Result := Grid.ImeName
//  else
//    Result := FImeName;
//end;

function TSkinDBGridColumn.DefaultReadOnly: Boolean;
var
  Grid: TDBGridProperties;
begin
  Grid := Self.GetProperties;
  Result := (Assigned(Grid) and Grid.ReadOnly)
            or (Assigned(Field) and FField.ReadOnly);
end;

function TSkinDBGridColumn.DefaultWidth: Double;
//var
//  W: Double;
//  RestoreCanvas: Boolean;
//  TempDc: HDC;
//  TM: TTextMetric;
begin
    if Self.GetProperties = nil then
    begin
      Result := Const_DefaultColumnWidth;
      Exit;
    end;

    if Assigned(Field) then
    begin
        try
          Result :=
  //              Field.DisplayWidth
                  Const_DefaultColumnWidth
                  +GetStringWidth(Self.GetCaption,RectF(0,0,MaxInt,MaxInt));
              //(Canvas.TextWidth('0') - TM.tmOverhang)
  //          + TM.tmOverhang + 4;
  //        if dgTitles in Options then
  //        begin
  //          Canvas.Font := Title.Font;
  //          W := Canvas.TextWidth(Title.Caption) + 4;
  //          if Result < W then
  //            Result := W;
  //        end;
        finally
        end;
    end
    else
    begin
      Result := Const_DefaultColumnWidth;
    end;
end;

//procedure TSkinDBGridColumn.FontChanged;
//begin
//  Include(FAssignedValues, cvFont);
//  Title.RefreshDefaultFont;
//  Changed(False);
//end;
//
//function TSkinDBGridColumn.GetAlignment: TAlignment;
//begin
//  if cvAlignment in FAssignedValues then
//    Result := FAlignment
//  else
//    Result := DefaultAlignment;
//end;
//
//function TSkinDBGridColumn.GetColor: TColor;
//begin
//  if cvColor in FAssignedValues then
//    Result := FColor
//  else
//    Result := DefaultColor;
//end;
//
//function TSkinDBGridColumn.GetExpanded: Boolean;
//begin
//  Result := FExpanded and Expandable;
//end;

function TSkinDBGridColumn.GetField: TField;
//var
//  Grid: TDBGridProperties;
begin

  { Returns Nil if FieldName can't be found in dataset }
//  Grid := GetProperties;

  if (FField = nil)
    and (Length(FFieldName) > 0)
    and (Self.GetProperties<>nil)
    and Assigned(GetProperties.FDataLink.DataSet) then
  begin
    if GetProperties.FDatalink.Dataset.Active
      or (not GetProperties.FDatalink.DefaultFields) then
    begin
      SetField(GetProperties.FDatalink.Dataset.FindField(FieldName));
    end;
  end;
  Result := FField;

end;

//function TSkinDBGridColumn.GetFont: TFont;
//var
//  Save: TNotifyEvent;
//begin
//  if not (cvFont in FAssignedValues) and (FFont.Handle <> DefaultFont.Handle) then
//  begin
//    Save := FFont.OnChange;
//    FFont.OnChange := nil;
//    FFont.Assign(DefaultFont);
//    FFont.OnChange := Save;
//  end;
//  Result := FFont;
//end;

//function TSkinDBGridColumn.GetProperties: TDBGridProperties;
//begin
//  if Assigned(Collection) and (Collection is TSkinDBGridColumns) then
//    Result := TSkinDBGridColumns(Collection).Grid
//  else
//    Result := nil;
//end;

function TSkinDBGridColumn.GetBindItemFieldName: String;
begin
  Result:=Self.FFieldName;
end;

function TSkinDBGridColumn.GetBindItemFieldName1: String;
begin
  Result:='';
end;

function TSkinDBGridColumn.GetCaption: String;
begin
  Result := FCaption;
  if Result = '' then
  begin
    Result := GetDisplayName;
  end;
end;

//function TSkinDBGridColumn.GetContentTypes: TSkinGridColumnContentTypes;
//begin
//  if (Self.Field<>nil) and (Field.DataType=ftBoolean) then
//  begin
//    Result:=[cctCheckBox];
//  end
//  else
//  begin
//    Result:=Inherited;
//  end;
//end;

function TSkinDBGridColumn.GetProperties: TDBGridProperties;
begin
  if Assigned(Collection) and (Collection is TSkinDBGridColumns) then
  begin
    Result := TSkinDBGridColumns(Collection).GetProperties;
  end
  else
  begin
    Result := nil;
  end;
end;

//function TSkinDBGridColumn.GetDisplayName: string;
//begin
//  Result := FFieldName+' '+FCaption;
////  if Result = '' then
////  begin
////    Result := inherited GetDisplayName;
////  end;
//end;

//function TSkinDBGridColumn.GetImeMode: TImeMode;
//begin
//  if cvImeMode in FAssignedValues then
//    Result := FImeMode
//  else
//    Result := DefaultImeMode;
//end;
//
//function TSkinDBGridColumn.GetImeName: TImeName;
//begin
//  if cvImeName in FAssignedValues then
//    Result := FImeName
//  else
//    Result := DefaultImeName;
//end;
//
//function TSkinDBGridColumn.GetParentColumn: TSkinDBGridColumn;
//var
//  Col: TSkinDBGridColumn;
//  Fld: TField;
//  I: Integer;
//begin
//  Result := nil;
//  Fld := Field;
//  if (Fld <> nil) and (Fld.ParentField <> nil) and (Collection <> nil) then
//    for I := Index - 1 downto 0 do
//    begin
//      Col := TSkinDBGridColumn(Collection.Items[I]);
//      if Fld.ParentField = Col.Field then
//      begin
//        Result := Col;
//        Exit;
//      end;
//    end;
//end;
//
//function TSkinDBGridColumn.GetPickList: TStrings;
//begin
//  if FPickList = nil then
//    FPickList := TStringList.Create;
//  Result := FPickList;
//end;

function TSkinDBGridColumn.GetReadOnly: Boolean;
begin
  if cvReadOnly in FAssignedValues then
  begin
    Result := FReadOnly;
  end
  else
  begin
    Result := DefaultReadOnly;
  end;
end;

function TSkinDBGridColumn.GetValueType(ARow: TBaseSkinItem): TVarType;
begin
  if (Self.Field<>nil) and (Field.DataType=ftBoolean)
      or (FieldName='ItemChecked')
      or (FieldName='ItemSelected') then
  begin
    Result:=varBoolean;
  end
  else
  begin
    Result:=varString;
  end;
end;

//function TSkinDBGridColumn.GetShowing: Boolean;
//var
//  Col: TSkinDBGridColumn;
//begin
//  Result := not Expanded and Visible;
//  if Result then
//  begin
//    Col := Self;
//    repeat
//      Col := Col.ParentColumn;
//    until (Col = nil) or not Col.Expanded;
//    Result := Col = nil;
//  end;
//end;
//
//function TSkinDBGridColumn.GetVisible: Boolean;
//var
//  Col: TSkinDBGridColumn;
//begin
//  Result := FVisible;
//  if Result then
//  begin
//    Col := ParentColumn;
//    Result := Result and ((Col = nil) or Col.Visible);
//  end;
//end;

function TSkinDBGridColumn.GetWidth: Double;
begin
//  if not Showing then
//    Result := -1
//  else
  if cvWidth in FAssignedValues then
    Result := Inherited GetWidth
  else
    Result := DefaultWidth;
end;

//function TSkinDBGridColumn.IsAlignmentStored: Boolean;
//begin
//  Result := (cvAlignment in FAssignedValues) and (FAlignment <> DefaultAlignment);
//end;
//
//function TSkinDBGridColumn.IsColorStored: Boolean;
//begin
//  Result := (cvColor in FAssignedValues) and (FColor <> DefaultColor);
//end;
//
//function TSkinDBGridColumn.IsFontStored: Boolean;
//begin
//  Result := (cvFont in FAssignedValues);
//end;
//
//function TSkinDBGridColumn.IsImeModeStored: Boolean;
//begin
//  Result := (cvImeMode in FAssignedValues) and (FImeMode <> DefaultImeMode);
//end;
//
//function TSkinDBGridColumn.IsImeNameStored: Boolean;
//begin
//  Result := (cvImeName in FAssignedValues) and (FImeName <> DefaultImeName);
//end;

function TSkinDBGridColumn.IsReadOnlyStored: Boolean;
begin
  Result := (cvReadOnly in FAssignedValues)
          and (FReadOnly <> DefaultReadOnly);
end;

function TSkinDBGridColumn.IsWidthStored: Boolean;
begin
  Result := (cvWidth in FAssignedValues);//
//          and NotEqualDouble(FWidth,DefaultWidth);
end;

//procedure TSkinDBGridColumn.RefreshDefaultFont;
//var
//  Save: TNotifyEvent;
//begin
//  if cvFont in FAssignedValues then Exit;
//  Save := FFont.OnChange;
//  FFont.OnChange := nil;
//  try
//    FFont.Assign(DefaultFont);
//  finally
//    FFont.OnChange := Save;
//  end;
//end;

procedure TSkinDBGridColumn.RestoreDefaults;
//var
//  FontAssigned: Boolean;
begin
//  FontAssigned := cvFont in FAssignedValues;
//  FTitle.RestoreDefaults;
  FAssignedValues := [];
//  RefreshDefaultFont;
  FreeAndNil(FPickList);
//  ButtonStyle := cbsAuto;
//  Changed(FontAssigned);
end;

//procedure TSkinDBGridColumn.SetAlignment(Value: TAlignment);
//var
//  Grid: TDBGridProperties;
//begin
//  if IsStored then
//  begin
//    if (cvAlignment in FAssignedValues) and (Value = FAlignment) then Exit;
//    FAlignment := Value;
//    Include(FAssignedValues, cvAlignment);
//    Changed(False);
//  end
//  else
//  begin
//    Grid := GetProperties;
//    if Assigned(Grid) and (Grid.Datalink.Active) and Assigned(Field) then
//      Field.Alignment := Value;
//  end;
//end;
//
//procedure TSkinDBGridColumn.SetButtonStyle(Value: TColumnButtonStyle);
//begin
//  if Value = FButtonStyle then Exit;
//  FButtonStyle := Value;
//  Changed(False);
//end;
//
//procedure TSkinDBGridColumn.SetColor(Value: TColor);
//begin
//  if (cvColor in FAssignedValues) and (Value = FColor) then Exit;
//  FColor := Value;
//  Include(FAssignedValues, cvColor);
//  Changed(False);
//end;

procedure TSkinDBGridColumn.SetDateTimeFormat(const Value: String);
begin
  if FDateTimeFormat<>Value then
  begin
    FDateTimeFormat := Value;
    Self.DoPropChange;
  end;
end;

procedure TSkinDBGridColumn.SetValueFormat(const Value: String);
begin
  if FValueFormat<>Value then
  begin
    FValueFormat := Value;
    Self.DoPropChange;
  end;
end;

procedure TSkinDBGridColumn.SetField(Value: TField);
begin
  //相同就不处理
  if FField = Value then Exit;

//  //如果不同,那么释放并取消引用
//  if Assigned(FField) and (GetProperties <> nil) then
//    FField.RemoveFreeNotification(GetProperties);

  if Assigned(Value) and (csDestroying in Value.ComponentState) then
  begin
    Value := nil;    // don't acquire references to fields being destroyed
  end;

  FField := Value;

  if Assigned(Value) then
  begin
//    if GetProperties <> nil then
//      FField.FreeNotification(GetProperties);
    FFieldName := Value.FullName;
  end;

  if not IsStored then
  begin
    if Value = nil then
    begin
      FFieldName := '';
      RestoreDefaults;
    end;
  end;

  //需要重新计算一下列宽,暂时去掉,因为太耗时
  //Self.DoSizeChange;

  //Changed(False);
end;

procedure TSkinDBGridColumn.SetFieldName(const Value: WideString);
var
  AField: TField;
//  Grid: TDBGridProperties;
begin
  AField := nil;
//  Grid := GetProperties;
  if (Self.GetProperties<>nil)
    and Assigned(GetProperties.FDataLink.DataSet)
//  and
//    not (csLoading in GetProperties.ComponentState)
    and (Length(Value) > 0) then
  begin
    AField := GetProperties.FDataLink.DataSet.FindField(Value); { no exceptions }
  end;
  FFieldName := Value;
  SetField(AField);
end;

//procedure TSkinDBGridColumn.SetFont(Value: TFont);
//begin
//  FFont.Assign(Value);
//  Include(FAssignedValues, cvFont);
//  Changed(False);
//end;
//
//procedure TSkinDBGridColumn.SetImeMode(Value: TImeMode);
//begin
//  if (cvImeMode in FAssignedValues) or (Value <> DefaultImeMode) then
//  begin
//    FImeMode := Value;
//    Include(FAssignedValues, cvImeMode);
//  end;
//  Changed(False);
//end;
//
//procedure TSkinDBGridColumn.SetImeName(Value: TImeName);
//begin
//  if (cvImeName in FAssignedValues) or (Value <> DefaultImeName) then
//  begin
//    FImeName := Value;
//    Include(FAssignedValues, cvImeName);
//  end;
//  Changed(False);
//end;
//
//procedure TSkinDBGridColumn.SetIndex(Value: Integer);
//var
//  Grid: TDBGridProperties;
//  Fld: TField;
//  I, OldIndex: Integer;
//  Col: TSkinDBGridColumn;
//begin
//  OldIndex := Index;
//  Grid := GetProperties;
//
//  if IsStored then
//  begin
//    Grid.BeginLayout;
//    try
//      I := OldIndex + 1;  // move child columns along with parent
//      while (I < Collection.Count) and (TSkinDBGridColumn(Collection.Items[I]).ParentColumn = Self) do
//        Inc(I);
//      Dec(I);
//      if OldIndex > Value then   // column moving left
//      begin
//        while I > OldIndex do
//        begin
//          Collection.Items[I].Index := Value;
//          Inc(OldIndex);
//        end;
//        inherited SetIndex(Value);
//      end
//      else
//      begin
//        inherited SetIndex(Value);
//        while I > OldIndex do
//        begin
//          Collection.Items[OldIndex].Index := Value;
//          Dec(I);
//        end;
//      end;
//    finally
//      Grid.EndLayout;
//    end;
//  end
//  else
//  begin
//    if (Grid <> nil) and Grid.Datalink.Active then
//    begin
//      if Grid.AcquireLayoutLock then
//      try
//        Col := Grid.ColumnAtDepth(Grid.Columns[Value], Depth);
//        if (Col <> nil) then
//        begin
//          Fld := Col.Field;
//          if Assigned(Fld) then
//            Field.Index := Fld.Index;
//        end;
//      finally
//        Grid.EndLayout;
//      end;
//    end;
//    inherited SetIndex(Value);
//  end;
//end;

//procedure TSkinDBGridColumn.SetPickList(Value: TStrings);
//begin
//  if Value = nil then
//  begin
//    FPickList.Free;
//    FPickList := nil;
//    Exit;
//  end;
//  PickList.Assign(Value);
//end;
//
//procedure TSkinDBGridColumn.SetPopupMenu(Value: TPopupMenu);
//begin
//  FPopupMenu := Value;
//  if Value <> nil then Value.FreeNotification(GetProperties);
//end;

procedure TSkinDBGridColumn.SetReadOnly(Value: Boolean);
var
  Grid: TDBGridProperties;
begin
  Grid := Self.GetProperties;
  if not IsStored and Assigned(Grid) and Grid.Datalink.Active and Assigned(Field) then
    Field.ReadOnly := Value
  else
  begin
    if (cvReadOnly in FAssignedValues) and (Value = FReadOnly) then Exit;
    FReadOnly := Value;
    Include(FAssignedValues, cvReadOnly);
    //Changed(False);
  end;
end;

//procedure TSkinDBGridColumn.SetTitle(Value: TColumnTitle);
//begin
//  FTitle.Assign(Value);
//end;

procedure TSkinDBGridColumn.SetWidth(const Value: Double);
var
  Grid: TDBGridProperties;
  DoSetWidth: Boolean;
begin
  DoSetWidth := IsStored;
  if not DoSetWidth then
  begin
      Grid := GetProperties;
      if Assigned(Grid) then
      begin
        if
          Assigned(Field)
  //        and Grid.FUpdateFields
          then
        begin
  //        with Grid do
  //        begin
  //          Canvas.Font := Self.Font;
  //          GetTextMetrics(Canvas.Handle, TM);
  //          Field.DisplayWidth :=
                //(Value + (TM.tmAveCharWidth div 2) - TM.tmOverhang - 3)
  //            div TM.tmAveCharWidth;
  //        end;
        end;

        if (not Grid.FLayoutFromDataset)
           or (cvWidth in FAssignedValues) then
        begin
          DoSetWidth := True;
        end;

      end
      else
      begin
        DoSetWidth := True;
      end;
  end;

  if DoSetWidth then
  begin
//      if //(
//      (cvWidth in FAssignedValues)
////        or NotEqualDouble(Value,DefaultWidth))
//         then
//      begin
        //先
        Include(FAssignedValues, cvWidth);
        //再
        Inherited SetWidth(Value);

//      end;
      //Changed(False);
  end;

end;

//procedure TSkinDBGridColumn.SetVisible(Value: Boolean);
//begin
//  if Value <> FVisible then
//  begin
//    FVisible := Value;
//    Changed(True);
//  end;
//end;
//
//procedure TSkinDBGridColumn.SetExpanded(Value: Boolean);
//const
//  Direction: array [Boolean] of ShortInt = (-1,1);
//var
//  Grid: TDBGridProperties;
//  WasShowing: Boolean;
//begin
//  if Value <> FExpanded then
//  begin
//    Grid := GetProperties;
//    WasShowing := (Grid <> nil) and Grid.Columns[Grid.SelectedIndex].Showing;
//    FExpanded := Value;
//    Changed(True);
//    if (Grid <> nil) and WasShowing then
//    begin
//      if not Grid.Columns[Grid.SelectedIndex].Showing then
//        // The selected cell was hidden by this expand operation
//        // Select 1st child (next col = 1) when parent is expanded
//        // Select child's parent (prev col = -1) when parent is collapsed
//        Grid.MoveCol(Grid.Col, Direction[FExpanded]);
//    end;
//  end;
//end;
//
//function TSkinDBGridColumn.Depth: Integer;
//var
//  Col: TSkinDBGridColumn;
//begin
//  Result := 0;
//  Col := ParentColumn;
//  if Col <> nil then Result := Col.Depth + 1;
//end;
//
//function TSkinDBGridColumn.GetExpandable: Boolean;
//var
//  Fld: TField;
//begin
//  Fld := Field;
//  Result := (Fld <> nil) and (Fld.DataType in [ftADT, ftArray]);
//end;


{ TSkinDBGridColumns }

constructor TSkinDBGridColumns.Create(AProperties:TVirtualGridProperties;
                                      ItemClass: TCollectionItemClass);
begin
  inherited Create(AProperties,ItemClass);
end;

function TSkinDBGridColumns.FindItemByFieldName(AFieldName: String): TSkinDBGridColumn;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Self.Count-1 do
  begin
    if Items[I].FieldName=AFieldName then
    begin
      Result:=Items[I];
      Break;
    end;
  end;
end;

function TSkinDBGridColumns.Add: TSkinDBGridColumn;
begin
  Result := TSkinDBGridColumn(inherited Add);
end;

function TSkinDBGridColumns.GetColumn(Index: Integer): TSkinDBGridColumn;
begin
  Result := TSkinDBGridColumn(inherited Items[Index]);
end;

function TSkinDBGridColumns.GetProperties: TDBGridProperties;
begin
  Result:=TDBGridProperties(FVirtualGridProperties);
end;

//function TSkinDBGridColumns.GetOwner: TPersistent;
//begin
//  Result := FProperties;//FGrid;
//end;
//
//procedure TSkinDBGridColumns.LoadFromFile(const Filename: string);
//var
//  S: TFileStream;
//begin
//  S := TFileStream.Create(Filename, fmOpenRead);
//  try
//    LoadFromStream(S);
//  finally
//    S.Free;
//  end;
//end;
//
//type
//  TColumnsWrapper = class(TComponent)
//  private
//    FColumns: TSkinDBGridColumns;
//  published
//    property Columns: TSkinDBGridColumns read FColumns write FColumns;
//  end;
//
//procedure TSkinDBGridColumns.LoadFromStream(S: TStream);
//var
//  Wrapper: TColumnsWrapper;
//begin
//  Wrapper := TColumnsWrapper.Create(nil);
//  try
//    Wrapper.Columns := FGrid.CreateColumns;
//    S.ReadComponent(Wrapper);
//    Assign(Wrapper.Columns);
//  finally
//    Wrapper.Columns.Free;
//    Wrapper.Free;
//  end;
//end;

procedure TSkinDBGridColumns.RestoreDefaults;
var
  I: Integer;
begin
  BeginUpdate;
  try
    for I := 0 to Count-1 do
      Items[I].RestoreDefaults;
  finally
    EndUpdate;
  end;
end;

procedure TSkinDBGridColumns.RebuildColumns;

  procedure AddFields(Fields: TFields
                      //  ; Depth: Integer
                        );
  var
    I: Integer;
  begin
//    Inc(Depth);
    for I := 0 to Fields.Count-1 do
    begin
      Add.FieldName := Fields[I].FullName;
//      if Fields[I].DataType in [ftADT, ftArray] then
//      begin
//        AddFields((Fields[I] as TObjectField).Fields, Depth);
//      end;
    end;
  end;

begin
  if Assigned(Self.FVirtualGridProperties)
    and Assigned(GetProperties.FDataLink.DataSource)
    and Assigned(GetProperties.FDataLink.Datasource.Dataset) then
  begin
    Self.GetProperties.BeginLayout;
    try
      Clear;
      AddFields(GetProperties.FDataLink.Datasource.Dataset.Fields
          //, 0
          );
    finally
      GetProperties.EndLayout;
    end
  end
  else
  begin
    Clear;
  end;
end;

//procedure TSkinDBGridColumns.SaveToFile(const Filename: string);
//var
//  S: TStream;
//begin
//  S := TFileStream.Create(Filename, fmCreate);
//  try
//    SaveToStream(S);
//  finally
//    S.Free;
//  end;
//end;
//
//procedure TSkinDBGridColumns.SaveToStream(S: TStream);
//var
//  Wrapper: TColumnsWrapper;
//begin
//  Wrapper := TColumnsWrapper.Create(nil);
//  try
//    Wrapper.Columns := Self;
//    S.WriteComponent(Wrapper);
//  finally
//    Wrapper.Free;
//  end;
//end;
//
procedure TSkinDBGridColumns.SetColumn(Index: Integer; Value: TSkinDBGridColumn);
begin
  Items[Index].Assign(Value);
end;

procedure TSkinDBGridColumns.SetState(NewState: TSkinDBGridColumnsState);
begin
  if NewState = State then
  begin
    Exit;
  end;
  if NewState = csDefault then
  begin
    //清除
    Clear;
  end
  else
  begin
    //如果是手动设置的表格列,重建
    RebuildColumns;
  end;
end;

//procedure TSkinDBGridColumns.Update(Item: TCollectionItem);
////var
////  Raw: Integer;
//begin
//  Inherited;
//  //表格列数据更改
//  if (Self.FProperties = nil)
//    or (csLoading in FProperties.FSkinControl.ComponentState) then
//  begin
//    Exit;
//  end;
//
//  if Item = nil then
//  begin
//    //FProperties.LayoutChanged;
//  end
//  else
//  begin
////    Raw := FGrid.DataToRawColumn(Item.Index);
////    FGrid.InvalidateCol(Raw);
////    FGrid.ColWidths[Raw] := TSkinDBGridColumn(Item).Width;
//  end;
//end;

function TSkinDBGridColumns.InternalAdd: TSkinDBGridColumn;
begin
  Result := Add;
  Result.IsStored := False;
end;

function TSkinDBGridColumns.GetState: TSkinDBGridColumnsState;
begin
  Result := TSkinDBGridColumnsState((Count > 0) and Items[0].IsStored);
end;



{ TBookmarkList }

constructor TBookmarkList.Create(AProperties:TDBGridProperties);
begin
  inherited Create;

  SetLength(FList, 0);

  FProperties:=AProperties;
end;

destructor TBookmarkList.Destroy;
begin
  Clear;
  inherited Destroy;
end;

procedure TBookmarkList.Clear;
begin
  if Length(FList) = 0 then Exit;
  SetLength(FList, 0);
//  FGrid.Invalidate;
end;

function TBookmarkList.Compare(const Item1, Item2: TBookmark): Integer;
begin
//  with FProperties.FDatalink.Datasource.Dataset do
  Result := FProperties.FDatalink.Datasource.Dataset.CompareBookmarks(TBookmark(Item1), TBookmark(Item2));
end;

function TBookmarkList.CurrentRow: TBookmark;
begin
  if not FLinkActive then
  begin
    Raise EInvalidGridOperation.Create(sDataSetClosed);
  end;
  Result := FProperties.FDatalink.Datasource.Dataset.Bookmark;
end;

function TBookmarkList.GetCurrentRowSelected: Boolean;
var
  Index: Integer;
begin
  Result := Find(CurrentRow, Index);
end;

function TBookmarkList.Find(const Item: TBookmark; var Index: Integer): Boolean;
var
  L, H, I, C: Integer;
begin
  if (Item = FCache) and (FCacheIndex >= 0) then
  begin
    Index := FCacheIndex;
    Result := FCacheFind;
    Exit;
  end;

  Result := False;
  L := 0;
  H := Length(FList) - 1;
  while L <= H do
  begin
    I := (L + H) shr 1;
    C := Compare(FList[I], Item);
    if C < 0 then L := I + 1 else
    begin
      H := I - 1;
      if C = 0 then
      begin
        Result := True;
        L := I;
      end;
    end;
  end;

  Index := L;
  FCache := Item;
  FCacheIndex := Index;
  FCacheFind := Result;
end;

function TBookmarkList.GetCount: Integer;
begin
  Result := Length(FList);
end;

function TBookmarkList.GetItem(Index: Integer): TBookmark;
begin
  Result := FList[Index];
end;

function TBookmarkList.IndexOf(const Item: TBookmark): Integer;
begin
  if not Find(Item, Result) then
  begin
    Result := -1;
  end;
end;

procedure TBookmarkList.LinkActive(Value: Boolean);
begin
  Clear;
  FLinkActive := Value;
end;

procedure TBookmarkList.Delete;
var
  I: Integer;
begin
//  with Self.FProperties.Datalink.Datasource.Dataset do
//  begin
  Self.FProperties.Datalink.Datasource.Dataset.DisableControls;
  try
    for I := Length(FList)-1 downto 0 do
    begin
      Self.FProperties.Datalink.Datasource.Dataset.Bookmark := FList[I];
      Self.FProperties.Datalink.Datasource.Dataset.Delete;
      DeleteItem(I);
    end;
  finally
    Self.FProperties.Datalink.Datasource.Dataset.EnableControls;
  end;
//  end;
end;

function TBookmarkList.Refresh: Boolean;
var
  I: Integer;
begin
  Result := False;
//  with FGrid.DataLink.Datasource.Dataset do
  try
    FProperties.DataLink.Datasource.Dataset.CheckBrowseMode;
    for I := Length(FList) - 1 downto 0 do
      if not FProperties.DataLink.Datasource.Dataset.BookmarkValid(TBookmark(FList[I])) then
      begin
        Result := True;
        DeleteItem(I);
      end;
  finally
    FProperties.DataLink.Datasource.Dataset.UpdateCursorPos;
//    if Result then FGrid.Invalidate;
  end;
end;

procedure TBookmarkList.DeleteItem(Index: Integer);
var
  Temp: Pointer;
begin
  if (Index < 0) or (Index >= Count) then
  begin
    raise EListError.Create(SListIndexError);
  end;

  Temp := FList[Index];

  // The Move below will overwrite this slot, so we need to finalize it first
  FList[Index] := nil;

  if Index < Count-1 then
  begin
    System.Move(
      FList[Index + 1],
      FList[Index],
      (Count - Index - 1) * SizeOf(Pointer)
      );
    // Make sure we don't finalize the item that was in the last position.
    PPointer(@FList[Count-1])^ := nil;
  end;
  SetLength(FList, Count-1);
  DataChanged(Temp);
end;

procedure TBookmarkList.InsertItem(Index: Integer; Item: TBookmark);
begin
  if (Index < 0) or (Index > Count) then
    raise EListError.Create(SListIndexError);
  SetLength(FList, Count + 1);
  if Index < Count - 1 then
  begin
    Move(FList[Index], FList[Index + 1],
      (Count - Index - 1) * SizeOf(Pointer));
    // The slot we opened up with the Move above has a dangling pointer we don't want finalized
    PPointer(@FList[Index])^ := nil;
  end;
  FList[Index] := Item;
  DataChanged(TObject(Item));
end;

procedure TBookmarkList.SetCurrentRowSelected(Value: Boolean);
var
  Index: Integer;
  Current: TBookmark;
begin
  Current := CurrentRow;
  if (Length(Current) = 0) or (Find(Current, Index) = Value) then Exit;
  if Value then
    InsertItem(Index, Current)
  else
    DeleteItem(Index);
//  FGrid.InvalidateRow(FGrid.Row);
end;

procedure TBookmarkList.DataChanged(Sender: TObject);
begin
  FCache := nil;
  FCacheIndex := -1;
end;

//{ TColumnTitle }
//
//function TColumnTitle.IsColorStored: Boolean;
//begin
//  Result := (cvTitleColor in FColumn.FAssignedValues) and
//    (FColor <> DefaultColor);
//end;
//
//function TColumnTitle.IsFontStored: Boolean;
//begin
//  Result := (cvTitleFont in FColumn.FAssignedValues);
//end;
//
//function TColumnTitle.IsCaptionStored: Boolean;
//begin
//  Result := (cvTitleCaption in FColumn.FAssignedValues) and
//    (FCaption <> DefaultCaption);
//end;
//
//procedure TColumnTitle.RefreshDefaultFont;
//var
//  Save: TNotifyEvent;
//begin
//  if (cvTitleFont in FColumn.FAssignedValues) then Exit;
//  Save := FFont.OnChange;
//  FFont.OnChange := nil;
//  try
//    FFont.Assign(DefaultFont);
//  finally
//    FFont.OnChange := Save;
//  end;
//end;
//
//procedure TColumnTitle.RestoreDefaults;
//var
//  FontAssigned: Boolean;
//begin
//  FontAssigned := cvTitleFont in FColumn.FAssignedValues;
//  FColumn.FAssignedValues := FColumn.FAssignedValues - ColumnTitleValues;
//  FCaption := '';
//  RefreshDefaultFont;
//  { If font was assigned, changing it back to default may affect grid title
//    height, and title height changes require layout and redraw of the grid. }
//  FColumn.Changed(FontAssigned);
//end;
//
//procedure TColumnTitle.SetAlignment(Value: TAlignment);
//begin
//  if (cvTitleAlignment in FColumn.FAssignedValues) and (Value = FAlignment) then Exit;
//  FAlignment := Value;
//  Include(FColumn.FAssignedValues, cvTitleAlignment);
//  FColumn.Changed(False);
//end;
//
//procedure TColumnTitle.SetColor(Value: TColor);
//begin
//  if (cvTitleColor in FColumn.FAssignedValues) and (Value = FColor) then Exit;
//  FColor := Value;
//  Include(FColumn.FAssignedValues, cvTitleColor);
//  FColumn.Changed(False);
//end;
//
//procedure TColumnTitle.SetFont(Value: TFont);
//begin
//  FFont.Assign(Value);
//end;
//
//procedure TColumnTitle.SetCaption(const Value: string);
//var
//  Grid: TDBGridProperties;
//begin
//  if Column.IsStored then
//  begin
//    if (cvTitleCaption in FColumn.FAssignedValues) and (Value = FCaption) then Exit;
//    FCaption := Value;
//    Include(Column.FAssignedValues, cvTitleCaption);
//    Column.Changed(False);
//  end
//  else
//  begin
//    Grid := Column.GetProperties;
//    if Assigned(Grid) and (Grid.Datalink.Active) and Assigned(Column.Field) then
//      Column.Field.DisplayLabel := Value;
//  end;
//end;




{ TSkinDBGridRows }

function TSkinDBGridRows.Add: TSkinDBGridRow;
begin
  Result:=TSkinDBGridRow(Inherited Add);
end;

//function TSkinDBGridRows.CreateBinaryObject(const AClassName:String=''): TInterfacedPersistent;
//begin
//  Result:=TSkinDBGridRow.Create;//(Self);
//end;

procedure TSkinDBGridRows.DoAdd(AObject: TObject);
begin
  inherited;

  {$IFDEF FREE_VERSION}
  if Count=200 then
  begin
    ShowMessage('OrangeUI免费版限制(Grid只能200条记录数)');
  end;
  {$ENDIF}

end;

function TSkinDBGridRows.GetSkinItemClass: TBaseSkinItemClass;
begin
  Result:=TSkinDBGridRow;
end;

{ TSkinDBGrid }

function TSkinDBGrid.Material:TSkinDBGridDefaultMaterial;
begin
  Result:=TSkinDBGridDefaultMaterial(SelfOwnMaterial);
end;

function TSkinDBGrid.SelfOwnMaterialToDefault:TSkinDBGridDefaultMaterial;
begin
  Result:=TSkinDBGridDefaultMaterial(SelfOwnMaterial);
end;

function TSkinDBGrid.CurrentUseMaterialToDefault:TSkinDBGridDefaultMaterial;
begin
  Result:=TSkinDBGridDefaultMaterial(CurrentUseMaterial);
end;

function TSkinDBGrid.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TDBGridProperties;
end;

function TSkinDBGrid.GetDBGridProperties: TDBGridProperties;
begin
  Result:=TDBGridProperties(Self.FProperties);
end;

procedure TSkinDBGrid.SetDBGridProperties(Value: TDBGridProperties);
begin
  Self.FProperties.Assign(Value);
end;



{ TSkinDBGridRow }

//constructor TSkinDBGridRow.Create;
//begin
//  inherited;
//
//end;
//
//destructor TSkinDBGridRow.Destroy;
//begin
//
//  inherited;
//end;

end.



