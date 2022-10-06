unit TestChartFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,

  uSkinVirtualChartType,
  uDrawPathParam,
  uGraphicCommon,
  uDrawParam,

  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type
  TFrameTestChart = class(TFrame)
  private
    { Private declarations }
  public
    FSkinVirtualChart:TSkinVirtualChart;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;

implementation

{$R *.dfm}

{ TFrame1 }

constructor TFrameTestChart.Create(AOwner: TComponent);
var
  ASeries:TVirtualChartSeries;
  ADataItem:TVirtualChartSeriesDataItem;
begin
  inherited;
  FSkinVirtualChart:=TSkinVirtualChart.Create(Self);
  FSkinVirtualChart.Parent:=Self;
  FSkinVirtualChart.Align:=alClient;
  FSkinVirtualChart.AlignWithMargins:=True;


  FSkinVirtualChart.SelfOwnMaterialToDefault.BackColor.IsFill:=True;
  FSkinVirtualChart.SelfOwnMaterialToDefault.BarAxisLineParam.Color.Color:=clGray;
  FSkinVirtualChart.SelfOwnMaterialToDefault.DrawAxisCaptionParam.FontColor:=clGray;


//  //��ʾX��ķָ���
//  FSkinVirtualChart.Prop.FXAxisSkinListView.SkinControlType;
//  FSkinVirtualChart.Prop.FXAxisSkinListView.SelfOwnMaterialToDefault.BackColor.BorderWidth:=1;
//  FSkinVirtualChart.Prop.FXAxisSkinListView.SelfOwnMaterialToDefault.IsDrawColLine:=True;
//  FSkinVirtualChart.Prop.FXAxisSkinListView.SelfOwnMaterialToDefault.IsDrawColBeginLine:=True;
//  FSkinVirtualChart.Prop.FXAxisSkinListView.SelfOwnMaterialToDefault.IsDrawColEndLine:=True;
//
//  //��ʾY��ķָ���
//  FSkinVirtualChart.Prop.FYAxisSkinListView.SkinControlType;
//  FSkinVirtualChart.Prop.FYAxisSkinListView.SelfOwnMaterialToDefault.BackColor.BorderWidth:=1;
//  FSkinVirtualChart.Prop.FYAxisSkinListView.SelfOwnMaterialToDefault.DrawItemDevideParam.IsFill:=True;



  //X������
  FSkinVirtualChart.Properties.AxisItems.Add.Caption:='Mon';
  FSkinVirtualChart.Properties.AxisItems.Add.Caption:='Tue';
  FSkinVirtualChart.Properties.AxisItems.Add.Caption:='Wed';
  FSkinVirtualChart.Properties.AxisItems.Add.Caption:='Thu';
  FSkinVirtualChart.Properties.AxisItems.Add.Caption:='Fri';
  FSkinVirtualChart.Properties.AxisItems.Add.Caption:='Sat';
  FSkinVirtualChart.Properties.AxisItems.Add.Caption:='Sun';



//  //Y�������ϵĵ�,�Զ�������Ҫ����
//  FSkinVirtualChart.Properties.YAxisItems.Add.Caption:='1,800';
//  FSkinVirtualChart.Properties.YAxisItems.Add.Caption:='1,500';
//  FSkinVirtualChart.Properties.YAxisItems.Add.Caption:='1,200';
//  FSkinVirtualChart.Properties.YAxisItems.Add.Caption:='900';
//  FSkinVirtualChart.Properties.YAxisItems.Add.Caption:='600';
//  FSkinVirtualChart.Properties.YAxisItems.Add.Caption:='300';
//  FSkinVirtualChart.Properties.YAxisItems.Add.Caption:='0';



  //����
  ASeries:=TVirtualChartSeries(FSkinVirtualChart.Properties.SeriesList.Add);



//  ASeries.ChartType:=sctBar;
  ASeries.ChartType:=sctPie;//��ͼ
//  ASeries.ChartType:=sctLine;



  ASeries.Caption:='���';
  ADataItem:=ASeries.DataItems.Add;
  ADataItem.Caption:='Mon';
  ADataItem.Value:=300;

  ADataItem:=ASeries.DataItems.Add;
  ADataItem.Caption:='Tue';
  ADataItem.Value:=600;

  ADataItem:=ASeries.DataItems.Add;
  ADataItem.Caption:='Wed';
  ADataItem.Value:=700;

  ADataItem:=ASeries.DataItems.Add;
  ADataItem.Caption:='Thu';
  ADataItem.Value:=900;
//  ADataItem.Color:=clGreen;

  ADataItem:=ASeries.DataItems.Add;
  ADataItem.Caption:='Fri';
  ADataItem.Value:=1300;

  ADataItem:=ASeries.DataItems.Add;
  ADataItem.Caption:='Sat';
  ADataItem.Value:=1600;

  ADataItem:=ASeries.DataItems.Add;
  ADataItem.Caption:='Sun';
  ADataItem.Value:=1800;






end;

destructor TFrameTestChart.Destroy;
begin

  inherited;
end;

end.
