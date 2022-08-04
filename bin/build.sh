set -e

BLUE='\n\033[1;34m'
NC='\033[0m\n' # No Color

echo ${BLUE}"COMPILING GAME"${NC}
haxe compile.hxml
echo ${BLUE}"LAUNCING GAME"${NC}
hl build/Game.hl

# if [ $1 = "debug" ]; then

# elif [ $1 = "release" ]; then
#   echo ${BLUE}"COMPILING GAME"${NC}
#   haxe compile.hxml
#   echo ${BLUE}"LAUNCING GAME"${NC}
#   hl build/Game.hl
# fi