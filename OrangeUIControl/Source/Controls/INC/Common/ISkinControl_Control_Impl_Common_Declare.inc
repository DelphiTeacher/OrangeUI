

  protected
    {$IFNDEF WinForm}
    {$IFNDEF WinEdit}
    FCanvas:TDrawCanvas;
    {$ENDIF}
    {$ENDIF}




    FPaintData:TPaintData;

    FParentMouseEvent:Boolean;

    //����¼���������-�Զ�,����,������
    FMouseEventTransToParentType:TMouseEventTransToParentType;





    function GetParentMouseEvent:Boolean;
    procedure SetParentMouseEvent(const AValue:Boolean);


    function GetMouseEventTransToParentType:TMouseEventTransToParentType;
    procedure SetMouseEventTransToParentType(const AValue:TMouseEventTransToParentType);

    //���ÿؼ�λ�úͳߴ�
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: TControlSize);overload;
    procedure SetBounds(ABoundsRect:TRectF);overload;


    //��ȡ���ؼ����ӿؼ�
    function GetParentChildControlCount:Integer;
    function GetParentChildControl(Index:Integer):TChildControl;


    //��ȡ�ӿؼ�
    function GetChildControlCount:Integer;
    function GetChildControl(Index:Integer):TChildControl;
  public
    //���������Ϣ����
    FParentIsCanGesutrePageControl:Boolean;
    FParentCanGesutrePageControl:TControl;
  public
    //��Edit��IsInScrollBox��������Ҫʹ��
    FParentIsScrollBox:Boolean;
    FParentScrollBox:TControl;
    function GetParentIsScrollBox:Boolean;
    function GetParentScrollBox:TControl;
  protected

    //�ؼ���С����
    procedure Resize;override;

    //�ؼ��������
    procedure Loaded;override;

    procedure DoEnter;override;
    procedure DoExit;override;

    //�����ӿؼ��ͷ���Ϣ
    procedure Notification(AComponent:TComponent;Operation:TOperation);override;



    {$IFDEF FMX}
  public
    property Left:TControlSize read GetLeft write SetLeft;
    property Top:TControlSize read GetTop write SetTop;
    {$ENDIF}

  public
    //����Parent������¼�
    property MouseEventTransToParentType:TMouseEventTransToParentType read GetMouseEventTransToParentType write SetMouseEventTransToParentType;


  published
    //����Parent������¼�
    property ParentMouseEvent:Boolean read GetParentMouseEvent write SetParentMouseEvent;



  protected
    //DataJson.S[FieldName],AStringList.Value[FieldName]
    FBindItemFieldName:String;
//    //String,Boolean,Integer,Float....
//    FBindItemFieldType:TFieldType;
    //ItemCaption,ItemDetail,ItemDetail1
//    FBindItemDataTypeName:String;

    //DataJson.S[FieldName],AStringList.Value[FieldName]
    function GetBindItemFieldName:String;
    procedure SetBindItemFieldName(AValue:String);
//    //String,Boolean,Integer,Float....
//    function GetBindItemFieldType:TFieldType;
    //ItemCaption,ItemDetail,ItemDetail1
//    function GetBindItemDataTypeName:String;
  published
    property BindItemFieldName:String read GetBindItemFieldName write FBindItemFieldName;
//    property BindItemFieldType:TFieldType read GetBindItemFieldType write FBindItemFieldType;
//    property BindItemDataTypeName:String read GetBindItemDataTypeName write FBindItemDataTypeName;


