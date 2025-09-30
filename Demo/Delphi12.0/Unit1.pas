unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type
  TForm1 = class(TForm)
    procedure FormPaint(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  System.Types, System.UITypes, IGDIPlus, VCL.IGDIPlusExt;

{$R *.dfm}

procedure TForm1.FormPaint(Sender: TObject);
begin
  var AGraphics := TIGPGraphics.Make( Canvas );
  AGraphics.SmoothingMode := TIGPSmoothingMode.AntiAlias;
  AGraphics.TextRenderingHint := TIGPTextRenderingHint.AntiAlias;

  var ALeftTopCorner := TPointF.Create( 20, 20 );
  var AFont := TIGPFont.Make( 'Microsoft Sans Serif', 40, [ fsBold ] );
  var ARect := AGraphics.GetStringBoundingBoxF( 'Welcome to IGDI+', AFont, ALeftTopCorner );
  var ARect1 := ARect.Inflate( 10, 10 );

  // Draw a fancy rounded rectangle.
  AGraphics.DrawRoundRectangleF(
              TIGPPen.Make( TIGPLinearGradientBrush.Make( ARect1.Inflate( 2, 2 ), aclRed, aclBlue, TIGPLinearGradientMode.Vertical ), 4 ),
              TIGPPathGradientBrush.Make(
                  TIGPGraphicsPath.Make().AddRoundRectangleF( ARect1, TIGPSizeF.Create( 20, 20 ) )
                   )
                .SetInterpolationColorArrays( [ aclGreen, aclCyan, aclYellow ], [ 0, 0.3, 1 ] )
                .SetCenterPointF( TPointF.Create( 250, 50 ))
                .SetFocusScales( 0.87, 0.2 ),
              ARect1, TIGPSizeF.Create( 20, 20 ) );

  // Draw a text with semitransparent shadow.
  AGraphics.DrawStringF( 'Welcome to IGDI+',
                        AFont,
                        TPointF.Create( 23, 23 ),
                        TIGPSolidBrush.Make( MakeARGBColor( 50, aclBlack )) )

           .DrawStringF( 'Welcome to IGDI+',
                        AFont,
                        ALeftTopCorner,
                        TIGPLinearGradientBrush.Make( ARect, aclRed, aclBlue, TIGPLinearGradientMode.ForwardDiagonal ));


  // Draw a closed curve.
  AGraphics.DrawClosedCurveF( TIGPPen.Make( aclRed, 3 ), TIGPSolidBrush.Make( aclBlue ),
              [
                TPointF.Create( 60,  160 ),
                TPointF.Create( 150, 180 ),
                TPointF.Create( 200, 140 ),
                TPointF.Create( 180, 220 ),
                TPointF.Create( 120, 200 ),
                TPointF.Create( 80,  260 )
              ] );

  // Draw a semitransparent star.
  var APath := TIGPGraphicsPath.Make();
  APath.AddLinesF(
    [
      TPointF.Create( 75, 0 ),
      TPointF.Create( 100, 50 ),
      TPointF.Create( 150, 50 ),
      TPointF.Create( 112, 75 ),
      TPointF.Create( 150, 150 ),
      TPointF.Create( 75, 100 ),
      TPointF.Create( 0, 150 ),
      TPointF.Create( 37, 75 ),
      TPointF.Create( 0, 50 ),
      TPointF.Create( 50, 50 )
    ] );

  AGraphics.TranslateTransform( 420, 30 )
           .FillPath(
              TIGPPathGradientBrush.Make( APath )
                .SetCenterColor( MakeColor( 200, 255, 0, 0))
                .SetSurroundColors(
                  [
                    MakeColor(80, 0, 0, 0),
                    MakeColor(80, 0, 255, 0),
                    MakeColor(80, 0, 0, 255),
                    MakeColor(80, 255, 255, 255),
                    MakeColor(80, 0, 0, 0),
                    MakeColor(80, 0, 255, 0),
                    MakeColor(80, 0, 0, 255),
                    MakeColor(80, 255, 255, 255),
                    MakeColor(80, 0, 0, 0),
                    MakeColor(80, 0, 255, 0)
                  ] ),

              APath );

  // Draw rotated ellipse.
  AGraphics.ResetTransform()
           .TranslateTransform( 300, 160 )
           .RotateTransform( 30 )
           .DrawEllipseF(
              TIGPPen.Make( aclRed, 3 ),
              TIGPLinearGradientBrush.Make( TPointF.Create( 0, 0 ), TPointF.Create( 20, 20 ), aclYellow, aclGreen )
              .SetWrapMode( TIGPWrapMode.TileFlipX ),
              0, 0, 200, 80 );

end;

end.
