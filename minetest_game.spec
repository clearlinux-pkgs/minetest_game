Name     : minetest_game
Version  : 0351c6691595c6eb88a1bea2383f6fae46a686ce
Release  : 29
URL      : https://github.com/minetest/minetest_game/archive/0351c6691595c6eb88a1bea2383f6fae46a686ce/minetest_game-0351c6691595c6eb88a1bea2383f6fae46a686ce.tar.gz
Source0  : https://github.com/minetest/minetest_game/archive/0351c6691595c6eb88a1bea2383f6fae46a686ce/minetest_game-0351c6691595c6eb88a1bea2383f6fae46a686ce.tar.gz
Summary  : A Voxel Game

Group    : Development/Tools
License  : CC-BY-SA-2.0 LGPL-2.1

%description
The main game for the Minetest game engine [minetest_game]

%prep
%setup -q -n minetest_game-0351c6691595c6eb88a1bea2383f6fae46a686ce

%build

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/usr/share/luanti/games/minetest_game
cp -arv *.txt game.conf menu mods %{buildroot}/usr/share/luanti/games/minetest_game/

%files
%defattr(-,root,root,-)
/usr/share/luanti/games/minetest_game/*
