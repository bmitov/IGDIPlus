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
  IGDIPlus, VCL.Graphics, Mitov.Containers.Common;

type
  TIGPBitmapHelper = class helper for TIGPBitmap
  public
    class function Create( ABitmap : TBitmap ) : IGPBitmap; overload; inline;
    class function Create( AIcon : TIcon ) : IGPBitmap; overload; inline;

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
    function  ForGraphics( const AProc : TConstProc<IGPGraphics> ) : TBitmap;

  public
    property GPBitmap : IGPBitmap   read GetGPBitmap;
    property Graphics : IGPGraphics read GetGraphics;

  end;
//---------------------------------------------------------------------------
  TIGPGraphicsHelper = class helper for TIGPGraphics
  public
    class function Create( canvas : TCanvas ) : IGPGraphics; overload; inline;

  public
    constructor CreateObject( canvas : TCanvas ); overload;

  public
    class function FromCanvas( canvas : TCanvas ) : IGPGraphics; overload; inline;

  end;
//---------------------------------------------------------------------------
  TIGPVclCanvasHelper = class helper for TCanvas
  protected
    function  GetGraphics() : IGPGraphics; inline;

  public
    function  ForGraphics( const AProc : TConstProc<IGPGraphics> ) : TCanvas;

  public
    property Graphics : IGPGraphics read GetGraphics;

  end;
//---------------------------------------------------------------------------
implementation
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
class function TIGPBitmapHelper.Create( ABitmap : TBitmap ) : IGPBitmap;
begin
  Result := CreateObject( ABitmap );
end;
//---------------------------------------------------------------------------
class function TIGPBitmapHelper.Create( AIcon : TIcon ) : IGPBitmap;
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
function TIGPVclBitmapHelper.ForGraphics( const AProc : TConstProc<IGPGraphics> ) : TBitmap;
begin
  Assert( Assigned( AProc ));
  AProc( TIGPGraphics.CreateObject( Canvas ) );
  Result := Self;
end;
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
class function TIGPGraphicsHelper.FromCanvas( canvas : TCanvas ) : IGPGraphics;
begin
  Result := TIGPGraphics.Create(canvas);
end;
//---------------------------------------------------------------------------
constructor TIGPGraphicsHelper.CreateObject( canvas : TCanvas );
begin
  CreateObject( canvas.Handle );
end;
//---------------------------------------------------------------------------
class function TIGPGraphicsHelper.Create( canvas : TCanvas ) : IGPGraphics;
begin
  Result := CreateObject( canvas );
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
function TIGPVclCanvasHelper.ForGraphics( const AProc : TConstProc<IGPGraphics> ) : TCanvas;
begin
  Assert( Assigned( AProc ));
  AProc( TIGPGraphics.CreateObject( Self ) );
  Result := Self;
end;
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
end.
