unit DashBoard_Analyse_BarChart_MonthSummaryFrame;

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
  uSkinButtonType;

type
  TFrameBarChart_MonthSummary = class(TFrame)
    pnlClient: TSkinWinPanel;
    lblCaption: TLabel;
    SkinWinButton1: TSkinWinButton;
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

procedure TFrameBarChart_MonthSummary.gridDataResize(Sender: TObject);
begin
  //如果表格列是按比例的,那么每次拖动尺寸,都要重新计算
  //Self.gridData.Prop.Columns.GetListLayoutsManager.DoItemSizeChange(nil);
end;

constructor TFrameBarChart_MonthSummary.Create(AOwner: TComponent);
var
  ASeries:TVirtualChartSeries;
  ADataItem:TVirtualChartSeriesDataItem;
begin
  inherited;
  FSkinVirtualChart:=TSkinVirtualChart.Create(Self);
  FSkinVirtualChart.Parent:=Self;
  FSkinVirtualChart.SetBounds(
                          10,
                          FSkinVirtualChart.Top+FSkinVirtualChart.Height+10,
                          Width-10-10,
                          Height-(FSkinVirtualChart.Top+FSkinVirtualChart.Height+10)-10
                          );
  FSkinVirtualChart.Anchors:=[akLeft,akTop,akRight,akBottom];
//  FSkinVirtualChart.Align:=alClient;
//  FSkinVirtualChart.AlignWithMargins:=True;


  FSkinVirtualChart.SelfOwnMaterialToDefault.BarSizePercent:=0.4;
  FSkinVirtualChart.SelfOwnMaterialToDefault.BackColor.IsFill:=True;
  FSkinVirtualChart.SelfOwnMaterialToDefault.BarAxisLineParam.Color.Color:=clGray;
  FSkinVirtualChart.SelfOwnMaterialToDefault.DrawAxisCaptionParam.FontColor:=clGray;


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



  //X轴坐标
  FSkinVirtualChart.Properties.AxisItems.Add.Caption:='Jan';
  FSkinVirtualChart.Properties.AxisItems.Add.Caption:='Feb';
  FSkinVirtualChart.Properties.AxisItems.Add.Caption:='Mar';
  FSkinVirtualChart.Properties.AxisItems.Add.Caption:='Apr';
  FSkinVirtualChart.Properties.AxisItems.Add.Caption:='May';
  FSkinVirtualChart.Properties.AxisItems.Add.Caption:='Jun';
  FSkinVirtualChart.Properties.AxisItems.Add.Caption:='Jul';
  FSkinVirtualChart.Properties.AxisItems.Add.Caption:='Aug';
  FSkinVirtualChart.Properties.AxisItems.Add.Caption:='Sep';
  FSkinVirtualChart.Properties.AxisItems.Add.Caption:='Oct';
  FSkinVirtualChart.Properties.AxisItems.Add.Caption:='Nov';
  FSkinVirtualChart.Properties.AxisItems.Add.Caption:='Dec';



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
  ASeries.Caption:='金额';

  ADataItem:=ASeries.DataItems.Add;
  ADataItem.Caption:='Jan';
  ADataItem.Value:=300;

  ADataItem:=ASeries.DataItems.Add;
  ADataItem.Caption:='Feb';
  ADataItem.Value:=600;

  ADataItem:=ASeries.DataItems.Add;
  ADataItem.Caption:='Mar';
  ADataItem.Value:=700;

  ADataItem:=ASeries.DataItems.Add;
  ADataItem.Caption:='Apr';
  ADataItem.Value:=900;
//  ADataItem.Color:=clGreen;

  ADataItem:=ASeries.DataItems.Add;
  ADataItem.Caption:='May';
  ADataItem.Value:=1300;

  ADataItem:=ASeries.DataItems.Add;
  ADataItem.Caption:='Hun';
  ADataItem.Value:=1600;

  ADataItem:=ASeries.DataItems.Add;
  ADataItem.Caption:='Jul';
  ADataItem.Value:=1800;

  ADataItem:=ASeries.DataItems.Add;
  ADataItem.Caption:='Aug';
  ADataItem.Value:=1400;

  ADataItem:=ASeries.DataItems.Add;
  ADataItem.Caption:='Sep';
  ADataItem.Value:=800;

  ADataItem:=ASeries.DataItems.Add;
  ADataItem.Caption:='Oct';
  ADataItem.Value:=700;

  ADataItem:=ASeries.DataItems.Add;
  ADataItem.Caption:='Nov';
  ADataItem.Value:=1500;

  ADataItem:=ASeries.DataItems.Add;
  ADataItem.Caption:='Dev';
  ADataItem.Value:=1100;






end;

end.
