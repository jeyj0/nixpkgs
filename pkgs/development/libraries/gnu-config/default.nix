{ stdenv, fetchurl }:

let
  rev = "a8d79c3130da83c7cacd6fee31b9acc53799c406";

  # Don't use fetchgit as this is needed during Aarch64 bootstrapping
  configGuess = fetchurl {
    url = "https://git.savannah.gnu.org/cgit/config.git/plain/config.guess?id=${rev}";
    sha256 = "0qbq49gr2cmf4gzrjvrmpwxxgzl3vap1xm902xa8pkcqdvriq0qw";
  };
  configSub = fetchurl {
    url = "https://git.savannah.gnu.org/cgit/config.git/plain/config.sub?id=${rev}";
    sha256 = "0i699axqfkxk9mgv1hlms5r44pf0s642yz75ajjjpwzhw4d5pnv4";
  };
in
stdenv.mkDerivation rec {
  pname = "gnu-config";
  version = "2019-04-15";

  buildCommand = ''
    mkdir -p $out
    cp ${configGuess} $out/config.guess
    cp ${configSub} $out/config.sub
  '';

  meta = with stdenv.lib; {
    description = "Attempt to guess a canonical system name";
    homepage = https://savannah.gnu.org/projects/config;
    license = licenses.gpl3;
    # In addition to GPLv3:
    #   As a special exception to the GNU General Public License, if you
    #   distribute this file as part of a program that contains a
    #   configuration script generated by Autoconf, you may include it under
    #   the same distribution terms that you use for the rest of that
    #   program.
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.all;
  };
}
