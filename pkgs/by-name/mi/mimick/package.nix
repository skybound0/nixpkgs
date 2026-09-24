{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  cairo,
  gdk-pixbuf,
  glib,
  gtk4,
  libadwaita,
  libheif,
  libjpeg_turbo,
  openssl,
  pango,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mimick";
  version = "9.9.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "nicx17";
    repo = "mimick";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qutSW/fXNmy5WxD3wEiu8iDVlBVXsaW/wWP1Sm4wLRE=";
  };

  cargoHash = "sha256-Ah22wRkKlrZChG5B/tIzVm21NHhIJ+dY7Q5XCpvHsd4=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    cairo
    gdk-pixbuf
    glib
    gtk4
    libadwaita
    libheif
    libjpeg_turbo
    openssl
    pango
  ];
  
  env = {
    TURBOJPEG_SOURCE = "explicit";
    TURBOJPEG_LIB_DIR = "${lib.getLib libjpeg_turbo}/lib";
    TURBOJPEG_INCLUDE_DIR = "${lib.getDev libjpeg_turbo}/include";
    TURBOJPEG_DYNAMIC = "1";
  };

  passthru.updateScript = nix-update-script { };
  
  postInstall = ''
    install -Dm644 setup/dev.nicx.mimick.desktop -t $out/share/applications
    install -Dm644 setup/icons/mimick.svg -t $out/share/icons/hicolor/scalable/apps
    install -Dm644 setup/metainfo/dev.nicx.mimick.metainfo.xml -t $out/share/metainfo
  '';

  meta = {
    description = "Immich client with background sync, library browser, and album sync";
    homepage = "https://github.com/nicx17/mimick";
    changelog = "https://github.com/nicx17/mimick/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "mimick";
  };
})
