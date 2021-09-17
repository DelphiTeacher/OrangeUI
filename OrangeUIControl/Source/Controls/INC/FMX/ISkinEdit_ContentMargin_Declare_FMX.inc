  private

    FContentMarginsLeft:Integer;
    FContentMarginsTop:Integer;
    FContentMarginsRight:Integer;
    FContentMarginsBottom:Integer;

    function GetContentMarginsLeft: Integer;
    function GetContentMarginsTop: Integer;
    function GetContentMarginsRight: Integer;
    function GetContentMarginsBottom: Integer;


    procedure SetContentMarginsLeft(const Value: Integer);
    procedure SetContentMarginsTop(const Value: Integer);
    procedure SetContentMarginsRight(const Value: Integer);
    procedure SetContentMarginsBottom(const Value: Integer);
  published

    Property ContentMarginsLeft:Integer read GetContentMarginsLeft write SetContentMarginsLeft;
    Property ContentMarginsTop:Integer read GetContentMarginsTop write SetContentMarginsTop;
    Property ContentMarginsRight:Integer read GetContentMarginsRight write SetContentMarginsRight;
    Property ContentMarginsBottom:Integer read GetContentMarginsBottom write SetContentMarginsBottom;

