object fmMain: TfmMain
  Left = 0
  Top = 0
  Caption = 'fmMain'
  ClientHeight = 634
  ClientWidth = 890
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 650
    Top = 0
    Width = 240
    Height = 634
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitLeft = 300
    ExplicitTop = 272
    ExplicitHeight = 41
    inline frChat: TfrChat
      Left = 0
      Top = 80
      Width = 240
      Height = 554
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 576
      ExplicitHeight = 634
      inherited moMsgIn: TMemo
        Width = 240
        Height = 533
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 314
        ExplicitHeight = 613
      end
      inherited edMsgOut: TEdit
        Top = 533
        Width = 240
        ExplicitLeft = 0
        ExplicitTop = 613
        ExplicitWidth = 314
      end
    end
    inline frVoice: TfrVoice
      Left = 0
      Top = 0
      Width = 240
      Height = 80
      Align = alTop
      TabOrder = 1
      ExplicitWidth = 240
      ExplicitHeight = 80
    end
  end
end
