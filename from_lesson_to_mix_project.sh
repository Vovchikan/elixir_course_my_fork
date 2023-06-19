script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

echo $script_dir
LESSON_DIR=$1
echo "lesson dir: $LESSON_DIR"
echo "result = $([ ! -d $LESSON_DIR ])"

# Check empty args
if [ $# -eq 0 ]
then
  echo "No arguments supplied"
  exit 1
fi

# Check if folder exists
if [ ! -d $LESSON_DIR ]
then
  echo "Folder - $LESSON_DIR doesn't exist !!!"
  exit 1
fi

echo "Creating backup for $LESSON_DIR"
BACKUP_LESSON="/tmp/$LESSON_DIR-$(date +%Y%m%d%H%M%S).backup"
cp -r $LESSON_DIR $BACKUP_LESSON

# Check if cp wasn't successed
if [ $? -ne 0 ]
then
    echo "FAILED Creating backup - $BACKUP_LESSON"
    exit 1
fi
echo "Backup created in $BACKUP_LESSON"

cd $LESSON_DIR
mv lib tmp_lib
cd ..
yes | mix new $LESSON_DIR; cd $LESSON_DIR
mv -v tmp_lib/*_test.exs ./test
mv -v tmp_lib/* lib/; rm -rfv tmp_lib
mkdir config; echo "import Config" >> config/config.exs
