Name     : minetest_game
Version  : 5.0.0
Release  : 13
URL      : https://github.com/minetest/minetest_game/archive/5.0.0.tar.gz
Source0  : https://github.com/minetest/minetest_game/archive/5.0.0.tar.gz
Summary  : A Voxel Game

Group    : Development/Tools
License  : CC-BY-SA-2.0 LGPL-2.1

%description
The main game for the Minetest game engine [minetest_game]

%prep
%setup -q -n minetest_game-5.0.0

%build

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/usr/share/minetest/games/minetest_game
cp -arv *.txt game.conf menu mods %{buildroot}/usr/share/minetest/games/minetest_game/

%files
%defattr(-,root,root,-)
/usr/share/minetest/games/minetest_game/*
