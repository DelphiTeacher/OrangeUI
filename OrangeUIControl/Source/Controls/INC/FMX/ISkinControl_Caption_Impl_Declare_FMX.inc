  protected
    //标题
    FCaption:String;
    function GetCaption:String;virtual;
    procedure SetCaption(const Value:String);virtual;
  public
    //标题
    {$IFNDEF FMXEdit}
    {$IFNDEF FMXComboEdit}
    {$IFNDEF FMXComboBox}
    {$IFNDEF FMXMemo}
    property StaticText:String read FCaption write FCaption;
    property StaticCaption:String read FCaption write FCaption;
    {$ENDIF}
    {$ENDIF}
    {$ENDIF}
    {$ENDIF}
  public
    //标题
    {$IFNDEF FMXEdit}
    {$IFNDEF FMXComboEdit}
    {$IFNDEF FMXComboBox}
    {$IFNDEF FMXMemo}
    property Caption:String read GetCaption write SetCaption;
    {$ENDIF}
    {$ENDIF}
    {$ENDIF}
    {$ENDIF}


    //这些控件需要自定义Text属性或是自带了
    {$IFNDEF FMXEdit}
    {$IFNDEF FMXComboEdit}
    {$IFNDEF FMXComboBox}
    {$IFNDEF FMXMemo}
    property Text:String read GetCaption write SetCaption;
    {$ENDIF}
    {$ENDIF}
    {$ENDIF}
    {$ENDIF}


