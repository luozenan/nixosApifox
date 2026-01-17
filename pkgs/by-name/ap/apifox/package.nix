# pkgs/by-name/ap/apifox/package.nix（完全对齐微信写法）
{ pkgs, lib, ... }:

let
  pname = "apifox";
  version = "latest";
  # 1. 下载包含AppImage的zip包
  zipSrc = pkgs.fetchzip {
    url = "https://file-assets.apifox.com/download/Apifox-linux-latest.zip";
    sha256 = "sha256-oy5egwI/MM/SsmqZIBg5WPHIrqfNN6FzbBr18Szr5yc="; # 替换为实际hash
    stripRoot = false; # 保留zip内的原始目录
  };

  # 2. 从zip中提取AppImage文件（过滤出.AppImage后缀）
  appimageSrc = builtins.path {
    path = "${zipSrc}/Apifox.AppImage"; # 替换为实际AppImage文件名
    name = "Apifox.AppImage";
  };

  # 3. 解压AppImage（和微信的appimageContents逻辑一致）
  appimageContents = pkgs.appimageTools.extract {
    inherit pname version ;
    src=appimageSrc;
    # 可选：修复依赖（参考微信的patchelf操作）
    postExtract = ''
      patchelf --replace-needed libtiff.so.5 libtiff.so $out/opt/apifox/apifox || true
    '';
  };

in
# 4. 核心：使用wrapAppImage（和微信的wrapAppImage完全一致）
pkgs.appimageTools.wrapAppImage {
  inherit pname version;
  src = appimageContents; # 传入解压后的AppImage内容
  meta = with lib; {
    description = "API调试、测试、文档一体化工具";
    homepage = "https://www.apifox.cn/";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };

  # 5. 关键：和微信一样用extraInstallCommands（追加安装操作）
  extraInstallCommands = ''
    # 复制桌面文件（和微信的cp wechat.desktop逻辑一致）
    mkdir -p $out/share/applications
    cp ${appimageContents}/apifox.desktop $out/share/applications/

    # 复制图标（和微信的cp wechat.png逻辑一致，仅尺寸不同）
    mkdir -p $out/share/icons/hicolor/256x256/apps
    cp ${appimageContents}/usr/share/icons/hicolor/256x256/apps/apifox.png $out/share/icons/hicolor/256x256/apps/

    # 替换Exec字段（和微信的--replace-fail AppRun wechat逻辑一致）
    substituteInPlace $out/share/applications/apifox.desktop --replace-fail AppRun apifox
  '';

}
