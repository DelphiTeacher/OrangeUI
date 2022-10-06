unit DashBoard_Projects_PieChart_ProjectStatusFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uDrawCanvas, uSkinItems,

  //公共素材模块
  EasyServiceCommonMaterialDataMoudle_VCL,


  uSkinVirtualChartType,
  uDrawPathParam,
  uGraphicCommon,
  uDrawParam,

  uSkinWindowsControl, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualGridType, uSkinItemGridType, uSkinPanelType, Vcl.StdCtrls,
  uSkinButtonType, uSkinVirtualListType, uSkinListViewType;

type
  TFramePieChart_ProjectStatus = class(TFrame)
    pnlClient: TSkinWinPanel;
    lblCaption: TLabel;
    SkinWinButton1: TSkinWinButton;
    lvData: TSkinWinListView;
    procedure gridDataResize(Sender: TObject);
  private
    { Private declarations }
  public
    FSkinVirtualChart:TSkinVirtualChart;
    constructor Create(AOwner: TComponent);
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TFramePieChart_ProjectStatus.gridDataResize(Sender: TObject);
begin
  //如果表格列是按比例的,那么每次拖动尺寸,都要重新计算
  //Self.gridData.Prop.Columns.GetListLayoutsManager.DoItemSizeChange(nil);
end;

constructor TFramePieChart_ProjectStatus.Create(AOwner: TComponent);
var
  ASeries:TVirtualChartSeries;
  ADataItem:TVirtualChartSeriesDataItem;
begin
  inherited;
  FSkinVirtualChart:=TSkinVirtualChart.Create(Self);
  FSkinVirtualChart.Parent:=Self;
  FSkinVirtualChart.SetBounds(
                          10,
                          Self.lblCaption.Top+lblCaption.Height+10,
                          Width-10-10,
                          Height-(lblCaption.Top+lblCaption.Height+10)-lvData.Height-10
                          );
  FSkinVirtualChart.Anchors:=[akLeft,akTop,akRight,akBottom];
//  FSkinVirtualChart.Align:=alClient;
//  FSkinVirtualChart.AlignWithMargins:=True;


//  FSkinVirtualChart.SelfOwnMaterialToDefault.BarSizePercent:=0.4;
//  FSkinVirtualChart.SelfOwnMaterialToDefault.BackColor.IsFill:=True;
//  FSkinVirtualChart.SelfOwnMaterialToDefault.BarAxisLineParam.Color.Color:=clGray;
//  FSkinVirtualChart.SelfOwnMaterialToDefault.DrawAxisCaptionParam.FontColor:=clGray;
  FSkinVirtualChart.SelfOwnMaterialToDefault.SeriesLegendListViewVisible:=False;
  FSkinVirtualChart.SelfOwnMaterialToDefault.PieInfoVisible:=False;
  FSkinVirtualChart.SelfOwnMaterialToDefault.PieInnerRadiusPercent:=0.5;
  FSkinVirtualChart.SelfOwnMaterialToDefault.FSeriesColorArray[0]:=$97CF0A;
  FSkinVirtualChart.SelfOwnMaterialToDefault.FSeriesColorArray[1]:=$F57C72;
  FSkinVirtualChart.SelfOwnMaterialToDefault.FSeriesColorArray[2]:=$7C5CFA;


//  //显示X轴的分隔线
//  FSkinVirtualChart.Prop.FXAxisSkinListView.SkinControlType;
//  FSkinVirtualChart.Prop.FXAxisSkinListView.SelfOwnMaterialToDefault.BackColor.BorderWidth:=1;
//  FSkinVirtualChart.Prop.FXAxisSkinListView.SelfOwnMaterialToDefault.IsDrawColLine:=True;
//  FSkinVirtualChart.Prop.FXAxisSkinListView.SelfOwnMaterialToDefault.IsDrawColBeginLine:=True;
//  FSkinVirtualChart.Prop.FXAxisSkinListView.SelfOwnMaterialToDefault.IsDrawColEndLine:=True;
//
//  //显示Y轴的分隔线
//  FSkinVirtualChart.Prop.FYAxisSkinListView.SkinControlType;
//  FSkinVirtualChart.Prop.FYAxisSkinListView.SelfOwnMaterialToDefault.BackColor.BorderWidth:=1;
//  FSkinVirtualChart.Prop.FYAxisSkinListView.SelfOwnMaterialToDefault.DrawItemDevideParam.IsFill:=True;



//  //X轴坐标
//  FSkinVirtualChart.Properties.XAxisItems.Add.Caption:='已完成';
//  FSkinVirtualChart.Properties.XAxisItems.Add.Caption:='进行中';
//  FSkinVirtualChart.Properties.XAxisItems.Add.Caption:='延期';



//  //Y轴坐标上的点,自动，不需要设置
//  FSkinVirtualChart.Properties.YAxisItems.Add.Caption:='1,800';
//  FSkinVirtualChart.Properties.YAxisItems.Add.Caption:='1,500';
//  FSkinVirtualChart.Properties.YAxisItems.Add.Caption:='1,200';
//  FSkinVirtualChart.Properties.YAxisItems.Add.Caption:='900';
//  FSkinVirtualChart.Properties.YAxisItems.Add.Caption:='600';
//  FSkinVirtualChart.Properties.YAxisItems.Add.Caption:='300';
//  FSkinVirtualChart.Properties.YAxisItems.Add.Caption:='0';



  //数据
  ASeries:=TVirtualChartSeries(FSkinVirtualChart.Properties.SeriesList.Add);
  //饼图
  ASeries.ChartType:=sctPie;
  ASeries.Caption:='进度';

  ADataItem:=ASeries.DataItems.Add;
  ADataItem.Caption:='已完成';
  ADataItem.Value:=64;

  ADataItem:=ASeries.DataItems.Add;
  ADataItem.Caption:='进行中';
  ADataItem.Value:=26;

  ADataItem:=ASeries.DataItems.Add;
  ADataItem.Caption:='延期';
  ADataItem.Value:=10;



end;

end.
