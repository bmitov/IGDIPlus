{******************************************************************************

              Copyright (C) 2008-2025 by Mitov Software
              mitov@mitov.com
              www.mitov.com
              www.igdiplus.org
              www.openwire.org

              This software is provided 'as-is', without any express or
              implied warranty.  In no event will the author be held liable
              for any  damages arising from the use of this software.

              Permission is granted to anyone to use this software for any
              purpose, including commercial applications, and to alter it
              and redistribute it freely, subject to the following
              restrictions:

              1. The origin of this software must not be misrepresented,
                 you must not claim that you wrote the original software.
                 If you use this software in a product, an acknowledgment
                 in the product documentation would be appreciated but is
                 not required.

              2. Altered source versions must be plainly marked as such, and
                 must not be misrepresented as being the original software.

              3. This notice may not be removed or altered from any source
                 distribution.

******************************************************************************}

unit FMX.IGDIPlusExt;

{$ALIGN ON}
{$MINENUMSIZE 4}

{$IFNDEF VER130}
{$IFNDEF VER140}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_CAST OFF}
{$ENDIF}
{$ENDIF}

interface

uses
  FMX.Graphics, System.Classes, System.SysUtils, IGDIPlus;

// VCL.IGDIPlusExt needs to be in implementation to allow C++ Builder linking!

type
  TIGPFMXBitmap = class( TIGPBitmap )
  public
    class function  Make( ABitmap : TBitmap ) : IGPBitmap; inline;

  public
    constructor CreateObject( ABitmap : TBitmap );

  end;
//---------------------------------------------------------------------------
  TIGPFMXBitmapHelper = class helper for TBitmap
  protected
    function  GetGPBitmap() : IGPBitmap; inline;
    function  GetGraphics() : IGPGraphics; inline;

  public
    function  ForGraphics( const AProc : TIGPConstProc<IGPGraphics> ) : TBitmap;

  public
    property GPBitmap : IGPBitmap   read GetGPBitmap;
    property Graphics : IGPGraphics read GetGraphics;

  end;
//---------------------------------------------------------------------------
  TIGPFMXGraphics = class( TIGPGraphics )
  protected
    FBitmap : IGPBitmap;
    FCanvas : TCanvas;

  public
    class function  Make( ACanvas : TCanvas ) : IGPGraphics; inline;

  public
    constructor CreateObject( ACanvas : TCanvas );
    destructor  Destroy(); override;

  end;
//---------------------------------------------------------------------------
  TIGPFMXCanvasHelper = class helper for TCanvas
  protected
    function  GetGraphics() : IGPGraphics; inline;

  public
    function  ForGraphics( const AProc : TIGPConstProc<IGPGraphics> ) : TCanvas;

  public
    property Graphics : IGPGraphics read GetGraphics;

  end;
//---------------------------------------------------------------------------
implementation

uses
{$IFDEF MSWINDOWS}
  Winapi.Windows,
{$ENDIF}
  System.Types, System.UITypes;

type
  TFMXBitmap = FMX.Graphics.TBitmap;

//---------------------------------------------------------------------------
procedure CopyC4R( pSrc : PByte;
                         srcStep: Integer;
                         pDst: PByte;
                         dstStep: Integer;
                         roiSize: TSize);
begin
  for var Y : Integer := 0 to roiSize.cy - 1 do
    begin
    Move( pSrc^, pDst^, roiSize.cx * 4 );
    Inc( pSrc, srcStep );
    Inc( pDst, dstStep );
    end;

end;
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
constructor TIGPFMXBitmap.CreateObject( ABitmap : TFMXBitmap );
begin
  var ASize := TSize.Create( ABitmap.Width, ABitmap.Height );
  inherited CreateObject( ASize.cx, ASize.cy );
{$IFDEF MSWINDOWS}
  var AInstanceHolder := ForLockBits( TIGPRect.Create( ASize ), [ TIGPImageLockMode.Read ], GPPixelFormat32bppARGB,
      procedure( const AGPBitmapData : IGPBitmapData )
      begin
        var ABitmapData : TBitmapData;

        ABitmap.Map( TMapAccess.Read, ABitmapData );

        CopyC4R( PByte( ABitmapData.Data ), ABitmapData.Pitch, AGPBitmapData.Scan0, AGPBitmapData.Stride, ASize );
        ABitmap.Unmap( ABitmapData );
      end
    );

