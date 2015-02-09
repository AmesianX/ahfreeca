object fmMain: TfmMain
  Left = 0
  Top = 0
  Caption = 'Sample 02 - '#54868#49345#50517#52629' '#46972#51060#48652#47084#47532' '#49324#50857
  ClientHeight = 562
  ClientWidth = 784
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Image: TImage
    Left = 368
    Top = 52
    Width = 320
    Height = 240
  end
  object plCam: TPanel
    Left = 8
    Top = 52
    Width = 320
    Height = 240
    BevelOuter = bvNone
    Caption = 'plCam'
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 784
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object btCamOn: TButton
      Left = 8
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Cam On'
      TabOrder = 0
      OnClick = btCamOnClick
    end
    object btCamOff: TButton
      Left = 84
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Cam Off'
      TabOrder = 1
      OnClick = btCamOffClick
    end
    object btVideoZipStart: TButton
      Left = 184
      Top = 9
      Width = 75
      Height = 25
      Caption = 'VideoZip Start'
      TabOrder = 2
      OnClick = btVideoZipStartClick
    end
    object btVideoZipStop: TButton
      Left = 260
      Top = 9
      Width = 75
      Height = 25
      Caption = 'VideoZip Stop'
      TabOrder = 3
      OnClick = btVideoZipStopClick
    end
  end
  object Timer: TTimer
    Interval = 5
    Left = 24
    Top = 364
  end
end
