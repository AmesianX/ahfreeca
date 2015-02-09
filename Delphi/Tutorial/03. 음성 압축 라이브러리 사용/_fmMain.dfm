object fmMain: TfmMain
  Left = 0
  Top = 0
  Caption = 'Sample 03 - '#51020#49457' '#50517#52629' '#46972#51060#48652#47084#47532' '#49324#50857
  ClientHeight = 290
  ClientWidth = 554
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
  object lbInfo: TLabel
    Left = 8
    Top = 76
    Width = 28
    Height = 13
    Caption = 'lbInfo'
  end
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 173
    Height = 57
    BevelOuter = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 5
      Width = 62
      Height = 13
      Caption = 'Voice Record'
    end
    object btRecordStart: TButton
      Left = 8
      Top = 24
      Width = 75
      Height = 25
      Caption = 'Start'
      TabOrder = 0
      OnClick = btRecordStartClick
    end
    object btRecordStop: TButton
      Left = 89
      Top = 24
      Width = 75
      Height = 25
      Caption = 'Stop'
      TabOrder = 1
      OnClick = btRecordStopClick
    end
  end
end
