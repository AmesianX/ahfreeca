object fmMain: TfmMain
  Left = 0
  Top = 0
  Caption = 'fmMain'
  ClientHeight = 562
  ClientWidth = 784
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
    Left = 544
    Top = 0
    Width = 240
    Height = 562
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 0
    inline frChat: TfrChat
      Left = 0
      Top = 260
      Width = 240
      Height = 302
      Align = alClient
      TabOrder = 0
      ExplicitTop = 260
      ExplicitWidth = 240
      ExplicitHeight = 302
      inherited moMsgIn: TMemo
        Width = 240
        Height = 281
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 240
        ExplicitHeight = 281
      end
      inherited edMsgOut: TEdit
        Top = 281
        Width = 240
        ExplicitLeft = 0
        ExplicitTop = 281
        ExplicitWidth = 240
      end
    end
    inline frVoice: TfrVoice
      Left = 0
      Top = 180
      Width = 240
      Height = 80
      Align = alTop
      TabOrder = 1
      ExplicitTop = 180
    end
    inline frCamPreview: TfrCamPreview
      Left = 0
      Top = 0
      Width = 240
      Height = 180
      Align = alTop
      Color = clBlack
      ParentBackground = False
      ParentColor = False
      TabOrder = 2
    end
  end
  inline frScreen: TfrScreen
    Left = 0
    Top = 0
    Width = 544
    Height = 562
    Align = alClient
    TabOrder = 1
    ExplicitWidth = 544
    ExplicitHeight = 562
    inherited Image: TImage
      Width = 544
      Height = 562
      ExplicitLeft = -2
      ExplicitTop = 0
      ExplicitWidth = 650
      ExplicitHeight = 634
    end
  end
end
