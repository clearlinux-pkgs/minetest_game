Name     : minetest_game
Version  : d38b8e665723d90d2f3c73e26d2b00066451760d
Release  : 27
URL      : https://github.com/minetest/minetest_game/archive/d38b8e665723d90d2f3c73e26d2b00066451760d/minetest_game-d38b8e665723d90d2f3c73e26d2b00066451760d.tar.gz
Source0  : https://github.com/minetest/minetest_game/archive/d38b8e665723d90d2f3c73e26d2b00066451760d/minetest_game-d38b8e665723d90d2f3c73e26d2b00066451760d.tar.gz
Summary  : A Voxel Game

Group    : Development/Tools
License  : CC-BY-SA-2.0 LGPL-2.1

%description
The main game for the Minetest game engine [minetest_game]

%prep
%setup -q -n minetest_game-d38b8e665723d90d2f3c73e26d2b00066451760d

%build

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/usr/share/luanti/games/minetest_game
cp -arv *.txt game.conf menu mods %{buildroot}/usr/share/luanti/games/minetest_game/

%files
%defattr(-,root,root,-)
/usr/share/luanti/games/minetest_game/*
