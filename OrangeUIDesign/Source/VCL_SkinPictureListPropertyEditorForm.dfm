object frmSkinPictureListPropertyEditor: TfrmSkinPictureListPropertyEditor
  Left = 232
  Top = 143
  BorderIcons = [biSystemMenu]
  Caption = #22270#29255#21015#34920#32534#36753#22120
  ClientHeight = 568
  ClientWidth = 683
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    683
    568)
  PixelsPerInch = 96
  TextHeight = 13
  object lblImageIndex: TLabel
    Left = 532
    Top = 178
    Width = 100
    Height = 13
    Anchors = [akTop, akRight]
    Caption = #24403#21069#36873#20013#22270#29255#19979#26631':'
    ExplicitLeft = 453
  end
  object lblImageName: TLabel
    Left = 530
    Top = 218
    Width = 100
    Height = 13
    Anchors = [akTop, akRight]
    Caption = #24403#21069#36873#20013#22270#29255#21517#31216':'
    ExplicitLeft = 451
  end
  object lblFileName: TLabel
    Left = 530
    Top = 261
    Width = 100
    Height = 13
    Anchors = [akTop, akRight]
    Caption = #24403#21069#36873#20013#22270#29255#36335#24452':'
    ExplicitLeft = 451
  end
  object lblResourceName: TLabel
    Left = 530
    Top = 304
    Width = 124
    Height = 13
    Anchors = [akTop, akRight]
    Caption = #24403#21069#36873#20013#22270#29255#36164#28304#21517#31216':'
    ExplicitLeft = 451
  end
  object lblUrl: TLabel
    Left = 530
    Top = 346
    Width = 100
    Height = 13
    Anchors = [akTop, akRight]
    Caption = #24403#21069#36873#20013#22270#29255#38142#25509':'
    ExplicitLeft = 451
  end
  object OKButton: TButton
    Left = 590
    Top = 8
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = OKButtonClick
  end
  object CancelButton: TButton
    Left = 590
    Top = 39
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 10
    Top = 8
    Width = 502
    Height = 552
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 2
    DesignSize = (
      502
      552)
    object Add: TButton
      Left = 17
      Top = 521
      Width = 75
      Height = 23
      Anchors = [akLeft, akBottom]
      Caption = '&Add...'
      TabOrder = 0
      OnClick = AddClick
    end
    object Delete: TButton
      Left = 179
      Top = 521
      Width = 75
      Height = 23
      Anchors = [akLeft, akBottom]
      Caption = '&Delete'
      Enabled = False
      TabOrder = 1
      OnClick = DeleteClick
    end
    object Clear: TButton
      Left = 260
      Top = 521
      Width = 75
      Height = 23
      Anchors = [akLeft, akBottom]
      Caption = '&Clear'
      TabOrder = 2
      OnClick = ClearClick
    end
    object Replace: TButton
      Left = 98
      Top = 521
      Width = 75
      Height = 23
      Anchors = [akLeft, akBottom]
      Caption = '&Replace...'
      Enabled = False
      TabOrder = 3
      OnClick = ReplaceClick
    end
    object ExportPicture: TButton
      Left = 341
      Top = 521
      Width = 75
      Height = 23
      Anchors = [akLeft, akBottom]
      Caption = '&Export...'
      Enabled = False
      TabOrder = 4
      OnClick = ExportPictureClick
    end
    object ListView1: TListView
      Left = 9
      Top = 15
      Width = 485
      Height = 500
      Align = alCustom
      Anchors = [akLeft, akTop, akRight, akBottom]
      Columns = <>
      IconOptions.AutoArrange = True
      LargeImages = ImageList1
      TabOrder = 5
      OnAdvancedCustomDrawItem = ListView1AdvancedCustomDrawItem
      OnClick = ListView1Click
    end
  end
  object edtImageIndex: TEdit
    Left = 536
    Top = 197
    Width = 139
    Height = 21
    Anchors = [akTop, akRight]
    TabOrder = 3
  end
  object edtImageName: TEdit
    Left = 535
    Top = 238
    Width = 140
    Height = 21
    Anchors = [akTop, akRight]
    TabOrder = 4
  end
  object edtFileName: TEdit
    Left = 535
    Top = 281
    Width = 140
    Height = 21
    Anchors = [akTop, akRight]
    TabOrder = 5
  end
  object edtResourceName: TEdit
    Left = 535
    Top = 324
    Width = 140
    Height = 21
    Anchors = [akTop, akRight]
    TabOrder = 6
  end
  object edtUrl: TEdit
    Left = 537
    Top = 366
    Width = 140
    Height = 21
    Anchors = [akTop, akRight]
    TabOrder = 7
  end
  object SaveSelected: TButton
    Left = 565
    Top = 439
    Width = 80
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #20445#23384
    TabOrder = 8
    OnClick = SaveSelectedClick
  end
  object chkIsClipRound: TCheckBox
    Left = 536
    Top = 394
    Width = 153
    Height = 19
    Anchors = [akTop, akRight]
    Caption = #26159#21542#21098#35009#25104#22278#24418
    TabOrder = 9
  end
  object SaveDialog: TSavePictureDialog
    Filter = 
      'All (*.bmp;*.ico;*.emf;*.wmf)|*.bmp;*.ico;*.emf;*.wmf|Bitmaps (*' +
      '.bmp)|*.bmp|Icons (*.ico)|*.ico|Enhanced Metafiles (*.emf)|*.emf' +
      '|Metafiles (*.wmf)|*.wmf'
    Options = [ofOverwritePrompt, ofEnableSizing]
    Left = 236
    Top = 20
  end
  object OpenDialog: TOpenPictureDialog
    Left = 120
    Top = 16
  end
  object ImageList1: TImageList
    Height = 48
    Width = 48
    Left = 128
    Top = 88
  end
end
