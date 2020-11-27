{******************************************************************************

              Copyright (C) 2008-2015 by Boian Mitov
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

interface

uses
  IGDIPlus, VCL.Graphics;

type
  TIGPBitmapHelper = class helper for TIGPBitmap
  public
    class function Create( ABitmap : TBitmap ) : IGPBitmap; overload;
    class function Create( AIcon : TIcon ) : IGPBitmap; overload;

  public
    constructor CreateObject( ABitmap : TBitmap ); overload;
    constructor CreateObject( AIcon : TIcon ); overload;

  end;
//---------------------------------------------------------------------------
  TIGPGraphicsHelper = class helper for TIGPGraphics
  public
    class function Create( canvas : TCanvas ) : IGPGraphics; overload;

  public
    constructor CreateObject( canvas : TCanvas ); overload;

  public
    class function FromCanvas( canvas : TCanvas ) : IGPGraphics; overload;

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
end.
