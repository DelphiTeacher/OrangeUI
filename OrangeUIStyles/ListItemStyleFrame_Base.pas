//convert pas to utf8 by ¥
unit ListItemStyleFrame_Base;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uSkinItems,
  uSkinVirtualListType,
  uSkinCustomListType,

  BaseListItemStyleFrame, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinFireMonkeyControl, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel;

type
  //基类
  TFrameBaseListItemStyleBase = class(TFrameBaseListItemStyle,IFrameBaseListItemStyle)
  private
    { Private declarations }
  public
//    function GetItemDesignerPanel:TSkinItemDesignerPanel;override;
    { Public declarations }
  end;


implementation

{$R *.fmx}

{ TFrameBaseListItemStyleBase }

//function TFrameBaseListItemStyleBase.GetItemDesignerPanel: TSkinFMXItemDesignerPanel;
//begin
//  Result:=Inherited;
//end;

end.
