Name     : minetest_game
Version  : 093cd28a279f42592a53762e2a8452f29b2a31ba
Release  : 23
URL      : https://github.com/minetest/minetest_game/archive/093cd28a279f42592a53762e2a8452f29b2a31ba/minetest_game-093cd28a279f42592a53762e2a8452f29b2a31ba.tar.gz
Source0  : https://github.com/minetest/minetest_game/archive/093cd28a279f42592a53762e2a8452f29b2a31ba/minetest_game-093cd28a279f42592a53762e2a8452f29b2a31ba.tar.gz
Summary  : A Voxel Game

Group    : Development/Tools
License  : CC-BY-SA-2.0 LGPL-2.1

%description
The main game for the Minetest game engine [minetest_game]

%prep
%setup -q -n minetest_game-093cd28a279f42592a53762e2a8452f29b2a31ba

%build

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/usr/share/luanti/games/minetest_game
cp -arv *.txt game.conf menu mods %{buildroot}/usr/share/luanti/games/minetest_game/

%files
%defattr(-,root,root,-)
/usr/share/luanti/games/minetest_game/*
