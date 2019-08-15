{ stdenv, fetchurl, makeWrapper, jre, lib }:

stdenv.mkDerivation rec {
  version = "1.9.0";
  pname = "avro-tools";

  src = fetchurl {
    url =
    "https://repo1.maven.org/maven2/org/apache/avro/avro-tools/${version}/${pname}-${version}.jar";
    sha256 = "164mcz7ljd2ikwsq9ba98galcjar4g4n6ag7kkh466nwrpbmd2zi";
  };

  dontUnpack = true;

  buildInputs = [ jre ];
  nativeBuildInputs = [ makeWrapper ];
  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/libexec/avro-tools
    mv $src ${pname}-${version}.jar
    cp ${pname}-${version}.jar $out/libexec/avro-tools

    makeWrapper ${jre}/bin/java $out/bin/avro-tools \
    --add-flags "-jar $out/libexec/avro-tools/${pname}-${version}.jar"
  '';

  meta = with stdenv.lib; {
    homepage    = https://avro.apache.org/;
    description = "Avro command-line tools and utilities";
    license     = lib.licenses.asl20;
    maintainers = [ lib.maintainers.nequissimus ];
  };
}
