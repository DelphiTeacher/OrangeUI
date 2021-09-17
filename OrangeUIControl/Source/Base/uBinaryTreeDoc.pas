//convert pas to utf8 by ¥

/// <summary>
///   <para>
///     存储文档
///   </para>
///   <para>
///     Store document
///   </para>
/// </summary>
unit uBinaryTreeDoc;

interface
{$I FrameWork.inc}

uses
  SysUtils,
  Classes,

  {$IFDEF VCL}
  Windows,
  Graphics,
  {$ENDIF}

  {$IFDEF FMX}
  UITypes,
  Types,
  {$ENDIF}

  uBaseLog,
  uFuncCommon,
  uGraphicCommon;





const
  { Binary Tree Document Version 2.0 }
  BTDOC_VERSION_20 = 20;
  IID_ISupportClassDocNode:TGUID='{E150284B-46F9-4F13-B2E2-FA4017667A5D}';






type
  { Binary Tree Node Type }
  TBTNodeType20 = (
    nt20_Directory = 0,
//    nt20_AnsiChar = 1,
//    nt20_WideChar = 2,
//    nt20_AnsiString = 3,
    nt20_WideString = 4,
//    nt20_Int8 = 5,
//    nt20_Int16 = 6,
    nt20_Int32 = 7,
//    nt20_Int64 = 8,
    nt20_UInt8 = 9,
//    nt20_UInt16 = 10,
    nt20_UInt32 = 11,
//    nt20_Real32 = 12,
//    nt20_Real48 = 13,
    nt20_Real64 = 14,
//    nt20_Real80 = 15,
//    nt20_Currency = 16,
    nt20_DateTime = 17,
//    nt20_TimeStamp = 18,
//    nt20_Bool8 = 19,
//    nt20_Bool16 = 20,
    nt20_Bool32 = 21,
//    nt20_Guid = 22,
    nt20_Binary = 23,
    nt20_Class = 24,
    nt20_Color = 25,
    nt20_Font = 26
  );







type
//  AnsiChar=Char;
//  PAnsiChar=PChar;
//  AnsiString=String;
  WideString=String;

  TBTNodeList20=class;

//  TBTNode20_AnsiChar=class;
//  TBTNode20_AnsiString=class;
  TBTNode20_Binary=class;
//  TBTNode20_Bool16=class;
  TBTNode20_Bool32=class;
//  TBTNode20_Bool8=class;
//  TBTNode20_Currency=class;
  TBTNode20_DateTime=class;
  TBTNode20_Directory=class;
  TBTNode20_Class=class;
//  TBTNode20_Guid=class;
//  TBTNode20_Int16=class;
  TBTNode20_Int32=class;
//  TBTNode20_Int64=class;
//  TBTNode20_Int8=class;
//  TBTNode20_Real32=class;
//  TBTNode20_Real48=class;
  TBTNode20_Real64=class;
//  TBTNode20_Real80=class;
//  TBTNode20_TimeStamp=class;
//  TBTNode20_UInt16=class;
  TBTNode20_UInt32=class;
  TBTNode20_UInt8=class;
//  TBTNode20_WideChar=class;
  TBTNode20_WideString=class;
//  TBTNode20_Font=class;
  TBTNode20_Color=class;




  //文档加载保存接口
  ISupportClassDocNode=interface
  ['{E150284B-46F9-4F13-B2E2-FA4017667A5D}']
    //从文档节点中加载
    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;
    //保存到文档节点
    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;
  end;





