unit DashBoard_ProjectsFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Forms,


  Math,
  uSkinVirtualChartType,
  ListItemStyle_IconTop_CaptionDetailBottom,
//  ItemGrid_TwoCellTextFrame,
//  ItemGrid_MutliColorProgressBarColumnFrame,
  DashBoard_Projects_PieChart_ProjectStatusFrame,
  DashBoard_Projects_ItemGrid_TwoCellTextHasBackColorFrame,
  DashBoard_Analyse_BarChart_MonthSummaryFrame,

  uSkinWindowsControl, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinListViewType, uDrawCanvas, uSkinItems, Vcl.Controls;

type
  TFrameDashBoard_Projects=class(TFrame)
    lvData: TSkinWinListView;
    procedure FrameResize(Sender: TObject);
  private
    { Private declarations }
  public
//    FItemGrid_TwoCellTextFrame:TFrameItemGrid_TwoCellText;
//    FItemGrid_MultiColorProgressBarColumnFrame:TFrameItemGrid_MultiColorProgressBarColumn;
//    FItemGrid_MultiColorProgressBarColumnFrame2:TFrameItemGrid_MultiColorProgressBarColumn;
    FPieChart_ProjectStatusFrame:TFramePieChart_ProjectStatus;
    FItemGrid_TwoCellTextHasBackColorFrame:TFrameItemGrid_TwoCellTextHasBackColor;
    FBarChart_MonthSummaryFrame:TFrameBarChart_MonthSummary;

    FControlLayoutItems:TControlLayoutItems;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;

implementation

{$R *.dfm}

{ TFrameDashBoard }

constructor TFrameDashBoard_Projects.Create(AOwner: TComponent);
begin
  inherited;

  FPieChart_ProjectStatusFrame:=TFramePieChart_ProjectStatus.Create(Self);
  FPieChart_ProjectStatusFrame.Parent:=Self;

  FItemGrid_TwoCellTextHasBackColorFrame:=TFrameItemGrid_TwoCellTextHasBackColor.Create(Self);
  FItemGrid_TwoCellTextHasBackColorFrame.Name:='FItemGrid_TwoCellTextHasBackColorFrame';
  FItemGrid_TwoCellTextHasBackColorFrame.Parent:=Self;

//  FItemGrid_MultiColorProgressBarColumnFrame2:=TFrameItemGrid_MultiColorProgressBarColumn.Create(Self);
//  FItemGrid_MultiColorProgressBarColumnFrame.Name:='FItemGrid_MultiColorProgressBarColumnFrame2';
//  FItemGrid_MultiColorProgressBarColumnFrame2.Parent:=Self;
//  FItemGrid_MultiColorProgressBarColumnFrame2.lblCaption.Caption:='社交媒体流量';
//  FItemGrid_MultiColorProgressBarColumnFrame2.gridData.Prop.Items[0].Caption:='Facebook';
//  FItemGrid_MultiColorProgressBarColumnFrame2.gridData.Prop.Items[0].Detail:='2,250';
//  FItemGrid_MultiColorProgressBarColumnFrame2.gridData.Prop.Items[0].Detail1:='30';
//
//  FItemGrid_MultiColorProgressBarColumnFrame2.gridData.Prop.Items[1].Caption:='Instagram';
//  FItemGrid_MultiColorProgressBarColumnFrame2.gridData.Prop.Items[1].Detail:='1,250';
//  FItemGrid_MultiColorProgressBarColumnFrame2.gridData.Prop.Items[1].Detail1:='10';
//
//  FItemGrid_MultiColorProgressBarColumnFrame2.gridData.Prop.Items[2].Caption:='Twitter';
//  FItemGrid_MultiColorProgressBarColumnFrame2.gridData.Prop.Items[2].Detail:='6,250';
//  FItemGrid_MultiColorProgressBarColumnFrame2.gridData.Prop.Items[2].Detail1:='60';
//
//  FItemGrid_MultiColorProgressBarColumnFrame2.gridData.Prop.Items[3].Caption:='LinkedIn';
//  FItemGrid_MultiColorProgressBarColumnFrame2.gridData.Prop.Items[3].Detail:='250';
//  FItemGrid_MultiColorProgressBarColumnFrame2.gridData.Prop.Items[3].Detail1:='5';






  FBarChart_MonthSummaryFrame:=TFrameBarChart_MonthSummary.Create(Self);
  FBarChart_MonthSummaryFrame.Parent:=Self;
  FBarChart_MonthSummaryFrame.FSkinVirtualChart.Prop.SeriesList[0].ChartType:=sctLine;








  FControlLayoutItems:=TControlLayoutItems.Create;
//  FControlLayoutItems.FListLayoutsManager.FIsItemCountFitControl:=True;
  FControlLayoutItems.FListLayoutsManager.FIsStrictItemCountPerLine:=False;
//  FControlLayoutItems.FListLayoutsManager.FIsChangeRowOnlyByItemIsRowEnd:=True;


  //添加两个需要排列的控件，两个控件的设计时高度要保持一致
  FControlLayoutItems.Add(lvData,-2,lvData.Height);


  FControlLayoutItems.Add(FPieChart_ProjectStatusFrame,0.3,FPieChart_ProjectStatusFrame.Height).FThisRowItemCount:=2;
  FControlLayoutItems.Add(FItemGrid_TwoCellTextHasBackColorFrame,0.7,FPieChart_ProjectStatusFrame.Height).FThisRowItemCount:=2;


//  FControlLayoutItems.Add(FItemGrid_MultiColorProgressBarColumnFrame2,-1,FItemGrid_MultiColorProgressBarColumnFrame2.Height);

  //一整排报表
  FControlLayoutItems.Add(FBarChart_MonthSummaryFrame,-2,FBarChart_MonthSummaryFrame.Height);



  //那个间隔
  FControlLayoutItems.FListLayoutsManager.ItemSpace:=10;
//  FControlLayoutItems.FListLayoutsManager.ItemCountPerLine:=2;


end;

destructor TFrameDashBoard_Projects.Destroy;
begin
  FreeAndNil(FControlLayoutItems);
  inherited;
end;

procedure TFrameDashBoard_Projects.FrameResize(Sender: TObject);
begin
  if FControlLayoutItems<>nil then
  begin
    FControlLayoutItems.FListLayoutsManager.ControlWidth:=Self.Width;
    FControlLayoutItems.FListLayoutsManager.ControlHeight:=Self.Height;
    FControlLayoutItems.FListLayoutsManager.DoItemSizeChange(nil);
    FControlLayoutItems.AlignControls;
    Height:=Ceil(FControlLayoutItems.FListLayoutsManager.CalcContentHeight);
  end;
end;

end.
