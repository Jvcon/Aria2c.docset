# ======= Main ======
# Load environment variables
if [ -f .env ]; then
    export $(cat .env | sed 's/#.*//g' | xargs)
fi

mode=$1

BASE_DIR=$(
    cd $(dirname $0)
    pwd
)

Output_DIR=$BASE_DIR/output
TAR_DIR=$DOCSET_DIR/Aria2c.docset
SRC=$BASE_DIR/aria2c.html

rm -rf $Output_DIR
mkdir $Output_DIR

# Initial

if ! [ -x "$(command -v go)" ]; then
    echo "Go is not installed"
    sudo apt install -y golang
fi

if ! [ -x "$(command -v curl)" ]; then
    echo "curl is not installed"
    sudo apt install -y curl
fi

go install github.com/technosophos/dashing@latest
if test -f "$SRC"; then
    rm aria2c.html
    curl 'https://raw.githubusercontent.com/aria2/aria2.github.io/master/manual/en/html/aria2c.html' -O aria2c.html
else
    curl 'https://raw.githubusercontent.com/aria2/aria2.github.io/master/manual/en/html/aria2c.html' -O aria2c.html
fi

dashing build

case "$mode" in
build)
    echo "Building a compress"
    tar -czf Aria2c.tgz Aria2c.docset
    mv Aria2c.tgz $Output_DIR
    ;;
test)
    if [ -d "$TAR_DIR" ]; then
        echo "The '$TAR_DIR' folder exists. Deleting..."
        # Delete the folder
        rm -r "$TAR_DIR"
    fi
    echo "Moving docset folder to test"
    mv -f Aria2c.docset $TAR_DIR
    ;;
all | "") ;;

*)
    echo "Invalid"
    exit 1
    ;;
esac
echo "Cleaning..."
git clean -fd
