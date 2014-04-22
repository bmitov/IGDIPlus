unit VCL.IGDIPlusExt;

interface

uses
  IGDIPlus, VCL.Graphics;

type
  TIGPBitmapHelper = class helper for TIGPBitmap
  public
    constructor Create( ABitmap : TBitmap ); overload;
    constructor Create( AIcon : TIcon ); overload;

  end;

  TIGPGraphicsHelper = class helper for TIGPGraphics
  public
    constructor Create( canvas : TCanvas ); overload;

  public
    class function FromCanvas( canvas : TCanvas ) : TIGPGraphics; overload;

  end;

implementation

constructor TIGPBitmapHelper.Create( ABitmap : TBitmap );
begin
  CreateHBitmap( ABitmap.Handle, ABitmap.Palette );
end;

constructor TIGPBitmapHelper.Create( AIcon : TIcon );
begin
  CreateHICON( AIcon.Handle );
end;

class function TIGPGraphicsHelper.FromCanvas( canvas : TCanvas ) : TIGPGraphics;
begin
  Result := TIGPGraphics.Create(canvas);
end;

constructor TIGPGraphicsHelper.Create( canvas : TCanvas );
begin
  Create( canvas.Handle );
end;

end.