{$ENDIF}
end;
//---------------------------------------------------------------------------
class function TIGPFMXBitmap.Make( ABitmap : TFMXBitmap ) : IGPBitmap;
begin
  Result := CreateObject( ABitmap );
end;
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
function TIGPFMXBitmapHelper.GetGPBitmap() : IGPBitmap;
begin
  Result := TIGPFMXBitmap.CreateObject( Self );
end;
//---------------------------------------------------------------------------
function TIGPFMXBitmapHelper.GetGraphics() : IGPGraphics;
begin
  Result := TIGPFMXGraphics.CreateObject( Canvas );
end;
//---------------------------------------------------------------------------
function TIGPFMXBitmapHelper.ForGraphics( const AProc : TIGPConstProc<IGPGraphics> ) : FMX.Graphics.TBitmap;
begin
  Assert( Assigned( AProc ));
  AProc( TIGPFMXGraphics.CreateObject( Canvas ) );
  Result := Self;
end;
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
constructor TIGPFMXGraphics.CreateObject( ACanvas : TCanvas );
begin
{$IFDEF MSWINDOWS}
{$IF CompilerVersion >= 37} // Delphi RX 13.0
  FBitmap := TIGPBitmap.CreateObject( Round( ACanvas.Width ), Round( ACanvas.Height ));
{$ELSE}
  FBitmap := TIGPBitmap.CreateObject( ACanvas.Width, ACanvas.Height );
{$ENDIF}
  inherited CreateObject( FBitmap );
{$ELSE}
  inherited CreateObject();
{$ENDIF}
  FCanvas := ACanvas;
end;
//---------------------------------------------------------------------------
destructor TIGPFMXGraphics.Destroy();
begin
{$IFDEF MSWINDOWS}
{$IF CompilerVersion >= 37} // Delphi RX 13.0
  var ASize := TSize.Create( Round( FCanvas.Width ), Round( FCanvas.Height ));
{$ELSE}
  var ASize := TSize.Create( FCanvas.Width, FCanvas.Height );
{$ENDIF}
  var ABitmap := TFMXBitmap.Create( ASize.cx, ASize.cy ); // Do not use Smart Pointer to remove IGDI+ Mitov.Runtime dependencies!
  try
    FBitmap.ForLockBits( TIGPRect.Create( ASize ), [ TIGPImageLockMode.Read ], GPPixelFormat32bppARGB,
        procedure( const ABitmapData : IGPBitmapData )
        begin
          var AFMXBitmapData : TBitmapData;
          ABitmap.Map( TMapAccess.Write, AFMXBitmapData );
          try
            CopyC4R( ABitmapData.Scan0, ABitmapData.Stride, PByte( AFMXBitmapData.Data ), AFMXBitmapData.Pitch, ASize );
          finally
            ABitmap.Unmap( AFMXBitmapData );
            end;

        end
      );

    FCanvas.BeginScene();
    try
      FCanvas.DrawBitmap( ABitmap, TRectF.Create( 0, 0, ASize.cx, ASize.cy ), TRectF.Create( 0, 0, ASize.cx, ASize.cy ), 1 );
    finally
      FCanvas.EndScene();
      end;

  finally
{$IF CompilerVersion >= 36} // Delphi RX 12.0
      ABitmap.Free();
{$ELSE}
      ABitmap.DisposeOf();
{$ENDIF}
    end;

{$ENDIF}
  inherited;
end;
//---------------------------------------------------------------------------
class function TIGPFMXGraphics.Make( ACanvas : TCanvas ) : IGPGraphics;
begin
  Result := CreateObject( ACanvas );
end;
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
function TIGPFMXCanvasHelper.GetGraphics() : IGPGraphics;
begin
  Result := TIGPFMXGraphics.CreateObject( Self );
end;
//---------------------------------------------------------------------------
function TIGPFMXCanvasHelper.ForGraphics( const AProc : TIGPConstProc<IGPGraphics> ) : TCanvas;
begin
  Assert( Assigned( AProc ));
  AProc( TIGPFMXGraphics.CreateObject( Self ) );
  Result := Self;
end;
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
end.


