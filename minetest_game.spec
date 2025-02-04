Name     : minetest_game
Version  : 672b63f9dcbfbd2e8cb46658f7e550c8f7eecf47
Release  : 26
URL      : https://github.com/minetest/minetest_game/archive/672b63f9dcbfbd2e8cb46658f7e550c8f7eecf47/minetest_game-672b63f9dcbfbd2e8cb46658f7e550c8f7eecf47.tar.gz
Source0  : https://github.com/minetest/minetest_game/archive/672b63f9dcbfbd2e8cb46658f7e550c8f7eecf47/minetest_game-672b63f9dcbfbd2e8cb46658f7e550c8f7eecf47.tar.gz
Summary  : A Voxel Game

Group    : Development/Tools
License  : CC-BY-SA-2.0 LGPL-2.1

%description
The main game for the Minetest game engine [minetest_game]

%prep
%setup -q -n minetest_game-672b63f9dcbfbd2e8cb46658f7e550c8f7eecf47

%build

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/usr/share/luanti/games/minetest_game
cp -arv *.txt game.conf menu mods %{buildroot}/usr/share/luanti/games/minetest_game/

%files
%defattr(-,root,root,-)
/usr/share/luanti/games/minetest_game/*
