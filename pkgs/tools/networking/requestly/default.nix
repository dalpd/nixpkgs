{ lib
, appimageTools
, fetchurl
}:

let
  pname = "requestly";
  version = "1.5.13";

  src = fetchurl {
    url = "https://github.com/requestly/requestly-desktop-app/releases/download/v${version}/Requestly-${version}.AppImage";
    hash = "sha256-DSOZBVBjIYO8BG3o7AUsH7h2KvSPlp9Lj9d3OwvBhfQ=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    mv $out/bin/${pname}-${version} $out/bin/${pname}

    install -Dm 444 ${appimageContents}/${pname}.desktop -t $out/share/applications
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "Intercept & Modify HTTP Requests";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    homepage = "https://requestly.io";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ dit7ya ];
  };
}
