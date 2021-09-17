object Form1: TForm1
  Left = 271
  Top = 114
  Caption = #26379#21451#22280#31034#20363#26381#21153#31471
  ClientHeight = 520
  ClientWidth = 917
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -45
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 54
  object Label1: TLabel
    Left = 94
    Top = 185
    Width = 80
    Height = 54
    Margins.Left = 13
    Margins.Top = 13
    Margins.Right = 13
    Margins.Bottom = 13
    Caption = 'Port'
  end
  object ButtonStart: TButton
    Left = 94
    Top = 31
    Width = 286
    Height = 94
    Margins.Left = 13
    Margins.Top = 13
    Margins.Right = 13
    Margins.Bottom = 13
    Caption = 'Start'
    TabOrder = 0
    OnClick = ButtonStartClick
  end
  object ButtonStop: TButton
    Left = 400
    Top = 31
    Width = 286
    Height = 94
    Margins.Left = 13
    Margins.Top = 13
    Margins.Right = 13
    Margins.Bottom = 13
    Caption = 'Stop'
    TabOrder = 1
    OnClick = ButtonStopClick
  end
  object EditPort: TEdit
    Left = 94
    Top = 256
    Width = 460
    Height = 62
    Margins.Left = 13
    Margins.Top = 13
    Margins.Right = 13
    Margins.Bottom = 13
    TabOrder = 2
    Text = '7040'
  end
  object ButtonOpenBrowser: TButton
    Left = 75
    Top = 379
    Width = 406
    Height = 95
    Margins.Left = 13
    Margins.Top = 13
    Margins.Right = 13
    Margins.Bottom = 13
    Caption = 'Open Browser'
    TabOrder = 3
    OnClick = ButtonOpenBrowserClick
  end
  object btnConfigDataBase: TButton
    Left = 501
    Top = 379
    Width = 337
    Height = 95
    Margins.Left = 13
    Margins.Top = 13
    Margins.Right = 13
    Margins.Bottom = 13
    Caption = #25968#25454#24211#35774#32622
    TabOrder = 4
    OnClick = btnConfigDataBaseClick
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    Left = 344
    Top = 128
  end
end