{ Custom Node }

  TBTNode20 = class(TObject)
  private
    FNodeName: WideString;
    FParentNode: TBTNode20;
    FChildNodes: TBTNodeList20;
    FNodeCaption: WideString;

    procedure SetParentNode(const Value: TBTNode20);
    procedure SetNodeName(const Value: WideString);
    procedure SetNodeCaption(const Value: WideString);
  protected
    FNodeType: TBTNodeType20;
    FDataSize: DWORD;

    procedure ClearData; virtual;
  public
    constructor Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString=''); virtual;
    destructor Destroy; override;

    function FindChildNodeByName(ANodeName: WideString):TBTNode20;

    function AddChildNode(ANodeType: TBTNodeType20; ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;

//    function AddChildNode_AnsiChar(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
//    function AddChildNode_AnsiString(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
    function AddChildNode_Binary(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
//    function AddChildNode_Bool16(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
    function AddChildNode_Bool32(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
//    function AddChildNode_Bool8(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
//    function AddChildNode_Currency(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
    function AddChildNode_DateTime(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
    function AddChildNode_Directory(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
    function AddChildNode_Class(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
//    function AddChildNode_Guid(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
//    function AddChildNode_Int16(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
    function AddChildNode_Int32(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
//    function AddChildNode_Int64(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
//    function AddChildNode_Int8(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
//    function AddChildNode_Real32(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
//    function AddChildNode_Real48(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
    function AddChildNode_Real64(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
//    function AddChildNode_Real80(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
//    function AddChildNode_TimeStamp(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
//    function AddChildNode_UInt16(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
    function AddChildNode_UInt32(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
    function AddChildNode_UInt8(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
//    function AddChildNode_WideChar(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
    function AddChildNode_WideString(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
//    function AddChildNode_Font(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
    function AddChildNode_Color(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;

//    function ConvertNode_AnsiChar: TBTNode20_AnsiChar;
//    function ConvertNode_AnsiString: TBTNode20_AnsiString;
    function ConvertNode_Binary: TBTNode20_Binary;
//    function ConvertNode_Bool16: TBTNode20_Bool16;
    function ConvertNode_Bool32: TBTNode20_Bool32;
//    function ConvertNode_Bool8: TBTNode20_Bool8;
//    function ConvertNode_Currency: TBTNode20_Currency;
    function ConvertNode_DateTime: TBTNode20_DateTime;
    function ConvertNode_Directory: TBTNode20_Directory;
    function ConvertNode_Class: TBTNode20_Class;
//    function ConvertNode_Guid: TBTNode20_Guid;
//    function ConvertNode_Int16: TBTNode20_Int16;
    function ConvertNode_Int32: TBTNode20_Int32;
//    function ConvertNode_Int64: TBTNode20_Int64;
//    function ConvertNode_Int8: TBTNode20_Int8;
//    function ConvertNode_Real32: TBTNode20_Real32;
//    function ConvertNode_Real48: TBTNode20_Real48;
    function ConvertNode_Real64: TBTNode20_Real64;
//    function ConvertNode_Real80: TBTNode20_Real80;
//    function ConvertNode_TimeStamp: TBTNode20_TimeStamp;
//    function ConvertNode_UInt16: TBTNode20_UInt16;
    function ConvertNode_UInt32: TBTNode20_UInt32;
    function ConvertNode_UInt8: TBTNode20_UInt8;
//    function ConvertNode_WideChar: TBTNode20_WideChar;
    function ConvertNode_WideString: TBTNode20_WideString;
//    function ConvertNode_Font: TBTNode20_Font;
    function ConvertNode_Color: TBTNode20_Color;


    procedure ReadBuffer(var ADest:Pointer); virtual;
    procedure WriteBuffer(const ASource:Pointer; ACount: Integer); virtual;

    property ParentNode: TBTNode20 read FParentNode write SetParentNode;
    property ChildNodes: TBTNodeList20 read FChildNodes;
    property NodeType: TBTNodeType20 read FNodeType;
    property NodeName: WideString read FNodeName write SetNodeName;
    property NodeCaption: WideString read FNodeCaption write SetNodeCaption;
    property DataSize: DWORD read FDataSize;
  end;


{ Node List }

  TBTNodeList20 = class(TObject)
  private
    FOwnerNode: TBTNode20;
    FItems: TList;

    function GetCount: Integer;
    function GetItems(Index: Integer): TBTNode20;
    procedure SetItems(Index: Integer; const Value: TBTNode20);
  public
    constructor Create(AOwnerNode: TBTNode20); virtual;
    destructor Destroy; override;

    function FindNodeByName(ANodeName: WideString): TBTNode20;
    function FindNodeByLeftPartName(ALeftPartNodeName: WideString): TBTNode20;

    function Add(ANode: TBTNode20): Integer;
    procedure Clear;
    procedure Delete(Index: Integer);
    function IndexOf(ANode: TBTNode20): Integer;
    procedure Insert(Index: Integer; ANode: TBTNode20);
    procedure Move(CurIndex, NewIndex: Integer);
    function Remove(ANode: TBTNode20): Integer;
    property Items[Index: Integer]: TBTNode20 read GetItems write SetItems;default;
    property Count: Integer read GetCount;
  end;


{ Directory Node }

  TBTNode20_Directory = class(TBTNode20)
  public
    destructor Destroy;override;
    constructor Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString=''); override;
  end;






//{ AnsiChar Node }
//
//  TBTNode20_AnsiChar = class(TBTNode20)
//  private
//    FData: AnsiChar;
//    procedure SetData(const Value: AnsiChar);
//  protected
//    procedure ClearData; override;
//  public
//    constructor Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString=''); override;
//
//    procedure ReadBuffer(var ADest:Pointer); override;
//    procedure WriteBuffer(const ASource:Pointer; ACount: Integer); override;
//
//    property Data: AnsiChar read FData write SetData;
//  end;
//
//
//{ WideChar Node }
//
//  TBTNode20_WideChar = class(TBTNode20)
//  private
//    FData: WideChar;
//    procedure SetData(const Value: WideChar);
//  protected
//    procedure ClearData; override;
//  public
//    constructor Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString=''); override;
//
//    procedure ReadBuffer(var ADest:Pointer); override;
//    procedure WriteBuffer(const ASource:Pointer; ACount: Integer); override;
//
//    property Data: WideChar read FData write SetData;
//  end;
//
//
//{ AnsiString Node }
//
//  TBTNode20_AnsiString = class(TBTNode20)
//  private
//    FData: PAnsiChar;
//    function GetData: AnsiString;
//    procedure SetData(const Value: AnsiString);
//  protected
//    procedure ClearData; override;
//  public
//    constructor Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString=''); override;
//
//    procedure ReadBuffer(var ADest:Pointer); override;
//    procedure WriteBuffer(const ASource:Pointer; ACount: Integer); override;
//
//    property Data: AnsiString read GetData write SetData;
//  end;
//





{ WideString Node }

  TBTNode20_WideString = class(TBTNode20)
  private
    FData: PWideChar;
    function GetData: WideString;
    procedure SetData(const Value: WideString);
  protected
    procedure ClearData; override;
  public
    constructor Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString=''); override;

    procedure ReadBuffer(var ADest:Pointer); override;
    procedure WriteBuffer(const ASource:Pointer; ACount: Integer); override;

    property Data: WideString read GetData write SetData;
  end;

{ Class Node }

  TBTNode20_Class = class(TBTNode20)
  private
    FClassName: PWideChar;
    function GetClassName: WideString;
    procedure SetClassName(const Value: WideString);
  protected
    procedure ClearData; override;
  public
    constructor Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString=''); override;

    procedure ReadBuffer(var ADest:Pointer); override;
    procedure WriteBuffer(const ASource:Pointer; ACount: Integer); override;

    property ClassName: WideString read GetClassName write SetClassName;
  end;


{ Font Node }
//
//  TBTNode20_Font = class(TBTNode20)
//  private
//    FData: PWideChar;
//    function GetData: WideString;
//    procedure SetData(const Value: WideString);
//  protected
//    procedure ClearData; override;
//  public
//    constructor Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString=''); override;
//
//    procedure ReadBuffer(var ADest:Pointer); override;
//    procedure WriteBuffer(const ASource:Pointer; ACount: Integer); override;
//
//    property Data: WideString read GetData write SetData;
//  end;


{ Int8 Node }
//
//  TBTNode20_Int8 = class(TBTNode20)
//  private
//    FData: Shortint;
//    procedure SetData(const Value: Shortint);
//  protected
//    procedure ClearData; override;
//  public
//    constructor Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString=''); override;
//
//    procedure ReadBuffer(var ADest:Pointer); override;
//    procedure WriteBuffer(const ASource:Pointer; ACount: Integer); override;
//
//    property Data: Shortint read FData write SetData;
//  end;
//

{ Int16 Node }

//  TBTNode20_Int16 = class(TBTNode20)
//  private
//    FData: SmallInt;
//    procedure SetData(const Value: SmallInt);
//  protected
//    procedure ClearData; override;
//  public
//    constructor Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString=''); override;
//
//    procedure ReadBuffer(var ADest:Pointer); override;
//    procedure WriteBuffer(const ASource:Pointer; ACount: Integer); override;
//
//    property Data: SmallInt read FData write SetData;
//  end;


{ Int32 Node }

  TBTNode20_Int32 = class(TBTNode20)
  private
    FData: Int32;
    procedure SetData(const Value: Int32);
  protected
    procedure ClearData; override;
  public
    constructor Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString=''); override;

    procedure ReadBuffer(var ADest:Pointer); override;
    procedure WriteBuffer(const ASource:Pointer; ACount: Integer); override;

    property Data: Int32 read FData write SetData;
  end;

{ Color Node }

  TBTNode20_Color = class(TBTNode20)
  private
    AColor:TDelphiColor;
//    Alpha:Byte;

    FData: TDrawColor;
    procedure SetData(const Value: TDrawColor);
  protected
    procedure ClearData; override;
  public
    constructor Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString=''); override;
    destructor Destroy;override;

    procedure ReadBuffer(var ADest:Pointer); override;
    procedure WriteBuffer(const ASource:Pointer; ACount: Integer); override;

    property Data: TDrawColor read FData write SetData;
  end;


{ Int64 Node }

//  TBTNode20_Int64 = class(TBTNode20)
//  private
//    FData: Int64;
//    procedure SetData(const Value: Int64);
//  protected
//    procedure ClearData; override;
//  public
//    constructor Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString=''); override;
//
//    procedure ReadBuffer(var ADest:Pointer); override;
//    procedure WriteBuffer(const ASource:Pointer; ACount: Integer); override;
//
//    property Data: Int64 read FData write SetData;
//  end;


{ UInt8 Node }

  TBTNode20_UInt8 = class(TBTNode20)
  private
    FData: Byte;
    procedure SetData(const Value: Byte);
  protected
    procedure ClearData; override;
  public
    constructor Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString=''); override;

    procedure ReadBuffer(var ADest:Pointer); override;
    procedure WriteBuffer(const ASource:Pointer; ACount: Integer); override;

    property Data: Byte read FData write SetData;
  end;


{ UInt16 Node }

//  TBTNode20_UInt16 = class(TBTNode20)
//  private
//    FData: Word;
//    procedure SetData(const Value: Word);
//  protected
//    procedure ClearData; override;
//  public
//    constructor Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString=''); override;
//
//    procedure ReadBuffer(var ADest:Pointer); override;
//    procedure WriteBuffer(const ASource:Pointer; ACount: Integer); override;
//
//    property Data: Word read FData write SetData;
//  end;


{ UInt32 Node }

  TBTNode20_UInt32 = class(TBTNode20)
  private
    FData: LongWord;
    procedure SetData(const Value: LongWord);
  protected
    procedure ClearData; override;
  public
    constructor Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString=''); override;

    procedure ReadBuffer(var ADest:Pointer); override;
    procedure WriteBuffer(const ASource:Pointer; ACount: Integer); override;

    property Data: LongWord read FData write SetData;
  end;


{ Real32 Node }

//  TBTNode20_Real32 = class(TBTNode20)
//  private
//    FData: Single;
//    procedure SetData(const Value: Single);
//  protected
//    procedure ClearData; override;
//  public
//    constructor Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString=''); override;
//
//    procedure ReadBuffer(var ADest:Pointer); override;
//    procedure WriteBuffer(const ASource:Pointer; ACount: Integer); override;
//
//    property Data: Single read FData write SetData;
//  end;


{ Real48 Node }
//
//  TBTNode20_Real48 = class(TBTNode20)
//  private
//    FData: Real48;
//    procedure SetData(const Value: Real48);
//  protected
//    procedure ClearData; override;
//  public
//    constructor Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString=''); override;
//
//    procedure ReadBuffer(var ADest:Pointer); override;
//    procedure WriteBuffer(const ASource:Pointer; ACount: Integer); override;
//
//    property Data: Real48 read FData write SetData;
//  end;


{ Real64 Node }

  TBTNode20_Real64 = class(TBTNode20)
  private
    FData: Double;
    procedure SetData(const Value: Double);
  protected
    procedure ClearData; override;
  public
    constructor Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString=''); override;

    procedure ReadBuffer(var ADest:Pointer); override;
    procedure WriteBuffer(const ASource:Pointer; ACount: Integer); override;

    property Data: Double read FData write SetData;
  end;


{ Real80 Node }

//  TBTNode20_Real80 = class(TBTNode20)
//  private
//    FData: Extended;
//    procedure SetData(const Value: Extended);
//  protected
//    procedure ClearData; override;
//  public
//    constructor Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString=''); override;
//
//    procedure ReadBuffer(var ADest:Pointer); override;
//    procedure WriteBuffer(const ASource:Pointer; ACount: Integer); override;
//
//    property Data: Extended read FData write SetData;
//  end;


{ Currency Node }

//  TBTNode20_Currency = class(TBTNode20)
//  private
//    FData: Currency;
//    procedure SetData(const Value: Currency);
//  protected
//    procedure ClearData; override;
//  public
//    constructor Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString=''); override;
//
//    procedure ReadBuffer(var ADest:Pointer); override;
//    procedure WriteBuffer(const ASource:Pointer; ACount: Integer); override;
//
//    property Data: Currency read FData write SetData;
//  end;


{ DateTime Node }

  TBTNode20_DateTime = class(TBTNode20)
  private
    FData: TDateTime;
    procedure SetData(const Value: TDateTime);
  protected
    procedure ClearData; override;
  public
    constructor Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString=''); override;

    procedure ReadBuffer(var ADest:Pointer); override;
    procedure WriteBuffer(const ASource:Pointer; ACount: Integer); override;

    property Data: TDateTime read FData write SetData;
  end;


{ TimeStamp Node }

//  TBTNode20_TimeStamp = class(TBTNode20)
//  private
//    FData: TTimeStamp;
//    procedure SetData(const Value: TTimeStamp);
//  protected
//    procedure ClearData; override;
//  public
//    constructor Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString=''); override;
//
//    procedure ReadBuffer(var ADest:Pointer); override;
//    procedure WriteBuffer(const ASource:Pointer; ACount: Integer); override;
//
//    property Data: TTimeStamp read FData write SetData;
//  end;


{ Bool8 Node }

//  TBTNode20_Bool8 = class(TBTNode20)
//  private
//    FData: ByteBool;
//    procedure SetData(const Value: ByteBool);
//  protected
//    procedure ClearData; override;
//  public
//    constructor Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString=''); override;
//
//    procedure ReadBuffer(var ADest:Pointer); override;
//    procedure WriteBuffer(const ASource:Pointer; ACount: Integer); override;
//
//    property Data: ByteBool read FData write SetData;
//  end;


{ Bool16 Node }

//  TBTNode20_Bool16 = class(TBTNode20)
//  private
//    FData: WordBool;
//    procedure SetData(const Value: WordBool);
//  protected
//    procedure ClearData; override;
//  public
//    constructor Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString=''); override;
//
//    procedure ReadBuffer(var ADest:Pointer); override;
//    procedure WriteBuffer(const ASource:Pointer; ACount: Integer); override;
//
//    property Data: WordBool read FData write SetData;
//  end;


{ Bool32 Node }

  TBTNode20_Bool32 = class(TBTNode20)
  private
    FData: LongBool;
    procedure SetData(const Value: LongBool);
  protected
    procedure ClearData; override;
  public
    constructor Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString=''); override;

    procedure ReadBuffer(var ADest:Pointer); override;
    procedure WriteBuffer(const ASource:Pointer; ACount: Integer); override;

    property Data: LongBool read FData write SetData;
  end;


{ GUID Node }

//  TBTNode20_GUID = class(TBTNode20)
//  private
//    FData: TGUID;
//    function GetData: PGUID;
//    procedure SetData(const Value: PGUID);
//  protected
//    procedure ClearData; override;
//  public
//    constructor Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString=''); override;
//
//    procedure ReadBuffer(var ADest:Pointer); override;
//    procedure WriteBuffer(const ASource:Pointer; ACount: Integer); override;
//
//    property Data: PGUID read GetData write SetData;
//  end;


{ Binary Node }

  TBTNode20_Binary = class(TBTNode20)
  private
    FData: Pointer;
    function GetData: Pointer;
  protected
    procedure ClearData; override;
  public
    constructor Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString=''); override;

    procedure ReadBuffer(var ADest:Pointer); override;
    procedure WriteBuffer(const ASource:Pointer; ACount: Integer); override;

    procedure LoadFromStream(Stream: TStream);
    procedure SaveToStream(Stream: TStream);

    procedure LoadFromFile(const FileName: string);
    procedure SaveToFile(const FileName: string);

    property DataBuf: Pointer read GetData;
  end;


{ Binary Tree Document 2.0 }

  TBTDOC20 = class(TObject)
  private
    FVersion: BYTE;
    FName: WideString;
    FTopNode: TBTNode20_Directory;

    procedure SetName(const Value: WideString);
    function GetNodes: TBTNodeList20;
    function GetDocBufSize: DWORD;

    function GetSafeNodePath(ANodePath: WideString): WideString;
    function SearchNode(ANodeList: TBTNodeList20; ANodePath: WideString): TBTNode20;
    function RecursiveFindNode(ANodes: TBTNodeList20; ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;

    function GetNameBytes: Integer;
    function CalculateNodeSize(ANode: TBTNode20): Integer;
    function CalculateNodesSize(ANodeList: TBTNodeList20): Integer;

    procedure DocHeaderFromBuffer(var ASource: Pointer; var ACurPos: Integer);
    procedure DocNodeFromBuffer(var ASource: Pointer; var ACurPos: Integer;
      AParentNode: TBTNode20; var ANode: TBTNode20; var AChildCount: Integer);
    procedure DocNodesFromBuffer(var ASource: Pointer; var ACurPos: Integer;
      AParentNode: TBTNode20; const AChildCount: Integer);

    procedure DocHeaderToBuffer(var ADest: Pointer);
    procedure DocNodeToBuffer(var ADest: Pointer; ANode: TBTNode20);
    procedure DocNodesToBuffer(var ADest: Pointer; ANodeList: TBTNodeList20);
  public
    constructor Create;
    destructor Destroy; override;

    class function CreateNode(ANodeType: TBTNodeType20; AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
//    class function PrefetchData(const ADocBuf; var AVersion: BYTE; var AName: WideString): Boolean;

    procedure Assign(Source: TBTDOC20);

    procedure Clear;

    procedure Load(const pSrc:Pointer);
    procedure Save(var pDest:Pointer);

    procedure LoadFromStream(Stream: TStream);
    procedure SaveToStream(Stream: TStream);

    procedure LoadFromFile(const FileName: string);
    procedure SaveToFile(const FileName: string);

    function FindNodeByName(ANodeName: WideString;ARecursive: Boolean): TBTNode20;
    function FindNodeByPath(ANodePath: WideString): TBTNode20;

    property Version: BYTE read FVersion;
    property Name: WideString read FName write SetName;
    property TopNode: TBTNode20_Directory read FTopNode;
    property Nodes: TBTNodeList20 read GetNodes;
    property DocBufSize: DWORD read GetDocBufSize;
  end;

procedure CopyMemoryData(Destination: Pointer; Source: Pointer; Length: DWORD);








implementation



{$IFDEF FMX}
uses
  FMX.Types;
{$ENDIF}




const
  EXCEPTION_IVALIDDOCUMENT            = '无效文档';
  EXCEPTION_IVALIDVERSION             = '无效版本号';
  EXCEPTION_IVALIDNODE                = '无效节点';
  EXCEPTION_INVALIDNODENAME           = '节点名称不能为空';

const
  MAX_DOCNAME_LENGTH = 230;
  MAX_NODENAME_LENGTH = 80;







type

{ Binary Tree Document --- Header }

  PBTDocHeader = ^TBTDocHeader;
  TBTDocHeader = packed record
    bVersion: BYTE;
    bNameLength: BYTE;
  end;


{ Binary Tree Document --- Node Header }

  PBTNodeHeader = ^TBTNodeHeader;
  TBTNodeHeader = packed record
    bNodeType: BYTE;
    dwChildCount: DWORD;
    bNameLength: BYTE;
    bCaptionLength: BYTE;
    dwDataLength: DWORD;
  end;


procedure CopyMemoryData(Destination: Pointer; Source: Pointer; Length: DWORD);
begin
  {$IFDEF VCL}
  CopyMemory(Destination,Source,Length);
  {$ENDIF}
  {$IFDEF FMX}
  System.Move(Source^,Destination^,Length);
  {$ENDIF}
end;

{ TBTNode20 }

procedure TBTNode20.ClearData;
begin
end;

function TBTNode20.ConvertNode_Directory: TBTNode20_Directory;
begin
  Result:=nil;if Self is TBTNode20_Directory then Result := TBTNode20_Directory(Self);
end;
function TBTNode20.ConvertNode_Class: TBTNode20_Class;
begin
  Result:=nil;if Self is TBTNode20_Class then Result := TBTNode20_Class(Self);
end;
//function TBTNode20.ConvertNode_AnsiChar: TBTNode20_AnsiChar;
//begin
//  Result:=nil;Result:=nil;if Self is TBTNode20_AnsiChar then Result := TBTNode20_AnsiChar(Self);
//end;
//function TBTNode20.ConvertNode_WideChar: TBTNode20_WideChar;
//begin
//  Result:=nil;if Self is TBTNode20_WideChar then Result := TBTNode20_WideChar(Self);
//end;
//function TBTNode20.ConvertNode_AnsiString: TBTNode20_AnsiString;
//begin
//  Result:=nil;if Self is TBTNode20_AnsiString then Result := TBTNode20_AnsiString(Self);
//end;
function TBTNode20.ConvertNode_WideString: TBTNode20_WideString;
begin
  Result:=nil;if Self is TBTNode20_WideString then Result := TBTNode20_WideString(Self);
end;
//function TBTNode20.ConvertNode_Font: TBTNode20_Font;
//begin
//  Result:=nil;if Self is TBTNode20_Font then Result := TBTNode20_Font(Self);
//end;
function TBTNode20.ConvertNode_Color: TBTNode20_Color;
begin
  Result:=nil;if Self is TBTNode20_Color then Result := TBTNode20_Color(Self);
end;
//function TBTNode20.ConvertNode_Int8: TBTNode20_Int8;
//begin
//  Result:=nil;if Self is TBTNode20_Int8 then Result := TBTNode20_Int8(Self);
//end;
//function TBTNode20.ConvertNode_Int16: TBTNode20_Int16;
//begin
//  Result:=nil;if Self is TBTNode20_Int16 then Result := TBTNode20_Int16(Self);
//end;
function TBTNode20.ConvertNode_Int32: TBTNode20_Int32;
begin
  Result:=nil;if Self is TBTNode20_Int32 then Result := TBTNode20_Int32(Self);
end;
//function TBTNode20.ConvertNode_Int64: TBTNode20_Int64;
//begin
//  Result:=nil;if Self is TBTNode20_Int64 then Result := TBTNode20_Int64(Self);
//end;
function TBTNode20.ConvertNode_UInt8: TBTNode20_UInt8;
begin
  Result:=nil;if Self is TBTNode20_UInt8 then Result := TBTNode20_UInt8(Self);
end;
//function TBTNode20.ConvertNode_UInt16: TBTNode20_UInt16;
//begin
//  Result:=nil;if Self is TBTNode20_UInt16 then Result := TBTNode20_UInt16(Self);
//end;
function TBTNode20.ConvertNode_UInt32: TBTNode20_UInt32;
begin
  Result:=nil;if Self is TBTNode20_UInt32 then Result := TBTNode20_UInt32(Self);
end;
//function TBTNode20.ConvertNode_Real32: TBTNode20_Real32;
//begin
//  Result:=nil;if Self is TBTNode20_Real32 then Result := TBTNode20_Real32(Self);
//end;
//function TBTNode20.ConvertNode_Real48: TBTNode20_Real48;
//begin
//  Result:=nil;if Self is TBTNode20_Real48 then Result := TBTNode20_Real48(Self);
//end;
function TBTNode20.ConvertNode_Real64: TBTNode20_Real64;
begin
  Result:=nil;if Self is TBTNode20_Real64 then Result := TBTNode20_Real64(Self);
end;
//function TBTNode20.ConvertNode_Real80: TBTNode20_Real80;
//begin
//  Result:=nil;if Self is TBTNode20_Real80 then Result := TBTNode20_Real80(Self);
//end;
//function TBTNode20.ConvertNode_Currency: TBTNode20_Currency;
//begin
//  Result:=nil;if Self is TBTNode20_Currency then Result := TBTNode20_Currency(Self);
//end;
function TBTNode20.ConvertNode_DateTime: TBTNode20_DateTime;
begin
  Result:=nil;if Self is TBTNode20_DateTime then Result := TBTNode20_DateTime(Self);
end;
//function TBTNode20.ConvertNode_TimeStamp: TBTNode20_TimeStamp;
//begin
//  Result:=nil;if Self is TBTNode20_TimeStamp then Result := TBTNode20_TimeStamp(Self);
//end;
//function TBTNode20.ConvertNode_Bool8: TBTNode20_Bool8;
//begin
//  Result:=nil;if Self is TBTNode20_Bool8 then Result := TBTNode20_Bool8(Self);
//end;
//function TBTNode20.ConvertNode_Bool16: TBTNode20_Bool16;
//begin
//  Result:=nil;if Self is TBTNode20_Bool16 then Result := TBTNode20_Bool16(Self);
//end;
function TBTNode20.ConvertNode_Bool32: TBTNode20_Bool32;
begin
  Result:=nil;if Self is TBTNode20_Bool32 then Result := TBTNode20_Bool32(Self);
end;
//function TBTNode20.ConvertNode_Guid: TBTNode20_Guid;
//begin
//  Result:=nil;if Self is TBTNode20_Guid then Result := TBTNode20_Guid(Self);
//end;
function TBTNode20.ConvertNode_Binary: TBTNode20_Binary;
begin
  Result:=nil;if Self is TBTNode20_Binary then Result := TBTNode20_Binary(Self);
end;






function TBTNode20.AddChildNode_Directory(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
begin
  Result := TBTNode20_Directory.Create(Self, ANodeName, ANodeCaption);
end;
function TBTNode20.AddChildNode_Class(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
begin
  Result := TBTNode20_Class.Create(Self, ANodeName, ANodeCaption);
end;
//function TBTNode20.AddChildNode_AnsiChar(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
//begin
//  Result := TBTNode20_AnsiChar.Create(Self, ANodeName, ANodeCaption);
//end;
//function TBTNode20.AddChildNode_WideChar(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
//begin
//  Result := TBTNode20_WideChar.Create(Self, ANodeName, ANodeCaption);
//end;
//function TBTNode20.AddChildNode_AnsiString(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
//begin
//  Result := TBTNode20_AnsiString.Create(Self, ANodeName, ANodeCaption);
//end;
function TBTNode20.AddChildNode_WideString(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
begin
  Result := TBTNode20_WideString.Create(Self, ANodeName, ANodeCaption);
end;
//function TBTNode20.AddChildNode_Font(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
//begin
//  Result := TBTNode20_Font.Create(Self, ANodeName, ANodeCaption);
//end;
function TBTNode20.AddChildNode_Color(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
begin
  Result := TBTNode20_Color.Create(Self, ANodeName, ANodeCaption);
end;
//function TBTNode20.AddChildNode_Int8(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
//begin
//  Result := TBTNode20_Int8.Create(Self, ANodeName, ANodeCaption);
//end;
//function TBTNode20.AddChildNode_Int16(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
//begin
//  Result := TBTNode20_Int16.Create(Self, ANodeName, ANodeCaption);
//end;
function TBTNode20.AddChildNode_Int32(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
begin
  Result := TBTNode20_Int32.Create(Self, ANodeName, ANodeCaption);
end;
//function TBTNode20.AddChildNode_Int64(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
//begin
//  Result := TBTNode20_Int64.Create(Self, ANodeName, ANodeCaption);
//end;
function TBTNode20.AddChildNode_UInt8(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
begin
  Result := TBTNode20_UInt8.Create(Self, ANodeName, ANodeCaption);
end;
//function TBTNode20.AddChildNode_UInt16(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
//begin
//  Result := TBTNode20_UInt16.Create(Self, ANodeName, ANodeCaption);
//end;
function TBTNode20.AddChildNode_UInt32(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
begin
  Result := TBTNode20_UInt32.Create(Self, ANodeName, ANodeCaption);
end;
//function TBTNode20.AddChildNode_Real32(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
//begin
//  Result := TBTNode20_Real32.Create(Self, ANodeName, ANodeCaption);
//end;
//function TBTNode20.AddChildNode_Real48(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
//begin
//  Result := TBTNode20_Real48.Create(Self, ANodeName, ANodeCaption);
//end;
function TBTNode20.AddChildNode_Real64(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
begin
  Result := TBTNode20_Real64.Create(Self, ANodeName, ANodeCaption);
end;
//function TBTNode20.AddChildNode_Real80(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
//begin
//  Result := TBTNode20_Real80.Create(Self, ANodeName, ANodeCaption);
//end;
//function TBTNode20.AddChildNode_Currency(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
//begin
//  Result := TBTNode20_Currency.Create(Self, ANodeName, ANodeCaption);
//end;
function TBTNode20.AddChildNode_DateTime(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
begin
  Result := TBTNode20_DateTime.Create(Self, ANodeName, ANodeCaption);
end;
//function TBTNode20.AddChildNode_TimeStamp(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
//begin
//  Result := TBTNode20_TimeStamp.Create(Self, ANodeName, ANodeCaption);
//end;
//function TBTNode20.AddChildNode_Bool8(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
//begin
//  Result := TBTNode20_Bool8.Create(Self, ANodeName, ANodeCaption);
//end;
//function TBTNode20.AddChildNode_Bool16(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
//begin
//  Result := TBTNode20_Bool16.Create(Self, ANodeName, ANodeCaption);
//end;
function TBTNode20.AddChildNode_Bool32(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
begin
  Result := TBTNode20_Bool32.Create(Self, ANodeName, ANodeCaption);
end;
//function TBTNode20.AddChildNode_Guid(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
//begin
//  Result := TBTNode20_Guid.Create(Self, ANodeName, ANodeCaption);
//end;
function TBTNode20.AddChildNode_Binary(ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
begin
  Result := TBTNode20_Binary.Create(Self, ANodeName, ANodeCaption);
end;


function TBTNode20.AddChildNode(ANodeType: TBTNodeType20; ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
begin
  case ANodeType of
    nt20_Directory: Result := TBTNode20_Directory.Create(Self, ANodeName, ANodeCaption);
    nt20_Class: Result := TBTNode20_Class.Create(Self, ANodeName, ANodeCaption);
//    nt20_AnsiChar: Result := TBTNode20_AnsiChar.Create(Self, ANodeName, ANodeCaption);
//    nt20_WideChar: Result := TBTNode20_WideChar.Create(Self, ANodeName, ANodeCaption);
//    nt20_AnsiString: Result := TBTNode20_AnsiString.Create(Self, ANodeName, ANodeCaption);
    nt20_WideString: Result := TBTNode20_WideString.Create(Self, ANodeName, ANodeCaption);
//    nt20_Font: Result := TBTNode20_Font.Create(Self, ANodeName, ANodeCaption);
    nt20_Color: Result := TBTNode20_Color.Create(Self, ANodeName, ANodeCaption);
//    nt20_Int8: Result := TBTNode20_Int8.Create(Self, ANodeName, ANodeCaption);
//    nt20_Int16: Result := TBTNode20_Int16.Create(Self, ANodeName, ANodeCaption);
    nt20_Int32: Result := TBTNode20_Int32.Create(Self, ANodeName, ANodeCaption);
//    nt20_Int64: Result := TBTNode20_Int64.Create(Self, ANodeName, ANodeCaption);
    nt20_UInt8: Result := TBTNode20_UInt8.Create(Self, ANodeName, ANodeCaption);
//    nt20_UInt16: Result := TBTNode20_UInt16.Create(Self, ANodeName, ANodeCaption);
    nt20_UInt32: Result := TBTNode20_UInt32.Create(Self, ANodeName, ANodeCaption);
//    nt20_Real32: Result := TBTNode20_Real32.Create(Self, ANodeName, ANodeCaption);
//    nt20_Real48: Result := TBTNode20_Real48.Create(Self, ANodeName, ANodeCaption);
    nt20_Real64: Result := TBTNode20_Real64.Create(Self, ANodeName, ANodeCaption);
//    nt20_Real80: Result := TBTNode20_Real80.Create(Self, ANodeName, ANodeCaption);
//    nt20_Currency: Result := TBTNode20_Currency.Create(Self, ANodeName, ANodeCaption);
    nt20_DateTime: Result := TBTNode20_DateTime.Create(Self, ANodeName, ANodeCaption);
//    nt20_TimeStamp: Result := TBTNode20_TimeStamp.Create(Self, ANodeName, ANodeCaption);
//    nt20_Bool8: Result := TBTNode20_Bool8.Create(Self, ANodeName, ANodeCaption);
//    nt20_Bool16: Result := TBTNode20_Bool16.Create(Self, ANodeName, ANodeCaption);
    nt20_Bool32: Result := TBTNode20_Bool32.Create(Self, ANodeName, ANodeCaption);
//    nt20_Guid: Result := TBTNode20_GUID.Create(Self, ANodeName, ANodeCaption);
    nt20_Binary: Result := TBTNode20_Binary.Create(Self, ANodeName, ANodeCaption);
    else ShowException(EXCEPTION_IVALIDNODE);
  end;//case of
end;


constructor TBTNode20.Create(AParentNode: TBTNode20;
  ANodeName: WideString;const ANodeCaption:WideString='');
begin
  FNodeType := nt20_Directory;
  if Trim(ANodeName) = '' then
    ShowException(EXCEPTION_INVALIDNODENAME);
  FNodeName := ANodeName;
  FNodeCaption := ANodeCaption;
  FDataSize := 0;

  FParentNode := nil;
  SetParentNode(AParentNode);
  FChildNodes := nil;
  FChildNodes := TBTNodeList20.Create(Self);
end;

destructor TBTNode20.Destroy;
begin
  FChildNodes.Clear();
  FreeAndNil(FChildNodes);
  ClearData();
  inherited;
end;

function TBTNode20.FindChildNodeByName(ANodeName: WideString): TBTNode20;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Self.FChildNodes.Count - 1 do
  begin
    if Self.FChildNodes[I].FNodeName=ANodeName then
    begin
      Result:=Self.FChildNodes[I];
      Break;
    end;
  end;
end;

procedure TBTNode20.WriteBuffer(const ASource:Pointer; ACount: Integer);
begin
end;

procedure TBTNode20.SetNodeCaption(const Value: WideString);
var
  strTemp: WideString;
begin
  strTemp := Value;

  if System.Length(strTemp) > MAX_NODENAME_LENGTH then
  begin
    strTemp := Copy(strTemp, 1, MAX_NODENAME_LENGTH);
  end;

  FNodeCaption := strTemp;
end;

procedure TBTNode20.SetNodeName(const Value: WideString);
var
  strTemp: WideString;
begin
  strTemp := Value;

  if System.Length(strTemp) > MAX_NODENAME_LENGTH then
  begin
    strTemp := Copy(strTemp, 1, MAX_NODENAME_LENGTH);
  end;

  FNodeName := strTemp;
end;

procedure TBTNode20.SetParentNode(const Value: TBTNode20);
begin
  if FParentNode <> Value then begin
    if FParentNode <> nil then
      FParentNode.ChildNodes.Remove(Self);
    FParentNode := Value;
    if FParentNode <> nil then
      FParentNode.ChildNodes.Add(Self);
  end;
end;

procedure TBTNode20.ReadBuffer(var ADest:Pointer);
begin

end;

{ TBTNodeList20 }

function TBTNodeList20.Add(ANode: TBTNode20): Integer;
begin
  Result := IndexOf(ANode);
  if Result = -1 then begin
    Result := FItems.Add(ANode);
    ANode.ParentNode := FOwnerNode;
  end;
end;

procedure TBTNodeList20.Clear;
var
  i: Integer;
  ABTNode:TBTNode20;
begin
  i := FItems.Count - 1;
  while i >= 0 do
  begin

    ABTNode:=TBTNode20(FItems.Items[i]);
    FreeAndNil(ABTNode);

    if i > FItems.Count - 1 then
      i := FItems.Count - 1
    else
      Dec(i);
  end;

  FItems.Clear();
end;

constructor TBTNodeList20.Create(AOwnerNode: TBTNode20);
begin
  if AOwnerNode = nil then
    ShowException('AOwnerNode can not nil');
  FItems := TList.Create();
  FOwnerNode := AOwnerNode;
end;

procedure TBTNodeList20.Delete(Index: Integer);
var
  objNode: TBTNode20;
begin
  objNode := TBTNode20(FItems.Items[Index]);
  objNode.ChildNodes.Clear();
  FreeAndNil(objNode);
  FItems.Delete(Index);
end;

destructor TBTNodeList20.Destroy;
begin
  FreeAndNil(FItems);
  inherited;
end;

function TBTNodeList20.FindNodeByLeftPartName(ALeftPartNodeName: WideString): TBTNode20;
var
  i: Integer;
  LeftPartLen:Integer;
begin
  Result := nil;
  LeftPartLen:=Length(ALeftPartNodeName);
  i := FItems.Count - 1;
  while i >= 0 do begin
    if Copy(TBTNode20(FItems.Items[i]).NodeName,1,LeftPartLen) = ALeftPartNodeName then
    begin
      Result := TBTNode20(FItems.Items[i]);
      Break;
    end;
    if i > FItems.Count - 1 then
      i := FItems.Count - 1
    else
      Dec(i);
  end;
end;

function TBTNodeList20.FindNodeByName(ANodeName: WideString): TBTNode20;
var
  i: Integer;
begin
  Result := nil;
  i := FItems.Count - 1;
  while i >= 0 do begin
    if TBTNode20(FItems.Items[i]).NodeName = ANodeName then
    begin
      Result := TBTNode20(FItems.Items[i]);
      Break;
    end;
    if i > FItems.Count - 1 then
      i := FItems.Count - 1
    else
      Dec(i);
  end;
end;

function TBTNodeList20.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TBTNodeList20.GetItems(Index: Integer): TBTNode20;
begin
  Result := TBTNode20(FItems.Items[Index]);
end;

function TBTNodeList20.IndexOf(ANode: TBTNode20): Integer;
begin
  Result := FItems.IndexOf(ANode);
end;

procedure TBTNodeList20.Insert(Index: Integer;
  ANode: TBTNode20);
begin
  if IndexOf(ANode) = -1 then begin
    FItems.Insert(Index, ANode);
    ANode.ParentNode := FOwnerNode;
  end;
end;

procedure TBTNodeList20.Move(CurIndex, NewIndex: Integer);
begin
  FItems.Move(CurIndex, NewIndex);
end;

function TBTNodeList20.Remove(ANode: TBTNode20): Integer;
begin
  Result := IndexOf(ANode);
  if Result >= 0 then begin
    Result := FItems.Remove(ANode);
    ANode.ParentNode := nil;
  end;
end;

procedure TBTNodeList20.SetItems(Index: Integer;
  const Value: TBTNode20);
begin
  FItems.Items[Index] := Value;
end;


{ TBTNode20_Directory }

constructor TBTNode20_Directory.Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString='');
begin
  inherited Create(AParentNode, ANodeName,ANodeCaption);
  FNodeType := nt20_Directory;
end;

//{ TBTNode20_AnsiChar }
//
//procedure TBTNode20_AnsiChar.ClearData;
//begin
//  inherited;
//  FData := #0;
//end;
//
//constructor TBTNode20_AnsiChar.Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString='');
//begin
//  inherited Create(AParentNode, ANodeName,ANodeCaption);
//  FNodeType := nt20_AnsiChar;
//  FData := #0;
//  FDataSize := SizeOf(AnsiChar);
//end;
//
//procedure TBTNode20_AnsiChar.WriteBuffer(const ASource:Pointer; ACount: Integer);
//begin
//  CopyMemoryData(@FData, ASource, ACount);
//end;
//
//procedure TBTNode20_AnsiChar.SetData(const Value: AnsiChar);
//begin
//  FData := Value;
//end;
//
//procedure TBTNode20_AnsiChar.ReadBuffer(var ADest:Pointer);
//begin
//  CopyMemoryData(ADest, @FData, FDataSize);
//end;
//
//{ TBTNode20_WideChar }
//
//procedure TBTNode20_WideChar.ClearData;
//begin
//  inherited;
//  FData := #0;
//end;
//
//constructor TBTNode20_WideChar.Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString='');
//begin
//  inherited Create(AParentNode, ANodeName,ANodeCaption);
//  FNodeType := nt20_WideChar;
//  FData := #0;
//  FDataSize := SizeOf(WideChar);
//end;
//
//procedure TBTNode20_WideChar.WriteBuffer(const ASource:Pointer; ACount: Integer);
//begin
//  CopyMemoryData(@FData, ASource, ACount);
//end;
//
//procedure TBTNode20_WideChar.SetData(const Value: WideChar);
//begin
//  FData := Value;
//end;
//
//procedure TBTNode20_WideChar.ReadBuffer(var ADest:Pointer);
//begin
//  CopyMemoryData(ADest, @FData, FDataSize);
//end;
//
//{ TBTNode20_AnsiString }
//
//procedure TBTNode20_AnsiString.ClearData;
//begin
//  inherited;
//  if FDataSize > 0 then begin
//    FreeMemory(FData);
//    FData := nil;
//    FDataSize := 0;
//  end;
//end;
//
//constructor TBTNode20_AnsiString.Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString='');
//begin
//  inherited Create(AParentNode, ANodeName,ANodeCaption);
//  FNodeType := nt20_AnsiString;
//  FData := nil;
//end;
//
//procedure TBTNode20_AnsiString.WriteBuffer(const ASource:Pointer; ACount: Integer);
//begin
//  if ACount > 0 then begin
//    ClearData();
//    FData := GetMemory(ACount);
//    CopyMemoryData(FData, ASource, ACount);
//    FDataSize := ACount;
//  end;
//end;
//
//function TBTNode20_AnsiString.GetData: AnsiString;
//begin
//  if FDataSize > 0 then
//    Result := FData
//  else
//    Result := '';
//end;
//
//procedure TBTNode20_AnsiString.SetData(const Value: AnsiString);
//var
//  nValueSize: Integer;
//begin
//  ClearData();
//  nValueSize := System.Length(Value);
//  if nValueSize > 0 then begin
//    nValueSize := nValueSize + SizeOf(AnsiChar);
//    FData := GetMemory(nValueSize);
//    StrCopy(FData, PAnsiChar(Value));
//    CopyMemoryData(FData, @Value[1], nValueSize);
//    FDataSize := nValueSize;
//  end;
//end;
//
//procedure TBTNode20_AnsiString.ReadBuffer(var ADest:Pointer);
//begin
//  if FDataSize > 0 then begin
//    CopyMemoryData(ADest, FData, FDataSize);
//  end;
//end;

destructor TBTNode20_Directory.Destroy;
begin

  inherited;
end;

{ TBTNode20_Class }

procedure TBTNode20_Class.ClearData;
begin
  inherited;
  if FDataSize > 0 then begin
    FreeMemory(FClassName);
    FClassName := nil;
    FDataSize := 0;
  end;
end;

constructor TBTNode20_Class.Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString='');
begin
  inherited Create(AParentNode, ANodeName, ANodeCaption);
  FNodeType := nt20_Class;
  FClassName := nil;
end;

procedure TBTNode20_Class.WriteBuffer(const ASource:Pointer; ACount: Integer);
begin
  if ACount > 0 then begin
    ClearData();
    FClassName := GetMemory(ACount);
    CopyMemoryData(FClassName, ASource, ACount);
    FDataSize := ACount;
  end;
end;

function TBTNode20_Class.GetClassName: WideString;
begin
  if FDataSize > 0 then
    Result := FClassName
  else
    Result := '';
end;

procedure CopyStringToMemory(AMemory:Pointer;AString:String;ASize:Integer);
begin
  {$IF RTLVersion>=34}
        CopyMemoryData(AMemory, @AString[1], ASize);
  {$ELSE}
      {$IFDEF MSWINDOWS}
      CopyMemoryData(AMemory, @AString[1], ASize);
      {$ELSE}
        {$IFDEF _MACOS}
        CopyMemoryData(AMemory, @AString[1], ASize);
        {$ELSE}
        CopyMemoryData(AMemory, @AString[0], ASize);
        {$ENDIF}
      {$ENDIF}
  {$IFEND}
end;

procedure TBTNode20_Class.SetClassName(const Value: WideString);
var
  nValueSize: Integer;
begin
  ClearData();
  nValueSize := System.Length(Value) * SizeOf(WideChar);
  if nValueSize > 0 then
  begin
    nValueSize := nValueSize + SizeOf(WideChar);
    FClassName := GetMemory(nValueSize);
    CopyStringToMemory(FClassName,Value,nValueSize);
    FDataSize := nValueSize;
  end;
end;

procedure TBTNode20_Class.ReadBuffer(var ADest:Pointer);
begin
  if FDataSize > 0 then begin
    CopyMemoryData(ADest, FClassName, FDataSize);
  end;
end;

{ TBTNode20_WideString }

procedure TBTNode20_WideString.ClearData;
begin
  inherited;
  if FDataSize > 0 then begin
    FreeMemory(FData);
    FData := nil;
    FDataSize := 0;
  end;
end;

constructor TBTNode20_WideString.Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString='');
begin
  inherited Create(AParentNode, ANodeName,ANodeCaption);
  FNodeType := nt20_WideString;
  FData := nil;
end;

procedure TBTNode20_WideString.WriteBuffer(const ASource:Pointer; ACount: Integer);
begin
  if ACount > 0 then begin
    ClearData();
    FData := GetMemory(ACount);
    CopyMemoryData(FData, ASource, ACount);
    FDataSize := ACount;
  end;
end;

function TBTNode20_WideString.GetData: WideString;
begin
  if FDataSize > 0 then
    Result := FData
  else
    Result := '';
end;

procedure TBTNode20_WideString.SetData(const Value: WideString);
var
  nValueSize: Integer;
begin
  ClearData();

  nValueSize := System.Length(Value) * SizeOf(WideChar);

  if nValueSize > 0 then
  begin
    nValueSize := nValueSize + SizeOf(WideChar);
    FData := GetMemory(nValueSize);
//    {$IF DEFINED(MSWINDOWS) OR DEFINED(_MACOS)}
//    CopyMemoryData(FData, @Value[1], nValueSize);
//    {$ELSE}
//    CopyMemoryData(FData, @Value[0], nValueSize);
//    {$ENDIF}
    CopyStringToMemory(FData,Value,nValueSize);

    FDataSize := nValueSize;
  end;
end;

procedure TBTNode20_WideString.ReadBuffer(var ADest:Pointer);
begin
  if FDataSize > 0 then
  begin
    CopyMemoryData(ADest, FData, FDataSize);
  end;
end;


//{ TBTNode20_Font }
//
//procedure TBTNode20_Font.ClearData;
//begin
//  inherited;
//  if FDataSize > 0 then begin
//    FreeMemory(FData);
//    FData := nil;
//    FDataSize := 0;
//  end;
//end;
//
//constructor TBTNode20_Font.Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString='');
//begin
//  inherited Create(AParentNode, ANodeName,ANodeCaption);
//  FNodeType := nt20_Font;
//  FData := nil;
//end;
//
//procedure TBTNode20_Font.WriteBuffer(const ASource:Pointer; ACount: Integer);
//begin
//  if ACount > 0 then begin
//    ClearData();
//    FData := GetMemory(ACount);
//    CopyMemoryData(FData, ASource, ACount);
//    FDataSize := ACount;
//  end;
//end;
//
//function TBTNode20_Font.GetData: WideString;
//begin
//  if FDataSize > 0 then
//    Result := FData
//  else
//    Result := '';
//end;
//
//procedure TBTNode20_Font.SetData(const Value: WideString);
//var
//  nValueSize: Integer;
//begin
//  ClearData();
//  nValueSize := System.Length(Value) * SizeOf(WideChar);
//  if nValueSize > 0 then begin
//    nValueSize := nValueSize + SizeOf(WideChar);
//    FData := GetMemory(nValueSize);
//    CopyMemoryData(FData, @Value[1], nValueSize);
//    FDataSize := nValueSize;
//  end;
//end;
//
//procedure TBTNode20_Font.ReadBuffer(var ADest:Pointer);
//begin
//  if FDataSize > 0 then begin
//    CopyMemoryData(ADest, FData, FDataSize);
//  end;
//end;

{ TBTNode20_Int8 }
//
//procedure TBTNode20_Int8.ClearData;
//begin
//  inherited;
//  FData := 0;
//end;
//
//constructor TBTNode20_Int8.Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString='');
//begin
//  inherited Create(AParentNode, ANodeName,ANodeCaption);
//  FNodeType := nt20_Int8;
//  FData := 0;
//  FDataSize := SizeOf(Shortint);
//end;
//
//procedure TBTNode20_Int8.WriteBuffer(const ASource:Pointer; ACount: Integer);
//begin
//  CopyMemoryData(@FData, ASource, ACount);
//end;
//
//procedure TBTNode20_Int8.SetData(const Value: Shortint);
//begin
//  FData := Value;
//end;
//
//procedure TBTNode20_Int8.ReadBuffer(var ADest:Pointer);
//begin
//  CopyMemoryData(ADest, @FData, FDataSize);
//end;
//
//{ TBTNode20_Int16 }
//
//procedure TBTNode20_Int16.ClearData;
//begin
//  inherited;
//  FData := 0;
//end;
//
//constructor TBTNode20_Int16.Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString='');
//begin
//  inherited Create(AParentNode, ANodeName,ANodeCaption);
//  FNodeType := nt20_Int16;
//  FData := 0;
//  FDataSize := SizeOf(SmallInt);
//end;
//
//procedure TBTNode20_Int16.WriteBuffer(const ASource:Pointer; ACount: Integer);
//begin
//  CopyMemoryData(@FData, ASource, ACount);
//end;
//
//procedure TBTNode20_Int16.SetData(const Value: SmallInt);
//begin
//  FData := Value;
//end;
//
//procedure TBTNode20_Int16.ReadBuffer(var ADest:Pointer);
//begin
//  CopyMemoryData(ADest, @FData, FDataSize);
//end;

{ TBTNode20_Color }

procedure TBTNode20_Color.ClearData;
begin
  inherited;
  if FData<>nil then
  begin
    FData.FColor:=WhiteColor;
    FData.FAlpha:=255;
  end;
end;

constructor TBTNode20_Color.Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString='');
begin
//  FMX.Types.Log.d('TBTNode20_Color.Create'+ANodeName+' '+ANodeCaption);

  inherited Create(AParentNode, ANodeName,ANodeCaption);

  FNodeType := nt20_Color;
  FData := TDrawColor.Create(ANodeName,ANodeCaption);

  FDataSize := SizeOf(TDelphiColor)+SizeOf(Byte);

end;

destructor TBTNode20_Color.Destroy;
begin
  FreeAndNil(FData);
  inherited;
end;

procedure TBTNode20_Color.WriteBuffer(const ASource:Pointer; ACount: Integer);
begin
//  FMX.Types.Log.d('TBTNode20_Color.WriteBuffer '+FNodeName+' '+FNodeCaption);
//  FMX.Types.Log.d('TBTNode20_Color.WriteBuffer Count'+IntToStr(ACount));


  CopyMemoryData(@AColor, ASource, SizeOf(TDelphiColor));
//  FMX.Types.Log.d('TBTNode20_Color.WriteBuffer 1 AColor '+IntToStr(AColor));
//IOS64位下好像不能Copy一个字节的内存
//  CopyMemoryData(@Alpha, Pointer(Integer(ASource)+SizeOf(TDelphiColor)), SizeOf(Byte));//1);//
//  FData.Alpha:=255;
//  FMX.Types.Log.d('TBTNode20_Color.WriteBuffer 2');

  FData.Color:=AColor;
//  FData.Alpha:=Alpha;
end;

procedure TBTNode20_Color.SetData(const Value: TDrawColor);
begin
  FData.Assign(Value);
end;

procedure TBTNode20_Color.ReadBuffer(var ADest:Pointer);
//var
//  AColor:TDelphiColor;
//  Alpha:Byte;
begin

//  FMX.Types.Log.d('TBTNode20_Color.ReadBuffer');

  AColor:=FData.Color;
//  Alpha:=FData.Alpha;
  CopyMemoryData(ADest, @AColor, SizeOf(TDelphiColor));
//  CopyMemoryData(Pointer(Integer(@ADest)+SizeOf(TDelphiColor)), @Alpha, SizeOf(Byte));//1);//
end;


{ TBTNode20_Int32 }

procedure TBTNode20_Int32.ClearData;
begin
  inherited;
  FData := 0;
end;

constructor TBTNode20_Int32.Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString='');
begin
  inherited Create(AParentNode, ANodeName,ANodeCaption);
  FNodeType := nt20_Int32;
  FData := 0;
  FDataSize := SizeOf(Int32);//64位下面读取出错
end;

procedure TBTNode20_Int32.WriteBuffer(const ASource:Pointer; ACount: Integer);
begin
  CopyMemoryData(@FData, ASource, ACount);
end;

procedure TBTNode20_Int32.SetData(const Value: Int32);
begin
  FData := Value;
end;

procedure TBTNode20_Int32.ReadBuffer(var ADest:Pointer);
begin
  CopyMemoryData(ADest, @FData, FDataSize);
end;

{ TBTNode20_UInt8 }

procedure TBTNode20_UInt8.ClearData;
begin
  inherited;
  FData := 0;
end;

constructor TBTNode20_UInt8.Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString='');
begin
  inherited Create(AParentNode, ANodeName,ANodeCaption);
  FNodeType := nt20_UInt8;
  FData := 0;
  FDataSize := SizeOf(Byte);
end;

procedure TBTNode20_UInt8.WriteBuffer(const ASource:Pointer; ACount: Integer);
begin
  CopyMemoryData(@FData, ASource, ACount);
end;

procedure TBTNode20_UInt8.SetData(const Value: Byte);
begin
  FData := Value;
end;

procedure TBTNode20_UInt8.ReadBuffer(var ADest:Pointer);
begin
  CopyMemoryData(ADest, @FData, FDataSize);
end;

//{ TBTNode20_UInt16 }
//
//procedure TBTNode20_UInt16.ClearData;
//begin
//  inherited;
//  FData := 0;
//end;
//
//constructor TBTNode20_UInt16.Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString='');
//begin
//  inherited Create(AParentNode, ANodeName,ANodeCaption);
//  FNodeType := nt20_UInt16;
//  FData := 0;
//  FDataSize := SizeOf(Word);
//end;
//
//procedure TBTNode20_UInt16.WriteBuffer(const ASource:Pointer; ACount: Integer);
//begin
//  CopyMemoryData(@FData, ASource, ACount);
//end;
//
//procedure TBTNode20_UInt16.SetData(const Value: Word);
//begin
//  FData := Value;
//end;
//
//procedure TBTNode20_UInt16.ReadBuffer(var ADest:Pointer);
//begin
//  CopyMemoryData(ADest, @FData, FDataSize);
//end;

{ TBTNode20_UInt32 }

procedure TBTNode20_UInt32.ClearData;
begin
  inherited;
  FData := 0;
end;

constructor TBTNode20_UInt32.Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString='');
begin
  inherited Create(AParentNode, ANodeName,ANodeCaption);
  FNodeType := nt20_UInt32;
  FData := 0;
  FDataSize := SizeOf(LongWord);
end;

procedure TBTNode20_UInt32.WriteBuffer(const ASource:Pointer; ACount: Integer);
begin
  CopyMemoryData(@FData, ASource, ACount);
end;

procedure TBTNode20_UInt32.SetData(const Value: LongWord);
begin
  FData := Value;
end;

procedure TBTNode20_UInt32.ReadBuffer(var ADest:Pointer);
begin
  CopyMemoryData(ADest, @FData, FDataSize);
end;

{ TBTNode20_Real32 }
//
//procedure TBTNode20_Real32.ClearData;
//begin
//  inherited;
//  FData := 0.0;
//end;
//
//constructor TBTNode20_Real32.Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString='');
//begin
//  inherited Create(AParentNode, ANodeName,ANodeCaption);
//  FNodeType := nt20_Real32;
//  FData := 0.0;
//  FDataSize := SizeOf(Single);
//end;
//
//procedure TBTNode20_Real32.WriteBuffer(const ASource:Pointer; ACount: Integer);
//begin
//  CopyMemoryData(@FData, ASource, ACount);
//end;
//
//procedure TBTNode20_Real32.SetData(const Value: Single);
//begin
//  FData := Value;
//end;
//
//procedure TBTNode20_Real32.ReadBuffer(var ADest:Pointer);
//begin
//  CopyMemoryData(ADest, @FData, FDataSize);
//end;
//
{ TBTNode20_Real64 }

procedure TBTNode20_Real64.ClearData;
begin
  inherited;
  FData := 0.0;
end;

constructor TBTNode20_Real64.Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString='');
begin
  inherited Create(AParentNode, ANodeName,ANodeCaption);
  FNodeType := nt20_Real64;
  FData := 0.0;
  FDataSize := SizeOf(Double);
end;

procedure TBTNode20_Real64.WriteBuffer(const ASource:Pointer; ACount: Integer);
begin
  CopyMemoryData(@FData, ASource, ACount);
end;

procedure TBTNode20_Real64.SetData(const Value: Double);
begin
  FData := Value;
end;

procedure TBTNode20_Real64.ReadBuffer(var ADest:Pointer);
begin
  CopyMemoryData(ADest, @FData, FDataSize);
end;

//{ TBTNode20_Bool8 }
//
//procedure TBTNode20_Bool8.ClearData;
//begin
//  inherited;
//  FData := False;
//end;
//
//constructor TBTNode20_Bool8.Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString='');
//begin
//  inherited Create(AParentNode, ANodeName,ANodeCaption);
//  FNodeType := nt20_Bool8;
//  FData := False;
//  FDataSize := SizeOf(ByteBool);
//end;
//
//procedure TBTNode20_Bool8.WriteBuffer(const ASource:Pointer; ACount: Integer);
//begin
//  CopyMemoryData(@FData, ASource, ACount);
//end;
//
//procedure TBTNode20_Bool8.SetData(const Value: ByteBool);
//begin
//  FData := Value;
//end;
//
//procedure TBTNode20_Bool8.ReadBuffer(var ADest:Pointer);
//begin
//  CopyMemoryData(ADest, @FData, FDataSize);
//end;
//
//{ TBTNode20_Bool16 }
//
//procedure TBTNode20_Bool16.ClearData;
//begin
//  inherited;
//  FData := False;
//end;
//
//constructor TBTNode20_Bool16.Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString='');
//begin
//  inherited Create(AParentNode, ANodeName,ANodeCaption);
//  FNodeType := nt20_Bool16;
//  FData := False;
//  FDataSize := SizeOf(WordBool);
//end;
//
//procedure TBTNode20_Bool16.WriteBuffer(const ASource:Pointer; ACount: Integer);
//begin
//  CopyMemoryData(@FData, ASource, ACount);
//end;
//
//procedure TBTNode20_Bool16.SetData(const Value: WordBool);
//begin
//  FData := Value;
//end;
//
//procedure TBTNode20_Bool16.ReadBuffer(var ADest:Pointer);
//begin
//  CopyMemoryData(ADest, @FData, FDataSize);
//end;

{ TBTNode20_Bool32 }

procedure TBTNode20_Bool32.ClearData;
begin
  inherited;
  FData := False;
end;

constructor TBTNode20_Bool32.Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString='');
begin
  inherited Create(AParentNode, ANodeName, ANodeCaption);
  FNodeType := nt20_Bool32;
  FData := False;
  FDataSize := SizeOf(LongBool);
end;

procedure TBTNode20_Bool32.WriteBuffer(const ASource:Pointer; ACount: Integer);
begin
  CopyMemoryData(@FData, ASource, ACount);
end;

procedure TBTNode20_Bool32.SetData(const Value: LongBool);
begin
  FData := Value;
end;

procedure TBTNode20_Bool32.ReadBuffer(var ADest:Pointer);
begin
  CopyMemoryData(ADest, @FData, FDataSize);
end;

{ TBTNode20_Binary }

procedure TBTNode20_Binary.ClearData;
begin
  inherited;
  if FDataSize > 0 then begin
    FreeMemory(FData);
    FData := nil;
    FDataSize := 0;
  end;
end;

constructor TBTNode20_Binary.Create(AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString='');
begin
  inherited Create(AParentNode, ANodeName, ANodeCaption);
  FNodeType := nt20_Binary;
  FData := nil;
end;

function TBTNode20_Binary.GetData: Pointer;
begin
  Result := FData;
end;

procedure TBTNode20_Binary.WriteBuffer(const ASource:Pointer; ACount: Integer);
begin
  ClearData();
  if ACount > 0 then begin
    FData := GetMemory(ACount);
    CopyMemoryData(FData, ASource, ACount);
    FDataSize := ACount;
  end;
end;

procedure TBTNode20_Binary.LoadFromFile(const FileName: string);
var
  objStream: TFileStream;
begin
  objStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
  try
    LoadFromStream(objStream);
  finally
    FreeAndNil(objStream);
  end;
end;

procedure TBTNode20_Binary.LoadFromStream(Stream: TStream);
var
  nDataSize: Integer;
begin
  nDataSize := Integer(Stream.Size);

  ClearData();
  if nDataSize > 0 then
  begin
    FData := GetMemory(nDataSize);
    Stream.Position := 0;
    Stream.ReadBuffer(FData^, nDataSize);
    FDataSize := nDataSize;
  end;
end;

procedure TBTNode20_Binary.SaveToFile(const FileName: string);
var
  objStream: TFileStream;
begin
  objStream := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(objStream);
  finally
    FreeAndNil(objStream);
  end;
end;

procedure TBTNode20_Binary.SaveToStream(Stream: TStream);
begin
  if FDataSize > 0 then
    Stream.WriteBuffer(FData^, FDataSize);
end;

procedure TBTNode20_Binary.ReadBuffer(var ADest:Pointer);
begin
  if FDataSize > 0 then begin
    CopyMemoryData(ADest, FData, FDataSize);
  end;
end;

{ TBTNode20_Int64 }
//
//procedure TBTNode20_Int64.ClearData;
//begin
//  inherited;
//  FData := 0;
//end;
//
//constructor TBTNode20_Int64.Create(AParentNode: TBTNode20;
//  ANodeName: WideString;const ANodeCaption:WideString='');
//begin
//  inherited Create(AParentNode, ANodeName, ANodeCaption);
//  FNodeType := nt20_Int64;
//  FData := 0;
//  FDataSize := SizeOf(Int64);
//end;
//
//procedure TBTNode20_Int64.WriteBuffer(const ASource:Pointer; ACount: Integer);
//begin
//  CopyMemoryData(@FData, ASource, ACount);
//end;
//
//procedure TBTNode20_Int64.SetData(const Value: Int64);
//begin
//  FData := Value;
//end;
//
//procedure TBTNode20_Int64.ReadBuffer(var ADest:Pointer);
//begin
//  CopyMemoryData(ADest, @FData, FDataSize);
//end;
//
//{ TBTNode20_Real48 }
//
//procedure TBTNode20_Real48.ClearData;
//begin
//  inherited;
//  FData := 0.0;
//end;
//
//constructor TBTNode20_Real48.Create(AParentNode: TBTNode20;
//  ANodeName: WideString;const ANodeCaption:WideString='');
//begin
//  inherited Create(AParentNode, ANodeName, ANodeCaption);
//  FNodeType := nt20_Real48;
//  FData := 0.0;
//  FDataSize := SizeOf(Real48);
//end;
//
//procedure TBTNode20_Real48.WriteBuffer(const ASource:Pointer; ACount: Integer);
//begin
//  CopyMemoryData(@FData, ASource, ACount);
//end;
//
//procedure TBTNode20_Real48.SetData(const Value: Real48);
//begin
//  FData := Value;
//end;
//
//procedure TBTNode20_Real48.ReadBuffer(var ADest:Pointer);
//begin
//  CopyMemoryData(ADest, @FData, FDataSize);
//end;
//
//{ TBTNode20_Real80 }
//
//procedure TBTNode20_Real80.ClearData;
//begin
//  inherited;
//  FData := 0.0;
//end;
//
//constructor TBTNode20_Real80.Create(AParentNode: TBTNode20;
//  ANodeName: WideString;const ANodeCaption:WideString='');
//begin
//  inherited Create(AParentNode, ANodeName, ANodeCaption);
//  FNodeType := nt20_Real80;
//  FData := 0.0;
//  FDataSize := SizeOf(Extended);
//end;
//
//procedure TBTNode20_Real80.WriteBuffer(const ASource:Pointer; ACount: Integer);
//begin
//  CopyMemoryData(@FData, ASource, ACount);
//end;
//
//procedure TBTNode20_Real80.SetData(const Value: Extended);
//begin
//  FData := Value;
//end;
//
//procedure TBTNode20_Real80.ReadBuffer(var ADest:Pointer);
//begin
//  CopyMemoryData(ADest, @FData, FDataSize);
//end;
//
//{ TBTNode20_Currency }
//
//procedure TBTNode20_Currency.ClearData;
//begin
//  inherited;
//  FData := 0.0;
//end;
//
//constructor TBTNode20_Currency.Create(AParentNode: TBTNode20;
//  ANodeName: WideString;const ANodeCaption:WideString='');
//begin
//  inherited Create(AParentNode, ANodeName, ANodeCaption);
//  FNodeType := nt20_Currency;
//  FData := 0.0;
//  FDataSize := SizeOf(Currency);
//end;
//
//procedure TBTNode20_Currency.WriteBuffer(const ASource:Pointer; ACount: Integer);
//begin
//  CopyMemoryData(@FData, ASource, ACount);
//end;
//
//procedure TBTNode20_Currency.SetData(const Value: Currency);
//begin
//  FData := Value;
//end;
//
//procedure TBTNode20_Currency.ReadBuffer(var ADest:Pointer);
//begin
//  CopyMemoryData(ADest, @FData, FDataSize);
//end;
//
{ TBTNode20_DateTime }

procedure TBTNode20_DateTime.ClearData;
begin
  inherited;
  FData := Now();
end;

constructor TBTNode20_DateTime.Create(AParentNode: TBTNode20;
  ANodeName: WideString;const ANodeCaption:WideString='');
begin
  inherited Create(AParentNode, ANodeName, ANodeCaption);
  FNodeType := nt20_DateTime;
  FData := 0.0;
  FDataSize := SizeOf(TDateTime);
end;

procedure TBTNode20_DateTime.WriteBuffer(const ASource:Pointer; ACount: Integer);
begin
  CopyMemoryData(@FData, ASource, ACount);
end;

procedure TBTNode20_DateTime.SetData(const Value: TDateTime);
begin
  FData := Value;
end;

procedure TBTNode20_DateTime.ReadBuffer(var ADest:Pointer);
begin
  CopyMemoryData(ADest, @FData, FDataSize);
end;

//{ TBTNode20_TimeStamp }
//
//procedure TBTNode20_TimeStamp.ClearData;
//begin
//  inherited;
//
//end;
//
//constructor TBTNode20_TimeStamp.Create(AParentNode: TBTNode20;
//  ANodeName: WideString;const ANodeCaption:WideString='');
//begin
//  inherited Create(AParentNode, ANodeName, ANodeCaption);
//  FNodeType := nt20_TimeStamp;
//  FDataSize := SizeOf(TTimeStamp);
//end;
//
//procedure TBTNode20_TimeStamp.WriteBuffer(const ASource:Pointer; ACount: Integer);
//begin
//  CopyMemoryData(@FData, ASource, ACount);
//end;
//
//procedure TBTNode20_TimeStamp.SetData(const Value: TTimeStamp);
//begin
//  FData.Time := Value.Time;
//  FData.Date := Value.Date;
//end;
//
//procedure TBTNode20_TimeStamp.ReadBuffer(var ADest:Pointer);
//begin
//  CopyMemoryData(ADest, @FData, FDataSize);
//end;
//
//{ TBTNode20_GUID }
//
//procedure TBTNode20_GUID.ClearData;
//begin
//  inherited;
//
//end;
//
//constructor TBTNode20_GUID.Create(AParentNode: TBTNode20;
//  ANodeName: WideString;const ANodeCaption:WideString='');
//begin
//  inherited Create(AParentNode, ANodeName, ANodeCaption);
//  FNodeType := nt20_GUID;
//  FDataSize := SizeOf(TGUID);
//end;
//
//function TBTNode20_GUID.GetData: PGUID;
//begin
//  Result := @FData;
//end;
//
//procedure TBTNode20_GUID.WriteBuffer(const ASource:Pointer; ACount: Integer);
//begin
//  CopyMemoryData(@FData, ASource, ACount);
//end;
//
//procedure TBTNode20_GUID.SetData(const Value:PGUID);
//begin
//  CopyMemoryData(@FData, Value, SizeOf(TGUID));
//end;
//
//procedure TBTNode20_GUID.ReadBuffer(var ADest:Pointer);
//begin
//  CopyMemoryData(ADest, @FData, FDataSize);
//end;

{ TBTDOC20 }

procedure TBTDOC20.Assign(Source: TBTDOC20);
var
  objStream: TMemoryStream;
begin
  objStream := TMemoryStream.Create();
  try
    Source.SaveToStream(objStream);
    objStream.Position := 0;
    LoadFromStream(objStream);
  finally
    FreeAndNil(objStream);
  end;
end;

function TBTDOC20.CalculateNodeSize(
  ANode: TBTNode20): Integer;
var
  nNodeNameSize: Integer;
  nNodeCaptionSize: Integer;
begin
  nNodeNameSize := System.Length(ANode.NodeName) * SizeOf(WideChar);
  if nNodeNameSize > 0 then
    nNodeNameSize := nNodeNameSize + SizeOf(WideChar);

  nNodeCaptionSize := System.Length(ANode.NodeCaption) * SizeOf(WideChar);
  if nNodeCaptionSize > 0 then
    nNodeCaptionSize := nNodeCaptionSize + SizeOf(WideChar);

  Result := SizeOf(TBTNodeHeader) + nNodeNameSize + nNodeCaptionSize + Integer(ANode.DataSize);
end;

function TBTDOC20.CalculateNodesSize(
  ANodeList: TBTNodeList20): Integer;
var
  i: Integer;
  objNode: TBTNode20;
begin
  Result := 0;
  i := ANodeList.Count - 1;
  while i >= 0 do begin
    objNode := ANodeList.Items[i];

    Result := Result + CalculateNodeSize(objNode);

    if objNode.ChildNodes.Count > 0 then begin
      Result := Result + CalculateNodesSize(objNode.ChildNodes);
    end;

    if i > ANodeList.Count - 1 then
      i := ANodeList.Count - 1
    else
      Dec(i);
  end;
end;

constructor TBTDOC20.Create;
begin
  inherited;
  FVersion := BTDOC_VERSION_20;
  FTopNode := TBTNode20_Directory.Create(nil, '\');
end;

destructor TBTDOC20.Destroy;
begin
  FreeAndNil(FTopNode);
  inherited;
end;

function TBTDOC20.GetDocBufSize: DWORD;
begin
  Result := SizeOf(TBTDocHeader) + //Doc Header
    GetNameBytes() + //Doc Name
    CalculateNodeSize(FTopNode) + //TopNode Header
    CalculateNodesSize(FTopNode.ChildNodes); //ChildNodes
end;

procedure TBTDOC20.Save(var pDest:Pointer);
var
  pDataBuf:Pointer;
begin
  pDataBuf:=pDest;
  DocHeaderToBuffer(pDataBuf);
  DocNodeToBuffer(pDataBuf, FTopNode);
  DocNodesToBuffer(pDataBuf, FTopNode.ChildNodes);
end;

procedure TBTDOC20.Load(const pSrc:Pointer);
var
  pSource:Pointer;
  nCurPos: Integer;
  nChildNodes: Integer;
begin
  Clear();

  pSource := pSrc;
  nCurPos := 0;

  DocHeaderFromBuffer(pSource, nCurPos);
  FreeAndNil(FTopNode);
  DocNodeFromBuffer(pSource, nCurPos, nil, TBTNode20(FTopNode), nChildNodes);
  DocNodesFromBuffer(pSource, nCurPos, FTopNode, nChildNodes);
end;

procedure TBTDOC20.LoadFromFile(const FileName: string);
var
  objStream: TFileStream;
begin
  objStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
  try
    LoadFromStream(objStream);
  finally
    FreeAndNil(objStream);
  end;
end;

procedure TBTDOC20.SaveToFile(const FileName: string);
var
  objStream: TFileStream;
begin
  objStream := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(objStream);
  finally
    FreeAndNil(objStream);
  end;
end;

procedure TBTDOC20.DocNodesToBuffer(var ADest: Pointer;
  ANodeList: TBTNodeList20);
var
  i: Integer;
  objNode: TBTNode20;
begin
  for i := 0 to ANodeList.Count - 1 do
  begin
    objNode := ANodeList.Items[i];

    DocNodeToBuffer(ADest, objNode);

    if objNode.ChildNodes.Count > 0 then
    begin
      DocNodesToBuffer(ADest, objNode.ChildNodes);
    end;
  end;//for
end;

procedure TBTDOC20.DocNodeToBuffer(var ADest: Pointer;
  ANode: TBTNode20);
var
  nNodeNameSize: Integer;
  nNodeCaptionSize: Integer;
  NodeHeader: TBTNodeHeader;
begin
  nNodeNameSize := System.Length(ANode.NodeName) * SizeOf(WideChar);
  if nNodeNameSize > 0 then
    nNodeNameSize := nNodeNameSize + SizeOf(WideChar);

  nNodeCaptionSize := System.Length(ANode.NodeCaption) * SizeOf(WideChar);
  if nNodeCaptionSize > 0 then
    nNodeCaptionSize := nNodeCaptionSize + SizeOf(WideChar);

  NodeHeader.bNodeType := Ord(ANode.NodeType);
  NodeHeader.dwChildCount := ANode.ChildNodes.Count;
  NodeHeader.bNameLength := nNodeNameSize;
  NodeHeader.bCaptionLength := nNodeCaptionSize;
  NodeHeader.dwDataLength := ANode.DataSize;

  CopyMemoryData(ADest, @NodeHeader, SizeOf(TBTNodeHeader));
  Inc(PByte(ADest), SizeOf(TBTNodeHeader));

  CopyMemoryData(ADest, PWideChar(ANode.FNodeName), NodeHeader.bNameLength);
  Inc(PByte(ADest), NodeHeader.bNameLength);

  CopyMemoryData(ADest, PWideChar(ANode.FNodeCaption), NodeHeader.bCaptionLength);
  Inc(PByte(ADest), NodeHeader.bCaptionLength);

  ANode.ReadBuffer(ADest);
  Inc(PByte(ADest), ANode.DataSize);
end;

class function TBTDOC20.CreateNode(ANodeType: TBTNodeType20;
  AParentNode: TBTNode20; ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
begin
  case ANodeType of
    nt20_Directory: Result := TBTNode20_Directory.Create(AParentNode, ANodeName, ANodeCaption);
    nt20_Class: Result := TBTNode20_Class.Create(AParentNode, ANodeName, ANodeCaption);
//    nt20_AnsiChar: Result := TBTNode20_AnsiChar.Create(AParentNode, ANodeName, ANodeCaption);
//    nt20_WideChar: Result := TBTNode20_WideChar.Create(AParentNode, ANodeName, ANodeCaption);
//    nt20_AnsiString: Result := TBTNode20_AnsiString.Create(AParentNode, ANodeName, ANodeCaption);
    nt20_WideString: Result := TBTNode20_WideString.Create(AParentNode, ANodeName, ANodeCaption);
//    nt20_Font: Result := TBTNode20_Font.Create(AParentNode, ANodeName, ANodeCaption);
    nt20_Color: Result := TBTNode20_Color.Create(AParentNode, ANodeName, ANodeCaption);
//    nt20_Int8: Result := TBTNode20_Int8.Create(AParentNode, ANodeName, ANodeCaption);
//    nt20_Int16: Result := TBTNode20_Int16.Create(AParentNode, ANodeName, ANodeCaption);
    nt20_Int32: Result := TBTNode20_Int32.Create(AParentNode, ANodeName, ANodeCaption);
//    nt20_Int64: Result := TBTNode20_Int64.Create(AParentNode, ANodeName, ANodeCaption);
    nt20_UInt8: Result := TBTNode20_UInt8.Create(AParentNode, ANodeName, ANodeCaption);
//    nt20_UInt16: Result := TBTNode20_UInt16.Create(AParentNode, ANodeName, ANodeCaption);
    nt20_UInt32: Result := TBTNode20_UInt32.Create(AParentNode, ANodeName, ANodeCaption);
//    nt20_Real32: Result := TBTNode20_Real32.Create(AParentNode, ANodeName, ANodeCaption);
//    nt20_Real48: Result := TBTNode20_Real48.Create(AParentNode, ANodeName, ANodeCaption);
    nt20_Real64: Result := TBTNode20_Real64.Create(AParentNode, ANodeName, ANodeCaption);
//    nt20_Real80: Result := TBTNode20_Real80.Create(AParentNode, ANodeName, ANodeCaption);
//    nt20_Currency: Result := TBTNode20_Currency.Create(AParentNode, ANodeName, ANodeCaption);
    nt20_DateTime: Result := TBTNode20_DateTime.Create(AParentNode, ANodeName, ANodeCaption);
//    nt20_TimeStamp: Result := TBTNode20_TimeStamp.Create(AParentNode, ANodeName, ANodeCaption);
//    nt20_Bool8: Result := TBTNode20_Bool8.Create(AParentNode, ANodeName, ANodeCaption);
//    nt20_Bool16: Result := TBTNode20_Bool16.Create(AParentNode, ANodeName, ANodeCaption);
    nt20_Bool32: Result := TBTNode20_Bool32.Create(AParentNode, ANodeName, ANodeCaption);
//    nt20_Guid: Result := TBTNode20_GUID.Create(AParentNode, ANodeName, ANodeCaption);
    nt20_Binary: Result := TBTNode20_Binary.Create(AParentNode, ANodeName, ANodeCaption);
    else ShowException(EXCEPTION_IVALIDNODE);
  end;//case of
end;

procedure TBTDOC20.LoadFromStream(Stream: TStream);
var
  pDataBuf: Pointer;
  nDataSize: Integer;
begin
  nDataSize := Integer(Stream.Size);

  if nDataSize < SizeOf(TBTDocHeader) then
    ShowException(EXCEPTION_IVALIDDOCUMENT);

  pDataBuf := GetMemory(nDataSize);
  try
    Stream.ReadBuffer(pDataBuf^, nDataSize);
    Load(pDataBuf);
  finally
    FreeMemory(pDataBuf);
  end;
end;

//class function TBTDOC20.PrefetchData(const ADocBuf; var AVersion: BYTE;
//  var AName: WideString): Boolean;
//var
//  DocHeader: TBTDocHeader;
//  pSource: PBYTE;
//  TempName: WideString;
//begin
//  pSource := PBYTE(@ADocBuf);
//
//  CopyMemoryData(@DocHeader, pSource, SizeOf(TBTDocHeader));
//  Inc(pSource, SizeOf(TBTDocHeader));
//
//  TempName := '';
//  if DocHeader.bNameLength <> 0 then
//  begin
//    TempName := StrPas(PWideChar(pSource));
//  end;
//
//  if DocHeader.bVersion <> BTDOC_VERSION_20 then
//    ShowException(EXCEPTION_IVALIDVERSION);
//
//  AVersion := DocHeader.bVersion;
//  AName := TempName;
//
//  Result := True;
//end;

procedure TBTDOC20.SaveToStream(Stream: TStream);
var
  pDataBuf: Pointer;
  nDataSize: Integer;
begin
  nDataSize := GetDocBufSize();

  if nDataSize > 0 then
  begin
    pDataBuf := GetMemory(nDataSize);
    try
      Save(pDataBuf);
      Stream.Size := nDataSize;
      Stream.Position := 0;
      Stream.WriteBuffer(pDataBuf^, nDataSize);
    finally
      FreeMemory(pDataBuf);
    end;
  end;
end;

function TBTDOC20.FindNodeByName(ANodeName: WideString;
  ARecursive: Boolean): TBTNode20;
begin
  if ARecursive then
    Result := RecursiveFindNode(FTopNode.ChildNodes, ANodeName)
  else
    Result := FTopNode.ChildNodes.FindNodeByName(ANodeName);
end;

function TBTDOC20.RecursiveFindNode(ANodes: TBTNodeList20;
  ANodeName: WideString;const ANodeCaption:WideString=''): TBTNode20;
var
  i: Integer;
  objNode: TBTNode20;
begin
  Result := nil;

  i := ANodes.Count - 1;
  while i >= 0 do begin
    objNode := ANodes.Items[i];

    if objNode.NodeName = ANodeName then begin
      Result := objNode;
      Exit;
    end;

    if objNode.ChildNodes.Count > 0 then begin
      Result := RecursiveFindNode(objNode.ChildNodes, ANodeName);
      if Result <> nil then Exit;
    end;

    if i > ANodes.Count - 1 then
      i := ANodes.Count - 1
    else
      Dec(i);
  end;
end;

procedure TBTDOC20.DocHeaderFromBuffer(var ASource: Pointer;var ACurPos: Integer);
var
  DocHeader: TBTDocHeader;
  TempName: WideString;
begin
  CopyMemoryData(@DocHeader, ASource, SizeOf(TBTDocHeader));
  Inc(PByte(ASource), SizeOf(TBTDocHeader));
  Inc(ACurPos, SizeOf(TBTDocHeader));

  TempName := '';
  if DocHeader.bNameLength <> 0 then
  begin
//    TempName := StrPas(PWideChar(ASource));
    TempName := PWideChar(ASource);
    Inc(PByte(ASource), DocHeader.bNameLength);
    Inc(ACurPos, DocHeader.bNameLength);
  end;

  if DocHeader.bVersion <> BTDOC_VERSION_20 then
    ShowException(EXCEPTION_IVALIDVERSION);

  FVersion := DocHeader.bVersion;
  FName := TempName;
end;

procedure TBTDOC20.DocNodeFromBuffer(var ASource: Pointer;
  var ACurPos: Integer; AParentNode: TBTNode20;
  var ANode: TBTNode20; var AChildCount: Integer);
var
  NodeHeader: TBTNodeHeader;
begin
  //Read Node Header
  CopyMemoryData(@NodeHeader, ASource, SizeOf(TBTNodeHeader));
  Inc(PByte(ASource), SizeOf(TBTNodeHeader));
  Inc(ACurPos, SizeOf(TBTNodeHeader));

  AChildCount := NodeHeader.dwChildCount;

  //Create Node
  ANode := CreateNode(TBTNodeType20(NodeHeader.bNodeType), AParentNode, 'NONAME');

  //Read Node Name
  if NodeHeader.bNameLength > 0 then begin
//    ANode.NodeName := StrPas(PWideChar(ASource));
    ANode.NodeName := PWideChar(ASource);
    Inc(PByte(ASource), NodeHeader.bNameLength);
    Inc(ACurPos, NodeHeader.bNameLength);
  end;

  //Read Node Caption
  if NodeHeader.bCaptionLength > 0 then begin
//    ANode.NodeCaption := StrPas(PWideChar(ASource));
    ANode.NodeCaption := PWideChar(ASource);
    Inc(PByte(ASource), NodeHeader.bCaptionLength);
    Inc(ACurPos, NodeHeader.bCaptionLength);
  end;

  //Read Node Data
  if NodeHeader.dwDataLength > 0 then begin
    ANode.WriteBuffer(ASource, NodeHeader.dwDataLength);
    Inc(PByte(ASource), NodeHeader.dwDataLength);
    Inc(ACurPos, NodeHeader.dwDataLength);
  end;
end;

procedure TBTDOC20.DocHeaderToBuffer(var ADest: Pointer);
var
  DocHeader: TBTDocHeader;
begin
  DocHeader.bVersion := FVersion;
  DocHeader.bNameLength := GetNameBytes();

  CopyMemoryData(ADest, @DocHeader, SizeOf(TBTDocHeader));
  Inc(PByte(ADest), SizeOf(TBTDocHeader));

  if DocHeader.bNameLength > 0 then
  begin
    CopyMemoryData(ADest, PWideChar(FName), DocHeader.bNameLength);
    Inc(PByte(ADest), DocHeader.bNameLength);
  end;
end;

procedure TBTDOC20.Clear;
begin
  FTopNode.ChildNodes.Clear();
end;

function TBTDOC20.GetNameBytes: Integer;
begin
  Result := System.Length(FName) * SizeOf(WideChar);
  if Result > 0 then Inc(Result, SizeOf(WideChar));
end;

function TBTDOC20.GetNodes: TBTNodeList20;
begin
  Result := FTopNode.ChildNodes;
end;

function TBTDOC20.GetSafeNodePath(ANodePath: WideString): WideString;
var
  I, L: Integer;
begin
  L := System.Length(ANodePath);
  I := 1;
  while (I <= L) and (ANodePath[I] = '\') do Inc(I);
  if I > L then
    Result := ''
  else
  begin
    while (ANodePath[L] = '\') do Dec(L);
    Result := Copy(ANodePath, I, L - I + 1);
  end;
end;

function TBTDOC20.FindNodeByPath(
  ANodePath: WideString): TBTNode20;
begin
  Result := SearchNode(FTopNode.ChildNodes, GetSafeNodePath(Trim(ANodePath)));
end;

function TBTDOC20.SearchNode(ANodeList: TBTNodeList20;
  ANodePath: WideString): TBTNode20;
var
  i, nPos, nLength: Integer;
  objNode: TBTNode20;
  strFirstNodeName, strChildNodePath: WideString;
begin
  Result := nil;
  nPos := Pos('\', ANodePath);
  nLength := System.Length(ANodePath);

  for i := 0 to ANodeList.Count - 1 do begin
    objNode := ANodeList.Items[i];

    if (nPos = 0) and (nLength > 0) then begin
      strFirstNodeName := ANodePath;
      strChildNodePath := '';
    end else begin
      strFirstNodeName := Copy(ANodePath, 1, nPos - 1);
      strChildNodePath := Copy(ANodePath, nPos + 1, nLength - nPos);
    end;

    if strFirstNodeName = '' then Exit;

    if objNode.NodeName = strFirstNodeName then begin
      if strChildNodePath <> '' then begin
        Result := SearchNode(objNode.ChildNodes, strChildNodePath);
      end else begin
        Result := objNode;
      end;
      if Result <> nil then Exit;
    end;

  end;//for
end;

procedure TBTDOC20.SetName(const Value: WideString);
var
  strTemp: WideString;
begin
  strTemp := Value;

  if System.Length(strTemp) > MAX_NODENAME_LENGTH then
  begin
    strTemp := Copy(strTemp, 1, MAX_NODENAME_LENGTH);
  end;

  FName := strTemp;
end;

procedure TBTDOC20.DocNodesFromBuffer(var ASource: Pointer;
  var ACurPos: Integer; AParentNode: TBTNode20; const AChildCount: Integer);
var
  i: Integer;
  objNode: TBTNode20;
  nChildNodes: Integer;
begin
  for i := 0 to AChildCount - 1 do
  begin
    //Read Node
    DocNodeFromBuffer(ASource, ACurPos, AParentNode, objNode, nChildNodes);

    //Read Child Nodes
    if nChildNodes > 0 then
    begin
      DocNodesFromBuffer(ASource, ACurPos, objNode, nChildNodes);
    end;
  end;//for
end;




end.


