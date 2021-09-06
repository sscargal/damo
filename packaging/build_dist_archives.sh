#!/bin/bash

if [ $# -ne 2 ]
then
	echo "Usage: $0 <work dir> <version>"
	exit 1
fi

work_dir=$1
version=$2

if [ -d "$work_dir" ] || [ -f "$work_dir" ]
then
	echo "$work_dir already exist"
	exit 1
fi

mkdir "$work_dir"
bindir=$(dirname "$0")

for file in "setup.py" "pyproject.toml"
do
	cp "$bindir/$file" "$work_dir/"
done

"$bindir/mk_readme.sh" "$work_dir" "$version"

damo_dir="$bindir/.."

mkdir -p "$work_dir/src/damo"
cp "$damo_dir/"*.py "$work_dir/src/damo"
cp "$damo_dir/damo" "$work_dir/src/damo/damo.py"
touch "$work_dir/src/damo/__init__.py"

cd "$work_dir"
if python3 -m build
then
	echo
	echo "The distribution archives are ready at $work_dir/dist/"
	echo "You may upload it now via:"
	echo "    cd $work_dir && python3 -m twine upload dist/*"
fi