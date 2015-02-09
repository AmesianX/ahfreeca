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
  inline frChat: TfrChat
    Left = 576
    Top = 0
    Width = 314
    Height = 634
    Align = alRight
    TabOrder = 0
    ExplicitLeft = 576
    ExplicitTop = 160
    inherited moMsgIn: TMemo
      Height = 613
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 314
      ExplicitHeight = 453
    end
    inherited edMsgOut: TEdit
      Top = 613
      ExplicitLeft = 0
      ExplicitTop = 453
      ExplicitWidth = 314
    end
  end
end
