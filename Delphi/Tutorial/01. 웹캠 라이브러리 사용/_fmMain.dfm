object fmMain: TfmMain
  Left = 0
  Top = 0
  Caption = 'Sample 01 - '#50937' '#52896' '#46972#51060#48652#47084#47532' '#49324#50857
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
    Left = 0
    Top = 0
    Width = 105
    Height = 105
    AutoSize = True
  end
  object Panel1: TPanel
    Left = 463
    Top = 321
    Width = 320
    Height = 240
    Caption = 'Panel1'
    TabOrder = 0
  end
  object Timer: TTimer
    Interval = 10
    OnTimer = TimerTimer
    Left = 28
    Top = 16
  end
end
