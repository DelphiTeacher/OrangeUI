object frmDrawPicturePropertyEditor: TfrmDrawPicturePropertyEditor
  Left = 0
  Top = 0
  Caption = #22270#29255#32534#36753#22120
  ClientHeight = 513
  ClientWidth = 933
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    933
    513)
  PixelsPerInch = 96
  TextHeight = 13
  object ScrollBox1: TScrollBox
    Left = 4
    Top = 3
    Width = 822
    Height = 478
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    object PaintBox1: TPaintBox
      Left = 0
      Top = 0
      Width = 105
      Height = 105
      OnPaint = PaintBox1Paint
    end
  end
  object Button1: TButton
    Left = 833
    Top = 23
    Width = 100
    Height = 25
    Margins.Bottom = 9
    Anchors = [akTop, akRight]
    Caption = #25171#24320'...'
    TabOrder = 1
    OnClick = Button1Click
  end
  object btnSave: TButton
    Left = 833
    Top = 60
    Width = 100
    Height = 25
    Margins.Bottom = 9
    Anchors = [akTop, akRight]
    Caption = #21478#23384#20026'...'
    TabOrder = 2
    OnClick = btnSaveClick
  end
  object btnOk: TButton
    Left = 833
    Top = 94
    Width = 100
    Height = 25
    Margins.Bottom = 9
    Anchors = [akTop, akRight]
    Caption = #30830#23450
    TabOrder = 3
    OnClick = btnOkClick
  end
  object Button2: TButton
    Left = 833
    Top = 128
    Width = 100
    Height = 25
    Margins.Bottom = 9
    Anchors = [akTop, akRight]
    Caption = #21462#28040
    TabOrder = 4
    OnClick = Button2Click
  end
  object Button4: TButton
    Left = 833
    Top = 192
    Width = 100
    Height = 25
    Margins.Bottom = 9
    Anchors = [akTop, akRight]
    Caption = #28165#38500
    TabOrder = 5
    OnClick = Button4Click
  end
  object SaveDialog1: TSavePictureDialog
    Left = 317
    Top = 84
  end
end
