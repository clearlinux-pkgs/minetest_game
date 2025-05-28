Name     : minetest_game
Version  : a6bf9dd526e51b25f1ca08d6d214c5e8442b503b
Release  : 28
URL      : https://github.com/minetest/minetest_game/archive/a6bf9dd526e51b25f1ca08d6d214c5e8442b503b/minetest_game-a6bf9dd526e51b25f1ca08d6d214c5e8442b503b.tar.gz
Source0  : https://github.com/minetest/minetest_game/archive/a6bf9dd526e51b25f1ca08d6d214c5e8442b503b/minetest_game-a6bf9dd526e51b25f1ca08d6d214c5e8442b503b.tar.gz
Summary  : A Voxel Game

Group    : Development/Tools
License  : CC-BY-SA-2.0 LGPL-2.1

%description
The main game for the Minetest game engine [minetest_game]

%prep
%setup -q -n minetest_game-a6bf9dd526e51b25f1ca08d6d214c5e8442b503b

%build

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/usr/share/luanti/games/minetest_game
cp -arv *.txt game.conf menu mods %{buildroot}/usr/share/luanti/games/minetest_game/

%files
%defattr(-,root,root,-)
/usr/share/luanti/games/minetest_game/*
