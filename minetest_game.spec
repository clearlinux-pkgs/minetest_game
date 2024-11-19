Name     : minetest_game
Version  : c7be7c165fa3e8e20ec0569da3b19682feb0c72a
Release  : 25
URL      : https://github.com/minetest/minetest_game/archive/c7be7c165fa3e8e20ec0569da3b19682feb0c72a/minetest_game-c7be7c165fa3e8e20ec0569da3b19682feb0c72a.tar.gz
Source0  : https://github.com/minetest/minetest_game/archive/c7be7c165fa3e8e20ec0569da3b19682feb0c72a/minetest_game-c7be7c165fa3e8e20ec0569da3b19682feb0c72a.tar.gz
Summary  : A Voxel Game

Group    : Development/Tools
License  : CC-BY-SA-2.0 LGPL-2.1

%description
The main game for the Minetest game engine [minetest_game]

%prep
%setup -q -n minetest_game-c7be7c165fa3e8e20ec0569da3b19682feb0c72a

%build

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/usr/share/luanti/games/minetest_game
cp -arv *.txt game.conf menu mods %{buildroot}/usr/share/luanti/games/minetest_game/

%files
%defattr(-,root,root,-)
/usr/share/luanti/games/minetest_game/*
