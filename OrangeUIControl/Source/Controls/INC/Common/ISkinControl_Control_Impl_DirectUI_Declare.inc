  protected


    FNeedHitTest:Boolean;


    FHitTestValue: Integer;



    //DirectUIģʽ���Ƿ���ʾ
    FDirectUIVisible:Boolean;



    //���ڵ����ʱ���ж����ĸ��ؼ�
    //DirectUI���ؼ��ӿ�,�ӹܿؼ��ĸ���
    FDirectUIParentIntf: IDirectUIParent;
    procedure SetDirectUIParentIntf(Value:IDirectUIParent);

    //λ�þ���
    function GetAutoSizeWidth:Double;
    function GetAutoSizeHeight:Double;
    function GetNeedHitTest:Boolean;
    function GetHitTestValue:Integer;
    function AutoSizeBoundsRect:TRectF;


    function GetDirectUIVisible:Boolean;



    //DirectUI���ؼ��ӿڣ��ӹ����Ļ��ƺ͸���
    property DirectUIParentIntf:IDirectUIParent read FDirectUIParentIntf write SetDirectUIParentIntf;
  published
    property DirectUIVisible:Boolean read GetDirectUIVisible write FDirectUIVisible;
