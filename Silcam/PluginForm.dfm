object MainForm: TMainForm
  Left = 200
  Top = 121
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'MMB PlugIn Form'
  ClientHeight = 109
  ClientWidth = 201
  Color = clWhite
  DefaultMonitor = dmPrimary
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poDefault
  PixelsPerInch = 96
  TextHeight = 13
  object VideoGrabber1: TVideoGrabber
    Left = 0
    Top = 0
    Width = 201
    Height = 109
    Align = alClient
    FullRepaint = False
    AutoFilePrefix = 'vg'
    BorderStyle = bsNone
    DualDisplay_Left = 400
    DualDisplay_Top = 20
    Cropping_Zoom = 1.000000000000000000
    MotionDetector_Grid = 
      '5555555555 5555555555 5555555555 5555555555 5555555555 555555555' +
      '5 5555555555 5555555555 5555555555 5555555555 '
    PlayerSpeedRatio = 1.000000000000000000
    Reencoding_StartTime = -1
    Reencoding_StartFrame = -1
    Reencoding_StopTime = -1
    Reencoding_StopFrame = -1
    TextOverlay_Font.Charset = DEFAULT_CHARSET
    TextOverlay_Font.Color = clAqua
    TextOverlay_Font.Height = -16
    TextOverlay_Font.Name = 'MS Sans Serif'
    TextOverlay_Font.Style = []
    TextOverlay_String = 
      'Example of static text (TextOverlay_Selector=0). Set TextOverlay' +
      '_Selector=1 to see a demo with variables.'
    VideoCompression_Quality = 1.000000000000000000
    VideoFromImages_TemporaryFile = 'SetOfBitmaps01.dat'
    VideoProcessing_RotationCustomAngle = 45.500000000000000000
    VideoSource_FileOrURL_StartTime = -1
    VideoSource_FileOrURL_StopTime = -1
  end
end
