{******************************************************************************

              Copyright (C) 2008-2025 by Boian Mitov
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
unit VCL.IGDIPlusExt;

{$HPPEMIT NOUSINGNAMESPACE}

interface

uses
  IGDIPlus, VCL.Graphics;

type
  TIGPBitmapHelper = class helper for TIGPBitmap
  public
    class function  Make( ABitmap : TBitmap ) : IGPBitmap; overload; inline;
    class function  Make( AIcon : TIcon ) : IGPBitmap; overload; inline;

  public
    constructor CreateObject( ABitmap : TBitmap ); overload;
    constructor CreateObject( AIcon : TIcon ); overload;

  end;
//---------------------------------------------------------------------------
  TIGPVclBitmapHelper = class helper for TBitmap
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
  TIGPGraphicsHelper = class helper for TIGPGraphics
  public
    class function  Make( ACanvas : TCanvas ) : IGPGraphics; overload; inline;

  public
    constructor CreateObject( ACanvas : TCanvas ); overload;

  public
    class function FromCanvas( ACanvas : TCanvas ) : IGPGraphics; overload; inline;

  end;
//---------------------------------------------------------------------------
  TIGPVclCanvasHelper = class helper for TCanvas
  protected
    function  GetGraphics() : IGPGraphics; inline;
    function  GetGPFont() : IGPFont; inline;

  public
    function  ForGraphics( const AProc : TIGPConstProc<IGPGraphics> ) : TCanvas;

  public
    property Graphics : IGPGraphics read GetGraphics;
    property GPFont : IGPFont       read GetGPFont;

  end;
//---------------------------------------------------------------------------
  TIGPFontHelper = class helper for TIGPFont
  public
    class function  Make( ACanvas : TCanvas ) : IGPFont; overload; inline;
    class function  Make( AFont : TFont ) : IGPFont; overload; inline;

  public
    constructor CreateObject( ACanvas : TCanvas ); overload;
    constructor CreateObject( AFont : TFont ); overload;

  public
    class function FromCanvas( ACanvas : TCanvas ) : IGPFont; overload; inline;
    class function FromFont( AFont : TFont ) : IGPFont; overload; inline;

  end;
//---------------------------------------------------------------------------
  TIGPVclFontHelper = class helper for TFont
  protected
    function  GetGPFont() : IGPFont; inline;

  public
    property GPFont : IGPFont read GetGPFont;

  end;
//---------------------------------------------------------------------------
implementation

uses
  System.UITypes;
//---------------------------------------------------------------------------
constructor TIGPBitmapHelper.CreateObject( ABitmap : TBitmap );
begin
  CreateHBitmapObject( ABitmap.Handle, ABitmap.Palette );
end;
//---------------------------------------------------------------------------
constructor TIGPBitmapHelper.CreateObject( AIcon : TIcon );
begin
  CreateHICONObject( AIcon.Handle );
end;
//---------------------------------------------------------------------------
class function TIGPBitmapHelper.Make( ABitmap : TBitmap ) : IGPBitmap;
begin
  Result := CreateObject( ABitmap );
end;
//---------------------------------------------------------------------------
class function TIGPBitmapHelper.Make( AIcon : TIcon ) : IGPBitmap;
begin
  Result := CreateObject( AIcon );
end;
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
function TIGPVclBitmapHelper.GetGPBitmap() : IGPBitmap;
begin
  Result := TIGPBitmap.CreateObject( Self );
end;
//---------------------------------------------------------------------------
function TIGPVclBitmapHelper.GetGraphics() : IGPGraphics;
begin
  Result := TIGPGraphics.CreateObject( Canvas );
end;
//---------------------------------------------------------------------------
function TIGPVclBitmapHelper.ForGraphics( const AProc : TIGPConstProc<IGPGraphics> ) : TBitmap;
begin
  Assert( Assigned( AProc ));
  AProc( TIGPGraphics.CreateObject( Canvas ) );
  Result := Self;
end;
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
class function TIGPGraphicsHelper.FromCanvas( ACanvas : TCanvas ) : IGPGraphics;
begin
  Result := TIGPGraphics.CreateObject( ACanvas );
end;
//---------------------------------------------------------------------------
constructor TIGPGraphicsHelper.CreateObject( ACanvas : TCanvas );
begin
  CreateObject( ACanvas.Handle );
end;
//---------------------------------------------------------------------------
class function TIGPGraphicsHelper.Make( ACanvas : TCanvas ) : IGPGraphics;
begin
  Result := CreateObject( ACanvas );
end;
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
function TIGPVclCanvasHelper.GetGraphics() : IGPGraphics;
begin
  Result := TIGPGraphics.CreateObject( Self );
end;
//---------------------------------------------------------------------------
function TIGPVclCanvasHelper.GetGPFont() : IGPFont;
begin
  Result := TIGPFont.CreateObject( Handle );
end;
//---------------------------------------------------------------------------
function TIGPVclCanvasHelper.ForGraphics( const AProc : TIGPConstProc<IGPGraphics> ) : TCanvas;
begin
  Assert( Assigned( AProc ));
  AProc( TIGPGraphics.CreateObject( Self ) );
  Result := Self;
end;
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
constructor TIGPFontHelper.CreateObject( ACanvas : TCanvas );
begin
  CreateObject( ACanvas.Handle );
end;
//---------------------------------------------------------------------------
constructor TIGPFontHelper.CreateObject( AFont : TFont );
begin
  CreateObject( AFont.Name, AFont.Size, AFont.Style );
end;
//---------------------------------------------------------------------------
class function TIGPFontHelper.Make( ACanvas : TCanvas ) : IGPFont;
begin
  Result := CreateObject( ACanvas );
end;
//---------------------------------------------------------------------------
class function TIGPFontHelper.Make( AFont : TFont ) : IGPFont;
begin
  Result := CreateObject( AFont );
end;
//---------------------------------------------------------------------------
class function TIGPFontHelper.FromCanvas( ACanvas : TCanvas ) : IGPFont;
begin
  Result := CreateObject( ACanvas );
end;
//---------------------------------------------------------------------------
class function TIGPFontHelper.FromFont( AFont : TFont ) : IGPFont;
begin
  Result := CreateObject( AFont );
end;
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
function TIGPVclFontHelper.GetGPFont() : IGPFont;
begin
  Result := TIGPFont.CreateObject( Self );
end;
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
end.
